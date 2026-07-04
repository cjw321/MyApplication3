export class Book {
  id: number = 0;
  name: string = '';
  author: string = '';
  isbn: string = '';
  publisher: string = '';
  publishYear: string = '';
  location: string = '';
  totalCount: number = 0;
  availableCount: number = 0;
  coverUrl: string = '';
  description: string = '';
  isCollected: boolean = false;
  status: string = ''; // '' | 'want' | 'borrowed'
}
