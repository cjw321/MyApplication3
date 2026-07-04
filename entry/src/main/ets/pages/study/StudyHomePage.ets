import { router } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { MockData } from '../../data/MockData';
import { Theme, FontSize } from '../../utils/Theme';
import { Course } from '../../model/CourseModel';
import { Grade } from '../../model/GradeModel';
import { Book } from '../../model/BookModel';

class DayCourseGroup {
  label: string;
  courses: Course[];

  constructor(label: string, courses: Course[]) {
    this.label = label;
    this.courses = courses;
  }
}

class StudyFolder {
  name: string;
  icon: string;
  fileCount: number;

  constructor(name: string, icon: string, fileCount: number) {
    this.name = name;
    this.icon = icon;
    this.fileCount = fileCount;
  }
}

@Component
export struct StudyHomePage {
  @State selectedTab: number = 0;
  @State grades: Grade[] = [];
  @State sortAsc: boolean = true;
  @State books: Book[] = [];
  @State bookKeyword: string = '';
  @State dayGroups: DayCourseGroup[] = [];
  @StorageLink('isDarkMode') isDarkMode: boolean = false;

  private tabs: string[] = ['课程表', '成绩查询', '图书馆检索', '学习资料'];
  private slotTimes: Record<number, string> = {
    1: '08:00', 2: '08:55', 3: '10:00', 4: '10:55',
    5: '14:00', 6: '14:55', 7: '16:00', 8: '16:55',
    9: '19:00', 10: '19:55'
  };
  private folders: StudyFolder[] = [
    new StudyFolder('专业课程', '📚', 12),
    new StudyFolder('公共课', '📖', 8),
    new StudyFolder('实验报告', '🧪', 6),
    new StudyFolder('论文文献', '📄', 15),
    new StudyFolder('考试资料', '📝', 10),
    new StudyFolder('课外阅读', '📘', 7),
  ];

  aboutToAppear(): void {
    this.grades = MockData.getGrades();
    this.books = MockData.getBooks();
    this.updateDayGroups();
  }

  updateDayGroups(): void {
    this.dayGroups = [];
    for (let off = -1; off <= 1; off++) {
      let label: string;
      if (off === 0) {
        label = '📌 今天';
      } else {
        const d = new Date();
        d.setDate(d.getDate() + off);
        const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
        label = `${d.getMonth() + 1}/${d.getDate()} ${weekdays[d.getDay()]}`;
      }
      const courses = this.getDayCourses(off);
      this.dayGroups.push(new DayCourseGroup(label, courses));
    }
  }

  getDayCourses(offset: number): Course[] {
    const d = new Date();
    d.setDate(d.getDate() + offset);
    const weekday = d.getDay() === 0 ? 7 : d.getDay();
    return MockData.getCourses().filter((c: Course) => c.weekday === weekday)
      .sort((a: Course, b: Course) => a.startSlot - b.startSlot);
  }

  sortGrades(): void {
    this.sortAsc = !this.sortAsc;
    this.grades = [...this.grades].sort((a: Grade, b: Grade) => {
      return this.sortAsc ? a.score - b.score : b.score - a.score;
    });
  }

  searchBooks(): void {
    const all = MockData.getBooks();
    if (this.bookKeyword.trim() === '') {
      this.books = all;
    } else {
      const kw = this.bookKeyword.trim().toLowerCase();
      this.books = all.filter((b: Book) =>
        b.name.toLowerCase().includes(kw) || b.author.toLowerCase().includes(kw)
      );
    }
  }

