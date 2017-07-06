//
//  LineView.m
//  test拖尾效果
//
//  Created by LiGongJiao on 17/5/12.
//  Copyright © 2017年 DuanJi (WuHan) Network CO., LTD. All rights reserved.
//

#import "LineView.h"


#define PointsCount 50

@interface LineView ()

@property (nonatomic, strong)NSMutableArray *layers;

@property (nonatomic, strong)NSMutableArray *points;


@property (nonatomic, assign) CGFloat  alpaF;

@property (nonatomic, assign)CGFloat   widthF;


//@property (nonatomic, strong)CAGradientLayer *   slayer;

@property (nonatomic, strong)UIBezierPath   *path;


@property (nonatomic, strong)CAShapeLayer *slayer;
@property (nonatomic, strong)CAGradientLayer *gradient  ;
@end

@implementation LineView


-(void)awakeFromNib
{
    [super awakeFromNib] ;
    [self setUp ];
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        
        
        [self setUp];
        
        
        
    }
    return self ;
    
}

-(CAGradientLayer *)gradient
{
    if(!_gradient){
    
        _gradient = [CAGradientLayer layer] ;
        
    }

    return  _gradient ;

}

-(CAShapeLayer *)slayer{
    if(!_slayer){
        
        _slayer = [CAShapeLayer layer] ;
    }
    
    return _slayer ;
    
}



-(void)setUp
{

    
    [self.layer addSublayer:self.slayer];
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject] ;
    CGPoint curP =   [touch locationInView:self];
    NSValue *value = [NSValue valueWithCGPoint:curP] ;
    [self.points addObject:value];

    
    //创建拖尾图层
    
    [self createLayers];
  
}

-(void)start{
    
    
    CGFloat alpaF = 1.0 ;
    
    for (int i = 0 ; i <self.points.count ; i++) {
        
        alpaF -= 0.08  ;
        
        CGPoint curP = [self.points[i] CGPointValue] ;
        
        
        if(i == 0){
            _path = [UIBezierPath bezierPath] ;
            
            [_path moveToPoint:curP];
        }else{
            
            _path.lineWidth = 10 ;
            
            
            //  _path.lineJoinStyle
            
            
            CGPoint lastP = [self.points[i-1] CGPointValue] ;
            
            
            CGPoint midP = [self midPointWithPoint1:lastP Point2:curP];
            
            
            
            //  [_path addLineToPoint:curP];
            
            [_path addQuadCurveToPoint:midP controlPoint:lastP];
            
            
            
            
            
            self.slayer.path = _path.CGPath ;
            
            self.slayer.fillColor = [UIColor clearColor].CGColor ;
            
            self.slayer.lineWidth = 5 ;
            
            //  self.slayer.strokeColor = [UIColor redColor].CGColor ;
            
            self.slayer.lineJoin = kCALineJoinRound ;
            
            self.slayer.lineCap = kCALineCapRound ;
            
            
            self.slayer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
            
  
        }
    }
    
    while (self.points.count > 10) {
        [self.points removeObjectAtIndex:0];
    }
    
}
#pragma mark -获取两点的中间点

-(CGPoint) midPointWithPoint1:(CGPoint) p1 Point2:(CGPoint) p2{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}



-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject] ;
    CGPoint curP =   [touch locationInView:self];
    NSValue *value = [NSValue valueWithCGPoint:curP] ;
    [self.points addObject:value];
    
    
//    [self start];
    
    
    [self startAnim];
    
    
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
  [self removeLayersAndPoints];
}

/**
 *  创建图层
 */

-(void)createLayers{
    
    _alpaF = 1 ;
    
    _widthF = 10 ;
    
    for(int i = 0 ; i < PointsCount + 1; i++){
        
        
        _alpaF -= 1.0/PointsCount ;
        
        _widthF -= 10.0/PointsCount ;
        
        
        //图层
        CAShapeLayer *layer = [CAShapeLayer layer] ;
        
     //   layer.fillColor = [UIColor clearColor].CGColor ;
        
      //  layer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:_alpaF].CGColor;
        [self.layer addSublayer:layer] ;
        layer.lineWidth = _widthF ;

        
   // layer.opacity = _alpaF; //背景透明度
        
        
      //  layer.bounds = CGRectMake(0, 0, 20, 20) ;

        [self.layers insertObject:layer atIndex:0];
    }
    
}


-(UIColor *)radomColor{

    return [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
}
/**
 *  移除所有的点和图层
 */
-(void)removeLayersAndPoints{

    [self.points removeAllObjects];

    [self.layers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    [self.layers removeAllObjects];
}

/**
 *  开始动画
 */
-(void)startAnim{
    
    
    
    //   CGPoint point = CGPointZero ;
    
    _alpaF =0.3 ;
    
    _widthF = 5 ;
    
    
    CGPoint  startP  ;
    
    CGPoint controlP;
    
    NSValue *value= [self.points objectAtIndex:0] ;
    
    CGPoint p0 = [value CGPointValue] ;
    
    CGPoint endP = p0 ;
    
    for(int i = 0 ;i < self.points.count -1; i++){
        
        UIBezierPath *path = [UIBezierPath bezierPath] ;
        
        
        
        startP = endP ;
        
        
        
        _alpaF += 1.0/PointsCount ;
        
          _widthF += 10.0/PointsCount ;
        
        NSValue *value= [self.points objectAtIndex:i] ;
        
        CGPoint curP = [value CGPointValue] ;
        
        controlP = curP;
        
        NSValue *value1= [self.points objectAtIndex: i + 1] ;
        CGPoint  p1 = [value1 CGPointValue] ;
      
        
        
        endP = [self midPointWithPoint1:controlP Point2:p1] ;
        
        
       
        
        
        [path moveToPoint:startP] ;
        
        
        [path addQuadCurveToPoint:endP controlPoint:controlP];
        

        
        
        CAShapeLayer *layer = [self.layers objectAtIndex:i];
        
        layer.path = path.CGPath ;
        
        layer.lineWidth = _widthF ;
        
        
        layer.fillColor =[UIColor redColor] .CGColor;
 
        layer.strokeColor = [UIColor redColor] .CGColor;// //  [UIColor colorWithRed:1 green:0 blue:0 alpha:_alpaF].CGColor ;
        
        
        // layer.fillColor = [UIColor redColor] .CGColor;
        
        layer.backgroundColor =  [UIColor blueColor].CGColor ;
        
        layer.opacity = _alpaF; //背景透明度
        
        layer.lineJoin = kCALineJoinRound ;
        
      //  layer.lineCap = kCALineCapRound ;
        
        // layer.lineDashPhase =  _alpaF ;
        
    }
    
    
    
    while (self.points.count >20){
        [self.points removeObjectAtIndex:0];
    }
    
}


-(NSMutableArray *)layers{
    
    
    if(!_layers){
        
        _layers = [NSMutableArray new] ;
    }
    
    return _layers ;
    
}

-(NSMutableArray *)points{
    if(!_points){
        
        _points = [NSMutableArray new] ;
    }
    
    return _points ;
    
}

@end
