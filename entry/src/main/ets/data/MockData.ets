import { Announcement, News } from '../model/AnnouncementModel';
import { Book } from '../model/BookModel';
import { CampusBuilding } from '../model/CampusModel';
import { Course } from '../model/CourseModel';
import { Food } from '../model/FoodModel';
import { Grade } from '../model/GradeModel';
import { LostFoundItem } from '../model/LostFoundModel';
import { TodoItem } from '../model/TodoModel';
import { UserInfo } from '../model/UserModel';

export class MockData {
  // ============================ 公告 ============================
  private static _announcements: Announcement[] | null = null;

  static getAnnouncements(): Announcement[] {
    if (MockData._announcements) return MockData._announcements;
    MockData._announcements = [
      { id: 1, title: '关于2026年夏季学期选课通知', content: '各位同学：\n\n2026年夏季学期选课工作即将开始，现将有关事项通知如下：\n\n一、选课时间\n6月20日9:00 - 6月25日17:00\n\n二、选课对象\n全体在校本科生\n\n三、选课方式\n通过教务系统在线选课\n\n请各位同学按时完成选课，逾期不再受理。', type: '学校通知', publisher: '教务处', publishTime: '2026-06-12 10:30', imageUrls: [], isCollected: false },
      { id: 2, title: '关于期末考试周图书馆延长开放时间的通知', content: '为满足同学们期末复习需求，图书馆将于考试周期间（6月20日-7月5日）延长开放时间至晚上23:00。请同学们合理安排学习时间，注意保持安静。', type: '学校通知', publisher: '图书馆', publishTime: '2026-06-10 14:00', imageUrls: [], isCollected: false },
      { id: 3, title: '计算机学院关于举办学术讲座的通知', content: '讲座主题：人工智能前沿技术与应用\n主讲人：张教授（清华大学）\n时间：2026年6月18日 14:00-16:00\n地点：计算机学院报告厅\n欢迎广大师生参加！', type: '学院通知', publisher: '计算机学院', publishTime: '2026-06-08 09:00', imageUrls: [], isCollected: false },
      { id: 4, title: '关于端午节放假安排的通知', content: '根据学校安排，端午节放假时间为6月22日至6月24日，共3天。6月25日（周三）正常上课。请各位同学注意安全，合理安排假期。', type: '学校通知', publisher: '校办', publishTime: '2026-06-05 11:00', imageUrls: [], isCollected: false },
      { id: 5, title: '校园摄影社团招新公告', content: '校园摄影社团面向全校招收新成员！无论你是摄影小白还是资深玩家，只要你对摄影有兴趣，我们都欢迎你的加入！\n\n报名方式：扫描海报二维码或前往社团办公室报名\n报名截止：2026年6月30日', type: '社团通知', publisher: '摄影社团', publishTime: '2026-06-01 15:30', imageUrls: [], isCollected: false },
      { id: 6, title: '暑期社会实践报名通知', content: '2026年暑期社会实践活动开始报名，请各学院组织学生积极参加。报名截止日期为7月10日。', type: '学校通知', publisher: '团委', publishTime: '2026-06-15 08:30', imageUrls: [], isCollected: false },
      { id: 7, title: '关于校园网络升级的通知', content: '网络中心将于6月18日凌晨1:00-5:00对校园网进行升级维护，届时网络将暂时中断。', type: '学院通知', publisher: '网络中心', publishTime: '2026-06-14 16:00', imageUrls: [], isCollected: false },
      { id: 8, title: '英语四六级考试考场安排', content: '2026年上半年全国大学英语四六级考试将于6月17日举行，请考生登录教务系统查询考场安排。', type: '学校通知', publisher: '教务处', publishTime: '2026-06-13 09:00', imageUrls: [], isCollected: false },
      { id: 9, title: '篮球社团友谊赛公告', content: '篮球社团将于本周六下午在体育馆举办社团友谊赛，欢迎同学们前来观战助威！', type: '社团通知', publisher: '篮球社团', publishTime: '2026-06-11 10:00', imageUrls: [], isCollected: false },
      { id: 10, title: '图书馆暑假借书规则调整', content: '暑假期间借书规则有所调整，具体请参见图书馆官网公告。', type: '学校通知', publisher: '图书馆', publishTime: '2026-06-09 14:00', imageUrls: [], isCollected: false },
      { id: 11, title: '关于宿舍楼停电检修的紧急通知', content: '后勤处将于6月16日对宿舍片区供电设施进行检修，预计停电时间8:00-12:00。', type: '学院通知', publisher: '后勤处', publishTime: '2026-06-07 07:30', imageUrls: [], isCollected: false },
      { id: 12, title: 'ACM程序设计竞赛报名通知', content: '2026年ACM程序设计竞赛校内选拔赛开始报名，欢迎编程爱好者踊跃参与。', type: '社团通知', publisher: '编程社团', publishTime: '2026-06-06 12:00', imageUrls: [], isCollected: false },
      { id: 13, title: '毕业生就业双选会通知', content: '学校将于6月25日在体育馆举办夏季毕业生就业双选会，届时将有120余家企业参会。', type: '学校通知', publisher: '就业指导中心', publishTime: '2026-06-04 11:30', imageUrls: [], isCollected: false },
      { id: 14, title: '心理健康教育讲座', content: '学生处心理健康中心将于6月20日举办"压力管理与情绪调节"心理讲座，欢迎参加。', type: '学院通知', publisher: '学生处', publishTime: '2026-06-03 15:00', imageUrls: [], isCollected: false },
      { id: 15, title: '校园志愿者招募公告', content: '校青协面向全校招募迎新志愿者，服务时间为9月1日-3日，报名截至8月20日。', type: '社团通知', publisher: '青年志愿者协会', publishTime: '2026-06-02 09:30', imageUrls: [], isCollected: false },
    ];
    return MockData._announcements;
  }

