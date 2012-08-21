From: Michael-John Turner <mj@mjturner.net>
Subject: Re: Controller problems during reshape -> can't continue reshape
 after reboot.
Date: Tue, 21 Aug 2012 17:15:09 +0100
Message-ID: <20120821161508.GD12850@majestic.pimp.org.za>
References: <5032963A.8000908@buttersideup.com>
 <5032DB8F.2010101@anonymous.org.uk>
 <50333DE6.8010708@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50333DE6.8010708@buttersideup.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@buttersideup.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 21, 2012 at 08:51:02AM +0100, Tim Small wrote:
> It was a Marvell 9125 AHCI card (highpoint branded), and I've had
> numerous problems with them locking up (the 9123s are worse), and have
> scrapped all of the Marvell 9123s already, and gone back to using a
> combination of Marvell's 88SX7042 (non-AHCI) cards, and Silicon Image
> 3132 etc. cards.

FWIW, I have a Marvell 9123[1] in one of my systems and found that
disabling NCQ on the two drives hooked to it[2] stopped any funnies.
Agreed, it's not the best of adapters, but it's been rock solid for the
year or so since I made that change.

[1] "Marvell Technology Group Ltd. 88SE9123 PCIe SATA 6.0 Gb/s controller (rev 10)"
[2] A pair of WD Scorpio Blacks in an md RAID1 set

-mj
-- 
 Michael-John Turner
 mj@mjturner.net      <>     http://mjturner.net/
