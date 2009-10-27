From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Is My Data DESTROYED?!
Date: Mon, 26 Oct 2009 21:50:42 -0500
Message-ID: <20091027025048179.ITXN5890@cdptpa-omta01.mail.rr.com>
References: <200910261214.56186.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200910261214.56186.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> > I use a hot-swap sata enclosure for my disk backup. Mine is installed in
> > one 5.25" slot, elsewhere I have used an external esata version of the
> > same thing. Cheap and gives me the full native speed of the disk.
> 
> I have one of those 4-in-3 bay converters, 4 hotswap 3.5" bays, in 3 5.25"
> bays. Really rather nice. Probably get another one later.

	When I first went to SATA disks, I picked up a 12 bay multilane
enclosure from Norcotek coupled with a Highpoint SAS RAID controller.  It
was a disaster.  With a small number of drives in the enclosure, and with
some fiddling, I could get the system to be fairly stable.  Once I went
beyond 6 disks, however, it was an unending nightmare of problems.  I tried
everything, including gutting the Infiniband adapters and putting in port
multipliers, switching to mdadm.  Right about a year ago, I scrapped the
Norcotek enclosure and picked up a 12 bay port multiplier enclosure from PC
PitStop.  I've been thrilled with it.  They have a 20 bay enclosure which I
believe I am going to get to facilitate my next expansion, early next year.

