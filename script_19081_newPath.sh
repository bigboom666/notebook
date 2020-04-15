devices="1aad6ef0" 
runningTimes="1000"


for((i=0;i<$runningTimes;i++)); do   #总次数=runningTimes次

	adb -s $devices shell input tap 200 490  #点击编辑
	sleep 0.1
	adb -s $devices shell input tap 100 200 #点击美顏
	sleep 0.1
	echo $i
done
