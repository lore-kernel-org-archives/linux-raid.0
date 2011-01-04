From: "Patrick H." <linux-raid@feystorm.net>
Subject: Re: filesystem corruption
Date: Tue, 04 Jan 2011 10:31:56 -0700
Message-ID: <4D23598C.3040901@feystorm.net>
References: <4D212D4A.3040003@feystorm.net>	<20110103141603.632fdf3e@notabene.brown>	<4D214B5C.3010103@feystorm.net>	<20110103155630.565341d0@notabene.brown>	<4D215902.9010308@feystorm.net> <20110104163324.70baff54@notabene.brown> <4D22D14F.8070407@feystorm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D22D14F.8070407@feystorm.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sent: Tue Jan 04 2011 00:50:39 GMT-0700 (Mountain Standard Time)
From: Patrick H. <linux-raid@feystorm.net>
To: linux-raid@vger.kernel.org
Subject: Re: filesystem corruption
> Sent: Mon Jan 03 2011 22:33:24 GMT-0700 (Mountain Standard Time)
> From: NeilBrown <neilb@suse.de>
> To: Patrick H. <linux-raid@feystorm.net> linux-raid@vger.kernel.org
> Subject: Re: filesystem corruption
>> On Sun, 02 Jan 2011 22:05:06 -0700 "Patrick H." 
>> <linux-raid@feystorm.net>
>> wrote:
>>
>>  
>>> Ok, thanks for the info.
>>> I think I'll solve it by creating 2 dedicated hosts for running the 
>>> array, but not actually export any disks themselves. This way if a 
>>> master dies, all the raid disks are still there and can be picked up 
>>> by the other master.
>>>
>>>     
>>
>> That sounds like it should work OK.
>>
>> NeilBrown
>>   
> Well, it didnt solve it. if I power the entire cluster down and start 
> it back up, I get corruption, on old files that werent being modified 
> still. If I power off just a single node, it seems to handle it fine, 
> just not the whole cluster.
>
> It also seems to happen fairly frequently now. In the previous setup 
> it was probably 1 in 50 failures that there was corruption. Now its 
> pretty much a guarantee there will be corruption if I kill it.
> On the last failure I did, when it came back up, it re-assembled the 
> entire raid-5 array with all disks active and none of them needing any 
> sort of re-sync. The disk controller is battery backed, so even if it 
> was re-ordering the writes, the battery should ensure that it all gets 
> committed.
>
> Any other ideas?
>
> -Patrick
Here is some info from my most recent failure simulation. This one 
resulted in about 50 corrupt files, another 40 or so that cant even be 
opened, and one stale nfs file handle.
I had the cluster script dump out a bunch of info before and after 
assembling the array.

= = = = = = = = = =
# mdadm -E /dev/etherd/e1.1p1
/dev/etherd/e1.1p1:
Magic : a92b4efc
Version : 1.2
Feature Map : 0x1
Array UUID : 9cd9ae9b:39454845:62f2b08d:a4a1ac6c
Name : dm01:126  (local to host dm01)
Creation Time : Tue Jan  4 04:45:50 2011
Raid Level : raid5
Raid Devices : 3

Avail Dev Size : 2119520 (1035.10 MiB 1085.19 MB)
Array Size : 4238848 (2.02 GiB 2.17 GB)
Used Dev Size : 2119424 (1035.05 MiB 1085.15 MB)
Data Offset : 2048 sectors
Super Offset : 8 sectors
State : clean
Device UUID : a20adb76:af00f276:5be79a36:b4ff3a8b

Internal Bitmap : 2 sectors from superblock
Update Time : Tue Jan  4 16:45:56 2011
Checksum : 361041f6 - correct
Events : 486

Layout : left-symmetric
Chunk Size : 64K

Device Role : Active device 0
Array State : AAA ('A' == active, '.' == missing)



# mdadm -X /dev/etherd/e1.1p1
Filename : /dev/etherd/e1.1p1
Magic : 6d746962
Version : 4
UUID : 9cd9ae9b:39454845:62f2b08d:a4a1ac6c
Events : 486
Events Cleared : 486
State : OK
Chunksize : 64 KB
Daemon : 5s flush period
Write Mode : Normal
Sync Size : 1059712 (1035.05 MiB 1085.15 MB)
Bitmap : 16558 bits (chunks), 189 dirty (1.1%)
= = = = = = = = = =


