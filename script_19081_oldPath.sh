devices="1aad6ef0" 
runningTimes="1000"


for((i=0;i<$runningTimes;i++)); do   #�ܴ���=runningTimes��

	
	adb -s $devices shell input tap 540 340  #���ͼ��
	adb -s $devices shell input tap 630 1375  #�����Ƶ
	adb -s $devices shell input tap 100 200 #�������
	adb -s $devices shell input tap 240 340  #�����Ƭ
	echo $i
done
