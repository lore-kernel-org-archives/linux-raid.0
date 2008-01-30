From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Wed, 30 Jan 2008 16:11:50 +0300
Message-ID: <47A07796.2010805@msgid.tls.msk.ru>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F7FCD.7030106@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
[]
> Mr. Tokarev wrote:
> 
>> By the way, on all our systems I use small (256Mb for small-software systems,
>> sometimes 512M, but 1G should be sufficient) partition for a root filesystem
>> (/etc, /bin, /sbin, /lib, and /boot), and put it on a raid1 on all...
>> ... doing [it]
>> this way, you always have all the tools necessary to repair a damaged system
>> even in case your raid didn't start, or you forgot where your root disk is
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

You don't care of the speed of your root filesystem.  Note there are
two speeds - write and read.

You only write to root (including /bin and /lib and so on) during
software (re)install and during some configuration work (writing
/etc/password and the like).  First is very infrequent, and both
needs only a few writes, -- so write speed isn't important.

Read speed also not that important, because most commonly used
stuff from there will be cached anyway (like libc.so, bash and
grep), and again, reading such tiny stuff - it doesn't matter
if it's "fast" raid or a slow one.

What you do care about the speed of devices where your large,
commonly accessed/modified files - such as video files esp.
when you want streaming video - are resides.  And even here,
unless you've special requirement for speed, you will not
notice any difference between "slow" and "fast" raid levels.

For typical filesystem usage, raid5 works good for both reads
and (cached, delayed) writes.  It's workloads like databases
where raid5 performs badly.

What you do care about is your data integrity.  It's not really
interesting to reinstall a system or lose your data in case if
something goes wrong, and it's best to have recovery tools as
easily available as possible.  Plus, amount of space you need.

>> Also, placing /dev on a tmpfs helps alot to minimize number of writes
>> necessary for root fs.
> 
> Another interesting idea. I'm not familiar with using tmpfs (no need,
> until now); but I wonder how you create the devices you need when you're
> doing a rescue.

When you start udev, your /dev will be on tmpfs.

/mjt
