adapter  把数据和item,layout联系起来  
数组中的数据是无法直接传递给ListView的，我们还需要借助适配器来完成。

1. 新建数据类 model   fruit.class  
2. ListView的子项指定一个我们自定义的布局   fruit_item.xml  
3. 创建一个自定义的适配器，这个适配器继承自ArrayAdapter，并将泛型指定为Fruit 类  
- 父类的一组构造函数，用于将上下文、ListView子项布局的id和数据都传递进来
- getView() 方法，这个方法在每个子项被滚动到屏幕内的时候会被调用。在getView() 方法中，首先通过getItem() 方法得到当前项的Fruit实例，然后使用LayoutInflater 来为这个子项加载我们传入的布局

>LayoutInflater 的inflate() 方法接收3个参数，前两个参数我们已经知道是什么意思了，第三个参数指定成false ，表示只让我们在父布局中声明的layout 属性生效，但不会为这个View添加父布局，因为一旦View有了父布局之后，它就不能再添加到ListView中了。




## 提升ListView的运行效率

1. getView() 方法中还有一个convertView 参数，这个参数用于将之前加载好的布局进行缓存，以便之后可以进行重用。
```java
if (convertView == null) {
            view = LayoutInflater.from(getContext()).inflate(resourceId, parent,
                false);
        } else {
            view = convertView;
        }
```
2. 每次在getView() 方法中还是会调用View 的findViewById() 方法来获取一次控件的实例。我们可以借助一个**ViewHolder** 来对这部分性能进行优化
>新增了一个内部类ViewHolder ，用于对控件的实例进行缓存。当convertView 为null 的时候，创建一个ViewHolder 对象，并将控件的实例都存放在ViewHolder 里，然后调用View 的setTag() 方法，将ViewHolder 对象存储在View 中。当convertView 不为null 的时候，则调用View 的getTag() 方法，把ViewHolder 重新取出。这样所有控件的实例都缓存在了ViewHolder 里，就没有必要每次都通过findViewById() 方法来获取控件实例了
