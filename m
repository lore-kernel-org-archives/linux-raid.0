From: Eli Morris <ermorris@ucsc.edu>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Thu, 8 Dec 2011 12:39:10 -0800
Message-ID: <46200D05-2D7F-44F8-9323-DCFF720776D2@ucsc.edu>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu> <20111208075709.587ac227@notabene.brown> <654BF752-029F-444F-A4AB-68C3CEA7F8D5@ucsc.edu> <20111208091651.2a56dd5b@notabene.brown> <2866C99D-B573-4EF3-8FD0-0A40B0C20118@ucsc.edu> <20111209065140.107aa286@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111209065140.107aa286@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Dec 8, 2011, at 11:51 AM, NeilBrown wrote:

> On Thu, 8 Dec 2011 11:17:12 -0800 Eli Morris <ermorris@ucsc.edu> wrote:
> 
>> 
>> On Dec 7, 2011, at 2:16 PM, NeilBrown wrote:
>> 
>>> On Wed, 7 Dec 2011 14:00:00 -0800 Eli Morris <ermorris@ucsc.edu> wrote:
>>> 
>>>> 
>>>> On Dec 7, 2011, at 12:57 PM, NeilBrown wrote:
>>>> 
>>>>> On Wed, 7 Dec 2011 12:42:26 -0800 Eli Morris <ermorris@ucsc.edu> wrote:
>>>>> 
>>>>>> Hi All,
>>>>>> 
>>>>>> I thought maybe someone could help me out. I have a 16 disk software RAID that we use for backup. This is at least the second time this happened- all at once, four of the drives report as 'removed' when none of them actually were. These drives also disappeared from the 'lsscsi' list until I restarted the disk expansion chassis where they live. 
>>>>>> 
>>>>>> These are the dreaded Caviar Green drives. We bought 16 of them as an upgrade for a hardware RAID originally, because the tech from that company said they would work fine. After running them for a while, four drives dropped out of that array. So I put them in the software RAID expansion chassis they are in now, thinking I might have better luck. In this configuration, this happened once before. That time, the drives looked to all have significant numbers of bad sectors, so I got those ones replaced and thought that that might have been the problem all along. Now it has happened again. So I have two fairly predictable questions and I'm hoping someone might be able to offer a suggestion:
>>>>>> 
>>>>>> 1) Any ideas on how to get this array working again without starting from scratch? It's all backup data, so it's not do or die, but it is also 30 TB and I really don't want to rebuild the whole thing again from scratch.
>>>>> 
>>>>> 1/ Stop the array
>>>>>  mdadm -S /dev/md5
>>>>> 
>>>>> 2/ Make sure you can read all of the devices
>>>>> 
>>>>>  mdadm -E /dev/some-device
>>>>> 
>>>>> 3/ When you are confident that the hardware is actually working, reassemble
>>>>> the array with --force
>>>>> 
>>>>>  mdadm -A /dev/md5 --force /dev/sd[a-o]1
>>>>> (or whatever gets you a list of devices.)
>>>>> 
>>>>>> 
>>>>>> I tried the re-add command and the error was something like 'not allowed'
>>>>>> 
>>>>>> 2) Any idea on how to stop this from happening again? I was thinking of playing with the disk timeout in the OS (not the one on the drive firmware). 
>>>>> 
>>>>> Cannot help there, sorry - and you really should solve this issue before you
>>>>> put the array back together or it'll just all happen again.
>>>>> 
>>>>> NeilBrown
>>>>> 
>>>>>> 
>>>>>> If anyway can help, I'd greatly appreciate it, because, at this point, I have no idea what to do about this mess. 
>>>>>> 
>>>>>> Thanks!
>>>>>> 
>>>>>> Eli
>>>>>> 
>>>>>> 
>>>>>> [root@stratus ~]# mdadm --detail /dev/md5
>>>>>> /dev/md5:
>>>>>>      Version : 1.2
>>>>>> Creation Time : Wed Oct 12 16:32:41 2011
>>>>>>   Raid Level : raid5
>>>>>> Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
>>>>>> Raid Devices : 16
>>>>>> Total Devices : 13
>>>>>>  Persistence : Superblock is persistent
>>>>>> 
>>>>>>  Update Time : Mon Dec  5 12:52:46 2011
>>>>>>        State : active, FAILED, Not Started
>>>>>> Active Devices : 12
>>>>>> Working Devices : 13
>>>>>> Failed Devices : 0
>>>>>> Spare Devices : 1
>>>>>> 
>>>>>>       Layout : left-symmetric
>>>>>>   Chunk Size : 512K
>>>>>> 
>>>>>>         Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
>>>>>>         UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
>>>>>>       Events : 32
>>>>>> 
>>>>>>  Number   Major   Minor   RaidDevice State
>>>>>>     0       8        1        0      active sync   /dev/sda1
>>>>>>     1       0        0        1      removed
>>>>>>     2       8       33        2      active sync   /dev/sdc1
>>>>>>     3       8       49        3      active sync   /dev/sdd1
>>>>>>     4       8       65        4      active sync   /dev/sde1
>>>>>>     5       8       81        5      active sync   /dev/sdf1
>>>>>>     6       8       97        6      active sync   /dev/sdg1
>>>>>>     7       8      113        7      active sync   /dev/sdh1
>>>>>>     8       0        0        8      removed
>>>>>>     9       8      145        9      active sync   /dev/sdj1
>>>>>>    10       8      161       10      active sync   /dev/sdk1
>>>>>>    11       8      177       11      active sync   /dev/sdl1
>>>>>>    12       8      193       12      active sync   /dev/sdm1
>>>>>>    13       8      209       13      active sync   /dev/sdn1
>>>>>>    14       0        0       14      removed
>>>>>>    15       0        0       15      removed
>>>>>> 
>>>>>>    16       8      225        -      spare   /dev/sdo1
>>>>>> [root@stratus ~]# 
>>>>>> 
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> 
>>>> 
>>>> Hi Neil,
>>>> 
>>>> Thanks. I gave it a try and I think I got close to getting it back. Maybe. Here is the output from one of the drives that showed up as 'removed' below. It looks OK to me, but I'm not really sure what trouble signs to look for. After stopping the array, I tried to reconstruct it, and here is what I got below. I don't know why the drives would be busy. Short of rebooting, which I can't do at the moment, is there a way to check why they are busy and force them to stop? I don't have them mounted or anything. Or do you think that means the hardware is not responding properly?
>>>> 
>>>> Thanks,
>>>> 
>>>> Eli
>>>> 
>>>> mdadm -A /dev/md5 --force /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1
>>>> mdadm: failed to add /dev/sdo1 to /dev/md5: Device or resource busy
>>>> mdadm: failed to add /dev/sdp1 to /dev/md5: Device or resource busy
>>>> mdadm: /dev/md5 assembled from 12 drives and 2 spares - not enough to start the array.
>>> 
>>> This means that the device is busy....
>>> Maybe it got attach to another md array.  What is in /proc/mdstat.  Maybe you
>>> have to stop something else.
>>> 
>>> NeilBrown
>> 
>> I found somewhere that dmraid can grab the drives and not release them, so I removed the dmraid packages and set the nodrmraid flag on the boot line. Since I did that I get:
>> 
>> mdadm: cannot open device /dev/sda1: Device or resource busy
>> mdadm: /dev/sda1 has no superblock - assembly aborted
>> 
>> which is a little odd, since last time it complained that /sdo1 and /sdp1 where busy and didn't say anything about drive /sda1. Anyway through, I read some instructions here: 
>> 
>> http://en.wikipedia.org/wiki/Mdadm#Known_problems
>> 
>> that suggest that I zero the superblock on /dev/sda1
>> 
>> I don't know too much about this, but I thought the superblock contained information about the RAID array. If I zero it, will that screw up the array that I'm trying to recover or is it the thing to try? I also am wondering if this might have caused the problem to begin with, like dmraid grabbed four of my drives when I did the last routine reboot, since I had four drives come up as "removed" all of a sudden. 
>> 
>> thanks for any advice,
>> 
>> Eli
>> 
> 
> 
> Don't zero anything until you are sure you know what the problem is and why
> that would fix it.  I probably won't in this case.
> 
> There are a number of things that can keep a device busy:
> - mounted filesystem - unlikely here
> - enabled as swap - unlikely
> - in an md array - /proc/mdstat shows there aren't any
> - in a dm array - "dmsetup table" will show you, "dmsetup remove_all" will
>   remove the dm arrays
> - some process has an exclusive open - again, unlikely.
> 
> Cannot think of anything else just now.
> 
> Are there any message appearing in the kernel logs (or 'dmesg' output)
> when you try to assemble the array.
> 
> Try running the --assemble with --verbose and  post the result.
> 
> NeilBrown
> 

