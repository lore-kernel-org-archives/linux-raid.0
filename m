From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Why can't I re-add my drive after partition shrink?
Date: Fri, 14 Jul 2017 19:17:54 -0500
Message-ID: <0341a04d-9aa5-7665-d9ff-527fe9fc8238@gmail.com>
References: <2ea5ed99-05b5-25d2-c9d4-8ce1f4945eaa@gmail.com>
 <87tw2f2425.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87tw2f2425.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/13/2017 08:35 PM, NeilBrown wrote:
> <snip
> Please report output of "mdadm --examine" on both a device that is active
> in the array, and the device that you are trying to add.
> Also "mdadm --examine-bitmap" of a device that is active in the array.
>
> NeilBrown
>
>> I researched as much as I could on the net and came up with nothing
>> except some one saying that mdadm keeps something at the end of the disk
>> regardless of what it says about "Used Dev Size." Is it possible to move
>> this info so that I could re-add?
>>
>> Ramesh
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Neil,

   Since the problem, I did not want to leave my md in degraded state. 
So, I added my drive back and paid the penalty for rebuilding. I have 
other disks that need to be resized and *can get you want*. Please let 
me know if that is what you meant. If  you wanted the current info after 
successfully rebuilding the array after a regular add, it is below.

First the device that is currently in after a regular add.
> zym [rramesh] 497 > sudo mdadm --examine /dev/sdb1
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 0e9f76b5:4a89171a:a930bccd:78749144
>            Name : zym:0  (local to host zym)
>   Creation Time : Mon Apr 22 00:08:12 2013
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 6442188800 (3071.88 GiB 3298.40 GB)
>      Array Size : 12348030976 (11776.00 GiB 12644.38 GB)
>   Used Dev Size : 6174015488 (2944.00 GiB 3161.10 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 702ca77d:564d69ff:e45d9679:64c314fa
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Fri Jul 14 18:36:37 2017
>        Checksum : c5502356 - correct
>          Events : 297182
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>    Device Role : Active device 4
>    Array State : AAAAAA ('A' == active, '.' == missing)

Member disk that has been in the array before /dev/sdb1 resize
> zym [rramesh] 498 > sudo mdadm --examine /dev/sdc1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 0e9f76b5:4a89171a:a930bccd:78749144
>            Name : zym:0  (local to host zym)
>   Creation Time : Mon Apr 22 00:08:12 2013
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
>      Array Size : 12348030976 (11776.00 GiB 12644.38 GB)
>   Used Dev Size : 6174015488 (2944.00 GiB 3161.10 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 7e035b56:d1e1882b:e78a08ad:3ba50667
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Fri Jul 14 18:36:37 2017
>        Checksum : a5288a4c - correct
>          Events : 297182
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>    Device Role : Active device 2
>    Array State : AAAAAA ('A' == active, '.' == missing)

Now examine bit map on /dev/sdb1 (device that got in after a regular add)
> zym [rramesh] 499 > sudo mdadm --examine-bitmap /dev/sdb1
>         Filename : /dev/sdb1
>            Magic : 6d746962
>          Version : 4
>             UUID : 0e9f76b5:4a89171a:a930bccd:78749144
>           Events : 297182
>   Events Cleared : 297182
>            State : OK
>        Chunksize : 64 MB
>           Daemon : 5s flush period
>       Write Mode : Normal
>        Sync Size : 3087007744 (2944.00 GiB 3161.10 GB)
>           Bitmap : 47104 bits (chunks), 0 dirty (0.0%)

Ramesh
