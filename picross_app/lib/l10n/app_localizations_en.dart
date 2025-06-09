// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Picross';

  @override
  String get account_title => 'Account';

  @override
  String get error_fill_fields => 'Please fill in all fields.';

  @override
  String get error_user_data => 'Failed to retrieve user data.';

  @override
  String get error_register => 'User registration failed.';

  @override
  String get error_email_in_use => 'This email is alredy in use';

  @override
  String get login_success => 'Login successful';

  @override
  String get login_wrong_credentials => 'Incorrect credentials';

  @override
  String get token_bearer_required => 'The Token Bearer is required';

  @override
  String get token_invalid_or_exired => 'The Token is invalid or is expired';

  @override
  String get user_not_found => 'The user was not found';

  @override
  String get server_error => 'Server error';

  @override
  String get email_hint => 'Enter your email address';

  @override
  String get password_hint => 'Enter your password';

  @override
  String get register_button => 'Register';

  @override
  String get login_button => 'Login';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get change_photo => 'Change photo';

  @override
  String get username => 'Username';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get logout => 'Log out';

  @override
  String get edit_success => 'Changes saved successfully';

  @override
  String get edit_error => 'Failed to save changes';

  @override
  String get logout_confirm => 'Do you want to log out?';

  @override
  String get no_session => 'No session started.';

  @override
  String get update_success => 'Details updated successfully.';

  @override
  String update_error(Object message) {
    return 'Error: $message';
  }

  @override
  String get change_password => 'Change password';

  @override
  String get current_password => 'Current password';

  @override
  String get new_password => 'New password';

  @override
  String get cancel => 'Cancel';

  @override
  String get change => 'Change';

  @override
  String get fill_both_fields => 'Please fill both fields';

  @override
  String get no_active_session => 'No active session';

  @override
  String get password_updated => 'Password updated successfully';

  @override
  String password_change_error(Object message) {
    return 'Error: $message';
  }

  @override
  String get password_change_fail => 'Server error or incorrect password';

  @override
  String get logout_success => 'Session closed';

  @override
  String get your_profile => 'Your profile';

  @override
  String get credits_title => 'Powered by:';

  @override
  String get credits_body => 'Ivan Barrasa & Cristhian Leon';

  @override
  String get restart_game_tooltip => 'Restart game';

  @override
  String get best_time => 'Best time';

  @override
  String get current_time => 'Current time';

  @override
  String get score_points => 'Score';

  @override
  String get toggle_mode_button => 'Toggle mode';

  @override
  String get not_available => 'Not available';

  @override
  String get home_menu => 'Menu';

  @override
  String get home_language => 'Language';

  @override
  String get home_instructions => 'Instructions';

  @override
  String get home_credits => 'Credits';

  @override
  String get home_delete_best_times_tooltip => 'Delete best times';

  @override
  String get home_delete_best_times_message => 'All best times deleted';

  @override
  String get home_profile => 'Your profile';

  @override
  String get home_select_level => 'Select level';

  @override
  String get instructions_title => 'Instructions';

  @override
  String get whats_nonogram_title =>
      'What Are Nonograms? A Complete Beginner\'s Guide';

  @override
  String get whats_nonogram_body =>
      'A nonogram is a type of logic puzzle that consists of a rectangular grid of squares, with numerical clues aligned along the rows and columns. The goal is to determine which squares should be filled to eventually uncover a hidden pixel-style image. The puzzle challenges players to use logic and deduction rather than guesswork to complete it successfully.\n\nThe numbers provided are not random—they represent sequences of filled squares. For example, a clue of \'5 2\' in a row means there will be a group of five filled cells, followed by at least one blank cell, and then a group of two filled cells. However, the placement of these blocks is not initially clear, which is where your reasoning skills come into play.\n\nThis type of picture logic puzzle requires no prior math skills, just patience and logical thinking. With each square you fill (or exclude), you get closer to completing a hidden illustration—one of the most rewarding parts of solving nonograms.';

  @override
  String get how_to_play_title => 'How to Play Nonograms: Step-by-Step';

  @override
  String get how_to_play_body =>
      'Learning how to play a nonogram puzzle can seem tricky at first, but once you understand the system behind it, you\'ll be hooked. The basic principle is to use the clues to determine which squares to fill in. There\'s no guessing—just methodical analysis and deduction.\n\nStart by identifying rows or columns where the clues take up the full width. For example, in a 10x10 grid, a row with a clue \'10\' clearly means all 10 cells are filled. Rows like \'9\' or \'8\' will also have very limited positions where the blocks can go, making them a great starting point. Use this logic to mark what you\'re sure of.\n\nAs you work through the puzzle, use the gray squares to mark empty squares. This visual aid helps eliminate possibilities and focus your attention. As more clues align, you\'ll unlock new sections. The beauty of the nonogram puzzle is in the slow unveiling of the image—like solving a mystery one square at a time.';

  @override
  String get basic_rules_title => 'Nonogram Puzzle Rules for Beginners';

  @override
  String get basic_rules_body =>
      'The golden rule in any nonogram is: never guess. Every move should be based on logic. If the clue says \'3 2\', you cannot assume where the 3 and the 2 go without testing all possible placements and cross-checking with intersecting clues. A single mistake can throw off your entire puzzle.\n\nAlways work on both axes—rows and columns—simultaneously. This cross-referencing is key to advancing through difficult puzzles. The challenge scales with larger grids and more complex clue patterns, but the satisfaction also grows with each completed puzzle.';

  @override
  String get advices_title => 'Logic Puzzle Tips to Improve Your Strategy';

  @override
  String get advices_body =>
      'If you\'re stuck, revisit previously marked rows and columns. New information often helps solve older sections. Use \'edge logic\', focusing on rows or columns with clues that are long enough to touch both edges of the grid. This tactic is especially useful in mid-size puzzles.\n\nDon\'t hesitate to lightly test possibilities using pencil marks or digital tools—just avoid finalizing moves until you\'re sure. As you practice, you\'ll naturally develop intuition for patterns and improve your speed and accuracy.';

  @override
  String get language_title => 'Language';

  @override
  String get game_lost => 'You lost!';

  @override
  String get game_won => 'You won!';

  @override
  String get score_saved_success => 'Score saved successfully';

  @override
  String score_save_error(Object errorBody) {
    return 'Error sending score: $errorBody';
  }

  @override
  String connection_success(Object responseBody) {
    return 'Connection successful. Response: $responseBody';
  }

  @override
  String connection_error_code(Object statusCode) {
    return 'Connection error. Code: $statusCode';
  }

  @override
  String connection_error(Object error) {
    return 'Connection error: $error';
  }
}
