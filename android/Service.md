# Service
<!-- TOC -->

- [Service](#service)
  - [1. 概述](#1-%e6%a6%82%e8%bf%b0)
  - [2. Service在清单文件中的声明](#2-service%e5%9c%a8%e6%b8%85%e5%8d%95%e6%96%87%e4%bb%b6%e4%b8%ad%e7%9a%84%e5%a3%b0%e6%98%8e)
  - [3. Service启动服务](#3-service%e5%90%af%e5%8a%a8%e6%9c%8d%e5%8a%a1)
    - [3.1 继承Service](#31-%e7%bb%a7%e6%89%bfservice)
    - [3.2 继承IntentService](#32-%e7%bb%a7%e6%89%bfintentservice)
  - [4. Service绑定服务](#4-service%e7%bb%91%e5%ae%9a%e6%9c%8d%e5%8a%a1)
    - [4.1 扩展`Binder`类通信](#41-%e6%89%a9%e5%b1%95binder%e7%b1%bb%e9%80%9a%e4%bf%a1)
      - [4.1.1 扩展 Binder 类](#411-%e6%89%a9%e5%b1%95-binder-%e7%b1%bb)
      - [4.1.2 实现 ServiceConnection接口](#412-%e5%ae%9e%e7%8e%b0-serviceconnection%e6%8e%a5%e5%8f%a3)
      - [4.1.3 调用 bindService()，传递 ServiceConnection 对象](#413-%e8%b0%83%e7%94%a8-bindservice%e4%bc%a0%e9%80%92-serviceconnection-%e5%af%b9%e8%b1%a1)
      - [4.1.4 调用 unbindService()断开与服务的连接。](#414-%e8%b0%83%e7%94%a8-unbindservice%e6%96%ad%e5%bc%80%e4%b8%8e%e6%9c%8d%e5%8a%a1%e7%9a%84%e8%bf%9e%e6%8e%a5)
    - [4.2 使用AIDL通信](#42-%e4%bd%bf%e7%94%a8aidl%e9%80%9a%e4%bf%a1)
    - [4.2 绑定服务的生命周期](#42-%e7%bb%91%e5%ae%9a%e6%9c%8d%e5%8a%a1%e7%9a%84%e7%94%9f%e5%91%bd%e5%91%a8%e6%9c%9f)
    - [4.3 绑定时机](#43-%e7%bb%91%e5%ae%9a%e6%97%b6%e6%9c%ba)
  - [5. 前台Service](#5-%e5%89%8d%e5%8f%b0service)
  - [6. 问题：](#6-%e9%97%ae%e9%a2%98)
    - [6.1 service和activity](#61-service%e5%92%8cactivity)
    - [6.2 service和Thread](#62-service%e5%92%8cthread)
    - [6.3 :remote](#63-remote)
- [参考](#%e5%8f%82%e8%80%83)

<!-- /TOC -->
## 1. 概述
Service(服务)是一个一种可以在后台执行长时间运行操作而没有用户界面的应用组件。服务可由其他应用组件启动（如Activity），服务一旦被启动将在后台一直运行，即使启动服务的组件（Activity）已销毁也不受影响。 此外，组件可以绑定到服务，以与之进行交互，甚至是执行进程间通信 (IPC)。 例如，服务可以处理网络事务、播放音乐，执行文件 I/O 或与内容提供程序交互，而所有这一切均可在后台进行，Service基本上分为两种形式：
- 启动状态  
  当应用组件（如 Activity）通过调用 startService() 启动服务时，服务即处于“启动”状态。一旦启动，服务即可在后台无限期运行，即使启动服务的组件已被销毁也不受影响，除非手动调用才能停止服务， 已启动的服务通常是执行单一操作，而且不会将结果返回给调用方。
- 绑定状态  
  当应用组件通过调用 bindService() 绑定到服务时，服务即处于“绑定”状态。绑定服务提供了一个客户端-服务器接口，允许组件与服务进行交互、发送请求、获取结果，甚至是利用进程间通信 (IPC) 跨进程执行这些操作。 仅当与另一个应用组件绑定时，绑定服务才会运行。 多个组件可以同时绑定到该服务，但全部取消绑定后，该服务即会被销毁。

- 启动且绑定  
  服务既可以是启动服务，也允许绑定。此时需要同时实现以下回调方法：onStartCommand()和 onBind()。系统不会在所有客户端都取消绑定时销毁服务。为此，必须通过调用 stopSelf() 或 stopService() 显式停止服务


![服务生命周期](https://developer.android.com/images/service_lifecycle.png?hl=zh-cn)

## 2. Service在清单文件中的声明
```xml
<service android:enabled=["true" | "false"]
    android:exported=["true" | "false"]
    android:icon="drawable resource"
    android:isolatedProcess=["true" | "false"]
    android:label="string resource"
    android:name="string"
    android:permission="string"
    android:process="string" >
    ...
</service>
```
- android:exported：代表是否能被其他应用隐式调用（其默认值是由service中有无intent-filter决定的，如果有intent-filter，默认值为true，否则为false）。为false的情况下，即使有intent-filter匹配，也无法打开，即无法被其他应用隐式调用。

- android:name：对应Service类名

- android:permission：是权限声明

- android:process：是否需要在单独的进程中运行,当设置为android:process=”:remote”时，代表Service在单独的进程中运行。注意“：”很重要，它的意思是指要在当前进程名称前面附加上当前的包名，所以“remote”和”:remote”不是同一个意思，前者的进程名称为：remote，而后者的进程名称为：App-packageName:remote。

- android:isolatedProcess ：设置 true 意味着，服务会在一个特殊的进程下运行，这个进程与系统其他进程分开且没有自己的权限。与其通信的唯一途径是通过服务的API(bind and start)。

- android:enabled：是否可以被系统实例化，默认为 true因为父标签 也有 enable 属性，所以必须两个都为默认值 true 的情况下服务才会被激活，否则不会激活。


## 3. Service启动服务

启动服务由组件通过调用 startService() 启动，服务启动之后，其生命周期即独立于启动它的组件，并且可以在后台无限期地运行，即使启动服务的组件已被销毁也不受影响。因此，服务应通过调用 stopSelf() 来自行停止运行，或者由另一个组件调用 stopService() 来停止

可以通过扩展两个类来创建启动服务：

- Service  
这是所有服务的父类。扩展此类时，如果要执行耗时操作，必须创建一个用于执行操作的新线程，因为默认情况下服务将运行于UI线程
- IntentService  
这是 Service 的子类，它使用工作线程逐一处理所有启动请求。如果应用不需要同时处理多个请求，这是最好的选择。IntentService只需实现构造函数与 onHandleIntent() 方法即可，onHandleIntent()方法会接收每个启动请求的 Intent



### 3.1 继承Service
创建 Service 的子类，并重写一些回调方法，以处理服务生命周期的某些关键过程
```java
public class MyService extends Service {
	public static final String TAG = "MyService";
	@Override
	public void onCreate() {
		super.onCreate();
		Log.d(TAG, "onCreate() executed");
	}
	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		Log.d(TAG, "onStartCommand() executed");
		return super.onStartCommand(intent, flags, startId);
	}
	@Override
	public void onDestroy() {
		super.onDestroy();
		Log.d(TAG, "onDestroy() executed");
	}
	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}
}
```
在MainActivity中调用
```java
Intent intent = new Intent(this, MyService.class);
Bundle bundle = new Bundle();
bundle.putSerializable("Key", MyService.Control.PAUSE);
intent.putExtras(bundle);
startService(intent);
//stopService(intent);
```
- onCreate()  
  首次创建服务时，系统将调用此方法来执行一次性设置程序（在调用 onStartCommand() 或onBind() 之前）。如果服务已在运行，则不会调用此方法，该方法只调用一次

- onStartCommand()  
  当另一个组件（如 Activity）通过调用 startService() 请求启动服务时，系统将调用此方法。一旦执行此方法，服务即会启动并可在后台无限期运行。 如果自己实现此方法，则需要在服务工作完成后，通过调用 stopSelf() 或 stopService() 来停止服务。（在绑定状态下，无需实现此方法。）

  由于每次启动服务（调用startService）时，onStartCommand方法都会被调用，因此我们可以通过该方法使用Intent给Service传递所需要的参数，然后在onStartCommand方法中处理的事件，最后根据需求选择不同的Flag返回值，以达到对程序更友好的控制

  如果服务没有提供绑定，则使用 startService() 传递的 Intent 是应用组件与服务之间唯一的通信模式。如果希望服务返回结果，则启动服务的客户端可以为广播创建一个 PendingIntent （使用 getBroadcast()），并通过启动服务的 Intent 传递给服务。然后，服务就可以使用广播传递结果



- onDestroy()  
  当服务不再使用且将被销毁时，系统将调用此方法。服务应该实现此方法来清理所有资源，如线程、注册的侦听器、接收器等，这是服务接收的最后一个调用。

- onBind()  
  当另一个组件想通过调用 bindService() 与服务绑定（例如执行 RPC）时，系统将调用此方法。在此方法的实现中，必须返回 一个IBinder 接口的实现类，供客户端用来与服务进行通信。无论是启动状态还是绑定状态，此方法必须重写，但在启动状态的情况下直接返回 null。


### 3.2 继承IntentService
由于大多数启动服务都不必同时处理多个请求，因此使用 IntentService 类实现服务也许是最好的选择

IntentService 执行以下操作：

- 创建默认的工作线程，用于在应用的主线程外执行传递给 onStartCommand() 的所有 Intent
- 创建工作队列，用于将 Intent 逐一传递给 onHandleIntent() 实现，这样就不必担心多线程问题
- 在处理完所有启动请求后停止服务，因此不必自己调用 stopSelf()方法
- 提供 onBind() 的默认实现（返回 null）
- 提供 onStartCommand() 的默认实现，可将 Intent 依次发送到工作队列和 onHandleIntent()   
   
因此，只需实现构造函数与 onHandleIntent() 方法即可

```java
public class MyIntentService extends IntentService {

    private final String TAG = "MyIntentService";

    public MyIntentService() {
        super("MyIntentService");
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        Bundle bundle = intent.getExtras();
        if (bundle != null) {
            for (int i = 0; i < 5; i++) {
                try {
                    Thread.sleep(200);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                Log.e(TAG, bundle.getString("key", "默认值"));
            }
        }
    }

}
````
```java
public class StartIntentServiceActivity extends AppCompatActivity {

    private int i = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_start_intent_service);
    }

    public void startService(View view) {
        Intent intent = new Intent(this, MyIntentService.class);
        Bundle bundle = new Bundle();
        bundle.putString("key", "当前值：" + i++);
        intent.putExtras(bundle);
        startService(intent);
    }

}
```


## 4. Service绑定服务 
**绑定为了让activity得到service的方法数据。**

应用组件（客户端）通过调用 bindService() 绑定到服务，绑定是异步的，系统随后调用服务的 onBind() 方法，该方法返回用于与服务交互的 IBinder。要接收 IBinder，客户端必须提供一个 ServiceConnection 实例用于监控与服务的连接，并将其传递给 bindService()。当 Android 系统创建了客户端与服务之间的连接时，会回调ServiceConnection 对象的onServiceConnected()方法，向客户端传递用来与服务通信的IBinder

多个客户端可同时连接到一个服务。不过，只有在第一个客户端绑定时，系统才会调用服务的 onBind() 方法来检索 IBinder。系统随后无需再次调用 onBind()，便可将同一 IBinder 传递至其他绑定的客户端。当所有客户端都取消了与服务的绑定后，系统会将服务销毁（除非 startService() 也启动了该服务）

另外，只有 Activity、服务和内容提供者可以绑定到服务，无法从广播接收器绑定到服务。

- 扩展 Binder 类  
如果服务是**供本应用专用**，并且运行在**与客户端相同的进程中**，则应通过扩展 Binder 类并从 onBind() 返回它的一个实例来创建接口。客户端收到 Binder 后，可利用它直接访问 Service 中可用的公共方法
- 使用 Messenger  
如需让接口跨不同的进程工作，则可使用 Messenger 为服务创建接口。服务可以这种方式定义对应于不同类型 Message 对象的 Handler。此 Handler 是 Messenger 的基础，后者随后可与客户端分享一个 IBinder，从而让客户端能利用 Message 对象向服务发送命令。此外，客户端还可定义自有 Messenger，以便服务回传消息。这是执行进程间通信 (IPC) 的最简单方法，因为 Messenger 会在单一线程中创建包含所有请求的队列，这样就不必对服务进行线程安全设计
- 使用 AIDL  
AIDL（Android 接口定义语言）执行所有将对象分解成原语的工作，操作系统可以识别这些原语并将它们编组到各进程中，以执行 IPC。 之前采用 Messenger 的方法实际上是以 AIDL 作为其底层结构。 如上所述，Messenger 会在单一线程中创建包含所有客户端请求的队列，以便服务一次接收一个请求。 不过，如果想让服务同时处理多个请求，则可直接使用 AIDL。 在此情况下，服务必须具备多线程处理能力，并采用线程安全式设计。如需直接使用 AIDL，必须创建一个定义编程接口的 .aidl 文件。Android SDK 工具利用该文件生成一个实现接口并处理 IPC 的抽象类，随后可在服务内对其进行扩展

### 4.1 扩展`Binder`类通信
#### 4.1.1 扩展 Binder 类
1. 在服务中创建一个可满足下列任一要求的 Binder 实例：
    - 包含客户端可调用的公共方法
    - 返回当前 Service 实例，其中包含客户端可调用的公共方法
    - 或返回由服务承载的其他类的实例，其中包含客户端可调用的公共方法

2. 从 onBind() 回调方法返回此 Binder 实例

#### 4.1.2 实现 ServiceConnection接口
重写两个回调方法：
- onServiceConnected()  
系统会调用该方法以传递服务的onBind() 方法返回的 IBinder
- onServiceDisconnected()  
Android 系统会在与服务的连接意外中断时，例如当服务崩溃或被终止时调用该方法。当客户端取消绑定时，系统不会调用该方法

#### 4.1.3 调用 bindService()，传递 ServiceConnection 对象
当系统调用了 onServiceConnected() 的回调方法时，就可以通过IBinder对象操作服务了

#### 4.1.4 调用 unbindService()断开与服务的连接。  
如果应用在客户端仍处于绑定状态时销毁客户端，会导致客户端取消绑定，更好的做法是在客户端与服务交互完成后立即取消绑定客户端，这样可以关闭空闲服务

```java
public class MyBindService extends Service {

    private IBinder myBinder;

    private Random mGenerator;

    private final String TAG = "MyBindService";

    public class MyBinder extends Binder {
        MyBindService getService() {
            return MyBindService.this;
        }
    }

    @Override
    public void onCreate() {
        Log.e(TAG, "onCreate");
        myBinder = new MyBinder();
        mGenerator = new Random();
        super.onCreate();
    }

    @Override
    public IBinder onBind(Intent intent) {
        Log.e(TAG, "onBind");
        return myBinder;
    }

    @Override
    public void onDestroy() {
        Log.e(TAG, "onDestroy");
        super.onDestroy();
    }

    @Override
    public boolean onUnbind(Intent intent) {
        Log.e(TAG, "onUnbind");
        return super.onUnbind(intent);
    }

    @Override
    public void onRebind(Intent intent) {
        Log.e(TAG, "onRebind");
        super.onRebind(intent);
    }

    public int getRandomNumber() {
        return mGenerator.nextInt(100);
    }

}
```
```java
public class BindServiceActivity extends AppCompatActivity {

    private MyBindService mService;

    private boolean mBound = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bind_service);
    }

    private ServiceConnection mConnection = new ServiceConnection() {

        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            MyBindService.MyBinder binder = (MyBindService.MyBinder) service;
            mService = binder.getService();
            mBound = true;
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            mBound = false;
        }
    };

    public void bindService(View view) {
        Intent intent = new Intent(this, MyBindService.class);
        bindService(intent, mConnection, Context.BIND_AUTO_CREATE);
    }

    public void unBindService(View view) {
        if (mBound) {
            unbindService(mConnection);
            mBound = false;
        }
    }

    public void getData(View view) {
        if (mBound) {
            Toast.makeText(this, "获取到的随机数：" + mService.getRandomNumber(), Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(this, "服务未绑定", Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mBound) {
            unbindService(mConnection);
            mBound = false;
        }
    }

}
```
### 4.2 使用AIDL通信
使用AIDL跨进程通信，整体过程和单进程一样，都是通过一个Binder来通信的，区别在于单进程的Binder是自己通过继承Binder类来手动实现的，而跨进程的Binder是通过AIDL自动生成的，那是一个牛逼的Binder。

activity调用service：

生成AIDL--->IMyAidlInterface接口，里面声明要回调的方法MethodA
在Service里，把要用到的内部类实现，继承IMyAidlInterface.Stub,里面实现MethodA（直接调用类里的方法也行）

回调：  

[Android Service基本用法、AIDL、Binder连接池详解](https://www.jianshu.com/p/243eb0a3c282)  


### 4.2 绑定服务的生命周期
绑定服务的生命周期在同时启动服务的情况下比较特殊，想要终止服务，除了需要取消绑定服务外，还需要服务通过 stopSelf() 自行停止或其他组件调用 stopService()

其中，如果服务已启动并接受绑定，则当系统调用了onUnbind() 方法，想要在客户端下一次绑定到服务时调用 onRebind() 方法的话，则onUnbind() 方法需返回 true。onRebind() 返回空值，但客户端仍可以在其 onServiceConnected() 回调中接收到 IBinder对象

![已启动且允许绑定的服务的生命周期](https://developer.android.com/images/fundamentals/service_binding_tree_lifecycle.png?hl=zh-cn)


### 4.3 绑定时机
- 如果只需要在 Activity 可见时与服务交互，则应在 onStart() 期间绑定，在 onStop() 期间取消绑定
- 如果希望 Activity 在后台停止运行状态下仍可接收响应，则可在 onCreate() 期间绑定，在 onDestroy() 期间取消绑定。这意味着 Activity 在其整个运行过程中（包括后台运行期间）都需要使用此服务
- 通常情况下，切勿在 Activity 的 onResume() 和 onPause() 期间绑定和取消绑定，因为每一次生命周期转换都会发生这些回调，应该使发生在这些转换期间的处理保持在最低水平。假设有两个Activity需要绑定到同一服务，从Activity A跳转到Activity B，这个过程中会依次执行A-onPause，B-onCreate，B-onStart，B-onResume，A-onStop。这样系统会在A-onPause的时候销毁服务，又在B-onResume的时候重建服务。当Activity B回退到Activity A时，会依次执行B-onPause，A-onRestart，A-onStart，A-onResume，B-onStop，B-onDestroy。此时，系统会在B-onPause时销毁服务，又在A-onResume时重建服务。这样就造成了多次的销毁与重建，因此需要选定好绑定服务与取消绑定服务的时机


## 5. 前台Service
用到再看,Android8.0以后方法略微不同,需要创建和管理通知渠道。  
参考:  
[Android8.0使用通知创建前台服务](https://blog.csdn.net/Haienzi/article/details/81268022)  
[Android排坑：Android8.0后前台服务的变更](https://blog.csdn.net/qq_40594395/article/details/88133766)


## 6. 问题：
### 6.1 service和activity
1. 没有绑定的服务就可以理解为没有界面的activity
2. 绑定的服务  
值得注意的是对于启动服务，一旦启动将与访问它的组件无任何关联，即使访问它的组件被销毁了，这个服务也一直运行下去，直到手动调用停止服务才被销毁，

### 6.2 service和Thread 
Android的后台就是指，它的运行是完全不依赖UI的。即使Activity被销毁，或者程序被关闭，只要进程还在，Service就可以继续运行。比如说一些应用程序，始终需要与服务器之间始终保持着心跳连接，就可以使用Service来实现。你可能又会问，前面不是刚刚验证过Service是运行在主线程里的么？在这里一直执行着心跳连接，难道就不会阻塞主线程的运行吗？当然会，但是我们可以在Service中再创建一个子线程，然后在这里去处理耗时逻辑就没问题了。
额，既然在Service里也要创建一个子线程，那为什么不直接在Activity里创建呢？这是因为Activity很难对Thread进行控制，当Activity被销毁之后，就没有任何其它的办法可以再重新获取到之前创建的子线程的实例。而且在一个Activity中创建的子线程，另一个Activity无法对其进行操作。但是Service就不同了，所有的Activity都可以与Service进行关联，然后可以很方便地操作其中的方法，即使Activity被销毁了，之后只要重新与Service建立关联，就又能够获取到原有的Service中Binder的实例。因此，使用Service来处理后台任务，Activity就可以放心地finish，完全不需要担心无法对后台任务进行控制的情况。

### 6.3 :remote
远程Service不能binder：Activity和Service运行在两个不同的进程当中，这时就不能再使用传统的建立关联的方式，程序也就崩溃了。
而需要用AIDL



# 参考
[Android Service使用详解](https://www.jianshu.com/p/95ec2a23f300)  
[关于Android Service真正的完全详解，你需要知道的一切](https://blog.csdn.net/javazejian/article/details/52709857)  
[Android Service完全解析，关于服务你所需知道的一切(上)](https://blog.csdn.net/guolin_blog/article/details/11952435)    
[Android Service基本用法、AIDL、Binder连接池详解](https://www.jianshu.com/p/243eb0a3c282)  