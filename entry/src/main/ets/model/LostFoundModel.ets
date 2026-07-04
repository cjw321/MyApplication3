export class LostFoundItem {
  id: number = 0;
  type: string = ''; // '失物' | '拾物'
  title: string = '';
  description: string = '';
  location: string = '';
  lostTime: string = '';
  contactPhone: string = '';
  category: string = ''; // '校园卡' | '书包' | '电子产品' | '其他'
  imageUrls: string[] = [];
  publishTime: string = '';
  publisher: string = '';
}
