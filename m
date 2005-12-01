From: Jure =?ISO-8859-2?Q?Pe=E8ar?= <pegasus@nerv.eu.org>
Subject: Re: Journal-guided Resynchronization for Software RAID
Date: Thu, 1 Dec 2005 21:01:04 +0100
Message-ID: <20051201210104.729a6e6a.pegasus@nerv.eu.org>
References: <Pine.LNX.4.58.0511301015520.14240@macduff.cs.wisc.edu>
	<17294.34794.477608.760700@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17294.34794.477608.760700@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 1 Dec 2005 16:19:38 +1100
Neil Brown <neilb@suse.de> wrote:

> What I would really like is a cheap (Well, not too expensive) board
> that had at least 100Meg of NVRAM which was addressable on the PCI
> buss, and an XOR and RAID-6 engine connected to the DMA engine.  Then
> we could use the NVRAM as a write-behind cache and offload all the
> parity calculation to it, while still having all the flexibility of
> software raid...

There are some things near enough what you wish:

How to use gfx memory as nvram (no batteries tho :)
http://hedera.linuxnews.pl/_news/2002/09/03/_long/1445.html

Or not really pci mapped, but presented as sata disk:
http://www.anandtech.com/storage/showdoc.aspx?i=3D2480&p=3D1

As for XOR, Jeff Garzik reports Promise SX4 is something like that.

--=20

Jure Pe=E8ar
http://jure.pecar.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
