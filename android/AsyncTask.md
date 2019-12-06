# 作用
- 实现多线程  
在工作线程中执行任务，如 耗时任务  
- 异步通信、消息传递  
实现工作线程 & 主线程（UI线程）之间的通信，即：将工作线程的执行结果传递给主线程，从而在主线程中执行相关的UI操作

# 优点  
- 方便实现异步通信  
不需使用 “任务线程（如继承Thread类） + Handler”的复杂组合  
- 节省资源  
采用线程池的缓存线程 + 复用线程，避免了频繁创建 & 销毁线程所带来的系统资源开销  

# 介绍
- 一个Android 已封装好的轻量级异步类
- 属于抽象类，即使用时需 实现子类

# 类定义
```java
public abstract class AsyncTask<Params, Progress, Result> { 
 ... 
}

// 类中参数为3种泛型类型
// 整体作用：控制AsyncTask子类执行线程任务时各个阶段的返回类型
// 具体说明：
	// a. Params：开始异步任务执行时传入的参数类型，对应excute（）中传递的参数
	// b. Progress：异步任务执行过程中，返回下载进度值的类型
	// c. Result：异步任务执行完成后，返回的结果类型，与doInBackground()的返回值类型保持一致
// 注：
	// a. 使用时并不是所有类型都被使用
	// b. 若无被使用，可用java.lang.Void类型代替
	// c. 若有不同业务，需额外再写1个AsyncTask的子类
}
```

# 使用
[android - AsyncTask 的使用](https://www.jianshu.com/p/990669c6d4f2)



# 参考
[Android 多线程：这是一份详细的AsyncTask使用教程](https://blog.csdn.net/carson_ho/article/details/79314325)
[Android 多线程：AsyncTask的原理 及其源码分析](https://blog.csdn.net/carson_ho/article/details/79314326)