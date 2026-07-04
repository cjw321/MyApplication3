import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { Course } from '../../model/CourseModel';
import { Constants } from '../../utils/Constants';
import { PreferencesHelper } from '../../data/PreferencesHelper';
import { MockData } from '../../data/MockData';
import { Theme, FontSize } from '../../utils/Theme';

@Entry
@Component
struct CourseEditPage {
  @State course: Course = new Course();
  @State isEdit: boolean = false;
  @State selectedWeeks: boolean[] = new Array(20).fill(false);

  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    if (params && params['courseId']) {
      this.isEdit = true;
      this.loadCourse((params['courseId'] as number));
    } else {
      // 生成新ID
      this.course.id = Date.now();
    }
  }

  async loadCourse(id: number): Promise<void> {
    const saved = await PreferencesHelper.getObject<Course[]>(this.context, Constants.PREF_KEY_COURSES, []);
    const all = saved.length > 0 ? saved : MockData.getCourses();
    const found = all.find(c => c.id === id);
    if (found) {
      this.course = found;
      for (const w of this.course.weeks) {
        if (w >= 1 && w <= 20) {
          this.selectedWeeks[w - 1] = true;
        }
      }
    }
  }

  toggleWeek(idx: number): void {
    this.selectedWeeks[idx] = !this.selectedWeeks[idx];
  }

  async saveCourse(): Promise<void> {
    if (!this.course.name.trim()) {
      promptAction.showToast({ message: '请输入课程名称', duration: 2000 });
      return;
    }

    const weeks: number[] = [];
    this.selectedWeeks.forEach((selected, idx) => {
      if (selected) weeks.push(idx + 1);
    });
    this.course.weeks = weeks;

    const saved = await PreferencesHelper.getObject<Course[]>(this.context, Constants.PREF_KEY_COURSES, []);
    let all = saved.length > 0 ? saved : MockData.getCourses();

    if (this.isEdit) {
      all = all.map(c => c.id === this.course.id ? this.course : c);
    } else {
      all.push(this.course);
    }
    await PreferencesHelper.putObject(this.context, Constants.PREF_KEY_COURSES, all);
    promptAction.showToast({ message: '保存成功', duration: 2000 });
    setTimeout(() => router.back(), 500);
  }

  build() {
    Column() {
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor(Theme.PRIMARY)
          .onClick(() => router.back())
        Text(this.isEdit ? '编辑课程' : '添加课程')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
        Blank()
        Button('保存')
          .fontSize(FontSize.CAPTION)
          .height(36)
          .backgroundColor(Theme.PRIMARY)
          .borderRadius(8)
          .onClick(() => this.saveCourse())
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      Scroll() {
        Column() {
          // 课程名称
          this.inputRow('课程名称', '请输入课程名称', this.course.name, (v: string) => this.course.name = v)
          this.inputRow('授课老师', '请输入授课老师', this.course.teacher, (v: string) => this.course.teacher = v)
          this.inputRow('上课地点', '请输入上课地点', this.course.classroom, (v: string) => this.course.classroom = v)
          this.inputRow('学分', '请输入学分', this.course.credit.toString(), (v: string) => this.course.credit = parseInt(v) || 0)

          // 上课时间
          Text('上课星期')
            .fontSize(14)
            .fontColor(Theme.TEXT_SECOND)
            .padding({ left: 16, top: 12, bottom: 8 })
            .width('100%')
          Row() {
            ForEach(['周一','周二','周三','周四','周五','周六','周日'], (day: string, idx: number) => {
              Text(day)
                .fontSize(12)
                .fontColor(this.course.weekday === idx + 1 ? Theme.WHITE : Theme.TEXT_SECOND)
                .padding({ left: 8, right: 8, top: 6, bottom: 6 })
                .borderRadius(14)
                .backgroundColor(this.course.weekday === idx + 1 ? Theme.PRIMARY : Theme.BG)
                .margin({ right: 4 })
                .onClick(() => { this.course.weekday = idx + 1; })
            })
          }
          .width('100%')
          .padding({ left: 16, right: 16 })

          Text('上课节次')
            .fontSize(14)
            .fontColor(Theme.TEXT_SECOND)
            .padding({ left: 16, top: 12, bottom: 8 })
            .width('100%')
          Row() {
            Text(`第 ${this.course.startSlot} 节 至 第 ${this.course.endSlot} 节`)
              .fontSize(13)
              .layoutWeight(1)
            Row() {
              Button('-')
                .fontSize(14)
                .width(36).height(30)
                .onClick(() => { if(this.course.startSlot > 1) this.course.startSlot--; })
              Text(`${this.course.startSlot}`).fontSize(14).margin({ left: 8, right: 8 })
              Button('+')
                .fontSize(14)
                .width(36).height(30)
                .onClick(() => { if(this.course.startSlot < 10) this.course.startSlot++; })
              Text(' - ').fontSize(14)
              Button('-')
                .fontSize(14)
                .width(36).height(30)
                .onClick(() => { if(this.course.endSlot > this.course.startSlot) this.course.endSlot--; })
              Text(`${this.course.endSlot}`).fontSize(14).margin({ left: 8, right: 8 })
              Button('+')
                .fontSize(14)
                .width(36).height(30)
                .onClick(() => { if(this.course.endSlot < 10) this.course.endSlot++; })
            }
          }
          .width('100%')
          .padding({ left: 16, right: 16 })
          .justifyContent(FlexAlign.SpaceBetween)

          // 上课周次
          Text('上课周次（点击选择）')
            .fontSize(14)
            .fontColor(Theme.TEXT_SECOND)
            .padding({ left: 16, top: 12, bottom: 8 })
            .width('100%')
          Grid() {
            ForEach(this.selectedWeeks, (checked: boolean, idx: number) => {
              GridItem() {
                Text(`${idx + 1}`)
                  .fontSize(11)
                  .fontColor(checked ? Theme.WHITE : Theme.TEXT_SECOND)
                  .width('100%')
                  .height(28)
                  .textAlign(TextAlign.Center)
                  .borderRadius(14)
                  .backgroundColor(checked ? Theme.PRIMARY : Theme.BG)
                  .onClick(() => this.toggleWeek(idx))
              }
            })
          }
          .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
          .rowsGap(6)
          .columnsGap(6)
          .padding({ left: 16, right: 16 })

          // 提醒
          Text('课程提醒（提前）')
            .fontSize(14)
            .fontColor(Theme.TEXT_SECOND)
            .padding({ left: 16, top: 12, bottom: 8 })
            .width('100%')
          Row() {
            ForEach([5, 10, 15, 30], (minute: number) => {
              Text(`${minute}分钟`)
                .fontSize(12)
                .fontColor(this.course.remindBeforeMin === minute ? Theme.WHITE : Theme.TEXT_SECOND)
                .padding({ left: 10, right: 10, top: 5, bottom: 5 })
                .borderRadius(14)
                .backgroundColor(this.course.remindBeforeMin === minute ? Theme.PRIMARY : Theme.BG)
                .margin({ right: 8 })
                .onClick(() => { this.course.remindBeforeMin = minute; })
            })
          }
          .width('100%')
          .padding({ left: 16, right: 16 })

          // 备注
          this.inputRow('备注', '备注（选填）', this.course.note, (v: string) => this.course.note = v)

          Blank().height(30)
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor(Theme.WHITE)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  inputRow(label: string, placeholder: string, value: string, onChange: (v: string) => void) {
    Row() {
      Text(label)
        .fontSize(14)
        .fontColor(Theme.TEXT_SECOND)
        .width(80)
      TextInput({ text: value, placeholder: placeholder })
        .fontSize(14)
        .layoutWeight(1)
        .backgroundColor(Theme.BG)
        .borderRadius(8)
        .padding({ left: 10 })
        .onChange(onChange)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 10, bottom: 4 })
  }
}