  static getAnnouncementTotal(): number {
    return MockData.getAnnouncements().length;
  }

  static getAnnouncementsPaged(offset: number, size: number): Announcement[] {
    const all = MockData.getAnnouncements();
    return all.slice(offset, offset + size);
  }

  // ============================ 资讯 ============================
  private static _news: News[] | null = null;

  static getNews(): News[] {
    if (MockData._news) return MockData._news;
    MockData._news = [
      { id: 1, title: '我校学生在2026年全国数学建模竞赛中荣获一等奖', summary: '在刚刚结束的2026年全国大学生数学建模竞赛中，我校代表队勇夺一等奖，创造历史最佳成绩。', content: '在刚刚结束的2026年全国大学生数学建模竞赛中，我校代表队勇夺一等奖，创造历史最佳成绩。本次竞赛共有来自全国1200余所高校的45000余支队伍参赛，我校由数学学院、计算机学院和电子信息学院学生组成的联合代表队经过三天三夜的奋战，最终脱颖而出。', category: '校园新闻', source: '校报', publishTime: '2026-06-14', imageUrls: [], isCollected: false },
      { id: 2, title: '2026年校园文化艺术节圆满落幕', summary: '为期一周的校园文化艺术节在精彩的文艺汇演中圆满落幕，活动涵盖了音乐、舞蹈、戏剧、书法等多个领域。', content: '为期一周的校园文化艺术节在精彩的文艺汇演中圆满落幕。本次活动涵盖音乐、舞蹈、戏剧、书法等多个艺术领域，吸引了全校数千名师生的积极参与。', category: '校园新闻', source: '校团委', publishTime: '2026-06-10', imageUrls: [], isCollected: false },
      { id: 3, title: '【讲座预告】创业与创新——从校园到硅谷', summary: '知名校友李明博士将回校分享他的创业经历，从校园创业团队到硅谷独角兽的成长之路。', content: '知名校友、星云科技创始人兼CEO李明博士将于6月20日回校做"创业与创新——从校园到硅谷"主题演讲，分享他从校园创业团队到硅谷独角兽的成长经历与心得。\n\n时间：2026年6月20日 19:00\n地点：大学生活动中心多功能厅', category: '讲座信息', source: '创新创业中心', publishTime: '2026-06-08', imageUrls: [], isCollected: false },
      { id: 4, title: '关于举办校园二手书交易活动的通知', summary: '学生会将于本周末在图书馆广场举办二手书交易活动，欢迎同学们踊跃参与。', content: '为促进书籍资源循环利用，学生会将于本周末（6月14日-15日）在图书馆广场举办校园二手书交易活动。活动时间为每天9:00-17:00，欢迎同学们前来淘书或出售闲置教材。', category: '社团活动', source: '学生会', publishTime: '2026-06-06', imageUrls: [], isCollected: false },
      { id: 5, title: '我校获全国大学生创新创业大赛金奖', summary: '在刚刚落幕的全国大学生创新创业大赛中，我校"智能农业"项目斩获金奖。', content: '在刚刚落幕的全国大学生创新创业大赛中，我校"智能农业"项目斩获金奖。该项目由计算机学院和农学院联合研发，利用物联网和人工智能技术实现精准农业管理。', category: '校园新闻', source: '校报', publishTime: '2026-06-12', imageUrls: [], isCollected: false },
      { id: 6, title: '【学术讲座】量子计算前沿进展', summary: '物理学院邀请中科院院士来校做量子计算主题讲座。', content: '物理学院邀请中国科学院院士、量子计算专家郭院士于6月22日来校做"量子计算前沿进展"的学术报告。\n\n时间：14:30\n地点：物理学院学术报告厅', category: '讲座信息', source: '物理学院', publishTime: '2026-06-11', imageUrls: [], isCollected: false },
      { id: 7, title: '书法社团作品展', summary: '书法社团年度作品展在图书馆大厅展出，展期一周。', content: '书法社团年度作品展于6月12日-18日在图书馆大厅展出，本次共展出社员作品80余幅，涵盖楷书、行书、草书等多种书体。', category: '社团活动', source: '书法社团', publishTime: '2026-06-09', imageUrls: [], isCollected: false },
      { id: 8, title: '校园马拉松报名开启', summary: '2026年校园马拉松赛开始报名，设5公里和10公里两个组别。', content: '2026年校园马拉松赛将于6月30日举行，即日起开始报名。比赛设5公里健康跑和10公里竞技跑两个组别，完赛选手均可获得纪念奖牌。', category: '社团活动', source: '体育部', publishTime: '2026-06-07', imageUrls: [], isCollected: false },
      { id: 9, title: '【讲座】AI赋能教育教学改革', summary: '教务处邀请教育技术专家探讨AI在教育中的应用。', content: '教务处将于6月19日举办"AI赋能教育教学改革"专题讲座，邀请北京师范大学教育技术学院王教授主讲。', category: '讲座信息', source: '教务处', publishTime: '2026-06-05', imageUrls: [], isCollected: false },
      { id: 10, title: '我校志愿者圆满完成马拉松赛事服务', summary: '我校200名志愿者为城市马拉松提供了全程服务，获得组委会高度评价。', content: '在刚刚结束的城市马拉松赛中，我校200名志愿者为赛事提供了选手引导、补给分发、医疗协助等全程服务，服务时长累计超过4000小时。', category: '校园新闻', source: '校团委', publishTime: '2026-06-03', imageUrls: [], isCollected: false },
      { id: 11, title: '英语角活动通知', summary: '国际交流学院每周五晚举办英语角活动，欢迎全校师生参加。', content: '国际交流学院主办的英语角活动每周五晚19:00-21:00在国际交流中心举行，每期设定不同话题，外教现场指导。', category: '社团活动', source: '国际交流学院', publishTime: '2026-06-01', imageUrls: [], isCollected: false },
      { id: 12, title: '【学术讲座】大数据与智慧城市', summary: '城市管理学院邀请知名学者探讨大数据在智慧城市建设中的应用。', content: '城市管理学院邀请清华大学李教授于6月25日来校做"大数据与智慧城市"专题报告，欢迎感兴趣的师生参加。', category: '讲座信息', source: '城市管理学院', publishTime: '2026-05-30', imageUrls: [], isCollected: false },
    ];
    return MockData._news;
  }

