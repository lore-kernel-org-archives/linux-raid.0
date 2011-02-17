From: hansbkk@gmail.com
Subject: Re: old filesystem label remaining after partition --add 'ed?
Date: Thu, 17 Feb 2011 14:50:12 +0700
Message-ID: <AANLkTi=OVUYM4+TDVwB8FyCDK9GsWrv80EAWsNhA6HYu@mail.gmail.com>
References: <AANLkTikcYz+AYXQBm+BhcjM1SkvDnR=-x58jLbyGB+2d@mail.gmail.com>
	<4D5C00DA.2060300@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C00DA.2060300@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Feb 16, 2011 at 11:52 PM, Phil Turmel <philip@turmel.org> wrote:
> Ext2 and friends leave space for a boot block at the beginning, so the first ext2 superblock is 1k (?) into the partition.  The blkid library knows this, so it is looking "past" your md superblock and seeing the ext2 superblock.
>
> A careful dd of the right sectors should knock it out.  (You're going to verify all this first, I hope.)

No thanks, if it's not causing a problem 'll just leave it alone.

>> I replaced a RAID6 member drive that hadn't been fully zero'd, had the
>> same partitioning layout as the previous one.
>>
>> The target partition had previously had an ext3 filesystem on it for
>> temporary moving/copying files around, with an e2label on it.
>>
>> I added the partition to the array with "mdadm /dev/md_raid6a --add
>> /sde4", and let it rebuild, all looks good both via -D and
>> /proc/mdstat
>>
>> Later on, I noticed that that partition still has the e2label on it? I
>> know my RAID1's show the label same as if it's a regular partition,
>> but I've always got a "bad magic" message back from checking for a
>> label on a RAID5/6 array member partition.
>>
>> I'm assuming this is just cosmetic, but it bothers my (probably OCD)
>> sense of order, so I thought I'd check in here.
>>
>> I don't even know a command to remove an existing filesystem other
>> than zeroing out the MBR/partition table - and in this case I didn't
>> want to disturb data in the other partitions. I supposed I could have
>> formatted it as ntfs or something, but that doesn't seem right.
>
> I'm going to guess that your array has v1.1 metadata.  If so, a fragment of your old filesystem still exists between the end of the MD superblock and the beginning of the data area.  MD's bitmaps are supposed to live in that area, so I'm going to guess that you aren't using an internal bitmap.  An 'mdadm -E' for that partition would help.

Well, got something strange there. First here's a -D on the array:

When I originally created the array (using sysresccd) I spec'd v1.2
metadata. However the production filer OS uses mdadm v2.6.4, so it
might have got downgraded in later recovery operations?

[root@sannas01 ~]# mdadm -D /dev/md_raid6a
/dev/md_raid6a:
        Version : 01.02.03
  Creation Time : Wed Dec 22 08:21:09 2010
     Raid Level : raid6
     Array Size : 7199998976 (6866.45 GiB 7372.80 GB)
  Used Dev Size : 3599999488 (1716.61 GiB 1843.20 GB)
   Raid Devices : 6
  Total Devices : 7
Preferred Minor : 125
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Feb 17 04:02:19 2011
          State : active
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1

     Chunk Size : 256K

           Name : sannas01:raid6a
           UUID : 628ddb50:a718c3dc:bd53d3e3:51eb73ca
         Events : 235750

    Number   Major   Minor   RaidDevice State
       0       8        4        0      active sync   /dev/sda4
       6       8       20        1      active sync   /dev/sdb4
       2       8       36        2      active sync   /dev/sdc4
       3       8       52        3      active sync   /dev/sdd4
       7       8       68        4      active sync   /dev/sde4
       5       8       84        5      active sync   /dev/sdf4

       8       8      164        -      spare   /dev/sdk4


When I do an -E on *any* of the members I get:

[root@sannas01 ~]# mdadm -E /dev/sde4
/dev/sde4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 628ddb50:a718c3dc:bd53d3e3:51eb73ca
           Name : sannas01:raid6a
  Creation Time : Wed Dec 22 08:21:09 2010
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 3599999729 (1716.61 GiB 1843.20 GB)
     Array Size : 14399997952 (6866.45 GiB 7372.80 GB)
  Used Dev Size : 3599999488 (1716.61 GiB 1843.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : b8deffce:73f5296e:b9f17f4d:7373900c

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Feb 17 14:19:59 2011
       Checksum : 6c94eb57 - correct
         Events : 235750

     Chunk Size : 256K

    Array Slot : 7 (0, failed, 2, 3, failed, 5, 1, 4, empty, failed,
failed, fled, failed, failed, failed, failed, failed, failed, failed,
failed, failed, fled, failed, failed, failed, failed, failed, failed,
failed, failed, failed, fled, failed, failed, failed, failed, failed,
failed, failed, failed, failed, fled, failed, failed, failed, failed,
failed, failed, failed, failed, failed, fled, failed, failed, failed,
failed, failed, failed, failed, failed, failed, fled, failed, failed,
failed, failed, failed, failed, failed, failed, failed, f

with many many more - note the "fled"s mixed in with the "failed"'s.

I wasn't worried before but I am now - should I be?

In case it means anything (sde's the recent replacement):

[root@sannas01 ~]# e2label /dev/sdd4
e2label: Bad magic number in super-block while trying to open /dev/sdd4
Couldn't find valid filesystem superblock.

[root@sannas01 ~]# e2label /dev/sde4
tmp-hita
