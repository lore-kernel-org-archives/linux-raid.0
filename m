From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: What SATA controller for software raid and/or lvm?
Date: Sun, 18 Jan 2004 17:29:10 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1074464950.2532.99.camel@localhost.localdomain>
References: <1074459283.2532.50.camel@localhost.localdomain>
	 <20040118212933.GB3763@hvs.envisage.co.za>
	 <1074462662.8813.6.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1074462662.8813.6.camel@localhost.localdomain>
To: numlock@freesurf.ch
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 2004-01-18 at 16:51, Jo=C3=ABl Bourquard wrote:
> On Sun, 2004-01-18 at 22:29, Hendrik Visage wrote:
> > On Sun, Jan 18, 2004 at 03:54:44PM -0500, Ming Zhang wrote:
> > > Hi, I want to setup a software raid and lvm configuration with 2-=
4TB raw
> > > disk space. I wonder if you can give me some suggestions on what =
kind of
> > > sata controllers are friendly to my purpose? :)
> >=20
> > Those supported properly in the kernel :)
> >=20
> > At present I'm using the onboard Via & Promise (20378) for SATA + (=
evms)
> > software RAID, but there are others that have different views on wh=
ich
> > controller(s) to use.
> >=20
>=20
> Unfortunately an onboard SATA RAID controller will not be enough for
> 2-4TB.
>=20
yes, so that is why i want to buy a separate sata controller.


> I'm looking to build the exact same thing (at least 2TB) using 256GB
> SATA disks.
>=20
> If money is no issue, the 8- or 12-port 3ware SATA RAID controllers h=
ave
> excellent linux support.
money is always an issue. :)


>=20
> For software RAID, I think it's overkill.. why buy a RAID coprocessor
> when you don't actually use it ?
>=20
> I think I'll go with two Highpoint 1820 (8-port) PCI-X controllers an=
d
> see how it works..
>=20
> Linux support wasn't their strong point in the past, but it seems the=
y
> released an "open-source" kernel module on 2nd January, 2004.
>=20
> Maybe a RAID guru can have a look at it, and see if it's a marketing
> joke or not ?
>=20
> Anyway, for the price I think I'll take the risk and order two of the=
m
> next week.
yes, that price sounds great. hope to get u comments on that card soon.
thanks a lot.

>=20
> Regards,
> Jo=C3=ABl
>=20
>=20
> > Hendrik
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
