From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Can't add device to raid 1 array - no error message
Date: Sun, 11 Mar 2012 17:52:30 -0500
Message-ID: <4F5D2CAE.4010704@nuclearwinter.com>
References: <4F526930.1080509@nuclearwinter.com> <20120304081159.14d3c937@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120304081159.14d3c937@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/3/2012 3:11 PM, NeilBrown wrote:
> On Sat, 03 Mar 2012 12:55:44 -0600 Larkin Lowrey <llowrey@nuclearwinter.com>
> wrote:
>
>> I am trying to replace the two small drives in my raid1 mirror with two
>> larger drives. I failed and removed the first drive and am now trying to
>> add a new larger drive to take its place. The add command completes
>> without any obvious error but the new dive is not added to the array.
>> What am I missing?
>>
>> A superblock is written on the new array partition but its role is
>> 'spare' and it does not show up in /proc/mdstat.
>>
>> Kernel 3.2.7-1.fc16.x86_64
>> mdadm - v3.2.3 - 23rd December 2011
>>
>> It appears that mdadm does detect an error but doesn't say anything
>> about it:
>>
>> # mdadm --manage /dev/md0 --add /dev/sdz2 ; echo $?
>> 1
> Strange.
> Does adding "--verbose" produce more messages?
>
> Maybe run mdadm under 'strace' and see exactly what is failing.
>
> NeilBrown

I rebooted before I got your reply and the drives showed up (in
/proc/mdstat and attached to the correct array). I supposed it is
possible that I had the on-disk and in-kernel partitions in an
inconsistent state. I had fdisk'ed both drives prior to adding them. I
am very careful about this so I would be surprised if that was the case.

Unfortunately, once the sync was complete and the root volume was on
both drives I was no longer able to boot (using grub2). After tearing my
hair out I finally failed, zeroed, and re-added each drive and finally
was able to get grub2 to install properly and boot.

Both drives are SSDs but I can't imagine that would make a difference...
unless they initialize to FFs (aren't inverting the flash) and that
somehow matters.

I'll try to reproduce this if I can find some spare cycles. Sorry for
the noise.

--Larkin

>
>
>
>
>> I do see the following in the logs:
>>
>> [ 2913.075120] scsi_verify_blk_ioctl: 74 callbacks suppressed
>> [ 2913.080708] mdadm: sending ioctl 1261 to a partition!
>> ...
>> [ 2913.137556] mdadm: sending ioctl 1261 to a partition!
>>
>> # mdadm -D /dev/md0
>> /dev/md0:
>>         Version : 1.2
>>   Creation Time : Tue Jan 10 20:28:20 2006
>>      Raid Level : raid1
>>      Array Size : 15634360 (14.91 GiB 16.01 GB)
>>   Used Dev Size : 15634360 (14.91 GiB 16.01 GB)
>>    Raid Devices : 2
>>   Total Devices : 1
>>     Persistence : Superblock is persistent
>>
>>   Intent Bitmap : Internal
>>
>>     Update Time : Sat Mar  3 12:43:41 2012
>>           State : active, degraded
>>  Active Devices : 1
>> Working Devices : 1
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>            Name : ***.*****.***:0  (local to host ***.*****.***)
>>            UUID : b5d9fcd0:5baaaff8:492c3e4b:22636aac
>>          Events : 499
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       0        0        0      removed
>>        1       8      130        1      active sync   /dev/sdi2
>>
>> # mdadm -E /dev/sdz2
>> /dev/sdz2:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x1
>>      Array UUID : b5d9fcd0:5baaaff8:492c3e4b:22636aac
>>            Name : ***.*****.***:0  (local to host ***.*****.***)
>>   Creation Time : Tue Jan 10 20:28:20 2006
>>      Raid Level : raid1
>>    Raid Devices : 2
>>
>>  Avail Dev Size : 83884032 (40.00 GiB 42.95 GB)
>>      Array Size : 31268720 (14.91 GiB 16.01 GB)
>>   Used Dev Size : 31268720 (14.91 GiB 16.01 GB)
>>     Data Offset : 2048 sectors
>>    Super Offset : 8 sectors
>>           State : clean
>>     Device UUID : 50670e17:d3e5fe82:e572e701:7460bcc4
>>
>> Internal Bitmap : 8 sectors from superblock
>>     Update Time : Sat Mar  3 12:41:18 2012
>>        Checksum : 4bb687db - correct
>>          Events : 0
>>
>>
>>    Device Role : spare
>>    Array State : .A ('A' == active, '.' == missing)
>>
>> ]# cat /proc/mdstat
>> Personalities : [raid1] [raid6] [raid5] [raid4]
>> md2 : active raid5 sdv2[9] sdo2[1] sdx2[4] sdl2[5] sdw2[10] sdp2[2]
>> sdk2[6] sdm2[8] sdq2[3] sdn2[7] sdr2[0]
>>       6641912320 blocks level 5, 128k chunk, algorithm 2 [11/11]
>> [UUUUUUUUUUU]
>>
>> md1 : active raid5 sdx1[6] sdb1[9] sdp1[7] sdl1[11] sdr1[4] sdg1[3]
>> sdk1[10] sdq1[8] sdh1[0] sdv1[13] sdm1[14] sdw1[12] sdn1[2] sdf1[1] sdo1[5]
>>       4375960064 blocks level 5, 64k chunk, algorithm 2 [15/15]
>> [UUUUUUUUUUUUUUU]
>>
>> md0 : active raid1 sdi2[1]
>>       15634360 blocks super 1.2 [2/1] [_U]
>>       bitmap: 1/1 pages [4KB], 65536KB chunk
>>
>> unused devices: <none>
>>
>> --Larkin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
