From: George Duffield <forumscollective@gmail.com>
Subject: Re: Understanding raid array status: Active vs Clean
Date: Wed, 18 Jun 2014 16:31:29 +0200
Message-ID: <CAG__1a6y4rABphRfSo_wxJC-r2YSec+A1D4O_1iVofqsRhB+UQ@mail.gmail.com>
References: <CAG__1a4MRV6gJL38XLAurtoSiD3rLBTmWpcS5HYvPpSfPR88UQ@mail.gmail.com>
	<20140529151658.3bfc97e5@notabene.brown>
	<1C901CF6-75BD-4B54-9F5D-7E2C35633CBC@gmail.com>
	<20140529160623.5b9e37e5@notabene.brown>
	<CAG__1a5j-0O7LOb6opz4MLPCjbxRNDXiaG6W=Xxt3JJ9eXfRRA@mail.gmail.com>
	<CAG__1a5XK1yt70ox_12hLjpBpY=YRcaJ6-MYHiEJ_RTpxFujoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG__1a5XK1yt70ox_12hLjpBpY=YRcaJ6-MYHiEJ_RTpxFujoA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Please ignore my reference to the array being partitioned, what I'd
intended to write follows:
Unless mdadm writes to the drives when a machine is booted or the
array MOUNTED I know for certain that the array has not been
written to i.e. no files have been added or deleted from a user
perspective.  The degraded array has been mounted and files read from
the array, but that's it.

Would really appreciate some input here so I can get on with growing
my main array once this "backup" machine is fully functional and I
know the underlying files are intact.

