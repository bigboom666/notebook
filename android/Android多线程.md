# 作用
Android官方声明：在多线程编程时有两大原则：

1. 不要阻塞UI线程（即主线程）：单线程会导致主线程阻塞，然后出现ANR错误：主线程被阻塞超过5s则会出现错误  
2. 不要在UI线程之外更新UI组件

# 实现
![](https://img-blog.csdnimg.cn/20190513085645362.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9jYXJzb25oby5ibG9nLmNzZG4ubmV0,size_16,color_FFFFFF,t_70)

# 参考  
[Android多线程：你必须要了解的多线程基础知识汇总](https://blog.csdn.net/carson_ho/article/details/90166487)

