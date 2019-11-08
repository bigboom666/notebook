# Binder
进程间的通信
client拿到Binder实体对象对应的地址去访问Server
binder机制是贯穿整个android系统的进程间访问机制，经常被用来访问service
![Binder是什么](https://imgconvert.csdnimg.cn/aHR0cDovL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pby91cGxvYWRfaW1hZ2VzLzk0NDM2NS00NWRiNGRmMzM5MzQ4YjliLnBuZz9pbWFnZU1vZ3IyL2F1dG8tb3JpZW50L3N0cmlwJTdDaW1hZ2VWaWV3Mi8yL3cvMTI0MA)

## 1. 知识储备
### 1.1 进程空间
- 内核空间（Kernel）是系统内核运行的空间，用户空间（UserSpace）是用户程序运行的空间。
- 系统内核空间和用户空间分离开来，保证用户程序进程崩溃时不会影响到整个系统
- 用户空间的进程要进行交互需要通过内核空间来驱动整个过程
- 进程内 用户空间 & 内核空间 进行交互 需通过 系统调用，主要通过函数：
  >copy_from_user（）：将用户空间的数据拷贝到内核空间  
   copy_to_user（）：将内核空间的数据拷贝到用户空间 
 
![进程空间](https://imgconvert.csdnimg.cn/aHR0cHM6Ly91cGxvYWQtaW1hZ2VzLmppYW5zaHUuaW8vdXBsb2FkX2ltYWdlcy85NDQzNjUtMTNkNTkwNThkNGUwY2JhMS5wbmc_aW1hZ2VNb2dyMi9hdXRvLW9yaWVudC9zdHJpcCU3Q2ltYWdlVmlldzIvMi93LzEyNDA)

### 1.2 进程隔离 & 跨进程通信（ IPC ）
- 进程隔离  
为了保证 安全性 & 独立性，一个进程 不能直接操作或者访问另一个进程，即Android的进程是相互独立、隔离的
- 传统的跨进程通信
![传统IPC](https://imgconvert.csdnimg.cn/aHR0cDovL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pby91cGxvYWRfaW1hZ2VzLzk0NDM2NS0xMjkzNTY4NGU4ZWMxMDdjLnBuZz9pbWFnZU1vZ3IyL2F1dG8tb3JpZW50L3N0cmlwJTdDaW1hZ2VWaWV3Mi8yL3cvMTI0MA)

- 使用了内存映射的 跨进程通信
![内存映射IPC](https://imgconvert.csdnimg.cn/aHR0cDovL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pby91cGxvYWRfaW1hZ2VzLzk0NDM2NS02NWE1YjE3NDI2YWVkNDI0LnBuZz9pbWFnZU1vZ3IyL2F1dG8tb3JpZW50L3N0cmlwJTdDaW1hZ2VWaWV3Mi8yL3cvMTI0MA)
>a. 而Binder的作用则是：连接 两个进程，实现了mmap()系统调用，主要负责 创建数据接收的缓存空间 & 管理数据接收缓存  
b. 注：传统的跨进程通信需拷贝数据2次，但Binder机制只需1次，主要是使用到了内存映射，具体下面会详细说明

## 2. Binder 跨进程通信机制&模型
### 2.1 C/S结构
Binder基于C/S的结构下，定义了4个角色：Server、Client、ServerManager、Binder驱动，其中前三者是在用户空间的，也就是彼此之间无法直接进行交互，Binder驱动是属于内核空间的，属于整个通信的核心，虽然叫驱动，但是实际上和硬件没有太大关系，只是实现的方式和驱动差不多，驱动负责进程之间Binder通信的建立，Binder在进程之间的传递，Binder引用计数管理，数据包在进程之间的传递和交互等一系列底层支持。
- 模型原理图
![模型原理图](https://imgconvert.csdnimg.cn/aHR0cDovL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pby91cGxvYWRfaW1hZ2VzLzk0NDM2NS1jMTBkNjAzMmY5MWExMDNmLnBuZz9pbWFnZU1vZ3IyL2F1dG8tb3JpZW50L3N0cmlwJTdDaW1hZ2VWaWV3Mi8yL3cvMTI0MA)  

  为什么都是跟Binder驱动交互？
![模型原理图](https://imgconvert.csdnimg.cn/aHR0cDovL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pby91cGxvYWRfaW1hZ2VzLzk0NDM2NS1iNDcwMDhhMDkyNjViOWM2LnBuZz9pbWFnZU1vZ3IyL2F1dG8tb3JpZW50L3N0cmlwJTdDaW1hZ2VWaWV3Mi8yL3cvMTI0MA)

- 模型角色说明
  ![模型角色说明](https://imgconvert.csdnimg.cn/aHR0cDovL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pby91cGxvYWRfaW1hZ2VzLzk0NDM2NS0xMzU1NjBjODdjOTgzZTQzLnBuZz9pbWFnZU1vZ3IyL2F1dG8tb3JpZW50L3N0cmlwJTdDaW1hZ2VWaWV3Mi8yL3cvMTI0MA)

client拿到Binder实体对象对应的地址去访问Server
>面向对象思想的引入将进程间通信转化为通过对某个Binder对象的引用调用该对象的方法，而其独特之处在于Binder对象是一个可以跨进程引用的对象，它的实体位于一个进程中，而它的引用却遍布于系统的各个进程之中。最诱人的是，这个引用和java里引用一样既可以是强类型，也可以是弱类型，而且可以从一个进程传给其它进程，让大家都能访问同一Server，就象将一个对象或引用赋值给另一个引用一样。Binder模糊了进程边界，淡化了进程间通信过程，整个系统仿佛运行于同一个面向对象的程序之中。形形色色的Binder对象以及星罗棋布的引用仿佛粘接各个应用程序的胶水，这也是Binder在英文里的原意。

- 模型架构  
  ![模型架构](https://imgconvert.csdnimg.cn/aHR0cDovL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pby91cGxvYWRfaW1hZ2VzLzk0NDM2NS0xNjMwYzY5ZTQ4Y2IxZGViLnBuZz9pbWFnZU1vZ3IyL2F1dG8tb3JpZW50L3N0cmlwJTdDaW1hZ2VWaWV3Mi8yL3cvMTI0MA)  
  >a. 系统已经实现好：Binder驱动和Service Manager进程属于Android基础架构；开发者自己实现：Client 进程 和 Server 进程   
  b. 在进行跨进程通信时，开发者只需自定义Client & Server 进程并显式使用上述3个步骤：注册，获取，使用



## 3.0 代码实现










Binder请求的线程管理
- Server进程会创建很多线程来处理Binder请求
- Binder模型的线程管理，采用Binder驱动的线程池，并由Binder驱动自身进行管理，而**不是由Server进程**来管理的
- 一个进程的Binder线程数默认最大是16，超过的请求会被阻塞等待空闲的Binder线程。  
  所以，在进程间通信时处理并发问题时，如使用ContentProvider时，它的CRUD（创建、检索、更新和删- 除）方法只能同时有16个线程同时工作



代码 

在onBinder方法中返回binder，binder包含了service的句柄，客户端得到句柄以后就可以调用servcie的公共方法了，这种调用方式是最常见的。


## Q&A
Q: Android为什么不使用linux原有的一些手段，比如管道，共享内存，socket等方式，而是采用了Binder作为主要机制？  
A: 效率，安全性。Binder只需要一次拷贝，性能仅次于共享内存，而且采用的传统的C/S结构，稳定性也是没得说，发送添加UID/PID，安全性高

# 参考
[Binder学习指南](http://weishu.me/2016/01/12/binder-index-for-newer/)  
[Android跨进程通信：图文详解 Binder机制 原理](https://blog.csdn.net/carson_ho/article/details/73560642)  