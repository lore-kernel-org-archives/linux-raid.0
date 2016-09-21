From: Simon Becks <beckssimon5@gmail.com>
Subject: Re: restore 3disk raid5 after raidpartitions have been setup with xfs
 filesystem by accident
Date: Wed, 21 Sep 2016 22:41:32 +0200
Message-ID: <CAKA=zHoKE69Q01oEVOCpKWzp6gQ7zO8rvY=NzuD0YoqLJdgTTQ@mail.gmail.com>
References: <CAKA=zHqbFv_RQvyR4o4HPS2UrP4xrRWLiy2nR+gudDguk+JLog@mail.gmail.com>
 <CAJCQCtR4NoCebcDLD-ovT+hZY=NKRtj1cP693wHQTbmiERDAXw@mail.gmail.com>
 <CAKA=zHpgVoNA5Y6MBmB4fnG85F-z=hj4FXEiUOggsWUn3tfWXg@mail.gmail.com>
 <20160921171511.GA6381@metamorpher.de> <CAKA=zHq7OgZ+oVAqn7zVmBM0gSQedNk2kZ3dkuBG7V89G-G3Rg@mail.gmail.com>
 <20160921180318.GA6633@metamorpher.de> <CAKA=zHoJu2vTXQa4yvbJDA2nmQwXLHyw2DfUJ+cVgTDr_gu2XQ@mail.gmail.com>
 <20160921190035.GA6949@metamorpher.de> <CAKA=zHryc+hqie_VZDsU4HGQP9Cw7Oo_J3S4mjJHyZbGX1K1PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKA=zHryc+hqie_VZDsU4HGQP9Cw7Oo_J3S4mjJHyZbGX1K1PA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Becks <beckssimon5@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

So the old disk i removed 2 month ago reports

/dev/loop1: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)

So the filesystem on the raid is/was XFS.  gave xfs_repair a shot but
it segfaults:

i guess thats good, that it found at least the superblock?

root@grml ~ # xfs_repair /dev/md42
Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!

attempting to find secondary superblock...
...........................................
found candidate secondary superblock...
unable to verify superblock, continuing...
found candidate secondary superblock...
error reading superblock 22 -- seek to offset 2031216754688 failed
unable to verify superblock, continuing...
found candidate secondary superblock...
unable to verify superblock, continuing...
..found candidate secondary superblock...
verified secondary superblock...
writing modified primary superblock
        - reporting progress in intervals of 15 minutes
sb root inode value 18446744073709551615 (NULLFSINO) inconsistent with
calculated value 2048
resetting superblock root inode pointer to 2048
sb realtime bitmap inode 18446744073709551615 (NULLFSINO) inconsistent
with calculated value 2049
resetting superblock realtime bitmap ino pointer to 2049
sb realtime summary inode 18446744073709551615 (NULLFSINO)
inconsistent with calculated value 2050
resetting superblock realtime summary ino pointer to 2050
Phase 2 - using internal log
        - zero log...
totally zeroed log
        - scan filesystem freespace and inode maps...
bad magic number
bad magic number
bad magic number
Metadata corruption detected at block 0x8/0x1000
bad magic number
Metadata corruption detected at block 0x23d3f408/0x1000
bad magic numberbad magic number

Metadata corruption detected at block 0x2afe5808/0x1000
bad magic number
bad magic number
bad magic number
bad magic number
bad magic number
bad magic number
bad magic number
bad magic number
bad magic number
bad magic number
bad magic number
bad magic number
bad magic number
Metadata corruption detected at block 0x10/0x1000
Metadata corruption detected at block 0xe54c808/0x1000
bad magic # 0x494e81f6 for agf 0
bad version # 16908289 for agf 0
bad sequence # 99 for agf 0
bad length 99 for agf 0, should be 15027328
flfirst 1301384768 in agf 0 too large (max = 1024)
bad magic # 0x494e81f6 for agi 0
bad version # 16908289 for agi 0
bad sequence # 99 for agi 0
bad length # 99 for agi 0, should be 15027328
reset bad agf for ag 0
reset bad agi for ag 0
Metadata corruption detected at block 0xd6f7b808/0x1000
Metadata corruption detected at block 0x2afe5810/0x1000
bad on-disk superblock 6 - bad magic number
primary/secondary superblock 6 conflict - AG superblock geometry info
conflicts with filesystem geometry
zeroing unused portion of secondary superblock (AG #6)
[1]    23110 segmentation fault  xfs_repair /dev/md42
xfs_repair /dev/md42



2016-09-21 21:50 GMT+02:00 Simon Becks <beckssimon5@gmail.com>:
> Thank you. I already learned a lot. Your command only shows data for
> all of the 3 disks.
>
> Out of curiosity i used strings /dev/loop42 | grep mp3 and many of my
> songs showed up - is that a good sign?
>
> Just tried the 5 orders like a,b,c a,c,b and so on and receive the
> same output about mount: wrong fs type, bad option, bad superblock on
> /dev/md42 and fsck.ext2: Superblock invalid, trying backup blocks....
>
> Then used photorec in all 5 combinations of disks for several minutes
> without a single file found.
>
> Is it possible that i have to keep something else in mind, while
> assembling the raid? I expected at least some files with photorec when
> the raid was assembled in the right order.
>
>
> 2016-09-21 21:00 GMT+02:00 Andreas Klauer <Andreas.Klauer@metamorpher.de>:
>> On Wed, Sep 21, 2016 at 08:31:23PM +0200, Simon Becks wrote:
>>> Maybe i just assembled it in the wrong order?
>>
>> Yes, or maybe the superblock was overwritten by XFS after all.
>>
>> You could check what's at offset 1M for each disk.
>>
>> losetup --find --show --read-only --offset=$((2048*512)) /the/disk
>> file -s /dev/loop42
>>
>> If the superblock was still intact it should say ext4 or whatever
>> your filesystem was for at least one of them.
>>
>> You can also try this for the disk you removed 2 month ago.
>>
>> If that is not the case and fsck with backup superblock also
>> is not successful then you'll have to see if you find anything
>> valid in the raw data.
>>
>> Regards
>> Andreas Klauer