= = = = = = = = = =
# mdadm -E /dev/etherd/e2.1p1
/dev/etherd/e2.1p1:
Magic : a92b4efc
Version : 1.2
Feature Map : 0x1
Array UUID : 9cd9ae9b:39454845:62f2b08d:a4a1ac6c
Name : dm01:126  (local to host dm01)
Creation Time : Tue Jan  4 04:45:50 2011
Raid Level : raid5
Raid Devices : 3

Avail Dev Size : 2119520 (1035.10 MiB 1085.19 MB)
Array Size : 4238848 (2.02 GiB 2.17 GB)
Used Dev Size : 2119424 (1035.05 MiB 1085.15 MB)
Data Offset : 2048 sectors
Super Offset : 8 sectors
State : clean
Device UUID : f9205ace:0796ecf5:2cca363c:c2873816

Internal Bitmap : 2 sectors from superblock
Update Time : Tue Jan  4 16:45:56 2011
Checksum : 9d235885 - correct
Events : 486

Layout : left-symmetric
Chunk Size : 64K

Device Role : Active device 1
Array State : AAA ('A' == active, '.' == missing)



# mdadm -X /dev/etherd/e2.1p1
Filename : /dev/etherd/e2.1p1
Magic : 6d746962
Version : 4
UUID : 9cd9ae9b:39454845:62f2b08d:a4a1ac6c
Events : 486
Events Cleared : 486
State : OK
Chunksize : 64 KB
Daemon : 5s flush period
Write Mode : Normal
Sync Size : 1059712 (1035.05 MiB 1085.15 MB)
Bitmap : 16558 bits (chunks), 189 dirty (1.1%)
= = = = = = = = = =


= = = = = = = = = =
# mdadm -E /dev/etherd/e3.1p1
/dev/etherd/e3.1p1:
Magic : a92b4efc
Version : 1.2
Feature Map : 0x1
Array UUID : 9cd9ae9b:39454845:62f2b08d:a4a1ac6c
Name : dm01:126  (local to host dm01)
Creation Time : Tue Jan  4 04:45:50 2011
Raid Level : raid5
Raid Devices : 3

Avail Dev Size : 2119520 (1035.10 MiB 1085.19 MB)
Array Size : 4238848 (2.02 GiB 2.17 GB)
Used Dev Size : 2119424 (1035.05 MiB 1085.15 MB)
Data Offset : 2048 sectors
Super Offset : 8 sectors
State : active
Device UUID : 7f90958d:22de5c08:88750ecb:5f376058

Internal Bitmap : 2 sectors from superblock
Update Time : Tue Jan  4 16:46:13 2011
Checksum : 3fce6b33 - correct
Events : 487

Layout : left-symmetric
Chunk Size : 64K

Device Role : Active device 2
Array State : AAA ('A' == active, '.' == missing)



# mdadm -X /dev/etherd/e3.1p1
Filename : /dev/etherd/e3.1p1
Magic : 6d746962
Version : 4
UUID : 9cd9ae9b:39454845:62f2b08d:a4a1ac6c
Events : 487
Events Cleared : 486
State : OK
Chunksize : 64 KB
Daemon : 5s flush period
Write Mode : Normal
Sync Size : 1059712 (1035.05 MiB 1085.15 MB)
Bitmap : 16558 bits (chunks), 249 dirty (1.5%)
= = = = = = = = = =



- - - - - - - - - - -
# mdadm -D /dev/md/fs01
/dev/md/fs01:
Version : 1.2
Creation Time : Tue Jan  4 04:45:50 2011
Raid Level : raid5
Array Size : 2119424 (2.02 GiB 2.17 GB)
Used Dev Size : 1059712 (1035.05 MiB 1085.15 MB)
Raid Devices : 3
Total Devices : 3
Persistence : Superblock is persistent

Intent Bitmap : Internal

Update Time : Tue Jan  4 16:46:13 2011
State : active, resyncing
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0

Layout : left-symmetric
Chunk Size : 64K

Rebuild Status : 1% complete

Name : dm01:126  (local to host dm01)
UUID : 9cd9ae9b:39454845:62f2b08d:a4a1ac6c
Events : 486

Number   Major   Minor   RaidDevice State
0     152      273        0      active sync   /dev/block/152:273
1     152      529        1      active sync   /dev/block/152:529
3     152      785        2      active sync   /dev/block/152:785
- - - - - - - - - - -



The old method *never* resulted in this much corruption, and never 
generated stale nfs file handles. Why is this so much worse now when it 
was supposed to be better?
