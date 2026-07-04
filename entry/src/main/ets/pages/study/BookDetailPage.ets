import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { MockData } from '../../data/MockData';
import { Book } from '../../model/BookModel';
import { Theme, FontSize } from '../../utils/Theme';

@Entry
@Component
struct BookDetailPage {
  @State book: Book | null = null;
  @State isCollected: boolean = false;
  @State bookStatus: string = '';
  private itemId: number = 0;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    if (params && params['id']) {
      this.itemId = params['id'] as number;
      this.loadDetail();
    }
  }

  loadDetail(): void {
    const list = MockData.getBooks();
    const item = list.find(b => b.id === this.itemId);
    if (item) {
      this.book = item;
      this.isCollected = item.isCollected;
      this.bookStatus = item.status;
    }
  }

  toggleCollect(): void {
    this.isCollected = !this.isCollected;
    if (this.book) {
      this.book.isCollected = this.isCollected;
    }
  }

  setStatus(status: string): void {
    this.bookStatus = status;
    if (this.book) {
      this.book.status = status;
    }
    const msg = status === 'want' ? '已标记为想看' : (status === 'borrowed' ? '已标记为已借' : '已取消标记');
    promptAction.showToast({ message: msg, duration: 1500 });
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor(Theme.PRIMARY)
          .onClick(() => router.back())
        Text('图书详情')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
        Blank()
        SymbolGlyph($r('sys.symbol.ohos_star'))
          .fontSize(24)
          .fontColor([this.isCollected ? Theme.ACCENT_ORANGE : Theme.TEXT_SECOND])
          .onClick(() => this.toggleCollect())
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      if (this.book) {
        Scroll() {
          Column() {
            // 封面区域
            Column() {
              Text('📖')
                .fontSize(64)
              Text(this.book.name)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor(Theme.TEXT_PRIMARY)
                .margin({ top: 12 })
                .textAlign(TextAlign.Center)
              Text(`ISBN: ${this.book.isbn}`)
                .fontSize(FontSize.CAPTION)
                .fontColor(Theme.TEXT_SECOND)
                .margin({ top: 4 })
            }
            .width('100%')
            .padding({ top: 24, bottom: 24 })
            .backgroundColor(Theme.PRIMARY_BG)

            // 信息列表
            Column() {
              this.infoRow('作者', this.book.author)
              this.infoRow('出版社', this.book.publisher)
              this.infoRow('出版年份', this.book.publishYear)
              this.infoRow('馆藏位置', this.book.location)
              Row() {
                Text('藏书数量')
                  .fontSize(FontSize.BODY)
                  .fontColor(Theme.TEXT_SECOND)
                  .width(80)
                Text(`共 ${this.book.totalCount} 册，可借 ${this.book.availableCount} 册`)
                  .fontSize(FontSize.BODY)
                  .fontColor(this.book.availableCount > 0 ? Theme.ACCENT_GREEN : Theme.RED_DOT)
              }
              .width('100%')
              .padding({ top: 12, bottom: 12 })
              .border({ width: { bottom: 0.5 }, color: Theme.BORDER })

              Text('图书简介')
                .fontSize(FontSize.BODY)
                .fontColor(Theme.TEXT_SECOND)
                .padding({ top: 12, bottom: 6 })
              Text(this.book.description)
                .fontSize(FontSize.BODY)
                .fontColor(Theme.TEXT_PRIMARY)
                .lineHeight(22)
            }
            .width('100%')
            .padding(16)
          }
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)

        // 底部操作栏
        Row() {
          Button(this.bookStatus === 'want' ? '✓ 已想读' : '标记想看')
            .fontSize(FontSize.CAPTION)
            .height(40)
            .layoutWeight(1)
            .backgroundColor(this.bookStatus === 'want' ? Theme.ACCENT_ORANGE : Theme.BG)
            .fontColor(this.bookStatus === 'want' ? Theme.WHITE : Theme.TEXT_SECOND)
            .borderRadius(20)
            .onClick(() => this.setStatus(this.bookStatus === 'want' ? '' : 'want'))

          Button(this.bookStatus === 'borrowed' ? '✓ 已借阅' : '标记已借')
            .fontSize(FontSize.CAPTION)
            .height(40)
            .layoutWeight(1)
            .backgroundColor(this.bookStatus === 'borrowed' ? Theme.ACCENT_GREEN : Theme.BG)
            .fontColor(this.bookStatus === 'borrowed' ? Theme.WHITE : Theme.TEXT_SECOND)
            .borderRadius(20)
            .margin({ left: 12 })
            .onClick(() => this.setStatus(this.bookStatus === 'borrowed' ? '' : 'borrowed'))
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        .backgroundColor(Theme.CARD)
        .border({ width: { top: 0.5 }, color: Theme.BORDER })
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  infoRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(FontSize.BODY)
        .fontColor(Theme.TEXT_SECOND)
        .width(80)
      Text(value)
        .fontSize(FontSize.BODY)
        .fontColor(Theme.TEXT_PRIMARY)
    }
    .width('100%')
    .padding({ top: 12, bottom: 12 })
    .border({ width: { bottom: 0.5 }, color: Theme.BORDER })
  }
}
