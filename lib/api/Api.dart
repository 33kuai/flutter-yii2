class Api{

  static const String BASE_URL      =  'http://api.zuxianzhi.com/';
  static const String DO_LOGIN      =  BASE_URL + 'login';
  static const String LOGOUT        =  BASE_URL + 'logout';
  static const String USER_INFO     =  BASE_URL + 'userInfo';
  static const String ARTICLE_LIST  =  BASE_URL + 'v2/article';
  static const String MOVIE_LIST    =  BASE_URL + 'v2/movie-es';
  static const String ARTICLE       =  BASE_URL + 'v1/article/view';
  static const String CATEGORY      =  BASE_URL + 'v1/article-category/index';

  static const String PROFILE       =  BASE_URL + 'v2/profile/view?user_id=';
  static const String PROFILE_UPDATE       =  BASE_URL + 'v2/profile/update';
}