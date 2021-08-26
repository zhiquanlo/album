//
//  ZQAlbumNameListView.m
//  demo
//
//  Created by 李志权 on 2021/7/27.
//  Copyright © 2021 kailu. All rights reserved.
//

#import "ZQAlbumNameListView.h"



@interface ZQAlbumNameListCell:UITableViewCell
@property (nonatomic,strong)UIImageView *titleImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@end
@implementation ZQAlbumNameListCell
-(UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
        _titleImageView.clipsToBounds = YES;
        [self.contentView addSubview:_titleImageView];
    }
    return _titleImageView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.titleImageView.frame)+10, 0, CGRectGetWidth(self.frame)-(CGRectGetWidth(self.titleImageView.frame)+10), CGRectGetHeight(self.frame))];
        _nameLabel.font = [UIFont boldSystemFontOfSize:13];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
@end

@interface ZQAlbumNameListView()<UITableViewDelegate,UITableViewDataSource>
/// 相册名称
@property (nonatomic,strong)NSArray *albumNames;
@property (nonatomic,copy)SelectIndexPathRow selectIndexPathRow;
@property (nonatomic,assign)CGFloat h;
@property (nonatomic,strong)PHImageRequestOptions *options;
@end
@implementation ZQAlbumNameListView
- (PHImageRequestOptions *)options{
    if (!_options) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        _options = options;
    }
    return _options;
}
-(instancetype)initWithFrame:(CGRect)frame selectIndexPathRow:(SelectIndexPathRow)selectIndexPathRow{
    if (self = [super initWithFrame:frame]) {
        self.selectIndexPathRow = selectIndexPathRow;
        self.h = frame.size.height;
        self.delegate = self;
        self.dataSource  = self;
        self.tableFooterView = [UIView new];
        self.backgroundColor = [UIColor colorWithRed:19/255 green:18/255 blue:18/255 alpha:1];
        [self registerClass:[ZQAlbumNameListCell class] forCellReuseIdentifier:@"ZQAlbumNameListCell"];
    }
    return self;
}
- (void)showAlbumNameListViewWithAlbumNames:(NSArray <ZQAlbumNameModel *>*)albumNames{
    if (self.albumNames && self.frame.size.height == self.h) {
        [self hiddenAlbumNameListView];
        return;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.h);
    }];
    if (self.albumNames != albumNames) {
        self.albumNames = albumNames;
        [self reloadData];
        if (albumNames.count) {
            NSIndexPath *path=[NSIndexPath indexPathForItem:0 inSection:0];
            [self tableView:self didSelectRowAtIndexPath:path];
        }
    }
}
-(void)hiddenAlbumNameListView{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.h);
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,0);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albumNames.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *rid=@"ZQAlbumNameListCell";
    ZQAlbumNameListCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    ZQAlbumNameModel *model = self.albumNames[indexPath.row];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    PHAsset *asset = [model.assets firstObject];
    NSLog(@"%f",asset.duration);
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(50, 50) contentMode:PHImageContentModeDefault options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.titleImageView.image =result;
    }];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@%zi",model.name,model.count];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndexPathRow) {
        self.selectIndexPathRow(indexPath.row);
    }
    [self hiddenAlbumNameListView];
}
@end

@implementation ZQAlbumNameModel

@end
