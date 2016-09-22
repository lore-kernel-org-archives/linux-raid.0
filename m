From: Simon Becks <beckssimon5@gmail.com>
Subject: Re: restore 3disk raid5 after raidpartitions have been setup with xfs
 filesystem by accident
Date: Thu, 22 Sep 2016 07:46:13 +0200
Message-ID: <CAKA=zHpdAt9g6fwpFfSkusem_GM2exf3uDRzRcO8K0JiGmAdPA@mail.gmail.com>
References: <CAKA=zHqbFv_RQvyR4o4HPS2UrP4xrRWLiy2nR+gudDguk+JLog@mail.gmail.com>
 <CAJCQCtR4NoCebcDLD-ovT+hZY=NKRtj1cP693wHQTbmiERDAXw@mail.gmail.com>
 <CAKA=zHpgVoNA5Y6MBmB4fnG85F-z=hj4FXEiUOggsWUn3tfWXg@mail.gmail.com>
 <20160921171511.GA6381@metamorpher.de> <CAKA=zHq7OgZ+oVAqn7zVmBM0gSQedNk2kZ3dkuBG7V89G-G3Rg@mail.gmail.com>
 <20160921180318.GA6633@metamorpher.de> <CAKA=zHoJu2vTXQa4yvbJDA2nmQwXLHyw2DfUJ+cVgTDr_gu2XQ@mail.gmail.com>
 <20160921190035.GA6949@metamorpher.de> <CAKA=zHryc+hqie_VZDsU4HGQP9Cw7Oo_J3S4mjJHyZbGX1K1PA@mail.gmail.com>
 <CAKA=zHoKE69Q01oEVOCpKWzp6gQ7zO8rvY=NzuD0YoqLJdgTTQ@mail.gmail.com>
 <CAJCQCtSE1m4k_zpQxa59fZ8CK6biFSX0AUPkKCTUkNLT5y+MSA@mail.gmail.com> <CAKA=zHr-dwudU5bENHF_3QSG9vYi4Tib8Sg2Jq_rfqOjuF7vew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKA=zHr-dwudU5bENHF_3QSG9vYi4Tib8Sg2Jq_rfqOjuF7vew@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Becks <beckssimon5@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Measured now the time it takes to find the superblock with xfs_repair
in all combinations of disk order.

Fastest in 5 minutes in order sda,sdb,sdc but got error reading superblock 22 --
Seek to offset 2031216754688 failed

Superblock 22 is the the superblock it was found in 3 orders out of 6.

So i assumed, the fastest hit might be right one and started photorec on it:

Photorec only found

txt: 38 recovered
gif: 1 recovered

Gif was several gigabyte big and is not a real picture. The text files
are all smaller than 4K and only contain ps aux output of the nas.

Seems like i still do not have the right order of the disks? But it
looks identically to me:

