From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
  by user
Date: Wed, 2 Nov 2011 02:16:15 +0100
Message-ID: <20111102011615.GA5289@tango.0pointer.de>
References: <20110125042814.GA9727@tango.0pointer.de>
 <AANLkTik7dd5SHkuBVrS6LLDR9v57GsFjjxDKQKPp-YVL@mail.gmail.com>
 <20110208094843.GD11446@tango.0pointer.de>
 <AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
 <20110208110730.GF23157@tango.0pointer.de>
 <AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
 <20110208172822.GC21847@tango.0pointer.de>
 <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
 <20111031110613.GA1402@tango.0pointer.de>
 <20111102114416.7879b77f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111102114416.7879b77f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 02.11.11 11:44, NeilBrown (neilb@suse.de) wrote:

> > We nowadays jump back into the initrd when we shut down, so that the
> > initrd disassembles everything it assembled at boot time. This for the
> > first time enables us to ensure that all layers of our stack are in a
> > sane state (i.e. fully offline) when we shut down, regardless in which
> > way you stack it.
> 
> This sounds particularly elegant.
> Is there some part of the filesystem, that survives through the whole process
> - from before / is mounted until after it is unmounted?
>
> Presumably this would be /run if anything.

Yes. /run is usually mounted by the initrd these days, and the initrd
itself places its binaries in /run/initramfs/ which systemd then
pivot_root()s into at shutdown.

> mdmon must be running from the time that / becomes writable until after it
> becomes readonly.

I'd really prefer if we could somehow make it something that isn't
special and we could just shutdown

> If we can have it from before it is mounted until after it is unmounted, that
> might be even better.

Well, that could work if mdmon is invoked in the initrd only. If mdmon
is always running from the initrd this would solve the issue that it
keeps files on the real root referenced thus making unmounting of /
impossible.

However, there might be complexities here: what happens if the user
creates an MD device during normal operation, so that mdmon is started
at runtime, and not from the initrd?

That said I definitely prefer that if mdmon really wants to avoid
systemd and live independent of it that it does so by being invoked from
the initrd, so that it runs completely independently from all systemd
book keeping. 

If this is what you want, then we could come up with a simple scheme
like "a process owned by root who has +t set on /proc/$PID/stat" is
excluded from systemd's killing.

But again, I really think that mdmon should just be fixed to become a
daemon that can be shtu down at any time.

> (It is possible to start a new one which replaces the old one but if that was
> only used for version upgrades, that would be best).

If you do upgrades like that then you end up with a version of mdmon
running that is still referencing the root dir. That means the initrd
disassembling will break.

> So if mdmon has a 'cwd' and all open files in /run (and the executable
> elsewhere in the same filesystem), could it easily survive the 'kill all
> processes before unmounting /' thing?

Right now no. But if the +t scheme would work for you we could at
that. But you'd need a good story how to handle upgrades and arrays that
are assembled during ruintime (i.e. after initrd)?

> > However, just excluding mdmom from being killed will not make this work,
> > simply because jumping into initrd only works sensibly if we can drop
> > all references to all previous mounts which requires us to have only one
> > process running at that time, and one process only.
> > 
> > It always boils down to the same thing: mdmon must be something we can
> > shutdown cleanly like every other process. Excluding it from that will
> > just move the problem around, but not fix it.
> 
> My ideal would be that you just ignore mdmon.
> After unmounting '/', you shutdown md arrays with "mdadm -Ss" and then mdmon
> will spontaneously disappear.

That's still a chicken and egg problem. We cannot unmount / until all
references to files on / are dropped. For that we need all processes
running from it terminated. That means mdmon needs to go first, and only
then we can unmount /.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
