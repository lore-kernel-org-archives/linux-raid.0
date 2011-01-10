From: Christian Schmidt <charlie@digadd.de>
Subject: Re: What exactly does echo check > /sys/block/mdX/md/sync_action
 do?
Date: Mon, 10 Jan 2011 02:14:35 +0100
Message-ID: <4D2A5D7B.5080500@digadd.de>
References: <4D2A3B25.6050504@digadd.de>	<20110110102613.692fa2e3@notabene.brown>	<4D2A5297.6000601@digadd.de> <20110110114329.091d577c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110114329.091d577c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/10/2011 01:43 AM, NeilBrown wrote:
> On Mon, 10 Jan 2011 01:28:07 +0100 Christian Schmidt <charlie@digadd.de>
> wrote:
> 
> 
>>> This device thinks that that the array is functioning correctly with no
>>> failed devices, and that this device is a spare - presumably a 5th device?
>>> It doesn't know the names of the other devices (and if it thought it did, it
>>> could easily be wrong as names changed).  What do the other devices think of
>>> the state of the array?
>>
>> [~]>mdadm -Q --detail /dev/md3
>> /dev/md3:
>>         Version : 1.02
>>   Creation Time : Sat Jul 17 02:57:27 2010
>>      Raid Level : raid5
>>      Array Size : 5857390080 (5586.04 GiB 5997.97 GB)
>>   Used Dev Size : 1952463360 (1862.01 GiB 1999.32 GB)
>>    Raid Devices : 4
>>   Total Devices : 4
>>     Persistence : Superblock is persistent
>>
>>     Update Time : Mon Jan 10 00:38:00 2011
>>           State : clean, recovering
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>  Rebuild Status : 68% complete
>>
>>            Name : sysresccd:1
>>            UUID : fa8fb033:6312742f:0524501d:5aa24a28
>>          Events : 34
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8       34        0      active sync   /dev/sdc2
>>        1       8       50        1      active sync   /dev/sdd2
>>        2       8       82        2      active sync   /dev/sdf2
>>        4       8      114        3      active sync   /dev/sdh2
>>
>> So just "check" turns the array into rebuild mode and one of the drives
>> into a spare? That's unexpected.
> 
> I very much doubt writing "check" is all that happened.  Maybe seeing some
> kernel logs would help.  

Here they are:

[  235.503895] md: md3 stopped.
[  235.505428] md: bind<sdd2>
[  235.505557] md: bind<sdf2>
[  235.505673] md: bind<sdh2>
[  235.505804] md: bind<sdc2>
[  235.510288] md/raid:md3: device sdc2 operational as raid disk 0
[  235.510292] md/raid:md3: device sdh2 operational as raid disk 3
[  235.510294] md/raid:md3: device sdf2 operational as raid disk 2
[  235.510296] md/raid:md3: device sdd2 operational as raid disk 1
[  235.510569] md/raid:md3: allocated 4280kB
[  235.510604] md/raid:md3: raid level 5 active with 4 out of 4 devices,
algorithm 2
[  235.510607] RAID conf printout:
[  235.510609]  --- level:5 rd:4 wd:4
[  235.510611]  disk 0, o:1, dev:sdc2
[  235.510613]  disk 1, o:1, dev:sdd2
[  235.510614]  disk 2, o:1, dev:sdf2
[  235.510616]  disk 3, o:1, dev:sdh2
[  235.510652] md3: detected capacity change from 0 to 5997967441920
[  236.204947]  md3: unknown partition table
[ 1347.192343] md: data-check of RAID array md3
[ 1347.192346] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 1347.192347] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for data-check.
[ 1347.192352] md: using 128k window, over a total of 1952463360 blocks.

Actually I rebooted the machine after a kernel update, which turned out
to change the drive names (I left an unrelated drive in a hotswap bay).
Also, I had an erroneous /etc/mdadm.conf which was still referring to
the old drive naming. When I realized this drive array wasn't started I
completely renamed the config file and ran
mdadm -A --scan
after which the array was found. I have some issues opening crypto
volumes on the LVM though and tried to figure out whether I forgot the
key for one and never created the other, or something's wrong on the
underlying layer, so I started a check.

> What does
>    cat /proc/mdstat

It says:

md3 : active raid5 sdc2[0] sdh2[4] sdf2[2] sdd2[1]
      5857390080 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4]
[UUUU]
      [=================>...]  check = 85.3% (1667391744/1952463360)
finish=57.5min speed=82511K/sec

> show (assuming the check/recovery/whatever hasn't finished yet).
> It should say "recovering" as I think the key word is copied into the
> 'State:' line above.
> 
> But writing "check" should not cause any drive to become a 'spare', and
> should not trigger a 'rebuild' - just a 'check'.

Well... so what is this raid actually doing? mdstat says check, mdam -q
--detail says recovering, and mdadm --examine on one of the drives says
spare (while no spare are listed at any other point).

mdadm --examine:

/dev/sdc2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa8fb033:6312742f:0524501d:5aa24a28
           Name : sysresccd:1
  Creation Time : Sat Jul 17 02:57:27 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
     Array Size : 11714780160 (5586.04 GiB 5997.97 GB)
  Used Dev Size : 3904926720 (1862.01 GiB 1999.32 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 801bb0ab:256d6f57:7e53e467:62094362

    Update Time : Mon Jan 10 01:43:39 2011
       Checksum : 5f661441 - correct
         Events : 35

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)

/dev/sdd2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa8fb033:6312742f:0524501d:5aa24a28
           Name : sysresccd:1
  Creation Time : Sat Jul 17 02:57:27 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
     Array Size : 11714780160 (5586.04 GiB 5997.97 GB)
  Used Dev Size : 3904926720 (1862.01 GiB 1999.32 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : d14e0126:4c8be6cd:418165b2:24bba827

    Update Time : Mon Jan 10 01:43:39 2011
       Checksum : 6015453f - correct
         Events : 35

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing)

/dev/sdf2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa8fb033:6312742f:0524501d:5aa24a28
           Name : sysresccd:1
  Creation Time : Sat Jul 17 02:57:27 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
     Array Size : 11714780160 (5586.04 GiB 5997.97 GB)
  Used Dev Size : 3904926720 (1862.01 GiB 1999.32 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 3b8a4934:40a3270d:7e285e98:07aec354

    Update Time : Mon Jan 10 01:43:39 2011
       Checksum : c0b232bd - correct
         Events : 35

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing)

/dev/sdh2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa8fb033:6312742f:0524501d:5aa24a28
           Name : sysresccd:1
  Creation Time : Sat Jul 17 02:57:27 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
     Array Size : 11714780160 (5586.04 GiB 5997.97 GB)
  Used Dev Size : 3904926720 (1862.01 GiB 1999.32 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 172eb49b:03e62242:614d7ed3:1fb25f65

    Update Time : Mon Jan 10 01:43:39 2011
       Checksum : a8d4425a - correct
         Events : 35

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAA ('A' == active, '.' == missing)
