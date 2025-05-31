import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/time_service.dart';
import 'package:http/http.dart' as http;


enum CellState { empty, filled, marked }

enum InteractionMode { fill, mark }

class GameState extends ChangeNotifier {
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

  GameState(this._size, this._solution) {
    //TODO: eliminar esta linea cuando se vaya a hacer el release
    print(
      _solution,
    ); //! Esta linea se usa para mostrar la solución en el modo debug

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

  // Getters públicos
  int get size => _size;
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
        _mode == InteractionMode.fill
            ? InteractionMode.mark
            : InteractionMode.fill;
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
    bool hasErrors = false;
    for (int row = 0; row < _size && !hasErrors; row++) {
      for (int col = 0; col < _size && !hasErrors; col++) {
        if (_solution[row][col] == 1 &&
            _cellStates[row][col] != CellState.filled) {
          hasErrors = true;
        } else if (_solution[row][col] == 0 &&
            _cellStates[row][col] == CellState.filled) {
          hasErrors = true;
        }
      }
    }

    _isCompleted = true;
    _timer?.cancel();

    if (hasErrors) {
      _message = "¡Has perdido! Hay errores en las casillas.";
    } else {
      if (_bestTime == null || _currentTime < _bestTime!) {
        _bestTime = _currentTime;
        _saveBestTime();
      }
      _message = "¡Has ganado!";
    }

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
  final url = Uri.parse('http://api.playpicross.com');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('Conexión exitosa. Respuesta: ${response.body}');
    } else {
      print('Error en la conexión. Código: ${response.statusCode}');
    }
  } catch (e) {
    print('Error de conexión: $e');
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
    _bestTime = prefs.getInt('bestTime_$_size');
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
      await prefs.remove('bestTime_$s');
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
