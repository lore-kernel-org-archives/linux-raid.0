From: George Duffield <forumscollective@gmail.com>
Subject: Re: Understanding raid array status: Active vs Clean
Date: Tue, 17 Jun 2014 16:31:52 +0200
Message-ID: <CAG__1a5j-0O7LOb6opz4MLPCjbxRNDXiaG6W=Xxt3JJ9eXfRRA@mail.gmail.com>
References: <CAG__1a4MRV6gJL38XLAurtoSiD3rLBTmWpcS5HYvPpSfPR88UQ@mail.gmail.com>
	<20140529151658.3bfc97e5@notabene.brown>
	<1C901CF6-75BD-4B54-9F5D-7E2C35633CBC@gmail.com>
	<20140529160623.5b9e37e5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140529160623.5b9e37e5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Apologies for the long delay in responding - I had further issues with
Microservers trashing the first drive in the backplane, including one
of the drives for the array in question (in the case of the array it
seems the drive lost power and dropped out the array, albeit it's
fully functional now and passes SMART testing).  As a result I've
built new machines using a mini-itx motherboards and made a clean
install of Arch Linux - finished that last night, so now have the
array migrated to the new machine and powered up, albeit in degraded
mode.  I'd appreciate some advice re rebuilding this array (by adding
back the drive in question).  I've set out below pertinent info
relating to the array and hard drives in the system as well as my
intended recovery strategy.  As can be seen from lsblk, /dev/sdb1 is
the drive that is no longer recognised as being part of the array.  It
has not been written to since the incident occurred.  Is there a quick
& easy to reintegrate it into the array or is my only option to run:
# mdadm /dev/md0 --add /dev/sdb1

and let it take its course?

The machine has a 3.5Ghz i3 CPU and currently has 8GB ram installed, I
can swap out the 4GB chips and replace with 8GB chips if 16GB RAM will
significantly increase the rebuild speed.  I'd also like to speed up
the rebuild as far as possible, so my plan is to set the following
parameters, (but I've no idea what safe numbers would be).

dev.raid.speed_limit_min =
dev.raid.speed_limit_max =

Current values are:
# sysctl dev.raid.speed_limit_min
dev.raid.speed_limit_min = 1000
# sysctl dev.raid.speed_limit_max
dev.raid.speed_limit_max = 200000

Set readahead:
# blockdev --setra 65536 /dev/md0

Set stripe_cache_size to 32 MiB:
# echo 32768 > /sys/block/md0/md/stripe_cache_size

Turn on bitmaps:
# mdadm --grow --bitmap=internal /dev/md0

Rebuild the array by reintegrating /dev/sdb1:
# mdadm /dev/md0 --add /dev/sdb1

Turn off bitmaps after rebuild is completed:
# mdadm --grow --bitmap=none /dev/md0


Thanks for your time and patience.


Current Array and hardware stats:
-------------------------------------------------

# mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Thu Apr 17 01:13:52 2014
     Raid Level : raid5
     Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
  Used Dev Size : 2930134016 (2794.39 GiB 3000.46 GB)
   Raid Devices : 5
  Total Devices : 4
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Jun  3 17:38:15 2014
          State : active, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : audioliboffsite:0  (local to host audioliboffsite)
           UUID : aba348c6:8dc7b4a7:4e282ab5:40431aff
         Events : 11314

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       65        1      active sync   /dev/sde1
       2       8       81        2      active sync   /dev/sdf1
       3       8       33        3      active sync   /dev/sdc1
       5       8       49        4      active sync   /dev/sdd1

# lsblk -i
NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda       8:0    1  7.5G  0 disk
|-sda1    8:1    1  512M  0 part  /boot
`-sda2    8:2    1    7G  0 part  /
sdb       8:16   0  2.7T  0 disk
`-sdb1    8:17   0  2.7T  0 part
sdc       8:32   0  2.7T  0 disk
`-sdc1    8:33   0  2.7T  0 part
  `-md0   9:0    0 10.9T  0 raid5
sdd       8:48   0  2.7T  0 disk
`-sdd1    8:49   0  2.7T  0 part
  `-md0   9:0    0 10.9T  0 raid5
sde       8:64   0  2.7T  0 disk
`-sde1    8:65   0  2.7T  0 part
  `-md0   9:0    0 10.9T  0 raid5
sdf       8:80   0  2.7T  0 disk
`-sdf1    8:81   0  2.7T  0 part
  `-md0   9:0    0 10.9T  0 raid5







I've answered your questions below as best I can:

>> Any idea what would cause constant writing - I presume from what I see that the initial array sync completed?--
>
> Hmmm...
> Do the numbers in /proc/diskstats change?
>
>   watch -d 'grep md0 /proc/diskstats'


Nope, they remain constant


> What is in /sys/block/md0/md/safe_mode_delay?

0.203 is the value at present - I can try changing it afrter
rebuilding the array.


> What if you change that to a different number (it is in seconds and can be
> fractional)?
>
> What  kernel version (uname -a)?

3.14.6-1-ARCH #1 SMP PREEMPT Sun Jun 8 10:08:38 CEST 2014 x86_64 GNU/Linux
