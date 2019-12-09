# bitmap创建
Bitmap是一个final类，因此不能被继承。
Bitmap只有一个构造方法，且该构造方法是没有任何访问权限修饰符修饰，不能直接通过构造方法创建Bitmap。
利用Bitmap的静态方法createBitmap()和BitmapFactory的decode系列静态方法创建Bitmap对象。
## 利用Bitmap的静态方法createBitmap()
![](https://upload-images.jianshu.io/upload_images/1736058-638e1836671d38f5.png?imageMogr2/auto-orient/strip|imageView2/2/w/430/format/webp)
## 利用BitmapFactory的decode系列静态方法
![](https://upload-images.jianshu.io/upload_images/1736058-1b4f93c3886c997b.png?imageMogr2/auto-orient/strip|imageView2/2/w/514/format/webp)


# Bitmap的颜色配置信息与压缩方式信息
Bitmap中有两个内部枚举类：Config和CompressFormat，Config是用来设置颜色配置信息的，CompressFormat是用来设置压缩方式的。
![](https://upload-images.jianshu.io/upload_images/1736058-d530c7d0bb8e8cf6.png?imageMogr2/auto-orient/strip|imageView2/2/w/371/format/webp)

# Bitmap对图像进行操作
## 1. Bitmap裁剪图像
```java
Bitmap.createBitmap(Bitmap source, int x, int y, int width, int height)
```
根据源Bitmap对象source，创建出source对象裁剪后的图像的Bitmap。x,y分别代表裁剪时，x轴和y轴的第一个像素，width，height分别表示裁剪后的图像的宽度和高度。

## 2. Bitmap缩放，旋转，移动图像
```java 
Bitmap.createBitmap(Bitmap source, int x, int y, int width, int height,Matrix m, boolean filter)
```
这个方法只比上面的方法多了m和filter这两个参数，m是一个Matrix（矩阵）对象，可以进行缩放，旋转，移动等动作，filter为true时表示source会被过滤，仅仅当m操作不仅包含移动操作，还包含别的操作时才适用。其实上面的方法本质上就是调用这个方法而已。

```java
// 定义矩阵对象  
Matrix matrix = new Matrix();  
// 缩放图像  
matrix.postScale(0.8f, 0.9f);  
// 向左旋转（逆时针旋转）45度，参数为正则向右旋转（顺时针旋转） 
matrix.postRotate(-45);  
//移动图像
//matrix.postTranslate(100,80);
Bitmap bitmap = Bitmap.createBitmap(source, 0, 0, source.getWidth(), source.getHeight(),  
        matrix, true);    
```

## 3. Bitmap保存图像与释放资源
```java
bitmap=BitmapFactory.decodeResource(getResources(),R.drawable.feng);
File file=new File(getFilesDir(),"lavor.jpg");
if(file.exists()){
    file.delete();
}
try {
    FileOutputStream outputStream=new FileOutputStream(file);
    bitmap.compress(Bitmap.CompressFormat.JPEG,90,outputStream);
    outputStream.flush();
    outputStream.close();
} catch (FileNotFoundException e) {
    e.printStackTrace();
} catch (IOException e) {
    e.printStackTrace();
}
bitmap.recycle();//释放bitmap的资源，这是一个不可逆转的操作
```

# BitmapFactory通过BitmapFactory.Options对图像进行操作
BitmapFactory是通过BitmapFactory.Options对图像进行操作的，然后将操作后的图像生成Bitmap对象或者将操作后的图像用已经存在的Bitmap保存，当不能用之保存时会返回null。
![](https://upload-images.jianshu.io/upload_images/1736058-b17bd999b0a3e762.png?imageMogr2/auto-orient/strip|imageView2/2/w/371/format/webp)

- inBitmap：如果设置将会将生成的图像内容加载到该Bitmap对象中。
- inDensity：给Bitmap对象设置的密度，如果inScaled为true（这是默认的），而若inDensity与inTargetDensity不匹配，那么就会在Bitmap对象返回前将其缩放到匹配inTargetDensity。
- inDither：是否对图像进行抖动处理，默认值是false。
- inJustDecodeBounds：如果设置成true，表示获取Bitmap对象信息，但是不将其像素加载到内存。
- inPreferredConfig：Bitmap对象颜色配置信息，默认是Bitmap.Config.ARGB_8888。
- inSampleSize：对图像进行压缩，设置的值为2的整数次幂或者接近2的整数次幂，当次设置为2时，宽和高为都原来的1/2，图像所占空间为原来的1/4。
- inScaled：设置是否缩放。
- inTargetDensity：绘制到目标Bitmap上的密度。
- outHeight：Bitmap对象的高度。
- outWidth：Bitmap对象的宽度。



# 综合例子
```java
    /**
     * 谷歌推荐使用方法，从资源中加载图像，并高效压缩，有效降低OOM的概率
     * @param res 资源
     * @param resId 图像资源的资源id
     * @param reqWidth 要求图像压缩后的宽度
     * @param reqHeight 要求图像压缩后的高度
     * @return
     */
    public Bitmap decodeSampledBitmapFromResource(Resources res, int resId, int reqWidth, int reqHeight) {
        // 设置inJustDecodeBounds = true ,表示获取图像信息，但是不将图像的像素加入内存
        final BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeResource(res, resId, options);

        // 调用方法计算合适的 inSampleSize
        options.inSampleSize = calculateInSampleSize(options, reqWidth,
                reqHeight);

        // inJustDecodeBounds 置为 false 真正开始加载图片
        options.inJustDecodeBounds = false;
        //将options.inPreferredConfig改成Bitmap.Config.RGB_565，
        // 是默认情况Bitmap.Config.ARGB_8888占用内存的一般
        options.inPreferredConfig= Bitmap.Config.RGB_565;
        return BitmapFactory.decodeResource(res, resId, options);
    }

    // 计算 BitmapFactpry 的 inSimpleSize的值的方法
    public int calculateInSampleSize(BitmapFactory.Options options,
                                     int reqWidth, int reqHeight) {
        if (reqWidth == 0 || reqHeight == 0) {
            return 1;
        }

        // 获取图片原生的宽和高
        final int height = options.outHeight;
        final int width = options.outWidth;
        Log.d(TAG, "origin, w= " + width + " h=" + height);
        int inSampleSize = 1;

        // 如果原生的宽高大于请求的宽高,那么将原生的宽和高都置为原来的一半
        if (height > reqHeight || width > reqWidth) {
            final int halfHeight = height / 2;
            final int halfWidth = width / 2;

            // 主要计算逻辑
            // Calculate the largest inSampleSize value that is a power of 2 and
            // keeps both
            // height and width larger than the requested height and width.
            while ((halfHeight / inSampleSize) >= reqHeight && (halfWidth / inSampleSize) >= reqWidth) {
                inSampleSize *= 2;
            }
        }

        Log.d(TAG, "sampleSize:" + inSampleSize);
        return inSampleSize;
    }  
```




BitmapFactory  
    decodeFile
    decodeStream
    ...

采样率
BitmapFactory.Options的inJustDecodeBounds设true并加载图片（轻量加载）
BitmapFactory.Options读出原始宽高
计算inSampleSize
BitmapFactory.Options的inJustDecodeBounds设置false