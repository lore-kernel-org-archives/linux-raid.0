From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: Linux RAID metadata format docs?
Date: Fri, 14 Nov 2003 21:31:14 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031114193114.GB1080@mea-ext.zmailer.org>
References: <20031114185013.GA11930@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031114185013.GA11930@gtf.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 14, 2003 at 01:50:13PM -0500, Jeff Garzik wrote:
> Do any docs exist, that describe the on-disk md format?

Not as such.   An  H-file  isn't a document in itself...

> I'm talking with a vendor that would like to support booting off of 
> "Linux RAID" (as they call it), from their card's BIOS, which implies
> the vendor would need to add support for the md format to their BIOS.
> 
> 	Jeff

Problem there is the multitude of partition schemes, and that RAID
superblocks are inside the partitions...

Nevertheless I would love to be able to boot from _any_ of disks
in a bootable RAID1 diskset.  I have just experimented with Highpoint's
RocketRaid 1520, which almost can do that.  It fails if the primary
disk is offline, but succeeds if secondary is out.
I also liked their superblock location - very early in disk.
Negative thing in the HPT BIOS is, that if it detects a fault, it
wants user input instead of just trying starting disks a bit more 
persistently, and continuing _soon_ the boot in degraded RAID1 mode
without any user input.

After all, Sun has been able to do that for a very long time,
it should be possible in PC hardware, too.
(In Suns we have to define a set of boot devices into prom level,
 and there all devices are different, and retain their identity
 forever independent of plugging new interface cards into system,
 but that is another story...)

/Matti Aarnio
