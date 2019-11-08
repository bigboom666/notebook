1. 新建数据类 model   fruit.class  
2. RecyclerView的子项指定一个我们自定义的布局   fruit_item.xml  
3. 准备一个适配器，新建FruitAdapter 类，让这个适配器继承自RecyclerView.Adapter ，并将泛型指定为FruitAdapter.ViewHolder 。其中，ViewHolder 是我们在FruitAdapter 中定义的一个内部类

RecyclerView.Adapter有三个方法要实现

- viewholder，  
继承自RecyclerView.ViewHolder，
构造函数中要传入一个View 参数，这个参数通常就是RecyclerView子项的最外层布局，那么我们就可以通过findViewById() 方法来获取到布局中的ImageView和TextView的实例

- 一个构造函数，这个方法用于把要展示的数据源传进来，并赋值给一个全局变量mFruitList ，我们后续的操作都将在这个数据源的基础上进行。

- onCreateViewHolder() 方法是用于创建ViewHolder 实例的，我们在这个方法中将fruit_item 布局加载进来，然后创建一个ViewHolder 实例

- onBindViewHolder() 方法是用于对RecyclerView子项的数据进行赋值的，会在每个子项被滚动到屏幕内的时候执行



## 点击事件
- 修改了ViewHolder ，在ViewHolder 中添加了fruitView 变量来保存子项最外层布局的实例
- 在onCreateViewHolder()方法中注册点击事件，