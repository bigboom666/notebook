# Service
主要用于在后台处理一些耗时的逻辑，或者去执行某些需要长期运行的任务。必要的时候我们甚至可以在程序退出的情况下，让Service在后台继续保持运行状态。  

service和activity的区别？  


onBind()方法我们都没有使用到，这个方法其实就是用于和Activity建立关联的  



MyService

1. 完成任务类 class MyBinder extends Binder  
2. 在MyService类中完成 onBind方法

MainActivity  
3. 匿名类 new ServiceConnection() 重写 onServiceConnection（）方法  
4. 在按键onClick()逻辑中，调用bindService()



先点击一下Start Service按钮，再点击一下Bind Service按钮，这样就将Service启动起来，并和Activity建立了关联。然后点击Stop Service按钮后Service并不会销毁，再点击一下Unbind Service按钮，Service就会销毁了

始终记得在Service的onDestroy()方法里去清理掉那些不再使用的资源，防止在Service被销毁后还会有一些不再使用的对象仍占用着内存


# service和Thread 
Android的后台就是指，它的运行是完全不依赖UI的。即使Activity被销毁，或者程序被关闭，只要进程还在，Service就可以继续运行。比如说一些应用程序，始终需要与服务器之间始终保持着心跳连接，就可以使用Service来实现。你可能又会问，前面不是刚刚验证过Service是运行在主线程里的么？在这里一直执行着心跳连接，难道就不会阻塞主线程的运行吗？当然会，但是我们可以在Service中再创建一个子线程，然后在这里去处理耗时逻辑就没问题了。



额，既然在Service里也要创建一个子线程，那为什么不直接在Activity里创建呢？这是因为Activity很难对Thread进行控制，当Activity被销毁之后，就没有任何其它的办法可以再重新获取到之前创建的子线程的实例。而且在一个Activity中创建的子线程，另一个Activity无法对其进行操作。但是Service就不同了，所有的Activity都可以与Service进行关联，然后可以很方便地操作其中的方法，即使Activity被销毁了，之后只要重新与Service建立关联，就又能够获取到原有的Service中Binder的实例。因此，使用Service来处理后台任务，Activity就可以放心地finish，完全不需要担心无法对后台任务进行控制的情况。




android 9.0上使用前台服务，需要添加权限  
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />


远程Service不能binder：Activity和Service运行在两个不同的进程当中，这时就不能再使用传统的建立关联的方式，程序也就崩溃了。
而需要用AIDL



# 参考：
[Android Service完全解析，关于服务你所需知道的一切(上)](https://blog.csdn.net/guolin_blog/article/details/11952435)