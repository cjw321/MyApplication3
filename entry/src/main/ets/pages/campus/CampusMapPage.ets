import { router } from '@kit.ArkUI';
import { MockData } from '../../data/MockData';
import { CampusBuilding } from '../../model/CampusModel';
import { Theme, FontSize } from '../../utils/Theme';

@Entry
@Component
struct CampusMapPage {
  @State searchKeyword: string = '';
  @State buildings: CampusBuilding[] = [];
  @State selectedBuilding: CampusBuilding | null = null;
  @State filteredBuildings: CampusBuilding[] = [];

  aboutToAppear(): void {
    this.buildings = MockData.getCampusBuildings();
    this.filteredBuildings = this.buildings;
  }

  onSearch(): void {
    if (this.searchKeyword.trim() === '') {
      this.filteredBuildings = this.buildings;
    } else {
      const kw = this.searchKeyword.trim().toLowerCase();
      this.filteredBuildings = this.buildings.filter(b => b.name.toLowerCase().includes(kw));
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor(Theme.PRIMARY)
          .onClick(() => router.back())
        Text('校园地图')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      // 搜索栏
      Row() {
        TextInput({ text: this.searchKeyword, placeholder: '搜索建筑名称...' })
          .fontSize(FontSize.BODY)
          .height(36)
          .layoutWeight(1)
          .backgroundColor(Theme.BG)
          .borderRadius(18)
          .padding({ left: 12 })
          .onChange((value: string) => {
            this.searchKeyword = value;
            this.onSearch();
          })
        Button('搜索')
          .fontSize(FontSize.CAPTION)
          .height(36)
          .backgroundColor(Theme.PRIMARY)
          .borderRadius(18)
          .margin({ left: 8 })
          .onClick(() => this.onSearch())
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      // 地图区域
      Scroll() {
        Stack() {
          // 地图背景
          Column() {
            // 道路网格
            ForEach(['主干道', '环校路', '教学楼区域', '宿舍区域', '运动区域'], (label: string, idx: number) => {
              Row() {
                Text(label)
                  .fontSize(FontSize.TAG)
                  .fontColor(Theme.BORDER)
              }
              .width('80%')
              .height(1)
              .backgroundColor(Theme.BORDER)
              .margin({ top: 60 })
            })
          }
          .width('100%')
          .height(560)
          .backgroundColor(Theme.BG)
          .border({ width: 1, color: Theme.BORDER, radius: 8 })

          // 建筑标记
          ForEach(this.filteredBuildings, (building: CampusBuilding) => {
            Column() {
              Text('📍')
                .fontSize(20)
              Text(building.name)
                .fontSize(9)
                .fontColor(Theme.WHITE)
                .padding({ left: 3, right: 3, top: 1, bottom: 1 })
                .borderRadius(4)
                .backgroundColor(Theme.PRIMARY)
                .maxLines(1)
            }
            .position({ x: building.x, y: building.y })
            .onClick(() => {
              this.selectedBuilding = building;
            })
          })
        }
        .width('100%')
        .height(560)
        .padding(16)
      }
      .layoutWeight(1)

      // 建筑详情
      if (this.selectedBuilding) {
        Column() {
          Text(this.selectedBuilding.name)
            .fontSize(FontSize.MODULE_TITLE)
            .fontWeight(FontWeight.Bold)
            .fontColor(Theme.TEXT_PRIMARY)
          Text(this.selectedBuilding.description)
            .fontSize(FontSize.BODY)
            .fontColor(Theme.TEXT_SECOND)
            .margin({ top: 6 })
        }
        .width('100%')
        .padding(16)
        .backgroundColor(Theme.CARD)
        .border({ width: { top: 0.5 }, color: Theme.BORDER })
      }

      // 图例
      Row() {
        Text('📍 建筑位置  ')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.TEXT_SECOND)
        Text('点击建筑查看详情')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.TEXT_SECOND)
      }
      .width('100%')
      .padding(10)
      .backgroundColor(Theme.BG)
    }
    .width('100%')
    .height('100%')
  }
}
