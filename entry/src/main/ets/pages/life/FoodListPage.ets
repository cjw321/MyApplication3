import { router } from '@kit.ArkUI';
import { MockData } from '../../data/MockData';
import { Food } from '../../model/FoodModel';
import { Constants } from '../../utils/Constants';
import { Theme, FontSize } from '../../utils/Theme';

@Entry
@Component
struct FoodListPage {
  @State foods: Food[] = [];

  aboutToAppear(): void {
    this.foods = MockData.getFoods();
  }

  getStars(rating: number): string {
    const full = Math.floor(rating);
    const half = rating - full >= 0.5 ? 1 : 0;
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
        Text('校园美食')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      List() {
        ForEach(this.foods, (food: Food) => {
          ListItem() {
            Row() {
              Column() {
                Text('🍽️')
                  .fontSize(32)
              }
              .width(60)
              .height(60)
              .justifyContent(FlexAlign.Center)
              .backgroundColor('#FFF7E8')
              .borderRadius(8)

              Column() {
                Text(food.name)
                  .fontSize(FontSize.MODULE_TITLE)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(Theme.TEXT_PRIMARY)
                Text(food.featureDish)
                  .fontSize(FontSize.CAPTION)
                  .fontColor(Theme.ACCENT_ORANGE)
                  .margin({ top: 4 })
                Row() {
                  Text(this.getStars(food.rating))
                    .fontSize(FontSize.CAPTION)
                    .fontColor(Theme.ACCENT_ORANGE)
                  Text(`${food.rating}分`)
                    .fontSize(FontSize.CAPTION)
                    .fontColor(Theme.ACCENT_ORANGE)
                    .margin({ left: 6 })
                  Text(`${food.ratingCount}评`)
                    .fontSize(FontSize.TAG)
                    .fontColor(Theme.TEXT_SECOND)
                    .margin({ left: 4 })
                }
                .margin({ top: 4 })
                Text(`📍 ${food.location}`)
                  .fontSize(FontSize.TAG)
                  .fontColor(Theme.TEXT_SECOND)
                  .margin({ top: 2 })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 12 })
              .layoutWeight(1)

              Column() {
                SymbolGlyph($r('sys.symbol.ohos_star'))
                  .fontSize(22)
                  .fontColor([food.isCollected ? Theme.ACCENT_ORANGE : Theme.BORDER])
                  .onClick(() => {
                    food.isCollected = !food.isCollected;
                  })
                Text(food.isCollected ? '已收藏' : '收藏')
                  .fontSize(FontSize.TAG)
                  .fontColor(Theme.TEXT_SECOND)
                  .margin({ top: 2 })
              }
              .alignItems(HorizontalAlign.Center)
              .margin({ left: 8 })
            }
            .width('100%')
            .padding(16)
            .onClick(() => {
              router.pushUrl({ url: Constants.PAGE_FOOD_DETAIL, params: { id: food.id } });
            })
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 0.5, color: Theme.BORDER })
      .backgroundColor(Theme.CARD)
    }
    .width('100%')
    .height('100%')
  }
}
