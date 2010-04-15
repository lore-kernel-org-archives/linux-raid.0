From: Mark Knecht <markknecht@gmail.com>
Subject: What fdisk file system type for generic RAID0/1?
Date: Thu, 15 Apr 2010 12:58:19 -0700
Message-ID: <m2z5bdc1c8b1004151258n8ba374e8s8b1169e22cea0a64@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

For drives that shouldn't be assembled by the kernel at boot time what
sort of file system type should they be marked with by fdisk? (I.e -
Is 'fd' __incorrect__ because I don't care about auto-detection.)

My system has a 2-drive RAID0 to host vmware appliances and then a
3-drive RAID1 to back up the RAID0 every so often. When I boot I see
this message on the console:

mdadm: /dev/md/6 has been started with 3 drives. [!!]

where the !! are in red. Once booted and into KDE everything looks fine:

c2stable ~ # cat /proc/mdstat
Personalities : [raid0] [raid1]
md6 : active raid1 sda6[0] sdc6[2] sdb6[1]
      247416933 blocks super 1.1 [3/3] [UUU]

md11 : active raid0 sdd1[0] sde1[1]
      104871936 blocks super 1.1 512k chunks

md3 : active raid1 sdc3[2] sdb3[1] sda3[0]
      52436096 blocks [3/3] [UUU]

md5 : active raid1 sdc5[2] sdb5[1] sda5[0]
      52436032 blocks [3/3] [UUU]

unused devices: <none>
c2stable ~ #

In dmesg I see this about mdadm getting things starts:

md: md11 stopped.
md: bind<sde1>
md: bind<sdd1>
raid0 : md_size is 209743872 sectors.
******* md11 configuration *********
md11: detected capacity change from 0 to 107388862464
 md11: unknown partition table
md: md6 stopped.
md: bind<sdb6>
md: bind<sdc6>
md: bind<sda6>
raid1: raid set md6 active with 3 out of 3 mirrors
md6: detected capacity change from 0 to 253354939392
 md6: unknown partition table
EXT3-fs (md11): using internal journal
EXT3-fs (md11): mounted filesystem with writeback data mode
EXT3-fs (md6): using internal journal
EXT3-fs (md6): mounted filesystem with writeback data mode

I'm thinking that my making them with 'fd' has confused the boot process a bit.

If that's correct then is there and problem with just marking them
back to 83 now?

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1           7       56196   83  Linux
/dev/sda2               8         530     4200997+  82  Linux swap / Solaris
/dev/sda3             536        7063    52436160   fd  Linux raid autodetect
/dev/sda4            7064       60801   431650485    5  Extended
/dev/sda5            7064       13591    52436128+  fd  Linux raid autodetect
/dev/sda6           30000       60801   247417065   fd  Linux raid autodetect

Thanks,
Mark