  build() {
    Scroll() {
      Column() {
        Text('学习助手')
          .fontSize(FontSize.PAGE_TITLE)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .padding({ left: 16, top: 16, bottom: 12 })
          .fontColor(Theme.textColor(this.isDarkMode))

        // 顶部标签
        Row() {
          ForEach(this.tabs, (tab: string, idx: number) => {
            Column() {
              Text(tab)
                .fontSize(FontSize.BODY)
                .fontWeight(this.selectedTab === idx ? FontWeight.Medium : FontWeight.Normal)
                .fontColor(this.selectedTab === idx ? Theme.PRIMARY : Theme.textSecondColor(this.isDarkMode))
                .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              if (this.selectedTab === idx) {
                Text('')
                  .width(24)
                  .height(2)
                  .backgroundColor(Theme.PRIMARY)
                  .borderRadius(1)
                  .margin({ top: 2 })
              }
            }
            .layoutWeight(1)
            .onClick(() => {
              this.selectedTab = idx;
              this.updateDayGroups();
            })
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })

        if (this.selectedTab === 0) {
          this.courseScheduleContent()
        } else if (this.selectedTab === 1) {
          this.gradeQueryContent()
        } else if (this.selectedTab === 2) {
          this.librarySearchContent()
        } else if (this.selectedTab === 3) {
          this.studyFilesContent()
        }

        Blank().height(16)
      }
    }
    .scrollBar(BarState.Off)
    .backgroundColor(Theme.bgColor(this.isDarkMode))
  }

  @Builder
  courseScheduleContent() {
    Column() {
      ForEach(this.dayGroups, (group: DayCourseGroup) => {
        Column() {
          Row() {
            Text(group.label)
              .fontSize(FontSize.BODY)
              .fontWeight(FontWeight.Medium)
              .fontColor(group.label.startsWith('📌') ? Theme.ACCENT_ORANGE : Theme.textColor(this.isDarkMode))
            Blank()
            Text(`${group.courses.length}门课`)
              .fontSize(FontSize.CAPTION)
              .fontColor(Theme.TEXT_SECOND)
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 8, bottom: 4 })

          if (group.courses.length === 0) {
            Text('无课程安排')
              .fontSize(FontSize.CAPTION)
              .fontColor(Theme.TEXT_SECOND)
              .padding(12)
              .width('100%')
              .textAlign(TextAlign.Center)
          } else {
            ForEach(group.courses, (course: Course) => {
              Row() {
                Text(this.slotTimes[course.startSlot] || '')
                  .fontSize(FontSize.CAPTION)
                  .fontColor(Theme.TEXT_SECOND)
                  .width(48)
                Column() {
                  Text(course.name)
                    .fontSize(FontSize.BODY)
                    .fontColor(Theme.textColor(this.isDarkMode))
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(`${course.classroom} · ${course.teacher}`)
                    .fontSize(FontSize.TAG)
                    .fontColor(Theme.TEXT_SECOND)
                    .margin({ top: 2 })
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 8 })
                .layoutWeight(1)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 8, bottom: 8 })
              .backgroundColor(Theme.cardColor(this.isDarkMode))
              .borderRadius(8)
              .margin({ left: 16, right: 16, bottom: 4 })
            })
          }
        }
        .width('100%')
        .margin({ bottom: 8 })
      })

