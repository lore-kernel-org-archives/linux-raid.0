From: Stephen Kent <smkent@smkent.net>
Subject: Re: mdadm named array (metadata 1.2) and udev when assembling an
 array in initramfs
Date: Tue, 4 Nov 2014 10:17:57 -0800
Message-ID: <CAC45b7k0HXkm2TQWnQyk==mR1KuhKEDhs4AU1eWOFy1FLiW+Mw@mail.gmail.com>
References: <CAC45b7=-dZX-kxDZY3KBEPZhaTuUhTcqNjTL6y8X71q9oDjiwQ@mail.gmail.com>
 <5458970B.3050305@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5458970B.3050305@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 4, 2014 at 1:06 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>
> 01.11.2014 21:53, Stephen Kent wrote:
> > I have set up a machine to use an md array as the root device. I have
> > created the array with metadata type 1.2, name "root," on host
> > "optimus" (so the full metadata name is "optimus:root").
> >
> > I'm using Gentoo Linux (kernel 3.16.5-gentoo), and previously I had no
> > initramfs so I wrote a short one to assemble the array. My initramfs
> > sets the hostname and runs "mdadm -As," which correctly auto-assembles
> > the root device array on /dev/md/root (even without an
> > /etc/mdadm.conf).
> >
> > Once the initramfs script is finished, init starts which then starts
> > udev. Now, at this point the array is already assembled, but the
> > /dev/md/* name is lost (and so is /run/mdadm/map) since those files
> > were on the initramfs' tempfs root.
>
> This is your problem.  You should not lose neither /dev nor /run
> when switching root.  Usual thing to do is to mount tmpfs /dev and
> tmpfs /run in initramfs and do mount --move /dev /root/dev (and
> the same for /run) before switching root.
>
> Thanks,
>
> /mjt

Hm, interesting. I didn't realize a mount point could be moved, that's
good to know.

My initramfs is a short custom shell script that I wrote, basically
all it does is assemble the array and mount the root filesystem. I'm
not mounting a tmpfs and/or udev on /run and /dev, so unfortunately
there aren't any mount points to move to the target root mountpoint at
the end of init. /run and /dev are only mounted on my machine after
leaving the initramfs.

Fortunately, NeilBrown's patch works for me which solves the problem
and allows mdadm to work correctly with a minimal initramfs.

Stephen
