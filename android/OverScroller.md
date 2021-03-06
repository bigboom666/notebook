# 介绍
Android里OverScroller类是为了实现View平滑滚动的一个Helper类。通常在自定义的View时使用，在View中定义一个私有成员mScroller = new OverScroller(context)。设置mScroller滚动的位置时，并不会导致View的滚动，通常是用mScroller记录/计算View滚动的位置，再重写View的computeScroll()，完成实际的滚动

```java
mScroller.getCurrX() //获取mScroller当前水平滚动的位置
mScroller.getCurrY() //获取mScroller当前竖直滚动的位置
mScroller.getFinalX() //获取mScroller最终停止的水平位置
mScroller.getFinalY() //获取mScroller最终停止的竖直位置
mScroller.setFinalX(int newX) //设置mScroller最终停留的水平位置，没有动画效果，直接跳到目标位置
mScroller.setFinalY(int newY) //设置mScroller最终停留的竖直位置，没有动画效果，直接跳到目标位置

//滚动，startX, startY为开始滚动的位置，dx,dy为滚动的偏移量, duration为完成滚动的时间
mScroller.startScroll(int startX, int startY, int dx, int dy) //使用默认完成时间250ms
mScroller.startScroll(int startX, int startY, int dx, int dy, int duration)
mScroller.computeScrollOffset() //返回值为boolean，true说明滚动尚未完成，false说明滚动已经完成。这是一个很重要的方法，通常放在View.computeScroll()中，用来判断是否滚动是否结束。
```

# 例子
```java
private static final String TAG = "Scroller";  

private OverScroller mScroller;  

public CustomView(Context context, AttributeSet attrs) {  
    super(context, attrs);  
    mScroller = new OverScroller(context);  
}  

//调用此方法滚动到目标位置  
public void smoothScrollTo(int fx, int fy) {  
    int dx = fx - mScroller.getFinalX();  
    int dy = fy - mScroller.getFinalY();  
    smoothScrollBy(dx, dy);  
}  

//调用此方法设置滚动的相对偏移  
public void smoothScrollBy(int dx, int dy) {  

    //设置mScroller的滚动偏移量  
    mScroller.startScroll(mScroller.getFinalX(), mScroller.getFinalY(), dx, dy);  
    invalidate();//这里必须调用invalidate()才能保证computeScroll()会被调用，否则不一定会刷新界面，看不到滚动效果  
}  
  
@Override  
public void computeScroll() {  
  
    //先判断mScroller滚动是否完成  
    if (mScroller.computeScrollOffset()) {  
      
        //这里调用View的scrollTo()完成实际的滚动  
        scrollTo(mScroller.getCurrX(), mScroller.getCurrY());  
          
        //必须调用该方法，否则不一定能看到滚动效果  
        postInvalidate();  
    }  
    super.computeScroll();  
}  
```