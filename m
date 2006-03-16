From: Andre Noll <maan@systemlinux.org>
Subject: Re: A random initramfs script
Date: Thu, 16 Mar 2006 01:23:30 +0100
Message-ID: <20060316002330.GT27173@skl-net.de>
References: <87u0a0so6w.fsf@hades.wkstn.nix> <20060315002527.GO27173@skl-net.de> <87lkvcrtzu.fsf@hades.wkstn.nix> <20060315185750.GP27173@skl-net.de> <87hd5zs9zm.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87hd5zs9zm.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
List-Id: linux-raid.ids

On 20:56, Nix wrote:

> > What I meant is that it never gets overmounted by a real rootfs.
> 
> The rootfs never overmounts anything. Do you mean `it never gets
> overmounted by a real root filesystem'?

Yes, that's what I tried to say. Sorry about the confusion. Basically
I have three similar setups that work with the same init script:

	The main server which has all its filesystems on lvm.
	There is only one vg and only one pv, a raid 10 array. /bin,
	/etc, /home, /lib /root, /sbin, /tmp, /usr and /var are
	all lvs. They are mounted by the the init script of the
	initramfs. That script does the full boot and finally execs
	busybox init just do start the getty processes.

	A bunch of NFS clients. They boot similarly, but mount
	everything (except /etc) via NFS.

	The rescue system. Still the same, but does not mount anything
	as everything is contained in the initramfs.

None of these have a real root filesystem. nfsroot support isn't even
compiled in for the NFS clients.

> If so, that's a... most peculiar setup: I don't think I've ever heard of
> anything but systems meant to run on diskless kiosks and the occasional
> live cd running like that.

It works pretty well. My diskless desktop is up for more than 100
days and the main server had a similar uptime before I rebooted some
days ago (to try out dccp).

> ... but looking at init/initramfs.c, you should be safe as long as the
> initramfs can be loaded at all (on i386 I think there's a 16Mb limit on
> that but it depends on the arch and the bootloader and all sorts of
> horrid arcana: most arches have a much higher limit).

I just booted a rescue system on i386 which is definitely larger
than 16MB compressed.

> >                                I always thought an N MB initramfs
> > cuts about N MB of the main memory, plus some housekeeping data,
> > but that's all. This view is probably a little bit too naive ;)
> 
> It does, *unless* you switch root filesystems appropriately, that is,
> you unlink everything in the initramfs before `exec chroot'ing into the
> real root filesystem. In practice this has to be done by a dedicated C
> program in order to get away with deleting /dev and the very chroot
> binary itself :) and that's what busybox's switch_root does.

In view of this chicken-egg problem it looks much cleaner to me to avoid
the chroot :)

> >> ifconfig? route? ick. ip(8) is the wave of the future :) far more flexible
> >> and actually has a comprehensible command line as well.
> > 
> > Thanks for the tip. I'll give it a try.
> 
> <http://lartc.org/> describes many of its myriad extra features in more
> detail.

All that stuff seems to be fairly old, linux-2.6. isn't mentioned at
all and the cvs server doesn't work. Is it still up do date?

> >> I try to avoid running daemons out of initramfs, because all those daemons
> >> share *no* inodes with anything else you'll ever run: more permanent memory
> >> load for as long as those daemons are running, although at least it's
> >> swappable load.
> > 
> > Fair enough, but portmap is needed to mount NFS filesystems. How much
> > memory would be saved if I'd kill portmap after the mount and restart
> > it afterwards from a mounted filesystem?
> 
> All of it. The only reason running daemons from initramfs wastes memory
> is that if you've got the binaries open/running and you delete them, in
> standard Unix fashion the space used by them won't be reclaimed until
> they're closed/stopped --- and the standard procedure for switching from
> an initramfs involves unlinking everything on the filesystem.
> 
> There's *nothing* special about the rootfs filesystem on which initramfs
> runs except that it's a ramfs filesystem, and as such nonswappable, and
> that it's the start and end of the kernel's list of mount points (which
> means that unmounting it, mount --moving it, and so on, is impossible).
> It behaves just like a POSIX filesystem because it is one. In fact it's
> almost exactly the same as a tmpfs except that it's not swap-backed, and
> its maximum size can't be limited in the way tmpfs can. (tmpfs is a small
> hack atop ramfs.)

Thanks for the explanation. I really appreciate it!

> so why is dynamic scanning the preferred method in LVM,
> yet discouraged in the md world? I see some conflicted messages here ;)

I'm afraid, only Neil will be able to answer this. BTW: I agree with
you and do not see the point in hardwiring the UUIDs either.

> >> mdev is `micro-udev', a 255-line tiny replacement for udev. It's part of
> >> busybox.
> > 
> > Cool. Guess I'll have to update busybox..

done. The new busybox (from SVN) seems to work fine, just like the
old one did. The init script doesn't use mdev yet, but from a first
reading this is just a matter of translating /etc/udev/udev.conf
to the mdev syntax.

> You need SVN uClibc too (if you're using uClibc rather than glibc);
> older versions don't maintain the d_type field in the struct dirent, so
> mdev's scanning of /sys gets very confused and you end up with an empty
> /dev.

Damn. I just compiled 0.9.28. Guess this one is too old.

> > That's indeed much smaller than what I have (6 MB). However, what
> 
> 6Mb!? Ye *gods*.

Hehe, didn't god create his first initramfs within 6 MB, but was
arrested on Sunday, the seventh? :)

Seriously, what's 6 MB if the onboard graphic chip easily cuts away
another 64 MB?

> (Also, you do know about the `mdadm.uclibc' target in the mdadm
> makefile, right?

No, I didn't. Thanks for enlightening me.
Andre
-- 
The only person who always got his work done by Friday was Robinson Crusoe
