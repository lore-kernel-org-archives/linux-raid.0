From: den Hoog <speedyden@gmail.com>
Subject: Re: looking for advice on raid0+raid5 array recovery with mdadm and
 sector offset
Date: Tue, 7 Jan 2014 22:43:26 +0100
Message-ID: <CANgodhC6wKST5B3zKHD-04xHV8DCUm1Rv71c44RWDMuJp6+WGg@mail.gmail.com>
References: <CANgodhBjRyNDwJwOxepqxX0zMaLtnniYpwWe_k7hjgfRP0UpvA@mail.gmail.com>
	<20140106124143.287894da@notabene.brown>
	<CANgodhCyo7fgEzkg-=jtYkVkNVda50yiaYCCpzPcxAeFxwNUjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANgodhCyo7fgEzkg-=jtYkVkNVda50yiaYCCpzPcxAeFxwNUjw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

some delay due to illness, but as I expected all data on the first
drive was lost.

I created the new container and recreated raid0, and looks identical
now, but it won't mount.
As expected the raid0 offset and sectors are identical to the old volume.

If you would be willing to make a working imsm 'missing' version, I'd
be grateful , and will give that a shot.
It would be the only way to trigger a rebuild on the first drive with
the parity, correct?
Will it detect the existing r5 at that specific offset though?

Thanks again, Dennis



