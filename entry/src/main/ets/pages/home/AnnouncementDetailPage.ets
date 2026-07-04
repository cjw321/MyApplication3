import { router } from '@kit.ArkUI';
import { MockData } from '../../data/MockData';
import { Announcement } from '../../model/AnnouncementModel';
import { Theme, FontSize } from '../../utils/Theme';

@Entry
@Component
struct AnnouncementDetailPage {
  @State announcement: Announcement | null = null;
  @State isCollected: boolean = false;
  private itemId: number = 0;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    if (params && params['id']) {
      this.itemId = params['id'] as number;
      this.loadDetail();
    }
  }

  loadDetail(): void {
    const list = MockData.getAnnouncements();
    const item = list.find(a => a.id === this.itemId);
    if (item) {
      this.announcement = item;
      this.isCollected = item.isCollected;
    }
  }

  build() {
    Column() {
      // 顶部导航栏（含返回按钮）
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor(Theme.PRIMARY)
          .onClick(() => router.back())
        Text('公告详情')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
        Blank()
        SymbolGlyph($r('sys.symbol.ohos_star'))
          .fontSize(24)
          .fontColor([this.isCollected ? Theme.ACCENT_ORANGE : Theme.TEXT_SECOND])
          .onClick(() => {
            this.isCollected = !this.isCollected;
            if (this.announcement) {
              this.announcement.isCollected = this.isCollected;
            }
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      if (this.announcement) {
        Scroll() {
          Column() {
            Text(this.announcement.title)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(Theme.TEXT_PRIMARY)
              .width('100%')
              .padding({ left: 16, right: 16, top: 16 })

            Row() {
              Text(this.announcement.publisher)
                .fontSize(FontSize.CAPTION)
                .fontColor(Theme.PRIMARY)
              Text(this.announcement.publishTime)
                .fontSize(FontSize.CAPTION)
                .fontColor(Theme.TEXT_SECOND)
                .margin({ left: 12 })
              Text(this.announcement.type)
                .fontSize(FontSize.TAG)
                .fontColor(Theme.WHITE)
                .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                .borderRadius(8)
                .backgroundColor(Theme.PRIMARY)
                .margin({ left: 12 })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })

            Divider().strokeWidth(0.5).color(Theme.BORDER)

            Text(this.announcement.content)
              .fontSize(FontSize.BODY)
              .lineHeight(24)
              .fontColor(Theme.TEXT_PRIMARY)
              .width('100%')
              .padding(16)
          }
        }
        .scrollBar(BarState.Off)
        .backgroundColor(Theme.CARD)
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.CARD)
  }
}
