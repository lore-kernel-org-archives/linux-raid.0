From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Reduce Timeout on Disk Failure
Date: Tue, 29 Apr 2003 10:06:14 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EAE86D6.D4DC56B2@SteelEye.com>
References: <20030429132329.20854.qmail@rome.rubylane.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: jim@rubylane.com
Cc: Andreas Kahnt <aka@aka.coware.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

jim@rubylane.com wrote:
> 
> If this is patched, I hope it is also put into a 2.2 update.  When a
> SW raid is running, a couple of I/O retries might be reasonable, but
> not heroic recovery attempts that would make good sense in a
> single-disk environment.

Yes, the md driver in 2.2 had a ridiculously large retry loop when an
I/O failure occurs...if I counted correctly, I think it did 4096 retries
on I/O failure! This usually means that one of the lower level drivers
ends up hung in a pretty tight error handling loop...

 
> We did a simple test of powering down an IDE drive that was part of an
> (idle) SW raid, then trying to access the filesystem, and the system
> just locked up.  Maybe it would have eventually come back to life - I
> dunno.

Yep, we tried similar things with a network block device (breaking the
network connection)...we ended up hacking the raid1 and nbd drivers and
inserting schedule() calls just to mitigate the effects of the retries a
little bit...we at least got the system not to hang completely while the
retries were going on... 

 
> For the curious, we haven't upgraded to 2.4x because whenever I check
> the kernel traffic page, it seems there are still important bugs being
> found and corrected - ones we don't want to experience in a production
> setup.

Well, this particular retry problem does not exist in 2.4. And in
general, as far as software RAID is concerned, 2.4 is a lot better...I
know, at least with raid1, you can fail a device just about anytime you
want (with lots of write activity, during a resync, etc.) and as often
as you want, and it doesn't hang...

--
Paul
