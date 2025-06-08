import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Picross'**
  String get title;

  /// No description provided for @account_title.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account_title;

  /// No description provided for @error_fill_fields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields.'**
  String get error_fill_fields;

  /// No description provided for @error_user_data.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve user data.'**
  String get error_user_data;

  /// No description provided for @error_register.
  ///
  /// In en, this message translates to:
  /// **'User registration failed.'**
  String get error_register;

  /// No description provided for @login_success.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get login_success;

  /// No description provided for @login_wrong_credentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect credentials'**
  String get login_wrong_credentials;

  /// No description provided for @server_error.
  ///
  /// In en, this message translates to:
  /// **'Server error: {code}'**
  String server_error(Object code);

  /// No description provided for @email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get email_hint;

  /// No description provided for @password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get password_hint;

  /// No description provided for @register_button.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register_button;

  /// No description provided for @login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_button;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @change_photo.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get change_photo;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @edit_success.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully'**
  String get edit_success;

  /// No description provided for @edit_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to save changes'**
  String get edit_error;

  /// No description provided for @logout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to log out?'**
  String get logout_confirm;

  /// No description provided for @no_session.
  ///
  /// In en, this message translates to:
  /// **'No session started.'**
  String get no_session;

  /// No description provided for @update_success.
  ///
  /// In en, this message translates to:
  /// **'Details updated successfully.'**
  String get update_success;

  /// Error message when updating user details
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String update_error(Object message);

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get change_password;

  /// No description provided for @current_password.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get current_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get new_password;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @fill_both_fields.
  ///
  /// In en, this message translates to:
  /// **'Please fill both fields'**
  String get fill_both_fields;

  /// No description provided for @no_active_session.
  ///
  /// In en, this message translates to:
  /// **'No active session'**
  String get no_active_session;

  /// No description provided for @password_updated.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get password_updated;

  /// Error message when changing password
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String password_change_error(Object message);

  /// No description provided for @password_change_fail.
  ///
  /// In en, this message translates to:
  /// **'Server error or incorrect password'**
  String get password_change_fail;

  /// No description provided for @logout_success.
  ///
  /// In en, this message translates to:
  /// **'Session closed'**
  String get logout_success;

  /// No description provided for @your_profile.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get your_profile;

  /// No description provided for @credits_title.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get credits_title;

  /// No description provided for @credits_body.
  ///
  /// In en, this message translates to:
  /// **'Here the application credits will be shown.'**
  String get credits_body;

  /// No description provided for @restart_game_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Restart game'**
  String get restart_game_tooltip;

  /// No description provided for @best_time.
  ///
  /// In en, this message translates to:
  /// **'Best time'**
  String get best_time;

  /// No description provided for @current_time.
  ///
  /// In en, this message translates to:
  /// **'Current time'**
  String get current_time;

  /// No description provided for @score_points.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score_points;

  /// No description provided for @toggle_mode_button.
  ///
  /// In en, this message translates to:
  /// **'Toggle mode'**
  String get toggle_mode_button;

  /// No description provided for @not_available.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get not_available;

  /// No description provided for @home_menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get home_menu;

  /// No description provided for @home_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get home_language;

  /// No description provided for @home_instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get home_instructions;

  /// No description provided for @home_credits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get home_credits;

  /// No description provided for @home_delete_best_times_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete best times'**
  String get home_delete_best_times_tooltip;

  /// No description provided for @home_delete_best_times_message.
  ///
  /// In en, this message translates to:
  /// **'All best times deleted'**
  String get home_delete_best_times_message;

  /// No description provided for @home_profile.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get home_profile;

  /// No description provided for @home_select_level.
  ///
  /// In en, this message translates to:
  /// **'Select level'**
  String get home_select_level;

  /// No description provided for @instructions_title.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions_title;

  /// No description provided for @whats_nonogram_title.
  ///
  /// In en, this message translates to:
  /// **'What Are Nonograms? A Complete Beginner\'s Guide'**
  String get whats_nonogram_title;

  /// No description provided for @whats_nonogram_body.
  ///
  /// In en, this message translates to:
  /// **'A nonogram is a type of logic puzzle that consists of a rectangular grid of squares, with numerical clues aligned along the rows and columns. The goal is to determine which squares should be filled to eventually uncover a hidden pixel-style image. The puzzle challenges players to use logic and deduction rather than guesswork to complete it successfully.\n\nThe numbers provided are not random—they represent sequences of filled squares. For example, a clue of \'5 2\' in a row means there will be a group of five filled cells, followed by at least one blank cell, and then a group of two filled cells. However, the placement of these blocks is not initially clear, which is where your reasoning skills come into play.\n\nThis type of picture logic puzzle requires no prior math skills, just patience and logical thinking. With each square you fill (or exclude), you get closer to completing a hidden illustration—one of the most rewarding parts of solving nonograms.'**
  String get whats_nonogram_body;

  /// No description provided for @how_to_play_title.
  ///
  /// In en, this message translates to:
  /// **'How to Play Nonograms: Step-by-Step'**
  String get how_to_play_title;

  /// No description provided for @how_to_play_body.
  ///
  /// In en, this message translates to:
  /// **'Learning how to play a nonogram puzzle can seem tricky at first, but once you understand the system behind it, you\'ll be hooked. The basic principle is to use the clues to determine which squares to fill in. There\'s no guessing—just methodical analysis and deduction.\n\nStart by identifying rows or columns where the clues take up the full width. For example, in a 10x10 grid, a row with a clue \'10\' clearly means all 10 cells are filled. Rows like \'9\' or \'8\' will also have very limited positions where the blocks can go, making them a great starting point. Use this logic to mark what you\'re sure of.\n\nAs you work through the puzzle, use the gray squares to mark empty squares. This visual aid helps eliminate possibilities and focus your attention. As more clues align, you\'ll unlock new sections. The beauty of the nonogram puzzle is in the slow unveiling of the image—like solving a mystery one square at a time.'**
  String get how_to_play_body;

  /// No description provided for @basic_rules_title.
  ///
  /// In en, this message translates to:
  /// **'Nonogram Puzzle Rules for Beginners'**
  String get basic_rules_title;

  /// No description provided for @basic_rules_body.
  ///
  /// In en, this message translates to:
  /// **'The golden rule in any nonogram is: never guess. Every move should be based on logic. If the clue says \'3 2\', you cannot assume where the 3 and the 2 go without testing all possible placements and cross-checking with intersecting clues. A single mistake can throw off your entire puzzle.\n\nAlways work on both axes—rows and columns—simultaneously. This cross-referencing is key to advancing through difficult puzzles. The challenge scales with larger grids and more complex clue patterns, but the satisfaction also grows with each completed puzzle.'**
  String get basic_rules_body;

  /// No description provided for @advices_title.
  ///
  /// In en, this message translates to:
  /// **'Logic Puzzle Tips to Improve Your Strategy'**
  String get advices_title;

  /// No description provided for @advices_body.
  ///
  /// In en, this message translates to:
  /// **'If you\'re stuck, revisit previously marked rows and columns. New information often helps solve older sections. Use \'edge logic\', focusing on rows or columns with clues that are long enough to touch both edges of the grid. This tactic is especially useful in mid-size puzzles.\n\nDon\'t hesitate to lightly test possibilities using pencil marks or digital tools—just avoid finalizing moves until you\'re sure. As you practice, you\'ll naturally develop intuition for patterns and improve your speed and accuracy.'**
  String get advices_body;

  /// No description provided for @language_title.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language_title;

  /// No description provided for @game_lost.
  ///
  /// In en, this message translates to:
  /// **'You lost!'**
  String get game_lost;

  /// No description provided for @game_won.
  ///
  /// In en, this message translates to:
  /// **'You won!'**
  String get game_won;

  /// No description provided for @score_saved_success.
  ///
  /// In en, this message translates to:
  /// **'Score saved successfully'**
  String get score_saved_success;

  /// Message when there is an error sending the score to the server
  ///
  /// In en, this message translates to:
  /// **'Error sending score: {errorBody}'**
  String score_save_error(Object errorBody);

  /// Message when connection to the API is successful
  ///
  /// In en, this message translates to:
  /// **'Connection successful. Response: {responseBody}'**
  String connection_success(Object responseBody);

  /// Message when the API connection fails with HTTP code
  ///
  /// In en, this message translates to:
  /// **'Connection error. Code: {statusCode}'**
  String connection_error_code(Object statusCode);

  /// Message when there is a general connection error
  ///
  /// In en, this message translates to:
  /// **'Connection error: {error}'**
  String connection_error(Object error);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
