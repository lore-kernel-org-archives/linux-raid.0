From: Albert Pauw <albert.pauw@gmail.com>
Subject: Bugreport: mdmon will not start with latest git version when using
 ddf container
Date: Wed, 31 Jul 2013 20:14:18 +0200
Message-ID: <51F953FA.5000400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Seems mdmon will not start when I create a ddf container with raid 
devices therein:

I am using this version from git:

mdadm - v3.3-rc2-20-gd81cc6a - 31st July 2013

on Centos 6.4, 2.6.32-358.14.1.el6.x86_64

I am using 5 loop devices of 512 MB each for disks.
I created a container with 5 disks:

mdadm -CR /dev/md127 -e ddf -l container -n 5 /dev/loop[1-5]

[root@moonlight ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1]
md127 : inactive loop5[4](S) loop4[3](S) loop3[2](S) loop2[1](S) loop1[0](S)
       163840 blocks super external:ddf

unused devices: <none>

And created two raid sets in it, one with three disks in raid 5, the 
other a raid 1

[root@moonlight ~]# mdadm -CR /dev/md1 -l raid5 -n 3 /dev/md127
mdadm: array /dev/md1 started.
mdadm: failed to launch mdmon. Array remains readonly
[root@moonlight ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1]
md1 : active (read-only) raid5 loop1[2] loop2[1] loop3[0]
       958464 blocks super external:/md127/1 level 5, 512k chunk, 
algorithm 2 [3/3] [UUU]
           resync=PENDING

md0 : active (read-only) raid1 loop4[1] loop5[0]
       479232 blocks super external:/md127/0 [2/2] [UU]
           resync=PENDING

md127 : inactive loop5[4](S) loop4[3](S) loop3[2](S) loop2[1](S) loop1[0](S)
       163840 blocks super external:ddf

unused devices: <none>

And adding another one, raid5 in my case, gives the same result for the 
next /dev/md device.

Unfortunately, they stay readonly, as mdmon won't start, so mdadm 
--readwrite /dev/md0, etc, won't work.

However, when I create these raid devices directly on top of the 
/dev/loop[1-5] devices, without using a ddf container, it works as 
advertised and the devices get (re)build/resynced.



Regards,

Albert


