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

-(void)setUp
{

    
    
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



-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject] ;
    CGPoint curP =   [touch locationInView:self];
    NSValue *value = [NSValue valueWithCGPoint:curP] ;
    [self.points addObject:value];
    
    
    
    
//    
//    if(self.points.count % 2 == 0){
//    
//        [self.points addObject:value];
//        
//        
//      //  [self.points removeObjectAtIndex:0];
//    }

    
// [self.points addObject:value];
    
//    
//    if(self.points.count >PointsCount){
//        
//        
//        [self.points removeObjectAtIndex:0];
//    
//    }
    
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
        
        layer.fillColor = [UIColor clearColor].CGColor ;
        
        layer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:_alpaF].CGColor;
        [self.layer addSublayer:layer] ;
        layer.lineWidth = _widthF ;

        
        layer.opacity = _alpaF; //背景透明度
        
        
        layer.bounds = CGRectMake(0, 0, 20, 20) ;
        
        
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
    
      _alpaF = 0.5 ;
    
    _widthF = 5 ;

    for(int i = 0 ;i < self.points.count ; i++){
        
        _alpaF += 1.0/PointsCount ;
        
        _widthF += 10.0/PointsCount ;
    
        NSValue *value= [self.points objectAtIndex:i] ;
        
        CGPoint curP = [value CGPointValue] ;
        

        UIBezierPath *path = [UIBezierPath bezierPath] ;
        
        [path moveToPoint:curP];
        [path addLineToPoint:curP];
        
        
        CGPoint p = CGPointZero;
        
            
            if(i >= 1){
             NSValue *value= [self.points objectAtIndex: i - 1] ;
              CGPoint  p1 = [value CGPointValue] ;
                
                p = p1 ;
                
                
              //  [path addLineToPoint:p1];
                
                //取两个点的中间点
                CGPoint midP = [self midPointWithPoint1:p1 Point2:curP] ;
                
                  [ path addQuadCurveToPoint:midP controlPoint:curP];
                
                  [ path addQuadCurveToPoint:curP controlPoint:midP];
                
                
            }
        
        if(i >= 2){
            NSValue *value= [self.points objectAtIndex: i - 2] ;
            CGPoint  p2 = [value CGPointValue] ;
            
            
            if(!CGPointEqualToPoint(p, CGPointZero )){
            //取两个点的中间点
            CGPoint midP = [self midPointWithPoint1:p2 Point2:p] ;
            
            [ path addQuadCurveToPoint:midP controlPoint:p];
                
                  [ path addQuadCurveToPoint:p2 controlPoint:midP];
                
               // [path addLineToPoint:p2];
            }
            
            
        }
        
        if(i >= 3){
        
        
        
        }

       // [path addLineToPoint:curP] ;
    
        CAShapeLayer *layer = [self.layers objectAtIndex:i];

        layer.path = path.CGPath ;
        
        layer.lineWidth = _widthF ;
        
        
        layer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:_alpaF].CGColor;
        
        
        layer.opacity = _alpaF; //背景透明度
    }
    
    if(self.points.count >20){
    
   [self.points removeObjectAtIndex:0];
    }

}
#pragma mark -获取两点的中间点

-(CGPoint) midPointWithPoint1:(CGPoint) p1 Point2:(CGPoint) p2{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
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
