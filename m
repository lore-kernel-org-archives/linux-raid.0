From: Eli Morris <ermorris@ucsc.edu>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Wed, 7 Dec 2011 15:42:34 -0800
Message-ID: <0226125C-C6D8-42E6-9772-509A7AA4B8C8@ucsc.edu>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu> <20111208075709.587ac227@notabene.brown> <654BF752-029F-444F-A4AB-68C3CEA7F8D5@ucsc.edu> <20111208091651.2a56dd5b@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111208091651.2a56dd5b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Dec 7, 2011, at 2:16 PM, NeilBrown wrote:

> On Wed, 7 Dec 2011 14:00:00 -0800 Eli Morris <ermorris@ucsc.edu> wrote:
> 
>> 
>> On Dec 7, 2011, at 12:57 PM, NeilBrown wrote:
>> 
>>> On Wed, 7 Dec 2011 12:42:26 -0800 Eli Morris <ermorris@ucsc.edu> wrote:
>>> 
>>>> Hi All,
>>>> 
>>>> I thought maybe someone could help me out. I have a 16 disk software RAID that we use for backup. This is at least the second time this happened- all at once, four of the drives report as 'removed' when none of them actually were. These drives also disappeared from the 'lsscsi' list until I restarted the disk expansion chassis where they live. 
>>>> 
>>>> These are the dreaded Caviar Green drives. We bought 16 of them as an upgrade for a hardware RAID originally, because the tech from that company said they would work fine. After running them for a while, four drives dropped out of that array. So I put them in the software RAID expansion chassis they are in now, thinking I might have better luck. In this configuration, this happened once before. That time, the drives looked to all have significant numbers of bad sectors, so I got those ones replaced and thought that that might have been the problem all along. Now it has happened again. So I have two fairly predictable questions and I'm hoping someone might be able to offer a suggestion:
>>>> 
>>>> 1) Any ideas on how to get this array working again without starting from scratch? It's all backup data, so it's not do or die, but it is also 30 TB and I really don't want to rebuild the whole thing again from scratch.
>>> 
>>> 1/ Stop the array
>>>   mdadm -S /dev/md5
>>> 
>>> 2/ Make sure you can read all of the devices
>>> 
>>>   mdadm -E /dev/some-device
>>> 
>>> 3/ When you are confident that the hardware is actually working, reassemble
>>>  the array with --force
>>> 
>>>   mdadm -A /dev/md5 --force /dev/sd[a-o]1
>>> (or whatever gets you a list of devices.)
>>> 
>>>> 
>>>> I tried the re-add command and the error was something like 'not allowed'
>>>> 
>>>> 2) Any idea on how to stop this from happening again? I was thinking of playing with the disk timeout in the OS (not the one on the drive firmware). 
>>> 
>>> Cannot help there, sorry - and you really should solve this issue before you
>>> put the array back together or it'll just all happen again.
>>> 
>>> NeilBrown
>>> 
>>>> 
>>>> If anyway can help, I'd greatly appreciate it, because, at this point, I have no idea what to do about this mess. 
>>>> 
>>>> Thanks!
>>>> 
>>>> Eli
>>>> 
>>>> 
>>>> [root@stratus ~]# mdadm --detail /dev/md5
>>>> /dev/md5:
>>>>       Version : 1.2
>>>> Creation Time : Wed Oct 12 16:32:41 2011
>>>>    Raid Level : raid5
>>>> Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
>>>>  Raid Devices : 16
>>>> Total Devices : 13
>>>>   Persistence : Superblock is persistent
>>>> 
>>>>   Update Time : Mon Dec  5 12:52:46 2011
>>>>         State : active, FAILED, Not Started
>>>> Active Devices : 12
>>>> Working Devices : 13
>>>> Failed Devices : 0
>>>> Spare Devices : 1
>>>> 
>>>>        Layout : left-symmetric
>>>>    Chunk Size : 512K
>>>> 
>>>>          Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
>>>>          UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
>>>>        Events : 32
>>>> 
>>>>   Number   Major   Minor   RaidDevice State
>>>>      0       8        1        0      active sync   /dev/sda1
>>>>      1       0        0        1      removed
>>>>      2       8       33        2      active sync   /dev/sdc1
>>>>      3       8       49        3      active sync   /dev/sdd1
>>>>      4       8       65        4      active sync   /dev/sde1
>>>>      5       8       81        5      active sync   /dev/sdf1
>>>>      6       8       97        6      active sync   /dev/sdg1
>>>>      7       8      113        7      active sync   /dev/sdh1
>>>>      8       0        0        8      removed
>>>>      9       8      145        9      active sync   /dev/sdj1
>>>>     10       8      161       10      active sync   /dev/sdk1
>>>>     11       8      177       11      active sync   /dev/sdl1
>>>>     12       8      193       12      active sync   /dev/sdm1
>>>>     13       8      209       13      active sync   /dev/sdn1
>>>>     14       0        0       14      removed
>>>>     15       0        0       15      removed
>>>> 
>>>>     16       8      225        -      spare   /dev/sdo1
>>>> [root@stratus ~]# 
>>>> 
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
>> 
>> Hi Neil,
>> 
>> Thanks. I gave it a try and I think I got close to getting it back. Maybe. Here is the output from one of the drives that showed up as 'removed' below. It looks OK to me, but I'm not really sure what trouble signs to look for. After stopping the array, I tried to reconstruct it, and here is what I got below. I don't know why the drives would be busy. Short of rebooting, which I can't do at the moment, is there a way to check why they are busy and force them to stop? I don't have them mounted or anything. Or do you think that means the hardware is not responding properly?
>> 
>> Thanks,
>> 
>> Eli
>> 
>> mdadm -A /dev/md5 --force /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1
>> mdadm: failed to add /dev/sdo1 to /dev/md5: Device or resource busy
>> mdadm: failed to add /dev/sdp1 to /dev/md5: Device or resource busy
>> mdadm: /dev/md5 assembled from 12 drives and 2 spares - not enough to start the array.
> 
> This means that the device is busy....
> Maybe it got attach to another md array.  What is in /proc/mdstat.  Maybe you
> have to stop something else.
> 
> NeilBrown


I can't imagine what would be using it though. It was being used as part of this RAID set, so it's not going to be mounted somewhere else.

[root@stratus ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] 
unused devices: <none>

thanks,

Eli

