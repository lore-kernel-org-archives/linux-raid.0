From: Luca Berra <bluca@comedia.it>
Subject: Re: What fdisk file system type for generic RAID0/1?
Date: Fri, 16 Apr 2010 08:44:03 +0200
Message-ID: <20100416064403.GC17719@maude.comedia.it>
References: <m2z5bdc1c8b1004151258n8ba374e8s8b1169e22cea0a64@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <m2z5bdc1c8b1004151258n8ba374e8s8b1169e22cea0a64@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Apr 15, 2010 at 12:58:19PM -0700, Mark Knecht wrote:
>For drives that shouldn't be assembled by the kernel at boot time what
>sort of file system type should they be marked with by fdisk? (I.e -
>Is 'fd' __incorrect__ because I don't care about auto-detection.)

Could you kindly explain what your problem is, because what you post
below does not match your intro.
Something in the lines of: "I would like that md6 is not assembled at
boot time, could it be due to the partition type set to 0xfd, should i
change that?" would be far more effective, assuming this is what you
intended.
adding your distro version, kernel and mdadm version, contents of
mdadm.conf usually helps as well

On a modern system _NO_ drive is assembled by the kernel at boot time
they are assembled by mdadm called from an initramfs or from mdadm
called by init scripts or udev rules

Even if you try there is no way the kernel can autodetect an md with a
superblock different than 0.90, so your md6 and md11 were not
autodetected.

this link lists all known partition types
http://www.win.tue.nl/~aeb/partitions/partition_types-1.html
as you can see the only linux raid partition type is in fact fd
Anyway most modern distro use blkid which is not fooled by partition
types, so you could set it to anything and it would probably still
behave the same way.

L.

>My system has a 2-drive RAID0 to host vmware appliances and then a
>3-drive RAID1 to back up the RAID0 every so often. When I boot I see
>this message on the console:
>
>mdadm: /dev/md/6 has been started with 3 drives. [!!]
>
>where the !! are in red. Once booted and into KDE everything looks fine:
>
>c2stable ~ # cat /proc/mdstat
>Personalities : [raid0] [raid1]
>md6 : active raid1 sda6[0] sdc6[2] sdb6[1]
>      247416933 blocks super 1.1 [3/3] [UUU]
>
>md11 : active raid0 sdd1[0] sde1[1]
>      104871936 blocks super 1.1 512k chunks
>
>md3 : active raid1 sdc3[2] sdb3[1] sda3[0]
>      52436096 blocks [3/3] [UUU]
>
>md5 : active raid1 sdc5[2] sdb5[1] sda5[0]
>      52436032 blocks [3/3] [UUU]
>
>unused devices: <none>
>c2stable ~ #
>
>In dmesg I see this about mdadm getting things starts:
>
>md: md11 stopped.
>md: bind<sde1>
>md: bind<sdd1>
>raid0 : md_size is 209743872 sectors.
>******* md11 configuration *********
>md11: detected capacity change from 0 to 107388862464
> md11: unknown partition table
>md: md6 stopped.
>md: bind<sdb6>
>md: bind<sdc6>
>md: bind<sda6>
>raid1: raid set md6 active with 3 out of 3 mirrors
>md6: detected capacity change from 0 to 253354939392
> md6: unknown partition table
>EXT3-fs (md11): using internal journal
>EXT3-fs (md11): mounted filesystem with writeback data mode
>EXT3-fs (md6): using internal journal
>EXT3-fs (md6): mounted filesystem with writeback data mode
>
>I'm thinking that my making them with 'fd' has confused the boot process a bit.
>
>If that's correct then is there and problem with just marking them
>back to 83 now?
>
>   Device Boot      Start         End      Blocks   Id  System
>/dev/sda1   *           1           7       56196   83  Linux
>/dev/sda2               8         530     4200997+  82  Linux swap / Solaris
>/dev/sda3             536        7063    52436160   fd  Linux raid autodetect
>/dev/sda4            7064       60801   431650485    5  Extended
>/dev/sda5            7064       13591    52436128+  fd  Linux raid autodetect
>/dev/sda6           30000       60801   247417065   fd  Linux raid autodetect
>
>Thanks,
>Mark
>--
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
