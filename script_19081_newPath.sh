devices="1aad6ef0" 
runningTimes="1000"


for((i=0;i<$runningTimes;i++)); do   #�ܴ���=runningTimes��

	adb -s $devices shell input tap 200 490  #����༭
	sleep 0.1
	adb -s $devices shell input tap 100 200 #������
	sleep 0.1
	echo $i
done
