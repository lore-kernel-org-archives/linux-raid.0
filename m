From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: User space RAID
Date: Wed, 18 Nov 2009 00:14:54 +0100
Message-ID: <874oosn3pt.fsf@frosties.localdomain>
References: <20091117193650.GA2748@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091117193650.GA2748@lazy.lzy> (Piergiorgio Sartor's message of
	"Tue, 17 Nov 2009 20:37:23 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> writes:

> Hi all,
>
> question for the experts.
>
> It would be possible, excluding performances, to
> build an user-space RAID system?
>
> I mean, something like fuse does, with a user space
> daemon to perform the math, especially for RAID-6,
> and the rest, together with a small kernel module.
>
> Or there are technical limitations which make this
> approach impossible with the current architecture?
>
> Just curious,
>
> bye,

You can use fuse to create a filesystem containing just one file,
which represents your user-raid, and mount that loopback. Since you
can already do it it can't be impossible. It just isn't optimal.


If you are truely interested then look at fuse and cuse and create a
buse along the same lines. I have a few features I would like to see:

1) zero-copy (with splice()?)
   Currently fuse calls read() to get the data for a write
   request. This copies the data into the supplied buffer.
   It would be better if one could splice() the data into a pipe and
   then splice it back onto the actual device/file the data resides
   on.

2) async crypto api support
   Some hardware has support for XOR or AES. The kernel has a nice API
   for this supporting both software and hardware drivers. It would be
   nice if one could interface with that API from userspace. For good
   performance this should be zero-copy again. So one would just
   splice the data into it and splice the result out of it.

3) barrier support
   Currently (last I checked) the loopback device has no barrier
   support and I'm not sure how fuse should act on barriers.
   A buse [Block device in User SpacE] (like fuse and cuse) should
   have a callback for barriers and probably not use the loopback hack.


4) block ioctl support
   Fuse has a callback for ioctls. Not sure if that is sufficient to
   handle block ioctls or if something needs to be added there. But it
   would be nice if one could request the size and geometry and so on.

MfG
        Goswin
