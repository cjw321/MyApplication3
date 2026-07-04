import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { Theme, FontSize } from '../../utils/Theme';
import { MediaHelper } from '../../utils/MediaHelper';

@Entry
@Component
struct LostFoundPublishPage {
  @State publishType: string = '失物';
  @State title: string = '';
  @State description: string = '';
  @State location: string = '';
  @State lostTime: string = '';
  @State contactPhone: string = '';
  @State category: string = '其他';
  @State imageUris: string[] = [];

  private categories: string[] = ['校园卡', '书包', '电子产品', '其他'];

  async pickImages(): Promise<void> {
    const uris = await MediaHelper.pickImage(3);
    if (uris.length > 0) {
      this.imageUris = this.imageUris.concat(uris);
      // 最多9张
      if (this.imageUris.length > 9) {
        this.imageUris = this.imageUris.slice(0, 9);
      }
    }
  }

  removeImage(index: number): void {
    const updated = new Array<string>();
    for (let i = 0; i < this.imageUris.length; i++) {
      if (i !== index) {
        updated.push(this.imageUris[i]);
      }
    }
    this.imageUris = updated;
  }

  submit(): void {
    if (!this.title.trim() || !this.description.trim() || !this.location.trim() || !this.contactPhone.trim()) {
      promptAction.showToast({ message: '请填写完整信息', duration: 2000 });
      return;
    }
    promptAction.showToast({ message: '发布成功！', duration: 2000 });
    setTimeout(() => router.back(), 500);
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor(Theme.PRIMARY)
          .onClick(() => router.back())
        Text('发布信息')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
        Blank()
        Button('提交')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.WHITE)
          .height(36)
          .backgroundColor(Theme.PRIMARY)
          .borderRadius(8)
          .onClick(() => this.submit())
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      Scroll() {
        Column() {
          // 类型选择
          Text('发布类型')
            .fontSize(FontSize.BODY)
            .fontColor(Theme.TEXT_SECOND)
            .padding({ left: 16, top: 16, bottom: 8 })
            .width('100%')
          Row() {
            ForEach(['失物', '拾物'], (type: string) => {
              Text(type)
                .fontSize(FontSize.BODY)
                .fontColor(this.publishType === type ? Theme.WHITE : Theme.TEXT_SECOND)
                .padding({ left: 20, right: 20, top: 8, bottom: 8 })
                .borderRadius(18)
                .backgroundColor(this.publishType === type ? Theme.PRIMARY : Theme.BG)
                .margin({ right: 12 })
                .onClick(() => { this.publishType = type; })
            })
          }
          .width('100%')
          .padding({ left: 16, right: 16 })

          // 物品分类
          Text('物品分类')
            .fontSize(FontSize.BODY)
            .fontColor(Theme.TEXT_SECOND)
            .padding({ left: 16, top: 16, bottom: 8 })
            .width('100%')
          Row() {
            ForEach(this.categories, (cat: string) => {
              Text(cat)
                .fontSize(FontSize.CAPTION)
                .fontColor(this.category === cat ? Theme.WHITE : Theme.TEXT_SECOND)
                .padding({ left: 14, right: 14, top: 6, bottom: 6 })
                .borderRadius(14)
                .backgroundColor(this.category === cat ? Theme.ACCENT_ORANGE : Theme.BG)
                .margin({ right: 8 })
                .onClick(() => { this.category = cat; })
            })
          }
          .width('100%')
          .padding({ left: 16, right: 16 })

          // 图片选择
          Text('上传图片（最多9张）')
            .fontSize(FontSize.BODY)
            .fontColor(Theme.TEXT_SECOND)
            .padding({ left: 16, top: 16, bottom: 8 })
            .width('100%')

          Row() {
            // 已选图片缩略图
            ForEach(this.imageUris, (uri: string, idx: number) => {
              Stack() {
                Image(uri)
                  .width(64)
                  .height(64)
                  .borderRadius(8)
                  .objectFit(ImageFit.Cover)
                Text('×')
                  .fontSize(14)
                  .fontColor(Theme.WHITE)
                  .backgroundColor(Theme.RED_DOT)
                  .width(16)
                  .height(16)
                  .borderRadius(8)
                  .textAlign(TextAlign.Center)
                  .position({ top: -4, right: -4 })
                  .onClick(() => this.removeImage(idx))
              }
              .width(64)
              .height(64)
              .margin({ right: 8 })
            })

            // 添加按钮
            if (this.imageUris.length < 9) {
              Column() {
                Text('+')
                  .fontSize(24)
                  .fontColor(Theme.TEXT_SECOND)
                Text('添加')
                  .fontSize(FontSize.TAG)
                  .fontColor(Theme.TEXT_SECOND)
                  .margin({ top: 2 })
              }
              .width(64)
              .height(64)
              .justifyContent(FlexAlign.Center)
              .border({ width: 1, color: Theme.BORDER, radius: 8 })
              .onClick(() => this.pickImages())
            }
          }
          .width('100%')
          .padding({ left: 16, right: 16 })

          // 表单
          this.formInput('物品名称', '请输入物品名称', this.title, (v: string) => this.title = v)
          this.formInput('丢失/拾获地点', '请输入地点', this.location, (v: string) => this.location = v)
          this.formInput('丢失/拾获时间', '如 2026-06-15', this.lostTime, (v: string) => this.lostTime = v)
          this.formInput('联系电话', '请输入联系电话', this.contactPhone, (v: string) => this.contactPhone = v)

          Text('物品描述')
            .fontSize(FontSize.BODY)
            .fontColor(Theme.TEXT_SECOND)
            .padding({ left: 16, top: 16, bottom: 8 })
            .width('100%')
          TextArea({ text: this.description, placeholder: '请详细描述物品特征、颜色、品牌等信息...' })
            .fontSize(FontSize.BODY)
            .fontColor(Theme.TEXT_PRIMARY)
            .height(120)
            .backgroundColor(Theme.BG)
            .borderRadius(8)
            .padding(12)
            .margin({ left: 16, right: 16 })
            .onChange((v: string) => this.description = v)

          Blank().height(30)
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor(Theme.CARD)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  formInput(label: string, placeholder: string, value: string, onChange: (v: string) => void) {
    Row() {
      Text(label)
        .fontSize(FontSize.BODY)
        .fontColor(Theme.TEXT_SECOND)
        .width(100)
      TextInput({ text: value, placeholder: placeholder })
        .fontSize(FontSize.BODY)
        .fontColor(Theme.TEXT_PRIMARY)
        .layoutWeight(1)
        .backgroundColor(Theme.BG)
        .borderRadius(8)
        .padding({ left: 10 })
        .onChange(onChange)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 4 })
  }
}