From: Victor Balakine <victor.balakine@ubc.ca>
Subject: Adding a disk to RAID0
Date: Tue, 28 Feb 2012 15:34:43 -0800
Message-ID: <4F4D6493.3030300@ubc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am trying to add another disk to RAID0 and this functionality appears 
to be broken.
First I create a RAID0 array:
#mdadm --create /dev/md0 --level=0 --raid-devices=1 --force /dev/xvda2
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

So far everything works fine. Then I add another disk to it:
#mdadm --grow /dev/md0 --raid-devices=2 --add /dev/xvda3 
--backup-file=/backup-md0
mdadm: level of /dev/md0 changed to raid4
mdadm: added /dev/xvda3
mdadm: Need to backup 1024K of critical section..

This is what I see in /var/log/messages
Feb 28 15:03:30 storage kernel: [ 1420.174022] md: bind<xvda2>
Feb 28 15:03:30 storage kernel: [ 1420.209167] md: raid0 personality 
registered for level 0
Feb 28 15:03:30 storage kernel: [ 1420.209818] bio: create slab <bio-1> at 1
Feb 28 15:03:30 storage kernel: [ 1420.209832] md/raid0:md0: looking at 
xvda2
Feb 28 15:03:30 storage kernel: [ 1420.209837] md/raid0:md0:   comparing 
xvda2(8386560) with xvda2(8386560)
Feb 28 15:03:30 storage kernel: [ 1420.209844] md/raid0:md0:   END
Feb 28 15:03:30 storage kernel: [ 1420.209851] md/raid0:md0:   ==> UNIQUE
Feb 28 15:03:30 storage kernel: [ 1420.209856] md/raid0:md0: 1 zones
Feb 28 15:03:30 storage kernel: [ 1420.209859] md/raid0:md0: FINAL 1 zones
Feb 28 15:03:30 storage kernel: [ 1420.209866] md/raid0:md0: done.
Feb 28 15:03:30 storage kernel: [ 1420.209870] md/raid0:md0: md_size is 
8386560 sectors.
Feb 28 15:03:30 storage kernel: [ 1420.209875] ******* md0 configuration 
*********
Feb 28 15:03:30 storage kernel: [ 1420.209879] zone0=[xvda2/]
Feb 28 15:03:30 storage kernel: [ 1420.209885]         zone offset=0kb 
device offset=0kb size=4193280kb
Feb 28 15:03:30 storage kernel: [ 1420.209902] 
**********************************
Feb 28 15:03:30 storage kernel: [ 1420.209903]
Feb 28 15:03:30 storage kernel: [ 1420.209919] md0: detected capacity 
change from 0 to 4293918720
Feb 28 15:03:30 storage kernel: [ 1420.223968]  md0: p1
...
Feb 28 15:04:01 storage kernel: [ 1450.783016] async_tx: api initialized 
(async)
Feb 28 15:04:01 storage kernel: [ 1450.796912] xor: automatically using 
best checksumming function: generic_sse
Feb 28 15:04:01 storage kernel: [ 1450.816012]    generic_sse:  9509.000 
MB/sec
Feb 28 15:04:01 storage kernel: [ 1450.816021] xor: using function: 
generic_sse (9509.000 MB/sec)
Feb 28 15:04:01 storage kernel: [ 1450.912021] raid6: int64x1   1888 MB/s
Feb 28 15:04:01 storage kernel: [ 1450.980013] raid6: int64x2   2707 MB/s
Feb 28 15:04:01 storage kernel: [ 1451.048025] raid6: int64x4   2073 MB/s
Feb 28 15:04:01 storage kernel: [ 1451.116039] raid6: int64x8   2010 MB/s
Feb 28 15:04:01 storage kernel: [ 1451.184017] raid6: sse2x1    4764 MB/s
Feb 28 15:04:01 storage kernel: [ 1451.252018] raid6: sse2x2    5170 MB/s
Feb 28 15:04:01 storage kernel: [ 1451.320016] raid6: sse2x4    7548 MB/s
Feb 28 15:04:01 storage kernel: [ 1451.320025] raid6: using algorithm 
sse2x4 (7548 MB/s)
Feb 28 15:04:01 storage kernel: [ 1451.330136] md: raid6 personality 
registered for level 6
Feb 28 15:04:01 storage kernel: [ 1451.330145] md: raid5 personality 
registered for level 5
Feb 28 15:04:01 storage kernel: [ 1451.330149] md: raid4 personality 
registered for level 4
Feb 28 15:04:01 storage kernel: [ 1451.330662] md/raid:md0: device xvda2 
operational as raid disk 0
Feb 28 15:04:01 storage kernel: [ 1451.330820] md/raid:md0: allocated 2176kB
Feb 28 15:04:01 storage kernel: [ 1451.330869] md/raid:md0: raid level 4 
active with 1 out of 2 devices, algorithm 5
Feb 28 15:04:01 storage kernel: [ 1451.330874] RAID conf printout:
Feb 28 15:04:01 storage kernel: [ 1451.330876]  --- level:4 rd:2 wd:1
Feb 28 15:04:01 storage kernel: [ 1451.330878]  disk 0, o:1, dev:xvda2
Feb 28 15:04:01 storage kernel: [ 1451.417995] md: bind<xvda3>
Feb 28 15:04:01 storage kernel: [ 1451.616399] RAID conf printout:
Feb 28 15:04:01 storage kernel: [ 1451.616404]  --- level:4 rd:3 wd:2
Feb 28 15:04:01 storage kernel: [ 1451.616408]  disk 0, o:1, dev:xvda2
Feb 28 15:04:01 storage kernel: [ 1451.616411]  disk 1, o:1, dev:xvda3
Feb 28 15:04:01 storage kernel: [ 1451.619054] md: reshape of RAID array md0
Feb 28 15:04:01 storage kernel: [ 1451.619066] md: minimum _guaranteed_  
speed: 1000 KB/sec/disk.
Feb 28 15:04:01 storage kernel: [ 1451.619069] md: using maximum 
available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
Feb 28 15:04:01 storage kernel: [ 1451.619075] md: using 128k window, 
over a total of 4193280k.
Feb 28 15:05:02 storage udevd[280]: timeout '/sbin/blkid -o udev -p 
/dev/md0'
Feb 28 15:05:03 storage udevd[280]: timeout: killing '/sbin/blkid -o 
udev -p /dev/md0' [1829]
Feb 28 15:05:04 storage udevd[280]: timeout: killing '/sbin/blkid -o 
udev -p /dev/md0' [1829]
Feb 28 15:05:05 storage udevd[280]: timeout: killing '/sbin/blkid -o 
udev -p /dev/md0' [1829]

