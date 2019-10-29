# Broadcast
是一个全局的监听器，Android 广播分为两个角色：广播发送者、广播接收者。     
**就是一种通信手段咯？？？**

<!-- TOC -->

- [Broadcast](#broadcast)
  - [1. 应用场景](#1-%e5%ba%94%e7%94%a8%e5%9c%ba%e6%99%af)
  - [2. 实现原理](#2-%e5%ae%9e%e7%8e%b0%e5%8e%9f%e7%90%86)
    - [2.1 模型](#21-%e6%a8%a1%e5%9e%8b)
  - [3. 用法](#3-%e7%94%a8%e6%b3%95)
    - [3.1 自定义广播接收者](#31-%e8%87%aa%e5%ae%9a%e4%b9%89%e5%b9%bf%e6%92%ad%e6%8e%a5%e6%94%b6%e8%80%85)
    - [3.2 注册广播接收器](#32-%e6%b3%a8%e5%86%8c%e5%b9%bf%e6%92%ad%e6%8e%a5%e6%94%b6%e5%99%a8)
      - [3.3 静态注册](#33-%e9%9d%99%e6%80%81%e6%b3%a8%e5%86%8c)
      - [3.4 动态注册](#34-%e5%8a%a8%e6%80%81%e6%b3%a8%e5%86%8c)
      - [3.5 两种注册方式区别](#35-%e4%b8%a4%e7%a7%8d%e6%b3%a8%e5%86%8c%e6%96%b9%e5%bc%8f%e5%8c%ba%e5%88%ab)
    - [3.3 广播发送者向AMS发送广播](#33-%e5%b9%bf%e6%92%ad%e5%8f%91%e9%80%81%e8%80%85%e5%90%91ams%e5%8f%91%e9%80%81%e5%b9%bf%e6%92%ad)
      - [3.3.1 广播类型](#331-%e5%b9%bf%e6%92%ad%e7%b1%bb%e5%9e%8b)
        - [3.3.1.1 普通广播（Normal Broadcast）](#3311-%e6%99%ae%e9%80%9a%e5%b9%bf%e6%92%adnormal-broadcast)
        - [3.3.1.2 系统广播](#3312-%e7%b3%bb%e7%bb%9f%e5%b9%bf%e6%92%ad)
        - [3.3.1.3 有序广播](#3313-%e6%9c%89%e5%ba%8f%e5%b9%bf%e6%92%ad)

<!-- /TOC -->

## 1. 应用场景
- 同一个App内部的同一组件内的消息通信（单个或者多个线程之间）；
- 同一个App内部的不同组件之间的消息通信（单个进程）；
- 同一个App具有多个进程的不同组件之间的消息通信；
- 不同App之间的组件之间消息通信；
- Android系统在特定的情况下与App之间的消息通信。

## 2. 实现原理
### 2.1 模型
观察者模式：基于消息的发布 / 订阅事件模型  
好处：Android将广播的发送者 和 接收者 解耦，使得系统方便集成，更易扩展
![广播模型](https://imgconvert.csdnimg.cn/aHR0cDovL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pby91cGxvYWRfaW1hZ2VzLzk0NDM2NS05ZmNhOWZkMzk3OGNlZjEwLnBuZz9pbWFnZU1vZ3IyL2F1dG8tb3JpZW50L3N0cmlwJTdDaW1hZ2VWaWV3Mi8yL3cvMTI0MA)


## 3. 用法
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
- 注意广播销毁的位置
  >两个APP间收发广播，放在后台的app只能在onDestory()里销毁才能收到广播
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
  
##### 3.3.1.1 普通广播（Normal Broadcast）
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
接收--MainActivity
```java
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    IntentFilter intentFilter = new IntentFilter();
    intentFilter.addAction("com.example.receiveboradcast.interprocess");
    registerReceiver(myReceiver,intentFilter);
    Log.d(TAG, "onCreate: ");
}


    protected void onDestroy() {
    super.onDestroy();
    unregisterReceiver(myReceiver);
    Log.d(TAG, "onDestroy: ");
}
```
##### 3.3.1.2 系统广播
- 当使用系统广播时，只需要在注册广播接收者时定义相关的action即可，并不需要手动发送广播，当系统有相关操作时会自动进行系统广播。  
- Android中内置了多个系统广播：只要涉及到手机的基本操作（如开机、网络状态变化、拍照等等），都会发出相应的广播
- 每个广播都有特定的Intent - Filter
```java
// Android 8.0 上不限制的隐式广播
/**
开机广播
 Intent.ACTION_LOCKED_BOOT_COMPLETED
 Intent.ACTION_BOOT_COMPLETED
*/
"保留原因：这些广播只在首次启动时发送一次，并且许多应用都需要接收此广播以便进行作业、闹铃等事项的安排。"

/**
增删用户
Intent.ACTION_USER_INITIALIZE
"android.intent.action.USER_ADDED"
"android.intent.action.USER_REMOVED"
*/
"保留原因：这些广播只有拥有特定系统权限的app才能监听，因此大多数正常应用都无法接收它们。"
    
/**
时区、ALARM变化
"android.intent.action.TIME_SET"
Intent.ACTION_TIMEZONE_CHANGED
AlarmManager.ACTION_NEXT_ALARM_CLOCK_CHANGED
*/
"保留原因：时钟应用可能需要接收这些广播，以便在时间或时区变化时更新闹铃"

/**
语言区域变化
Intent.ACTION_LOCALE_CHANGED
*/
"保留原因：只在语言区域发生变化时发送，并不频繁。 应用可能需要在语言区域发生变化时更新其数据。"

/**
Usb相关
UsbManager.ACTION_USB_ACCESSORY_ATTACHED
UsbManager.ACTION_USB_ACCESSORY_DETACHED
UsbManager.ACTION_USB_DEVICE_ATTACHED
UsbManager.ACTION_USB_DEVICE_DETACHED
*/
"保留原因：如果应用需要了解这些 USB 相关事件的信息，目前尚未找到能够替代注册广播的可行方案"

/**
蓝牙状态相关
BluetoothHeadset.ACTION_CONNECTION_STATE_CHANGED
BluetoothA2dp.ACTION_CONNECTION_STATE_CHANGED
BluetoothDevice.ACTION_ACL_CONNECTED
BluetoothDevice.ACTION_ACL_DISCONNECTED
*/
"保留原因：应用接收这些蓝牙事件的广播时不太可能会影响用户体验"

/**
Telephony相关
CarrierConfigManager.ACTION_CARRIER_CONFIG_CHANGED
TelephonyIntents.ACTION_*_SUBSCRIPTION_CHANGED
TelephonyIntents.SECRET_CODE_ACTION
TelephonyManager.ACTION_PHONE_STATE_CHANGED
TelecomManager.ACTION_PHONE_ACCOUNT_REGISTERED
TelecomManager.ACTION_PHONE_ACCOUNT_UNREGISTERED
*/
"保留原因：设备制造商 (OEM) 电话应用可能需要接收这些广播"

/**
账号相关
AccountManager.LOGIN_ACCOUNTS_CHANGED_ACTION
*/
"保留原因：一些应用需要了解登录帐号的变化，以便为新帐号和变化的帐号设置计划操作"

/**
应用数据清除
Intent.ACTION_PACKAGE_DATA_CLEARED
*/
"保留原因：只在用户显式地从 Settings 清除其数据时发送，因此广播接收器不太可能严重影响用户体验"
    
/**
软件包被移除
Intent.ACTION_PACKAGE_FULLY_REMOVED
*/
"保留原因：一些应用可能需要在另一软件包被移除时更新其存储的数据；对于这些应用，尚未找到能够替代注册此广播的可行方案"

/**
外拨电话
Intent.ACTION_NEW_OUTGOING_CALL
*/
"保留原因：执行操作来响应用户打电话行为的应用需要接收此广播"
    
/**
当设备所有者被设置、改变或清除时发出
DevicePolicyManager.ACTION_DEVICE_OWNER_CHANGED
*/
"保留原因：此广播发送得不是很频繁；一些应用需要接收它，以便知晓设备的安全状态发生了变化"
    
/**
日历相关
CalendarContract.ACTION_EVENT_REMINDER
*/
"保留原因：由日历provider发送，用于向日历应用发布事件提醒。因为日历provider不清楚日历应用是什么，所以此广播必须是隐式广播。"
    
/**
安装或移除存储相关广播
Intent.ACTION_MEDIA_MOUNTED
Intent.ACTION_MEDIA_CHECKING
Intent.ACTION_MEDIA_EJECT
Intent.ACTION_MEDIA_UNMOUNTED
Intent.ACTION_MEDIA_UNMOUNTABLE
Intent.ACTION_MEDIA_REMOVED
Intent.ACTION_MEDIA_BAD_REMOVAL
*/
"保留原因：这些广播是作为用户与设备进行物理交互的结果：安装或移除存储卷或当启动初始化时（当可用卷被装载）的一部分发送的，因此它们不是很常见，并且通常是在用户的掌控下"

/**
短信、WAP PUSH相关
Telephony.Sms.Intents.SMS_RECEIVED_ACTION
Telephony.Sms.Intents.WAP_PUSH_RECEIVED_ACTION

注意：需要申请以下权限才可以接收
"android.permission.RECEIVE_SMS"
"android.permission.RECEIVE_WAP_PUSH"
*/
"保留原因：SMS短信应用需要接收这些广播"
```

##### 3.3.1.3 有序广播




参考：  
[Android的有序广播和无序广播（解决安卓8.0版本之后有序广播的接收问题）](https://www.jianshu.com/p/b768aea2123f)  
[Android中的有序和无序广播浅析](https://www.jianshu.com/p/0b3a7b35d76d)