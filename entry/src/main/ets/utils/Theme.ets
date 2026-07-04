/**
 * 全局配色与设计规范常量（唯一颜色来源）
 * 依据《高校校园助手 APP 界面设计规范》§1.1 ~ §1.3 定义
 * 所有页面/组件应引用此处常量，禁止散落硬编码色值，以保证视觉一致性。
 */
export class Theme {
  // 主色调 —— 鸿蒙蓝：导航栏、Tab 栏、按钮、选中状态、标题
  static readonly PRIMARY: string = '#1677FF';
  // 主色浅变体 —— 渐变终点、悬停态
  static readonly PRIMARY_LIGHT_END: string = '#4096FF';
  // 主色淡底 —— 头像底、淡蓝卡片底、输入框聚焦底
  static readonly PRIMARY_BG: string = '#E8F3FF';
  // 未激活按钮底（必填未填全）
  static readonly PRIMARY_DISABLE: string = '#D4E5FF';

  // 辅助色 1 —— 暖橙：提醒、待办标记、进度条、重点按钮、失物图标
  static readonly ACCENT_ORANGE: string = '#FF7D00';
  // 辅助色 2 —— 清新绿：完成状态、成功提示、正常状态
  static readonly ACCENT_GREEN: string = '#00B42A';

  // 背景色 —— 浅灰：页面整体背景、模块分隔背景
  static readonly BG: string = '#F5F7FA';
  // 卡片背景 —— 纯白
  static readonly CARD: string = '#FFFFFF';
  // 文字主色 —— 深黑：正文、标题、重要信息
  static readonly TEXT_PRIMARY: string = '#1D2129';
  // 文字辅色 —— 浅灰：辅助说明、占位符、时间、次要信息
  static readonly TEXT_SECOND: string = '#86909C';
  // 边框色 —— 淡灰：模块边框、输入框边框、分割线
  static readonly BORDER: string = '#E5E6EB';

  // 深色模式配色
  static readonly BG_DARK: string = '#121212';
  static readonly CARD_DARK: string = '#1E1E1E';
  static readonly TEXT_DARK: string = '#E0E0E0';
  static readonly TEXT_SECOND_DARK: string = '#BDBDBD';
  static readonly BORDER_DARK: string = '#2A2A2A';

  // 白色（快捷引用）
  static readonly WHITE: string = '#FFFFFF';
  // 透明（输入框透出父容器底色）
  static readonly TRANSPARENT: string = '#00000000';

  // 提示红 —— 未读小红点
  static readonly RED_DOT: string = '#F53F3F';

  /** 背景色：按主题返回 */
  static bgColor(isDark: boolean): string {
    return isDark ? Theme.BG_DARK : Theme.BG;
  }

  /** 卡片背景：按主题返回 */
  static cardColor(isDark: boolean): string {
    return isDark ? Theme.CARD_DARK : Theme.CARD;
  }

  /** 主文字色：按主题返回 */
  static textColor(isDark: boolean): string {
    return isDark ? Theme.TEXT_DARK : Theme.TEXT_PRIMARY;
  }

  /** 辅文字色：按主题返回 */
  static textSecondColor(isDark: boolean): string {
    return isDark ? Theme.TEXT_SECOND_DARK : Theme.TEXT_SECOND;
  }

  /** 边框/分割线色：按主题返回 */
  static borderColor(isDark: boolean): string {
    return isDark ? Theme.BORDER_DARK : Theme.BORDER;
  }
}

/**
 * 字体规范（文档 §1.2 适度上调版）
 * 文档原表偏大（正文 26sp），此处采用折中值，配合 fontScale 运行时缩放。
 */
export class FontSize {
  static readonly PAGE_TITLE: number = 24;   // 页面大标题（原 22）
  static readonly MODULE_TITLE: number = 17; // 模块/卡片标题（原 16）
  static readonly LIST_TITLE: number = 16;   // 列表项标题（原 15）
  static readonly BODY: number = 15;         // 正文/内容（原 13-14）
  static readonly CAPTION: number = 12;      // 辅助/时间/备注（原 11）
  static readonly TAG: number = 10;          // 极小标签（原 9-10）
}

/**
 * 组件尺寸规范（文档 §1.3）
 */
export class Dimens {
  static readonly RADIUS: number = 8;        // 卡片/按钮/输入框圆角
  static readonly RADIUS_PILL: number = 16;  // 胶囊（标签、搜索栏、Tab 内）
  static readonly PADDING_SIDE: number = 20; // 页面左右边距
  static readonly GAP_ELEMENT: number = 16;  // 元素间距
  static readonly GAP_MODULE: number = 24;   // 模块间距
  static readonly BTN_HEIGHT: number = 48;   // 默认按钮高度
  static readonly BTN_HEIGHT_SM: number = 36;// 小按钮高度
  static readonly TAB_HEIGHT: number = 56;   // 底部 Tab 高度
}
