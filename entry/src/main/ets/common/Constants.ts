export default class Constants {
  static readonly MEDIA_ROUTE = 'pages/Media';
  static readonly DOWNLOAD_ROUTE = 'pages/Download';
  static readonly UPLOAD_ROUTE = 'pages/Upload';
  static readonly GRID_COLUMNS_TEMPLATE: string = '1fr 1fr 1fr';
  static readonly LIST_ITEM_SPACE: number = 25;
  static readonly MAX_SELECT_IMAGES_ONCE = 99;
  // static readonly SERVER_UPLOAD_ADDR = 'http://172.25.208.1:8888/upload';
  // static readonly SERVER_DOWNLOAD_ADDR = 'http://172.25.208.1:8888/download';
  static readonly SERVER_UPLOAD_URL = 'upload';
  static readonly SERVER_NEW_TASK = 'newTask/';
  static readonly SERVER_DOWNLOAD_VIDEO_URL = 'download/video/';
  static readonly SERVER_HISTORY_LIST = 'history/list';
  static readonly SERVER_HISTORY_ICON = 'history/icon/';
  static readonly SERVER_DOWNLOAD_LOADING_URL = 'download/loading';
  static readonly SERVER_CHECK_MODEL_URL = 'check/model';
  static readonly SERVER_CALCULATE_URL = 'calculate';
  static readonly SERVER_PREVIEW_URL = 'preview/';
  static readonly SERVER_PREVIEW_IMAGES_URL = 'preview/images';
  static readonly SERVER_DOWNLOAD_LOCAL_URL = 'file://media/Photos/';
}