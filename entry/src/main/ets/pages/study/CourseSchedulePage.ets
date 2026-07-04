import { router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { MockData } from '../../data/MockData';
import { Course } from '../../model/CourseModel';
import { Constants } from '../../utils/Constants';
import { PreferencesHelper } from '../../data/PreferencesHelper';
import { Theme, FontSize } from '../../utils/Theme';

@Entry
@Component
struct CourseSchedulePage {
  @State courses: Course[] = [];
  @State currentWeek: number = 16; // 当前教学周
  @State weekdays: string[] = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  @State timeSlots: string[] = ['1-2节\n8:00-9:40', '3-4节\n10:00-11:40', '5-6节\n14:00-15:40', '7-8节\n16:00-17:40', '9-10节\n19:00-20:40'];

  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    this.loadCourses();
  }

  async loadCourses(): Promise<void> {
    const saved = await PreferencesHelper.getObject<Course[]>(this.context, Constants.PREF_KEY_COURSES, []);
    this.courses = saved.length > 0 ? saved : MockData.getCourses();
  }

  getWeekCourses(weekday: number): Course[] {
    return this.courses.filter(c => c.weekday === weekday && c.weeks.includes(this.currentWeek));
  }

  // 课程区分色：前 3 个用规范主/绿/橙，后续保留区分色
  getCourseColor(courseId: number): string {
    const colors = [Theme.PRIMARY, Theme.ACCENT_GREEN, Theme.ACCENT_ORANGE, '#F53F3F', '#722ED1', '#08979C', '#D4380D', '#531DAB'];
    return colors[courseId % colors.length];
  }

  async deleteCourse(id: number): Promise<void> {
    this.courses = this.courses.filter(c => c.id !== id);
    await PreferencesHelper.putObject(this.context, Constants.PREF_KEY_COURSES, this.courses);
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor(Theme.PRIMARY)
          .onClick(() => router.back())
        Text('课程表')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
        Blank()
        Button('+ 添加')
          .fontSize(FontSize.CAPTION)
          .height(36)
          .backgroundColor(Theme.PRIMARY)
          .borderRadius(8)
          .onClick(() => {
            router.pushUrl({ url: Constants.PAGE_COURSE_EDIT });
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      // 周次切换
      Row() {
        Text('‹')
          .fontSize(20)
          .fontColor(Theme.PRIMARY)
          .onClick(() => {
            if (this.currentWeek > 1) {
              this.currentWeek--;
            }
          })
        Text(`第 ${this.currentWeek} 周`)
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 16, right: 16 })
        Text('›')
          .fontSize(20)
          .fontColor(Theme.PRIMARY)
          .onClick(() => {
            if (this.currentWeek < 20) {
              this.currentWeek++;
            }
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .padding({ top: 10, bottom: 10 })
      .backgroundColor(Theme.CARD)

      // 课程表
      Scroll() {
        Row() {
          // 时间列
          Column() {
            // 占位
            Text('')
              .width(50)
              .height(40)
            ForEach(this.timeSlots, (slot: string) => {
              Text(slot)
                .fontSize(9)
                .fontColor(Theme.TEXT_SECOND)
                .width(50)
                .height(60)
                .textAlign(TextAlign.Center)
                .border({ width: 0.5, color: Theme.BORDER })
            })
          }

          // 每天的课程
          ForEach(this.weekdays, (day: string, dayIdx: number) => {
            Column() {
              Text(day)
                .fontSize(FontSize.CAPTION)
                .fontWeight(FontWeight.Medium)
                .fontColor(Theme.TEXT_PRIMARY)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .backgroundColor(Theme.BG)
                .border({ width: 0.5, color: Theme.BORDER })

              ForEach(this.timeSlots, (slot: string, slotIdx: number) => {
                Column() {
                  ForEach(this.getWeekCourses(dayIdx + 1).filter(c => c.startSlot === slotIdx * 2 + 1), (course: Course) => {
                    Column() {
                      Text(course.name)
                        .fontSize(9)
                        .fontWeight(FontWeight.Medium)
                        .fontColor(Theme.WHITE)
                        .maxLines(2)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                      Text(course.classroom)
                        .fontSize(8)
                        .fontColor(Theme.WHITE)
                        .opacity(0.8)
                        .margin({ top: 2 })
                    }
                    .width('100%')
                    .height('100%')
                    .padding(2)
                    .borderRadius(4)
                    .backgroundColor(this.getCourseColor(course.id))
                    .onClick(() => {
                      router.pushUrl({ url: Constants.PAGE_COURSE_EDIT, params: { courseId: course.id } });
                    })
                  })
                }
                .width('100%')
                .height(60)
                .border({ width: 0.5, color: Theme.BORDER })
                .padding(2)
              })
            }
            .layoutWeight(1)
          })
        }
        .width('100%')
        .padding({ left: 4, right: 4 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor(Theme.CARD)
    }
    .width('100%')
    .height('100%')
  }
}
