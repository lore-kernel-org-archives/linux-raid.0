From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: VT 8237 Support?
Date: Wed, 21 Jan 2004 14:02:16 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401211357470.30312-100000@coffee.psychology.mcmaster.ca>
References: <20040121082404.GA11827@hvs.envisage.co.za>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040121082404.GA11827@hvs.envisage.co.za>
To: Hendrik Visage <hvisage@envisage.co.za>
Cc: Andrew Hogue <hogue@cs.yorku.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> "stock standard" in 2.6.0

with 2.6, it's wise to track patches more aggresively.  in particular,
I'd go with AKPM's latest mm prepatch and possibly jgarzik's libata update.

>   Vendor: ATA       Model: ST3120026AS       Rev: 0.81
>     Type:   Direct-Access                      ANSI SCSI revision: 05
...

> > Has anyone tried this patch?  How stable is libata for the VIA chipset...?
> 
> On 2.6.0 & 2.6.1 with the gentoo patches, I only have a single drive that
> appears to be "problematic", but I suspect either heat or cabling troubles,
> as it does the same on the Promise 20378 onboard controller.

some Seagate SATA disks have a bug that makes them unable to handle 
requests that don't contain a multiple of 16 sectors (or something similar).
the latest libata patch has a quirk list to pick out those specific drives,
and handle them.  previously, iirc, all ST's were worked around, with serious
performance implications.

the model above is not in the quirk list.  the quirk isn't controller-specific.

