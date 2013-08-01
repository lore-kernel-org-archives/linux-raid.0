From: Albert Pauw <albert.pauw@gmail.com>
Subject: Bugreport ddf rebuild problems
Date: Thu, 01 Aug 2013 21:30:19 +0200
Message-ID: <51FAB74B.4030200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Now I've got it working, I checked a simple rebuild test with a ddf 
container, containing two raidsets (raid 1 and raid 5).

Having 6 loopback devices of 512 MB each I opened in a separate screen 
this to monitor what happens:

while true; do clear; cat /proc/mdstat ; sleep 1; done

Now are here my commands, en watch the rebuild.

[root@moonlight ~]# mdadm --zero-superblock /dev/loop[1-6]
[root@moonlight ~]# mdadm -CR /dev/md127 -e ddf -l container -n 5 
/dev/loop[1-5]
mdadm: /dev/loop1 appears to contain an ext2fs file system
        size=153600K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/loop2 appears to contain an ext2fs file system
        size=153600K  mtime=Thu Jan  1 01:00:00 1970
mdadm: container /dev/md127 prepared.
[root@moonlight ~]# mdadm -CR /dev/md0 -l raid1 -n 2 /dev/md0
mdadm: You haven't given enough devices (real or missing) to create this 
array
[root@moonlight ~]# mdadm -CR /dev/md0 -l raid1 -n 2 /dev/md127
mdadm: array /dev/md0 started.
[root@moonlight ~]# mdadm -CR /dev/md1 -l raid5 -n 3 /dev/md127
mdadm: array /dev/md1 started.
[root@moonlight ~]# man mdadm
Formatting page, please wait...
[root@moonlight ~]# mdadm -f /dev/md0 /dev/loop4
mdadm: set /dev/loop4 faulty in /dev/md0
[root@moonlight ~]# mdadm -f /dev/md1 /dev/loop2
mdadm: set /dev/loop2 faulty in /dev/md1
[root@moonlight ~]# mdadm --add /dev/md127 /dev/loop6
mdadm: added /dev/loop6


What should happen is that one of the raid sets get rebuild by the added 
spare, however
  the one raid set gets the spare disk (which is good) and starts 
rebuilding, the second one, well have a look:

root@moonlight ~]# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md1 : active raid5 loop6[3] loop1[2] loop3[0]
       958464 blocks super external:/md127/1 level 5, 512k chunk, 
algorithm 2 [3/3] [UUU]

md0 : active raid1 loop3[3](S) loop2[2] loop5[0]
       479232 blocks super external:/md127/0 [2/2] [UU]

md127 : inactive loop6[5](S) loop5[4](S) loop4[3](S) loop3[2](S) 
loop2[1](S) loop1[0](S)
       196608 blocks super external:ddf


Effectively a rebuild raid 1 set with three disks (md0) including a 
spare, using a failed disk.

Looks like something is going wrong here.

Albert


