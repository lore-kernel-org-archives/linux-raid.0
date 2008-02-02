From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Sat, 02 Feb 2008 15:17:19 -0500
Message-ID: <47A4CFCF.4000203@tmr.com>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com> <47A07796.2010805@msgid.tls.msk.ru> <47A0855A.1010901@pobox.com> <47A1E259.8000000@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A1E259.8000000@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Moshe Yudkowsky <moshe@pobox.com>, Michael Tokarev <mjt@tls.msk.ru>
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Moshe Yudkowsky wrote:
>> Michael Tokarev wrote:
>>
>
>> To return to that peformance question, since I have to create at 
>> least 2 md drives using different partitions, I wonder if it's 
>> smarter to create multiple md drives for better performance.
>>
>> /dev/sd[abcd]1 -- RAID1, the /boot, /dev, /bin/, /sbin
>>
>> /dev/sd[abcd]2 -- RAID5, most of the rest of the file system
>>
>> /dev/sd[abcd]3 -- RAID10 o2, a drive that does a lot of downloading 
>> (writes)
>>
> I think the speed of downloads is so far below the capacity of an 
> array that you won't notice, and hopefully you will use things you 
> download more than once, so you still get more reads than writes.
>
>>> For typical filesystem usage, raid5 works good for both reads
>>> and (cached, delayed) writes.  It's workloads like databases
>>> where raid5 performs badly.
>>
>> Ah, very interesting. Is this true even for (dare I say it?) 
>> bittorrent downloads?
>>
> What do you have for bandwidth? Probably not more than a T3 (145Mbit) 
> which will max out at ~15MB/s, far below the write performance of a 
> single drive, much less an array (even raid5).
It has been pointed out that I have a double typo there, I meant OC3 not 
T3, and 155Mbit.  Still, the most someone is likely to have, even in a 
large company.  Still not a large chance of being faster than the disk 
in raid-10 mode.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


