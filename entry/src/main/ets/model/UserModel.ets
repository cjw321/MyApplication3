export class UserInfo {
  avatar: string = '';
  avatarUri: string = '';
  nickname: string = '';
  studentId: string = '';
  college: string = '';
  major: string = '';
  grade: string = '';
  phone: string = '';
  email: string = '';
}

export class FavoriteItem {
  id: number = 0;
  type: string = ''; // 'announcement' | 'news' | 'book' | 'food'
  title: string = '';
  sourceId: number = 0;
  createTime: string = '';
}
