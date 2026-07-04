import { router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { Constants } from '../../utils/Constants';
import { Theme, FontSize } from '../../utils/Theme';
import { MockData } from '../../data/MockData';
import { Announcement } from '../../model/AnnouncementModel';
import { Course } from '../../model/CourseModel';
import { TodoItem } from '../../model/TodoModel';
import { PreferencesHelper } from '../../data/PreferencesHelper';

class ShortcutItem {
  title: string;
  icon: string;
  page: string;

  constructor(title: string, icon: string, page: string) {
    this.title = title;
    this.icon = icon;
    this.page = page;
  }
}

@Component
export struct HomePage {
  @State announcements: Announcement[] = [];
  @State todos: TodoItem[] = [];
  @State weather: string = '晴 28°C';
  @State weatherIcon: string = '☀️';
  @State todayCourses: Course[] = [];
  @State hasUnread: boolean = true;
  @State currentHour: number = 8;
  @State currentMin: number = 0;
  @StorageLink('isDarkMode') isDarkMode: boolean = false;

  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  private slotTimeMap: Record<number, string> = {
    1: '08:00-08:45', 2: '08:55-09:40', 3: '10:00-10:45', 4: '10:55-11:40',
    5: '14:00-14:45', 6: '14:55-15:40', 7: '16:00-16:45', 8: '16:55-17:40',
    9: '19:00-19:45', 10: '19:55-20:40'
  };

  private startMinMap: Record<number, number> = {
    1: 480, 2: 535, 3: 600, 4: 655, 5: 725, 6: 775,
    7: 840, 8: 895, 9: 960, 10: 1015
  };

  private dateStr: string = '';

  private shortcutItems: ShortcutItem[] = [
    new ShortcutItem('课程表', '📅', Constants.PAGE_COURSE_SCHEDULE),
    new ShortcutItem('成绩查询', '📊', Constants.PAGE_GRADE_QUERY),
    new ShortcutItem('图书馆', '📚', Constants.PAGE_LIBRARY_SEARCH),
    new ShortcutItem('校园地图', '🗺️', Constants.PAGE_CAMPUS_MAP),
    new ShortcutItem('失物招领', '🔍', Constants.PAGE_LOST_FOUND_LIST),
    new ShortcutItem('校园美食', '🍽️', Constants.PAGE_FOOD_LIST),
    new ShortcutItem('校园资讯', '📰', Constants.PAGE_NEWS_LIST),
    new ShortcutItem('音乐播放', '🎵', Constants.PAGE_MUSIC_PLAYER),
  ];

  aboutToAppear(): void {
    const now = new Date();
    this.currentHour = now.getHours();
    this.currentMin = now.getMinutes();
    this.dateStr = (now.getMonth() + 1) + '月' + now.getDate() + '日';
    this.loadData();
  }

  async loadData(): Promise<void> {
    this.announcements = MockData.getAnnouncements().slice(0, 3);
    const savedTodos = await PreferencesHelper.getObject<TodoItem[]>(this.context, Constants.PREF_KEY_TODOS, []);
    this.todos = savedTodos.length > 0 ? savedTodos.filter((t: TodoItem) => !t.isCompleted).slice(0, 3) : MockData.getTodos().filter(t => !t.isCompleted).slice(0, 3);
    this.loadTodayCourses();
  }

  loadTodayCourses(): void {
    const today = new Date().getDay();
    const weekday = today === 0 ? 7 : today;
    const allCourses = MockData.getCourses();
    this.todayCourses = allCourses.filter((c: Course) => c.weekday === weekday)
      .sort((a: Course, b: Course) => a.startSlot - b.startSlot);
  }

  build() {
    Scroll() {
      Column() {
        // 导航栏
        this.navBar()

        // 搜索栏
        this.searchBar()

        // 今日课程
        this.todayCourseSection()

        // 天气卡片
        this.weatherCard()

        // 九宫格快捷入口
        this.shortcutGrid()

        // 校园公告
        this.announcementSection()

        // 待办提醒
        this.todoSection()

        // 底部留白
        Blank().height(16)
      }
      .width('100%')
    }
    .scrollBar(BarState.Off)
    .backgroundColor(this.isDarkMode ? Theme.BG_DARK : Theme.BG)
  }

  @Builder
  navBar() {
    Row() {
      Text('校园助手')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor(Theme.PRIMARY)
      Blank()
      Stack() {
        Text('🔔')
          .fontSize(22)
          .fontColor(Theme.PRIMARY)
        if (this.hasUnread) {
          Text('')
            .width(8)
            .height(8)
            .borderRadius(4)
            .backgroundColor(Theme.RED_DOT)
            .position({ top: 0, right: 0 })
        }
      }
      .width(30)
      .height(30)
      .onClick(() => {
        this.hasUnread = false;
        router.pushUrl({ url: Constants.PAGE_ANNOUNCEMENT_LIST });
      })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 4 })
  }

  @Builder
  searchBar() {
    Row() {
      Text('🔍')
        .fontSize(16)
        .fontColor(Theme.TEXT_SECOND)
        .margin({ left: 12 })
      Text('搜索校园信息 / 课程 / 美食')
        .fontSize(FontSize.CAPTION)
        .fontColor(Theme.TEXT_SECOND)
        .margin({ left: 8 })
    }
    .width('100%')
    .height(40)
    .padding({ left: 4, right: 16 })
    .margin({ left: 16, right: 16, top: 8, bottom: 4 })
    .borderRadius(20)
    .backgroundColor(Theme.cardColor(this.isDarkMode))
    .onClick(() => {
      router.pushUrl({ url: Constants.PAGE_ANNOUNCEMENT_LIST });
    })
  }

  @Builder
  todayCourseSection() {
    Column() {
      Row() {
        Text('今日课程')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.textColor(this.isDarkMode))
        Blank()
        Text('更多 >')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.PRIMARY)
          .onClick(() => {
            router.pushUrl({ url: Constants.PAGE_COURSE_SCHEDULE });
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 8 })

      if (this.todayCourses.length === 0) {
        Text('今日无课程，好好休息吧～')
          .fontSize(FontSize.BODY)
          .fontColor(Theme.textSecondColor(this.isDarkMode))
          .padding(20)
          .width('100%')
          .textAlign(TextAlign.Center)
      } else {
        List() {
          ForEach(this.todayCourses, (course: Course) => {
            ListItem() {
              Row() {
                Column() {
                  Text(course.name)
                    .fontSize(FontSize.BODY)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(Theme.textColor(this.isDarkMode))
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Row() {
                    Text(this.slotTimeMap[course.startSlot] || '')
                      .fontSize(FontSize.TAG)
                      .fontColor(Theme.TEXT_SECOND)
                    Text(course.classroom)
                      .fontSize(FontSize.TAG)
                      .fontColor(Theme.TEXT_SECOND)
                      .margin({ left: 12 })
                  }
                  .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                // 检查是否正在上课（内联判断）
                if (this.currentHour >= 8 && this.currentHour <= 20) {
                  Text('上课中')
                    .fontSize(FontSize.TAG)
                    .fontColor(Theme.WHITE)
                    .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                    .borderRadius(10)
                    .backgroundColor(Theme.ACCENT_ORANGE)
                }
              }
              .width('100%')
              .padding(12)
              .backgroundColor(Theme.cardColor(this.isDarkMode))
              .borderRadius(8)
              .margin({ bottom: 6 })
            }
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
        .height(this.todayCourses.length * 62)
      }
    }
  }

  @Builder
  weatherCard() {
    Row() {
      Column() {
        Text('今日天气')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.WHITE)
          .opacity(0.9)
        Text(this.weather)
          .fontSize(FontSize.PAGE_TITLE)
          .fontWeight(FontWeight.Bold)
          .fontColor(Theme.WHITE)
          .margin({ top: 4 })
        Text('北京 · ' + this.dateStr)
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.WHITE)
          .opacity(0.9)
          .margin({ top: 2 })
      }
      .alignItems(HorizontalAlign.Start)

      Text(this.weatherIcon)
        .fontSize(48)
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 20, right: 20, top: 16, bottom: 16 })
    .margin({ left: 16, right: 16, top: 8 })
    .borderRadius(8)
    .linearGradient({
      direction: GradientDirection.Right,
      colors: [[Theme.PRIMARY_LIGHT_END, 0.0], [Theme.PRIMARY, 1.0]]
    })
  }

  @Builder
  shortcutGrid() {
    Column() {
      Text('功能入口')
        .fontSize(FontSize.MODULE_TITLE)
        .fontWeight(FontWeight.Medium)
        .fontColor(Theme.textColor(this.isDarkMode))
        .padding({ left: 16, top: 16, bottom: 8 })
        .width('100%')

      Grid() {
        ForEach(this.shortcutItems, (item: ShortcutItem) => {
          GridItem() {
            Column() {
              Text(item.icon)
                .fontSize(28)
              Text(item.title)
                .fontSize(FontSize.CAPTION)
                .fontColor(Theme.textSecondColor(this.isDarkMode))
                .margin({ top: 4 })
            }
            .width('100%')
            .height(80)
            .justifyContent(FlexAlign.Center)
            .borderRadius(8)
            .backgroundColor(Theme.cardColor(this.isDarkMode))
            .onClick(() => {
              router.pushUrl({ url: item.page });
            })
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsGap(10)
      .columnsGap(10)
      .padding({ left: 16, right: 16 })
      .height(200)
    }
  }

  @Builder
  announcementSection() {
    Column() {
      Row() {
        Text('校园公告')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.textColor(this.isDarkMode))
        Blank()
        Text('更多 >')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.PRIMARY)
          .onClick(() => {
            router.pushUrl({ url: Constants.PAGE_ANNOUNCEMENT_LIST });
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 8 })

      List() {
        ForEach(this.announcements, (item: Announcement) => {
          ListItem() {
            Row() {
              Text(item.title)
                .fontSize(FontSize.BODY)
                .fontColor(Theme.textColor(this.isDarkMode))
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Blank()
              Text(item.publishTime.substring(5, 10))
                .fontSize(FontSize.CAPTION)
                .fontColor(Theme.TEXT_SECOND)
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })
            .backgroundColor(Theme.cardColor(this.isDarkMode))
            .onClick(() => {
              router.pushUrl({ url: Constants.PAGE_ANNOUNCEMENT_DETAIL, params: { id: item.id } });
            })
          }
        })
      }
      .width('100%')
      .height(140)
      .divider({ strokeWidth: 0.5, color: Theme.BORDER })
    }
  }

  @Builder
  todoSection() {
    Column() {
      Row() {
        Text('待办提醒')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.textColor(this.isDarkMode))
        Blank()
        Text('更多 >')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.PRIMARY)
          .onClick(() => {
            router.pushUrl({ url: Constants.PAGE_TODO_MANAGE });
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 8 })

      if (this.todos.length === 0) {
        Text('暂无待办事项')
          .fontSize(FontSize.BODY)
          .fontColor(Theme.TEXT_SECOND)
          .padding(20)
      } else {
        List() {
          ForEach(this.todos, (item: TodoItem) => {
            ListItem() {
              Row() {
                Checkbox()
                  .select(item.isCompleted)
                  .selectedColor(Theme.PRIMARY)
                  .onChange((value: boolean) => {
                    item.isCompleted = value;
                    this.saveTodos();
                  })
                Text(item.content)
                  .fontSize(FontSize.BODY)
                  .fontColor(Theme.textColor(this.isDarkMode))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ left: 8 })
                  .decoration({ type: item.isCompleted ? TextDecorationType.LineThrough : TextDecorationType.None })
                Blank()
                Text(item.category)
                  .fontSize(FontSize.TAG)
                  .fontColor(Theme.WHITE)
                  .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                  .borderRadius(8)
                  .backgroundColor(item.category === '学习' ? Theme.PRIMARY : (item.category === '生活' ? Theme.ACCENT_GREEN : Theme.ACCENT_ORANGE))
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 10, bottom: 10 })
              .backgroundColor(Theme.cardColor(this.isDarkMode))
            }
          })
        }
        .width('100%')
        .height(this.todos.length * 50)
        .divider({ strokeWidth: 0.5, color: Theme.BORDER })
      }

      Row() {
        Button('+ 新增待办')
          .fontSize(FontSize.CAPTION)
          .height(36)
          .backgroundColor(Theme.PRIMARY)
          .borderRadius(8)
          .onClick(() => {
            router.pushUrl({ url: Constants.PAGE_TODO_MANAGE });
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .padding({ top: 8, bottom: 8 })
      .backgroundColor(Theme.cardColor(this.isDarkMode))
    }
  }

  async saveTodos(): Promise<void> {
    await PreferencesHelper.putObject(this.context, Constants.PREF_KEY_TODOS, this.todos);
  }
}