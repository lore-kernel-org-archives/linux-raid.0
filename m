From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch mdadm] Add hot-unplug support to mdadm
Date: Wed, 7 Apr 2010 16:59:42 +1000
Message-ID: <20100407165942.1ab0f7e7@notabene.brown>
References: <4BBA1289.4010705@redhat.com>
	<20100407113035.3ca437f2@notabene.brown>
	<4BBBE7D2.6090608@redhat.com>
	<20100407053255.GB16693@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100407053255.GB16693@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 7 Apr 2010 07:32:55 +0200
Luca Berra <bluca@comedia.it> wrote:

> On Tue, Apr 06, 2010 at 10:02:58PM -0400, Doug Ledford wrote:
> >On 04/06/2010 09:30 PM, Neil Brown wrote:
> >> - I cannot say I like the process of hunting through /proc/mdstat for
> >>   a device name that textually matches the name that udev has just
> >>   removed from /dev.  It feels too indirect.
> >>   I was really hoping to just use /sys/$DEVPATH/holders to find the
> >>   containing arrays, but $DEVPATH has been destroyed before udev
> >>   gets to run anything .. even though the final object is still in
> >>   use.  That is really sad!
> >
> >I agree.  The fact that everything disappears before we can use it to
> >remove it from the array was a bit problematic.  And I too thought that
> >this was too indirect and error prone.  But, the fact remains that A) if
> 
> Is there any chance of having udev issuing a pre-remove event, before
> destroying /dev and sysfs, it would be far more useful than what we have
> now.

No.  udev has not ability to delay the kernel from removing things.
The kernel removes stuff, then sends a message to udev - udev responds by
cleaning up the user-space side.

If you want to know anything about a device on removal, you need to record
that information somewhere.  udev does this to some extent, so when a device
is removed, it knows the major/minor number (at least I assume that is how it
works). See /dev/.udev/db/

So we could generate uevents whenever a devices is added to or removed from
an array, then get udev to somehow record the current state so that when a
device is removed from the system, we know which array it is part of.
But that seems like a bit of a sledgehammer approach - my first impression is
that it would be worse than scanning /proc/mdstat.

Thanks,
NeilBrown
