From: Daniel Brahneborg <daniel.com@wtnord.net>
Subject: Re: Status of Promise drivers?
Date: Tue, 30 Dec 2003 21:38:28 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031230213828.G14399@nettis.grimsta>
References: <20031230200012.C14399@nettis.grimsta> <3FF1CCC1.3050304@pobox.com> <20031230202447.D14399@nettis.grimsta> <3FF1D8AE.2000107@pobox.com> <20031230211826.F14399@nettis.grimsta> <3FF1DF2B.3000501@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FF1DF2B.3000501@pobox.com>; from jgarzik@pobox.com on Tue, Dec 30, 2003 at 03:25:15PM -0500
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Daniel Brahneborg <daniel.com@wtnord.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 30, 2003 at 03:25:15PM -0500, Jeff Garzik wrote:
> Daniel Brahneborg wrote:
> > In short: First I went 100% scsi (except for / on hda) with sata_sil
> > and sata_via. This made my computer halt when I activated my second
> > network card (8139 + via-rhine or another 8139). Then I went 100% ide
> > with the via82cxxx and siimage drivers, which made the network cards
> > work.  Disks on the VIA interface worked fine for simple file systems
> > but failed when used for Raid. Disks on the Silicon Image interface
> > failed both.  It even got badblocks from the Ext2 suite to report tons
> > of failures.  Smartmontools has no complaints, so the disks as such
> > are ok.
> 
> I definitely recommend IDE siimage driver for Silicon Image SATA (though 
> I will announce when my driver is fixed).

Not even the IDE driver handles raid correctly though, and the
badblocks thing was with that IDE driver.  Is there any debug information
I can provide you with, in order to help you fix this?

> For VIA SATA, neither IDE nor libata program the chipset 100%, so I'm 
> not surprised you're seeing failures.  I'm working with VIA to get more 
> details as we speak.  They've been helpful so far.  I would recommend 
> sata_via over the generic IDE driver, but that's sorta a toss-up at present.

Good, I like companies that are helpful. What would you estimate
the time frame for working raid support to?  10 minutes? A week?
A month?  Kernel 2.8?

/Basic

