From: Jean-Paul Sergent <jpsergent@gmail.com>
Subject: Re: 2 disk raid 5 failure
Date: Sun, 5 Oct 2014 02:38:53 -0700
Message-ID: <CANuKptnEodSbv5ywzMtBq4TZXeOmdd7g0Awo1SXB=xm9kD=EQg@mail.gmail.com>
References: <CANuKpt=QJsham0TQWR1Cu1EC8GLyc0aSdU4p3DOznBRrEea11A@mail.gmail.com>
	<20141005194105.4377c295@notabene.brown>
	<CANuKptm=Y3L-xUfGfB5GO3yV63buHeWsfxMYKjUVPP8paGhs0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANuKptm=Y3L-xUfGfB5GO3yV63buHeWsfxMYKjUVPP8paGhs0A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

haha, you're awesome, did an apt-get update && apt-get install mdadm.
Got version:

mdadm - v3.3.2 - 21st August 2014

and all is good, re-added drives automatically, threw out the one with
the oldest event, which had bad sectors.

Thanks so much.

One last question though, the filesystem was XFS. Should I repair the
degraded raid first with a spare disk? or should I do an xfs scrub
first?

-JP

On Sun, Oct 5, 2014 at 2:21 AM, Jean-Paul Sergent <jpsergent@gmail.com> wrote:
> I'm recovering with a liveUSB of debian, the system this raid is on
> normally runs fedora 20, I'm not sure what version of mdadm was
> running on that system. I can find out if I need to.
>
>
> root@debian:~# mdadm --version
> mdadm - v3.3 - 3rd September 2013
>
>
> root@debian:~# mdadm -A /dev/md0 --force -vv /dev/sdb /dev/sdc
> /dev/sde /dev/sdf /dev/sdg
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sde is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdg is identified as a member of /dev/md0, slot 4.
> mdadm: added /dev/sdc to /dev/md0 as 1
> mdadm: added /dev/sdb to /dev/md0 as 2
> mdadm: added /dev/sdf to /dev/md0 as 3 (possibly out of date)
> mdadm: added /dev/sdg to /dev/md0 as 4 (possibly out of date)
> mdadm: added /dev/sde to /dev/md0 as 0
> mdadm: /dev/md0 assembled from 3 drives - not enough to start the array.
>
> Thanks,
> -JP
>
> On Sun, Oct 5, 2014 at 1:41 AM, NeilBrown <neilb@suse.de> wrote:
>> On Sat, 4 Oct 2014 22:43:01 -0700 Jean-Paul Sergent <jpsergent@gmail.com>
>> wrote:
>>
>>> Greetings,
>>>
>>> Recently I lost 2 disks, out of 5, in my raid 5 array from a bad SATA power
>>> cable. It was a Y splitter and it shorted... it was cheap. I was wondering
>>> if there was any chance in getting my data back.
>>>
>>> Of the 2 disks that blew out, one actually had bad/unreadable sectors on
>>> the disk and the other disk seems fine. I have cloned both disks with DD to
>>> 2 new disks and forced the one disk to clone even with errors. The
>>> remaining 3 disks are in tact. The events number on the array for all 5
>>> disks are very close to each other:
>>>
>>>          Events : 201636
>>>          Events : 201636
>>>          Events : 201636
>>>          Events : 201630
>>>          Events : 201633
>>>
>>> Which from my reading gives me some hope, but I'm not sure. I have not done
>>> "recovering a failed software raid" on the wiki yet, the part about
>>> using a loop device to protect your array. I thought I would send a
>>> message out to this list first before going down
>>> that route.
>>>
>>> I did try to do a mdadm --force --assemble on the array but is says that it
>>> only has 3 disks which isn't enough to start the array. I don't want to do
>>> anything else before consulting the mailing list first.
>>
>> --force --assemble really is what you want.  It should work.
>> What does
>>    mdadm -A /dev/md1 --force -vv /dev/sdb /dev/sdc /dev/sde /dev/sdf /dev/sdg
>>
>> report??
>> What version of mdadm (mdadm -V) do you have?
>>
>> NeilBrown
>>
>>
>>>
>>> below I have pasted the mdadm --examine from each member drive. Any help would
>>> be greatly appreciated.
>>>
>>> Thanks,
>>> -JP
>>>
>>> /dev/sdb:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x0
>>>      Array UUID : 7de100f5:4f30f751:62456293:fe98f735
>>>            Name : b1ackb0x:1
>>>   Creation Time : Sun Jan 13 00:01:44 2013
>>>      Raid Level : raid5
>>>    Raid Devices : 5
>>>
>>>  Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
>>>      Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
>>>   Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>    Unused Space : before=1968 sectors, after=816 sectors
>>>           State : clean
>>>     Device UUID : 71d7c3d7:7b232399:51571715:711da6f6
>>>
>>>     Update Time : Tue Apr 29 02:49:21 2014
>>>        Checksum : cd29f83c - correct
>>>          Events : 201636
>>>
>>>          Layout : left-symmetric
>>>      Chunk Size : 512K
>>>
>>>    Device Role : Active device 2
>>>    Array State : AAA.. ('A' == active, '.' == missing, 'R' == replacing)
>>> /dev/sdc:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x0
>>>      Array UUID : 7de100f5:4f30f751:62456293:fe98f735
>>>            Name : b1ackb0x:1
>>>   Creation Time : Sun Jan 13 00:01:44 2013
>>>      Raid Level : raid5
>>>    Raid Devices : 5
>>>
>>>  Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
>>>      Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
>>>   Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>    Unused Space : before=1968 sectors, after=816 sectors
>>>           State : clean
>>>     Device UUID : b47c32b5:b2f9e81a:37150c33:8e3fa6ca
>>>
>>>     Update Time : Tue Apr 29 02:49:21 2014
>>>        Checksum : 1e5353af - correct
>>>          Events : 201636
>>>
>>>          Layout : left-symmetric
>>>      Chunk Size : 512K
>>>
>>>    Device Role : Active device 1
>>>    Array State : AAA.. ('A' == active, '.' == missing, 'R' == replacing)
>>> /dev/sde:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x0
>>>      Array UUID : 7de100f5:4f30f751:62456293:fe98f735
>>>            Name : b1ackb0x:1
>>>   Creation Time : Sun Jan 13 00:01:44 2013
>>>      Raid Level : raid5
>>>    Raid Devices : 5
>>>
>>>  Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
>>>      Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
>>>   Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>    Unused Space : before=1968 sectors, after=816 sectors
>>>           State : clean
>>>     Device UUID : 0398da5b:0bcddd81:8f7e77e9:6689ee0c
>>>
>>>     Update Time : Tue Apr 29 02:49:21 2014
>>>        Checksum : 24a3f586 - correct
>>>          Events : 201636
>>>
>>>          Layout : left-symmetric
>>>      Chunk Size : 512K
>>>
>>>    Device Role : Active device 0
>>>    Array State : AAA.. ('A' == active, '.' == missing, 'R' == replacing)
>>> /dev/sdf:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x0
>>>      Array UUID : 7de100f5:4f30f751:62456293:fe98f735
>>>            Name : b1ackb0x:1
>>>   Creation Time : Sun Jan 13 00:01:44 2013
>>>      Raid Level : raid5
>>>    Raid Devices : 5
>>>
>>>  Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
>>>      Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
>>>   Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>    Unused Space : before=1968 sectors, after=976752816 sectors
>>>           State : clean
>>>     Device UUID : 356c6d85:627a994f:753dec0d:db4fa4f2
>>>
>>>     Update Time : Tue Apr 29 02:37:38 2014
>>>        Checksum : 2621f9d5 - correct
>>>          Events : 201630
>>>
>>>          Layout : left-symmetric
>>>      Chunk Size : 512K
>>>
>>>    Device Role : Active device 3
>>>    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
>>> /dev/sdg:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x0
>>>      Array UUID : 7de100f5:4f30f751:62456293:fe98f735
>>>            Name : b1ackb0x:1
>>>   Creation Time : Sun Jan 13 00:01:44 2013
>>>      Raid Level : raid5
>>>    Raid Devices : 5
>>>
>>>  Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
>>>      Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
>>>   Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>    Unused Space : before=1968 sectors, after=976752816 sectors
>>>           State : clean
>>>     Device UUID : 3dc152d8:832dd43a:a6d638e3:6e12b394
>>>
>>>     Update Time : Tue Apr 29 02:48:01 2014
>>>        Checksum : db9e6008 - correct
>>>          Events : 201633
>>>
>>>          Layout : left-symmetric
>>>      Chunk Size : 512K
>>>
>>>    Device Role : Active device 4
>>>    Array State : AAA.A ('A' == active, '.' == missing, 'R' == replacing)
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
