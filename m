From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: My MD is too big to resize ext4.
Date: Sun, 9 Jul 2017 18:09:31 -0500
Message-ID: <a25d982f-0ea3-9f03-4040-a533c1d845a6@gmail.com>
References: <6c827d07-19d8-017b-ca95-5e6f84b7821a@gmail.com>
 <20170708065040.GA3682@metamorpher.de>
 <ae47b321-07d1-2157-c217-844447e51ce2@gmail.com>
 <20170708194427.GA15208@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170708194427.GA15208@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/08/2017 02:44 PM, Andreas Klauer wrote:
> On Sat, Jul 08, 2017 at 01:12:11PM -0500, Ram Ramesh wrote:
>>      1. My MD uses partitions sd{b,c,d,e,f,g}1 instead of full disks. So
>> I can create partitions on the drive instead of on the MD.
>>      2. This means I need to shrink my current md device to smaller size
>> (say 12TB-14TB) - need to check my current
>>            active ext4 data size. It is definitely less than 16TB.
>>      3. Repartition the disks to create sd{b-g}2 for the reamining unused
>> 6xnTB area.
>>      4. Created md1 with sd{b-g]2 to get md1.
>>      5. Mount and use md1.
> Should work; you have to shrink the filesystem first, (or stick to
> whatever size it has now), then the md, then the partition.
>
> What makes this risky is that you have to pick the correct sizes.
> When growing you can't go wrong. When shrinking, you have to be
> careful not to shrink too much. Filesystems don't like it at all
> if their end is missing, and md doesn't like it if the block device
> is smaller than what it says in the metadata.
>
> So you have to determine the exact filesystem size (tune2fs -l),
> and take mdadm data offsets into account.
>
> Not necessary if you know what you're doing but if in doubt,
> you can leave a safety margin with each of these steps.
>
> Regards
> Andreas Klauer
I already shrunk ext4 and md as they can be done without having to boot 
to a rescue disk. I like to do the last step of partitioning disk using 
a rescue disk.

Here is my partition table on one disk (they all are very similar or 
identical - each is a 6TB enterprise disk)
> zym [rramesh] 431 > sudo gdisk -l /dev/sdb
> GPT fdisk (gdisk) version 0.8.8
>
>
> Partition table scan:
>   MBR: protective
>   BSD: not present
>   APM: not present
>   GPT: present
>
> Found valid GPT with protective MBR; using GPT.
> Disk /dev/sdb: 11721045168 sectors, 5.5 TiB
> Logical sector size: 512 bytes
> Disk identifier (GUID): D5C9B768-D2E5-4DEE-8D89-73A7B631FE28
> Partition table holds up to 128 entries
> First usable sector is 34, last usable sector is 11721045134
> Partitions will be aligned on 2048-sector boundaries
> Total free space is 2014 sectors (1007.0 KiB)
>
> Number  Start (sector)    End (sector)  Size       Code  Name
>    1            2048     11721045134   5.5 TiB     FD00  Linux RAID
>
Here is mdadm -E on the same disk
> zym [rramesh] 430 > sudo mdadm -E /dev/sdb1
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
>  Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
>      Array Size : 12348030976 (11776.00 GiB 12644.38 GB)
>   Used Dev Size : 6174015488 (2944.00 GiB 3161.10 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 2a844ae2:4b028cc3:36095185:7b09f7cc
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Sun Jul  9 17:55:51 2017
>        Checksum : 74d5464 - correct
>          Events : 290897
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>    Device Role : Active device 4
>    Array State : AAAAAA ('A' == active, '.' == missing)

I am guessing anything more than 6174015488+2048 as the end sector for 
/dev/sdb1 should be ok with mdadm. Let me know if I am not calculating 
correctly.

I plan to set /dev/sd{b,c,d,e,f,g}1 to 3TB even (start = 2048, end = 
6442452991 size = 6442450944 sectors = 3072GiB)
to get a 12TB md0.

Ramesh