On Mon, Jan 6, 2014 at 7:53 AM, den Hoog <speedyden@gmail.com> wrote:
> Hi Neil, hope you have had good holidays and appreciate your help!
>
> good to know that it is useless to go on the offset path for imsm.
>
> I know for sure the sdb disk was cleared by the win recovery as it
> created a new 2GB partition on it
> I will however try to re-create when I get home and keep you posted
> Probably will have to go the 'missing' way. Will that somehow figure
> out that it needs an offset?
>
> br Dennis
>
> On Mon, Jan 6, 2014 at 2:41 AM, NeilBrown <neilb@suse.de> wrote:
>> On Thu, 2 Jan 2014 20:45:24 +0100 den Hoog <speedyden@gmail.com> wrote:
>>
>>> Hi Neil
>>>
>>> I apologize if I made mistakes with the first mail post but probably
>>> something went wrong, so this is a retry.
>>>
>>> I'm looking for advice on my plan to recover my raid5 volume with mdadm.
>>>
>>> I was in a hurry and made a stupid mistake when upgrading the MB bios.
>>> Forgot to turn on the Intel SATA raid, and Windows recovery erased the
>>> first disk of 4.
>>>
>>> It is an array of 4x4TB, in a matrix, having 1 RAID0 volume, and 1 RAID5 vol.
>>> Although the array displays a failed array in Windows, 3 disks are
>>> active, and 1 is missing and showing as a non-raid array being
>>> available.
>>>
>>> In (my) theory, I should still be able to recover the raid5 vol. with
>>> the remaining 3 disks, however I should specify the specific sector
>>> offset I guess.
>>> I read many articles on this, but none of them address the
>>> 'difficulty' of recovering a specific volume when multiple exist in an
>>> array.
>>>
>>> Although I've some backups, I really would appreciate your help in
>>> getting this recovered.
>>> sda is the SSD
>>> sdb is the 'missing' and erased drive (serial ending on P82C)
>>> sdc is the second drive in the array
>>> sdd is the 3rd drive in the array
>>> sde is the 4th drive in the array
>>> sdf is the usb stick I'm running Fedora live from
>>>
>>> What I've done so far :
>>>
>>> - Started Fedora 15 Live from a USB
>>> - installed the mdadm package data_offset and compiled
>>>
>>>
>>> My plan to work with an offset to recover the [HitR5] volume:
>>>
>>> - echo 1 > /sys/module/md_mod/parameters/
>>> start_dirty_degraded
>>> - mdadm -C /dev/md/imsm -e imsm -n 4 /dev/sdb /dev/sdc /dev/sdd /dev/sde
>>> - mdadm -C /dev/md0 -l5 -n4 -c 128   /dev/sdb:1073746184s
>>> /dev/sdc:1073746184s /dev/sdd:1073746184s /dev/sde:1073746184s
>>
>> This certainly won't work.
>> You need "--data-offset=variable" for the "NNNNs" suffixes to be recognised,
>> and even then it only works for 1.x metadata, not for imsm metadata.
>>
>> There isn't much support for sticking together broken IMSM arrays at
>> present.  Your best bet is to re-create the whole array.
>>
>> So:
>>    mdadm -C /dev/md/imsm -e imsm -n 4 /dev/sd[bcde]
>>    mdadm -C /dev/md0 -l0 -n4 -c 128K -z 512G /dev/md/imsm
>>
>> then check that /dev/md0 looks OK for the RAID0 array.
>> If it does then you can continue to create the raid5 array
>>
>>    mdadm -C /dev/md1 -l5 -n4 -c 128k --assume-clean /dev/md/imsm
>>
>> That *should* then be correct.
>>
>> If the RAID0 array doesn't look right, the possible sdb really was cleared
>> rather than just having the metadata erased.
>> In this case the RAID0 is definitely gone and it will be a bit harder to
>> create the RAID5.  It could be something like:
>>
>>    mdadm -C /dev/md1 -l5 -n4 -c 128k missing /dev/sd[cde]
>>
>> but I'm not sure that 'missing' is works for imsm.  If you need to go this
>> way I can try to make 'missing' for for imsm.  It shouldn't be too hard.
>>
>> NeilBrown
>>
>>
>>>
>>>
>>> I'm in doubt about working with missing disks first to start a
>>> degraded array, with -C and missing for the first drive.
>>> Or choosing assemble --auto, or as stated above and create the volume with an
>>> offset.
>>>
>>> Another thing I'm not certain of: do I need to build a new mdadm with
>>> data_offset, or is it already present in my 3.2.6 version?
>>> When I built a new version with Neils mdadm I ended up with a 3.2.5 18May2012
>>> version.
>>>
>>> As I guess I have only one shot at this I have not executed anything yet.
>>>
>>> thanks many for your help, time and advice!
>>>
>>> best regards Dennis
>>>
>>>
>>> =======output mdadm -Evvvvs=============
>>>
>>> root@localhost ~]# mdadm -Evvvvs
>>>
>>> mdadm: No md superblock detected on /dev/dm-1.
>>>
>>> mdadm: No md superblock detected on /dev/dm-0.
>>>
>>> /dev/sdf1:
>>>
>>>    MBR Magic : aa55
>>>
>>> Partition[0] :    432871117 sectors at   3224498923 (type 07)
>>>
>>> Partition[1] :   1953460034 sectors at   3272020941 (type 16)
>>>
>>> Partition[3] :    924335794 sectors at     50200576 (type 00)
>>>
>>> /dev/sdf:
>>>
>>>    MBR Magic : aa55
>>>
>>> Partition[0] :     15769600 sectors at         2048 (type 0b)
>>>
>>> /dev/sde:
>>>
>>>           Magic : Intel Raid ISM Cfg Sig.
>>>
>>>         Version : 1.3.00
>>>
>>>     Orig Family : f3437c9b
>>>
>>>          Family : f3437c9d
>>>
>>>      Generation : 00002c5f
>>>
>>>      Attributes : All supported
>>>
>>>            UUID : 47b011c7:4a8531ea:7e94ab93:06034952
>>>
>>>        Checksum : 671f5f84 correct
>>>
>>>     MPB Sectors : 2
>>>
>>>           Disks : 4
>>>
>>>    RAID Devices : 2
>>>
>>>
>>>   Disk03 Serial : PL1321LAG4RXEH
>>>
>>>           State : active
>>>
>>>              Id : 00000005
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>>
>>>
>>> [HitR0]:
>>>
>>>            UUID : 73ecf2cf:fcfd2598:d6523381:71e57931
>>>
>>>      RAID Level : 0
>>>
>>>         Members : 4
>>>
>>>           Slots : [_UUU]
>>>
>>>     Failed disk : 1
>>>
>>>       This Slot : 3
>>>
>>>      Array Size : 4294967296 (2048.00 GiB 2199.02 GB)
>>>
>>>    Per Dev Size : 1073742088 (512.00 GiB 549.76 GB)
>>>
>>>   Sector Offset : 0
>>>
>>>     Num Stripes : 4194304
>>>
>>>      Chunk Size : 128 KiB
>>>
>>>        Reserved : 0
>>>
>>>   Migrate State : idle
>>>
>>>       Map State : failed
>>>
>>>     Dirty State : clean
>>>
>>>
>>> [HitR5]:
>>>
>>>            UUID : 71626250:b8fc1262:3545d952:69eb329e
>>>
>>>      RAID Level : 5
>>>
>>>         Members : 4
>>>
>>>           Slots : [_UU_]
>>>
>>>     Failed disk : 3
>>>
>>>       This Slot : 3 (out-of-sync)
>>>
>>>      Array Size : 20220831744 (9642.04 GiB 10353.07 GB)
>>>
>>>    Per Dev Size : 6740279304 (3214.02 GiB 3451.02 GB)
>>>
>>>   Sector Offset : 1073746184
>>>
>>>     Num Stripes : 26329208
>>>
>>>      Chunk Size : 128 KiB
>>>
>>>        Reserved : 0
>>>
>>>   Migrate State : idle
>>>
>>>       Map State : failed
>>>
>>>     Dirty State : clean
>>>
>>>
>>>   Disk00 Serial : PL2311LAG1P82C:0
>>>
>>>           State : active
>>>
>>>              Id : ffffffff
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>>
>>>
>>>   Disk01 Serial : PL1321LAG4NMEH
>>>
>>>           State : active
>>>
>>>              Id : 00000003
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>>
>>>
>>>   Disk02 Serial : PL1321LAG4TH4H
>>>
>>>           State : active
>>>
>>>              Id : 00000004
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>>
>>> /dev/sdd:
>>>
>>>           Magic : Intel Raid ISM Cfg Sig.
>>>
>>>         Version : 1.3.00
>>>
>>>     Orig Family : f3437c9b
>>>
>>>          Family : f3437c9d
>>>
>>>      Generation : 00002c5f
>>>
>>>      Attributes : All supported
>>>
>>>            UUID : 47b011c7:4a8531ea:7e94ab93:06034952
>>>
>>>        Checksum : 671f5f84 correct
>>>
>>>     MPB Sectors : 2
>>>
>>>           Disks : 4
>>>
>>>    RAID Devices : 2
>>>
>>>
>>>   Disk02 Serial : PL1321LAG4TH4H
>>>
>>>           State : active
>>>
>>>              Id : 00000004
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>>
>>>
>>> [HitR0]:
>>>
>>>            UUID : 73ecf2cf:fcfd2598:d6523381:71e57931
>>>
>>>      RAID Level : 0
>>>
>>>         Members : 4
>>>
>>>           Slots : [_UUU]
>>>
>>>     Failed disk : 1
>>>
>>>       This Slot : 2
>>>
>>>      Array Size : 4294967296 (2048.00 GiB 2199.02 GB)
>>>
>>>    Per Dev Size : 1073742088 (512.00 GiB 549.76 GB)
>>>
>>>   Sector Offset : 0
>>>
>>>     Num Stripes : 4194304
>>>
>>>      Chunk Size : 128 KiB
>>>
>>>        Reserved : 0
>>>
>>>   Migrate State : idle
>>>
>>>       Map State : failed
>>>
>>>     Dirty State : clean
>>>
>>>
>>> [HitR5]:
>>>
>>>            UUID : 71626250:b8fc1262:3545d952:69eb329e
>>>
>>>      RAID Level : 5
>>>
>>>         Members : 4
>>>
>>>           Slots : [_UU_]
>>>
>>>     Failed disk : 3
>>>
>>>       This Slot : 2
>>>
>>>      Array Size : 20220831744 (9642.04 GiB 10353.07 GB)
>>>
>>>    Per Dev Size : 6740279304 (3214.02 GiB 3451.02 GB)
>>>
>>>   Sector Offset : 1073746184
>>>
>>>     Num Stripes : 26329208
>>>
>>>      Chunk Size : 128 KiB
>>>
>>>        Reserved : 0
>>>
>>>   Migrate State : idle
>>>
>>>       Map State : failed
>>>
>>>     Dirty State : clean
>>>
>>>
>>>   Disk00 Serial : PL2311LAG1P82C:0
>>>
>>>           State : active
>>>
>>>              Id : ffffffff
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>>
>>>
>>>   Disk01 Serial : PL1321LAG4NMEH
>>>
>>>           State : active
>>>
>>>              Id : 00000003
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>>
>>>
>>>   Disk03 Serial : PL1321LAG4RXEH
>>>
>>>           State : active
>>>
>>>              Id : 00000005
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>>
>>> /dev/sdc:
>>>
>>>           Magic : Intel Raid ISM Cfg Sig.
>>>
>>>         Version : 1.3.00
>>>
>>>     Orig Family : f3437c9b
>>>
>>>          Family : f3437c9d
>>>
>>>      Generation : 00002c5f
>>>
>>>      Attributes : All supported
>>>
>>>            UUID : 47b011c7:4a8531ea:7e94ab93:06034952
>>>
>>>        Checksum : 671f5f84 correct
>>>
>>>     MPB Sectors : 2
>>>
>>>           Disks : 4
>>>
>>>    RAID Devices : 2
>>>
>>>
>>>   Disk01 Serial : PL1321LAG4NMEH
>>>
>>>           State : active
>>>
>>>              Id : 00000003
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>>
>>>
>>> [HitR0]:
>>>
>>>            UUID : 73ecf2cf:fcfd2598:d6523381:71e57931
>>>
>>>      RAID Level : 0
>>>
>>>         Members : 4
>>>
>>>           Slots : [_UUU]
>>>
>>>     Failed disk : 1
>>>
>>>       This Slot : 1
>>>
>>>      Array Size : 4294967296 (2048.00 GiB 2199.02 GB)
>>>
>>>    Per Dev Size : 1073742088 (512.00 GiB 549.76 GB)
>>>
>>>   Sector Offset : 0
>>>
>>>     Num Stripes : 4194304
>>>
>>>      Chunk Size : 128 KiB
>>>
>>>        Reserved : 0
>>>
>>>   Migrate State : idle
>>>
>>>       Map State : failed
>>>
>>>     Dirty State : clean
>>>
>>>
>>> [HitR5]:
>>>
>>>            UUID : 71626250:b8fc1262:3545d952:69eb329e
>>>
>>>      RAID Level : 5
>>>
>>>         Members : 4
>>>
>>>           Slots : [_UU_]
>>>
>>>     Failed disk : 3
>>>
>>>       This Slot : 1
>>>
>>>      Array Size : 20220831744 (9642.04 GiB 10353.07 GB)
>>>
>>>    Per Dev Size : 6740279304 (3214.02 GiB 3451.02 GB)
>>>
>>>   Sector Offset : 1073746184
>>>
>>>     Num Stripes : 26329208
>>>
>>>      Chunk Size : 128 KiB
>>>
>>>        Reserved : 0
>>>
>>>   Migrate State : idle
>>>
>>>       Map State : failed
>>>
>>>     Dirty State : clean
>>>
>>>
>>>   Disk00 Serial : PL2311LAG1P82C:0
>>>
>>>           State : active
>>>
>>>              Id : ffffffff
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>>
>>>
>>>   Disk02 Serial : PL1321LAG4TH4H
>>>
>>>           State : active
>>>
>>>              Id : 00000004
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>>
>>>
>>>   Disk03 Serial : PL1321LAG4RXEH
>>>
>>>           State : active
>>>
>>>              Id : 00000005
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>>
>>> mdadm: No md superblock detected on /dev/sdb1.
>>>
>>> /dev/sdb:
>>>
>>>    MBR Magic : aa55
>>>
>>> Partition[0] :   4294967295 sectors at            1 (type ee)
>>>
>>> /dev/sda2:
>>>
>>>    MBR Magic : aa55
>>>
>>> Partition[0] :   1816210284 sectors at   1920221984 (type 72)
>>>
>>> Partition[1] :   1953653108 sectors at   1936028192 (type 6c)
>>>
>>> Partition[3] :          447 sectors at     27722122 (type 00)
>>>
>>> /dev/sda1:
>>>
>>>    MBR Magic : aa55
>>>
>>> Partition[0] :   1816210284 sectors at   1920221984 (type 72)
>>>
>>> Partition[1] :   1953653108 sectors at   1936028192 (type 6c)
>>>
>>> Partition[3] :          447 sectors at     27722122 (type 00)
>>>
>>> /dev/sda:
>>>
>>>    MBR Magic : aa55
>>>
>>> Partition[0] :       716800 sectors at         2048 (type 07)
>>>
>>> Partition[1] :    499396608 sectors at       718848 (type 07)
>>>
>>> mdadm: No md superblock detected on /dev/loop4.
>>>
>>> mdadm: No md superblock detected on /dev/loop3.
>>>
>>> mdadm: No md superblock detected on /dev/loop2.
>>>
>>> mdadm: No md superblock detected on /dev/loop1.
>>>
>>> mdadm: No md superblock detected on /dev/loop0.
>>>
>>> /dev/md127:
>>>
>>>           Magic : Intel Raid ISM Cfg Sig.
>>>
>>>         Version : 1.3.00
>>>
>>>     Orig Family : f3437c9b
>>>
>>>          Family : f3437c9d
>>>
>>>      Generation : 00002c5f
>>>
>>>      Attributes : All supported
>>>
>>>            UUID : 47b011c7:4a8531ea:7e94ab93:06034952
>>>
>>>        Checksum : 671f5f84 correct
>>>
>>>     MPB Sectors : 2
>>>
>>>           Disks : 4
>>>
>>>    RAID Devices : 2
>>>
>>>
>>>   Disk02 Serial : PL1321LAG4TH4H
>>>
>>>           State : active
>>>
>>>              Id : 00000004
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>>
>>>
>>> [HitR0]:
>>>
>>>            UUID : 73ecf2cf:fcfd2598:d6523381:71e57931
>>>
>>>      RAID Level : 0
>>>
>>>         Members : 4
>>>
>>>           Slots : [_UUU]
>>>
>>>     Failed disk : 1
>>>
>>>       This Slot : 2
>>>
>>>      Array Size : 4294967296 (2048.00 GiB 2199.02 GB)
>>>
>>>    Per Dev Size : 1073742088 (512.00 GiB 549.76 GB)
>>>
>>>   Sector Offset : 0
>>>
>>>     Num Stripes : 4194304
>>>
>>>      Chunk Size : 128 KiB
>>>
>>>        Reserved : 0
>>>
>>>   Migrate State : idle
>>>
>>>       Map State : failed
>>>
>>>     Dirty State : clean
>>>
>>>
>>> [HitR5]:
>>>
>>>            UUID : 71626250:b8fc1262:3545d952:69eb329e
>>>
>>>      RAID Level : 5
>>>
>>>         Members : 4
>>>
>>>           Slots : [_UU_]
>>>
>>>     Failed disk : 3
>>>
>>>       This Slot : 2
>>>
>>>      Array Size : 20220831744 (9642.04 GiB 10353.07 GB)
>>>
>>>    Per Dev Size : 6740279304 (3214.02 GiB 3451.02 GB)
>>>
>>>   Sector Offset : 1073746184
>>>
>>>     Num Stripes : 26329208
>>>
>>>      Chunk Size : 128 KiB
>>>
>>>        Reserved : 0
>>>
>>>   Migrate State : idle
>>>
>>>       Map State : failed
>>>
>>>     Dirty State : clean
>>>
>>>
>>>   Disk00 Serial : PL2311LAG1P82C:0
>>>
>>>           State : active
>>>
>>>              Id : ffffffff
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>>
>>>
>>>   Disk01 Serial : PL1321LAG4NMEH
>>>
>>>           State : active
>>>
>>>              Id : 00000003
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>>
>>>
>>>   Disk03 Serial : PL1321LAG4RXEH
>>>
>>>           State : active
>>>
>>>              Id : 00000005
>>>
>>>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
