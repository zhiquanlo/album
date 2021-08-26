## 相册选择 demo

* 图片查看文件只能浏览图片不能浏览视频，只是demo演示需要，需要视频预览自行加入

## ZQAlbum 为功能调用

/// 显示选择相册
/// @param hostvc 操作控制器
/// @param modalPresentationStyle 模态显示样式
/// @param albumSelectedType 相册选择类型
+(void)showAlbumListFromViewController:(UIViewController *)hostvc  modalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle albumSelectedType:(ZQAlbumSelectedType)albumSelectedType;

/// @param imageMaxNumber 图片最大的选择数量 0为无限制
/// @param videoMaxNumber 图片最大的选择数量 0为无限制
/// @param isImageVideoCount 最大的选择数据图片视频是否混合计算  isImageVideoCount为YES视为混合计算 imageMaxNumber+videoMaxNumber的总和
+(void)setImageMaxNumber:(NSInteger)imageMaxNumber videoMaxNumber:(NSInteger)videoMaxNumber isImageVideoCount:(BOOL)isImageVideoCount;

/// @param doneStartRequestDataBlock 完成开始请数据片可以在这里做加载框 开始加载回调
+(void)doneStartRequestDataBlock:(DoneStartRequestDataBlock)doneStartRequestDataBlock;

/// @param doneEndRequestDataBlock 完成结束请求数据可以在这里关闭加载框 结束加载回调
+(void)doneEndRequestDataBlock:(DoneEndRequestDataBlock)doneEndRequestDataBlock;

/// @param previewStartRequestDataBlock 预览开始请数据片可以在这里做加载框 开始加载回调
+(void)previewStartRequestDataBlock:(PreviewStartRequestDataBlock)previewStartRequestDataBlock;

/// @param previewEndRequestDataBlock 预览结束请求数据可以在这里关闭加载框 结束加载回调
+(void)previewEndRequestDataBlock:(PreviewEndRequestDataBlock)previewEndRequestDataBlock;

/// @param maximumBlock 最大的选择数量限制回调
+(void)maximumBlock:(MaximumBlock)maximumBlock;

#### ZQAlbumListManager 
为单例管理所有的block、枚举、全局变量都写在这里
/**
 ZQAlbumSelectedTypeAll 相片、视频
 ZQAlbumSelectedTypeImage 相片
 ZQAlbumSelectedTypeVideo 视频
 */
typedef NS_ENUM(NSInteger, ZQAlbumSelectedType){
    ZQAlbumSelectedTypeAll = 0,
    ZQAlbumSelectedTypeImage = 1,
    ZQAlbumSelectedTypeVideo = 2
};
//完成开始请求数据
typedef void(^DoneStartRequestDataBlock)(void);
//完成结束请求数据
typedef void(^DoneEndRequestDataBlock)(NSMutableArray *data);
//预览开始请求数据
typedef void(^PreviewStartRequestDataBlock)(void);
//预览结束请求数据
typedef void(^PreviewEndRequestDataBlock)(NSMutableArray *data,UIViewController *showFromVC);
//最大限制回调
typedef void (^MaximumBlock)(ZQAlbumSelectedType albumSelectedType);
@interface ZQAlbumListManager : NSObject
+(instancetype)manager;

/// 点击完成的开始回调
@property (nonatomic,copy)DoneStartRequestDataBlock doneStartRequestDataBlock;
/// 点击完成的结束回调
@property (nonatomic,copy)DoneEndRequestDataBlock doneEndRequestDataBlock;
/// 点击预览的开始回调
@property (nonatomic,copy)PreviewStartRequestDataBlock previewStartRequestDataBlock;
/// 点击预览的结束回调
@property (nonatomic,copy)PreviewEndRequestDataBlock previewEndRequestDataBlock;

/// 最大限制回调
@property (nonatomic,copy)MaximumBlock maximumBlock;

/// 设置图片最大数
@property (nonatomic,assign)NSInteger imageMaxNumber;

/// 设置视频最大数
@property (nonatomic,assign)NSInteger videoMaxNumber;

/// 是否图片视频数量合并
@property (nonatomic,assign)BOOL isImageVideoCount;

/// 选择的类型
@property (nonatomic,assign)ZQAlbumSelectedType albumSelectedType;

## ZQAlbumListVC

* 显示相册控制器，相册显示、权限判断、预览、原图、完成逻辑都这里

## ZQAlbumNameListView

* 下拉相册名称
## ZQAlbumShowView
* 相册显示的表格视图

## ZQNoJurisdictionAlbumAlertView
* 权限没开启显示


