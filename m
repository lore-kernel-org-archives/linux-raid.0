From: Thomas Horsten <thomas@horsten.com>
Subject: Re: ATARAID userspace configuration tool
Date: Tue, 10 Feb 2004 17:47:44 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.40.0402101743020.28534-100000@jehova.dsm.dk>
References: <402916F8.8050008@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <402916F8.8050008@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 10 Feb 2004, Jeff Garzik wrote:

> > On top of this it would be useful to make the underlying devices
> > inaccessible after the mapped device is created (to prevent people from
> > doing things like fdisk /dev/hda, when what they really wanted was
> > something like fdisk /dev/ataraid/disc).
>
> This would be something to talk with the md maintainer about, I think.
> I'm not sure we want to do this, since the user may have a valid reason
> to access the underlying disk.

That's true of course, one example would be to remove the RAID superblock
with dd. The problem is if this is done by mistake, it could be
catastrophic. It might be enough to remove the wrong partitions (with
BLKPG_DEL_PARTITION, thanks to Matt Domsch for pointing me in the right
direction), it will at least prevent mkfs /dev/hda1 etc, which would have
unforeseeable consequences.

But when the RAID/DM device is up, would it not be possible to generate an
EACCESS or EINUSE error if someone tries to open the underlying device? If
he really wants to do it, he can just stop the DM device first.

// Thomas
