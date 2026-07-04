export class Announcement {
  id: number = 0;
  title: string = '';
  content: string = '';
  type: string = '';
  publisher: string = '';
  publishTime: string = '';
  imageUrls: string[] = [];
  isCollected: boolean = false;
}

export class News {
  id: number = 0;
  title: string = '';
  summary: string = '';
  content: string = '';
  category: string = '';
  source: string = '';
  publishTime: string = '';
  imageUrls: string[] = [];
  isCollected: boolean = false;
}
