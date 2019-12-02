## Activity

R.layout.xxx    
项目中添加的任何资源都会在R文件中生成一个相应的资源id ，因此我们刚才创建的first_layout.xml 布局的id 现在应该是已经添加到R文件中了



1. 创建空Activity工程  
2. 新建Activity-FirstActivity
3. 创建布局，编辑布局
4. 在新建Activity中调用setContentView()加载布局
5. 在AndroidManifest文件中注册Activity，并配置为主Activity




### 生命周期

![Activity生命周期](https://developer.android.com/images/activity_lifecycle.png?hl=zh-cn)  
![](https://upload-images.jianshu.io/upload_images/1467278-21c8544f417e6713.png?imageMogr2/auto-orient/strip|imageView2/2/w/550/format/webp)
#### 1. 生命周期中各个方法的含义和作用
（1）onCreate:create表示创建，这是Activity生命周期的第一个方法，也是我们在android开发中接触的最多的生命周期方法。它本身的作用是进行Activity的一些初始化工作，比如使用setContentView加载布局，对一些控件和变量进行初始化等。但也有很多人将很多与初始化无关的代码放在这，其实这是不规范的。此时Activity还在后台，不可见。所以动画不应该在这里初始化，因为看不到……

（2）onStart:start表示启动，这是Activity生命周期的第二个方法。此时Activity已经可见了，但是还没出现在前台，我们还看不到，无法与Activity交互。其实将Activity的初始化工作放在这也没有什么问题，放在onCreate中是由于官方推荐的以及我们开发的习惯。

（3）onResume:resume表示继续、重新开始，这名字和它的职责也相同。此时Activity经过前两个阶段的初始化已经蓄势待发。Activity在这个阶段已经出现在前台并且可见了。这个阶段可以打开独占设备

（4）onPause:pause表示暂停，当Activity要跳到另一个Activity或应用正常退出时都会执行这个方法。此时Activity在前台并可见，我们可以进行一些轻量级的存储数据和去初始化的工作，不能太耗时，因为在跳转Activity时只有当一个Activity执行完了onPause方法后另一个Activity才会启动，而且android中指定如果onPause在500ms即0.5秒内没有执行完毕的话就会强制关闭Activity。从生命周期图中发现可以在这快速重启，但这种情况其实很罕见，比如用户切到下一个Activity的途中按back键快速得切回来。

（5）onStop：stop表示停止，此时Activity已经不可见了，但是Activity对象还在内存中，没有被销毁。这个阶段的主要工作也是做一些资源的回收工作。

（6）onDestroy：destroy表示毁灭，这个阶段Activity被销毁，不可见，我们可以将还没释放的资源释放，以及进行一些回收工作。

（7）onRestart：restart表示重新开始，Activity在这时可见，当用户按Home键切换到桌面后又切回来或者从后一个Activity切回前一个Activity就会触发这个方法。这里一般不做什么操作。


### 设备旋转
#### 步骤：  
创建水平模式布局New → Android resource directory，产生res/layout-land目录    
设备处于水平方向时，Android会找到并使用res/layout-land目录下的布局资源  
把layout文件复制过来并修改，保持同名。  
若要保存数据：覆盖onSaveInstanceState(Bundle) 方法。  


#### 为什么会销毁重建？  
旋转设备会改变**设备配置** （device configuration）。  
设备配置 实际是一系列特征组合，用来描述设备当前状态。这些特征有：屏幕方向、屏幕像素密度、屏幕尺寸、键盘类型、底座模式以及语言等。  
**运行时配置变更** （runtime configuration change）发生时，可能会有更合适的资源来匹配新的设备配置。于是，Android销毁当前activity，为新配置寻找最佳资源，然后创建新实例使用这些资源。


#### 怎么调用数据？
protected void onSaveInstanceState(Bundle outState)   
该方法通常在onStop() 方法之前（测试发现是之后）由系统调用，除非用户按后退键。    

**原理**：  
可通过覆盖onSaveInstanceState(Bundle)方法，将一些数据保存在bundle中，然后在onCreate(Bundle) 方法中取回这些数据。   

**Bundle 到底是啥？**
Bundle 是存储字符串键与限定类型值之间映射关系（键-值对）的一种结构。  
通过Key拿出value。里面是用map存的。

**注意**：  
1. 覆盖onSaveInstanceState(Bundle) 方法时，应测试activity状态是否如预期般正确保存和恢复
2. 在Bundle中存储和恢复的数据类型只能是基本类型（primitive type）以及可以实现Serializable或Parcelable接口的对象。  
在Bundle中保存定制类对象不是个好主意，因为你取回的对象可能已经没用了。比较好的做法是，通过其他方式保存定制类对象，而在Bundle中保存标识对象的基本类型数据。  
什么方式？？


常见的做法是，覆盖onSaveInstanceState(Bundle) 方法，在Bundle 对象中，保存当前activity的小的或暂存状态的数据；覆盖onStop() 方法，保存永久性数据，如用户编辑的文字等。onStop() 方法调用完，activity随时会被系统销毁，所以用它保存永久性数据。



bundle实现的原理：  
保存在onSaveInstanceState(Bundle) 的数据该如何幸免于难呢？调用该方法时，用户数据随即被保存在Bundle 对象中，然后操作系统将Bundle 对象放入activity记录中。
为便于理解activity记录，我们增加一个暂存状态 （stashed state）到activity生命周期，如图3-14所示。
activity暂存后，Activity 对象不再存在，但操作系统会将activity记录对象保存起来。这样，在需要恢复activity时，操作系统可以使用暂存的activity记录重新激活activity。





**为啥Activity没有构造函数？**  
[Android Activity的构造方法](https://blog.csdn.net/ccpat/article/details/54915200)



**为什么要在manifest中声明activity？**   
启动activity前，ActivityManager 会确认指定的Class 是否已在manifest配置文件中声明。如果已完成声明，则启动activity，应用正常运行。反之，则抛出ActivityNotFoundException 异常，应用崩溃。这就是必须在manifest配置文件中声明应用的全部activity的原因。


**activity栈**  
ActivityManager 维护着一个非特定应用独享的回退栈。所有应用的activity都共享该回退栈。这也是将ActivityManager 设计成操作系统级的activity管理器来负责启动应用activity的原因之一。显然，回退栈是作为一个整体共享于操作系统及设备，而不单单用于某个应用。