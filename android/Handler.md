

# 有啥用
消息传递机制 / 异步通信机制

将工作线程中需更新UI的操作信息 传递到 UI主线程

为什么要用 Handler消息传递机制
答：多个线程并发更新UI的同时 保证线程安全。

![](https://imgconvert.csdnimg.cn/aHR0cDovL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pby91cGxvYWRfaW1hZ2VzLzk0NDM2NS03NDc5YjRhOGI4ZmU0OGJmLnBuZz9pbWFnZU1vZ3IyL2F1dG8tb3JpZW50L3N0cmlwJTdDaW1hZ2VWaWV3Mi8yL3cvMTI0MA)


# 咋用
Handler使用方式，因发送消息到消息队列的方式不同而不同  
共分为2种：使用Handler.sendMessage（）、使用Handler.post（）  

## 使用Handler.sendMessage（）
```java
/** 
  * 方式1：新建Handler子类（内部类）
  */

    // 步骤1：自定义Handler子类（继承Handler类） & 复写handleMessage（）方法
    class mHandler extends Handler {

        // 通过复写handlerMessage() 从而确定更新UI的操作
        @Override
        public void handleMessage(Message msg) {
         ...// 需执行的UI操作
            
        }
    }

    // 步骤2：在主线程中创建Handler实例
        private Handler mhandler = new mHandler();

    // 步骤3：在工作线程，创建所需的消息对象
        Message msg = Message.obtain(); // 实例化消息对象
        msg.what = 1; // 消息标识
        msg.obj = "AA"; // 消息内容存放

    // 步骤4：在工作线程中 通过Handler发送消息到消息队列中
    // 可通过sendMessage（） / post（）
    // 多线程可采用AsyncTask、继承Thread类、实现Runnable
        mHandler.sendMessage(msg);

    // 步骤5：开启工作线程（同时启动了Handler）
    // 多线程可采用AsyncTask、继承Thread类、实现Runnable


/** 
  * 方式2：匿名内部类
  */
   // 步骤1：在主线程中 通过匿名内部类 创建Handler类对象
            private Handler mhandler = new  Handler(){
                // 通过复写handlerMessage()从而确定更新UI的操作
                @Override
                public void handleMessage(Message msg) {
                        ...// 需执行的UI操作
                    }
            };

  // 步骤2：工作线程中 创建消息对象
    Message msg = Message.obtain(); // 实例化消息对象
  msg.what = 1; // 消息标识
  msg.obj = "AA"; // 消息内容存放
  
  // 步骤3：在工作线程中 通过Handler发送消息到消息队列中
  // 多线程可采用AsyncTask、继承Thread类、实现Runnable
   mHandler.sendMessage(msg);

  // 步骤4：开启工作线程（同时启动了Handler）
  // 多线程可采用AsyncTask、继承Thread类、实现Runnable

```

##  Handler.post（）
没有用到message  
```java
public class MainActivity extends AppCompatActivity {
    
    public TextView mTextView;
    public Handler mHandler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mTextView = (TextView) findViewById(R.id.show);

        // 步骤1：在主线程中创建Handler实例
        mHandler = new Handler();

        // 步骤2：在工作线程中 发送消息到消息队列中 & 指定操作UI内容
        new Thread() {
            @Override
            public void run() {
                try {
                    Thread.sleep(3000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                // 通过psot（）发送，需传入1个Runnable对象
                mHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        // 指定操作UI内容
                        mTextView.setText("执行了线程1的UI操作");
                    }

                });
            }
        }.start();
        // 步骤3：开启工作线程（同时启动了Handler）

        // 此处用2个工作线程展示
        new Thread() {
            @Override
            public void run() {
                try {
                    Thread.sleep(6000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                mHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        mTextView.setText("执行了线程2的UI操作");
                    }

                });
            }
        }.start();

    }

}
```


# 参考
[Android 异步通信：手把手教你使用Handler消息传递机制（含实例Demo）](https://blog.csdn.net/carson_ho/article/details/80305411)




那么Handler到底是什么呢？Handler是Android中引入的一种让开发者参与处理线程中消息循环的机制。每个Hanlder都关联了一个线程，每个线程内部都维护了一个消息队列MessageQueue，这样Handler实际上也就关联了一个消息队列。可以通过Handler将Message和Runnable对象发送到该Handler所关联线程的MessageQueue（消息队列）中，然后该消息队列一直在循环拿出一个Message，对其进行处理，处理完之后拿出下一个Message，继续进行处理，周而复始。当创建一个Handler的时候，该Handler就绑定了当前创建Hanlder的线程。从这时起，该Hanlder就可以发送Message和Runnable对象到该Handler对应的消息队列中，当从MessageQueue取出某个Message时，会让Handler对其进行处理。

Handler可以用来在多线程间进行通信，在另一个线程中去更新UI线程中的UI控件只是Handler使用中的一种典型案例，除此之外，Handler可以做很多其他的事情。每个Handler都绑定了一个线程，假设存在两个线程ThreadA和ThreadB，并且HandlerA绑定了 ThreadA，在ThreadB中的代码执行到某处时，出于某些原因，我们需要让ThreadA执行某些代码，此时我们就可以使用Handler，我们可以在ThreadB中向HandlerA中加入某些信息以告知ThreadA中该做某些处理了。由此可以看出，Handler是Thread的代言人，是多线程之间通信的桥梁，通过Handler，我们可以在一个线程中控制另一个线程去做某事。
