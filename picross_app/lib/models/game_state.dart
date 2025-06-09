import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart'; // para BuildContext
import 'package:picross_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/time_service.dart';
import 'package:http/http.dart' as http;
// Importa el archivo generado de localización (ajusta el import según tu proyecto)
import 'package:picross_app/l10n/app_localizations.dart';

enum CellState { empty, filled, marked }
enum InteractionMode { fill, mark }

class GameState extends ChangeNotifier {
  final String baseUrl = ApiConfig.baseUrl;
  final int _size;
  final List<List<int>> _solution;
  late List<List<CellState>> _cellStates;
  late List<bool> _completedRows = [];
  late List<bool> _completedCols = [];

  InteractionMode _mode = InteractionMode.fill;

  Timer? _timer;
  int _currentTime = 0;
  int? _bestTime;
  bool _isCompleted = false;
  String _message = "";
  int? _points;

  final BuildContext context; // Necesario para obtener localizaciones

  GameState(this._size, this._solution, this.context) {
    //TODO: eliminar esta linea cuando se vaya a hacer el release
    print(_solution); //! Esta linea se usa para mostrar la solución en el modo debug

    testApiConnection();

    _cellStates = List.generate(
      _size,
      (_) => List.generate(_size, (_) => CellState.empty),
    );

    _completedRows = List.filled(_size, false);
    _completedCols = List.filled(_size, false);

    _loadBestTime();
    _startTimer();
  }

  // Helper para obtener texto localizado
  String getLocalizedString(String key, [Map<String, String>? params]) {
    final localizations = AppLocalizations.of(context)!;
    switch (key) {
      case 'game_lost':
        return localizations.game_lost;
      case 'game_won':
        return localizations.game_won;
      case 'score_saved_success':
        return localizations.score_saved_success;
      case 'score_save_error':
        return localizations.score_save_error(params?['errorBody'] ?? '');
      case 'connection_success':
        return localizations.connection_success(params?['responseBody'] ?? '');
      case 'connection_error_code':
        return localizations.connection_error_code(params?['statusCode'] ?? '');
      case 'connection_error':
        return localizations.connection_error(params?['error'] ?? '');
      default:
        return key; // fallback
    }
  }

  // Getters públicos
  int get size => _size;
  int? get points => _points;
  String? get message => _message;
  String? get currentTimeFormatted => _formatTime(_currentTime);
  String? get bestTimeFormatted =>
      _bestTime != null ? _formatTime(_bestTime!) : null;
  InteractionMode get mode => _mode;
  List<bool> get completedRows => _completedRows;
  List<bool> get completedCols => _completedCols;

  CellState getCellState(int row, int col) => _cellStates[row][col];

  void toggleCell(int row, int col) {
    if (_isCompleted) return; // No cambiar si ya completado

    if (_cellStates[row][col] != CellState.empty) return;

    if (_mode == InteractionMode.fill) {
      _cellStates[row][col] = CellState.filled;
    } else {
      _cellStates[row][col] = CellState.marked;
    }

    _checkLinesCompletion();
    _updateCompletedLines();
    _checkCompletion();
    notifyListeners();
  }

  void toggleMode() {
    _mode =
        _mode == InteractionMode.fill ? InteractionMode.mark : InteractionMode.fill;
    notifyListeners();
  }

