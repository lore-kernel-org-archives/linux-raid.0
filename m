From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Which raid card to buy for Sarge
Date: Wed, 31 Mar 2004 15:59:26 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406B312E.1030006@pobox.com>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca> <200403312242.49462.ralph@debianbase.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200403312242.49462.ralph@debianbase.de>
To: =?ISO-8859-1?Q?Ralph_Pa=DFgang?= <ralph@debianbase.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ralph Pa=DFgang wrote:
> kernel code). But normaly a real hardware raid is without a doubt fas=
ter than=20
> a software raid.


Well...  Regardless of hardware or software RAID, the kernel I/O limits=
=20
and the drive I/O limits are the main limiting factor.  Hardware RAID=20
mainly helps for RAID1 and RAID5 writes, eliminating duplicate copies o=
f=20
data going across the PCI bus... at the expense of relinquishing contro=
l=20
over your data to the hardware RAID's firmware.

A UDMA/133 PATA hardware RAID from a large company I won't mention is=20
quite a bit slower than any SATA software RAID that I've tested...

	Jeff



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
