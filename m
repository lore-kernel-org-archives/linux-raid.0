From: Phil Turmel <philip@turmel.org>
Subject: Re: Disk Order
Date: Sun, 12 Aug 2012 20:37:51 -0400
Message-ID: <50284C5F.80808@turmel.org>
References: <50281BB1.6030309@abpni.co.uk> <502842D7.40005@turmel.org> <50284495.2030004@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50284495.2030004@abpni.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Tripathy <jonnyt@abpni.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/12/2012 08:04 PM, Jonathan Tripathy wrote:
> 
> Now, onto the topic of PCIe adapter. I was looking at this:
> http://www.cclonline.com/product/42541/PEXSAT32/IDE-SATA-SCSI-Cards/StarTech-2-Port-SATA-6-Gbps-PCI-Express-SATA-Controller-Card/CNT1075/
> 
> 
> Is that a bad model? Seems a little on the cheap side? Can anyone
> suggest a good model?

Amazon users aren't impressed.  But the limitation is really the PCIe x1
v2 bus interface: 500MB/sec.  Two SSDs would certainly overwhelm it, and
any other similar card.

I have a similar card, the Highpoint 620, in an older system at home
(PCIe v1): it maxes out at 200MB/sec.

So, it depends on what you want it to do.

{I'll let others make card recommendations--I prefer to *listen* to those.}

Phil
