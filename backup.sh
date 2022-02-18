#!/bin/sh

start=`date`

mount /dev/sdb1 /back

cd /back
file=$(date +"%d-%m-%Y")


one_day=$(date -d "3 days ago" +%d-%m-%Y)
for f in [0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]; do
  [ -d "$f" ] || continue
  [ "$f" != "$one_day" ] && sudo rm -rf "$f" && echo "$f" && continue
  [ "$f" == "$one_day" ] && echo "Leaving $f"
done

mkdir -p /back/$file

rsync -av --stats --delete 172.16.0.140::home /back/$file/home
rsync -av --stats --delete 172.16.0.140::var /back/$file/var
rsync -av --stats --delete 172.16.0.140::root /back/$file/root
rsync -av --stats --delete 172.16.0.140::etc /back/$file/etc
rsync -av --stats --delete 172.16.0.140::local /back/$file/local
rsync -av --stats --delete 172.16.0.140::DATA /back/$file/DATA

df -Th
echo =============back===============
cd /back ; du -shc * > du.txt 
cd ~
end=`date`

umount /back

echo "Start time: " $start
echo "End time: " $end
