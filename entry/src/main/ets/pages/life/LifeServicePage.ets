import { router } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { MockData } from '../../data/MockData';
import { LostFoundItem } from '../../model/LostFoundModel';
import { Food } from '../../model/FoodModel';
import { Theme, FontSize } from '../../utils/Theme';

class ToolItem {
  name: string;
  icon: string;

  constructor(name: string, icon: string) {
    this.name = name;
    this.icon = icon;
  }
}

@Component
export struct LifeServicePage {
  @State selectedCategory: number = 0;
  @State lostItems: LostFoundItem[] = [];
  @State lostTypeFilter: string = '全部';
  @State foods: Food[] = [];
  @StorageLink('isDarkMode') isDarkMode: boolean = false;

  private categories: string[] = ['全部', '校园卡', '书包', '电子产品', '其他'];
  private tools: ToolItem[] = [
    new ToolItem('计算器', '🧮'),
    new ToolItem('倒计时', '⏱️'),
    new ToolItem('快递查询', '📦'),
    new ToolItem('课表导出', '📤'),
  ];

  aboutToAppear(): void {
    this.lostItems = MockData.getLostFoundItems().slice(0, 3);
    this.foods = MockData.getFoods();
  }

  build() {
    Scroll() {
      Column() {
        Text('生活服务')
          .fontSize(FontSize.PAGE_TITLE)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .padding({ left: 16, top: 16, bottom: 12 })
          .fontColor(Theme.textColor(this.isDarkMode))

        // 2x2 入口卡片
        this.entryGrid()

        // 下方内容区
        if (this.selectedCategory === 0) {
          this.lostFoundContent()
        } else if (this.selectedCategory === 1) {
          this.foodContent()
        } else if (this.selectedCategory === 2) {
          this.musicContent()
        } else if (this.selectedCategory === 3) {
          this.toolContent()
        }

        Blank().height(16)
      }
    }
    .scrollBar(BarState.Off)
    .backgroundColor(Theme.bgColor(this.isDarkMode))
  }

  @Builder
  entryGrid() {
    Grid() {
      GridItem() {
        this.entryCard('🔍', '失物招领', Theme.ACCENT_ORANGE, 0)
      }
      GridItem() {
        this.entryCard('🍽️', '校园美食', Theme.PRIMARY, 1)
      }
      GridItem() {
        this.entryCard('🎵', '音乐播放', '#8B5CF6', 2)
      }
      GridItem() {
        this.entryCard('🛠️', '校园工具', Theme.ACCENT_GREEN, 3)
      }
    }
    .columnsTemplate('1fr 1fr')
    .rowsGap(10)
    .columnsGap(10)
    .padding({ left: 16, right: 16 })
    .height(180)
  }

