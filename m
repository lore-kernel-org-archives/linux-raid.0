From: "Mike Garey" <random51k@gmail.com>
Subject: Re: Can't mount /dev/md0 after stopping a synchronization
Date: Wed, 5 Apr 2006 12:59:21 -0400
Message-ID: <c79e949d0604050959o6feb6badx5f854a937a337a1d@mail.gmail.com>
References: <c79e949d0604042045w2fb901c2rfb4c00984f6b8761@mail.gmail.com>
	 <4433E073.8040502@fnuck.dk>
	 <c79e949d0604050839k2287fefdm53f6abb08dfcae89@mail.gmail.com>
	 <5b170a7d0604050920p674e10a9u9e26a52fcf3933c1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5b170a7d0604050920p674e10a9u9e26a52fcf3933c1@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/5/06, Tuomas Leikola <tuomas.leikola@gmail.com> wrote:
> On 4/5/06, Mike Garey <random51k@gmail.com> wrote:
> > I tried booting from /dev/hdc1 (as /dev/md0 in grub) using a 2.6.15
> > kernel with md and raid1 support built in and this is what I now get:
> >
> > md: autodetecting raid arrays
> > md: autorun ...
> > md: considering hdc1 ...
> > md: adding hdc1 ...
> > md: created md0
> > md: bind:<hdc1>
> > raid1: RAID set md0 active with 1 out of 2 mirrors
> > md: ...autrun done.
> >
> > Warning: unable to open an initial console
> > Input: AT translated set 2 keyboard as /class/input/input0
> >
> > and then at this point, the system just hangs and nothing happens.  So
> > I seem to be getting closer.. If I try booting from a kernel without
> > raid1 and md support, but using an initrd with raid1/md modules, then
> > I get the "ALERT! /dev/md0 does not exist.  Dropping to a shell!"
> > message.  I can't understand why there would be any difference between
> > using a kernel with raid1/md support, or using an initrd image with
> > raid1/md support, but apparently there is.  If anyone else has any
> > suggestions, please keep them coming.
>
> Sounds like your initrd could use a command like
>
> mdadm --assemble /dev/md0 /dev/hda1 /dev/hdc1
>
> at some point before mounting the real rootfs. There are many cleaner
> examples in the list archive, but that should do the trick. It seems
> like your initrd-kernel doesn't autostart the raid for some reason
> (config option?).

but wouldn't I need to have /dev/md0 available before doing mdadm
--assemble?  When booting from an initrd image, /dev/md0 is never
created for some reason..

> Note, you should never do any read/write access to the component disks
> after creating the raid. I guess you know this already, but some
> wording seemed suspect.

I take it you mean after the disks are synchronized, it's a bad thing
to write directly to /dev/hda1 or /dev/hdc1... In my case, I've
written directly to /dev/hdc1, but it's the only disk in the array,
and I'm going to be resyncing /dev/hda1 anyways, so it seems in this
instance it's okay?

> Can you specify more what is the problem with mounting md0? The log
> snipped doesn't show any errors about that.

after googling a bit more, I seem to have found a solution to my problem:

http://linux.derkeiler.com/Mailing-Lists/Debian/2005-07/2953.html

It seems that when I followed rootraiddoc.97, "Step 4.3 Copy your
Debian system to RAID device.", issuing the command "cp -axu /
/mnt/md0" didn't copy over my /dev directory, which was mounted on a
separate partition (tmpfs on /dev type tmpfs) and since I used the -x
switch to cp, it forced it to stay on the current file system (which I
thought was okay, since I figured /dev was populated dynamically by
udev anyways).

In any case, I simply booted from /dev/hda1, mounted /dev/hdc1, then
copied /dev/console from hda1 to hdc1.  After this, I was able to
disconnect hda and boot into /dev/md0 on hdc1.  I guess I should've
figured this out when I first ran into the "Warning: unable to open an
initial console" error when booting from a raid1/md enabled kernel,
but at that point I switched to using an initrd image and everything
seemed fine (how wrong I was! :)

So in conclusion, I'm still unable to boot from a kernel with an
initrd image containing the md and raid1 modules (I'm sure this has
something to do with udev not creating /dev/md0 properly), but I can
successfully boot from a raid1/md enabled kernel.  So after a very
large diversion, I'm back to my original problem of trying to decrease
the sync time.  I've now disconnected the CDROM drive from the
secondary ide channel, and I've replaced the 40 conductor cable with
an 80 conductor cable.  Hopefully it won't take me 25 hours to
synchronize the second time around!

Thanks to everyone who offered advice and suggestions, your help was
greatly appreciated (and possibly this thread may help some other poor
soul in the future, should they run into a similar situation).

Mike
