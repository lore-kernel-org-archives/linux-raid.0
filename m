From: Fredrik Pettersson <freppe@deimos.nu>
Subject: Re: Why is my raid 1 boot/root not working with autodetect?
Date: Thu, 11 Jun 2009 10:44:44 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0906111019350.9820@deimos.nu>
References: <Pine.LNX.4.64.0906101828150.10333@deimos.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0906101828150.10333@deimos.nu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have done some more testing in an attempt to gather more data, and here 
is what I have seen when testing different kernel options.

When booting with my normal kernel options I get the following md output 
during the boot:

(raid=noautodetect md=0,/dev/sdb1,/dev/sdc1 md=d0,/dev/sdb2,/dev/sdc2)
-----
md: Skipping autodetection of RAID arrays. (raid=autodetect will force)
md: Loading md0: /dev/sdb1
md: bind<sdb1>
md: bind<sdc1>
raid1: raid set md0 active with 2 out of 2 mirrors
  md0: unknown partition table
  md0: unknown partition table
md: Loading md_d0: /dev/sdb2
md: bind<sdb2>
md: bind<sdc2>
raid1: raid set md_d0 active with 2 out of 2 mirrors
  md_d0: p1 p2 p3 p4
  md_d0: p1 p2 p3 p4
-----

Everything is well and boots fine.

If I change try to use autodetect but still keep the md= definitions:

(raid=autodetect md=0,/dev/sdb1,/dev/sdc1 md=d0,/dev/sdb2,/dev/sdc2)
-----
md: Autodetecting RAID arrays.
md: Scanned 4 and added 4 devices.
md: autorun ...
md: considering sdc2 ...
md:  adding sdc2 ...
md: sdc1 has different UUID to sdc2
md:  adding sdb2
md: sdb1 has different UUID to sdc2
md: created md1
md: bind<sdb2>
md: bind<sdc2>
md: running: <sdc2><sdb2>
raid1: raid set md1 active with 2 out of 2 mirrors
md: considering sdc1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md: created md0
md: bind<sdb1>
md: bind<sdc1>
md: running: <sdc1><sdb1>
raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
md: Loading md0: /dev/sdb1
  md0: unknown partition table
md: couldn't update array info. -22
md: could not bd_claim sdb1.
md: md_import_device returned -16
md: could not bd_claim sdc1.
md: md_import_device returned -16
md: startind md0 failed
md: Loading md_d0: /dev/sdb2
md: could not bd_claim sdb2.
md: md_import_device returned -16
md: could not bd_claim sdc2.
md: md_import_device returned -16
md: starting md0 failed
-----

In that case boot eventually fails with "mdadm: no devices found for 
/dev/md_d0".

Finally I tried to remove the md= stuff as well:

(raid=autodetect)
-----
md: Autodetecting RAID arrays.
md: Scanned 4 and added 4 devices.
md: autorun ...
md: considering sdc2 ...
md:  adding sdc2 ...
md: sdc1 has different UUID to sdc2
md:  adding sdb2
md: sdb1 has different UUID to sdc2
md: created md1
md: bind<sdb2>
md: bind<sdc2>
md: running: <sdc2><sdb2>
raid1: raid set md1 active with 2 out of 2 mirrors
md: considering sdc1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md: created md0
md: bind<sdb1>
md: bind<sdc1>
md: running: <sdc1><sdb1>
raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
  md0: unknown partition table
-----

Boot fails with the same mdadm error as the previous attempt.

This is all on 2.6.29. Seems to me like it is actually sort of working in 
at least the last go. Or at least the raids are detected, but there is no 
mention of the four partitions on one of them so perhaps it is not 
detected properly? Have I made some error when creating the raids that 
causes the autodetect to not notice that one of the raids is partitioned? 
Any other potential mistakes I might have made that would lead to 
autodetect failing?

Regards,

/Fredrik Pettersson


On Wed, 10 Jun 2009, Fredrik Pettersson wrote:

> Hi,
>
> A couple of years ago I converted my system to run off a software raid 1 
> rather than from a single disk. On the dual 250GB disks I have set up two 
> partitions:
>
> -----
> Disk /dev/sdb: 250.0 GB, 250059350016 bytes
> 255 heads, 63 sectors/track, 30401 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x00000000
>
>   Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1   *           1        1246    10008463+  fd  Linux raid autodetect
> /dev/sdb2            1247       30401   234187537+  fd  Linux raid autodetect
> -----
>
> sdb1/sdc1 is a raid 1 called /dev/md0, sdb2/sdc2 is a partitionable raid 1 
> called /dev/md_d0, partitioned and used for usr, var & home.
>
> Partitions are set up as follows:
>
> -----
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/md0               9851232    236736   9114080   3% /
> udev                     10240        76     10164   1% /dev
> /dev/md_d0p1          29529044   8936164  19092880  32% /usr
> /dev/md_d0p2          19685916  10876740   7809176  59% /var
> /dev/md_d0p3           9842852   3453940   5888912  37% /home
> none                    517192         0    517192   0% /dev/shm
> -----
>
> At the time when I set this up I found that the only way for me to get it to 
> boot properly was to have the following kernel options in my grub.conf:
>
> raid=noautodetect md=0,/dev/sdb1,/dev/sdc1 md=d0,/dev/sdb2,/dev/sdc2
>
> As it was some time ago I don't recall exactly why that had to be there, but 
> it doesn't work without having those kernel options. I've just started 
> thinking of adding more software raid disks to my system and figured it would 
> be nice if autodetect would work for me so I would prefer to get rid of those 
> options. If I remove the "raid=noautodetect" bit, or all of it, then the 
> system fails to boot properly. From what I can see on the console it appears 
> to find the md_d0 raid and partitions just fine, but not the /dev/md0 raid 
> which obviously causes the boot to fail. So my question now is, why is 
> autodetect not working properly and what can I do to fix it?
>
> I'm sure there is more information I should have provided here, please ask if 
> anything is missing. Here is my /proc/mdstat and the full entry from 
> grub.conf:
>
> -----
> # cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
> md_d0 : active raid1 sdc2[1] sdb2[0]
>       234187456 blocks [2/2] [UU]
>
> md0 : active raid1 sdc1[1] sdb1[0]
>       10008384 blocks [2/2] [UU]
>
> unused devices: <none>
> -----
>
> -----
> title=Gentoo Linux 2.6.29-gentoo-r5
>        kernel (hd0,0)/boot/kernel-2.6.29-gentoo-r5 root=/dev/md0 
> raid=noautodetect md=0,/dev/sdb1,/dev/sdc1 md=d0,/dev/sdb2,/dev/sdc2
>        savedefault fallback
> -----
>
> Best regards, and thanks in advance for any answers.
>
> /Fredrik Pettersson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
