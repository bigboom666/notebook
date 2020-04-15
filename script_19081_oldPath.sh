devices="1aad6ef0" 
runningTimes="1000"


for((i=0;i<$runningTimes;i++)); do   #总次数=runningTimes次

	
	adb -s $devices shell input tap 540 340  #点击图集
	adb -s $devices shell input tap 630 1375  #点击视频
	adb -s $devices shell input tap 100 200 #点击返回
	adb -s $devices shell input tap 240 340  #点击照片
	echo $i
done
