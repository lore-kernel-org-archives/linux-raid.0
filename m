From: Mark Knecht <markknecht@gmail.com>
Subject: New machine, new RAID, wrong device name...
Date: Mon, 21 Feb 2011 11:59:06 -0800
Message-ID: <AANLkTin=E7m==Q0NASXv72jiB0h3XJhZ4-vsxCS6CvJU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've got a new laptop that has two hard drives in it and I've chosen
to use RAID1 on it. The Gentoo install is complete but when I reboot
the kernel doesn't find the RAID and I hang without syncing.

During the Gentoo install from a CD the machine is called (apparently)
"livecd". To build the RAID initially I wanted it to be /dev/md3 so I
used

livecd ~ # mknod /dev/md3 b 9 3
livecd ~ # mdadm --create /dev/md3 --level=1 --raid-devices=2
/dev/sda3 /dev/sdb3
livecd ~ # mke2fs -j /dev/md3

and everything went fine.

However once I've rebooted using the CD, and even though the machine
is once again called livecd the RAID is now called /dev/md127. I
assume, but don't know for sure, that something similar is happening
when I boot the actual installation, mdadm gives the RAID a different
name and it's likely not found by my new environment.

What's the right solution to changing the RAID naming in the
superblock so that the laptop finds it as local to 'laptop1' and
mounts it according the fstab?

I understand that I can probably put the UUID in the mdadm config
file, and I will, but before I do I wanted to cross this threshold and
figure out the right way to do it automatically.

Thanks,
Mark


livecd ~ # mdadm --detail /dev/md127
/dev/md127:
        Version : 1.2
  Creation Time : Wed Feb 16 16:03:29 2011
     Raid Level : raid1
     Array Size : 343758245 (327.83 GiB 352.01 GB)
  Used Dev Size : 343758245 (327.83 GiB 352.01 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Thu Feb 17 19:42:36 2011
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : livecd:3  (local to host livecd)
           UUID : f75493a8:1189516e:0f192f04:e21fbe28
         Events : 17

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
livecd ~ # mdadm --examine /dev/sda3
/dev/sda3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : f75493a8:1189516e:0f192f04:e21fbe28
           Name : livecd:3  (local to host livecd)
  Creation Time : Wed Feb 16 16:03:29 2011
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 687516763 (327.83 GiB 352.01 GB)
     Array Size : 687516490 (327.83 GiB 352.01 GB)
  Used Dev Size : 687516490 (327.83 GiB 352.01 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4430631f:454150f1:903a86cc:9d2c034c

    Update Time : Thu Feb 17 19:42:36 2011
       Checksum : 9adbdc7f - correct
         Events : 17


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)
livecd ~ #
