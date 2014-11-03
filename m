From: gornea <gornea@zoho.com>
Subject: Fake RAID 10 on ASRock Z97 Extreme3 with Slackware 14.1
Date: Mon, 03 Nov 2014 17:47:48 +0100
Message-ID: <14976849ec4.ace7bf4939116.3019157828391505014@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

I hope I'm on the right email list. I'm facing a problem during Slackware 14.1 installation. I have a ASRock motherboard (Z97 Extreme3) with Intel Rapid Storage Technology 13. I have 4 identical new 4-TBy WD hard drives. I configured the option ROM for RAID 10. When booting with Slackware 14.1 CD md finds the array but it always mounts it read only. I tried to work on it to make writable but I was not successful. I have tried to boot with the latest Ubuntu Server CD and it works well. I have also tried to delete the RAID 10 in the option ROM and then create it with mdadm after booting with Slackware 14.1 and I always produces a read only volume. I get no errors or warnings and in general everything seems fine except that I can not write on it (for example I can not create partitions). The 
 md version with Slackware 14.1 boot disk is 3.2.6 and the kernel is 3.10.17. So I'm starting to wonder if actually there is a know problem with that md/kernel? Or maybe there is a problem with the way I use it, but frankly I run out of ideas how to proceed further. This is the output of /proc/mdstat

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath]
md126 : active (read-only) raid10 sda[3] sdb[2] sdc[1] sdd[0]
7814032384 blocks super external:/md127/0 64K chunks 2 near-copies [4/4] [UUUU]

md127 : inactive sda[3](S) sdb[2](S) sdc[1](S) sdd[0](S)
9040 blocks super external:imsm

unused devices: <none>

Thanks a lot for any suggestion about how to proceed! I would like to install the fake RAID if it is not impossible with Slackware 14.1. I know that eventually it is possible to install a software RAID but I would like to understand why the Intel fake RAID is not working with Slackware 14.1.

Best regards,
Razvan Gornea


