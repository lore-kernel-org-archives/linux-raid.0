From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 15:49:16 +0200
Message-ID: <9fcdece2-68b7-8e5b-5995-caf15af18bf3@powerlamerz.org>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <20170423101639.GA4471@metamorpher.de>
 <37269c2b-1788-a0b6-6d91-84c6b6bdd16c@powerlamerz.org>
 <20170423104606.GA4603@metamorpher.de>
 <754209bb-9990-2a36-2233-d7d1273c8e37@powerlamerz.org>
 <20170423131605.GA9955@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170423131605.GA9955@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/23/2017 03:16 PM, Andreas Klauer wrote:
> On Sun, Apr 23, 2017 at 01:12:54PM +0200, Patrik Dahlström wrote:
>> I got some of that!
> 
>> [    3.100700] RAID conf printout:
>> [    3.100700]  --- level:5 rd:5 wd:5
>> [    3.100700]  disk 0, o:1, dev:sda
>> [    3.100700]  disk 1, o:1, dev:sdb
>> [    3.100701]  disk 2, o:1, dev:sdd
>> [    3.100701]  disk 3, o:1, dev:sdc
>> [    3.100701]  disk 4, o:1, dev:sde
>> [    3.101006] created bitmap (44 pages) for device md1
>> [    3.102245] md1: bitmap initialized from disk: read 3 pages, set 0 of
>> 89423 bits
>> [    3.159019] md1: detected capacity change from 0 to 24004163272704
> 
> Fairly standard, RAID5, presumably 1.2 metadata with 128M data offset, 
> which is the default mdadm uses lately. Older RAIDs would have smaller 
> data offsets.
> 
> So... ...the output above really is from before any of your accidents?
Yes, it is from before adding /dev/sdf and starting a reshape

> How old is your raid ...?
The raid is roughly 1 year old. It started as a combination of raids:
md0: 4x2TB raid5
md1: 2x6TB + md0 raid5

A few months after that, md0 was replaced with a 6 TB drive (/dev/sdd).
Last august I added /dev/sde and this january I added /dev/sde.
Yesterday I tried to add /dev/sdf.

> 
> Tested with loop devices:
> 
> # truncate -s 6001175126016 0 1 2 3 4
> # losetup --find --show
> # mdadm --create /dev/md42 --assume-clean --data-offset=128M --level=5 --raid-devices=5 /dev/loop[01234]

> 
> | [14580.373999] md/raid:md42: device loop4 operational as raid disk 4
> | [14580.373999] md/raid:md42: device loop3 operational as raid disk 3
> | [14580.374000] md/raid:md42: device loop2 operational as raid disk 2
> | [14580.374000] md/raid:md42: device loop1 operational as raid disk 1
> | [14580.374001] md/raid:md42: device loop0 operational as raid disk 0
> | [14580.374308] md/raid:md42: raid level 5 active with 5 out of 5 devices, algorithm 2
> | [14580.377043] md42: detected capacity change from 0 to 24004163272704
> 
> (Results in identical capacity as yours so it's the most likely match.)
> 
> Again, you'd do this with overlays only...
I did
$ mdadm --create /dev/md1 --assume-clean --data-offset=128M --level=5 --raid-devices=5 /dev/mapper/sd[abdce]
$ dmesg | tail
[10079.442770] md: bind<dm-2>
[10079.442835] md: bind<dm-5>
[10079.442889] md: bind<dm-1>
[10079.442954] md: bind<dm-3>
[10079.443015] md: bind<dm-4>
[10079.443814] md/raid:md1: device dm-4 operational as raid disk 4
[10079.443815] md/raid:md1: device dm-3 operational as raid disk 3
[10079.443816] md/raid:md1: device dm-1 operational as raid disk 2
[10079.443830] md/raid:md1: device dm-5 operational as raid disk 1
[10079.443830] md/raid:md1: device dm-2 operational as raid disk 0
[10079.444123] md/raid:md1: allocated 5432kB
[10079.444168] md/raid:md1: raid level 5 active with 5 out of 5 devices, algorithm 2
[10079.444169] RAID conf printout:
[10079.444170]  --- level:5 rd:5 wd:5
[10079.444171]  disk 0, o:1, dev:dm-2
[10079.444171]  disk 1, o:1, dev:dm-5
[10079.444172]  disk 2, o:1, dev:dm-1
[10079.444173]  disk 3, o:1, dev:dm-3
[10079.444173]  disk 4, o:1, dev:dm-4
[10079.444237] created bitmap (44 pages) for device md1
[10079.446272] md1: bitmap initialized from disk: read 3 pages, set 89423 of 89423 bits
[10079.451821] md1: detected capacity change from 0 to 24004163272704
$ mdadm --detail /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Sun Apr 23 15:40:15 2017
     Raid Level : raid5
     Array Size : 23441565696 (22355.62 GiB 24004.16 GB)
  Used Dev Size : 5860391424 (5588.90 GiB 6001.04 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sun Apr 23 15:40:15 2017
          State : clean 
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : rack-server-1:1  (local to host rack-server-1)
           UUID : 6beee843:59371bd6:c9278c83:1eb89111
         Events : 0

    Number   Major   Minor   RaidDevice State
       0     252        2        0      active sync   /dev/dm-2
       1     252        5        1      active sync   /dev/dm-5
       2     252        1        2      active sync   /dev/dm-1
       3     252        3        3      active sync   /dev/dm-3
       4     252        4        4      active sync   /dev/dm-4

$ mount /dev/md1 /storage
mount: wrong fs type, bad option, bad superblock on /dev/md1,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

Still no luck. Was the drives added in the wrong order?

> 
> Regards
> Andreas Klauer
> 
