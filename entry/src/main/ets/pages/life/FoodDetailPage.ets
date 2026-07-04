import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { MockData } from '../../data/MockData';
import { Food } from '../../model/FoodModel';
import { Theme, FontSize } from '../../utils/Theme';

@Entry
@Component
struct FoodDetailPage {
  @State food: Food | null = null;
  @State myRating: number = 0;
  private itemId: number = 0;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    if (params && params['id']) {
      this.itemId = params['id'] as number;
      this.loadDetail();
    }
  }

  loadDetail(): void {
    const list = MockData.getFoods();
    const item = list.find(f => f.id === this.itemId);
    if (item) {
      this.food = item;
      this.myRating = item.myRating;
    }
  }

  setRating(r: number): void {
    this.myRating = r;
    if (this.food) {
      this.food.myRating = r;
    }
    promptAction.showToast({ message: `已评分 ${r} 星`, duration: 1500 });
  }

  getStars(r: number): string {
    const full = Math.floor(r);
    const half = r - full >= 0.5 ? 1 : 0;
    return '★'.repeat(full) + (half ? '☆' : '') + '☆'.repeat(5 - full - half);
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor(Theme.PRIMARY)
          .onClick(() => router.back())
        Text('美食详情')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
        Blank()
        SymbolGlyph($r('sys.symbol.ohos_star'))
          .fontSize(24)
          .fontColor([this.food?.isCollected ? Theme.ACCENT_ORANGE : Theme.TEXT_SECOND])
          .onClick(() => {
            if (this.food) {
              this.food.isCollected = !this.food.isCollected;
            }
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      if (this.food) {
        Scroll() {
          Column() {
            // 头部
            Column() {
              Text('🍽️')
                .fontSize(56)
              Text(this.food.name)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor(Theme.TEXT_PRIMARY)
                .margin({ top: 8 })
              Text(`📍 ${this.food.location}`)
                .fontSize(FontSize.CAPTION)
                .fontColor(Theme.TEXT_SECOND)
                .margin({ top: 4 })
              Row() {
                Text(this.getStars(this.food.rating))
                  .fontSize(FontSize.BODY)
                  .fontColor(Theme.ACCENT_ORANGE)
                Text(`${this.food.rating}分 · ${this.food.ratingCount}条评价`)
                  .fontSize(FontSize.CAPTION)
                  .fontColor(Theme.ACCENT_ORANGE)
                  .margin({ left: 8 })
              }
              .margin({ top: 8 })
            }
            .width('100%')
            .padding({ top: 24, bottom: 24 })
            .backgroundColor('#FFF7E8')

            // 详情
            Column() {
              Text('特色菜品')
                .fontSize(FontSize.BODY)
                .fontWeight(FontWeight.Medium)
                .fontColor(Theme.TEXT_PRIMARY)
                .padding({ bottom: 4 })
              Text(this.food.featureDish)
                .fontSize(FontSize.BODY)
                .fontColor(Theme.ACCENT_ORANGE)

              Text('介绍')
                .fontSize(FontSize.BODY)
                .fontWeight(FontWeight.Medium)
                .fontColor(Theme.TEXT_PRIMARY)
                .padding({ top: 16, bottom: 4 })
              Text(this.food.description)
                .fontSize(FontSize.CAPTION)
                .fontColor(Theme.TEXT_SECOND)
                .lineHeight(22)

              // 我的评分
              Text('我的评分')
                .fontSize(FontSize.BODY)
                .fontWeight(FontWeight.Medium)
                .fontColor(Theme.TEXT_PRIMARY)
                .padding({ top: 20, bottom: 8 })
              Row() {
                ForEach([1, 2, 3, 4, 5], (star: number) => {
                  Text(star <= this.myRating ? '★' : '☆')
                    .fontSize(32)
                    .fontColor(star <= this.myRating ? Theme.ACCENT_ORANGE : Theme.BORDER)
                    .margin({ right: 8 })
                    .onClick(() => this.setRating(star))
                })
              }
            }
            .width('100%')
            .padding(16)
          }
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
  }
}
