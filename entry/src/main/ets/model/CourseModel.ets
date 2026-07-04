export class Course {
  id: number = 0;
  name: string = '';
  teacher: string = '';
  classroom: string = '';
  weekday: number = 1; // 1=周一 ... 7=周日
  startSlot: number = 1; // 第几节开始
  endSlot: number = 2; // 第几节结束
  weeks: number[] = []; // 上课周次
  credit: number = 0;
  remindBeforeMin: number = 10; // 提前多少分钟提醒
  note: string = '';
}
