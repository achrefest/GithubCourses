rm -f test.txt
rm -f testt.txt
#rm -f testtt.txt
touch test.txt
touch testt.txt
#touch testtt.txt
route >> test.txt  
grep -E "(Destination)|(Gateway)" test.txt >> testt.txt
WordCount=$(wc -l testt.txt | tr -dc '0-9')
#echo $WordCount
#echo $WordCount
line=""
line2=""
#echo $WordCount
t=8
for ((i=1;i<=$WordCount;i++));do
	#echo 1
	#echo "$WordCount"; 
	line=$(head -$i testt.txt | tail -1)
	line=$line"</br>"
	echo $line
#;line1=`"$line" `;echo "$line2"; 
done
rm -f test.txt
rm -f testt.txt
