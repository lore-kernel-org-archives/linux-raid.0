From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Linux RAID metadata format docs?
Date: Fri, 14 Nov 2003 15:28:47 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031114202846.GA18577@gtf.org>
References: <20031114185013.GA11930@gtf.org> <20031114193114.GB1080@mea-ext.zmailer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031114193114.GB1080@mea-ext.zmailer.org>
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 14, 2003 at 09:31:14PM +0200, Matti Aarnio wrote:
> On Fri, Nov 14, 2003 at 01:50:13PM -0500, Jeff Garzik wrote:
> > Do any docs exist, that describe the on-disk md format?
> 
> Not as such.   An  H-file  isn't a document in itself...
> 
> > I'm talking with a vendor that would like to support booting off of 
> > "Linux RAID" (as they call it), from their card's BIOS, which implies
> > the vendor would need to add support for the md format to their BIOS.
> > 
> > 	Jeff
> 
> Problem there is the multitude of partition schemes, and that RAID
> superblocks are inside the partitions...

Yep.  Thought I consider it fairly pointless to support anything but
ms-dos partitions and EFI partitions.  Given limited development
resources, I don't see a huge need for (for example) BSD disklabel
support.


> Nevertheless I would love to be able to boot from _any_ of disks
> in a bootable RAID1 diskset.  I have just experimented with Highpoint's
> RocketRaid 1520, which almost can do that.  It fails if the primary
> disk is offline, but succeeds if secondary is out.
> I also liked their superblock location - very early in disk.
> Negative thing in the HPT BIOS is, that if it detects a fault, it
> wants user input instead of just trying starting disks a bit more 
> persistently, and continuing _soon_ the boot in degraded RAID1 mode
> without any user input.

Yeah, the main point is to be able to root in degraded mode, as well
as regular mode.

	Jeff


