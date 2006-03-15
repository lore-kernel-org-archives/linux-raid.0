From: Andre Noll <maan@systemlinux.org>
Subject: Re: A random initramfs script
Date: Wed, 15 Mar 2006 19:57:50 +0100
Message-ID: <20060315185750.GP27173@skl-net.de>
References: <87u0a0so6w.fsf@hades.wkstn.nix> <20060315002527.GO27173@skl-net.de> <87lkvcrtzu.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87lkvcrtzu.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
List-Id: linux-raid.ids

On 08:29, Nix wrote:

> > I'm using a similar setup since December or so with no problems so
> > far. However, all my systems have initramfs as their rootfs.
> 
> (well, technically, *every* 2.6 system has an initramfs unpacked into
> its rootfs: it's just that for most people it's empty.)

What I meant is that it never gets overmounted by a real rootfs.

> There *is* a limit (depending on the size of the statically-populated
> page tables); right now I think it's 32Mb on i386/x86_64. Look out.

Care to explain a bit further? Are these statically-populated page
tables only used at boot time? I always thought an N MB initramfs
cuts about N MB of the main memory, plus some housekeeping data,
but that's all. This view is probably a little bit too naive ;)

> ifconfig? route? ick. ip(8) is the wave of the future :) far more flexible
> and actually has a comprehensible command line as well.

Thanks for the tip. I'll give it a try.

> I try to avoid running daemons out of initramfs, because all those daemons
> share *no* inodes with anything else you'll ever run: more permanent memory
> load for as long as those daemons are running, although at least it's
> swappable load.

Fair enough, but portmap is needed to mount NFS filesystems. How much
memory would be saved if I'd kill portmap after the mount and restart
it afterwards from a mounted filesystem?

> > The following works pretty well for me:
> > 
> > 	echo "DEVICE /dev/hd*[0-9] /dev/sd*[0-9] /dev/md[0-9]" > /etc/mdadm.conf
> > 	mdadm --examine --scan --config=/etc/mdadm.conf  >> /etc/mdadm.conf
> > 	mdadm --assemble --scan
> 
> Yeah, that would work. Neil's very *emphatic* about hardwiring the UUIDs of
> your arrays, though I'll admit that given the existence of --examine --scan,
> I don't really see why. :)

He likes to compare the situation with /etc/fstab. Nobody complains
about having to edit /etc/fstab, so why keep people complaining about
having to edit /etc/mdadm.conf?

> >> /sbin/mdev -s
> > 
> > What's mdev? udevstart works too, but it seems to be depreciated now.
> 
> mdev is `micro-udev', a 255-line tiny replacement for udev. It's part of
> busybox.

Cool. Guess I'll have to update busybox..

> > Minor suggestion:
> > 
> > 	if test -e /proc/mdstat; then /sbin/mdadm ...
> 
> Pointless, really: if /proc fails to mount we're dead anyway 

It's not about /proc, it's about /proc/mdstat. If the machine does
not have raid, there won't be a /proc/mdstat.

> I can be *sure* that RAID was built into this kernel
> because the initramfs is linked into the kernel image :)

OK. But then you'll need different init scripts for different setups.

> Binary sizes:
> 
> -rwxr-xr-x 1 root root 248580 Mar 12 17:15 bin/busybox
> -r-xr-xr-x 1 root root 512693 Mar  5 17:53 sbin/lvm
> -rwxr-xr-x 1 root root 173349 Mar  5 16:50 sbin/mdadm

That's indeed much smaller than what I have (6 MB). However, what
I like about using glibc is that there is no need to have different
versions of these tools. If I install a new mdadm, the next kernel's
initramfs will automatically contain the new version. Moreover, one
can add another binary to the initramfs simply by putting one more
line to a text file.

Thanks
Andre
-- 
The only person who always got his work done by Friday was Robinson Crusoe