Thanks. I think I know why /dev/sda was busy last time. I didn't realize that even if the assemble produced an inactive array, it needed to be stopped prior to trying again. After I stopped that array, I assembled the array again and I got the same problem drives an before. Log file output follows.

thanks for your help,

Eli



Here is the messages log:

Dec  8 12:22:29 stratus kernel: md: bind<sdc1>
Dec  8 12:22:29 stratus kernel: md: bind<sdd1>
Dec  8 12:22:29 stratus kernel: md: bind<sde1>
Dec  8 12:22:29 stratus kernel: md: bind<sdf1>
Dec  8 12:22:29 stratus kernel: md: bind<sdg1>
Dec  8 12:22:29 stratus kernel: md: bind<sdh1>
Dec  8 12:22:29 stratus kernel: md: bind<sdj1>
Dec  8 12:22:29 stratus kernel: md: bind<sdk1>
Dec  8 12:22:29 stratus kernel: md: bind<sdl1>
Dec  8 12:22:29 stratus kernel: md: bind<sdm1>
Dec  8 12:22:29 stratus kernel: md: bind<sdn1>
Dec  8 12:22:29 stratus kernel: md: bind<sdb1>
Dec  8 12:22:29 stratus kernel: md: bind<sdi1>
Dec  8 12:22:29 stratus kernel: md: export_rdev(sdo1)
Dec  8 12:22:29 stratus kernel: md: bind<sda1>

