From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: What will happen with spares in this scenario?
Date: Mon, 29 Jun 2009 18:08:56 +0200
Message-ID: <87zlbruinb.fsf@frosties.localdomain>
References: <ab50889f0906290828s44e10b14n1af6d23556e3f0ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ab50889f0906290828s44e10b14n1af6d23556e3f0ee@mail.gmail.com>
	(John McNulty's message of "Mon, 29 Jun 2009 16:28:29 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: John McNulty <johnmcn1@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John McNulty <johnmcn1@googlemail.com> writes:

> Hello,
>
> I have 16 disks and two RAID controllers, 8 disks per controller.
> These are c0d0 -> c0d7 and c1d0 -> c1d7.    The first disk on each
> controller is configured with two partitions:  300MB (p1) and the rest
> of the disk (p2).   Then I make some mirror plexes:
>
> c0d0p1 + c1d0p1 = md0
> c0d0p2 + c1d0p2 = md1
> c0d1p1 + c1d1p1 = md2
> c0d2p1 + c1d2p1 = md3
> c0d3p1 + c1d3p1 = md4
> c0d4p1 + c1d4p1 = md5
> c0d5p1 + c1d5p1 = md6
> c0d6p1 + c1d6p1 = md7
>
> Disks c0d7p1 and c1d7p1 are added to md7 as spares, and all the
> mirrors are configured to be in the same spare-group in mdadm.conf.
>
> If I loose a disk in a mirror other than md7, then md will steal a
> spare disk from md7 and use that.  But what if the disk is c0d0 or
> c1d0?  There are two mirror plexes sitting on top of these disks
> mirroring different partitions.  Will md work this out, partition the
> spares accordingly and fix up both using one spare disk, or will it
> just break, or will it get really confused and try to use both the
> spares in md7 to resolve the situation?
>
> I think I already know what the answer's going to be and that I've
> just shot myself in the foot?  Well, not quite as this isn't a live
> server yet so I have time to correct this.

Looks like it. I think it will use c0d7p1 to fix md0 and c1d7p1 to fix
md1. So drop md1, make c0d0p1 as big as the others and then partition
md0 eigther directly or via lvm.

Or write your own handler to add sparse to failing devices that knows
when it needs to partition.

> Rgds,
>
> John

MfG
        Goswin
