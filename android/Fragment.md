## fragment

### 生命周期：
1. Fragment不能独立存在，必须嵌入到Activity中
2. Fragment具有自己的生命周期，接收它自己的事件，并可以在Activity运行时被添加或删除
3. Fragment的生命周期直接受所在的Activity的影响。如：当Activity暂停时，它拥有的所有Fragment们都暂停


![Fragment的生命周期](https://www.runoob.com/wp-content/uploads/2015/08/31722863.jpg)
![Fragment的生命周期2](https://upload-images.jianshu.io/upload_images/2552605-82215f275d6a1794?imageMogr2/auto-orient/strip|imageView2/2/w/317/format/webp)
![Fragment和activity对比图](https://upload-images.jianshu.io/upload_images/944365-0f9670e55a52403c.png?imageMogr2/auto-orient/strip|imageView2/2/w/340/format/webp)



#### 注意：
fragment的生命周期方法由托管activity而不是操作系统调用。fragment的使用是activity内部的事情。

### fragment是啥
解释：  
fragment是一种控制器对象，activity可以委派一些任务给它，通常这些任务是管理用户界面。受管的用户界面可以是整个屏幕或者是小部分屏幕。

程序体现：
fragment_xxx.xml-->创建这个fragment的布局
XxxFragment.class-->fragment类中实现各种生命周期方法，在这些方法里完成逻辑控制工作(各类控件的监听事件)



### fragment咋用：
为托管UI fragment，activity必须：  
1. 在其布局中为fragment的视图安排位置；  
2. 管理fragment实例的生命周期。  


activity托管UI fragment有如下两种方式：
在activity布局 中添加fragment；
    在main_activity中写死<fragment 
在activity代码 中添加fragment。





1. 创建UI fragment  
1.1 定义用户界面布局文件；  
1.2 创建fragment类并设置其视图为定义的布局；  
  1.2.1 CrimeFragment 类继承Fragment 类  
  1.2.2 实现fragment生命周期方法  
    - oncreate    
    - oncreateview  
        > 在onCreateView(...)   方法中，fragment的视图是直接通过调用LayoutInflater.inflate(...) 方法并传入布局的资源ID生成的。第二个参数是视图的父视图，我们通常需要父视图来正确配置组件。第三个参数告诉布局生成器是否将生成的视图添加给父视图。这里，传入了false 参数，因为我们将以代码的方式添加视图。  
        LayoutInflater.inflate(...) 
        作用类似于findViewById()。不同点是LayoutInflater是用来找res/layout/下的xml布局文件，并且实例化；而findViewById()是找xml布局文件下的具体widget控件(如 Button、TextView等)。   
  1.2.3编写代码以实例化组件。  
2. 向FragmentManager 添加UI fragment   
  2.1 获取FragmentManager 之后，再获取一个fragment交给它管理  
3. 在main_avtivity中动态添加Fragment  
  3.1 获取到FragmentManager，在Activity中可以直接通过getFragmentManager得到。  
  3.2 开启一个事务，通过调用beginTransaction方法开启。  
  3.3 向容器内加入Fragment，一般使用replace方法实现，需要传入容器的id和Fragment的实例。  
  3.4 提交事务，调用commit方法提交。  





生命周期和方法  
Fragment.onCreate(Bundle) 是公共方法，而Activity.onCreate(Bundle) 是受保护方法。  
Fragment.onCreate(Bundle) 方法及其他Fragment 生命周期方法必须是公共方法，因为托管fragment的activity要调用它们。


MVC：
CrimeFragment 类是与模型及视图对象交互的控制器，用于显示特定crime的明细信息，并在用户修改这些信息后立即进行更新。

在GeoQuiz应用中，activity通过其生命周期方法完成了大部分逻辑控制工作。而在CriminalIntent应用中，这些工作是由fragment的生命周期方法完成的。  

这些生命周期的方法什么时候调用父类  什么时候不用调用？   








activity怎么和xml绑定的？  

以前使用的Activity.findViewById(int) 方法十分便利，能够在后台自动调用View.findViewById(int) 方法，而Fragment 类没有对应的便利方法，因此必须手动调用。

textlistener  和 onclickLinstener  比较  

FragmentManager:  
引入Fragment 类的时候，为协同工作，Activity 类中相应添加了FragmentManager 类。FragmentManager 类负责管理fragment并将它们的视图添加到activity的视图层级结构中

FragmentManager 类具体管理：
fragment队列；
fragment事务回退栈（稍后会学习）。  


fragment事务被用来添加、移除、附加、分离或替换fragment队列中的fragment。这是使用fragment动态组装和重新组装用户界面的关键。FragmentManager 管理着fragment事务回退栈。  
 
流接口   秀啊？？
FragmentManager.beginTransaction() 方法创建并返回FragmentTransaction 实例。FragmentTransaction 类支持流接口 （fluent interface）的链式方法调用，以此配置FragmentTransaction 再返回它。   
容器视图资源ID的作用有：  
告诉FragmentManager ，fragment视图应该出现在activity视图的什么位置；
唯一标识FragmentManager 队列中的fragment。 