      Button('编辑课程表')
        .fontSize(FontSize.CAPTION)
        .height(36)
        .width('100%')
        .backgroundColor(Theme.PRIMARY)
        .borderRadius(8)
        .margin({ left: 16, right: 16, top: 4 })
        .onClick(() => {
          router.pushUrl({ url: Constants.PAGE_COURSE_SCHEDULE });
        })
    }
    .width('100%')
    .padding({ top: 8 })
  }

  @Builder
  gradeQueryContent() {
    Column() {
      Row() {
        Text('成绩列表')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.textColor(this.isDarkMode))
        Blank()
        Button(this.sortAsc ? '↓ 从高到低' : '↑ 从低到高')
          .fontSize(FontSize.TAG)
          .height(30)
          .backgroundColor(Theme.PRIMARY)
          .borderRadius(8)
          .onClick(() => this.sortGrades())
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 8 })

      List() {
        ForEach(this.grades, (grade: Grade) => {
          ListItem() {
            Row() {
              Column() {
                Text(grade.courseName)
                  .fontSize(FontSize.BODY)
                  .fontColor(Theme.textColor(this.isDarkMode))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(`${grade.semester} · ${grade.credit}学分`)
                  .fontSize(FontSize.TAG)
                  .fontColor(Theme.TEXT_SECOND)
                  .margin({ top: 2 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
              Text(`${grade.score}`)
                .fontSize(FontSize.LIST_TITLE)
                .fontWeight(FontWeight.Bold)
                .fontColor(grade.score >= 90 ? Theme.ACCENT_GREEN : (grade.score >= 80 ? Theme.PRIMARY : Theme.ACCENT_ORANGE))
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })
            .backgroundColor(Theme.cardColor(this.isDarkMode))
            .borderRadius(8)
            .margin({ left: 16, right: 16, bottom: 6 })
          }
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding({ top: 8 })
  }

  @Builder
  librarySearchContent() {
    Column() {
      Row() {
        TextInput({ text: this.bookKeyword, placeholder: '搜索图书名称或作者...' })
          .fontSize(FontSize.BODY)
          .height(36)
          .layoutWeight(1)
          .backgroundColor(Theme.cardColor(this.isDarkMode))
          .borderRadius(18)
          .padding({ left: 12 })
          .onChange((v: string) => {
            this.bookKeyword = v;
            this.searchBooks();
          })
        Button('搜索')
          .fontSize(FontSize.CAPTION)
          .height(36)
          .backgroundColor(Theme.PRIMARY)
          .borderRadius(8)
          .margin({ left: 8 })
          .onClick(() => this.searchBooks())
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8 })

      List() {
        ForEach(this.books, (book: Book) => {
          ListItem() {
            Row() {
              Column() {
                Text(book.name)
                  .fontSize(FontSize.BODY)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(Theme.textColor(this.isDarkMode))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(book.author)
                  .fontSize(FontSize.TAG)
                  .fontColor(Theme.TEXT_SECOND)
                  .margin({ top: 2 })
                Row() {
                  Text(book.availableCount > 0 ? '可借' : '已借出')
                    .fontSize(FontSize.TAG)
                    .fontColor(book.availableCount > 0 ? Theme.ACCENT_GREEN : Theme.RED_DOT)
                  Text(`剩余${book.availableCount}本`)
                    .fontSize(FontSize.TAG)
                    .fontColor(Theme.TEXT_SECOND)
                    .margin({ left: 8 })
                }
                .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
              .margin({ left: 8 })
            }
            .width('100%')
            .padding(12)
            .backgroundColor(Theme.cardColor(this.isDarkMode))
            .borderRadius(8)
            .margin({ left: 16, right: 16, bottom: 6 })
            .onClick(() => {
              router.pushUrl({ url: Constants.PAGE_BOOK_DETAIL, params: { id: book.id } });
            })
          }
        })
      }
      .width('100%')
      .padding({ top: 8 })
    }
    .width('100%')
    .padding({ top: 8 })
  }

  @Builder
  studyFilesContent() {
    Column() {
      Grid() {
        ForEach(this.folders, (folder: StudyFolder) => {
          GridItem() {
            Column() {
              Text(folder.icon)
                .fontSize(36)
              Text(folder.name)
                .fontSize(FontSize.CAPTION)
                .fontColor(Theme.textColor(this.isDarkMode))
                .margin({ top: 6 })
              Text(`${folder.fileCount}个文件`)
                .fontSize(FontSize.TAG)
                .fontColor(Theme.TEXT_SECOND)
                .margin({ top: 2 })
            }
            .width('100%')
            .height(100)
            .justifyContent(FlexAlign.Center)
            .borderRadius(8)
            .backgroundColor(Theme.cardColor(this.isDarkMode))
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsGap(10)
      .columnsGap(10)
      .padding({ left: 16, right: 16 })
      .height(220)
    }
    .width('100%')
    .padding({ top: 12 })
  }
}