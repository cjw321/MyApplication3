export class Food {
  id: number = 0;
  name: string = '';
  location: string = '';
  description: string = '';
  featureDish: string = '';
  rating: number = 0; // 1-5
  ratingCount: number = 0;
  imageUrls: string[] = [];
  isCollected: boolean = false;
  myRating: number = 0;
}

export class FoodComment {
  id: number = 0;
  foodId: number = 0;
  userName: string = '';
  content: string = '';
  rating: number = 0;
  time: string = '';
}
