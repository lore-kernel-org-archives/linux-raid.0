From: Sebastian Kuzminsky <seb.kuzminsky@gmail.com>
Subject: Re: building a disk server
Date: Wed, 30 Nov 2005 20:38:22 -0700
Message-ID: <7f55de720511301938q1911a5bcx2a782b73bb39e87a@mail.gmail.com>
References: <E1EhDvc-00083b-00@toko.jab.org>
	 <20051130011853.GE28741@strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051130011853.GE28741@strugglers.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, I've been looking around some more.  I like the flexibility of
having the disks external to the "head" computer.  Looks like AoE is
not quite ready for the prime time yet.  SCSI seems overpriced for
what you get.  eSATA looks sweet.

Sonnet makes an 8-channel eSATA controller, PCI-X, using the Marvell
6081 chipset.  Supported in 2.6.14.  About $275. 
<http://www.sonnettech.com/product/tempo-x_esata8.html>

Addonics makes a 4-channel eSATA controller, also PCI-X, using the Sil
3124 chipset, also supported in 2.6.14.  About $90. 
<http://addonics.com/products/host_controller/adsa3gx4r-e.asp>

Anyone know of any other PCI-X multi-channel eSATA controllers? 
There's also the option of getting a regular (non-external) SATA
controller and the little SATA-to-eSATA converters, but I'd prefer to
cut down on the number of in-line connectors.


There are lots of eSATA enclosures available, holding from 1 to 8
drives.  Here's just one example:
<http://www.macgurus.com/productpages/sata/hotswapsatakits.php>. 
However, none of the enclosures I've found have redundant power
supplies.  I'm thinking to use RAID-6, and a pile of 2x enclosures, so
if a power supply goes I lose just 2 disks and my array stays up.  If
I can find an 8x enclosure with redundant power supplies that would be
preferable.

Does anyone have any experience with any eSATA enclosures, good or bad?


Comments?


--
Sebastian Kuzminsky
