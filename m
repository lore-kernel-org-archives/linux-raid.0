From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: md raid recovery - perplexed
Date: Wed, 25 Apr 2012 22:50:31 -0400
Message-ID: <4F98B7F7.8040205@tmr.com>
References: <1334969336.14947.23.camel@hermes> <1335029393.29951.4.camel@hermes>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1335029393.29951.4.camel@hermes>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ken Gunderson wrote:
>
> On Fri, 2012-04-20 at 18:48 -0600, Ken Gunderson wrote:
>> Hello List:
>>
>> I've created some arrays.  For example, md2 is RAID1 created with gpt
>> based partitions  /dev/sd[ab]1
>>
>> # mdadm --misc --detail /dev/md2
>>
>> /dev/md2:
>>          Version : 1.0
>>    Creation Time : Thu Apr 19 15:56:18 2012
>>       Raid Level : raid1
>>       Array Size : 262132 (256.03 MiB 268.42 MB)
>>    Used Dev Size : 262132 (256.03 MiB 268.42 MB)
>>     Raid Devices : 2
>>    Total Devices : 2
>>      Persistence : Superblock is persistent
>>
>>      Update Time : Fri Apr 20 09:08:11 2012
>>            State : clean
>>   Active Devices : 2
>> Working Devices : 2
>>   Failed Devices : 0
>>    Spare Devices : 0
>>
>>             Name : archiso:2
>>             UUID : e3a5c30e:3fb61039:397992ff:6cc70600
>>           Events : 17
>>
>>      Number   Major   Minor   RaidDevice State
>>         0       8        1        0      active sync   /dev/sda1
>>         1       8       17        1      active sync   /dev/sdb1
>>
>>
>> Okay, great, that works.  However, I am not able to recover from
>> simulated failure.
>>
>> # mdadm /dev/md2 --fail /dev/sdb1
>>
>> # mdadm /dev/md2 --misc --detail
>>
>> /dev/md2:
>>          Version : 1.0
>>    Creation Time : Thu Apr 19 15:56:18 2012
>>       Raid Level : raid1
>>       Array Size : 262132 (256.03 MiB 268.42 MB)
>>    Used Dev Size : 262132 (256.03 MiB 268.42 MB)
>>     Raid Devices : 2
>>    Total Devices : 2
>>      Persistence : Superblock is persistent
>>
>>      Update Time : Fri Apr 20 15:40:10 2012
>>            State : clean, degraded
>>   Active Devices : 1
>> Working Devices : 1
>>   Failed Devices : 1
>>    Spare Devices : 0
>>
>>             Name : archiso:2
>>             UUID : e3a5c30e:3fb61039:397992ff:6cc70600
>>           Events : 20
>>
>>      Number   Major   Minor   RaidDevice State
>>         0       8        1        0      active sync   /dev/sda1
>>         1       0        0        1      removed
>>
>>         1       8       17        -      faulty spare   /dev/sdb1
>>
>>
>>
>> Followed by
>>
>> # mdadm /dev/md2 --remove /dev/sdb1
>>
>> /dev/md2:
>>          Version : 1.0
>>    Creation Time : Thu Apr 19 15:56:18 2012
>>       Raid Level : raid1
>>       Array Size : 262132 (256.03 MiB 268.42 MB)
>>    Used Dev Size : 262132 (256.03 MiB 268.42 MB)
>>     Raid Devices : 2
>>    Total Devices : 1
>>      Persistence : Superblock is persistent
>>
>>      Update Time : Fri Apr 20 15:59:52 2012
>>            State : clean, degraded
>>   Active Devices : 1
>> Working Devices : 1
>>   Failed Devices : 0
>>    Spare Devices : 0
>>
>>             Name : archiso:2
>>             UUID : e3a5c30e:3fb61039:397992ff:6cc70600
>>           Events : 31
>>
>>      Number   Major   Minor   RaidDevice State
>>         0       8        1        0      active sync   /dev/sda1
>>         1       0        0        1      removed
>>
>>
>> I should then be able to re-add sdb1, no?
>>
>> # mdadm /dev/md2 --re-add /dev/sdb1
>>
>> mdadm: --re-add for /dev/sdb1 to /dev/md2 is not possible
>>
>> Since man mdadm explicitly provides following as example:
>>
>> "mdadm /dev/md0 -f /dev/hda1 -r /dev/hda1 -a /dev/hda1"
>>
>> Let's try just adding it instead of re-adding
>>
>> # mdadm /dev/md2 -a /dev/sdb1
>> mdadm: /dev/sdb1 reports being an active member for /dev/md2, but a --re-add fails.
>> mdadm: not performing --add as that would convert /dev/sdb1 in to a spare.
>> mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sdb1" first.
>>
>> I am perplexed as to why might this be?  I must be missing something
>> pretty basic here, else I can provide additional detail as require.
>>
>> Thanks for your help-- Ken
>>
>
> btw - I  do get it that /dev/sdb1 still thinks it's an active member
> of /dev/md2:
>
> # mdadm -E /dev/sdb1
> /dev/sdb1:
>            Magic : a92b4efc
>          Version : 1.0
>      Feature Map : 0x0
>       Array UUID : e3a5c30e:3fb61039:397992ff:6cc70600
>             Name : archiso:2
>    Creation Time : Thu Apr 19 15:56:18 2012
>       Raid Level : raid1
>     Raid Devices : 2
>
>   Avail Dev Size : 524264 (256.03 MiB 268.42 MB)
>       Array Size : 524264 (256.03 MiB 268.42 MB)
>     Super Offset : 524272 sectors
>            State : clean
>      Device UUID : 68d2dc69:03f902eb:9c8ca454:27bd3854
>
>      Update Time : Fri Apr 20 09:46:57 2012
>         Checksum : 2fa4f67c - correct
>           Events : 17
>
>
>     Device Role : Active device 1
>     Array State : AA ('A' == active, '.' == missing)
>
>
> And that I could --zero-superblock and then add the partition back into
> the array.
>
> And also that from searching the web that others encountering this seem
> to solve the issue by utilizing an write bitmap.
>
> But from my reading of the documentation I should not have to, no?
>
I think the problem is in the documentation, it should tell you these things 
perhaps. I confess I learned about this the easy way, since I have always used a 
bitmap and not encountered this until I was testing a similar post years ago.

You might be able to --force it, but I'd rather zero the superblock myself, I 
don't like using the big hammer unless there's no "right" way. I think you do 
understand it, at least as well as I do.

> Thanks in advance for helping me understand what's actually going on
> here.
>
>


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
