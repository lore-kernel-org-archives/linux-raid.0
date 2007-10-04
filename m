From: Andrew Clayton <andrew@digital-domain.net>
Subject: Re: RAID 5 performance issue.
Date: Thu, 4 Oct 2007 20:06:50 +0100
Message-ID: <20071004200650.0c8e026f@alpha.digital-domain.net>
References: <20071003105321.06943824@zeus.pccl.info>
	<Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
	<20071003211910.439ded54@alpha.digital-domain.net>
	<72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
	<20071004150831.6edbf926@zeus.pccl.info>
	<Pine.LNX.4.64.0710041009150.8275@p34.internal.lan>
	<20071004153656.16e10f9e@zeus.pccl.info>
	<Pine.LNX.4.64.0710041038400.8275@p34.internal.lan>
	<20071004160316.5332a370@zeus.pccl.info>
	<470518CD.10405@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <470518CD.10405@maine.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, David Rees <drees76@gmail.com>, Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 04 Oct 2007 12:46:05 -0400, Steve Cousins wrote:

> Andrew Clayton wrote:
> > On Thu, 4 Oct 2007 10:39:09 -0400 (EDT), Justin Piszcz wrote:
> >
> >
> >   >> What type (make/model) of the drives?
> >>     >
> > The drives are 250GB  Hitachi Deskstar 7K250 series ATA-6 UDMA/100
> >   A couple of things:
> 
>     1. I thought you had SATA drives
>     2. ATA-6 would be UDMA/133
> 
> The SATA-1 versions of the 7K250's did not have NCQ. The SATA-2
> versions do have NCQ. If you do have SATA drives, are they SATA-1 or
> SATA-2?

Not sure, I suspect SATA 1 seeing as we've had them nearly 3 years.

Some bits from dmesg

ata1: SATA max UDMA/100 cmd 0xffffc20000aa4880 ctl 0xffffc20000aa488a
bmdma 0xff ffc20000aa4800 irq 19
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-6: HDS722525VLSA80, V36OA63A, max UDMA/100
ata1.00: 488397168 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100

> Steve

Andrew
