From: Serge Bartosh <sb@navitel.su>
Subject: Monitor new badblocks
Date: Tue, 24 Mar 2015 20:30:41 +0300
Message-ID: <55119F41.1060400@navitel.su>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

since md started to support of BadBlockList(Log) I'm trying to find 
answer to question:
- is there a possibility to get alarm when md discovers new bad blocks?

Please correct me if I'm wrong but I suspect that answer will be "no".

According to man page possible Events are:
DeviceDisappeared, RebuildStarted, RebuildNN, RebuildFinished, Fail, 
FailSpare, SpareActive, NewArray, DegradedArray, MoveSpare, 
SparesMissing, TestMessage

There is no special event for new badblocks discover and I've checked 
today that bad blocks existence is not the reason to mark device "Fail".
I've made experiments with dmsetup simulating "bad surface": even when 
new disk containing 90 percents of unusable sectors is added to array md 
makes and finishes recover without kicking disk out. Last event is 
SpareActive. Syslog does not contain lines about md found bad blocks on 
new disk. Array is clean and active.

I understand that manual command "mdadm --examine-badblocks" reveals 
such hidden problem.
But is there a way to make "mdadm --monitor" to warn about bad blocks?



PS. System is Debian Jessie RC1

root@linux-test-vb:~# mdadm --version
mdadm - v3.3.2 - 21st August 2014
root@linux-test-vb:~# uname -a
Linux linux-test-vb 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt7-1 
(2015-03-01) x86_64 GNU/Linux
root@linux-test-vb:~# cat /etc/debian_version
8.0


PPS. Script used for experiments:
-----8<-----
#!/bin/bash

MDNAME=/dev/md999
DISKSZ=$((64*1024*1024))

#cleanup
echo cleanup
mdadm --stop $MDNAME
dmsetup remove bad_disk4

echo making files and loops
for i in `seq 1 4` ; do
     losetup -d /dev/loop$i;
     dd if=/dev/zero of=f$i bs=1M count=$((DISKSZ/1024/1024))
     losetup /dev/loop$i f$i;
done

echo
echo making faulty disk4 with bb somewhere in the middle...

DEV=/dev/loop4
SECTORS=`blockdev --getsz $DEV` #size in sectors
SECTSZ=`blockdev --getss $DEV` #size of sector

BBPOS=$((SECTORS/2)) #bad block position
BBLEN=$((SECTORS/4)) #bad block region length
echo badblock region from $BBPOS to $((BBPOS+BBLEN)) of $SECTORS
dmsetup create bad_disk4 << EOF
   0         $BBPOS   linear /dev/loop4 0
   $BBPOS    $BBLEN   error
   $((BBPOS+BBLEN)) $((SECTORS-BBLEN-BBPOS)) linear /dev/loop4 
$((BBPOS+BBLEN))
EOF

echo
echo making initially degraded raid6
mdadm --create $MDNAME -l 6 -n 4 /dev/loop[123] missing
echo waiting for recover finish...
while [ `cat /sys/block/md999/md/sync_action` != 'idle' ]
do
         sleep 1
done
echo adding bb disk
mdadm --add $MDNAME /dev/mapper/bad_disk4
-----8<-----

-- 
WBR,
Serge Bartosh

