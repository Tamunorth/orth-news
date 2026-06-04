// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Orth News';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navSaved => 'Saved';

  @override
  String get navSettings => 'Settings';

  @override
  String get trending => 'Trending';

  @override
  String get latest => 'Latest';

  @override
  String get seeAll => 'See all';

  @override
  String get searchHint => 'Search';

  @override
  String get searchSavedHint => 'Search saved';

  @override
  String get searchPromptTitle => 'Search the news';

  @override
  String get searchPromptSubtitle =>
      'Find stories by keyword, topic or source.';

  @override
  String get bookmarksTitle => 'Bookmarks';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get readFullArticle => 'Read full article';

  @override
  String get retry => 'Try again';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorSubtitle => 'Please check your connection and try again.';

  @override
  String get emptyHeadlinesTitle => 'No stories right now';

  @override
  String get emptyHeadlinesSubtitle =>
      'There are no headlines for this category yet.';

  @override
  String get emptySearchTitle => 'No results';

  @override
  String emptySearchSubtitle(String query) {
    return 'We couldn\'t find anything for \"$query\".';
  }

  @override
  String get emptyBookmarksTitle => 'No saved stories';

  @override
  String get emptyBookmarksSubtitle =>
      'Tap the bookmark icon on any article to keep it here.';

  @override
  String get categoryGeneral => 'All';

  @override
  String get categoryBusiness => 'Business';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryScience => 'Science';

  @override
  String get categorySports => 'Sports';

  @override
  String get categoryTechnology => 'Technology';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get settingsDefaultLayout => 'Default layout';

  @override
  String get layoutList => 'List';

  @override
  String get layoutGrid => 'Grid';

  @override
  String get settingsContent => 'Content';

  @override
  String get settingsRegion => 'Region';

  @override
  String get settingsDefaultCategory => 'Default category';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get bookmarkAdd => 'Save';

  @override
  String get bookmarkRemove => 'Saved';
}
