# GestureDetector
GestureDetector这个类对外提供了两个接口和一个内部类,其中包括:
回调接口：OnGestureListener，OnDoubleTapListener，OnContextClickListener
内部类:SimpleOnGestureListener
![](https://upload-images.jianshu.io/upload_images/1830162-99af6b0caeb230be.png?imageMogr2/auto-orient/strip|imageView2/2/w/601/format/webp)

# 基本
## OnGestureListener
这个Listener监听一些手势，如单击、滑动、长按等操作
- onDown(MotionEvent e):用户按下屏幕的时候的回调。
- onShowPress(MotionEvent e)：用户按下按键后100ms（根据Android7.0源码）还没有松开或者移动就会回调，官方在源码的解释是说一般用于告诉用户已经识别按下事件的回调（我暂时想不出有什么用途，因为这个回调触发之后还会触发其他的，不像长按）。
- onLongPress(MotionEvent e)：用户长按后（好像不同手机的时间不同，源码里默认是100ms+500ms）触发，触发之后不会触发其他回调，直至松开（UP事件）。
- onScroll(MotionEvent e1, MotionEvent e2,float distanceX, float distanceY)：手指滑动的时候执行的回调（接收到MOVE事件，且位移大于一定距离），e1,e2分别是之前DOWN事件和当前的MOVE事件，distanceX和- distanceY就是当前MOVE事件和上一个MOVE事件的位移量。
- onFling(MotionEvent e1, MotionEvent e2, float velocityX,float velocityY)：用户执行抛操作之后的回调，MOVE事件之后手松开（UP事件）那一瞬间的x或者y方向速度，如果达到一定数值（源码默认是每秒50px），就是抛操作（也就是快速滑动的时候松手会有这个回调，因此基本上有onFling必然有onScroll）。
- onSingleTapUp(MotionEvent e)：用户手指松开（UP事件）的时候如果没有执行onScroll()和onLongPress()这两个回调的话，就会回调这个，说明这是一个点击抬起事件，但是不能区分是否双击事件的抬起。

## OnDoubleTapListener
- onSingleTapConfirmed(MotionEvent e)：可以确认（通过单击DOWN后300ms没有下一个DOWN事件确认）这不是一个双击事件，而是一个单击事件的时候会回调。
- onDoubleTap(MotionEvent e)：可以确认这是一个双击事件的时候回调。
- onDoubleTapEvent(MotionEvent e)：onDoubleTap()回调之后的输入事件（DOWN、MOVE、UP）都会回调这个方法（这个方法可以实现一些双击后的控制，如让View双击后变得可拖动等）。

## OnContextClickListener
- onContextClick(MotionEvent e)：当鼠标/触摸板，右键点击时候的回调。

## SimpleOnGestureListener
实现了上面三个接口的类，拥有上面三个的所有回调方法,继承它的时候只需要选取我们所需要的回调方法来重写就可以了。

> 上面所有的回调方法的返回值都是boolean类型，和View的事件传递机制一样，返回true表示消耗了事件，flase表示没有消耗。


# 使用
```java
// 1.创建一个监听回调
SimpleOnGestureListener listener = new SimpleOnGestureListener() {
    @Override public boolean onDoubleTap(MotionEvent e) {
        Toast.makeText(MainActivity.this, "双击666", Toast.LENGTH_SHORT).show();
        return super.onDoubleTap(e);
    }
};

// 2.创建一个检测器
final GestureDetector detector = new GestureDetector(this, listener);

// 3.给监听器设置数据源
view.setOnTouchListener(new View.OnTouchListener() {
    @Override public boolean onTouch(View v, MotionEvent event) {
        return detector.onTouchEvent(event);
    }
});
```
View类有个View.OnTouchListener内部接口，通过重写他的onTouch(View v, MotionEvent event)方法，我们可以处理一些touch事件