Here is dmesg output:

md: bind<sdc1>
md: bind<sdd1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sdg1>
md: bind<sdh1>
md: bind<sdj1>
md: bind<sdk1>
md: bind<sdl1>
md: bind<sdm1>
md: bind<sdn1>
md: bind<sdb1>
md: bind<sdi1>
md: export_rdev(sdo1)
md: bind<sda1>


and here is the verbose assemble output:

[root@stratus log]# mdadm --verbose --assemble /dev/md5 --force /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 
mdadm: looking for devices for /dev/md5
mdadm: /dev/sda1 is identified as a member of /dev/md5, slot 0.
mdadm: /dev/sdb1 is identified as a member of /dev/md5, slot -1.
mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 2.
mdadm: /dev/sdd1 is identified as a member of /dev/md5, slot 3.
mdadm: /dev/sde1 is identified as a member of /dev/md5, slot 4.
mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 5.
mdadm: /dev/sdg1 is identified as a member of /dev/md5, slot 6.
mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 7.
mdadm: /dev/sdi1 is identified as a member of /dev/md5, slot -1.
mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 9.
mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 10.
mdadm: /dev/sdl1 is identified as a member of /dev/md5, slot 11.
mdadm: /dev/sdm1 is identified as a member of /dev/md5, slot 12.
mdadm: /dev/sdn1 is identified as a member of /dev/md5, slot 13.
mdadm: /dev/sdo1 is identified as a member of /dev/md5, slot -1.
mdadm: no uptodate device for slot 1 of /dev/md5
mdadm: added /dev/sdc1 to /dev/md5 as 2
mdadm: added /dev/sdd1 to /dev/md5 as 3
mdadm: added /dev/sde1 to /dev/md5 as 4
mdadm: added /dev/sdf1 to /dev/md5 as 5
mdadm: added /dev/sdg1 to /dev/md5 as 6
mdadm: added /dev/sdh1 to /dev/md5 as 7
mdadm: no uptodate device for slot 8 of /dev/md5
mdadm: added /dev/sdj1 to /dev/md5 as 9
mdadm: added /dev/sdk1 to /dev/md5 as 10
mdadm: added /dev/sdl1 to /dev/md5 as 11
mdadm: added /dev/sdm1 to /dev/md5 as 12
mdadm: added /dev/sdn1 to /dev/md5 as 13
mdadm: no uptodate device for slot 14 of /dev/md5
mdadm: no uptodate device for slot 15 of /dev/md5
mdadm: added /dev/sdb1 to /dev/md5 as -1
mdadm: added /dev/sdi1 to /dev/md5 as -1
mdadm: failed to add /dev/sdo1 to /dev/md5: Device or resource busy
mdadm: added /dev/sda1 to /dev/md5 as 0
mdadm: /dev/md5 assembled from 12 drives and 2 spares - not enough to start the array.