  Future<void> _checkCompletion() async {
    // Verificamos que todas las casillas que deben estar rellenas están rellenas correctamente
    for (int row = 0; row < _size; row++) {
      for (int col = 0; col < _size; col++) {
        if (_solution[row][col] == 1) {
          if (_cellStates[row][col] == CellState.empty) {
            // Alguna casilla que debería estar rellena no lo está, seguimos jugando
            return;
          }
        }
      }
    }

    // Aquí todas las casillas que deben estar rellenas están rellenas

    // Comprobamos si hay errores en esas casillas (por ejemplo, que alguna esté marcada en vez de rellenada)
    int errors = 0;
    for (int row = 0; row < _size; row++) {
      for (int col = 0; col < _size; col++) {
        if (_solution[row][col] == 1 &&
            _cellStates[row][col] != CellState.filled) {
          errors++;
        } else if (_solution[row][col] == 0 &&
            _cellStates[row][col] == CellState.filled) {
          errors++;
        }
      }
    }

    _isCompleted = true;
    _timer?.cancel();

    if (errors > 0) {
      _message = getLocalizedString('game_lost'); // "¡Has perdido!"
    } else {
      if (_bestTime == null || _currentTime < _bestTime!) {
        _bestTime = _currentTime;
        _saveBestTime();
      }
      _message = getLocalizedString('game_won'); // "¡Has ganado!"
    }

    // ✅ Enviar puntuación al servidor
    final seed = base64Encode(utf8.encode(jsonEncode(_solution))); // Genera un ID simple
    final completionTime = _currentTime;
    final errorsCount = errors;
    final width = _size;
    final height = _size;
    final points = _calculatePoints(completionTime, errorsCount, _size);
    _points = points;

    await _submitScore(
      seed: seed,
      completionTime: completionTime,
      errorsCount: errorsCount,
      width: width,
      height: height,
      points: points,
    );

    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _currentTime = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isCompleted) {
        _currentTime++;
        notifyListeners();
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> testApiConnection() async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(getLocalizedString('connection_success', {'responseBody': response.body}));
      } else {
        print(getLocalizedString('connection_error_code', {'statusCode': response.statusCode.toString()}));
      }
    } catch (e) {
      print(getLocalizedString('connection_error', {'error': e.toString()}));
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _saveBestTime() async {
    // guardar localmente
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final currentTime = _currentTime;
    final key = 'best_time_$size'; 
    final bestTime = prefs.getInt(key);

    if (bestTime == null || currentTime < bestTime) {
      await prefs.setInt(key, currentTime);
    }

    // guardar en API
    final timeService = TimeService();
    await timeService.saveTime(size, currentTime);
  }

  Future<void> _loadBestTime() async {
    final prefs = await SharedPreferences.getInstance();
    _bestTime = prefs.getInt('best_time_$_size'); 
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Metodo para borrar todos los tiempos (debug)
  Future<void> clearAllBestTimes() async {
    final prefs = await SharedPreferences.getInstance();
    // Supongamos que los tamaños usados son 5, 10, 15, 20
    final sizes = [5, 10, 15, 20];

    for (var s in sizes) {
      await prefs.remove('best_time_$s');
    }

    _bestTime = null; // Limpiar el mejor tiempo actual en esta instancia
    notifyListeners();
  }

  void _checkLinesCompletion() {
    // Revisa filas
    for (int row = 0; row < _size; row++) {
      bool rowCorrect = true;
      for (int col = 0; col < _size; col++) {
        if (_cellStates[row][col] == CellState.empty) {
          rowCorrect = false;
          break;
        }
      }
      completedRows[row] = rowCorrect;
    }

    // Revisa columnas
    for (int col = 0; col < _size; col++) {
      bool colCorrect = true;
      for (int row = 0; row < _size; row++) {
        if (_cellStates[row][col] == CellState.empty) {
          colCorrect = false;
          break;
        }
      }
      completedCols[col] = colCorrect;
    }

    notifyListeners();
  }

  bool isWrongFilled(int row, int col, List<List<int>> solution) {
    return _cellStates[row][col] == CellState.filled && solution[row][col] == 0;
  }

  bool isWrongMarked(int row, int col, List<List<int>> solution) {
    return _cellStates[row][col] == CellState.marked && solution[row][col] == 1;
  }

  bool isColumnFullyFilled(int col) {
    for (int row = 0; row < _cellStates.length; row++) {
      if (_cellStates[row][col] == CellState.empty) {
        return false;
      }
    }
    return true;
  }

  bool isRowFullyFilled(int row) {
    for (int col = 0; col < _cellStates[row].length; col++) {
      if (_cellStates[row][col] == CellState.empty) {
        return false;
      }
    }
    return true;
  }

  void _updateCompletedLines() {
    for (int row = 0; row < _size; row++) {
      completedRows[row] = _cellStates[row].every(
        (cell) => cell != CellState.empty,
      );
    }

    for (int col = 0; col < _size; col++) {
      bool isFilled = true;
      for (int row = 0; row < _size; row++) {
        if (_cellStates[row][col] == CellState.empty) {
          isFilled = false;
          break;
        }
      }
      completedCols[col] = isFilled;
    }
  }

  Future<void> _submitScore({
    required String seed,
    required int completionTime,
    required int errorsCount,
    required int width,
    required int height,
    required int points,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    final response = await http.post(
      Uri.parse('$baseUrl/users/score'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'seed': seed,
        'completionTime': completionTime,
        'errorsCount': errorsCount,
        'width': width,
        'height': height,
        'points': points,
      }),
    );

    if (response.statusCode == 200) {
      print('Puntuación guardada correctamente');
    } else {
      print('Error al enviar puntuación: ${response.body}');
    }
  }

  int _calculatePoints(int time, int errors, int size) {
    int base = size * size * 10;
    int penalty = errors * 5 + time;
    return (base - penalty).clamp(0, base);
  }

  void restartGame() {
    _cellStates.setAll(
      0,
      List.generate(_size, (_) => List.generate(_size, (_) => CellState.empty)),
    );
    _currentTime = 0;
    _isCompleted = false;
    _message = '';
    _timer?.cancel();
    _startTimer();
    _updateCompletedLines();
    notifyListeners();
  }
}
