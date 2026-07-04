import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { MockData } from '../../data/MockData';
import { Grade } from '../../model/GradeModel';
import { Theme, FontSize } from '../../utils/Theme';

@Entry
@Component
struct GradeQueryPage {
  @State studentId: string = '';
  @State password: string = '';
  @State isLoggedIn: boolean = false;
  @State grades: Grade[] = [];
  @State sortBy: number = 0;
  @State filterCategory: string = '全部';

  aboutToAppear(): void {
    // 模拟自动登录
    this.isLoggedIn = true;
    this.grades = MockData.getGrades();
  }

  doLogin(): void {
    if (!this.studentId.trim() || !this.password.trim()) {
      promptAction.showToast({ message: '请输入学号和密码', duration: 2000 });
      return;
    }
    this.isLoggedIn = true;
    this.grades = MockData.getGrades();
  }

  sortGrades(): void {
    if (this.sortBy === 1) {
      this.grades.sort((a, b) => b.score - a.score);
    } else if (this.sortBy === 2) {
      this.grades.sort((a, b) => a.score - b.score);
    } else if (this.sortBy === 3) {
      this.grades.sort((a, b) => b.gpa - a.gpa);
    }
  }

  get filteredGrades(): Grade[] {
    let result = this.grades;
    if (this.filterCategory !== '全部') {
      result = result.filter(g => g.category === this.filterCategory);
    }
    if (this.sortBy !== 0) {
      this.sortGrades();
    }
    return result;
  }

  // 绩点等级色：高=绿、中=蓝、低=橙、不及格=红
  getGpaColor(gpa: number): string {
    if (gpa >= 4.0) return Theme.ACCENT_GREEN;
    if (gpa >= 3.0) return Theme.PRIMARY;
    if (gpa >= 2.0) return Theme.ACCENT_ORANGE;
    return Theme.RED_DOT;
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor(Theme.PRIMARY)
          .onClick(() => router.back())
        Text('成绩查询')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      if (!this.isLoggedIn) {
        // 登录表单
        Column() {
          Text('请登录教务系统')
            .fontSize(FontSize.MODULE_TITLE)
            .fontWeight(FontWeight.Medium)
            .fontColor(Theme.TEXT_PRIMARY)
            .margin({ bottom: 24 })

          TextInput({ text: this.studentId, placeholder: '请输入学号' })
            .fontSize(FontSize.BODY)
            .fontColor(Theme.TEXT_PRIMARY)
            .width('80%')
            .height(48)
            .backgroundColor(Theme.BG)
            .borderRadius(8)
            .margin({ bottom: 12 })
            .onChange((v: string) => this.studentId = v)

          TextInput({ text: this.password, placeholder: '请输入密码' })
            .fontSize(FontSize.BODY)
            .fontColor(Theme.TEXT_PRIMARY)
            .width('80%')
            .height(48)
            .type(InputType.Password)
            .backgroundColor(Theme.BG)
            .borderRadius(8)
            .margin({ bottom: 24 })
            .onChange((v: string) => this.password = v)

          Button('登录查询')
            .fontSize(FontSize.BODY)
            .fontColor(Theme.WHITE)
            .width('80%')
            .height(48)
            .backgroundColor(Theme.PRIMARY)
            .borderRadius(8)
            .onClick(() => this.doLogin())
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Theme.CARD)
      } else {
        Column() {
          // 筛选和排序
          Row() {
            ForEach(['全部', '必修', '选修'], (cat: string) => {
              Text(cat)
                .fontSize(FontSize.CAPTION)
                .fontColor(this.filterCategory === cat ? Theme.WHITE : Theme.TEXT_SECOND)
                .padding({ left: 10, right: 10, top: 5, bottom: 5 })
                .borderRadius(12)
                .backgroundColor(this.filterCategory === cat ? Theme.PRIMARY : Theme.BG)
                .margin({ right: 8 })
                .onClick(() => {
                  this.filterCategory = cat;
                })
            })
            Blank()
            Select([{ value: '默认排序' }, { value: '分数↓' }, { value: '分数↑' }, { value: '绩点↓' }])
              .selected(this.sortBy)
              .value('默认排序')
              .height(36)
              .onSelect((index: number, value: string) => {
                this.sortBy = index;
              })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
          .backgroundColor(Theme.CARD)

          // 成绩列表
          List() {
            ListItem() {
              Row() {
                Text('课程名称').fontSize(FontSize.CAPTION).fontColor(Theme.TEXT_SECOND).width('40%')
                Text('成绩').fontSize(FontSize.CAPTION).fontColor(Theme.TEXT_SECOND).width('15%').textAlign(TextAlign.Center)
                Text('绩点').fontSize(FontSize.CAPTION).fontColor(Theme.TEXT_SECOND).width('15%').textAlign(TextAlign.Center)
                Text('学分').fontSize(FontSize.CAPTION).fontColor(Theme.TEXT_SECOND).width('15%').textAlign(TextAlign.Center)
                Text('类别').fontSize(FontSize.CAPTION).fontColor(Theme.TEXT_SECOND).width('15%').textAlign(TextAlign.Center)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 8, bottom: 8 })
              .backgroundColor(Theme.BG)
            }

            ForEach(this.filteredGrades, (grade: Grade) => {
              ListItem() {
                Row() {
                  Text(grade.courseName)
                    .fontSize(FontSize.BODY)
                    .fontColor(Theme.TEXT_PRIMARY)
                    .width('40%')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(`${grade.score}`)
                    .fontSize(FontSize.BODY)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(grade.score >= 90 ? Theme.ACCENT_GREEN : (grade.score >= 60 ? Theme.TEXT_PRIMARY : Theme.RED_DOT))
                    .width('15%')
                    .textAlign(TextAlign.Center)
                  Text(grade.gpa.toFixed(1))
                    .fontSize(FontSize.BODY)
                    .fontColor(this.getGpaColor(grade.gpa))
                    .width('15%')
                    .textAlign(TextAlign.Center)
                  Text(`${grade.credit}`)
                    .fontSize(FontSize.BODY)
                    .fontColor(Theme.TEXT_PRIMARY)
                    .width('15%')
                    .textAlign(TextAlign.Center)
                  Text(grade.category)
                    .fontSize(FontSize.TAG)
                    .fontColor(Theme.TEXT_SECOND)
                    .width('15%')
                    .textAlign(TextAlign.Center)
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              }
            })
          }
          .width('100%')
          .layoutWeight(1)
          .divider({ strokeWidth: 0.5, color: Theme.BORDER })
          .backgroundColor(Theme.CARD)
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
  }
}
