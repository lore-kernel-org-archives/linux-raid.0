From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] Hardware RAID offload
Date: Mon, 12 Jul 2004 13:09:07 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1089634146.11248.6.camel@localhost.localdomain>
References: <40F1A04E.8070105@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40F1A04E.8070105@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-raid@vger.kernel.org, Device mapper devel list <dm-devel@redhat.com>, Jens Axboe <axboe@suse.de>
List-Id: linux-raid.ids

On Sul, 2004-07-11 at 21:17, Jeff Garzik wrote:
> 1) Transaction sequencing.  Consider that N disk transactions comprise a 
> single RAID1 write.  The hardware can be set up to wait until all N 
> transactions are complete, before sending an interrupt.  This is 
> applicable to Marvell and Promise SATA, among others.

So this is basically IRQ mitigation. Can you flip the "cause an IRQ"
status on the fly ?

> 2) Copy elimination.  All disk transactions on the Promise SX4 go 
> through an on-board DIMM (128M - 2G), before being sent to the attached 
> controllers.  I would love to use this to eliminate data duplication on 
> RAID1 and RAID5 writes.

Big win for PCI cards because it cuts PCI bandwidth way down. It
doesn't seem like it should be that hard to add to the drivers either
depending upon how the RAM is presented. Is it mapped into PCI space ?

> Or maybe, allow the user to set a flag that tells md to pass a request 
> directly through to the low-level driver, in certain situations ("pass 
> through all RAID1 writes, but handle everything else in software").  /me 
> thinks out loud...

As some kind of driver "md_ops" or as a separate raid1-promise plugin ?


