From: Fredrik Pettersson <freppe@deimos.nu>
Subject: Why is my raid 1 boot/root not working with autodetect?
Date: Wed, 10 Jun 2009 18:58:43 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0906101828150.10333@deimos.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

A couple of years ago I converted my system to run off a software raid 1 
rather than from a single disk. On the dual 250GB disks I have set up two 
partitions:

-----
Disk /dev/sdb: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1        1246    10008463+  fd  Linux raid 
autodetect
/dev/sdb2            1247       30401   234187537+  fd  Linux raid 
autodetect
-----

sdb1/sdc1 is a raid 1 called /dev/md0, sdb2/sdc2 is a partitionable raid 1 
called /dev/md_d0, partitioned and used for usr, var & home.

Partitions are set up as follows:

-----
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md0               9851232    236736   9114080   3% /
udev                     10240        76     10164   1% /dev
/dev/md_d0p1          29529044   8936164  19092880  32% /usr
/dev/md_d0p2          19685916  10876740   7809176  59% /var
/dev/md_d0p3           9842852   3453940   5888912  37% /home
none                    517192         0    517192   0% /dev/shm
-----

At the time when I set this up I found that the only way for me to get it 
to boot properly was to have the following kernel options in my grub.conf:

raid=noautodetect md=0,/dev/sdb1,/dev/sdc1 md=d0,/dev/sdb2,/dev/sdc2

As it was some time ago I don't recall exactly why that had to be there, 
but it doesn't work without having those kernel options. I've just started 
thinking of adding more software raid disks to my system and figured it 
would be nice if autodetect would work for me so I would prefer to get rid 
of those options. If I remove the "raid=noautodetect" bit, or all of it, 
then the system fails to boot properly. From what I can see on the console 
it appears to find the md_d0 raid and partitions just fine, but not the 
/dev/md0 raid which obviously causes the boot to fail. So my question now 
is, why is autodetect not working properly and what can I do to fix it?

I'm sure there is more information I should have provided here, please ask 
if anything is missing. Here is my /proc/mdstat and the full entry from 
grub.conf:

-----
# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
md_d0 : active raid1 sdc2[1] sdb2[0]
       234187456 blocks [2/2] [UU]

md0 : active raid1 sdc1[1] sdb1[0]
       10008384 blocks [2/2] [UU]

unused devices: <none>
-----

-----
title=Gentoo Linux 2.6.29-gentoo-r5
         kernel (hd0,0)/boot/kernel-2.6.29-gentoo-r5 root=/dev/md0 
raid=noautodetect md=0,/dev/sdb1,/dev/sdc1 md=d0,/dev/sdb2,/dev/sdc2
         savedefault fallback
-----

Best regards, and thanks in advance for any answers.

/Fredrik Pettersson
