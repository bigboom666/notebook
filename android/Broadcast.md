# Broadcast
是一个全局的监听器，Android 广播分为两个角色：广播发送者、广播接收者。     
**就是一种通信手段咯？？？**

[TOC]

## 1. 应用场景
- Android不同组件间的通信（含 ：应用内 / 不同应用之间）
- 多线程通信
- 与 Android 系统在特定情况下的通信
  >如：电话呼入时、网络可用时

## 2. 实现原理
### 2.1 模型
观察者模式：基于消息的发布 / 订阅事件模型  
好处：Android将广播的发送者 和 接收者 解耦，使得系统方便集成，更易扩展
![广播模型](https://imgconvert.csdnimg.cn/aHR0cDovL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pby91cGxvYWRfaW1hZ2VzLzk0NDM2NS05ZmNhOWZkMzk3OGNlZjEwLnBuZz9pbWFnZU1vZ3IyL2F1dG8tb3JpZW50L3N0cmlwJTdDaW1hZ2VWaWV3Mi8yL3cvMTI0MA)


## 3. 咋用？
使用流程：
![使用流程](https://imgconvert.csdnimg.cn/aHR0cDovL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pby91cGxvYWRfaW1hZ2VzLzk0NDM2NS03YzlmZjY1NmViZDFiOTgxLnBuZz9pbWFnZU1vZ3IyL2F1dG8tb3JpZW50L3N0cmlwJTdDaW1hZ2VWaWV3Mi8yL3cvMTI0MA)


### 3.1 自定义广播接收者
- 继承BroadcastReceivre基类
- 必须复写抽象方法onReceive()方法

>广播接收器接收到相应广播后，会自动回调 onReceive() 方法
一般情况下，onReceive方法会涉及 与 其他组件之间的交互，如发送Notification、启动Service等
默认情况下，广播接收器运行在 UI 线程，因此，onReceive()方法不能执行耗时操作，否则将导致ANR

```java
// 继承BroadcastReceivre基类
public class mBroadcastReceiver extends BroadcastReceiver {

  // 复写onReceive()方法
  // 接收到广播后，则自动调用该方法
  @Override
  public void onReceive(Context context, Intent intent) {
   //写入接收广播后的操作
    }
}
```

### 3.2 注册广播接收器
注册的方式分为两种：静态注册、动态注册  

#### 3.3 静态注册
- 注册方式：在AndroidManifest.xml里通过标签声明
- 当此App首次启动时，系统会自动实例化mBroadcastReceiver类，并注册到系统中。
```java
<receiver 
    android:enabled=["true" | "false"]
    //此broadcastReceiver能否接收其他App的发出的广播
    //默认值是由receiver中有无intent-filter决定的：如果有intent-filter，默认值为true，否则为false
    android:exported=["true" | "false"]
    android:icon="drawable resource"
    android:label="string resource"
    //继承BroadcastReceiver子类的类名
    android:name=".mBroadcastReceiver"
    //具有相应权限的广播发送者发送的广播才能被此BroadcastReceiver所接收；
    android:permission="string"
    //BroadcastReceiver运行所处的进程
    //默认为app的进程，可以指定独立的进程
    //注：Android四大基本组件都可以通过此属性指定自己的独立进程
    android:process="string" >

//用于指定此广播接收器将接收的广播类型
//本示例中给出的是用于接收网络状态改变时发出的广播
 <intent-filter>
<action android:name="android.net.conn.CONNECTIVITY_CHANGE" />
    </intent-filter>
</receiver>

<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/> 
//有的时候要给相应权限
```
**注意**  ：Android8.0的后台执行限制   
1. 应用无法使用清单注册（静态注册）的方式来接收隐式广播  
2. 具体广播限制和对应赦免清单    
避免：不用静态注册，或者不用隐式广播  
参考：  
[咦，Oreo怎么收不到广播了？](https://juejin.im/post/5aefd27f6fb9a07ab45889cc)  
[android 8.0静态注册的隐式广播接收不到](https://blog.csdn.net/u013247461/article/details/80838550)  
[Android8.0 静态广播的改动（可跨进程）](https://blog.csdn.net/lzf199281/article/details/81915240)

#### 3.4 动态注册
- 注册方式：在代码中调用Context.registerReceiver（）方法
```java
// 选择在Activity生命周期方法中的onResume()中注册
@Override
  protected void onResume(){
      super.onResume();

    // 1. 实例化BroadcastReceiver子类 &  IntentFilter
     mBroadcastReceiver mBroadcastReceiver = new mBroadcastReceiver();
     IntentFilter intentFilter = new IntentFilter();

    // 2. 设置接收广播的类型
    intentFilter.addAction(android.net.conn.CONNECTIVITY_CHANGE);

    // 3. 动态注册：调用Context的registerReceiver（）方法
     registerReceiver(mBroadcastReceiver, intentFilter);
 }


// 注册广播后，要在相应位置记得销毁广播
// 即在onPause() 中unregisterReceiver(mBroadcastReceiver)
// 当此Activity实例化时，会动态将MyBroadcastReceiver注册到系统中
// 当此Activity销毁时，动态注册的MyBroadcastReceiver将不再接收到相应的广播。
 @Override
 protected void onPause() {
     super.onPause();
      //销毁在onResume()方法中的广播
     unregisterReceiver(mBroadcastReceiver);
     }
}
```
**注意**：
1. 对于动态广播，有注册就必然得有注销，否则会导致内存泄露  
在onResume()注册、onPause()注销是因为onPause()在App死亡前一定会被执行，从而保证广播在App死亡前一定会被注销，从而防止内存泄露。
>1. 不在onCreate() & onDestory() 或 onStart() & onStop()注册、注销是因为：
当系统因为内存不足（优先级更高的应用需要内存，请看上图红框）要回收Activity占用的资源时，Activity在执行完onPause()方法后就会被销毁，有些生命周期方法onStop()，onDestory()就不会执行。当再回到此Activity时，是从onCreate方法开始执行。
>2. 假设我们将广播的注销放在onStop()，onDestory()方法里的话，有可能在Activity被销毁后还未执行onStop()，onDestory()方法，即广播仍还未注销，从而导致内存泄露。
>3. 但是，onPause()一定会被执行，从而保证了广播在App死亡前一定会被注销，从而防止内存泄露。

#### 3.5 两种注册方式区别
![两种注册方式区别](https://imgconvert.csdnimg.cn/aHR0cDovL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pby91cGxvYWRfaW1hZ2VzLzk0NDM2NS04ZDE2M2FiM2NhMjBkZTBiLnBuZz9pbWFnZU1vZ3IyL2F1dG8tb3JpZW50L3N0cmlwJTdDaW1hZ2VWaWV3Mi8yL3cvMTI0MA)

### 3.3 广播发送者向AMS发送广播
- 广播 是 用”意图（Intent）“标识
- 定义广播的本质 = 定义广播所具备的“意图（Intent）”
- 广播发送 = 广播发送者 将此广播的“意图（Intent）”通过sendBroadcast（）方法发送出去

#### 3.3.1 广播类型
- 普通广播（Normal Broadcast）
- 系统广播（System Broadcast）
- 有序广播（Ordered Broadcast）
- 应用内广播（Local Broadcast）
- 粘性广播（Sticky Broadcast）
  
**1. 普通广播（Normal Broadcast）**  
**静态注册，显式广播**   
接收方--BroadcastReceiver类：  
```java
public class MyReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Toast.makeText(context,"got broadcast",Toast.LENGTH_LONG).show();
    }
}
```
接收--manifest：
```xml
<receiver
    android:name="com.example.receiveboradcast.MyReceiver"
    android:enabled="true"
    android:exported="true">
    <intent-filter>
        <action android:name="com.example.receiveboradcast.interprocess"/>
    </intent-filter>
</receiver>
```

发送--MainActivity:
```java
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mButton_1 = findViewById(R.id.Button_1);
        mButton_1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent("com.example.receiveboradcast.interprocess");
                intent.setComponent(new ComponentName("com.example.receiveboradcast","com.example.receiveboradcast.MyReceiver"));
                sendBroadcast(intent);

            }
        });
    }
```
>返回按键，也可以接收广播，杀后台不行。


**动态注册，隐式广播** 

		




