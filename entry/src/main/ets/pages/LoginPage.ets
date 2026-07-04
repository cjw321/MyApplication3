import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { Constants } from '../utils/Constants';
import { Theme, FontSize, Dimens } from '../utils/Theme';
import { PreferencesHelper } from '../data/PreferencesHelper';
import { MockData } from '../data/MockData';
import { UserInfo } from '../model/UserModel';

/**
 * 登录/注册页（合并布局，切换标签）
 * 文档2 §2.3：顶部标签栏切换「登录/注册」，表单淡入显示，
 * 简易前端校验，验证通过保存用户信息并跳转首页。
 */
@Entry
@Component
struct LoginPage {
  // 0=登录 1=注册
  @State currentTab: number = 0;

  // 登录表单
  @State loginId: string = '';
  @State loginPwd: string = '';
  @State showPwd: boolean = false;
  @State rememberPwd: boolean = false;

  // 注册表单
  @State regName: string = '';
  @State regId: string = '';
  @State regPwd: string = '';
  @State regConfirmPwd: string = '';
  @State regCode: string = '';
  @State agreeProtocol: boolean = false;

  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    this.loadSavedPwd();
  }

  async loadSavedPwd(): Promise<void> {
    const remember = await PreferencesHelper.getBoolean(this.context, Constants.PREF_KEY_REMEMBER_PWD, false);
    if (remember) {
      this.rememberPwd = true;
      this.loginId = await PreferencesHelper.getString(this.context, 'saved_login_id', '');
      this.loginPwd = await PreferencesHelper.getString(this.context, Constants.PREF_KEY_SAVED_PWD, '');
    }
  }

  // 登录必填是否齐备
  get loginReady(): boolean {
    return this.loginId.trim().length > 0 && this.loginPwd.trim().length > 0;
  }

  // 注册必填是否齐备
  get registerReady(): boolean {
    return this.regName.trim().length > 0 && this.regId.trim().length > 0
      && this.regPwd.trim().length > 0 && this.regConfirmPwd.trim().length > 0
      && this.regCode.trim().length > 0 && this.agreeProtocol;
  }

  doLogin(): void {
    if (!this.loginId.trim()) {
      promptAction.showToast({ message: '请输入学号' });
      return;
    }
    if (!this.loginPwd.trim()) {
      promptAction.showToast({ message: '请输入密码' });
      return;
    }
    // 记住密码
    PreferencesHelper.putBoolean(this.context, Constants.PREF_KEY_REMEMBER_PWD, this.rememberPwd);
    if (this.rememberPwd) {
      PreferencesHelper.putString(this.context, 'saved_login_id', this.loginId);
      PreferencesHelper.putString(this.context, Constants.PREF_KEY_SAVED_PWD, this.loginPwd);
    }
    // 保存登录态与用户信息（本地模拟）
    const user: UserInfo = MockData.getDefaultUser();
    user.studentId = this.loginId;
    if (user.nickname === '未设置昵称') {
      user.nickname = `同学${this.loginId.slice(-4)}`;
    }
    PreferencesHelper.putObject(this.context, Constants.PREF_KEY_USER_INFO, user);
    PreferencesHelper.putBoolean(this.context, Constants.PREF_KEY_LOGGED_IN, true);
    promptAction.showToast({ message: '登录成功' });
    setTimeout(() => router.replaceUrl({ url: Constants.PAGE_INDEX }), 500);
  }

  doRegister(): void {
    if (!this.regName.trim() || !this.regId.trim()) {
      promptAction.showToast({ message: '请填写姓名和学号' });
      return;
    }
    if (this.regPwd !== this.regConfirmPwd) {
      promptAction.showToast({ message: '两次密码不一致' });
      return;
    }
    if (!this.agreeProtocol) {
      promptAction.showToast({ message: '请同意注册协议' });
      return;
    }
    const user: UserInfo = MockData.getDefaultUser();
    user.nickname = this.regName;
    user.studentId = this.regId;
    PreferencesHelper.putObject(this.context, Constants.PREF_KEY_USER_INFO, user);
    PreferencesHelper.putBoolean(this.context, Constants.PREF_KEY_LOGGED_IN, true);
    promptAction.showToast({ message: '注册成功' });
    setTimeout(() => router.replaceUrl({ url: Constants.PAGE_INDEX }), 500);
  }

  build() {
    Column() {
      // 顶部标题
      Text(Constants.APP_NAME)
        .fontSize(FontSize.PAGE_TITLE)
        .fontWeight(FontWeight.Bold)
        .fontColor(Theme.PRIMARY)
        .margin({ top: 60, bottom: 8 })
      Text(Constants.APP_SUBTITLE)
        .fontSize(FontSize.CAPTION)
        .fontColor(Theme.TEXT_SECOND)
        .margin({ bottom: 32 })

      // 标签栏：登录 / 注册
      Row() {
        Column() {
          Text('登录')
            .fontSize(FontSize.MODULE_TITLE)
            .fontColor(this.currentTab === 0 ? Theme.PRIMARY : Theme.TEXT_SECOND)
          // 下划线
          Divider()
            .vertical(false)
            .strokeWidth(2)
            .color(this.currentTab === 0 ? Theme.PRIMARY : Theme.BG)
            .width(40)
            .margin({ top: 8 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .onClick(() => { this.currentTab = 0; })

        Column() {
          Text('注册')
            .fontSize(FontSize.MODULE_TITLE)
            .fontColor(this.currentTab === 1 ? Theme.PRIMARY : Theme.TEXT_SECOND)
          Divider()
            .vertical(false)
            .strokeWidth(2)
            .color(this.currentTab === 1 ? Theme.PRIMARY : Theme.BG)
            .width(40)
            .margin({ top: 8 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .onClick(() => { this.currentTab = 1; })
      }
      .width('90%')
      .margin({ bottom: 24 })

      // 表单区域
      if (this.currentTab === 0) {
        this.loginForm()
      } else {
        this.registerForm()
      }

      Blank().layoutWeight(1)

      // 底部：其他登录方式
      Column() {
        Text('其他登录方式')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.TEXT_SECOND)
        Row() {
          Text('💬')
            .fontSize(24)
            .width(40).height(40)
            .textAlign(TextAlign.Center)
          Text('🐧')
            .fontSize(24)
            .width(40).height(40)
            .textAlign(TextAlign.Center)
            .margin({ left: Dimens.GAP_ELEMENT })
        }
        .margin({ top: 12 })
      }
      .margin({ bottom: 30 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.BG)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  loginForm() {
    Column() {
      // 学号
      Row() {
        TextInput({ text: this.loginId, placeholder: '请输入你的学号' })
          .fontSize(FontSize.BODY)
          .fontColor(Theme.TEXT_PRIMARY)
          .backgroundColor(Theme.CARD)
          .layoutWeight(1)
          .onChange((v: string) => { this.loginId = v; })
      }
      .width('100%')
      .height(Dimens.BTN_HEIGHT)
      .borderRadius(Dimens.RADIUS)
      .backgroundColor(Theme.CARD)
      .border({ width: 1, color: Theme.BORDER })
      .padding({ left: 16, right: 16 })

      // 密码 + 显示/隐藏
      Row() {
        TextInput({ text: this.loginPwd, placeholder: '请输入你的密码' })
          .type(this.showPwd ? InputType.Normal : InputType.Password)
          .fontSize(FontSize.BODY)
          .fontColor(Theme.TEXT_PRIMARY)
          .backgroundColor(Theme.CARD)
          .layoutWeight(1)
          .onChange((v: string) => { this.loginPwd = v; })
        Text(this.showPwd ? '🙈' : '👁')
          .fontSize(22)
          .width(40)
          .textAlign(TextAlign.Center)
          .onClick(() => { this.showPwd = !this.showPwd; })
      }
      .width('100%')
      .height(Dimens.BTN_HEIGHT)
      .borderRadius(Dimens.RADIUS)
      .backgroundColor(Theme.CARD)
      .border({ width: 1, color: Theme.BORDER })
      .padding({ left: 16, right: 16 })
      .margin({ top: Dimens.GAP_ELEMENT })

      // 记住密码 / 忘记密码
      Row() {
        Row() {
          Checkbox()
            .select(this.rememberPwd)
            .selectedColor(Theme.PRIMARY)
            .onChange((v: boolean) => { this.rememberPwd = v; })
          Text('记住密码')
            .fontSize(FontSize.CAPTION)
            .fontColor(Theme.TEXT_SECOND)
        }
        Blank()
        Text('忘记密码')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.PRIMARY)
          .onClick(() => promptAction.showToast({ message: '请联系管理员重置密码' }))
      }
      .width('100%')
      .margin({ top: 12 })

      // 登录按钮
      Button('登录')
        .width('100%')
        .height(Dimens.BTN_HEIGHT)
        .fontSize(FontSize.BODY)
        .fontColor(Theme.WHITE)
        .backgroundColor(this.loginReady ? Theme.PRIMARY : Theme.PRIMARY_DISABLE)
        .borderRadius(Dimens.RADIUS)
        .margin({ top: Dimens.GAP_MODULE })
        .onClick(() => this.doLogin())

      // 切换注册
      Row() {
        Text('暂无账号？')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.TEXT_SECOND)
        Text('立即注册')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.PRIMARY)
          .onClick(() => { this.currentTab = 1; })
      }
      .margin({ top: 16 })
    }
    .width('90%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  registerForm() {
    Column() {
      this.regInput(this.regName, '请输入姓名', (v: string) => { this.regName = v; })
      this.regInput(this.regId, '请输入学号', (v: string) => { this.regId = v; })
      this.regInput(this.regPwd, '请输入密码', (v: string) => { this.regPwd = v; }, true)
      this.regInput(this.regConfirmPwd, '请确认密码', (v: string) => { this.regConfirmPwd = v; }, true)

      // 验证码 + 获取验证码
      Row() {
        TextInput({ text: this.regCode, placeholder: '请输入验证码' })
          .fontSize(FontSize.BODY)
          .fontColor(Theme.TEXT_PRIMARY)
          .backgroundColor(Theme.CARD)
          .layoutWeight(1)
          .onChange((v: string) => { this.regCode = v; })
        Button('获取验证码')
          .height(Dimens.BTN_HEIGHT_SM)
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.WHITE)
          .backgroundColor(Theme.ACCENT_ORANGE)
          .borderRadius(Dimens.RADIUS)
          .margin({ left: 12 })
          .onClick(() => promptAction.showToast({ message: '验证码已发送(模拟)' }))
      }
      .width('100%')
      .height(Dimens.BTN_HEIGHT)
      .borderRadius(Dimens.RADIUS)
      .border({ width: 1, color: Theme.BORDER })
      .padding({ left: 16, right: 0 })
      .margin({ top: Dimens.GAP_ELEMENT })

      // 注册协议
      Row() {
        Checkbox()
          .select(this.agreeProtocol)
          .selectedColor(Theme.PRIMARY)
          .onChange((v: boolean) => { this.agreeProtocol = v; })
        Text('我已阅读并同意')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.TEXT_SECOND)
        Text('《用户注册协议》')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.PRIMARY)
          .onClick(() => promptAction.showToast({ message: '用户注册协议(模拟)' }))
      }
      .margin({ top: 12 })

      // 注册按钮
      Button('注册')
        .width('100%')
        .height(Dimens.BTN_HEIGHT)
        .fontSize(FontSize.BODY)
        .fontColor(Theme.WHITE)
        .backgroundColor(this.registerReady ? Theme.PRIMARY : Theme.PRIMARY_DISABLE)
        .borderRadius(Dimens.RADIUS)
        .margin({ top: Dimens.GAP_MODULE })
        .onClick(() => this.doRegister())

      // 切换登录
      Row() {
        Text('已有账号？')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.TEXT_SECOND)
        Text('立即登录')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.PRIMARY)
          .onClick(() => { this.currentTab = 0; })
      }
      .margin({ top: 16 })
    }
    .width('90%')
    .alignItems(HorizontalAlign.Start)
  }

  // 注册表单通用输入框（避免 inputField 闭包在 ArkTS 中的限制）
  @Builder
  regInput(value: string, placeholder: string, onChange: (v: string) => void, password: boolean = false) {
    Row() {
      TextInput({ text: value, placeholder: placeholder })
        .type(password ? InputType.Password : InputType.Normal)
        .fontSize(FontSize.BODY)
        .fontColor(Theme.TEXT_PRIMARY)
        .backgroundColor(Theme.CARD)
        .layoutWeight(1)
        .onChange(onChange)
    }
    .width('100%')
    .height(Dimens.BTN_HEIGHT)
    .borderRadius(Dimens.RADIUS)
    .backgroundColor(Theme.CARD)
    .border({ width: 1, color: Theme.BORDER })
    .padding({ left: 16, right: 16 })
    .margin({ top: Dimens.GAP_ELEMENT })
  }
}