Here is the output of dmsetup table and I don't see anything beyond entries that make sense (vol2, vol3 are LVM groups that assemble 2 TB LUNS from hardware RAIDs):

[root@stratus log]# dmsetup tableVolGroup-lv_swap: 0 20578304 linear 65:2 3664791552
VolGroup-lv_root: 0 104857600 linear 65:2 2048
vol2-vol2: 0 4294942720 linear 65:49 384
vol2-vol2: 4294942720 4294942720 linear 65:65 384
vol2-vol2: 8589885440 1177706496 linear 65:81 384
vol3-vol3: 0 4294942720 linear 65:97 384
vol3-vol3: 4294942720 4294942720 linear 65:113 384
vol3-vol3: 8589885440 4294942720 linear 65:129 384
vol3-vol3: 12884828160 789798912 linear 65:145 384
VolGroup-lv_home: 0 3633963008 linear 65:17 2048
VolGroup-lv_home: 3633963008 3559931904 linear 65:2 104859648 

[root@stratus log]# lsscsi
[0:0:0:0]    disk    ATA      WDC WD20EADS-00S 0A01  /dev/sda 
[0:0:1:0]    disk    ATA      WDC WD20EADS-32S 0A01  /dev/sdb 
[0:0:2:0]    disk    ATA      WDC WD20EADS-00S 0A01  /dev/sdc 
[0:0:3:0]    disk    ATA      WDC WD20EADS-00S 0A01  /dev/sdd 
[0:0:4:0]    disk    ATA      WDC WD20EADS-00S 0A01  /dev/sde 
[0:0:5:0]    disk    ATA      WDC WD20EADS-00W 0A01  /dev/sdf 
[0:0:6:0]    disk    ATA      WDC WD20EADS-00S 0A01  /dev/sdg 
[0:0:7:0]    disk    ATA      WDC WD2001FASS-0 1D05  /dev/sdh 
[0:0:8:0]    disk    ATA      WDC WD20EADS-00S 0A01  /dev/sdi 
[0:0:9:0]    disk    ATA      WDC WD20EARS-00M AB51  /dev/sdj 
[0:0:10:0]   disk    ATA      WDC WD20EADS-00S 0A01  /dev/sdk 
[0:0:11:0]   disk    ATA      WDC WD20EADS-00S 0A01  /dev/sdl 
[0:0:12:0]   disk    ATA      WDC WD20EARX-00P AB51  /dev/sdm 
[0:0:13:0]   disk    ATA      WDC WD20EADS-00S 0A01  /dev/sdn 
[0:0:14:0]   disk    ATA      WDC WD20EADS-00S 0A01  /dev/sdo 
[0:0:15:0]   disk    ATA      WDC WD20EADS-00S 0A01  /dev/sdp 
[0:0:16:0]   enclosu Areca    ARC-8026-.01.11. 0111  -       
[2:0:0:0]    cd/dvd  SONY     DVD-ROM DDU810A  KD38  /dev/sr0 
[4:2:0:0]    disk    DELL     PERC 5/i         1.03  /dev/sdq 
[4:2:1:0]    disk    DELL     PERC 5/i         1.03  /dev/sdr 
[5:0:0:0]    disk    RaidWeb. com              R0.0  /dev/sds 
[6:0:2:0]    disk    RaidWeb. Com              0001  /dev/sdt 
[6:0:2:1]    disk    RaidWeb. Com              0001  /dev/sdu 
[6:0:2:2]    disk    RaidWeb. Com              0001  /dev/sdv 
[6:0:3:0]    disk    RaidWeb. Com              0001  /dev/sdw 
[6:0:3:1]    disk    RaidWeb. Com              0001  /dev/sdx 
[6:0:3:2]    disk    RaidWeb. Com              0001  /dev/sdy 
[6:0:3:3]    disk    RaidWeb. Com              0001  /dev/sdz 
[7:0:0:0]    cd/dvd  Dell     Virtual  CDROM   123   /dev/sr1 
[8:0:0:0]    disk    Dell     Virtual  Floppy  123   /dev/sdaa
[root@stratus log]# 



