From: Neil Brown <neilb@suse.de>
Subject: Re: Device state during an incremental assembly
Date: Mon, 22 Nov 2010 10:19:19 +1100
Message-ID: <20101122101919.08822c44@notabene.brown>
References: <20101120015225.GA9625@animx.eu.org>
	<20101121144159.GB29163@animx.eu.org>
	<20101122075840.1153b020@notabene.brown>
	<20101121224522.GA10945@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101121224522.GA10945@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 21 Nov 2010 17:45:22 -0500
Wakko Warner <wakko@animx.eu.org> wrote:

> Neil Brown wrote:
> > On Sun, 21 Nov 2010 09:41:59 -0500
> > > > Note: if you don't find that there is enough detail in this answer, it
> > > > simply
> > > > reflects the level of detail in the question :-)
> > > 
> > > Next, mdadm -I /dev/sdb1
> > > Still not enough.
> > > Next, mdadm -I /dev/sdc1
> > > At this point, I could start the array in degraded.  This is what I'd like
> > > to beable to query from beneath /sys/block/md0 or some where else.
> > 
> > Ahh.. In this case the answer is actually "no" - sorry.
> 
> Ok, I wasn't sure so I figured I'd ask.
> 
> > The answer is a non-trivial function of:
> >   the raid level
> >   the number of available non-spare devices
> >   (for raid10) which slots the available non-spare devices fill.
> 
> I've tested only on raid5 at the moment.
> 
> > All of this information is available in sysfs, and mdadm has code to perform
> > the computation and then take appropriate action.  But there is no simple way
> > to get this information.
> 
> For this environment, I'm limited to what busybox and it's ash can do.
> 
> > Why do you want this information?  What action will you take depending on the
> > answer?
> 
> I'm building an initramfs for myself that can be thrown at any of my systems
> and "just work" (and w/o using modules so that it'll work with most kernels).
> 
> I was reading in the kernel md.txt that there is a start degraded
> option.  I wanted a way to prompt the user (or have a parameter on boot)
> that would do this.  After reading it, I really wouldn't want to just enable
> that since it was for dirty and degraded.

There are two distinct issues here and I'm not sure which one you are
thinking about.

On one hand we can ask whether we should start a degraded array if the array
is dirty.  In this case we should certainly wait until every possible device
has been discovered to maximise the chance that the array can be started
non-degraded.  This is because a dirty degraded array can contain
undetectable data corruption.   But usually we do want to start such an array
because having the data available is more important than a risk that some of
it is corrupted.  The reason this requires a kernel option, or an '-f' to
"mdadm -A" is to ensure that the sysadmin knows that there is a small chance
of corruption.

On the other hand, we can ask whether we should start a degraded array if
there are enough devices to do that, though there could still be some more
devices to be found.  In this case it depends a bit on how long it takes to
discover devices and how long we are happy to wait.   Sometimes you might
want to ask the sysadmin "have all the usb devices been plugged in, or should
I want for more"...


The first is answered by giving '-f' to mdadm, or not.
The second by giving '-R' to mdadm, or not.


> 
> > If you just want mdadm to assemble as soon a a degraded array is possible,
> > just use "mdadm -IR" - but I suspect you already know that.
> 
> Sort of, but I didn't think of -I and -R together.  Another question on
> that.  If I have /sys/module/md_mod/parameters/start_ro set to 1, I use
> -IR with each device, will a resync happen once all devices show up?
> 
> IE:
> mdadm -IR /dev/sda1
> mdadm -IR /dev/sdb1
> mdadm -IR /dev/sdc1
> At this point it would be running in degraded (start_ro = 1).
> mdadm -IR /dev/sdd1
> Does a resync happen here?  (assume there's no bitmap)

It depends.
On a recent kernel, if nothing had written to the array, then a resync won't
be required when /dev/sdd1 is included - it will just change to array from
being degraded to being optimal.
However if there has been any write - and mounting a filesystem often writes
something to the superblock - then a resync (actually a recovery) will happen
at this point.  sdd1 will be seen as a new spare to be added and rebuilt.

NeilBrown