And then it just goes on forever. md0_raid0 process stays at 100% CPU load.
# ps -ef | grep md0
root      7268     2 99 09:34 ?        05:53:00 [md0_raid0]
root      7270     2  0 09:34 ?        00:00:00 [md0_reshape]
root      7271     1  0 09:34 pts/0    00:00:00 mdadm --grow /dev/md0 
--raid-devices=2 --add /dev/sdc1 --backup-file=/backup-md0

# cat /proc/mdstat
Personalities : [raid0] [raid6] [raid5] [raid4]
md0 : active raid4 xvda3[2] xvda2[0]
       4193280 blocks super 1.2 level 4, 512k chunk, algorithm 5 [3/1] [U__]
         resync=DELAYED

unused devices: <none>

# mdadm --version
mdadm - v3.2.2 - 17th June 2011
# uname -a
Linux storage 3.1.9-1.4-xen #1 SMP Fri Jan 27 08:55:10 UTC 2012 
(efb5ff4) x86_64 x86_64 x86_64 GNU/Linux

It's OpenSUSE 12.1 with all the latest updates running in XEN that I 
created to reproduce the problem. The actual server is running the same 
version of OpenSUSE (Linux san1 3.1.9-1.4-desktop #1 SMP PREEMPT Fri Jan 
27 08:55:10 UTC 2012 (efb5ff4) x86_64 x86_64 x86_64 GNU/Linux) on a 
hardware server. If you need any more information I can easily get it 
since it's a VM and the problem is easily reproducible.

Victor
