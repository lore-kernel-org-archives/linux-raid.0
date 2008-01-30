From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Wed, 30 Jan 2008 17:41:41 +0300
Message-ID: <47A08CA5.70704@msgid.tls.msk.ru>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com> <47A07796.2010805@msgid.tls.msk.ru> <47A0855A.1010901@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A0855A.1010901@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: linux-raid@vger.kernel.org
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
> I originally had asked, way back when, if having different md drives on
> different partitions of the *same* disk was a problem for perfomance --
>  or if, for some reason (e.g., threading) it was actually smarter to do
> it that way. The answer I received was from Iustin Pop, who said :
> 
> Iustin Pop wrote:
>> md code works better if it's only one array per physical drive,
>>     because it keeps statistics per array (like last accessed sector,
>>     etc.) and if you combine two arrays on the same drive these
>>     statistics are not exactly true anymore
> 
> So if I use /boot on its own drive and it's only accessed at startup,
> the /boot will only be accessed that one time and afterwards won't cause
> problems for the drive statistics. However, if I use put /boot, /bin,
> and /sbin on this RAID1 drive, it will always be accessed and it might
> create a performance issue.

To be fair, I didn't notice any measurable difference in real life
usage - be it single (probably partitioned further) large raid array
or several separate arrays on different partitions - at least when
there are two components - the "core system" (root fs) and the rest.
Sure, theoretically it should be different, but it seems that in
practice it doesn't make much of a difference.

>> For typical filesystem usage, raid5 works good for both reads
>> and (cached, delayed) writes.  It's workloads like databases
>> where raid5 performs badly.
> 
> Ah, very interesting. Is this true even for (dare I say it?) bittorrent
> downloads?

I don't see why not.  Bittorrent (and the like) writes quite
intelligently, doing alot of buffering of its own.  It writes
SLOWLY.  And it allows the filesystem to cache and optimize
writes.

>> What you do care about is your data integrity.  It's not really
>> interesting to reinstall a system or lose your data in case if
>> something goes wrong, and it's best to have recovery tools as
>> easily available as possible.  Plus, amount of space you need.
> 
> Sure, I understand. And backing up in case someone steals your server.
> But did you have something specific in mind when you wrote this? Don't
> all these configurations (RAID5 vs. RAID10) have equal recovery tools?

Well, I mean that if you've all the basic tools available on the
system even without raid (i mean, root fs on raid1 without any fancy
stuff), you probably have more chances for recovery if it ever will
be necessary.

Yes, reconstructing raid10 is a bit easier than raid5, when the
talk is about MANUAL reconstructing.  But this is something usually
not done anyway, because of complexity, easy to throw away the
data by mistake, and because mdadm somewhat works for recovery
by its own (there are cases when I know how to manually reconstruct
the array data when mdadm can't help me - for example, in case of
raid1 with two half-failed drives - ie, first half of driveA and
second half of driveB works - mdadm wont let me recover from such
situation even if I know that all my data is here).  So basically
there's no difference in "recoverability" of raid5 vs raid10.

>>>> Also, placing /dev on a tmpfs helps alot to minimize number of writes
>>>> necessary for root fs.
>>> Another interesting idea. I'm not familiar with using tmpfs (no need,
>>> until now); but I wonder how you create the devices you need when you're
>>> doing a rescue.
>>
>> When you start udev, your /dev will be on tmpfs.
> 
> Sure, that's what mount shows me right now -- using a standard Debian
> install. What did you suggest I change?

I didn't suggest any change.  I just pointed out that /dev on a tmpfs
reduces writes for root filesystem (as is mounting with -o noatime or
-o nodiratime).  With udev, /dev is already on a tmpfs.

/mjt
