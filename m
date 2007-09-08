From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID 6 reshape failed (false message about critical section)
 -      success report
Date: Sat, 08 Sep 2007 12:19:43 -0400
Message-ID: <46E2CB9F.40706@tmr.com>
References: <515CA0AD-2BAF-437A-8A41-260F7A27BADB@harekrishna.ru>    <18142.41665.719883.549678@notabene.brown>    <62E93D27-4D05-45F7-BB60-144BA46DC913@harekrishna.ru>    <18143.35894.229908.536924@notabene.brown> <15415.91.122.2.245.1189112237.squirrel@ssl.harekrishna.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15415.91.122.2.245.1189112237.squirrel@ssl.harekrishna.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Anton Voloshin <ashutosh@harekrishna.ru>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Anton Voloshin wrote:
> Dear Neil,
>
>   
>> At the top of Grow_restart (in Grow.c), just put
>> 	return 0;
>>
>> That will definitely get you your array back.
>>     
>
> Thank you for your help, I've got my array assembled, running, and all my
> data back up!
>
> But everything was not so smooth as I was (secretly) hoping originally.
> Details follow.
>
> After I first run ./mdadm --assemble /dev/md1
> array actually assembled but with 6 drives out of 8. I don't know exact
> reason why two partitions are missing, but attempts to add missing
> partitions with
>   
>> mdadm --add /dev/md1 /dev/sda2
>>     
> resulted in message that "/dev/sdc1 is locked" or something like that.
> Partitions are there (fdisk -l /dev/sda supports that) and they are
> present in /dev. I suspect that maybe udev was doing something wrong but I
> don't know for sure. Missing partitions were ones from drives which are
> used to run my root partition /dev/md0 - raid1 made of /dev/sda1 and
> /dev/sdc1.
>   
I thought I had replied to this, but I don't see the message, so I'll 
say it again in case it is helpful to others.

If you have a condition like this where a partition doesn't want to add, 
use "lsof" to look for things using it, and check the values in 
/proc/diskstats over a few minutes to see if something actually *is* 
using the partition. Attempting to force an add when some process or 
kernel thread is using a partition is a bad idea.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

