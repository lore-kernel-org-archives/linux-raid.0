From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: is this raid5 OK ?
Date: Fri, 30 Mar 2007 20:59:30 -0400
Message-ID: <460DB272.5090000@tmr.com>
References: <237230840.20070329193857@kaneda.iguw.tuwien.ac.at> <17932.22575.558925.535963@notabene.brown> <460CF7EF.1000203@kaneda.iguw.tuwien.ac.at> <460D3A9F.7010800@tmr.com> <460D55AB.1080309@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <460D55AB.1080309@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-wheneverRainer Fuegenstein wrote:
> Bill Davidsen wrote:
>
>> This still looks odd, why should it behave like this. I have created 
>> a lot of arrays (when I was doing the RAID5 speed testing thread), 
>> and never had anything like this. I'd like to see dmesg to see if 
>> there was an error reported regarding this.
>>
>> I think there's more going on, the original post showed the array as 
>> up rather than some building status, also indicates some issue, 
>> perhaps. What is the partition type of each of these partitions? 
>> Perhaps there's a clue there.
>
> partition type is FD (linux raid autodetect) on all disks.
>
> here's some more info:
> the hardware is pretty old, an 800MHz ASUS board with AMD cpu and an 
> extra onboard promise IDE controller with two channels. the server was 
> working well with a 60 GB hda disk (system) and a single 400 GB disk 
> (hde) for data. kernel was 2.6.19-1.2288.fc5xen0.
>
> when I added 3 more 400 GB disks (hdf to hdh) and created the raid5, 
> the server crashed (rebooted, freezed, ...) as soon as there was more 
> activity on the raid (kernel panics indicating trouble with 
> interrupts, inpage errors etc.) I then upgraded to a 400W power 
> supply, which didn't help.  I went back to two single (non-raid) 400 
> GB disks - same problem.
>
> finally, I figured out that the non-xen kernel works without problems. 
> I'm filling the raid5 since several hours now and the system is still 
> stable.
>
> I haven't tried to re-create the raid5 using the non-xen kernel, it 
> was created using the xen kernel. maybe xen could be the problem ?
I think it sounds likely at this point, I have been having issues with 
xen FC6 kernels, so perhaps the build or testing environment has changed.

However, I would round up the usual suspects, check all cables tight, 
check master/slave jumper settings on drives, etc. Be sure you have the 
appropriate cables, 80 pin where needed. Unless you need the xen kernel 
you might be better off without it for now.

The rest of your details were complete but didn't give me a clue, sorry.
>
> I was wrong in my last post - OS  is actually fedora core 5 (sorry for 
> the typo)
>
> current state of the raid5:
>
> [root@alfred ~]# mdadm --detail --scan
> ARRAY /dev/md0 level=raid5 num-devices=4 spares=1 
> UUID=e96cd8fe:c56c3438:6d9b6c14:9f0eebda
> [root@alfred ~]# mdadm --misc --detail /dev/md0
> /dev/md0:
>         Version : 00.90.03
>   Creation Time : Fri Mar 30 15:55:42 2007
>      Raid Level : raid5
>      Array Size : 1172126208 (1117.83 GiB 1200.26 GB)
>     Device Size : 390708736 (372.61 GiB 400.09 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>
>     Update Time : Fri Mar 30 20:22:27 2007
>           State : active, degraded, recovering
>  Active Devices : 3
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 1
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>  Rebuild Status : 12% complete
>
>            UUID : e96cd8fe:c56c3438:6d9b6c14:9f0eebda
>          Events : 0.26067
>
>     Number   Major   Minor   RaidDevice State
>        0      33        1        0      active sync   /dev/hde1
>        1      33       65        1      active sync   /dev/hdf1
>        2      34        1        2      active sync   /dev/hdg1
>        4      34       65        3      spare rebuilding   /dev/hdh1
>
>
> here's the dmesg of the last reboot (when the raid was already 
> created, but still syncing):
[ since it told me nothing useful I deleted it ]

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

