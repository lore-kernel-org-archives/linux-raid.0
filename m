From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Status of Promise drivers?
Date: Tue, 30 Dec 2003 15:25:15 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FF1DF2B.3000501@pobox.com>
References: <20031230200012.C14399@nettis.grimsta> <3FF1CCC1.3050304@pobox.com> <20031230202447.D14399@nettis.grimsta> <3FF1D8AE.2000107@pobox.com> <20031230211826.F14399@nettis.grimsta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031230211826.F14399@nettis.grimsta>
To: Daniel Brahneborg <daniel.com@wtnord.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel Brahneborg wrote:
> In short: First I went 100% scsi (except for / on hda) with sata_sil
> and sata_via. This made my computer halt when I activated my second
> network card (8139 + via-rhine or another 8139). Then I went 100% ide
> with the via82cxxx and siimage drivers, which made the network cards
> work.  Disks on the VIA interface worked fine for simple file systems
> but failed when used for Raid. Disks on the Silicon Image interface
> failed both.  It even got badblocks from the Ext2 suite to report tons
> of failures.  Smartmontools has no complaints, so the disks as such
> are ok.

I definitely recommend IDE siimage driver for Silicon Image SATA (though 
I will announce when my driver is fixed).

For VIA SATA, neither IDE nor libata program the chipset 100%, so I'm 
not surprised you're seeing failures.  I'm working with VIA to get more 
details as we speak.  They've been helpful so far.  I would recommend 
sata_via over the generic IDE driver, but that's sorta a toss-up at present.

	Jeff