  static getNewsTotal(): number {
    return MockData.getNews().length;
  }

  static getNewsPaged(offset: number, size: number): News[] {
    const all = MockData.getNews();
    return all.slice(offset, offset + size);
  }

  // ============================ 课程 ============================
  static getCourses(): Course[] {
    return [
      { id: 1, name: '高等数学A(二)', teacher: '王建国', classroom: '教学楼A201', weekday: 1, startSlot: 1, endSlot: 2, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], credit: 5, remindBeforeMin: 10, note: '' },
      { id: 2, name: '大学英语(四)', teacher: '陈丽华', classroom: '教学楼B102', weekday: 1, startSlot: 3, endSlot: 4, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], credit: 3, remindBeforeMin: 10, note: '' },
      { id: 3, name: '数据结构与算法', teacher: '张伟', classroom: '实验楼C301', weekday: 2, startSlot: 1, endSlot: 2, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], credit: 4, remindBeforeMin: 10, note: '' },
      { id: 4, name: '思想政治理论', teacher: '刘芳', classroom: '教学楼A305', weekday: 2, startSlot: 5, endSlot: 6, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], credit: 2, remindBeforeMin: 10, note: '' },
      { id: 5, name: '计算机组成原理', teacher: '赵强', classroom: '实验楼B201', weekday: 3, startSlot: 1, endSlot: 3, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], credit: 4, remindBeforeMin: 10, note: '' },
      { id: 6, name: '体育(篮球)', teacher: '马超', classroom: '体育馆', weekday: 4, startSlot: 3, endSlot: 4, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], credit: 1, remindBeforeMin: 10, note: '' },
      { id: 7, name: '操作系统', teacher: '孙磊', classroom: '教学楼C202', weekday: 5, startSlot: 1, endSlot: 2, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], credit: 3, remindBeforeMin: 10, note: '' },
      { id: 8, name: '数据库原理', teacher: '周涛', classroom: '实验楼A101', weekday: 5, startSlot: 5, endSlot: 6, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], credit: 3, remindBeforeMin: 10, note: '' },
    ];
  }

  // ============================ 成绩 ============================
  static getGrades(): Grade[] {
    return [
      { id: 1, courseName: '高等数学A(一)', score: 92, gpa: 4.0, credit: 5, semester: '2025-2026-1', examDate: '2026-01-15', category: '必修' },
      { id: 2, courseName: '大学英语(三)', score: 88, gpa: 3.7, credit: 3, semester: '2025-2026-1', examDate: '2026-01-12', category: '必修' },
      { id: 3, courseName: '程序设计基础', score: 95, gpa: 4.0, credit: 4, semester: '2025-2026-1', examDate: '2026-01-10', category: '必修' },
      { id: 4, courseName: '线性代数', score: 85, gpa: 3.3, credit: 3, semester: '2025-2026-1', examDate: '2026-01-08', category: '必修' },
      { id: 5, courseName: '思修与法基', score: 90, gpa: 4.0, credit: 2, semester: '2025-2026-1', examDate: '2026-01-05', category: '必修' },
      { id: 6, courseName: '大学物理(上)', score: 78, gpa: 2.7, credit: 4, semester: '2025-2026-1', examDate: '2026-01-18', category: '必修' },
    ];
  }

  // ============================ 图书 ============================
  static getBooks(): Book[] {
    return [
      { id: 1, name: '数据结构(C语言版)', author: '严蔚敏', isbn: '978-7-302-14751-0', publisher: '清华大学出版社', publishYear: '2007', location: '图书馆三楼A区-计算机科学', totalCount: 15, availableCount: 5, coverUrl: '', description: '本书是计算机专业经典教材，系统介绍了数据结构的基本概念、基本理论和基本方法。', isCollected: false, status: '' },
      { id: 2, name: '计算机组成原理', author: '唐朔飞', isbn: '978-7-04-034977-2', publisher: '高等教育出版社', publishYear: '2013', location: '图书馆三楼B区-计算机科学', totalCount: 10, availableCount: 3, coverUrl: '', description: '本书介绍了计算机各部件的组成和工作原理，是计算机专业核心课程教材。', isCollected: false, status: '' },
      { id: 3, name: '操作系统概念', author: 'Abraham Silberschatz', isbn: '978-7-111-60437-6', publisher: '机械工业出版社', publishYear: '2018', location: '图书馆三楼A区-计算机科学', totalCount: 8, availableCount: 8, coverUrl: '', description: '操作系统领域的经典教材，涵盖了进程管理、内存管理、文件系统等核心主题。', isCollected: false, status: '' },
      { id: 4, name: '算法导论(第三版)', author: 'Thomas H. Cormen', isbn: '978-7-111-40701-0', publisher: '机械工业出版社', publishYear: '2013', location: '图书馆三楼A区-计算机科学', totalCount: 12, availableCount: 0, coverUrl: '', description: '算法领域的权威著作，涵盖了排序、图算法、动态规划等经典算法。', isCollected: false, status: '' },
      { id: 5, name: '深入理解计算机系统', author: 'Randal E. Bryant', isbn: '978-7-111-54493-7', publisher: '机械工业出版社', publishYear: '2016', location: '图书馆三楼B区-计算机科学', totalCount: 6, availableCount: 2, coverUrl: '', description: '从程序员角度深入理解计算机系统，涵盖数据表示、机器级编程、内存层次结构等。', isCollected: false, status: '' },
    ];
  }

  // ============================ 失物招领 ============================
  private static _lostFound: LostFoundItem[] | null = null;

  static getLostFoundItems(): LostFoundItem[] {
    if (MockData._lostFound) return MockData._lostFound;
    MockData._lostFound = [
      { id: 1, type: '失物', title: '蓝色校园卡', description: '在图书馆附近丢失一张蓝色校园卡，卡号后四位为3721', location: '图书馆', lostTime: '2026-06-13', contactPhone: '13800138001', category: '校园卡', imageUrls: [], publishTime: '2026-06-13 15:00', publisher: '张三' },
      { id: 2, type: '失物', title: '黑色书包', description: '在教学楼A201丢失一个黑色双肩包，内有教材和笔记本', location: '教学楼A201', lostTime: '2026-06-12', contactPhone: '13800138002', category: '书包', imageUrls: [], publishTime: '2026-06-12 10:30', publisher: '李四' },
      { id: 3, type: '拾物', title: '捡到AirPods耳机', description: '在食堂二楼捡到一副白色AirPods耳机，带有蓝色保护壳', location: '食堂二楼', lostTime: '2026-06-14', contactPhone: '13800138003', category: '电子产品', imageUrls: [], publishTime: '2026-06-14 12:00', publisher: '王五' },
      { id: 4, type: '失物', title: '灰色钱包', description: '在操场附近丢失灰色钱包一个，内有身份证和学生证', location: '操场', lostTime: '2026-06-10', contactPhone: '13800138004', category: '其他', imageUrls: [], publishTime: '2026-06-10 16:00', publisher: '赵六' },
      { id: 5, type: '拾物', title: '银色U盘', description: '在实验楼C301捡到一个银色32G闪迪U盘', location: '实验楼C301', lostTime: '2026-06-15', contactPhone: '13800138005', category: '电子产品', imageUrls: [], publishTime: '2026-06-15 09:00', publisher: '小刘' },
      { id: 6, type: '失物', title: '红色眼镜盒', description: '在图书馆二楼自习区丢失一个红色眼镜盒，内含黑框眼镜', location: '图书馆二楼', lostTime: '2026-06-11', contactPhone: '13800138006', category: '其他', imageUrls: [], publishTime: '2026-06-11 14:20', publisher: '小陈' },
      { id: 7, type: '失物', title: '运动水杯', description: '在体育馆看台丢失一个蓝色运动水杯（特百惠）', location: '体育馆', lostTime: '2026-06-09', contactPhone: '13800138007', category: '其他', imageUrls: [], publishTime: '2026-06-09 17:00', publisher: '小孙' },
      { id: 8, type: '拾物', title: '捡到学生证', description: '在食堂一楼捡到学生证，学号2024011234', location: '食堂一楼', lostTime: '2026-06-16', contactPhone: '13800138008', category: '校园卡', imageUrls: [], publishTime: '2026-06-16 12:30', publisher: '小周' },
      { id: 9, type: '失物', title: '灰色围巾', description: '在操场附近丢失一条灰色羊绒围巾', location: '操场', lostTime: '2026-06-08', contactPhone: '13800138009', category: '其他', imageUrls: [], publishTime: '2026-06-08 19:00', publisher: '小吴' },
      { id: 10, type: '拾物', title: '捡到一串钥匙', description: '在A栋宿舍楼下捡到一串钥匙，共3把，带一个蓝色小熊挂件', location: 'A栋宿舍楼下', lostTime: '2026-06-17', contactPhone: '13800138010', category: '其他', imageUrls: [], publishTime: '2026-06-17 08:00', publisher: '小郑' },
      { id: 11, type: '失物', title: '黑色笔记本电脑充电器', description: '在图书馆三楼丢失一个联想笔记本充电器', location: '图书馆三楼', lostTime: '2026-06-07', contactPhone: '13800138011', category: '电子产品', imageUrls: [], publishTime: '2026-06-07 20:30', publisher: '小冯' },
      { id: 12, type: '拾物', title: '捡到一卡通', description: '在二食堂门口捡到一卡通一张，卡号2024015678', location: '二食堂门口', lostTime: '2026-06-18', contactPhone: '13800138012', category: '校园卡', imageUrls: [], publishTime: '2026-06-18 11:00', publisher: '小朱' },
      { id: 13, type: '失物', title: '粉色帆布包', description: '在教学楼B101教室丢失粉色帆布包一个，内有化妆品和小镜子', location: '教学楼B101', lostTime: '2026-06-06', contactPhone: '13800138013', category: '书包', imageUrls: [], publishTime: '2026-06-06 16:30', publisher: '小徐' },
      { id: 14, type: '失物', title: '蓝牙鼠标', description: '在实验楼A203丢失一个白色罗技蓝牙鼠标', location: '实验楼A203', lostTime: '2026-06-05', contactPhone: '13800138014', category: '电子产品', imageUrls: [], publishTime: '2026-06-05 10:00', publisher: '小胡' },
      { id: 15, type: '拾物', title: '捡到钱包', description: '在操场看台下方捡到一个棕色皮质钱包，内有少量现金和公交卡', location: '操场看台', lostTime: '2026-06-19', contactPhone: '13800138015', category: '其他', imageUrls: [], publishTime: '2026-06-19 07:30', publisher: '小高' },
    ];
    return MockData._lostFound;
  }

  static getLostFoundTotal(): number {
    return MockData.getLostFoundItems().length;
  }

  static getLostFoundPaged(offset: number, size: number): LostFoundItem[] {
    const all = MockData.getLostFoundItems();
    return all.slice(offset, offset + size);
  }

  // ============================ 美食 ============================
  static getFoods(): Food[] {
    return [
      { id: 1, name: '招牌牛肉面', location: '第一食堂一楼', description: '汤鲜味美，牛肉软烂，面条劲道，是食堂的招牌美食', featureDish: '红烧牛肉面', rating: 4.5, ratingCount: 128, imageUrls: [], isCollected: false, myRating: 0 },
      { id: 2, name: '麻辣香锅', location: '第二食堂二楼', description: '自选食材，麻辣鲜香，适合多人聚餐', featureDish: '麻辣香锅套餐', rating: 4.2, ratingCount: 95, imageUrls: [], isCollected: false, myRating: 0 },
      { id: 3, name: '黄焖鸡米饭', location: '美食街A区', description: '鸡肉鲜嫩多汁，配米饭绝佳', featureDish: '黄焖鸡', rating: 4.0, ratingCount: 76, imageUrls: [], isCollected: false, myRating: 0 },
      { id: 4, name: '石锅拌饭', location: '第三食堂一楼', description: '韩式风味，底部锅巴香脆，配料丰富', featureDish: '韩式石锅拌饭', rating: 4.3, ratingCount: 62, imageUrls: [], isCollected: false, myRating: 0 },
      { id: 5, name: '过桥米线', location: '美食街B区', description: '汤底浓厚，食材新鲜，一份够两人吃', featureDish: '状元过桥米线', rating: 3.8, ratingCount: 43, imageUrls: [], isCollected: false, myRating: 0 },
    ];
  }

  // ============================ 待办 ============================
  static getTodos(): TodoItem[] {
    return [
      { id: 1, content: '完成数据结构课程作业第三章', category: '学习', isCompleted: false, remindTime: '2026-06-16 20:00', createTime: '2026-06-14 10:00' },
      { id: 2, content: '复习操作系统第二章内容', category: '学习', isCompleted: false, remindTime: '2026-06-17 18:00', createTime: '2026-06-14 10:00' },
      { id: 3, content: '去图书馆还书', category: '生活', isCompleted: false, remindTime: '2026-06-16 12:00', createTime: '2026-06-13 09:00' },
      { id: 4, content: '参加社团例会', category: '其他', isCompleted: true, remindTime: '2026-06-12 17:00', createTime: '2026-06-10 08:00' },
    ];
  }

  static getDefaultUser(): UserInfo {
    return {
      avatar: '',
      avatarUri: '',
      nickname: '未设置昵称',
      studentId: '2024001',
      college: '计算机学院',
      major: '计算机科学与技术',
      grade: '2024级',
      phone: '',
      email: ''
    };
  }

  // ============================ 校园建筑 ============================
  static getCampusBuildings(): CampusBuilding[] {
    return [
      new CampusBuilding('教学楼A', 150, 80, '主要教学场所，共5层，设有多媒体教室50间'),
      new CampusBuilding('教学楼B', 150, 180, '文科教学楼，共4层，设有语音室和多媒体教室'),
      new CampusBuilding('教学楼C', 150, 280, '理工科教学楼，共6层，设有专业实验室'),
      new CampusBuilding('图书馆', 300, 80, '校园标志性建筑，藏书200余万册，设有自习座位3000个'),
      new CampusBuilding('实验楼A', 300, 220, '计算机与电子信息实验中心'),
      new CampusBuilding('实验楼B', 300, 320, '物理与化学实验中心'),
      new CampusBuilding('第一食堂', 50, 350, '一楼中式快餐，二楼特色小吃'),
      new CampusBuilding('第二食堂', 200, 450, '提供中西式餐饮，二楼为教工餐厅'),
      new CampusBuilding('第三食堂', 100, 500, '新装修食堂，提供各地风味美食'),
      new CampusBuilding('体育馆', 400, 150, '综合体育馆，含篮球场、羽毛球场、游泳馆'),
      new CampusBuilding('操场', 450, 280, '标准400米跑道，含足球场'),
      new CampusBuilding('宿舍1号楼', 30, 100, '本科生男生宿舍'),
      new CampusBuilding('宿舍2号楼', 30, 200, '本科生女生宿舍'),
      new CampusBuilding('宿舍3号楼', 30, 300, '研究生宿舍'),
      new CampusBuilding('大学生活动中心', 380, 350, '学生社团活动场所，含多功能厅、排练室'),
      new CampusBuilding('校医院', 380, 430, '提供基本医疗服务，24小时急诊'),
    ];
  }
}