  @Builder
  entryCard(icon: string, title: string, color: string, index: number) {
    Column() {
      Text(icon)
        .fontSize(32)
      Text(title)
        .fontSize(FontSize.BODY)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.selectedCategory === index ? Theme.WHITE : color)
        .margin({ top: 8 })
    }
    .width('100%')
    .height(80)
    .justifyContent(FlexAlign.Center)
    .borderRadius(12)
    .backgroundColor(this.selectedCategory === index ? color : Theme.cardColor(this.isDarkMode))
    .onClick(() => {
      this.selectedCategory = index;
    })
  }

  // ===== 失物招领 =====
  @Builder
  lostFoundContent() {
    Column() {
      Row() {
        ForEach(['全部', '失物', '拾物'], (type: string) => {
          Text(type)
            .fontSize(FontSize.CAPTION)
            .fontColor(this.lostTypeFilter === type ? Theme.WHITE : Theme.textSecondColor(this.isDarkMode))
            .padding({ left: 12, right: 12, top: 5, bottom: 5 })
            .borderRadius(14)
            .backgroundColor(this.lostTypeFilter === type ? Theme.ACCENT_ORANGE : Theme.cardColor(this.isDarkMode))
            .margin({ right: 8 })
            .onClick(() => {
              this.lostTypeFilter = type;
              let all = MockData.getLostFoundItems();
              if (type !== '全部') {
                all = all.filter(i => i.type === type);
              }
              this.lostItems = all.slice(0, 3);
            })
        })
        Blank()
        Text('+ 发布')
          .fontSize(FontSize.TAG)
          .fontColor(Theme.PRIMARY)
          .onClick(() => {
            router.pushUrl({ url: Constants.PAGE_LOST_FOUND_PUBLISH });
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })

      ForEach(this.lostItems, (item: LostFoundItem) => {
        Row() {
          Text(item.type === '失物' ? '🔴' : '🟢')
            .fontSize(16)
          Column() {
            Text(item.title)
              .fontSize(FontSize.BODY)
              .fontColor(Theme.textColor(this.isDarkMode))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            Text(`${item.location} · ${item.lostTime}`)
              .fontSize(FontSize.TAG)
              .fontColor(Theme.TEXT_SECOND)
              .margin({ top: 2 })
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 8 })
          .layoutWeight(1)
        }
        .width('100%')
        .padding(12)
        .backgroundColor(Theme.cardColor(this.isDarkMode))
        .borderRadius(8)
        .margin({ left: 16, right: 16, bottom: 6 })
        .onClick(() => {
          router.pushUrl({ url: Constants.PAGE_LOST_FOUND_LIST });
        })
      })

      Text('查看更多 >')
        .fontSize(FontSize.CAPTION)
        .fontColor(Theme.PRIMARY)
        .padding(8)
        .onClick(() => {
          router.pushUrl({ url: Constants.PAGE_LOST_FOUND_LIST });
        })
    }
    .width('100%')
    .padding({ top: 8 })
  }

  // ===== 校园美食 =====
  @Builder
  foodContent() {
    Column() {
      ForEach(this.foods.slice(0, 3), (food: Food) => {
        Row() {
          Text('🍽️')
            .fontSize(28)
          Column() {
            Text(food.name)
              .fontSize(FontSize.BODY)
              .fontColor(Theme.textColor(this.isDarkMode))
            Text(`⭐ ${food.rating} · ${food.location}`)
              .fontSize(FontSize.TAG)
              .fontColor(Theme.TEXT_SECOND)
              .margin({ top: 2 })
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 10 })
          .layoutWeight(1)
          Text('›')
            .fontSize(18)
            .fontColor(Theme.BORDER)
        }
        .width('100%')
        .padding(14)
        .backgroundColor(Theme.cardColor(this.isDarkMode))
        .borderRadius(8)
        .margin({ left: 16, right: 16, bottom: 6 })
        .onClick(() => {
          router.pushUrl({ url: Constants.PAGE_FOOD_DETAIL, params: { id: food.id } });
        })
      })

      Text('查看更多 >')
        .fontSize(FontSize.CAPTION)
        .fontColor(Theme.PRIMARY)
        .padding(8)
        .onClick(() => {
          router.pushUrl({ url: Constants.PAGE_FOOD_LIST });
        })
    }
    .width('100%')
    .padding({ top: 8 })
  }

  // ===== 音乐播放 =====
  @Builder
  musicContent() {
    Column() {
      Row() {
        Column() {
          Text('🎵')
            .fontSize(48)
        }
        .width(80)
        .height(80)
        .borderRadius(40)
        .backgroundColor(Theme.PRIMARY_BG)
        .justifyContent(FlexAlign.Center)

        Column() {
          Text('晴天')
            .fontSize(FontSize.BODY)
            .fontWeight(FontWeight.Medium)
            .fontColor(Theme.textColor(this.isDarkMode))
          Text('周杰伦')
            .fontSize(FontSize.CAPTION)
            .fontColor(Theme.TEXT_SECOND)
            .margin({ top: 4 })
          Row() {
            Text('▶ 播放')
              .fontSize(FontSize.TAG)
              .fontColor(Theme.WHITE)
              .padding({ left: 12, right: 12, top: 4, bottom: 4 })
              .backgroundColor(Theme.PRIMARY)
              .borderRadius(12)
            Text('下一首')
              .fontSize(FontSize.TAG)
              .fontColor(Theme.PRIMARY)
              .margin({ left: 8 })
          }
          .margin({ top: 8 })
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 14 })
        .layoutWeight(1)
      }
      .width('100%')
      .padding(16)
      .backgroundColor(Theme.cardColor(this.isDarkMode))
      .borderRadius(8)
      .margin({ left: 16, right: 16 })

      Text('打开完整播放器 >')
        .fontSize(FontSize.CAPTION)
        .fontColor(Theme.PRIMARY)
        .padding(8)
        .onClick(() => {
          router.pushUrl({ url: Constants.PAGE_MUSIC_PLAYER });
        })
    }
    .width('100%')
    .padding({ top: 12 })
  }

  // ===== 校园工具 =====
  @Builder
  toolContent() {
    Column() {
      Grid() {
        ForEach(this.tools, (tool: ToolItem) => {
          GridItem() {
            Column() {
              Text(tool.icon)
                .fontSize(32)
              Text(tool.name)
                .fontSize(FontSize.CAPTION)
                .fontColor(Theme.textColor(this.isDarkMode))
                .margin({ top: 6 })
            }
            .width('100%')
            .height(80)
            .justifyContent(FlexAlign.Center)
            .borderRadius(8)
            .backgroundColor(Theme.cardColor(this.isDarkMode))
          }
        })
      }
      .columnsTemplate('1fr 1fr')
      .rowsGap(10)
      .columnsGap(10)
      .padding({ left: 16, right: 16 })
      .height(170)
    }
    .width('100%')
    .padding({ top: 12 })
  }
}