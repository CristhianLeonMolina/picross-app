// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get title => 'Picross';

  @override
  String get account_title => 'Cuenta';

  @override
  String get error_fill_fields => 'Por favor, completa todos los campos.';

  @override
  String get error_user_data => 'Error al obtener datos del usuario.';

  @override
  String get error_register => 'No se pudo registrar el usuario.';

  @override
  String get login_success => 'Inicio de sesión exitoso';

  @override
  String get login_wrong_credentials => 'Credenciales incorrectas';

  @override
  String server_error(Object code) {
    return 'Error del servidor';
  }

  @override
  String get email_hint => 'Introduce tu correo electrónico';

  @override
  String get password_hint => 'Introduce tu contraseña';

  @override
  String get register_button => 'Regístrate';

  @override
  String get login_button => 'Iniciar sesión';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Guardar';

  @override
  String get change_photo => 'Cambiar foto';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get edit_success => 'Cambios guardados con éxito';

  @override
  String get edit_error => 'No se pudieron guardar los cambios';

  @override
  String get logout_confirm => '¿Deseas cerrar sesión?';

  @override
  String get no_session => 'No hay sesión iniciada.';

  @override
  String get update_success => 'Datos actualizados correctamente.';

  @override
  String update_error(Object message) {
    return 'Error: $message';
  }

  @override
  String get change_password => 'Cambiar contraseña';

  @override
  String get current_password => 'Contraseña actual';

  @override
  String get new_password => 'Nueva contraseña';

  @override
  String get cancel => 'Cancelar';

  @override
  String get change => 'Cambiar';

  @override
  String get fill_both_fields => 'Rellena ambos campos';

  @override
  String get no_active_session => 'No hay sesión activa';

  @override
  String get password_updated => 'Contraseña actualizada correctamente';

  @override
  String password_change_error(Object message) {
    return 'Error: $message';
  }

  @override
  String get password_change_fail => 'Error del servidor o contraseña incorrecta';

  @override
  String get logout_success => 'Sesión cerrada';

  @override
  String get your_profile => 'Tu perfil';

  @override
  String get credits_title => 'Créditos';

  @override
  String get credits_body => 'Aquí se mostrarán los créditos de la aplicación.';

  @override
  String get restart_game_tooltip => 'Reiniciar partida';

  @override
  String get best_time => 'Mejor tiempo';

  @override
  String get current_time => 'Tiempo actual';

  @override
  String get score_points => 'Puntuación';

  @override
  String get toggle_mode_button => 'Cambiar modo';

  @override
  String get not_available => 'No disponible';

  @override
  String get home_menu => 'Menú';

  @override
  String get home_language => 'Idioma';

  @override
  String get home_instructions => 'Instrucciones';

  @override
  String get home_credits => 'Créditos';

  @override
  String get home_delete_best_times_tooltip => 'Borrar mejores tiempos';

  @override
  String get home_delete_best_times_message => 'Todos los mejores tiempos eliminados';

  @override
  String get home_profile => 'Tu perfil';

  @override
  String get home_select_level => 'Selecciona el nivel';

  @override
  String get instructions_title => 'Instrucciones';

  @override
  String get whats_nonogram_title => '¿Qué son los Nonogramas? Una Guía Completa para Principiantes';

  @override
  String get whats_nonogram_body => 'Un nonograma es un tipo de puzzle lógico que consiste en una cuadrícula rectangular de casillas, con pistas numéricas alineadas a lo largo de las filas y columnas. El objetivo es determinar qué casillas deben rellenarse para eventualmente descubrir una imagen oculta en estilo pixel. El puzzle desafía a los jugadores a usar la lógica y la deducción en lugar de la adivinación para completarlo con éxito.\n\nLos números proporcionados no son aleatorios: representan secuencias de casillas rellenas. Por ejemplo, una pista de \'5 2\' en una fila significa que habrá un grupo de cinco casillas rellenas, seguido de al menos una casilla vacía, y luego un grupo de dos casillas rellenas. Sin embargo, la ubicación de estos bloques no está clara inicialmente, que es donde entran en juego tus habilidades de razonamiento.\n\nEste tipo de puzzle lógico de imágenes no requiere habilidades matemáticas previas, solo paciencia y pensamiento lógico. Con cada casilla que rellenas (o excluyes), te acercas a completar una ilustración oculta, una de las partes más gratificantes de resolver nonogramas.';

  @override
  String get how_to_play_title => 'Cómo Jugar Nonogramas: Paso a Paso';

  @override
  String get how_to_play_body => 'Aprender a jugar un puzzle nonograma puede parecer complicado al principio, pero una vez que entiendas el sistema detrás de él, te enganchará. El principio básico es usar las pistas para determinar qué casillas rellenar. No hay adivinación, solo análisis metódico y deducción.\n\nComienza identificando filas o columnas donde las pistas ocupan todo el ancho. Por ejemplo, en una cuadrícula de 10x10, una fila con la pista \'10\' claramente significa que todas las 10 casillas están rellenas. Filas como \'9\' o \'8\' también tendrán posiciones muy limitadas donde pueden ir los bloques, lo que las convierte en un gran punto de partida. Usa esta lógica para marcar lo que estás seguro.\n\nMientras trabajas en el puzzle, usa los bloques grises para marcar casillas vacías. Esta ayuda visual ayuda a eliminar posibilidades y enfocar tu atención. A medida que más pistas se alinean, desbloquearás nuevas secciones. La belleza del puzzle nonograma está en la lenta revelación de la imagen, como resolver un misterio una casilla a la vez.';

  @override
  String get basic_rules_title => 'Reglas de los Puzzles Nonograma para Principiantes';

  @override
  String get basic_rules_body => 'La regla de oro en cualquier nonograma es: nunca adivines. Cada movimiento debe basarse en la lógica. Si la pista dice \'3 2\', no puedes asumir dónde van el 3 y el 2 sin probar todas las ubicaciones posibles y verificar con las pistas que se cruzan. Un solo error puede arruinar todo tu puzzle.\n\nSiempre trabaja en ambos ejes (filas y columnas) simultáneamente. Esta verificación cruzada es clave para avanzar a través de puzzles difíciles. El desafío escala con cuadrículas más grandes y patrones de pistas más complejos, pero la satisfacción también crece con cada puzzle completado.';

  @override
  String get advices_title => 'Consejos de Puzzles Lógicos para Mejorar tu Estrategia';

  @override
  String get advices_body => 'Si estás atascado, revisa filas y columnas previamente marcadas. La nueva información a menudo ayuda a resolver secciones anteriores. Usa la \'lógica de bordes\', enfocándote en filas o columnas con pistas que son lo suficientemente largas como para tocar ambos bordes de la cuadrícula. Esta táctica es especialmente útil en puzzles de tamaño medio.\n\nNo dudes en probar ligeramente posibilidades usando marcas de lápiz o herramientas digitales, solo evita finalizar movimientos hasta que estés seguro. A medida que practiques, desarrollarás naturalmente intuición para patrones y mejorarás tu velocidad y precisión.';

  @override
  String get language_title => 'Idioma';

  @override
  String get game_lost => '¡Has perdido!';

  @override
  String get game_won => '¡Has ganado!';

  @override
  String get score_saved_success => 'Puntuación guardada correctamente';

  @override
  String score_save_error(Object errorBody) {
    return 'Error al enviar puntuación: $errorBody';
  }

  @override
  String connection_success(Object responseBody) {
    return 'Conexión exitosa. Respuesta: $responseBody';
  }

  @override
  String connection_error_code(Object statusCode) {
    return 'Error en la conexión. Código: $statusCode';
  }

  @override
  String connection_error(Object error) {
    return 'Error de conexión: $error';
  }
}
