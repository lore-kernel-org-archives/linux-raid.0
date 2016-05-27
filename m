From: bobzer <bobzer@gmail.com>
Subject: Re: raid 5 crashed
Date: Fri, 27 May 2016 15:19:54 -0400
Message-ID: <CADzS=apUB=XZRmCWjpOHuRgvk7EhqrbpRQhHQ+MHf8NHyGCU0w@mail.gmail.com>
References: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com>
 <20160511131524.GA11811@cthulhu.home.robinhill.me.uk> <CADzS=aoKqrG0QV1-Fe5g_b=n11gmbnerTyZ+eY4rBtJieNz_2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=aoKqrG0QV1-Fe5g_b=n11gmbnerTyZ+eY4rBtJieNz_2w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, Robin Hill <robin@robinhill.me.uk>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

hi,

I'm afraid to make the problem worst but i received a new HD to do a
dd_rescue :-)
I'm ready to buy another HD but the problem is that i don't know
what's the best to recover my data

My question is : There is a way to test if the data/raid is ok without
take the risk of losting anything more ?

help me please :-(

best regards
Mathieu

On Wed, May 25, 2016 at 11:06 PM, bobzer <bobzer@gmail.com> wrote:
> thanks for your help.
> i took time to answer because unlucky me, the power supply of my
> laptop fried so no laptop and no way to work on my raid :-(
> any way i got a new one :-)
>
> for the dmesg i paste it here : http://pastebin.com/whUHs256
>
> root@serveur:~# uname -a
> Linux serveur 3.2.0-4-amd64 #1 SMP Debian 3.2.63-2+deb7u1 x86_64 GNU/Linux
> root@serveur:~# mdadm -V
> mdadm - v3.3-78-gf43f5b3 - 02nd avril 2014
>
> about zero the superblock on the wrong device, i hope i didn't do
> that, but also i really don't think i did that, because i took care
> and at that time the raid was working
>
> i don't know what to do, if i use dd_rescue and can't get back 100% of
> the data could i be able to start the raid anyway ?
> what are my risk if i try something like :
> mdadm --assemble --force /dev/md0 /dev/sd[bcde]1
>
> thank you very much for your time
> Mathieu
>
>
> On Wed, May 11, 2016 at 3:15 PM, Robin Hill <robin@robinhill.me.uk> wrote:
>> On Tue May 10, 2016 at 11:28:31PM +0200, bobzer wrote:
>>
>>> hi everyone,
>>>
>>> I'm in panic mode :-( because i got a raid 5 with 4 disk but 2 removed
>>> yesterday i got a power outage which removed one disk. the disks
>>> sd[bcd]1 was ok and saying that sde1 is removed but sde1 said that
>>> everything is fine.
>>> so i stop the raid, zero the superblock of sde1, start the raid and
>>> add sde1 to the raid. then it start to reconstruct, i think it had
>>> time to finish before this problem (i'm not 100% sure that it finish
>>> but i think so)
>>> the data was accessible so i went to sleep
>>> today i discovered the raid in this state :
>>>
>>> root@serveur:/home/math# mdadm -D /dev/md0
>>> /dev/md0:
>>>         Version : 1.2
>>>   Creation Time : Sun Mar  4 22:49:14 2012
>>>      Raid Level : raid5
>>>      Array Size : 5860532352 (5589.04 GiB 6001.19 GB)
>>>   Used Dev Size : 1953510784 (1863.01 GiB 2000.40 GB)
>>>    Raid Devices : 4
>>>   Total Devices : 4
>>>     Persistence : Superblock is persistent
>>>
>>>     Update Time : Fri May  6 17:44:02 2016
>>>           State : clean, FAILED
>>>  Active Devices : 2
>>> Working Devices : 3
>>>  Failed Devices : 1
>>>   Spare Devices : 1
>>>
>>>          Layout : left-symmetric
>>>      Chunk Size : 128K
>>>
>>>            Name : debian:0
>>>            UUID : bf3c605b:9699aa55:d45119a2:7ba58d56
>>>          Events : 892482
>>>
>>>     Number   Major   Minor   RaidDevice State
>>>        3       8       33        0      active sync   /dev/sdc1
>>>        1       8       49        1      active sync   /dev/sdd1
>>>        4       0        0        4      removed
>>>        6       0        0        6      removed
>>>
>>>        4       8       17        -      faulty   /dev/sdb1
>>>        5       8       65        -      spare   /dev/sde1
>>>
>> So this reports /dev/sdb1 faulty and /dev/sde1 spare. That would
>> indicate that the rebuild hadn't finished.
>>
>>> root@serveur:/home/math# mdadm --examine /dev/sdb1
>>> /dev/sdb1:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x0
>>>      Array UUID : bf3c605b:9699aa55:d45119a2:7ba58d56
>>>            Name : debian:0
>>>   Creation Time : Sun Mar  4 22:49:14 2012
>>>      Raid Level : raid5
>>>    Raid Devices : 4
>>>
>>>  Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
>>>      Array Size : 5860532352 (5589.04 GiB 6001.19 GB)
>>>   Used Dev Size : 3907021568 (1863.01 GiB 2000.40 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>    Unused Space : before=1960 sectors, after=386 sectors
>>>           State : clean
>>>     Device UUID : 9bececcb:d520ca38:fd88d956:5718e361
>>>
>>>     Update Time : Fri May  6 02:07:00 2016
>>>   Bad Block Log : 512 entries available at offset 72 sectors
>>>        Checksum : dc2a133a - correct
>>>          Events : 892215
>>>
>>>          Layout : left-symmetric
>>>      Chunk Size : 128K
>>>
>>>    Device Role : Active device 2
>>>    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
>>>
>> We can see /dev/sdb1 has a lower event count than the others and also
>> that it indicates all the drives in the array were active when it was
>> last running. That would strongly suggest that it was not in the array
>> when /dev/sde1 was added to rebuild. The update time is also nearly 16
>> hours earlier than that of the other drives.
>>
>>> root@serveur:/home/math# mdadm --examine /dev/sdc1
>>> /dev/sdc1:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x0
>>>      Array UUID : bf3c605b:9699aa55:d45119a2:7ba58d56
>>>            Name : debian:0
>>>   Creation Time : Sun Mar  4 22:49:14 2012
>>>      Raid Level : raid5
>>>    Raid Devices : 4
>>>
>>>  Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
>>>      Array Size : 5860532352 (5589.04 GiB 6001.19 GB)
>>>   Used Dev Size : 3907021568 (1863.01 GiB 2000.40 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>    Unused Space : before=1960 sectors, after=386 sectors
>>>           State : clean
>>>     Device UUID : 1ecaf51c:3289a902:7bb71a93:237c68e8
>>>
>>>     Update Time : Fri May  6 17:58:27 2016
>>>   Bad Block Log : 512 entries available at offset 72 sectors
>>>        Checksum : b9d6aa84 - correct
>>>          Events : 892484
>>>
>>>          Layout : left-symmetric
>>>      Chunk Size : 128K
>>>
>>>    Device Role : Active device 0
>>>    Array State : AA.. ('A' == active, '.' == missing, 'R' == replacing)
>>>
>>> root@serveur:/home/math# mdadm --examine /dev/sdd1
>>> /dev/sdd1:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x0
>>>      Array UUID : bf3c605b:9699aa55:d45119a2:7ba58d56
>>>            Name : debian:0
>>>   Creation Time : Sun Mar  4 22:49:14 2012
>>>      Raid Level : raid5
>>>    Raid Devices : 4
>>>
>>>  Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
>>>      Array Size : 5860532352 (5589.04 GiB 6001.19 GB)
>>>   Used Dev Size : 3907021568 (1863.01 GiB 2000.40 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>    Unused Space : before=0 sectors, after=386 sectors
>>>           State : clean
>>>     Device UUID : 406c4cb5:c188e4a9:7ed8be9f:14a49b16
>>>
>>>     Update Time : Fri May  6 17:58:27 2016
>>>   Bad Block Log : 512 entries available at offset 2032 sectors
>>>        Checksum : 343f9cd0 - correct
>>>          Events : 892484
>>>
>>>          Layout : left-symmetric
>>>      Chunk Size : 128K
>>>
>>>    Device Role : Active device 1
>>>    Array State : AA.. ('A' == active, '.' == missing, 'R' == replacing)
>>>
>> These two drives contain the same information. They indicate that they
>> were the only 2 running members in the array when they were last updated.
>>
>>> root@serveur:/home/math# mdadm --examine /dev/sde1
>>> /dev/sde1:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x8
>>>      Array UUID : bf3c605b:9699aa55:d45119a2:7ba58d56
>>>            Name : debian:0
>>>   Creation Time : Sun Mar  4 22:49:14 2012
>>>      Raid Level : raid5
>>>    Raid Devices : 4
>>>
>>>  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
>>>      Array Size : 5860532352 (5589.04 GiB 6001.19 GB)
>>>   Used Dev Size : 3907021568 (1863.01 GiB 2000.40 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>    Unused Space : before=1960 sectors, after=3504 sectors
>>>           State : clean
>>>     Device UUID : f2e9c1ec:2852cf21:1a588581:b9f49a8b
>>>
>>>     Update Time : Fri May  6 17:58:27 2016
>>>   Bad Block Log : 512 entries available at offset 72 sectors - bad
>>> blocks present.
>>>        Checksum : 3a65b8bc - correct
>>>          Events : 892484
>>>
>>>          Layout : left-symmetric
>>>      Chunk Size : 128K
>>>
>>>    Device Role : spare
>>>    Array State : AA.. ('A' == active, '.' == missing, 'R' == replacing)
>>>
>> And finally /dev/sde1 shows as a spare, with the rest of the data
>> matching /dev/sdc1 and /dev/sde1.
>>
>>> PLEASE help me :-) i don't know what to do so i did nothing to not do
>>> any stupid things
>>> 1000 thank you
>>>
>>> ps i just saw this, i hope it not mak y case worst
>>> root@serveur:/home/math# cat /etc/mdadm/mdadm.conf
>>> DEVICE /dev/sd[bcd]1
>>> ARRAY /dev/md0 metadata=1.2 name=debian:0
>>> UUID=bf3c605b:9699aa55:d45119a2:7ba58d56
>>>
>>
>> From the data here, if looks to me as though /dev/sdb1 failed originally
>> (hence it thinks the array was complete). Either then /dev/sde1 also
>> failed, or you've proceeded to zero the superblock on the wrong drive.
>> You really need to look through the system logs and verify what happened
>> when and to what disk (if you rebooted at any point, the drive ordering
>> may have changed, so don't take for granted that the drive names are
>> consistent throughout).
>>
>> Cheers,
>>     Robin
>> --
>>      ___
>>     ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>>    / / )      | Little Jim says ....                            |
>>   // !!       |      "He fallen in de water !!"                 |