/dev/mapper/sdb6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : da61174d:9567c4df:fcea79f1:38024893
           Name : grml:42  (local to host grml)
  Creation Time : Thu Sep 22 05:14:11 2016
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 1923497952 (917.20 GiB 984.83 GB)
     Array Size : 1923496960 (1834.39 GiB 1969.66 GB)
  Used Dev Size : 1923496960 (917.19 GiB 984.83 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1960 sectors, after=992 sectors
          State : clean
    Device UUID : d0c61415:186b446b:ca34a8c6:69ed5b18

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Sep 22 05:14:11 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : bba25a31 - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0

/dev/sde6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 342ec726:3804270d:5917dd5f:c24883a9
           Name : TS-XLB6C:2
  Creation Time : Fri Dec 23 17:58:59 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 1923497952 (917.20 GiB 984.83 GB)
     Array Size : 1923496960 (1834.39 GiB 1969.66 GB)
  Used Dev Size : 1923496960 (917.19 GiB 984.83 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=992 sectors
          State : active
    Device UUID : d27a69d0:456f3704:8e17ac75:78939886

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jul 27 19:08:08 2016
       Checksum : de9dbd10 - correct
         Events : 11543

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)

Now testing photorec with the other orders.

2016-09-21 23:30 GMT+02:00 Simon Becks <beckssimon5@gmail.com>:
> I tried all possible orders but xfs_repair found in no round instantly
> a superblock or did the repair with flying colors.
>
> sda,sdb,sdc
> sda,sdc,sdb
> sdc,sda,sdb
> sdb,sda,sdc
> sdc,sdb,sda
> sdb,sdc,sda
>
>
> will give photorec a try and go to bed for now :/
>
> 2016-09-21 23:07 GMT+02:00 Chris Murphy <lists@colorremedies.com>:
>> On Wed, Sep 21, 2016 at 2:41 PM, Simon Becks <beckssimon5@gmail.com> wrote:
>>> So the old disk i removed 2 month ago reports
>>>
>>> /dev/loop1: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)
>>>
>>> So the filesystem on the raid is/was XFS.  gave xfs_repair a shot but
>>> it segfaults:
>>>
>>> i guess thats good, that it found at least the superblock?
>>
>> There's more than one and they're spread across the array. So it's
>> possible you got the first device order correct, so it finds a
>> superblock there, but then when it goes to the next position the drive
>> is out of order so it gets confused.
>>
>> To me this sounds like one drive is in the correct position but the
>> two others are reversed. But I'm not an XFS expert you'd have to ask
>> on their list.
>>
>>
>>
>>>
>>> root@grml ~ # xfs_repair /dev/md42
>>> Phase 1 - find and verify superblock...
>>> bad primary superblock - bad magic number !!!
>>>
>>> attempting to find secondary superblock...
>>> ...........................................
>>> found candidate secondary superblock...
>>> unable to verify superblock, continuing...
>>> found candidate secondary superblock...
>>> error reading superblock 22 -- seek to offset 2031216754688 failed
>>> unable to verify superblock, continuing...
>>> found candidate secondary superblock...
>>> unable to verify superblock, continuing...
>>> ..found candidate secondary superblock...
>>> verified secondary superblock...
>>> writing modified primary superblock
>>>         - reporting progress in intervals of 15 minutes
>>> sb root inode value 18446744073709551615 (NULLFSINO) inconsistent with
>>> calculated value 2048
>>> resetting superblock root inode pointer to 2048
>>> sb realtime bitmap inode 18446744073709551615 (NULLFSINO) inconsistent
>>
>> Those big ones strike me as imaginary numbers.
>>
>>> with calculated value 2049
>>> resetting superblock realtime bitmap ino pointer to 2049
>>> sb realtime summary inode 18446744073709551615 (NULLFSINO)
>>> inconsistent with calculated value 2050
>>> resetting superblock realtime summary ino pointer to 2050
>>> Phase 2 - using internal log
>>>         - zero log...
>>> totally zeroed log
>>>         - scan filesystem freespace and inode maps...
>>> bad magic number
>>> bad magic number
>>> bad magic number
>>> Metadata corruption detected at block 0x8/0x1000
>>> bad magic number
>>> Metadata corruption detected at block 0x23d3f408/0x1000
>>> bad magic numberbad magic number
>>>
>>> Metadata corruption detected at block 0x2afe5808/0x1000
>>> bad magic number
>>> bad magic number
>>> bad magic number
>>> bad magic number
>>> bad magic number
>>> bad magic number
>>> bad magic number
>>> bad magic number
>>> bad magic number
>>> bad magic number
>>> bad magic number
>>> bad magic number
>>> bad magic number
>>> Metadata corruption detected at block 0x10/0x1000
>>> Metadata corruption detected at block 0xe54c808/0x1000
>>> bad magic # 0x494e81f6 for agf 0
>>> bad version # 16908289 for agf 0
>>> bad sequence # 99 for agf 0
>>> bad length 99 for agf 0, should be 15027328
>>> flfirst 1301384768 in agf 0 too large (max = 1024)
>>> bad magic # 0x494e81f6 for agi 0
>>> bad version # 16908289 for agi 0
>>> bad sequence # 99 for agi 0
>>> bad length # 99 for agi 0, should be 15027328
>>> reset bad agf for ag 0
>>> reset bad agi for ag 0
>>> Metadata corruption detected at block 0xd6f7b808/0x1000
>>> Metadata corruption detected at block 0x2afe5810/0x1000
>>> bad on-disk superblock 6 - bad magic number
>>> primary/secondary superblock 6 conflict - AG superblock geometry info
>>> conflicts with filesystem geometry
>>> zeroing unused portion of secondary superblock (AG #6)
>>> [1]    23110 segmentation fault  xfs_repair /dev/md42
>>> xfs_repair /dev/md42
>>>
>>>
>>>
>>> 2016-09-21 21:50 GMT+02:00 Simon Becks <beckssimon5@gmail.com>:
>>>> Thank you. I already learned a lot. Your command only shows data for
>>>> all of the 3 disks.
>>>>
>>>> Out of curiosity i used strings /dev/loop42 | grep mp3 and many of my
>>>> songs showed up - is that a good sign?
>>>>
>>>> Just tried the 5 orders like a,b,c a,c,b and so on and receive the
>>>> same output about mount: wrong fs type, bad option, bad superblock on
>>>> /dev/md42 and fsck.ext2: Superblock invalid, trying backup blocks....
>>>>
>>>> Then used photorec in all 5 combinations of disks for several minutes
>>>> without a single file found.
>>>>
>>>> Is it possible that i have to keep something else in mind, while
>>>> assembling the raid? I expected at least some files with photorec when
>>>> the raid was assembled in the right order.
>>>>
>>>>
>>>> 2016-09-21 21:00 GMT+02:00 Andreas Klauer <Andreas.Klauer@metamorpher.de>:
>>>>> On Wed, Sep 21, 2016 at 08:31:23PM +0200, Simon Becks wrote:
>>>>>> Maybe i just assembled it in the wrong order?
>>>>>
>>>>> Yes, or maybe the superblock was overwritten by XFS after all.
>>>>>
>>>>> You could check what's at offset 1M for each disk.
>>>>>
>>>>> losetup --find --show --read-only --offset=$((2048*512)) /the/disk
>>>>> file -s /dev/loop42
>>>>>
>>>>> If the superblock was still intact it should say ext4 or whatever
>>>>> your filesystem was for at least one of them.
>>>>>
>>>>> You can also try this for the disk you removed 2 month ago.
>>>>>
>>>>> If that is not the case and fsck with backup superblock also
>>>>> is not successful then you'll have to see if you find anything
>>>>> valid in the raw data.
>>>>>
>>>>> Regards
>>>>> Andreas Klauer
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Chris Murphy
