cat default.xml |grep "<project"| \
while read line; do
       	pjct=${line#*name=\"}
       	pjct=${pjct%%\"*}
	echo $pjct 
done
