From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Does mdadm --create harm existing data?
Date: Sat, 3 Dec 2005 15:30:32 -0800
Message-ID: <200512032330.jB3NUWX9017265@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In mail.linux.raid I write:

>Other than the superblocks, does 'mdadm --create' harm existing data?

It would seem not according to this test:

------------------------------------------------------------

#!/bin/sh
# Create a test raid6 array, then create it again forcing the devices
# into a different order. Verify that the devices themselves (except the superblocks)
# are not altered

num_devices=4
device_size=2 # MByte
loop_start=10
md=/dev/md9
dir=/tmp/raidtest

test -d $dir || mkdir -v $dir
cd $dir

checksum() {
	# dont check superblock at end
	echo $1 `dd if=$1 bs=1024k count=$(($device_size-1)) 2>/dev/null | sum`
}

devs=""
reverse_devs=""
files=""
i=0
while test $i -lt $num_devices; do
  file=dev$i
  loop=/dev/loop$(($loop_start+$i))
  if test ! -f $file; then
    dd if=/dev/urandom of=$file bs=1024k count=$device_size 2>/dev/null
    losetup -d $loop
    losetup $loop $file
  fi
  checksum $file
  devs="$devs $loop"
  reverse_devs="$loop $reverse_devs"
  files="$files $file"
  i=$(($i+1))
done

stop() {
	mdadm --stop $md
}

create() {
	stop
	exe="mdadm -C --force -c 128 -l raid6 -n $(($num_devices+2)) -a $md $* missing missing"
	echo $exe
	$exe
	grep `basename $md` /proc/mdstat
	sum $md
	stop
}

create $devs
create $reverse_devs

for d in $devs; do
  checksum $d
done

----------------------------------------------------------------------

Output:

athlon:aab > sudo raidtest
dev0 23143 1024
dev1 38751 1024
dev2 30484 1024
dev3 05590 1024
mdadm -C --force -c 128 -l raid6 -n 6 -a /dev/md9 /dev/loop10 /dev/loop11 /dev/loop12 /dev/loop13 missing missing
mdadm: /dev/loop10 appears to be part of a raid array:
    level=raid6 devices=6 ctime=Sat Dec  3 15:24:15 2005
mdadm: /dev/loop11 appears to be part of a raid array:
    level=raid6 devices=6 ctime=Sat Dec  3 15:24:15 2005
mdadm: /dev/loop12 appears to be part of a raid array:
    level=raid6 devices=6 ctime=Sat Dec  3 15:24:15 2005
mdadm: /dev/loop13 appears to be part of a raid array:
    level=raid6 devices=6 ctime=Sat Dec  3 15:24:15 2005
Continue creating array? y
mdadm: array /dev/md9 started.
md9 : active raid6 loop13[3] loop12[2] loop11[1] loop10[0]
63189  7680
mdadm -C --force -c 128 -l raid6 -n 6 -a /dev/md9 /dev/loop13 /dev/loop12 /dev/loop11 /dev/loop10 missing missing
mdadm: /dev/loop13 appears to be part of a raid array:
    level=raid6 devices=6 ctime=Sat Dec  3 15:29:20 2005
mdadm: /dev/loop12 appears to be part of a raid array:
    level=raid6 devices=6 ctime=Sat Dec  3 15:29:20 2005
mdadm: /dev/loop11 appears to be part of a raid array:
    level=raid6 devices=6 ctime=Sat Dec  3 15:29:20 2005
mdadm: /dev/loop10 appears to be part of a raid array:
    level=raid6 devices=6 ctime=Sat Dec  3 15:29:20 2005
Continue creating array? y
mdadm: array /dev/md9 started.
md9 : active raid6 loop10[3] loop11[2] loop12[1] loop13[0]
58879  7680
/dev/loop10 23143 1024
/dev/loop11 38751 1024
/dev/loop12 30484 1024
/dev/loop13 05590 1024

