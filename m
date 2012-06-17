From: Roberto Leibman <roberto@leibman.net>
Subject: Re: How to activate a spare?
Date: Sun, 17 Jun 2012 12:55:54 -0700
Message-ID: <4FDE364A.7080505@leibman.net>
References: <S1756982Ab2FOO6f/20120615145835Z+98@vger.kernel.org> <4FDB4F14.3030609@leibman.net> <20120617181300.27deb1eb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120617181300.27deb1eb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Weird, weird... I had some inkling that it may have been the 
kernel/mdadm versions... I upgraded the whole thing to Ubuntu 12.04, 
readded the second drive and they're now both active. For anyone out 
there having this issue, try upgrading everything.

On 06/17/2012 01:13 AM, NeilBrown wrote:
> On Fri, 15 Jun 2012 08:04:52 -0700 Roberto Leibman<roberto@leibman.net>
> wrote:
>
>> I must be missing something completely obvious, but I've read the man
>> page, and went through the archive for this list.
>>
>> One of the hard drives in my raid array failed... I have taken the hard
>> drive out, replaced it with a new one, copied the partition table (using
>> gdisk) and then added the drive to the raid array with:
>>
>> mdadm --add /dev/md0 /dev/sdb3
>>
>> I then monitor it with "mdadm --detail /dev/md0" or "cat /proc/mdstat"
>> until it synchronizes
>> After an ungodly number of hours, the thing finishes synchronizing, but
>> the new drive only shows up as a spare. So the RAID is still degraded....
> The only explanation for this that I can think of is that the drive reported
> an error near the end of the recovery process.
> There could be some kernel bug, but you didn't say what kernel you are
> running so it is hard to check.
>
>> I have not been able to get the new drive to become part of the array as
>> active, web searches have proved useless (people with the same problem
>> and no resolution). I've even failed/removed the active drive, at which
>> point the spare becomes active, but when I add the original drive it
>> still adds it as a spare)
> That sounds wrong.  If you have an array with one working drive and one
> spare, and you fail the working drive, then you end up with no drive.  There
> is no way that the spare will suddenly become active.
>
> Maybe you are misinterpreting something and thinking it is spare when it
> isn't.
>
> The below looks perfectly normal.  What does it look like when the recovery
> stops?  Are there any messages in the kernel logs when it stops?
>
> NeilBrown
>
>
>
>> So how do I make it active???
>>
>> (it's in the middle of trying again, but here's what I have)
>> --------------
>> root@frogstar:~# cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md0 : active raid1 sda3[2] sdb3[0]
>>         1943454796 blocks super 1.2 [2/1] [U_]
>>         [>....................]  recovery =  1.0% (20096128/1943454796)
>> finish=737.0min speed=43493K/sec
>>
>> unused devices:<none>
>> --------------
>> and
>> root@frogstar:~# mdadm --detail /dev/md0
>> /dev/md0:
>>           Version : 1.2
>>     Creation Time : Sat Apr 14 13:52:25 2012
>>        Raid Level : raid1
>>        Array Size : 1943454796 (1853.42 GiB 1990.10 GB)
>>     Used Dev Size : 1943454796 (1853.42 GiB 1990.10 GB)
>>      Raid Devices : 2
>>     Total Devices : 2
>>       Persistence : Superblock is persistent
>>
>>       Update Time : Thu Jun 14 13:13:54 2012
>>             State : clean, degraded, recovering
>>    Active Devices : 1
>> Working Devices : 2
>>    Failed Devices : 0
>>     Spare Devices : 1
>>
>>    Rebuild Status : 1% complete
>>
>>              Name : frogstar:0  (local to host frogstar)
>>              UUID : 88ed6cd4:de463005:31ed764c:2b23a266
>>            Events : 47610
>>
>>       Number   Major   Minor   RaidDevice State
>>          0       8       19        0      active sync   /dev/sdb3
>>          2       8        3        1      spare rebuilding   /dev/sda3
>>
>> The version of mdadm I'm using is the stock on ubuntu 10.10 (v3.1.4)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