On Wed, Jun 18, 2014 at 3:25 PM, George Duffield
<forumscollective@gmail.com> wrote:
> A little more information if it helps deciding on the best recovery
> strategy.  As can be seen all drives still in the array have event
> count:
> Events : 11314
>
> The drive that fell out of the array has an event count of:
> Events : 11306
>
> Unless mdadm writes to the drives when a machine is booted or the
> array partitioned I know for certain that the array has not been
> written to i.e. no files have been added or deleted.
>
> Per https://raid.wiki.kernel.org/index.php/RAID_Recovery it would seem
> to me the following guidance applies:
> If the event count closely matches but not exactly, use "mdadm
> --assemble --force /dev/mdX <list of devices>" to force mdadm to
> assemble the array anyway using the devices with the closest possible
> event count. If the event count of a drive is way off, this probably
> means that drive has been out of the array for a long time and
> shouldn't be included in the assembly. Re-add it after the assembly so
> it's sync:ed up using information from the drives with closest event
> counts.
>
> However, in my case the array has been auto assebled by mdadm at boot
> time.  How would I best go about adding /dev/sdb1 back into the array?
>
>
> Superblock information:
>
> # mdadm --examine /dev/sd[bcdef]1
>
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : aba348c6:8dc7b4a7:4e282ab5:40431aff
>            Name : audioliboffsite:0  (local to host audioliboffsite)
>   Creation Time : Thu Apr 17 01:13:52 2014
>      Raid Level : raid5
>    Raid Devices : 5
>
>  Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>      Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : clean
>     Device UUID : e9663464:5b912bb1:a5617fe9:19abfc55
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Jun  3 17:31:02 2014
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : fb31415f - correct
>          Events : 11306
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 0
>    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : aba348c6:8dc7b4a7:4e282ab5:40431aff
>            Name : audioliboffsite:0  (local to host audioliboffsite)
>   Creation Time : Thu Apr 17 01:13:52 2014
>      Raid Level : raid5
>    Raid Devices : 5
>
>  Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>      Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : clean
>     Device UUID : 71052522:8b78da02:3e0cd6da:f3b3eb3e
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Jun  3 17:38:15 2014
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : e5177c43 - correct
>          Events : 11314
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 3
>    Array State : .AAAA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : aba348c6:8dc7b4a7:4e282ab5:40431aff
>            Name : audioliboffsite:0  (local to host audioliboffsite)
>   Creation Time : Thu Apr 17 01:13:52 2014
>      Raid Level : raid5
>    Raid Devices : 5
>
>  Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>      Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : clean
>     Device UUID : 2bd0953f:2319fe92:2dbe7e53:4b16fc80
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Jun  3 17:38:15 2014
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 4d64fbdf - correct
>          Events : 11314
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 4
>    Array State : .AAAA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : aba348c6:8dc7b4a7:4e282ab5:40431aff
>            Name : audioliboffsite:0  (local to host audioliboffsite)
>   Creation Time : Thu Apr 17 01:13:52 2014
>      Raid Level : raid5
>    Raid Devices : 5
>
>  Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>      Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : clean
>     Device UUID : 3e1155bb:a4b65803:caf487e4:9bb01396
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Jun  3 17:38:15 2014
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : df9fab5c - correct
>          Events : 11314
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 1
>    Array State : .AAAA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdf1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : aba348c6:8dc7b4a7:4e282ab5:40431aff
>            Name : audioliboffsite:0  (local to host audioliboffsite)
>   Creation Time : Thu Apr 17 01:13:52 2014
>      Raid Level : raid5
>    Raid Devices : 5
>
>  Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>      Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : clean
>     Device UUID : 1714ea64:c1610064:b8603f47:eaaffc3c
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Jun  3 17:38:15 2014
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : f37cc48f - correct
>          Events : 11314
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 2
>    Array State : .AAAA ('A' == active, '.' == missing, 'R' == replacing)
>
>
>
>
> Checking event count on all drives making up the array (and the member
> that "failed"):
>
> [root@audioliboffsite ~]# mdadm --examine /dev/sdb
> /dev/sdb:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> [root@audioliboffsite ~]# mdadm --examine /dev/sdc
> /dev/sdc:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> [root@audioliboffsite ~]# mdadm --examine /dev/sdd
> /dev/sdd:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> [root@audioliboffsite ~]# mdadm --examine /dev/sde
> /dev/sde:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> [root@audioliboffsite ~]# mdadm --examine /dev/sdf
> /dev/sdf:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
>
>
> On Tue, Jun 17, 2014 at 4:31 PM, George Duffield
> <forumscollective@gmail.com> wrote:
>> Apologies for the long delay in responding - I had further issues with
>> Microservers trashing the first drive in the backplane, including one
>> of the drives for the array in question (in the case of the array it
>> seems the drive lost power and dropped out the array, albeit it's
>> fully functional now and passes SMART testing).  As a result I've
>> built new machines using a mini-itx motherboards and made a clean
>> install of Arch Linux - finished that last night, so now have the
>> array migrated to the new machine and powered up, albeit in degraded
>> mode.  I'd appreciate some advice re rebuilding this array (by adding
>> back the drive in question).  I've set out below pertinent info
>> relating to the array and hard drives in the system as well as my
>> intended recovery strategy.  As can be seen from lsblk, /dev/sdb1 is
>> the drive that is no longer recognised as being part of the array.  It
>> has not been written to since the incident occurred.  Is there a quick
>> & easy to reintegrate it into the array or is my only option to run:
>> # mdadm /dev/md0 --add /dev/sdb1
>>
>> and let it take its course?
>>
>> The machine has a 3.5Ghz i3 CPU and currently has 8GB ram installed, I
>> can swap out the 4GB chips and replace with 8GB chips if 16GB RAM will
>> significantly increase the rebuild speed.  I'd also like to speed up
>> the rebuild as far as possible, so my plan is to set the following
>> parameters, (but I've no idea what safe numbers would be).
>>
>> dev.raid.speed_limit_min =
>> dev.raid.speed_limit_max =
>>
>> Current values are:
>> # sysctl dev.raid.speed_limit_min
>> dev.raid.speed_limit_min = 1000
>> # sysctl dev.raid.speed_limit_max
>> dev.raid.speed_limit_max = 200000
>>
>> Set readahead:
>> # blockdev --setra 65536 /dev/md0
>>
>> Set stripe_cache_size to 32 MiB:
>> # echo 32768 > /sys/block/md0/md/stripe_cache_size
>>
>> Turn on bitmaps:
>> # mdadm --grow --bitmap=internal /dev/md0
>>
>> Rebuild the array by reintegrating /dev/sdb1:
>> # mdadm /dev/md0 --add /dev/sdb1
>>
>> Turn off bitmaps after rebuild is completed:
>> # mdadm --grow --bitmap=none /dev/md0
>>
>>
>> Thanks for your time and patience.
>>
>>
>> Current Array and hardware stats:
>> -------------------------------------------------
>>
>> # mdadm --detail /dev/md0
>> /dev/md0:
>>         Version : 1.2
>>   Creation Time : Thu Apr 17 01:13:52 2014
>>      Raid Level : raid5
>>      Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
>>   Used Dev Size : 2930134016 (2794.39 GiB 3000.46 GB)
>>    Raid Devices : 5
>>   Total Devices : 4
>>     Persistence : Superblock is persistent
>>
>>   Intent Bitmap : Internal
>>
>>     Update Time : Tue Jun  3 17:38:15 2014
>>           State : active, degraded
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>            Name : audioliboffsite:0  (local to host audioliboffsite)
>>            UUID : aba348c6:8dc7b4a7:4e282ab5:40431aff
>>          Events : 11314
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       0        0        0      removed
>>        1       8       65        1      active sync   /dev/sde1
>>        2       8       81        2      active sync   /dev/sdf1
>>        3       8       33        3      active sync   /dev/sdc1
>>        5       8       49        4      active sync   /dev/sdd1
>>
>> # lsblk -i
>> NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
>> sda       8:0    1  7.5G  0 disk
>> |-sda1    8:1    1  512M  0 part  /boot
>> `-sda2    8:2    1    7G  0 part  /
>> sdb       8:16   0  2.7T  0 disk
>> `-sdb1    8:17   0  2.7T  0 part
>> sdc       8:32   0  2.7T  0 disk
>> `-sdc1    8:33   0  2.7T  0 part
>>   `-md0   9:0    0 10.9T  0 raid5
>> sdd       8:48   0  2.7T  0 disk
>> `-sdd1    8:49   0  2.7T  0 part
>>   `-md0   9:0    0 10.9T  0 raid5
>> sde       8:64   0  2.7T  0 disk
>> `-sde1    8:65   0  2.7T  0 part
>>   `-md0   9:0    0 10.9T  0 raid5
>> sdf       8:80   0  2.7T  0 disk
>> `-sdf1    8:81   0  2.7T  0 part
>>   `-md0   9:0    0 10.9T  0 raid5
>>
>>
>>
>>
>>
>>
>>
>> I've answered your questions below as best I can:
>>
>>>> Any idea what would cause constant writing - I presume from what I see that the initial array sync completed?--
>>>
>>> Hmmm...
>>> Do the numbers in /proc/diskstats change?
>>>
>>>   watch -d 'grep md0 /proc/diskstats'
>>
>>
>> Nope, they remain constant
>>
>>
>>> What is in /sys/block/md0/md/safe_mode_delay?
>>
>> 0.203 is the value at present - I can try changing it afrter
>> rebuilding the array.
>>
>>
>>> What if you change that to a different number (it is in seconds and can be
>>> fractional)?
>>>
>>> What  kernel version (uname -a)?
>>
>> 3.14.6-1-ARCH #1 SMP PREEMPT Sun Jun 8 10:08:38 CEST 2014 x86_64 GNU/Linux
