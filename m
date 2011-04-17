From: Sven Eschenberg <sven@whgl.uni-frankfurt.de>
Subject: Re: Recommended pci-e 1x SATA cards.
Date: Sun, 17 Apr 2011 23:18:44 +0200
Message-ID: <1303075124.2009.28.camel@HansWurst>
References: <4DA6CCFE.8020708@crc.id.au> <20110414185304.5bc1cca5@natsu>
	 <4DA6F3B2.8080402@crc.id.au> <4DA7513C.5020505@hardwarefreak.com>
	 <20110415105846.1c4ec630@natsu> <4DA8B91C.8050005@hardwarefreak.com>
	 <20110416111554.09066e73@natsu> <4DA959E4.2080605@fnarfbargle.com>
	 <4DA9FED8.2000308@hardwarefreak.com> <4DAA7E46.6040309@fnarfbargle.com>
	 <4DAB3344.2090502@hardwarefreak.com>
	 <alpine.DEB.2.00.1104172042570.14027@uplift.swm.pp.se>
	 <4DAB4CF1.8050409@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DAB4CF1.8050409@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Are you sure about this?

All those nifty specification updates for CPUs tell quite a different
story. And yes IC producers usually have such things too, they just
prefer to not publish them openly but rather decide to gag their
customers (like OEMs) by non disclosure agreements, if those plan on
getting a hold of those spec updates to work around the issues instead
of throwing away all the chips they bought.

But that just on a side note.

Bad PCB design and bad quality components are usually the more common
things causing problems. On the other hand, what was that story about
the ICHs in quite some chipsets having problems with the SATA Ports?

http://newsroom.intel.com/community/intel_newsroom/blog/2011/01/31/intel-identifies-chipset-design-error-implementing-solution

BTW: Big OEMs decided to get those broken chips nevertheless for
notebooks, because the problems usually do not occur with the first two
ports and the chips will probably be VERY cheap *eg*.

Marvell had issues (design) with the legacy PATA Interface on some
PATA/SATA chips earlier, then bumped the rev. and fixed the silicon.

Design errors and flaws are extremely common and there are certainly
enough in any IC, question is, if you hit 'em and if they cause
problems. And don't forget all the possible problems that arise from
production flaws (bad wafers etc.).

Anyway, concerning the original issue a bad PCB is probably rather the
issue. And SIL is as good a choice as Marvell or JMicron in most cases.

Regards

-Sven

On Sun, 2011-04-17 at 15:26 -0500, Stan Hoeppner wrote:

> The problem is almost never a design flaw with the main IC (whether
> SCSI, SATA, GPU, etc), but almost always the board implementation.  The
> big money is in the ICs, and they have high QC.  Board (PCB)
> manufacturing cost is often $0.50 USD/board or less.  If all $0.50 of
> that board making was QC, is that sufficient? (rhetorical)
> 


