> 参考:
> Android 属性动画：这是一篇很详细的 属性动画 总结&攻略
> https://blog.csdn.net/carson_ho/article/details/72909894  

[TOC]
## 1. 动画类型
![](https://imgconvert.csdnimg.cn/aHR0cDovL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pby91cGxvYWRfaW1hZ2VzLzk0NDM2NS01ODE5YzBiOTQ0YTI3NmU5LnBuZz9pbWFnZU1vZ3IyL2F1dG8tb3JpZW50L3N0cmlwJTdDaW1hZ2VWaWV3Mi8yL3cvMTI0MA)  

## 2. 视图动画
- 作用对象局限：View
- 没有改变View的属性，只是改变视觉效果
- 动画效果单一
## 3. 属性动画 
### 3.1 原理
![](https://imgconvert.csdnimg.cn/aHR0cDovL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pby91cGxvYWRfaW1hZ2VzLzk0NDM2NS0xNmExNjJhNzMxZjU0OGQ4LnBuZz9pbWFnZU1vZ3IyL2F1dG8tb3JpZW50L3N0cmlwJTdDaW1hZ2VWaWV3Mi8yL3cvMTI0MA)

ValueAnimator  
ObjectAnimator
自动和手动?
ValueAnimator 类是先改变值，然后 手动赋值 给对象的属性从而实现动画；是 间接 对对象属性进行操作；
ObjectAnimator 类是先改变值，然后 自动赋值 给对象的属性从而实现动画；是 直接 对对象属性进行操作；

自动：自动调用该对象属性的get() set() 自动取值