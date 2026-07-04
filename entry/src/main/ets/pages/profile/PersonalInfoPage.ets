import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { PreferencesHelper } from '../../data/PreferencesHelper';
import { MockData } from '../../data/MockData';
import { UserInfo } from '../../model/UserModel';
import { Constants } from '../../utils/Constants';
import { Theme, FontSize } from '../../utils/Theme';
import { MediaHelper } from '../../utils/MediaHelper';

@Entry
@Component
struct PersonalInfoPage {
  @State userInfo: UserInfo = MockData.getDefaultUser();

  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    this.loadInfo();
  }

  async loadInfo(): Promise<void> {
    const saved = await PreferencesHelper.getObject<UserInfo>(this.context, Constants.PREF_KEY_USER_INFO, MockData.getDefaultUser());
    this.userInfo = saved;
  }

  async saveInfo(): Promise<void> {
    await PreferencesHelper.putObject(this.context, Constants.PREF_KEY_USER_INFO, this.userInfo);
    promptAction.showToast({ message: '保存成功', duration: 2000 });
  }

  async pickAvatar(): Promise<void> {
    const uris = await MediaHelper.pickImage(1);
    if (uris.length > 0) {
      this.userInfo.avatarUri = uris[0];
      await PreferencesHelper.putObject(this.context, Constants.PREF_KEY_USER_INFO, this.userInfo);
    }
  }

  build() {
    Column() {
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor(Theme.PRIMARY)
          .onClick(() => router.back())
        Text('个人信息')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
        Blank()
        Button('保存')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.WHITE)
          .height(36)
          .backgroundColor(Theme.PRIMARY)
          .borderRadius(8)
          .onClick(() => this.saveInfo())
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      Scroll() {
        Column() {
          // 头像
          Column() {
            if (this.userInfo.avatarUri) {
              Image(this.userInfo.avatarUri)
                .width(72)
                .height(72)
                .borderRadius(36)
                .objectFit(ImageFit.Cover)
            } else {
              Text('👤')
                .fontSize(48)
            }
            Text('点击更换头像')
              .fontSize(FontSize.CAPTION)
              .fontColor(Theme.PRIMARY)
              .margin({ top: 8 })
          }
          .width('100%')
          .padding({ top: 24, bottom: 24 })
          .backgroundColor(Theme.CARD)
          .onClick(() => {
            this.pickAvatar();
          })

          Divider().strokeWidth(8).color(Theme.BG)

          this.editRow('昵称', this.userInfo.nickname, (v: string) => this.userInfo.nickname = v)
          this.editRow('学号', this.userInfo.studentId, (v: string) => this.userInfo.studentId = v)
          this.editRow('学院', this.userInfo.college, (v: string) => this.userInfo.college = v)
          this.editRow('专业', this.userInfo.major, (v: string) => this.userInfo.major = v)
          this.editRow('年级', this.userInfo.grade, (v: string) => this.userInfo.grade = v)
          this.editRow('手机号', this.userInfo.phone, (v: string) => this.userInfo.phone = v)
          this.editRow('邮箱', this.userInfo.email, (v: string) => this.userInfo.email = v)

          // 密码修改
          Divider().strokeWidth(8).color(Theme.BG)

          Row() {
            Text('修改密码')
              .fontSize(FontSize.BODY)
              .fontColor(Theme.PRIMARY)
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .padding(20)
          .backgroundColor(Theme.CARD)
          .onClick(() => {
            promptAction.showToast({ message: '模拟密码修改功能', duration: 1500 });
          })

          Blank().height(20)
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  editRow(label: string, value: string, onChange: (v: string) => void) {
    Row() {
      Text(label)
        .fontSize(FontSize.BODY)
        .fontColor(Theme.TEXT_SECOND)
        .width(60)
      TextInput({ text: value, placeholder: `请输入${label}` })
        .fontSize(FontSize.BODY)
        .fontColor(Theme.TEXT_PRIMARY)
        .layoutWeight(1)
        .backgroundColor(Theme.BG)
        .borderRadius(8)
        .padding({ left: 10 })
        .onChange(onChange)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .backgroundColor(Theme.CARD)
    .border({ width: { bottom: 0.5 }, color: Theme.BORDER })
  }
}