From: Daniel Brahneborg <daniel.com@wtnord.net>
Subject: Re: Status of Promise drivers?
Date: Tue, 30 Dec 2003 21:18:26 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031230211826.F14399@nettis.grimsta>
References: <20031230200012.C14399@nettis.grimsta> <3FF1CCC1.3050304@pobox.com> <20031230202447.D14399@nettis.grimsta> <3FF1D8AE.2000107@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FF1D8AE.2000107@pobox.com>; from jgarzik@pobox.com on Tue, Dec 30, 2003 at 02:57:34PM -0500
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Daniel Brahneborg <daniel.com@wtnord.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 30, 2003 at 02:57:34PM -0500, Jeff Garzik wrote:
> Daniel Brahneborg wrote:
> > On Tue, Dec 30, 2003 at 02:06:41PM -0500, Jeff Garzik wrote:
> >>Those who ignore the author stating the Silicon Image driver is _alpha_ 
> >>and unfinished do so at their own risk.
> > 
> > Is this true for both the IDE driver and the SCSI driver?
> 
> Only the "scsi" driver, sata_sil.  People do have some problems with the 
> IDE driver siimage, but it is on the whole much more stable.

I'm one of the people with problems...

> > Is the same driver used for the TX4 card? Checking my logs even the
> > VIA driver seems to have problems running under Raid. Both Raid1
> > and Raid5 gives me corrupted files, unless I turn off DMA.
> 
> sata_promise is used for all known Promise SATA cards.

Great!

> Which VIA driver are you referring to?  And PATA or SATA?  You need to 
> be more specific :)   The drivers/ide via82cxxx driver seems to work for 
> PATA.  The sata_via ("scsi") driver and the generic IDE driver work for 
> VIA SATA, but people have reported problems on x86-64.

SATA, with the via82cxxx driver.  It works fine for simple partitions,
which I guess is what most people uses.

In short: First I went 100% scsi (except for / on hda) with sata_sil
and sata_via. This made my computer halt when I activated my second
network card (8139 + via-rhine or another 8139). Then I went 100% ide
with the via82cxxx and siimage drivers, which made the network cards
work.  Disks on the VIA interface worked fine for simple file systems
but failed when used for Raid. Disks on the Silicon Image interface
failed both.  It even got badblocks from the Ext2 suite to report tons
of failures.  Smartmontools has no complaints, so the disks as such
are ok.

/Basic

