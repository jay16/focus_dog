timestamp=$(date +"%y/%m/%d-%H:%M:%S")

cd /mnt/work/etl/focus_dog
/usr/bin/git init
/usr/bin/git add -A .
/usr/bin/git commit -a -m "${timestamp}"
/usr/bin/git push origin master