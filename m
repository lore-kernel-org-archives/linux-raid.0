From: Sachin Garg <sgarg.bugreporter@gmail.com>
Subject: Desperate: mdadm fails to assemble raid saying devices are busy.
Date: Sat, 21 Sep 2013 10:32:05 -0400
Message-ID: <523DADE5.8050604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I am on Arch Linux. I have a 4 device RAID 5 of which 1 device is no longer
working. I am unable to assemble the raid.

The active devices are:/dev/sda2, /dev/sdb1, /dev/sdc2

The errors I get are like:

# mdadm -Avf /dev/md127
mdadm: looking for devices for /dev/md127
mdadm: no RAID superblock on /dev/dm-6
mdadm: no RAID superblock on /dev/dm-5
mdadm: no RAID superblock on /dev/dm-4
mdadm: no RAID superblock on /dev/dm-3
mdadm: no RAID superblock on /dev/dm-2
mdadm: no RAID superblock on /dev/dm-1
mdadm: no RAID superblock on /dev/dm-0
mdadm: /dev/sdc2 is busy - skipping
mdadm: no RAID superblock on /dev/sdc1
mdadm: no RAID superblock on /dev/sdc
mdadm: /dev/sdb1 is busy - skipping
mdadm: no RAID superblock on /dev/sdb
mdadm: no RAID superblock on /dev/sda3
mdadm: /dev/sda2 is busy - skipping
mdadm: no RAID superblock on /dev/sda1
mdadm: no RAID superblock on /dev/sda

I would like to know what is making these devices busy. I do not see any
indication from lsof or from the device mapper that these devices are being
used. I have even changed the  initramfs and the fstab etc. to prevent this
array from being started at boot time - still unable to assemble it.

This array contains my /home and I do not know how to recover it.

Help please ...

Thanks,
Sachin
