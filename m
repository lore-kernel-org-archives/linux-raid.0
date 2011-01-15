From: Bart Kus <me@bartk.us>
Subject: Re: (help!) MD RAID6 won't --re-add devices?
Date: Sat, 15 Jan 2011 11:50:58 -0800
Message-ID: <4D31FAA2.2080202@bartk.us>
References: <4D2EF83D.6080203@bartk.us> <4D31DE07.1000507@bartk.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D31DE07.1000507@bartk.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Some research has revealed a frightening solution:

http://forums.gentoo.org/viewtopic-t-716757-start-0.html

That thread calls upon mdadm --create with the --assume-clean flag.  It 
also seems to re-enforce my suspicions that MD has lost my device order 
numbers when it marked the drives as spare (thanks, MD!  Remind me to 
get you a nice christmas present next year.).  I know the order of 5 out 
of 10 devices, so that leaves 120 permutations to try.  I've whipped up 
some software to generate all the permuted mdadm --create commands.

The question now: how do I test if I've got the right combination?  Can 
I dd a meg off the assembled array and check for errors somewhere?

The other question: Is testing incorrect combinations destructive to any 
data on the drives?  Like, would RAID6 kick in and start "fixing" parity 
errors, even if I'm just reading?

--Bart

On 1/15/2011 9:48 AM, Bart Kus wrote:
> Things seem to have gone from bad to worse.  I upgraded to the latest 
> mdadm, and it actually let me do an --add operation, but --re-add was 
> still failing.  It added all the devices as spares though.  I stopped 
> the array and tried to re-assemble it, but it's not starting.
>
> jo ~ # mdadm -A /dev/md4 -f -u da14eb85:00658f24:80f7a070:b9026515
> mdadm: /dev/md4 assembled from 5 drives and 5 spares - not enough to 
> start the array.
>
> How do I promote these "spares" to being the active decides they once 
> were?  Yes, they're behind a few events, so there will be some data loss.
>
> --Bart
>
> On 1/13/2011 5:03 AM, Bart Kus wrote:
>> Hello,
>>
>> I had a Port Multiplier failure overnight.  This put 5 out of 10 
>> drives offline, degrading my RAID6 array.  The file system is still 
>> mounted (and failing to write):
>>
>> Buffer I/O error on device md4, logical block 3907023608
>> Filesystem "md4": xfs_log_force: error 5 returned.
>> etc...
>>
>> The array is in the following state:
>>
>> /dev/md4:
>>         Version : 1.02
>>   Creation Time : Sun Aug 10 23:41:49 2008
>>      Raid Level : raid6
>>      Array Size : 15628094464 (14904.11 GiB 16003.17 GB)
>>   Used Dev Size : 1953511808 (1863.01 GiB 2000.40 GB)
>>    Raid Devices : 10
>>   Total Devices : 11
>>     Persistence : Superblock is persistent
>>
>>     Update Time : Wed Jan 12 05:32:14 2011
>>           State : clean, degraded
>>  Active Devices : 5
>> Working Devices : 5
>>  Failed Devices : 6
>>   Spare Devices : 0
>>
>>      Chunk Size : 64K
>>
>>            Name : 4
>>            UUID : da14eb85:00658f24:80f7a070:b9026515
>>          Events : 4300692
>>
>>     Number   Major   Minor   RaidDevice State
>>       15       8        1        0      active sync   /dev/sda1
>>        1       0        0        1      removed
>>       12       8       33        2      active sync   /dev/sdc1
>>       16       8       49        3      active sync   /dev/sdd1
>>        4       0        0        4      removed
>>       20       8      193        5      active sync   /dev/sdm1
>>        6       0        0        6      removed
>>        7       0        0        7      removed
>>        8       0        0        8      removed
>>       13       8       17        9      active sync   /dev/sdb1
>>
>>       10       8       97        -      faulty spare
>>       11       8      129        -      faulty spare
>>       14       8      113        -      faulty spare
>>       17       8       81        -      faulty spare
>>       18       8       65        -      faulty spare
>>       19       8      145        -      faulty spare
>>
>> I have replaced the faulty PM and the drives have registered back 
>> with the system, under new names:
>>
>> sd 3:0:0:0: [sdn] Attached SCSI disk
>> sd 3:1:0:0: [sdo] Attached SCSI disk
>> sd 3:2:0:0: [sdp] Attached SCSI disk
>> sd 3:4:0:0: [sdr] Attached SCSI disk
>> sd 3:3:0:0: [sdq] Attached SCSI disk
>>
>> But I can't seem to --re-add them into the array now!
>>
>> # mdadm /dev/md4 --re-add /dev/sdn1 --re-add /dev/sdo1 --re-add 
>> /dev/sdp1 --re-add /dev/sdr1 --re-add /dev/sdq1
>> mdadm: add new device failed for /dev/sdn1 as 21: Device or resource 
>> busy
>>
>> I haven't unmounted the file system and/or stopped the /dev/md4 
>> device, since I think that would drop any buffers either layer might 
>> be holding.  I'd of course prefer to lose as little data as 
>> possible.  How can I get this array going again?
>>
>> PS: I think the reason "Failed Devices" shows 6 and not 5 is because 
>> I had a single HD failure a couple weeks back.  I replaced the drive 
>> and the array re-built A-OK.  I guess it still counted the failure 
>> since the array wasn't stopped during the repair.
>>
>> Thanks for any guidance,
>>
>> --Bart
>>
>> PPS: mdadm - v3.0 - 2nd June 2009
>> PPS: Linux jo.bartk.us 2.6.35-gentoo-r9 #1 SMP Sat Oct 2 21:22:14 PDT 
>> 2010 x86_64 Intel(R) Core(TM)2 Quad CPU @ 2.40GHz GenuineIntel GNU/Linux
>> PPS:  # mdadm --examine /dev/sdn1
>> /dev/sdn1:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x0
>>      Array UUID : da14eb85:00658f24:80f7a070:b9026515
>>            Name : 4
>>   Creation Time : Sun Aug 10 23:41:49 2008
>>      Raid Level : raid6
>>    Raid Devices : 10
>>
>>  Avail Dev Size : 3907023730 (1863.01 GiB 2000.40 GB)
>>      Array Size : 31256188928 (14904.11 GiB 16003.17 GB)
>>   Used Dev Size : 3907023616 (1863.01 GiB 2000.40 GB)
>>     Data Offset : 272 sectors
>>    Super Offset : 8 sectors
>>           State : clean
>>     Device UUID : c0cf419f:4c33dc64:84bc1c1a:7e9778ba
>>
>>     Update Time : Wed Jan 12 05:39:55 2011
>>        Checksum : bdb14e66 - correct
>>          Events : 4300672
>>
>>      Chunk Size : 64K
>>
>>    Device Role : spare
>>    Array State : A.AA.A...A ('A' == active, '.' == missing)
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

