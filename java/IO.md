# IO
类很多，了解基本和常用，剩下的遇到再看。
## 1. IO体系
### 1.1 数据来源/操作对象
分类|	字节输入流  |	字节输出流	|字符输入流 	|字符输出流
----|-------------|-------------|-------------|-------------
抽象基类|InputStream|OutputStream|Reader|Writer
访问文件|**FileInputStream**|**FileOutputStream**|**FileReader**|**FileWriter**
访问数组|**ByteArrayInputStream**|**ByteArrayOutputStream**|**CharArrayReader**|**CharArrayWriter**
访问管道|**PipedInputStream**|**PipedOutputStream**|**PipedReader**|**PipedWriter**
访问字符串| | |**StringReader**|**StringWriter**
缓冲流|BufferedInputStream|BufferedOutputStream|BufferedReader|BufferedWriter
转换流|	| |InputStreamReader|OutputStreamWriter
对象流|ObjectInputStream|ObjectOutputStream|
抽象基类|FilterInputStream|FilterOutputStream|FilterReader|FilterWriter
打印流| |PrintStream| |PrintWriter
推回输入流|PushbackInputStream| |PushbackReader	 
特殊流|DataInputStream|DataOutputStream	 
>注：表中粗体字所标出的类代表节点流，必须直接与指定的物理节点关联：斜体字标出的类代表抽象基类，无法直接创建实例。

