From: Chris Murphy <lists@colorremedies.com>
Subject: Re: What are mdadm maintainers to do? (error recovery redundancy/data loss)
Date: Tue, 17 Feb 2015 18:02:00 -0700
Message-ID: <CAJCQCtTv-HMX77GWqA+_1rfkWodsTETp_Y3w5En-N4nGCymWsA@mail.gmail.com>
References: <loom.20150214T222329-324@post.gmane.org>
	<20150216142845.0d50207c@notabene.brown>
	<loom.20150216T124230-883@post.gmane.org>
	<54E1EDEA.1030503@turmel.org>
	<loom.20150216T165111-551@post.gmane.org>
	<54E226B5.1080500@turmel.org>
	<loom.20150216T183419-387@post.gmane.org>
	<20150217104906.62d36c62@notabene.brown>
	<loom.20150217T080345-764@post.gmane.org>
	<CAJCQCtQvoB0yPPc=RXPPyJhpaFwH0pQTRCRaR_ycTbzHrD6rLw@mail.gmail.com>
	<54E3C51C.2080106@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54E3C51C.2080106@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 17, 2015 at 3:47 PM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:

> If we enable SCT ERC on every drive that supports it, and we are using the
> drive (only) in a RAID0/linear array then what is the downside?

Unnecessary data loss.


> As I
> understand it, the drive will no longer try for > 120sec to recover the data
> stored in the "bad" sector, and instead return an unreadable error message
> in a short amount of time (well below 30 seconds) which means the driver
> will be able to return a read error to the application (or FS or MD) and the
> system as a whole will carry on.

Not necessarily, it depends what's in that sector. If it's user data,
this means a sector (or possibly more) of data loss. If it's file
system metadata it means progressive file system corruption.

Configuring the drive to give up too soon is completely inappropriate
for single, raid0 or linear configurations.

Arguably the drive should have already recovered this data. If a
longer recovery can recover, then why isn't the drive writing the data
back to that sector so that next time it isn't so ambiguous that it
requires long recovery? I can't answer that question. In some case
that appears to happen in other cases it's not. But the followup is
that there really ought to be some way for user space to get access to
these kinds of errors rather than them accumulating until disaster
strikes.

The contra argument to that is, it's still cheaper to buy the proper
use case specified drive.


>If we didn't enable SCT ERC, then the
> entire drive would vanish, (because the timeout wasn't changed for the
> driver) and the current read and every future read/write will all fail, and
> the system will probably crash (well, depending on the application, FS
> layout, etc).

Umm no. If SCT ERC remains a high value or disable, while also
increasing the kernel command timer, the drive has a longer chance to
recover. That's the appropriate configuration for single, linear, and
raid0.


>
> So, IMHO, it seems that by default, every SCT ERC capable drive should have
> this enabled by default. As a part of error recovery (ie, crap that really
> important data stored on those few unreadable sectors) the user could
> manually disable SCT ERC and re-attempt to request the data from the drive
> (eg, during dd_rescue or similar).

If you do this for single, linear, or raid0 it will increase the
incident of data loss that would otherwise not occur if deep/long
recovery times were available.

Before changing these settings, there should be some better
understanding of what the manufacturer defined recovery times in the
real world actually are, and whether or not these long recoveries are
helpful. Presumably they'd say they are helpful, but I think we need
facts to contradict their position before second guessing the default
settings. And we have such facts to do exactly that when it comes to
raid1, 5, 6 with such drives which is why the recommendation is to
change SCT ERC if supported.



> Secondly, changing the timeout for those drives that don't support SCT ERC,
> again, it is fairly similar to above, we get the error from the drive before
> the timeout, except we will avoid the only possible downside above (failing
> to read a very unlikely but possible to read sector). Again, we will avoid
> dropping the entire drive, even if all operations on this drive will stop
> for a longer period of time, it is probably better than stopping
> permanently.

Not by default. You can't assume any drive hang is due to bad sectors
that merely need a longer recovery time. It could be some other error
condition, in which case doing a 120 or 180 second *by default* delay
means no error messages at all for upwards of 3 minutes.

And in any case the proper place to change the default kernel command
timer value is in the kernel, not with a udev rule.

I don't know if a udev rule can say "If the drive exclusively uses md,
lvm, btrfs, zfs raid1, 4+ or nested of those, and if the drive does
not support configurable SCT ERC, then change the kernel command timer
for those devices to ~120 seconds" then that might be a plausible
solution to use consumer drives the manufacturer rather explicitly
proscribes from use in raid...

But the contra argument to that is, why should anyone do this work for
(sorry) basically cheap users who don't want to buy the proper drive
for the specific use case? There are limited resources for this work.
And in fact the problem has a work around, if not a solution.

What we still don't have is something that reports any such problems
to user space.

-- 
Chris Murphy
