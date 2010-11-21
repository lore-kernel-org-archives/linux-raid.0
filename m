From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: Device state during an incremental assembly
Date: Sun, 21 Nov 2010 17:45:22 -0500
Message-ID: <20101121224522.GA10945@animx.eu.org>
References: <20101120015225.GA9625@animx.eu.org> <20101121144159.GB29163@animx.eu.org> <20101122075840.1153b020@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101122075840.1153b020@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Sun, 21 Nov 2010 09:41:59 -0500
> > > Note: if you don't find that there is enough detail in this answer, it
> > > simply
> > > reflects the level of detail in the question :-)
> > 
> > Next, mdadm -I /dev/sdb1
> > Still not enough.
> > Next, mdadm -I /dev/sdc1
> > At this point, I could start the array in degraded.  This is what I'd like
> > to beable to query from beneath /sys/block/md0 or some where else.
> 
> Ahh.. In this case the answer is actually "no" - sorry.

Ok, I wasn't sure so I figured I'd ask.

> The answer is a non-trivial function of:
>   the raid level
>   the number of available non-spare devices
>   (for raid10) which slots the available non-spare devices fill.

I've tested only on raid5 at the moment.

> All of this information is available in sysfs, and mdadm has code to perform
> the computation and then take appropriate action.  But there is no simple way
> to get this information.

For this environment, I'm limited to what busybox and it's ash can do.

> Why do you want this information?  What action will you take depending on the
> answer?

I'm building an initramfs for myself that can be thrown at any of my systems
and "just work" (and w/o using modules so that it'll work with most kernels).

I was reading in the kernel md.txt that there is a start degraded
option.  I wanted a way to prompt the user (or have a parameter on boot)
that would do this.  After reading it, I really wouldn't want to just enable
that since it was for dirty and degraded.

> If you just want mdadm to assemble as soon a a degraded array is possible,
> just use "mdadm -IR" - but I suspect you already know that.

Sort of, but I didn't think of -I and -R together.  Another question on
that.  If I have /sys/module/md_mod/parameters/start_ro set to 1, I use
-IR with each device, will a resync happen once all devices show up?

IE:
mdadm -IR /dev/sda1
mdadm -IR /dev/sdb1
mdadm -IR /dev/sdc1
At this point it would be running in degraded (start_ro = 1).
mdadm -IR /dev/sdd1
Does a resync happen here?  (assume there's no bitmap)

> > And of course, mdadm -I /dev/sdd1
> > makes the array fully active.
> > 
> > P.S. cantor2.suse.de[195.135.220.15] does pipelining even if pipelining
> > wasn't performed.
> I'm guessing this is a statement about SMTP? This would be why I got a bounce
>  <wakko@animx.eu.org>: host veg.animx.eu.org[76.7.162.186] said: 554 SMTP
>     synchronization error (in reply to MAIL FROM command)
> to my original mail.

Yes, w/o pipelining, MAIL command must not be sent without waiting for the
status code from the previous command (or initial connect).  I'm actually
surprised that postfix did that.

> I guess suse.de is not being conservative in what it sends, and animx is not
> being liberal in what it accepts...  Do you know what mail system is in use
> on animx??

I run both servers.  It hit my primary and rDNS wasn't available (temp
fail), so it hit my secondary and rDNS passed, but that system was
configured not to advertise pipelining due to some poorly setup systems that
had broken pipelining and had SMTP errors at the same time.  Both servers
use exim.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
