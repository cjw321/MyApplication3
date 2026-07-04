export class Constants {
  static readonly APP_NAME = '高校校园助手';
  static readonly APP_SUBTITLE = 'HarmonyOS NEXT 版';
  static readonly PAGE_SPlASH = 'pages/SplashPage';
  static readonly PAGE_INDEX = 'pages/Index';
  static readonly PAGE_GUIDE = 'pages/GuidePage';
  static readonly PAGE_LOGIN = 'pages/LoginPage';
  static readonly PAGE_ANNOUNCEMENT_DETAIL = 'pages/home/AnnouncementDetailPage';
  static readonly PAGE_ANNOUNCEMENT_LIST = 'pages/campus/AnnouncementListPage';
  static readonly PAGE_NEWS_LIST = 'pages/campus/NewsListPage';
  static readonly PAGE_NEWS_DETAIL = 'pages/campus/NewsDetailPage';
  static readonly PAGE_CAMPUS_MAP = 'pages/campus/CampusMapPage';
  static readonly PAGE_COURSE_SCHEDULE = 'pages/study/CourseSchedulePage';
  static readonly PAGE_COURSE_EDIT = 'pages/study/CourseEditPage';
  static readonly PAGE_GRADE_QUERY = 'pages/study/GradeQueryPage';
  static readonly PAGE_LIBRARY_SEARCH = 'pages/study/LibrarySearchPage';
  static readonly PAGE_BOOK_DETAIL = 'pages/study/BookDetailPage';
  static readonly PAGE_LOST_FOUND_LIST = 'pages/life/LostFoundListPage';
  static readonly PAGE_LOST_FOUND_PUBLISH = 'pages/life/LostFoundPublishPage';
  static readonly PAGE_FOOD_LIST = 'pages/life/FoodListPage';
  static readonly PAGE_FOOD_DETAIL = 'pages/life/FoodDetailPage';
  static readonly PAGE_MUSIC_PLAYER = 'pages/life/MusicPlayerPage';
  static readonly PAGE_PERSONAL_INFO = 'pages/profile/PersonalInfoPage';
  static readonly PAGE_MY_FAVORITES = 'pages/profile/MyFavoritesPage';
  static readonly PAGE_TODO_MANAGE = 'pages/profile/TodoManagePage';
  static readonly PAGE_SETTINGS = 'pages/profile/SettingsPage';

  static readonly TAB_HOME = 0;
  static readonly TAB_CAMPUS = 1;
  static readonly TAB_STUDY = 2;
  static readonly TAB_LIFE = 3;
  static readonly TAB_PROFILE = 4;

  static readonly TODO_CATEGORY_STUDY = '学习';
  static readonly TODO_CATEGORY_LIFE = '生活';
  static readonly TODO_CATEGORY_OTHER = '其他';

  static readonly ANNOUNCEMENT_TYPE_SCHOOL = '学校通知';
  static readonly ANNOUNCEMENT_TYPE_COLLEGE = '学院通知';
  static readonly ANNOUNCEMENT_TYPE_CLUB = '社团通知';

  static readonly LOST_FOUND_TYPE_LOST = '失物';
  static readonly LOST_FOUND_TYPE_FOUND = '拾物';

  static readonly THEME_LIGHT = 'light';
  static readonly THEME_DARK = 'dark';

  static readonly FONT_SIZE_SMALL = 'small';
  static readonly FONT_SIZE_MEDIUM = 'medium';
  static readonly FONT_SIZE_LARGE = 'large';

  static readonly PREF_KEY_THEME = 'theme_mode';
  static readonly PREF_KEY_FONT_SIZE = 'font_size';
  static readonly PREF_KEY_NOTIFY_COURSE = 'notify_course';
  static readonly PREF_KEY_NOTIFY_ANNOUNCEMENT = 'notify_announcement';
  static readonly PREF_KEY_NOTIFY_TODO = 'notify_todo';
  static readonly PREF_KEY_USER_INFO = 'user_info';
  static readonly PREF_KEY_COURSES = 'courses';
  static readonly PREF_KEY_TODOS = 'todos';
  static readonly PREF_KEY_FAVORITES = 'favorites';

  // 应用首次打开标记：true 表示尚未看过引导页
  static readonly PREF_KEY_FIRST_OPEN = 'is_first_open';
  // 登录态标记
  static readonly PREF_KEY_LOGGED_IN = 'is_logged_in';
  // 记住密码标记
  static readonly PREF_KEY_REMEMBER_PWD = 'remember_password';
  static readonly PREF_KEY_SAVED_PWD = 'saved_password';
}
