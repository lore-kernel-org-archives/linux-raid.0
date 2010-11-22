From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: Device state during an incremental assembly
Date: Sun, 21 Nov 2010 20:39:30 -0500
Message-ID: <20101122013930.GA28112@animx.eu.org>
References: <20101120015225.GA9625@animx.eu.org> <20101121144159.GB29163@animx.eu.org> <20101122075840.1153b020@notabene.brown> <20101121224522.GA10945@animx.eu.org> <20101122101919.08822c44@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101122101919.08822c44@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Sun, 21 Nov 2010 17:45:22 -0500
> Wakko Warner <wakko@animx.eu.org> wrote:
> 
> > Neil Brown wrote:
> > For this environment, I'm limited to what busybox and it's ash can do.
> > 
> > > Why do you want this information?  What action will you take depending on the
> > > answer?
> > 
> > I'm building an initramfs for myself that can be thrown at any of my systems
> > and "just work" (and w/o using modules so that it'll work with most kernels).
> > 
> > I was reading in the kernel md.txt that there is a start degraded
> > option.  I wanted a way to prompt the user (or have a parameter on boot)
> > that would do this.  After reading it, I really wouldn't want to just enable
> > that since it was for dirty and degraded.
> 
> There are two distinct issues here and I'm not sure which one you are
> thinking about.

I believe both.

> On one hand we can ask whether we should start a degraded array if the array
> is dirty.  In this case we should certainly wait until every possible device
> has been discovered to maximise the chance that the array can be started
> non-degraded.  This is because a dirty degraded array can contain
> undetectable data corruption.   But usually we do want to start such an array
> because having the data available is more important than a risk that some of
> it is corrupted.  The reason this requires a kernel option, or an '-f' to
> "mdadm -A" is to ensure that the sysadmin knows that there is a small chance
> of corruption.

That's why I was placing a similar option to the environment I'm building. 
In this case, it would be a UI question instead of a parameter.  I see no
reason to automatically start dirty-degraded arrays (atleast for what I'm
doing)

If for instance the 4 drive array has 3 drives added, it's dirty, and I want
to force it to run for whatever reason, would mdadm -R -f do it?  Or would
it be something that I'd have to shutdown the inactive array and rebuild it
with -A -f?  (This would be a menu option.  Also the start_ro module option
would always be 1 in my case)

> On the other hand, we can ask whether we should start a degraded array if
> there are enough devices to do that, though there could still be some more
> devices to be found.  In this case it depends a bit on how long it takes to
> discover devices and how long we are happy to wait.   Sometimes you might
> want to ask the sysadmin "have all the usb devices been plugged in, or should
> I want for more"...

For this one, same thing, 4 drive array, 3 added.  I know I can start it
by echo read-auto > /sys/block/mdX/md/array_state.  This environment is
setup to avoid writing until it mounts the root fs.

My original intention for this was local hard disks, possibly encrypted, but
with the design, USB shouldn't be any problems.  For my tests, my goal is to
beable to get to my root if each disk device to be encrypted (that is before
mdX), then the md device to be encrypted, followed by lvm and an lv that is
encrypted.  Overkill and very low performance, but it's just testing =)

> The first is answered by giving '-f' to mdadm, or not.
> The second by giving '-R' to mdadm, or not.

Ok.  That's good.

> > > If you just want mdadm to assemble as soon a a degraded array is possible,
> > > just use "mdadm -IR" - but I suspect you already know that.
> > 
> > Sort of, but I didn't think of -I and -R together.  Another question on
> > that.  If I have /sys/module/md_mod/parameters/start_ro set to 1, I use
> > -IR with each device, will a resync happen once all devices show up?
> > 
> > IE:
> > mdadm -IR /dev/sda1
> > mdadm -IR /dev/sdb1
> > mdadm -IR /dev/sdc1
> > At this point it would be running in degraded (start_ro = 1).
> > mdadm -IR /dev/sdd1
> > Does a resync happen here?  (assume there's no bitmap)
> 
> It depends.
> On a recent kernel, if nothing had written to the array, then a resync won't
> be required when /dev/sdd1 is included - it will just change to array from
> being degraded to being optimal.

Do you know off hand which kernel that would be?

> However if there has been any write - and mounting a filesystem often writes
> something to the superblock - then a resync (actually a recovery) will happen
> at this point.  sdd1 will be seen as a new spare to be added and rebuilt.

I fully understand this part.

I sure do appreciate your responces, it'll help me greatly with this little
project.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
