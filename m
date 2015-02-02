From: alpha lin <lin.alpha@gmail.com>
Subject: Fwd: update mdadm version to 3.3.2 in Centos 6.4
Date: Tue, 3 Feb 2015 06:26:44 +0800
Message-ID: <CAKtQofvwqzOUiYV0R-E=seF7DyP3w-ytO9oQ-1jw3NjtXq500Q@mail.gmail.com>
References: <CAKtQoftv3uf-Y1va7QV=qFiJZO0CdSJ7QtfHj7P1Mg5oyj0fRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKtQoftv3uf-Y1va7QV=qFiJZO0CdSJ7QtfHj7P1Mg5oyj0fRw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Forgot to mention that my Centos 6.4 x64 system has upgrade kernel to 3.16.0.
So the failure is base on kernel 3.16.0


---------- Forwarded message ----------
From: alpha lin <lin.alpha@gmail.com>
Date: Mon, Feb 2, 2015 at 10:30 PM
Subject: update mdadm version to 3.3.2 in Centos 6.4
To: linux-raid@vger.kernel.org


Hi All,

    I would like to know the possibility of update the mdadm package
from 3.2.5 to 3.3.2 in Redhat Centos 6.4 x64 system.
    The problem I have is I found that I can create a raid volume
without any problem. But when reboot the system. The md volume become
inactive.
    Below is my step:
    1. Check out mdadm package from the github.
    2. unzip the mdadm package and execute "make" and "make install"
    3. reboot.
    4. after system reboot, run mdadm to create a imsm RAID Volume.
   [root@localhost rules.d]# mdadm --version
    mdadm - v3.3.2 - 21st August 2014

[root@localhost rules.d]# mdadm --detail-platform
       Platform : Intel(R) Rapid Storage Technology enterprise
        Version : 3.7.0.1049
    RAID Levels : raid0 raid1 raid10 raid5
    Chunk Sizes : 4k 8k 16k 32k 64k 128k
    2TB volumes : supported
      2TB disks : supported
      Max Disks : 6
    Max Volumes : 2 per array, 4 per controller
 I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)
          Port2 : /dev/sda (3JV9BZRP)
          Port3 : /dev/sdb (1346095A3033)
          Port4 : /dev/sdc (1346095A2FEC)
          Port5 : /dev/sdd (1346095A3042)
          Port0 : - no device attached -
          Port1 : - no device attached -

[root@localhost rules.d]# mdadm -C /dev/md0 /dev/sd[b-d] -n 3 -e imsm
mdadm: /dev/sdb appears to be part of a raid array:
       level=container devices=0 ctime=Thu Jan  1 08:00:00 1970
mdadm: /dev/sdc appears to be part of a raid array:
       level=container devices=0 ctime=Thu Jan  1 08:00:00 1970
mdadm: /dev/sdd appears to be part of a raid array:
       level=container devices=0 ctime=Thu Jan  1 08:00:00 1970
Continue creating array? y
mdadm: container /dev/md0 prepared.

[root@localhost rules.d]# mdadm -C /dev/md/Volume0 /dev/md0 -n 3 -l 5
mdadm: array /dev/md/Volume0 started.

5. check raid stat
[root@localhost rules.d]# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md127 : active raid5 sdb[2] sdd[1] sdc[0]
      234434560 blocks super external:/md0/0 level 5, 128k chunk,
algorithm 0 [3/3] [UUU]
      [>....................]  resync =  0.8% (1027072/117217664)
finish=18.8min speed=102707K/sec

md0 : inactive sdd[2](S) sdc[1](S) sdb[0](S)
      3315 blocks super external:imsm

unused devices: <none>
[root@localhost rules.d]#
[root@localhost dev]# mdmon md0
mdmon: md0 already managed

6. reboot the system again.  check the md again.
[root@localhost Desktop]# cat /proc/mdstat
Personalities :
md125 : inactive sdi[1](S) sdh[0](S)
      6306 blocks super external:imsm

md126 : inactive sdg[0](S)
      3153 blocks super external:imsm

md127 : inactive sdg[0]
      117217664 blocks super external:/md126/0

unused devices: <none>
[root@localhost Desktop]#

I found the device label change from sd[a-d] to sd[f-i]
[root@localhost rules.d]# mdadm --detail-platform
       Platform : Intel(R) Rapid Storage Technology enterprise
        Version : 3.7.0.1049
    RAID Levels : raid0 raid1 raid10 raid5
    Chunk Sizes : 4k 8k 16k 32k 64k 128k
    2TB volumes : supported
      2TB disks : supported
      Max Disks : 6
    Max Volumes : 2 per array, 4 per controller
 I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)
          Port2 : /dev/sdf (3JV9BZRP)
          Port3 : /dev/sdg (1346095A3033)
          Port4 : /dev/sdh (1346095A2FEC)
          Port5 : /dev/sdi (1346095A3042)
          Port0 : - no device attached -
          Port1 : - no device attached -

Any idea? Does anything missing in my setup ?
