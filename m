From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bootable Raid-1
Date: Tue, 1 Feb 2011 15:53:27 -0600
Message-ID: <8A.7B.05134.9D0884D4@cdptpa-omtalb.mail.rr.com>
References: <4D487CA4.2030502@faccat.br>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D487CA4.2030502@faccat.br>
Sender: linux-raid-owner@vger.kernel.org
To: naira@faccat.br
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: Naira Kaieski [mailto:naira@faccat.br]
> Sent: Tuesday, February 01, 2011 3:36 PM
> To: lrhorer@satx.rr.com
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Bootable Raid-1
> 
> Hi,
> 
> My metadata is 0.90...
> 
> My Partitions:
> /dev/sda1               1         122      979933+  fd  Linux raid
> autodetect
> /dev/sda2   *         123         134       96390   fd  Linux raid
> autodetect
> /dev/sda3             135       19457   155211997+  fd  Linux raid
> autodetect

	I recall reading very recently (it might have even been today) that
Linux RAID Autodetect partitions can cause problems.  I have mine set to
simply "Linux":

Disk /dev/sda: 500 GB, 500105249280 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          50      401593   83  Linux
/dev/sda2              51       40000   320890342   83  Linux
/dev/sda3           40001       60801   167076000   83  Linux
 
> Disk /dev/md1: 1003 MB, 1003356160 bytes
> 2 heads, 4 sectors/track, 244960 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
> 
> Disk /dev/md1 doesn't contain a valid partition table
> 
> Disk /dev/md2: 98 MB, 98631680 bytes
> 2 heads, 4 sectors/track, 24080 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
> 
> Disk /dev/md2 doesn't contain a valid partition table
> 
> Disk /dev/md3: 158.9 GB, 158936989696 bytes
> 2 heads, 4 sectors/track, 38802976 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0xc4036374
> 
> Disk /dev/md3 doesn't contain a valid partition table
> 
> 
> I created the array with the command:
> mdadm --create --verbose --assume-clean --metadata=0.90 /dev/md3
> --level=1 --raid-devices=2 /dev/sda3 missing
> 
> # cat /proc/mdstat
> Personalities : [raid1]
> md3 : active raid1 sda3[0]
>        155211904 blocks [2/1] [U_]
> 
> md2 : active raid1 sda2[0]
>        96320 blocks [2/1] [U_]
> 
> md1 : active raid1 sda1[0]
>        979840 blocks [2/1] [U_]
> 
> # mdadm -D --scan
> ARRAY /dev/md1 metadata=0.90 UUID=e905069f:43e2eaa4:e090bcab:b1d9c206
> ARRAY /dev/md2 metadata=0.90 UUID=d259ec4f:1c63d0b1:e090bcab:b1d9c206
> ARRAY /dev/md3 metadata=0.90 UUID=030d5ded:82314c21:e090bcab:b1d9c206
> 
> On dmesg:
> [ 2349.760155] md: bind<sda1>
> [ 2349.762677] md/raid1:md1: active with 1 out of 2 mirrors
> [ 2349.762720] md1: detected capacity change from 0 to 1003356160
> [ 2349.765307]  md1: unknown partition table
> [ 2363.059235] md: bind<sda2>
> [ 2363.061089] md/raid1:md2: active with 1 out of 2 mirrors
> [ 2363.061129] md2: detected capacity change from 0 to 98631680
> [ 2363.065812]  md2: unknown partition table
> [ 2372.302358] md: bind<sda3>
> [ 2372.304614] md/raid1:md3: active with 1 out of 2 mirrors
> [ 2372.304663] md3: detected capacity change from 0 to 158936989696
> [ 2372.308395]  md3: unknown partition table
> 
> My kernel config:
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=y
> CONFIG_MD_AUTODETECT=y
> CONFIG_MD_RAID1=y
> 
> # mdadm --examine /dev/sda3
> /dev/sda3:
>            Magic : a92b4efc
>          Version : 0.90.00
>             UUID : 030d5ded:82314c21:e090bcab:b1d9c206 (local to host dns)
>    Creation Time : Tue Feb  1 19:03:30 2011
>       Raid Level : raid1
>    Used Dev Size : 155211904 (148.02 GiB 158.94 GB)
>       Array Size : 155211904 (148.02 GiB 158.94 GB)
>     Raid Devices : 2
>    Total Devices : 1
> Preferred Minor : 3
> 
>      Update Time : Tue Feb  1 19:18:56 2011
>            State : clean
>   Active Devices : 1
> Working Devices : 1
>   Failed Devices : 1
>    Spare Devices : 0
>         Checksum : 64a5bec0 - correct
>           Events : 7
> 
> 
>        Number   Major   Minor   RaidDevice State
> this     0       8        3        0      active sync   /dev/sda3
> 
>     0     0       8        3        0      active sync   /dev/sda3
>     1     1       0        0        1      faulty removed
> 
> I format the md* devices and copy file with rsync, alter the grub and
> fstab to boot md devices but on boot i have fail to boot md3 as rootfs
> 
> Atenciosamente,
> Naira Kaieski
> 
> 
> 
> Em 1/2/2011 18:43, Leslie Rhorer escreveu:
> >> I have read several articles on the internet and researched in the
> >> messages list, but I'm still having trouble configuring a raid level 1
> >> array that is bootable.
> >>
> >> I configured a server some time agowith Gentoo Linux, Kernel
> >> 2.6.28-hardened-r9, mdadm - v3.0 and 2 IDE hard drives, this is working
> >> correctly. For this installation iused as a basis for consultation
> >> Article http://en.gentoo-wiki.com/wiki/Migrate_to_RAID
> >>
> >> Now, I want to use two SATA drives in raid level 1,
> >>
> >> Now i have Gentoo Linux with kernel  2.6.36-hardened-r6 and mdadm -
> >> v3.1.4 and the instructions of Article dont work. The kernel was
> >> configured with support for disks raid autodetect and supported the
> raid
> >> level 1. But in the logs of dmesg does not run the auto-detection of
> the
> >> disks to the array, so in the boot when mounting the root device /
> >> dev/md2 the system can not find the device.
> >>
> >> When I run mdadm - auto-detect the array are found somewhere but still
> >> displays message indicating that the raid device is not a valid
> >> partition table.
> >>
> >> How can you configure a raid level 1 with bootable disks / dev / sda
> and
> >> / dev / sdb?
> >> I want three partitions:
> >>       /dev/md1  - swap  - /dev/sda1, /dev/sdb1
> >>       /dev/md2  - boot   - /dev/sda2, /dev/sdb2
> >>       /dev/md3  - / - /dev/sda3, /dev/sdb3
> >>
> >> I am using grub as bootloader.
> > 	This is very similar to my boot configuration on my two servers.  I
> > suspect your problem is the metadata.  What version of superblock are
> you
> > using for /dev/md2?  GRUB2 does not recognize a version 1.x superblock.
> > Since the boot images are quite small, and don't require an array of
> many
> > disks, there is nothing wrong with the 0.90 superblock, however.  If
> your
> > /dev/md2 array is not a 0.9 version superblock, try converting it.  Here
> is
> > my configuration from one of the servers:
> >
> > ARRAY /dev/md0 level=raid6 num-devices=10 metadata=01.2 name=Backup:0
> > UUID=431244d6:45d9635a:e88b3de5:92f30255
> > ARRAY /dev/md1 level=raid1 num-devices=2 metadata=0.90
> > UUID=4cde286c:0687556a:4d9996dd:dd23e701
> > ARRAY /dev/md2 level=raid1 num-devices=2 metadata=01.2 name=Backup:2
> > UUID=d45ff663:9e53774c:6fcf9968:21692025
> > ARRAY /dev/md3 level=raid1 num-devices=2 metadata=01.2 name=Backup:3
> > UUID=51d22c47:10f58974:0b27ef04:5609d357
> >
> > 	Where md0 is a large (11T) data array, md1 is boot, md2 is root, and
> > md3 is swap.  The partitioning layout of the boot drives is the same as
> > yours.
> >

