## 组件属性

android:layout_width、android:layout_height  
match_parent 表示让当前元素和父元素一样宽。
wrap_content表示当前元素的高度只要能刚好包含里面的内容就行。

android:padding="24dp"  
属性告诉组件在决定大小时，除内容本身外，还需增加额外指定量的空间。这样屏幕上显示的问题与按钮之间便会留有一定的空间，使整体显得更为美观。

android:orientation 
android:orientation 属性是两个LinearLayout 组件都具有的属性，它决定两者的子组件是水平放置还是垂直放置。

android:text 
该属性指定组件要显示的文字内容。  
属性值不是字符串值，而是对字符串资源 （string resource）的引用。
为什么安卓把字符串分开作为资源放？ 便于多语言适配





## java和xml怎么交互
.java通过public View findViewById(int id)(资源ID)获得控件
并通过对象的方法调用控件





