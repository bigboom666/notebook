## Intent
它是一种数据结构，抽象描述一次将要被执行的操作，其作用是在程序运行过程中连接两个不同的组件。应用程序通过 Intent 向 Android 系统发出某种请求信息，Android 根据请求的信息内容选择能够处理该请求的组件。   
>例如：使用 Android 手机拨打电话，当按下拨号发送键就会向 Android 系统发送一个具有 CALL_BUTTON 行为的 Intent 对象。Android 系统根据该请求信息，从注册应用的 AndroidManifest.xml 中找到能够处理该请求的电话号码拨号程序。输入电话号码并再次按下拨号发送键时，拨号程序会将一个包含 ACTION_CALL 和电话号码数据的 Intent 请求发送给 Android 系统，之后 Android 系统查找合适的应用程序进行处理。


### 使用 
#### 显式Intent
##### 启动下一个Activity，不传递数据
```java
mybutton.setOnClickListener(new OnClickListener() {
    @Override
    public void onClick(View v) {
	Intent intent = new Intent(FirstActivity.this,SecondActivity.class);
    startActivity (intent);
    }
});
```

##### 启动下一个Activity，传递数据
```java
//ActivityA向ActivityB传递参数    直接在ActivityA里new Intent也行
//定义 (ActivityB)
public static Intent newIntent(Context packageContext,boolean answerIsTrue){
    Intent intent = new Intent(packageContext, AnswerActivity.class);
    intent.putExtra(EXTRA_ANSWER_IS_TRUE, answerIsTrue);
    return intent;
}
//调用 (ActivityA)
startActivity(Intent);
//拿到数据 (ActivityB)
mAnswerIsTrue = getIntent().getBooleanExtra(EXTRA_ANSWER_IS_TRUE,false);
```
##### 在本Activity销毁时，返回数据给上一个Activity
startActivityForResult（）方法，该方法也是用来启动活动的，但是这个方法期望在活动销毁的时候能够返回一个结果给上一个活动。  
我们使用startActivityForResult（）方法来启动SecondActivity的，在SecondActivity被销毁之后会回调上一个活动的onActivityResult()方法。
```java
//ActivityA
mAnswerButton.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View v) {
        boolean answerIsTrue = mQuestionBank[mCurrentIndex].isAnswerTrue();
        Intent intent = AnswerActivity.newIntent(QuizActivity.this, answerIsTrue);
        startActivityForResult(intent, REQUEST_CODE_ANSWER);
    }
})

//ActivityB   定义一个返回数据的函数并调用   在此Activity销毁后  会回传数据
private void setAnswerShownResult(boolean isAnswerShown){
    Intent data = new Intent();
    data.putExtra(EXTRA_ANSWER_SHOWN,isAnswerShown);
    setResult(RESULT_OK,data);
}


//ActivityA  在ActivityB销毁后，调用onActivityResult()
@Override
protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
    //注意检查返回的结果
    if (resultCode != RESULT_OK) {
        return;
    }
    if (requestCode == REQUEST_CODE_ANSWER) {    //REQUEST_CODE_ANSWER,用来判断来源，也可用switch
        if (data == null) {
            return;
        }
        mIsAnswer = AnswerActivity.wasAnswerShown(data);
    }
}

```

 

==同一个应用的activit 为什么还要用Intent 借助ctivityManager 通信?==


extra也是一种键值结构。
public Intent putExtra(String name, boolean value)
记得使用包名修饰extra数据信息，这样，可避免来自不同应用的extra间发生命名冲突。


[Android Context 是什么？](https://blog.csdn.net/feiduclear_up/article/details/47356289) 
看不太懂  以后再看



==传递的数据都是在activity消亡或启动，有没有实时的==


intent-filter


[Android：这是一份详细的Intent学习指南](https://blog.csdn.net/carson_ho/article/details/51762131)   
[Android学习笔记(一) Intent用法总结](https://www.androiddev.net/android学习笔记一-intent用法总结/)