From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: partitioned raid issues
Date: Sun, 15 Feb 2009 22:00:03 +0100
Message-ID: <1234731603.21875.39.camel@poledra.romunt.nl>
Reply-To: Rudy@grumpydevil.homelinux.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear,

I have a system with the following raid setup:

root@astra:~# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md_d0p1           3906116   3712624    193492  96% /
/dev/md_d0p3            976476     32848    943628   4% /tmp
/dev/md_d0p5            488236     55208    433028  12% /var/log
/dev/md_d0p6           3906116   3630292    275824  93% /usr/src
/dev/md_d0p7           7666192     42128   7624064   1% /home

root@astra:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] 
md_d0 : active raid1 sdb1[1] sda1[0]
      17920384 blocks [2/2] [UU]
      

The unit boots over ethernet, with the following stansa in pxeconfig:

default astra-2.6.27.6 noinitrd load_ramdisk=0 prompt_ramdisk=0
root=/dev/md_d0p1 raid=part ro
prompt 1
timeout 1200
display astra.f1
F1 astra.f1


So far, so good. 

Now as soon as i switch to kernel 2.6.28.2, it fails and the kernel is
not able to find the root device. 

Anyone an idea what is happening here?
relevant section from config:

CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_RAID5_RESHAPE=y
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set


Cheers,


Rudy

