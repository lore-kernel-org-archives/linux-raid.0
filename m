From: Mark Knecht <markknecht@gmail.com>
Subject: Continuing problems with RAID arrays starting at boot - devices not
	found
Date: Thu, 13 May 2010 18:31:26 -0700
Message-ID: <AANLkTinUxy9cCTILXHASuCORhGO25gmgSwg-etV6JDBq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   I have a continuing problem with all my my RAID arrays. I'm
moderately confident that it's not a mdadm problem but I hope I can
ask here for any tests or ideas to test it before I try reporting it
up to the LKML. Thanks in advance.

   I have a new high-end home server/desktop machine built using an
Asus Rampage II Extreme motherboard, an Intel Core i7-980x and
(currently) 12GB DRAM. The machine has five 500GB WD RAID Edition
drives:

RAID 1: /dev/sda, /dev/sdb & /dev/sdc - 3 partitions on each drive
creating three 3-drive RAID1 drives

RAID 0: /dev/sdd & /dev/sde - currently 1 partition on each drive
creating a RAID0.

  Every time I boot all 5 drives are recognized by system BIOS. There
is a BIOS device table printing on the screen and it __always__ shows
all 5 drives. If I enter BIOS and look at the storage page all drives
are shown. If I do nothing then the system waits 10 seconds, then
boots into grub. Grub boots the kernel, the boot process rolls along,
gets to where it starts mdadm, and then 50%-75% of the time one or
more of the partitions isn't found and mdadm doesn't start the RAID
correctly.

   Now, after booting and RAID not starting correctly, maybe half the
time I can look for the drive (ls /dev/sde1 for instance) find it and
add it back to the RAID array. Half the time the drive isn't found
until I reboot the machine. If I look in dmesg I don't see the missing
drive. It's just like it isn't there even though BIOS said it was
before booting Linux. The missing drive is not always found on a warm
reboot, but is often found on a cold reboot.

   The problem has been consistent across all the kernels I've tried
over the last 2 months.

   My question is whether this is in any way related to mdadm? I
suspect it isn't but thought I'd try to get some ideas on how to test
for the root cause of this problem. If it was purely a mdadm problem
then even if the RAID wasn't correctly started then wouldn't I still
find the drive partitions?

   I can send along whatever info is needed. I don't know what to
supply at this point.

Thanks,
Mark

c2stable ~ # uname -a
Linux c2stable 2.6.34-rc5 #1 SMP PREEMPT Mon Apr 26 12:04:14 PDT 2010
x86_64 Intel(R) Core(TM) i7 CPU X 980 @ 3.33GHz GenuineIntel GNU/Linux
c2stable ~ #


c2stable ~ # cat /proc/mdstat
Personalities : [raid0] [raid1]
md6 : active raid1 sda6[0] sdc6[2] sdb6[1]
      247416933 blocks super 1.1 [3/3] [UUU]

md11 : active raid0 sdd1[0] sde1[1]
      104871936 blocks super 1.1 512k chunks

md3 : active raid1 sdc3[2] sda3[0] sdb3[1]
      52436096 blocks [3/3] [UUU]

md5 : active raid1 sdc5[2] sda5[0] sdb5[1]
      52436032 blocks [3/3] [UUU]

unused devices: <none>
c2stable ~ #

c2stable ~ # ls /dev/sd*
/dev/sda   /dev/sda4  /dev/sdb1  /dev/sdb5  /dev/sdc2  /dev/sdc6  /dev/sde1
/dev/sda1  /dev/sda5  /dev/sdb2  /dev/sdb6  /dev/sdc3  /dev/sdd
/dev/sda2  /dev/sda6  /dev/sdb3  /dev/sdc   /dev/sdc4  /dev/sdd1
/dev/sda3  /dev/sdb   /dev/sdb4  /dev/sdc1  /dev/sdc5  /dev/sde
c2stable ~ #
