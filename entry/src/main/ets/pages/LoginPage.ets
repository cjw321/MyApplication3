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

  // 验证码倒计时
  @State codeCountdown: number = 0;
  private codeTimer: number = -1;

  // 按钮加载态
  @State loginLoading: boolean = false;
  @State registerLoading: boolean = false;

  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    this.loadSavedPwd();
  }

  aboutToDisappear(): void {
    if (this.codeTimer !== -1) {
      clearInterval(this.codeTimer);
      this.codeTimer = -1;
    }
  }

  async loadSavedPwd(): Promise<void> {
    const remember = await PreferencesHelper.getBoolean(this.context, Constants.PREF_KEY_REMEMBER_PWD, false);
    if (remember) {
      this.rememberPwd = true;
      this.loginId = await PreferencesHelper.getString(this.context, 'saved_login_id', '');
      this.loginPwd = await PreferencesHelper.getString(this.context, Constants.PREF_KEY_SAVED_PWD, '');
    }
  }

	get loginReady(): boolean {
    return true;
  }

  get registerReady(): boolean {
    return this.regName.trim().length > 0 && this.regId.trim().length > 0
      && this.regPwd.trim().length > 0 && this.regConfirmPwd.trim().length > 0
      && this.regCode.trim().length > 0 && this.agreeProtocol;
  }

  startCodeCountdown(): void {
    if (this.codeCountdown > 0) return;
    this.codeCountdown = 60;
    promptAction.showToast({ message: '验证码已发送(模拟)' });
    this.codeTimer = setInterval(() => {
      this.codeCountdown--;
      if (this.codeCountdown <= 0) {
        if (this.codeTimer !== -1) {
          clearInterval(this.codeTimer);
          this.codeTimer = -1;
        }
      }
    }, 1000);
  }

  doLogin(): void {
    this.loginLoading = true;
    setTimeout(() => {
      PreferencesHelper.putBoolean(this.context, Constants.PREF_KEY_REMEMBER_PWD, this.rememberPwd);
      if (this.rememberPwd) {
        PreferencesHelper.putString(this.context, 'saved_login_id', this.loginId);
        PreferencesHelper.putString(this.context, Constants.PREF_KEY_SAVED_PWD, this.loginPwd);
      }
      const user: UserInfo = MockData.getDefaultUser();
      user.studentId = this.loginId || '2024001';
      if (user.nickname === '未设置昵称') {
        user.nickname = `同学${(this.loginId || '2024001').slice(-4)}`;
      }
      PreferencesHelper.putObject(this.context, Constants.PREF_KEY_USER_INFO, user);
      PreferencesHelper.putBoolean(this.context, Constants.PREF_KEY_LOGGED_IN, true);
      this.loginLoading = false;
      promptAction.showToast({ message: '登录成功' });
      setTimeout(() => router.replaceUrl({ url: Constants.PAGE_INDEX }), 500);
    }, 800);
  }

  doRegister(): void {
    if (!this.regName.trim() || !this.regId.trim()) {
      promptAction.showToast({ message: '请填写姓名和学号' });
      return;
    }
    if (this.regPwd.length < 6) {
      promptAction.showToast({ message: '密码长度至少6位' });
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
    this.registerLoading = true;
    setTimeout(() => {
      const user: UserInfo = MockData.getDefaultUser();
      user.nickname = this.regName;
      user.studentId = this.regId;
      PreferencesHelper.putObject(this.context, Constants.PREF_KEY_USER_INFO, user);
      PreferencesHelper.putBoolean(this.context, Constants.PREF_KEY_LOGGED_IN, true);
      this.registerLoading = false;
      promptAction.showToast({ message: '注册成功' });
      setTimeout(() => router.replaceUrl({ url: Constants.PAGE_INDEX }), 500);
    }, 800);
  }

  build() {
    Column() {
      // 标题
      Text(Constants.APP_NAME)
        .fontSize(FontSize.PAGE_TITLE)
        .fontWeight(FontWeight.Bold)
        .fontColor(Theme.PRIMARY)
        .margin({ top: 60, bottom: 4 })
      Text(Constants.APP_SUBTITLE)
        .fontSize(FontSize.CAPTION)
        .fontColor(Theme.TEXT_SECOND)
        .margin({ bottom: 32 })

      // 标签栏
      Row() {
        Column() {
          Text('登录')
            .fontSize(FontSize.MODULE_TITLE)
            .fontColor(this.currentTab === 0 ? Theme.PRIMARY : Theme.TEXT_SECOND)
            .fontWeight(this.currentTab === 0 ? FontWeight.Medium : FontWeight.Regular)
          Divider().vertical(false).strokeWidth(2)
            .color(this.currentTab === 0 ? Theme.PRIMARY : Theme.BORDER)
            .width(40).margin({ top: 8 })
        }
        .layoutWeight(1).alignItems(HorizontalAlign.Center)
        .onClick(() => { this.currentTab = 0; })

        Column() {
          Text('注册')
            .fontSize(FontSize.MODULE_TITLE)
            .fontColor(this.currentTab === 1 ? Theme.PRIMARY : Theme.TEXT_SECOND)
            .fontWeight(this.currentTab === 1 ? FontWeight.Medium : FontWeight.Regular)
          Divider().vertical(false).strokeWidth(2)
            .color(this.currentTab === 1 ? Theme.PRIMARY : Theme.BORDER)
            .width(40).margin({ top: 8 })
        }
        .layoutWeight(1).alignItems(HorizontalAlign.Center)
        .onClick(() => { this.currentTab = 1; })
      }
      .width('90%')
      .margin({ bottom: Dimens.GAP_MODULE })

      // 表单区域（Scroll 包裹，键盘弹出时可滚动）
      Scroll() {
        if (this.currentTab === 0) {
          this.loginForm()
        } else {
          this.registerForm()
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      // 其他登录方式
      Column() {
        Row() {
          Divider().vertical(false).strokeWidth(0.5).color(Theme.BORDER)
            .layoutWeight(1).margin({ top: 8 })
          Text('  其他登录方式  ')
            .fontSize(FontSize.CAPTION).fontColor(Theme.TEXT_SECOND)
          Divider().vertical(false).strokeWidth(0.5).color(Theme.BORDER)
            .layoutWeight(1).margin({ top: 8 })
        }
        .width('90%')
        .margin({ bottom: 16 })

        Row({ space: 24 }) {
          Column() {
            Column() {
              Text('微').fontSize(16).fontColor(Theme.WHITE).fontWeight(FontWeight.Bold)
            }
            .width(40).height(40)
            .borderRadius(20)
            .backgroundColor('#07C160')
            .justifyContent(FlexAlign.Center)
          }.onClick(() => promptAction.showToast({ message: '微信登录(模拟)' }))

          Column() {
            Column() {
              Text('Q').fontSize(18).fontColor(Theme.WHITE).fontWeight(FontWeight.Bold)
            }
            .width(40).height(40)
            .borderRadius(20)
            .backgroundColor('#12B7F5')
            .justifyContent(FlexAlign.Center)
          }.onClick(() => promptAction.showToast({ message: 'QQ登录(模拟)' }))
        }
      }
      .margin({ bottom: 40 })
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
        Text('👤').fontSize(18).width(24).textAlign(TextAlign.Center).fontColor(Theme.TEXT_SECOND)
        TextInput({ text: this.loginId, placeholder: '请输入你的学号' })
          .fontSize(FontSize.BODY).fontColor(Theme.TEXT_PRIMARY)
          .backgroundColor(Theme.TRANSPARENT).layoutWeight(1).placeholderColor(Theme.TEXT_SECOND)
          .onChange((v: string) => { this.loginId = v; })
      }
      .width('100%').height(Dimens.BTN_HEIGHT).borderRadius(Dimens.RADIUS)
      .backgroundColor(Theme.CARD).border({ width: 1, color: Theme.BORDER })
      .padding({ left: 12, right: 12 })

      // 密码 + 显示/隐藏
      Row() {
        Text('🔒').fontSize(18).width(24).textAlign(TextAlign.Center).fontColor(Theme.TEXT_SECOND)
        TextInput({ text: this.loginPwd, placeholder: '请输入你的密码' })
          .type(this.showPwd ? InputType.Normal : InputType.Password)
          .fontSize(FontSize.BODY).fontColor(Theme.TEXT_PRIMARY)
          .backgroundColor(Theme.TRANSPARENT).layoutWeight(1).placeholderColor(Theme.TEXT_SECOND)
          .onChange((v: string) => { this.loginPwd = v; })
        Text(this.showPwd ? '👁' : '🙈')
          .fontSize(20).width(28).textAlign(TextAlign.Center)
          .onClick(() => { this.showPwd = !this.showPwd; })
      }
      .width('100%').height(Dimens.BTN_HEIGHT).borderRadius(Dimens.RADIUS)
      .backgroundColor(Theme.CARD).border({ width: 1, color: Theme.BORDER })
      .padding({ left: 12, right: 12 })
      .margin({ top: Dimens.GAP_ELEMENT })

      // 记住密码 / 忘记密码
      Row() {
        Row() {
          Checkbox().select(this.rememberPwd).selectedColor(Theme.PRIMARY)
            .onChange((v: boolean) => { this.rememberPwd = v; })
          Text('记住密码').fontSize(FontSize.CAPTION).fontColor(Theme.TEXT_SECOND).margin({ left: 4 })
        }
        Blank()
        Text('忘记密码？').fontSize(FontSize.CAPTION).fontColor(Theme.PRIMARY)
          .onClick(() => this.showForgetPwdDialog())
      }
      .width('100%')
      .margin({ top: 12 })

      // 登录按钮
      Button() {
        Text('登录').fontSize(16).fontColor('#FFFFFF')
      }
      .width('100%').height(48)
      .backgroundColor('#1677FF')
      .borderRadius(8).margin({ top: 24 })
      .onClick(() => {
        router.replaceUrl({ url: 'pages/Index' });
      })

      // 切换注册
      Row() {
        Text('暂无账号？').fontSize(FontSize.CAPTION).fontColor(Theme.TEXT_SECOND)
        Text('立即注册').fontSize(FontSize.CAPTION).fontColor(Theme.PRIMARY).fontWeight(FontWeight.Medium)
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
      // 姓名
      Row() {
        Text('📝').fontSize(18).width(24).textAlign(TextAlign.Center).fontColor(Theme.TEXT_SECOND)
        TextInput({ text: this.regName, placeholder: '请输入姓名' })
          .fontSize(FontSize.BODY).fontColor(Theme.TEXT_PRIMARY)
          .backgroundColor(Theme.TRANSPARENT).layoutWeight(1).placeholderColor(Theme.TEXT_SECOND)
          .onChange((v: string) => { this.regName = v; })
      }
      .width('100%').height(Dimens.BTN_HEIGHT).borderRadius(Dimens.RADIUS)
      .backgroundColor(Theme.CARD).border({ width: 1, color: Theme.BORDER })
      .padding({ left: 12, right: 12 })

      // 学号
      Row() {
        Text('👤').fontSize(18).width(24).textAlign(TextAlign.Center).fontColor(Theme.TEXT_SECOND)
        TextInput({ text: this.regId, placeholder: '请输入学号' })
          .fontSize(FontSize.BODY).fontColor(Theme.TEXT_PRIMARY)
          .backgroundColor(Theme.TRANSPARENT).layoutWeight(1).placeholderColor(Theme.TEXT_SECOND)
          .onChange((v: string) => { this.regId = v; })
      }
      .width('100%').height(Dimens.BTN_HEIGHT).borderRadius(Dimens.RADIUS)
      .backgroundColor(Theme.CARD).border({ width: 1, color: Theme.BORDER })
      .padding({ left: 12, right: 12 })
      .margin({ top: Dimens.GAP_ELEMENT })

      // 密码
      Row() {
        Text('🔒').fontSize(18).width(24).textAlign(TextAlign.Center).fontColor(Theme.TEXT_SECOND)
        TextInput({ text: this.regPwd, placeholder: '请输入密码(至少6位)' })
          .type(InputType.Password)
          .fontSize(FontSize.BODY).fontColor(Theme.TEXT_PRIMARY)
          .backgroundColor(Theme.TRANSPARENT).layoutWeight(1).placeholderColor(Theme.TEXT_SECOND)
          .onChange((v: string) => { this.regPwd = v; })
      }
      .width('100%').height(Dimens.BTN_HEIGHT).borderRadius(Dimens.RADIUS)
      .backgroundColor(Theme.CARD).border({ width: 1, color: Theme.BORDER })
      .padding({ left: 12, right: 12 })
      .margin({ top: Dimens.GAP_ELEMENT })

      // 确认密码
      Row() {
        Text('🔒').fontSize(18).width(24).textAlign(TextAlign.Center).fontColor(Theme.TEXT_SECOND)
        TextInput({ text: this.regConfirmPwd, placeholder: '请确认密码' })
          .type(InputType.Password)
          .fontSize(FontSize.BODY).fontColor(Theme.TEXT_PRIMARY)
          .backgroundColor(Theme.TRANSPARENT).layoutWeight(1).placeholderColor(Theme.TEXT_SECOND)
          .onChange((v: string) => { this.regConfirmPwd = v; })
      }
      .width('100%').height(Dimens.BTN_HEIGHT).borderRadius(Dimens.RADIUS)
      .backgroundColor(Theme.CARD).border({ width: 1, color: Theme.BORDER })
      .padding({ left: 12, right: 12 })
      .margin({ top: Dimens.GAP_ELEMENT })

      // 验证码
      Row() {
        Text('📱').fontSize(18).width(24).textAlign(TextAlign.Center).fontColor(Theme.TEXT_SECOND)
        TextInput({ text: this.regCode, placeholder: '请输入验证码' })
          .fontSize(FontSize.BODY).fontColor(Theme.TEXT_PRIMARY)
          .backgroundColor(Theme.TRANSPARENT).layoutWeight(1).placeholderColor(Theme.TEXT_SECOND)
          .onChange((v: string) => { this.regCode = v; })
        Button(this.codeCountdown > 0 ? `${this.codeCountdown}s` : '获取验证码')
          .height(Dimens.BTN_HEIGHT_SM).fontSize(FontSize.CAPTION).fontColor(Theme.WHITE)
          .backgroundColor(this.codeCountdown > 0 ? Theme.TEXT_SECOND : Theme.ACCENT_ORANGE)
          .borderRadius(Dimens.RADIUS).margin({ left: 8 })
          .enabled(this.codeCountdown <= 0)
          .onClick(() => this.startCodeCountdown())
      }
      .width('100%').height(Dimens.BTN_HEIGHT).borderRadius(Dimens.RADIUS)
      .backgroundColor(Theme.CARD).border({ width: 1, color: Theme.BORDER })
      .padding({ left: 12, right: 12 })
      .margin({ top: Dimens.GAP_ELEMENT })

      // 注册协议
      Row() {
        Checkbox().select(this.agreeProtocol).selectedColor(Theme.PRIMARY)
          .onChange((v: boolean) => { this.agreeProtocol = v; })
        Text('我已阅读并同意').fontSize(FontSize.CAPTION).fontColor(Theme.TEXT_SECOND).margin({ left: 4 })
        Text('《用户注册协议》').fontSize(FontSize.CAPTION).fontColor(Theme.PRIMARY)
          .onClick(() => this.showProtocolDialog())
      }
      .width('100%')
      .margin({ top: 12 })

      // 注册按钮
      Button('注册')
        .width('100%').height(Dimens.BTN_HEIGHT)
        .fontSize(FontSize.BODY).fontColor(Theme.WHITE)
        .backgroundColor(Theme.PRIMARY)
        .borderRadius(Dimens.RADIUS).margin({ top: Dimens.GAP_MODULE })
        .onClick(() => this.doRegister())

      // 切换登录
      Row() {
        Text('已有账号？').fontSize(FontSize.CAPTION).fontColor(Theme.TEXT_SECOND)
        Text('立即登录').fontSize(FontSize.CAPTION).fontColor(Theme.PRIMARY).fontWeight(FontWeight.Medium)
          .onClick(() => { this.currentTab = 0; })
      }
      .margin({ top: 16 })
    }
    .width('90%')
    .alignItems(HorizontalAlign.Start)
  }

  /** 忘记密码弹窗 */
  showForgetPwdDialog(): void {
    promptAction.showDialog({
      title: '找回密码',
      message: '请输入你的学号和绑定的手机号，验证码将发送至你的手机。\n\n（本功能为模拟演示）',
      buttons: [
        { text: '取消', color: Theme.TEXT_SECOND },
        { text: '确定', color: Theme.PRIMARY }
      ]
    }).then(() => {
      promptAction.showToast({ message: '重置密码链接已发送(模拟)' });
    }).catch(() => {}); // 用户取消
  }

  /** 注册协议弹窗 */
  showProtocolDialog(): void {
    promptAction.showDialog({
      title: '用户注册协议',
      message: '欢迎使用"高校校园助手"APP。\n\n'
        + '一、协议范围\n本协议是您与本APP开发团队之间关于使用本APP所订立的协议。\n\n'
        + '二、用户信息\n1. 您需要提供真实、准确的个人信息完成注册；\n2. 我们将对您的个人信息严格保密；\n3. 您可以随时查看、修改您的个人信息。\n\n'
        + '三、用户责任\n1. 您不得利用本APP从事违法活动；\n2. 您需妥善保管账号密码。\n\n'
        + '四、免责声明\n本APP为校园服务辅助工具，部分数据为模拟演示数据。\n\n'
        + '五、协议修改\n我们保留修改本协议的权利，修改后的协议将在APP内公示。\n\n'
        + '请仔细阅读以上协议条款，点击"确定"即表示您接受本协议。',
      buttons: [
        { text: '拒绝', color: Theme.RED_DOT },
        { text: '同意', color: Theme.PRIMARY }
      ]
    }).then(() => {
      this.agreeProtocol = true;
    }).catch(() => {
      this.agreeProtocol = false;
    });
  }
}