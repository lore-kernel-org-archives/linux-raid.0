From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: Why can't I re-add my drive after partition shrink?
Date: Fri, 14 Jul 2017 00:37:26 +0100
Message-ID: <3774c1cf-563c-bd03-4e57-15cbe0cd7fb3@youngman.org.uk>
References: <2ea5ed99-05b5-25d2-c9d4-8ce1f4945eaa@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2ea5ed99-05b5-25d2-c9d4-8ce1f4945eaa@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/07/17 00:17, Ram Ramesh wrote:
> I am trying to shring my mdadm underlying disks/partitions as a way of 
> reclaiming space after md shrink operation. Here is my md
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
>> [raid4] [raid10]
>> md0 : active raid6 sdb1[6] sdg1[11] sdd1[12] sdf1[8] sde1[9] sdc1[10]
>>       12348030976 blocks super 1.2 level 6, 64k chunk, algorithm 2 
>> [6/6] [UUUUUU]
>>       bitmap: 2/23 pages [8KB], 65536KB chunk
>>
>> unused devices: <none>
> 
> Here is my mdadm detail about /dev/sdb1
>> Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
>>      Array Size : 12348030976 (11776.00 GiB 12644.38 GB)
>>   Used Dev Size : 6174015488 (2944.00 GiB 3161.10 GB)
> I fail, remove and repartition /dev/sdb1 so that new partition table 
> looks like this. (No change to data obviously)
>>    New partition table:
>>    Number  Start (sector)    End (sector)  Size       Code  Name
>>        1            2048      6442452991   3.0 TiB     FD00  Linux RAID
>>        2      6442452992     11721045134   2.5 TiB     FD00  Linux RAID
> 
> Since new /dev/sdb1 is significantly bigger than what mdadm says that it 
> is using, I thought I could simply re-add the drive. However, I get
>> sudo mdadm /dev/md0 --re-add /dev/sdb1
>> ***mdadm: --re-add for /dev/sdb1 to /dev/md0 is not possible***
> Why? What did I miss here? Is it possible to fix this so that I can 
> repartition other drives and -re-add them without having to go through 
> full rebuild after each change?
> 
> I researched as much as I could on the net and came up with nothing 
> except some one saying that mdadm keeps something at the end of the disk 
> regardless of what it says about "Used Dev Size." Is it possible to move 
> this info so that I could re-add?
> 
I can't say why it won't re-add, but what's at the end of the disk is 
the superblock - except it isn't at the end. The 0.9, or v1.0, 
superblocks are at the end, but you've got a v1.2 superblock which is 
stored at the start - to be precise, 4K in from the front of the partition.

Cheers,
Wol
