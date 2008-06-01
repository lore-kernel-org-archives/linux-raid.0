From: Willy Tarreau <w@1wt.eu>
Subject: Re: Limits of the 965 chipset & 3 PCI-e cards/southbridge? ~774MiB/s peak for read, ~650MiB/s peak for write?
Date: Sun, 1 Jun 2008 14:20:33 +0200
Message-ID: <20080601122033.GE5609@1wt.eu>
References: <alpine.DEB.1.10.0806010539430.24757@p34.internal.lan> <alpine.DEB.1.10.0806010700170.10729@p34.internal.lan> <alpine.DEB.1.10.0806010721230.10729@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0806010721230.10729@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Sun, Jun 01, 2008 at 07:26:09AM -0400, Justin Piszcz wrote:
> 
> 
> On Sun, 1 Jun 2008, Justin Piszcz wrote:
> 
> >
> >On Sun, 1 Jun 2008, Justin Piszcz wrote:
> >
> >>I have 12 enterprise-class seagate 1TiB disks on a 965 desktop board and 
> >>it appears I have hit the limit, if I were able to get the maximum speed 
> >>of all drives, ~70MiB/avg * 12 = 840MiB/s but it seems to stop aound 774 
> >>MiB/s (currently running badblocks on all drives)..
> >
> >Small correction, they are 7200.11 Seagate Desktop Drives (ST31000340AS), 
> >not enterprise drives:
> >
> >http://www.seagate.com/ww/v/index.jsp?vgnextoid=0732f141e7f43110VgnVCM100000f5ee0a0aRCRD
> >http://www.newegg.com/Product/Product.aspx?Item=N82E16822148274
> >
> >
> 
> http://www.intel.com/products/chipsets/g965/diagram.jpg
> 
> Basically it appears I am hammering the southbridge as for this board the 
> PCI-e (x1) slots also traverse through the southbridge.
> 
>  6_SATA -> G965 ICH8
> 3_PCI-e -> G965 ICH8
> 
> >From which has to ship that data across the DMI (2GB) link to the 
> northbridge.
> 
> If one utilized a 12, 16 or 24 port raid card (but used SW RAID) on the 
> x16 slot on the northbridge itself, would this barrier exist as the:
> GMCH<->CPU is (8.5GB/s)..?
> 
> Also on the X38 and X48 the speed increases slightly:
> http://www.intel.com/products/chipsets/X38/X38_Block_Diagram.jpg (10.6GB/s)
> http://www.intel.com/products/chipsets/x48/x48_block_diagram.jpg (12.8GB/s)
> 
> If one asks why would one need such speed?

It looks like graphic games are pushing the technologies to their
limits, which is good for us. I have bought X38 motherboards for
10 Gbps experimentations, and this chipset is perfectly capable of
feeding two Myri10GE NICs (20 Gbps total). This is 2.5 GB/s, not
counting overhead. So I/O bandwidth is a premium requirement today.

Other chipsets I have tested (945 and 965) were very poor (about 4.7
and 6.5 Gbps respectively if my memory serves me right).

Willy

