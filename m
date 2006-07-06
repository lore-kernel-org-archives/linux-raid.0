From: Luca Berra <bluca@comedia.it>
Subject: issue with internal bitmaps
Date: Thu, 6 Jul 2006 16:12:07 +0200
Message-ID: <20060706141207.GC21642@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hello, i just realized that internal bitmaps do not seem to work
anymore.

kernel 2.6.17
mdadm 2.5.2

[root@localhost ~]# mdadm --create --level=1 -n 2 -e 1 --bitmap=internal /dev/md100 /dev/sda1 /dev/sda2
mdadm: array /dev/md100 started.

... wait awhile ...

[root@localhost ~]# cat /proc/mdstat
Personalities : [raid1]
md100 : active raid1 sda2[1] sda1[0]
      1000424 blocks super 1.0 [2/2] [UU]
      bitmap: 4/4 pages [16KB], 128KB chunk

unused devices: <none>
[root@localhost ~]# mdadm -X /dev/md100
        Filename : /dev/md100
           Magic : 00000000
mdadm: invalid bitmap magic 0x0, the bitmap file appears to be corrupted
         Version : 0
mdadm: unknown bitmap version 0, either the bitmap file is corrupted or you need to upgrade your tools

[root@localhost ~]# cat /proc/mdstat
Personalities : [raid1]
md100 : active raid1 sda2[1] sda1[0]
      1000424 blocks super 1.0 [2/2] [UU]
      bitmap: 0/4 pages [0KB], 128KB chunk

unused devices: <none>

[root@localhost ~]# mdadm -D /dev/md100
/dev/md100:
        Version : 01.00.03
  Creation Time : Thu Jul  6 16:05:10 2006
     Raid Level : raid1
     Array Size : 1000424 (977.14 MiB 1024.43 MB)
    Device Size : 1000424 (977.14 MiB 1024.43 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 100
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Jul  6 16:07:11 2006
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : 100
           UUID : 60cd0dcb:fde52377:699453f7:da96b9d4
         Events : 1

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8        2        1      active sync   /dev/sda2



-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
