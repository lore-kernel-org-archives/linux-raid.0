From: =?ISO-8859-1?Q?Jo=EBl?= Bourquard <numlock@freesurf.ch>
Subject: Re: What SATA controller for software raid and/or lvm?
Date: Sun, 18 Jan 2004 22:51:03 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1074462662.8813.6.camel@localhost.localdomain>
References: <1074459283.2532.50.camel@localhost.localdomain>
	 <20040118212933.GB3763@hvs.envisage.co.za>
Reply-To: numlock@freesurf.ch
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040118212933.GB3763@hvs.envisage.co.za>
To: linux-raid@vger.kernel.org
Cc: Ming Zhang <mingz@ele.uri.edu>
List-Id: linux-raid.ids

On Sun, 2004-01-18 at 22:29, Hendrik Visage wrote:
> On Sun, Jan 18, 2004 at 03:54:44PM -0500, Ming Zhang wrote:
> > Hi, I want to setup a software raid and lvm configuration with 2-4T=
B raw
> > disk space. I wonder if you can give me some suggestions on what ki=
nd of
> > sata controllers are friendly to my purpose? :)
>=20
> Those supported properly in the kernel :)
>=20
> At present I'm using the onboard Via & Promise (20378) for SATA + (ev=
ms)
> software RAID, but there are others that have different views on whic=
h
> controller(s) to use.
>=20

Unfortunately an onboard SATA RAID controller will not be enough for
2-4TB.

I'm looking to build the exact same thing (at least 2TB) using 256GB
SATA disks.

If money is no issue, the 8- or 12-port 3ware SATA RAID controllers hav=
e
excellent linux support.

=46or software RAID, I think it's overkill.. why buy a RAID coprocessor
when you don't actually use it ?

I think I'll go with two Highpoint 1820 (8-port) PCI-X controllers and
see how it works..

Linux support wasn't their strong point in the past, but it seems they
released an "open-source" kernel module on 2nd January, 2004.

Maybe a RAID guru can have a look at it, and see if it's a marketing
joke or not ?

Anyway, for the price I think I'll take the risk and order two of them
next week.

Regards,
Jo=C3=ABl


> Hendrik
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
