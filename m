From: Lapohos Tibor <tibor.lapohos@rogers.com>
Subject: embedding area is unusually small... (GRUB2 on software RAID1)
Date: Wed, 6 Jan 2010 06:23:57 -0800 (PST)
Message-ID: <844035.90831.qm@web88203.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello, 

I successfully set up an Intel Matrix Raid device with a RAID1 and a RAID0 volume, each having a couple of partitions, but then I could not install GRUB2 on the RAID1 volume, which I wanted to use to boot from and mount as root. It turned out that the "IMSM" metadata is not supported in GRUB2 (v1.97.1) just yet, so I had to turn away from my original plan. 

To "imitate" the setup I originally wanded, I turned both of my drives into AHCI controlled devices in the BIOS (instead of RAID), and I partitioned them to obtain /dev/sda[12] and /dev/sdb[12]. 

Then I used /dev/sd[ab]1 to build a RAID1 set, and /dev/sd[ab]2 to create a RAID0 set using mdadm v 3.0.3: 

> mdadm -C /dev/md0 -v -e 0 -l 1 -n 2 /dev/sda1 /dev/sdb1 
> mdadm -C /dev/md1 -v -e 0 -l 0 -n 2 /dev/sda2 /dev/sdb2 

I set the metadata type to 0.90 because I would like to boot from it and allow the kernel to auto-detect the RAID devices while it's booting, in order to can get away from using an intitrd (I am building my own distribution based on CLFS x86_64 multilib). 

I used cfdisk to partition both of the /dev/md[01] devices, and I obtained /dev/md0p[123] and /dev/md1p[12]. The plan is to use /dev/md0p1 as a RAID1 root partition, and have the system boot from /dev/md0. I formatted /dev/md0p1 as 

> mk2efs -t ext4 -L OS /dev/md0p1 

To this point, things went smoothly. mdadm -D... and mdadm -E... did report back working devices as intended. Then mounted /dev/md0p1 on a directory called /root/os, and I did 

> grub-install --root-directory=/root/os /dev/md0 

or 

> grub-install --root-directory=/root/os "md0" 

and I got a warning and an error message: "Your embedding area is unusually small.  core.img won't fit in it." and "Embedding is not possible, but this is required when the root device is on a RAID array or LVM volume." 

What did I do wrong, and how do I fix it? Thanks ahead, 
Tibor


