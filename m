From: "Brian Bonner" <bkbonner@gmail.com>
Subject: Mounting array was read write for about 3 minutes, then Read-only file system error
Date: Thu, 6 Jul 2006 22:32:08 -0400
Message-ID: <e0904ff40607061932l3b1d7849v43ed568aa4fceea8@mail.gmail.com>
Reply-To: bkbonner@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I created a raid1 array using /dev/disk/by-id with (2) 250GB USB 2.0
Drives.  It was working for about 2 minutes until I tried to copy a
directory tree from one drive to the array and then cancelled it
midstream.  After cancelling the copy, when I list the contents of the
directory it doesn't show anything there.

When I try to create a file, I get the following error msg:

[root@app1 ~]# cd /mnt/usb250
[root@app1 usb250]# ls
lost+found
[root@app1 usb250]# touch test.txt
touch: cannot touch `test.txt': Read-only file system
[root@app1 usb250]#

even though when I show the mounts, it displays:

[root@app1 ~]# mount -l
/dev/mapper/VolGroup01-LogVol00 on / type ext3 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/md0 on /boot type ext3 (rw)
tmpfs on /dev/shm type tmpfs (rw)
/dev/mapper/VolGroup01-LogVol02 on /home type ext3 (rw)
/dev/mapper/VolGroup01-LogVol01 on /tmp type ext3 (rw)
/dev/mapper/VolGroup01-LogVol03 on /usr type ext3 (rw)
/dev/mapper/VolGroup01-LogVol04 on /var type ext3 (rw)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
automount(pid2195) on /net type autofs (rw,fd=4,pgrp=2195,minproto=2,maxproto=4)

/dev/md3 on /mnt/usb250 type ext3 (rw)

Here's my mdadm.conf file, and the details on the array.

Does anyone have any thoughts on why this is acting this way?  I'm stumped.

Thanks,

Brian

/etc/mdadm.conf

DEVICE partitions /dev/disk/by-id/usb-ST325082_3A_000DCC /dev/disk/by-id/usb-ST3
25082_3A_001A41
MAILADDR root
ARRAY /dev/md3 level=raid1 num-devices=2 devices=/dev/disk/by-id/usb-ST325082_3A
_000DCC,/dev/disk/by-id/usb-ST325082_3A_001A41
ARRAY /dev/md2 level=raid1 num-devices=2 uuid=a94ec909:c3c5386b:5e8b311e:6eea3fb
4
ARRAY /dev/md0 level=raid1 num-devices=2 uuid=11118406:0792eb6b:aa28aac9:6217b69
5
ARRAY /dev/md1 level=raid1 num-devices=2 uuid=0e5beeb3:49ffc108:4b09e081:5966b20
c



[root@app1 ~]# mdadm --detail /dev/md3
/dev/md3:
        Version : 00.90.03
  Creation Time : Wed Jul  5 06:28:18 2006
     Raid Level : raid1
     Array Size : 244198464 (232.89 GiB 250.06 GB)
    Device Size : 244198464 (232.89 GiB 250.06 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Thu Jul  6 09:07:44 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : ff7d7a3c:a458efba:16a174b4:bd4b002e
         Events : 0.70

    Number   Major   Minor   RaidDevice State
       0       8       48        0      active sync   /dev/sdd
       1       8       64        1      active sync   /dev/sde
[root@app1 ~]#

[root@app1 ~]# more /proc/mdstat
Personalities : [raid1]
md3 : active raid1 sdd[0] sde[1]
      244198464 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] sda1[0]
      200704 blocks [2/2] [UU]

md1 : active raid1 sdb2[1] sda2[0]
      2096384 blocks [2/2] [UU]

md2 : active raid1 sdb3[1] sda3[0]
      75826688 blocks [2/2] [UU]

unused devices: <none>
