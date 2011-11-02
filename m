From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
   by user
Date: Wed, 2 Nov 2011 14:32:25 +0100
Message-ID: <20111102133223.GC5119@tango.0pointer.de>
References: <20110208094843.GD11446@tango.0pointer.de>
 <AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
 <20110208110730.GF23157@tango.0pointer.de>
 <AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
 <20110208172822.GC21847@tango.0pointer.de>
 <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
 <20111031110613.GA1402@tango.0pointer.de>
 <20111102114416.7879b77f@notabene.brown>
 <20111102011615.GA5289@tango.0pointer.de>
 <20111102130334.09c3ab51@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111102130334.09c3ab51@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 02.11.11 13:03, NeilBrown (neilb@suse.de) wrote:

> > I'd really prefer if we could somehow make it something that isn't
> > special and we could just shutdown
> 
> It must remain running until the array that it manages is read-only and will
> never be written to again.  Then it can be shutdown gracefully.
> It may be awkward to shut it down gracefully at the moment - I'm not sure.  I
> can certainly fix that.

The big thing is that if things are done that way you'll always have the
chicken and egg problem: you really need to shut down mdmon before
unmounting root, but currently you require us to do it in the other
order too.

> > > If we can have it from before it is mounted until after it is unmounted, that
> > > might be even better.
> > 
> > Well, that could work if mdmon is invoked in the initrd only. If mdmon
> > is always running from the initrd this would solve the issue that it
> > keeps files on the real root referenced thus making unmounting of /
> > impossible.
> > 
> > However, there might be complexities here: what happens if the user
> > creates an MD device during normal operation, so that mdmon is started
> > at runtime, and not from the initrd?
> 
> Each instance of mdmon manages a set of arrays and must remain running
> until all of those arrays are readonly (or shut down).  This allows it to
> record that all writes have completed and mark the array as 'clean' so a
> resync isn't needed at next boot.

Why doesn't the kernel do that on its own?

> If a user creates an array while the system it running, it will not have the
> root filesystem on it.  So between unmounting the last non-root filesystem
> and unmounting root it is perfectly OK to stop that mdmon.

Well, that complicates things quite a bit, since that way the shutdown
logic has two very different paths.

> > That said I definitely prefer that if mdmon really wants to avoid
> > systemd and live independent of it that it does so by being invoked from
> > the initrd, so that it runs completely independently from all systemd
> > book keeping. 
> > 
> > If this is what you want, then we could come up with a simple scheme
> > like "a process owned by root who has +t set on /proc/$PID/stat" is
> > excluded from systemd's killing.
> 
> You couldn't just do the equivalent of
>   fuser -k /some/filesystem
>   umount /some/filesystem
> 
> iterating over filesystems with '/' last?
>
> Then anything that only uses the /run filesystem will survive.

What we do right now is this:

kill_all_processes();
do {
     umount_all_file_systems_we_can();
     read_only_mount_all_remaining_file_systems();
} while (we_had_some_success_with_that());
jump_into_initrd();

As long as mdmon references a file from the root disk we cannot umount
it, so the loop wouldn't be effective.

> > > (It is possible to start a new one which replaces the old one but if that was
> > > only used for version upgrades, that would be best).
> > 
> > If you do upgrades like that then you end up with a version of mdmon
> > running that is still referencing the root dir. That means the initrd
> > disassembling will break.
> 
> True.  A version upgrade would need to stash the binary in /run.
> It might be better to go the 'remount-readonly - then stop mdmon'
> route.

It is not sufficient to stash the binary in /run, you'd also need to
include your own libc and in fact every single other library or file you
use.

Why? If a system is upgraded library files are deleted and replaced by
new ones. If a process stays running with the original libraries mapped
the file system cannot be remounted read-only, since the file is only
deleted in theory, but needs to be deleted on disk, which can only
happen if the file is not referenced anymore. Hence, if the user does an
upgrade of *any* of the files mdmon has open we will not be able to
remount the fs these files are from read-only if the user did an upgrade
of any of the files. 

> > That's still a chicken and egg problem. We cannot unmount / until all
> > references to files on / are dropped. For that we need all processes
> > running from it terminated. That means mdmon needs to go first, and only
> > then we can unmount /.
> > 
> > Lennart
> > 
> 
> Does, or can, systemd remount '/' readonly before trying to unmount it and
> allow some task to run at that point?

Well, we try that as last resort.

> I guess it still needs to be able to differentiate processes that are holding
> write-access to the filesystem and so need to be killed, from processes are
> only holding read-access and so can be permitted to remain.

Basically what I saying here is that it's a really bad idea that mdmon
insists to stay around until after the file system is unmounted, even
though it itself is running from it. And the fact that mdmon doesn't
have any of those files open for writing doesn't help you very much
here, due to the upgrade/delete issue.

> I don't quite get your "+t on /proc/$PID/stat" suggestion:
> 
> # chmod +t /proc/self/stat
> chmod: changing permissions of `/proc/self/stat': Operation not permitted

Uh oh, I was sure that one could actually change the access mode of
files in /proc. Seems I was wrong. An alternative solution might be to
do argv[0][0]='!' in your code, to tell systemd to exclude your process
from killing. THis wouldbe inspired from shells changing the first char
of argv to "-" for login shells.

But again, I believe the right solution is to fix mdmon to make it
something that can be shut down normally at any time. That might mean
that some of its code has to move to the kernel, but otherwise you'll
always have this chicken and egg problem, and you cannot fix it properly.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