![操作对象](https://user-gold-cdn.xitu.io/2018/5/16/16367d673b0e268d?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

### 1.2 数据传输/运输方式
![字节字符](https://user-gold-cdn.xitu.io/2018/9/11/165c95a493d6356b?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

## 2. 常用的IO方法
### 2.1 访问文件
- 字节流 FileInputStream FileOutputStream
按字节为单位(提供的方法)
write(byte b[])

- 字符流 FileReader	FileWriter
按字符为单位(提供的方法)
write(char c[])

### 2.2 缓冲流
- 字节流 BufferedInputStream BufferedOutputStream  
 1） BufferedOutputStream没有无参构造方法,它必须传入一个OutputStream(一般是FileOutputStream)，来一起使用，以提高读写效率。
- 字符流 BufferedReader	BufferedWriter  
  readLine() 方便读取输入。
### 2.3 转换流
- 字符流 InputStreamReader OutputStreamWriter
- 作用
1. 如果目前所 获取到的是一个字节流需要转换字符流使用，这时候就可以使用转换流。   
字节流----> 字符流
2. 使用转换流可以**指定编码**表进行读写文件。

### 2.4 数据流
数据输入流允许应用程序以与机器无关(嘛意思？)方式从底层输入流中读取基本 Java 数据类型。
- 字节流 DataOutputStream DataInputStream  
- 构造方法：DataOutputStream(OutputStream outs);  
按字节为单位，方法提供了各种类型的读写。
writeDouble() writeChar() WriteByte()...

```java
String filePath = "E:\\Workspace\\IdeaStudio\\io-demo\\i-o\\demo\\data.dat";

// 参见【再学点东西】部分
DataOutputStream dos = new DataOutputStream(new FileOutputStream(new File(filePath)));

dos.write('A');
dos.writeInt(10);
dos.writeBoolean(true);
dos.writeByte(-1);
dos.writeChar('B');
// 采用UTF-16BE
dos.writeChars("中国");
dos.writeUTF("中国");
dos.writeDouble(20.10);
dos.writeFloat(10.20f);
dos.writeLong(100000000L);

dos.close();

IOUtil.printHex(filePath);
```
[Java | 学习字节流DataInputStream and DataOutputStream](https://www.jianshu.com/p/9606d680c103)

### 2.5 对象流-序列化

```java
        ObjectOutputStream oo = new ObjectOutputStream(new FileOutputStream(new File("E:/Person.txt")));
        oo.writeObject(person);
```
#### 作用：   
　　1） 把对象的字节序列永久地保存到硬盘上，通常存放在一个文件中；   
　　2） 在网络上传送对象的字节序列。
>1. 在很多应用中，需要对某些对象进行序列化，让它们离开内存空间，入住物理硬盘，以便长期保存。比如最常见的是Web服务器中的Session对象，当有 10万用户并发访问，就有可能出现10万个Session对象，内存可能吃不消，于是Web容器就会把一些seesion先序列化到硬盘中，等要用了，再把保存在硬盘中的对象还原到内存中。  
>2. 当两个进程在进行远程通信时，彼此可以发送各种类型的数据。无论是何种类型的数据，都会以二进制序列的形式在网络上传送。发送方需要把这个Java对象转换为字节序列，才能在网络上传送；接收方则需要把字节序列再恢复为Java对象。

#### serialVersionUID
- 类的源码修改了(比如增加一个成员变量)，存储的对象还能反序列化吗？  
>2个序列化版本号不一致会报错。  
如果不显式指定UID，java编译器会自动给这个class进行一个摘要算法，类似于指纹算法，只要这个文件 多一个空格，得到的UID就会截然不同的，可以保证在这么多类中，这个编号是唯一的。

答：只要我们自己指定了serialVersionUID，就可以在序列化后，去添加一个字段，或者方法，而不会影响到后期的还原，还原后的对象照样可以使用，而且还多了方法或者属性可以用。

- 用法？  
1、 在某些场合，希望类的不同版本对序列化兼容，因此需要确保类的不同版本具有相同的serialVersionUID；  
2、 在某些场合，不希望类的不同版本对序列化兼容，因此需要确保类的不同版本具有不同的serialVersionUID。


#### 注意点：
1） 序列化的类需要实现Serializable接口(标记接口，内容为空)。  
2） 类的serialVersionUID的默认值完全依赖于Java编译器的实现，对于同一个类，用不同的Java编译器编译，有可能会导致不同的 serialVersionUID，也有可能相同。为了提高serialVersionUID的独立性和确定性，强烈建议在一个可序列化类中显示的定义serialVersionUID，为它赋予明确的值。  
3） 由JVM直接构造出Java对象，不调用构造方法，构造方法内部的代码，在反序列化时根本不可能执行

[Java基础学习总结——Java对象的序列化和反序列化](https://www.cnblogs.com/xdp-gacl/p/3777987.html)

## 3. 注意事项和问题
### 3.1 缓冲流为什么能提高效率？
- 不带缓冲的操作，每读一个字节就要写入一个字节，由于涉及磁盘的IO操作相比内存的操作要慢很多，所以不带缓冲的流效率很低。  
带缓冲的流，可以一次读很多字节，但不向磁盘中写入，只是先放到内存里。等凑够了缓冲区大小的时候一次性写入磁盘，这种方式可以减少磁盘操作次数，速度就会提高很多。  
- 优点：效率高   
缺点：内存占用多

### 3.2 字节流和字符流差别在哪？
- 字节流操作的基本单元为字节；字符流操作的基本单元为Unicode码元。  
- 字节流默认不使用缓冲区；字符流使用缓冲区。(至少文件流是这样的)  
- 字节流通常用于处理二进制数据，实际上它可以处理任意类型的数据，但它不支持直接写入或读取Unicode码元；字符流通常处理文本数据，它支持写入及读取Unicode码元。
>实际上，在我们没有指定时使用的是操作系统的默认字符编码方式来对我们要写入的字符进行编码。  
由于字符流在输出前实际上是要完成Unicode码元序列到相应编码方式的字节序列的转换，所以它会使用内存缓冲区来存放转换后得到的字节序列，等待都转换完毕再一同写入磁盘文件中。

## 参考
- [Java8 I/O源码-目录](https://blog.csdn.net/panweiwei1994/article/details/78046000)
- [理解Java中字符流与字节流的区别](https://www.cnblogs.com/absfree/p/5415092.html))
- [IO流(操作文件内容)](https://www.jianshu.com/p/5a3e15793ce9)



## 代码
```java 
import java.io.*;
import java.text.MessageFormat;

public class TestIO {

    public static void main(String[] args) throws Exception {

        testSerialize();


    }

    //文件 字节流  FileInputStream FileOutputStream
    public static void test01() throws FileNotFoundException {
        FileInputStream fileInputStream = null;
        FileOutputStream fileOutputStream = null;
        try {
            //创建字节输入输出流

            fileInputStream = new FileInputStream(new File("./IO/test.txt"));
            fileOutputStream = new FileOutputStream(new File("./IO/test2.txt"));

            int hasRead;
            byte[] fileArray = new byte[1024];
            byte[] b = new byte[]{1,2,3,4,5,6,7,8,9,10,11};
            while ((hasRead = fileInputStream.read(fileArray)) > 0) {
                //System.out.println(new String(fileArray, 0, hasRead));
                System.out.println(new String(b));
            }

            String a = "abc123";

            fileOutputStream.write(b);//没有缓冲区，不需要flush   字节流默认不使用缓冲区


        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    //文件 字符流  fileReader      为什么汉字乱码？？？？？？？？？？？？？？？？？？？？？？？？？？？？？
    public static void test02() throws FileNotFoundException {
        FileReader fileReader = null;
        FileWriter fileWriter = null;
        try {
            //创建字节输入流
            fileReader = new FileReader(new File("./IO/test.txt"));
            fileWriter = new FileWriter(new File("./IO/test2.txt"));

            int hasRead;
            char[] fileArray = new char[1024];
            while ((hasRead = fileReader.read(fileArray)) > 0) {
                //System.out.println(new String(fileArray, 0, hasRead));
                System.out.println(fileArray);
            }

            //OutputStreamWriter
            fileWriter.write(fileArray);
            fileWriter.flush();    //为什么这个要flush？OutputStreamWriter看  里面有个缓冲区。
            fileWriter.close();

        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    //缓存流
    public static void test03() throws FileNotFoundException {
        FileInputStream fileInputStream = null;
        FileOutputStream fileOutputStream = null;
        BufferedInputStream bufferedInputStream = null;
        BufferedOutputStream bufferedOutputStream = null;
        try {
            fileInputStream = new FileInputStream(new File("./IO/test.txt"));
            fileOutputStream = new FileOutputStream(new File("./IO/test2.txt"));
            bufferedInputStream = new BufferedInputStream(fileInputStream);
            bufferedOutputStream = new BufferedOutputStream(fileOutputStream);

            byte[] byteArray = new byte[1024];
            int hasRead = 0;

            if ((hasRead = bufferedInputStream.read(byteArray)) > 0) ;

            bufferedOutputStream.write(byteArray);
            bufferedOutputStream.flush();


        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                bufferedOutputStream.close();
                //上面代码中我们使用了缓存流和文件流，但是我们只关闭了缓存流。这个需要注意一下，当我们使用处理流套接到节点流上的使用的时候，只需要关闭最上层的处理就可以了。java会自动帮我们关闭下层的节点流。
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }


//DataInputStream  DataOutputStream
// 检查文件是否存在，否则创建
    public static void checkFile(File file) {
        if (!file.exists()) {
            file.getParentFile().mkdirs();// 创建多级目录
            try {
                file.createNewFile();// 创建文件，此处需要处理异常
                System.out.println("创建文件成功！");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
// 明确源文件和目标文件
    public static void test04() throws IOException {
        myWrite();
        myReader();
    }


    private static void myWrite() throws IOException {
// TODO Auto-generated method stub
// 创建数据输出流对象
        File o = new File("./IO/test.txt");// 源文件
        File t = new File("./IO/test2.txt");// 目标文件
        checkFile(o);
        checkFile(t);
        FileOutputStream fos = new FileOutputStream(o);
        DataOutputStream dos = new DataOutputStream(fos);
// 写数据
        dos.writeByte(10);
        dos.writeShort(100);
        dos.writeInt(1000);
        dos.writeLong(10000);
        dos.writeFloat(12.34F);
        dos.writeDouble(12.56);
        dos.writeChar('a');
        dos.writeBoolean(true);
// 释放资源
        dos.close();
    }


    private static void myReader() throws IOException {
// TODO Auto-generated method stub
// 创建数据输入流对象
        File o = new File("./IO/test.txt");// 源文件
        FileInputStream fis = new FileInputStream(o);
        DataInputStream dis = new DataInputStream(fis);
// 读数据
        byte b = dis.readByte();
        short s = dis.readShort();
        int i = dis.readInt();
        long l = dis.readLong();
        float f = dis.readFloat();
        double d = dis.readDouble();
        char c = dis.readChar();
        boolean bl = dis.readBoolean();
// 释放资源
        dis.close();
        System.out.println(b);
        System.out.println(s);
        System.out.println(i);
        System.out.println(l);
        System.out.println(f);
        System.out.println(d);
        System.out.println(c);
        System.out.println(bl);
    }


//转换流

    //使用输入字节流的转换流指定码表进行读取文件数据      显示中文字符很方便
    public static void readTest2() throws IOException{
        File file = new File("./IO/test.txt");
        FileInputStream fileInputStream = new FileInputStream(file);
        //创建字节流的转换流并且指定码表进行读取
        InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream,"utf-8");
        char[] buf = new char[1024];
        int length = 0;
        while((length = inputStreamReader.read(buf))!=-1){
            System.out.println(new String(buf,0,length));
        }
    }

    //使用输出字节流的转换流指定码表写出数据
    public static void writeTest2() throws IOException{
        File file = new File("./IO/test2.txt");
        //建立数据的输出通道
        FileOutputStream fileOutputStream = new FileOutputStream(file);
        //把输出字节流转换成字符流并且指定编码表。
        OutputStreamWriter outputStreamWriter = new OutputStreamWriter(fileOutputStream, "utf-8");
        outputStreamWriter.write("新中国好啊");
        //关闭资源
        outputStreamWriter.close();
    }

    //读标准输入，放入转换流
    public static void readTest() throws IOException{
        InputStream in = System.in; //获取了标准的输入流。
//      System.out.println("读到 的字符："+ (char)in.read());  //read()一次只能读取一个字节。
        //需要把字节流转换成字符流。
        InputStreamReader inputStreamReader = new InputStreamReader(in);
        //使用字符流的缓冲类
        BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

        String line = null;
        while((line = bufferedReader.readLine())!=null){
            System.out.println("内容："+ line);
        }
    }



    //对象流  序列化

    /**
     * <p>ClassName: TestObjSerializeAndDeserialize<p>
     * <p>Description: 测试对象的序列化和反序列<p>
     * @author xudp
     * @version 1.0 V
     * @createTime 2014-6-9 下午03:17:25
     */


        public static void testSerialize() throws Exception {
            SerializePerson();//序列化Person对象
            Person p = DeserializePerson();//反序列Perons对象
            System.out.println(MessageFormat.format("name={0},age={1},sex={2}",
                    p.getName(), p.getAge(), p.getSex()));
        }

        /**
         * MethodName: SerializePerson
         * Description: 序列化Person对象
         * @author xudp
         * @throws FileNotFoundException
         * @throws IOException
         */
        private static void SerializePerson() throws FileNotFoundException,
                IOException {
            Person person = new Person();
            person.setName("gacl");
            person.setAge(25);
            person.setSex("男");
            // ObjectOutputStream 对象输出流，将Person对象存储到E盘的Person.txt文件中，完成对Person对象的序列化操作
            ObjectOutputStream oo = new ObjectOutputStream(new FileOutputStream(
                    new File("./IO/Person.txt")));
            oo.writeObject(person);
            System.out.println("Person对象序列化成功！");
            oo.close();
        }

        /**
         * MethodName: DeserializePerson
         * Description: 反序列Perons对象
         * @author xudp
         * @return
         * @throws Exception
         * @throws IOException
         */
        private static Person DeserializePerson() throws Exception, IOException {
            ObjectInputStream ois = new ObjectInputStream(new FileInputStream(
                    new File("./IO/Person.txt")));
            Person person = (Person) ois.readObject();
            System.out.println("Person对象反序列化成功！");
            return person;
        }


}






/**
 * <p>ClassName: Person<p>
 * <p>Description:测试对象序列化和反序列化<p>
 * @author xudp
 * @version 1.0 V
 * @createTime 2014-6-9 下午02:33:25
 */
 class Person implements Serializable {

    /**
     * 序列化ID
     */
    private static final long serialVersionUID = -5809782578272943999L;
    private int age;
    private String name;
    private String sex;
    private int neverUse;

    public int getAge() {
        return age;
    }

    public String getName() {
        return name;
    }

    public String getSex() {
        return sex;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }
}
```