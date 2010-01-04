From: <senthilkumar.muthukalai@wipro.com>
Subject: RE: Growing Linear RAID
Date: Mon, 4 Jan 2010 14:03:54 +0530
Message-ID: <8338BD137FF1B64EB341218BD702985E02D283C4@BLR-EC-MBX03.wipro.com>
References: <8338BD137FF1B64EB341218BD702985E02C8C03B@BLR-EC-MBX03.wipro.com><20091210123353.66100b41@notabene.brown><8338BD137FF1B64EB341218BD702985E02C8C165@BLR-EC-MBX03.wipro.com><20091210203008.69cbbe97@notabene.brown><8338BD137FF1B64EB341218BD702985E02C8C9BF@BLR-EC-MBX03.wipro.com> <20091217101435.4bc51a69@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

In addition to the below mentioned details, I would like to add the
details of the patch suggested by you earlier.

commit a778b73ff793d34c0082f76110f73a7754915067.

The below mentioned observations were made after applying this patch.

Kindly help.

New year wishes.

Thanks,
Senthil M

-----Original Message-----
From: SenthilKumar Muthukalai (WT01 - Telecom Equipment) 
Sent: Wednesday, December 23, 2009 10:03 PM
To: Neil Brown
Cc: linux-raid@vger.kernel.org
Subject: RE: Growing Linear RAID

Hi Neil,

Upgrading the kernel is quite impossible as there are lots of
open-source packages bundled in our NAS product which would need
enormous testing and effort to check the compliance of the fixes and
features that had gone in all these days, if we upgrade.

Kindly check the observations stated below and see if you can help.
We have linux-2.6.18 and mdadm-2.6.4.

[root@NAS0018f8056151 /]#
[root@NAS0018f8056151 /]# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4]
md0 : active linear sdb[0]
      156290880 blocks super 1.2 32k rounding

unused devices: <none>
[root@NAS0018f8056151 /]#
[root@NAS0018f8056151 /]# mdadm -D /dev/md0
/dev/md0:
        Version : 01.02.03
  Creation Time : Wed Dec 23 07:45:42 2009
     Raid Level : linear
     Array Size : 156290880 (149.05 GiB 160.04 GB)
   Raid Devices : 1
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Dec 23 07:45:42 2009
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

       Rounding : 32K

           Name : 0
           UUID : df516a9e:356dc2c0:851c942d:ccab4bda
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sata1
[root@NAS0018f8056151 /]#
[root@NAS0018f8056151 /]#
[root@NAS0018f8056151 /]# mdadm --grow /dev/md0 --add /dev/sata2
md: bind<sda>
[root@NAS0018f8056151 /]#
[root@NAS0018f8056151 /]#
[root@NAS0018f8056151 /]# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4]
md0 : active linear sda[1](S) sdb[0]
      156290880 blocks super 1.2 32k rounding

unused devices: <none>
[root@NAS0018f8056151 /]#
[root@NAS0018f8056151 /]# mdadm -D /dev/md0
/dev/md0:
        Version : 01.02.03
  Creation Time : Wed Dec 23 07:45:42 2009
     Raid Level : linear
     Array Size : 156290880 (149.05 GiB 160.04 GB)
   Raid Devices : 1
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Dec 23 07:45:42 2009
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

       Rounding : 32K

           Name : 0
           UUID : df516a9e:356dc2c0:851c942d:ccab4bda
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sata1

       1       8        0        -      spare   /dev/sata2

Thanks,
Senthil M

-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Thursday, December 17, 2009 4:45 AM
To: SenthilKumar Muthukalai (WT01 - Telecom Equipment)
Cc: linux-raid@vger.kernel.org
Subject: Re: Growing Linear RAID

On Wed, 16 Dec 2009 16:32:30 +0530
<senthilkumar.muthukalai@wipro.com> wrote:

> Neil,
> 
> I applied the patch but the disk is getting added as a spare.
> Pls guide me here.
>

While I would like to help, it is hard to justify spending much time
getting
something working on an old kernel.  Maybe you should try to resolve
whatever
issues are keeping you from upgrading to a newer kernel.

At the very least, you would need to provide me with a lot more
information
about what if happening.  Exactly what patch you applies, exactly what
command you run, exactly what the output is, exactly what kernel
messages you
get, and exactly what the content of "/proc/mdstat" is both before and
after.
Even with that I cannot promise anything.

NeilBrown
