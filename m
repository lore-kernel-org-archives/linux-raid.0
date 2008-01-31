From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Thu, 31 Jan 2008 09:59:37 -0500
Message-ID: <47A1E259.8000000@tmr.com>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com> <47A07796.2010805@msgid.tls.msk.ru> <47A0855A.1010901@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A0855A.1010901@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> Michael Tokarev wrote:
>
>> You only write to root (including /bin and /lib and so on) during
>> software (re)install and during some configuration work (writing
>> /etc/password and the like).  First is very infrequent, and both
>> needs only a few writes, -- so write speed isn't important.
>
> Thanks, but I didn't make myself clear. The preformance problem I'm 
> concerned about was having different md drives accessing different 
> partitions.
>
> For example, I can partition the drives as follows:
>
> /dev/sd[abcd]1 -- RAID1, /boot
>
> /dev/sd[abcd]2 -- RAID5, the rest of the file system
>
> I originally had asked, way back when, if having different md drives 
> on different partitions of the *same* disk was a problem for 
> perfomance --  or if, for some reason (e.g., threading) it was 
> actually smarter to do it that way. The answer I received was from 
> Iustin Pop, who said :
>
> Iustin Pop wrote:
>> md code works better if it's only one array per physical drive,
>>     because it keeps statistics per array (like last accessed sector,
>>     etc.) and if you combine two arrays on the same drive these
>>     statistics are not exactly true anymore
>
> So if I use /boot on its own drive and it's only accessed at startup, 
> the /boot will only be accessed that one time and afterwards won't 
> cause problems for the drive statistics. However, if I use put /boot, 
> /bin, and /sbin on this RAID1 drive, it will always be accessed and it 
> might create a performance issue.
>

I always put /boot on a separate partition, just to run raid1 which I 
don't use elsewhere.

> To return to that peformance question, since I have to create at least 
> 2 md drives using different partitions, I wonder if it's smarter to 
> create multiple md drives for better performance.
>
> /dev/sd[abcd]1 -- RAID1, the /boot, /dev, /bin/, /sbin
>
> /dev/sd[abcd]2 -- RAID5, most of the rest of the file system
>
> /dev/sd[abcd]3 -- RAID10 o2, a drive that does a lot of downloading 
> (writes)
>
I think the speed of downloads is so far below the capacity of an array 
that you won't notice, and hopefully you will use things you download 
more than once, so you still get more reads than writes.

>> For typical filesystem usage, raid5 works good for both reads
>> and (cached, delayed) writes.  It's workloads like databases
>> where raid5 performs badly.
>
> Ah, very interesting. Is this true even for (dare I say it?) 
> bittorrent downloads?
>
What do you have for bandwidth? Probably not more than a T3 (145Mbit) 
which will max out at ~15MB/s, far below the write performance of a 
single drive, much less an array (even raid5).

>> What you do care about is your data integrity.  It's not really
>> interesting to reinstall a system or lose your data in case if
>> something goes wrong, and it's best to have recovery tools as
>> easily available as possible.  Plus, amount of space you need.
>
> Sure, I understand. And backing up in case someone steals your server. 
> But did you have something specific in mind when you wrote this? Don't 
> all these configurations (RAID5 vs. RAID10) have equal recovery tools?
>
> Or were you referring to the file system? Reiserfs and XFS both seem 
> to have decent recovery tools. LVM is a little tempting because it 
> allows for snapshots, but on the other hand I wonder if I'd find it 
> useful.
>
If you are worried about performance, perhaps some reading of comments 
on LVM would be in order. I personally view it as a trade-off of 
performance for flexibility.
>
>>>> Also, placing /dev on a tmpfs helps alot to minimize number of writes
>>>> necessary for root fs.
>>> Another interesting idea. I'm not familiar with using tmpfs (no need,
>>> until now); but I wonder how you create the devices you need when 
>>> you're
>>> doing a rescue.
>>
>> When you start udev, your /dev will be on tmpfs.
>
> Sure, that's what mount shows me right now -- using a standard Debian 
> install. What did you suggest I change?
>
>


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


