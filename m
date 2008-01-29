From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 18:44:20 -0500
Message-ID: <479FBA54.6010009@tmr.com>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F7FCD.7030106@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> I'd like to thank everyone who wrote in with comments and 
> explanations. And in particular it's nice to see that I'm not the only 
> one who's confused.
>
> I'm going to convert back to the RAID 1 setup I had before for /boot, 
> 2 hot and 2 spare across four drives. No, that's wrong: 4 hot makes 
> the most sense.
>
> And given that RAID 10 doesn't seem to confer (for me, as far as I can 
> tell) advantages in speed or reliability -- or the ability to mount 
> just one surviving disk of a mirrored pair -- over RAID 5, I think 
> I'll convert back to RAID 5, put in a hot spare, and do regular 
> backups (as always). Oh, and use reiserfs with data=journal.
>
Depending on near/far choices, raid10 should be faster than raid5, with 
far read should be quite a bit faster. You can't boot off raid10, and if 
you put your swap on it many recovery CDs won't use it. But for general 
use and swap on a normally booted system it is quite fast.
> Comments back:
>
> Peter Rabbitson wrote:
>
>> Maybe you are, depending on your settings, but this is beyond the 
>> point. No matter what 1+0 you have (linux, classic, or otherwise) you 
>> can not boot from it, as there is no way to see the underlying 
>> filesystem without the RAID layer.
>
> Sir, thank you for this unequivocal comment. This comment clears up 
> all my confusion. I had a wrong mental model of how file system maps 
> work.
>
>> With the current state of affairs (available mainstream bootloaders) 
>> the rule is:
>> Block devices containing the kernel/initrd image _must_ be either:
>>     * a regular block device (/sda1, /hda, /fd0, etc.)
>>     * or a linux RAID 1 with the superblock at the end of the device 
>> (0.9 or 1.2)
>
> Thaks even more: 1.2 it is.
>
>> This is how you find the actual raid version:
>>
>> mdadm -D /dev/md[X] | grep Version
>>
>> This will return a string of the form XX.YY.ZZ. Your superblock 
>> version is XX.YY.
>
> Ah hah!
>
> Mr. Tokarev wrote:
>
>> By the way, on all our systems I use small (256Mb for small-software 
>> systems,
>> sometimes 512M, but 1G should be sufficient) partition for a root 
>> filesystem
>> (/etc, /bin, /sbin, /lib, and /boot), and put it on a raid1 on all...
>> ... doing [it]
>> this way, you always have all the tools necessary to repair a damaged 
>> system
>> even in case your raid didn't start, or you forgot where your root 
>> disk is
>> etc etc.
>
> An excellent idea. I was going to put just /boot on the RAID 1, but 
> there's no reason why I can't add a bit more room and put them all 
> there. (Because I was having so much fun on the install, I'm using 4GB 
> that I was going to use for swap space to mount base install and I'm 
> working from their to build the RAID. Same idea.)
>
> Hmmm... I wonder if this more expansive /bin, /sbin, and /lib causes 
> hits on the RAID1 drive which ultimately degrade overall performance? 
> /lib is hit only at boot time to load the kernel, I'll guess, but /bin 
> includes such common tools as bash and grep.
>
>> Also, placing /dev on a tmpfs helps alot to minimize number of writes
>> necessary for root fs.
>
> Another interesting idea. I'm not familiar with using tmpfs (no need, 
> until now); but I wonder how you create the devices you need when 
> you're doing a rescue.
>
> Again, my thanks to everyone who responded and clarified.
>


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


