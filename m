From: =?ISO-8859-1?Q?Jo=EBl?= Bourquard <numlock@freesurf.ch>
Subject: Re: What SATA controller for software raid and/or lvm?
Date: Mon, 19 Jan 2004 00:50:36 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1074469835.7611.9.camel@localhost.localdomain>
References: <1074459283.2532.50.camel@localhost.localdomain>
	 <20040118212933.GB3763@hvs.envisage.co.za>
	 <1074462662.8813.6.camel@localhost.localdomain>
	 <1074464950.2532.99.camel@localhost.localdomain>
Reply-To: numlock@freesurf.ch
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1074464950.2532.99.camel@localhost.localdomain>
To: mingz@ele.uri.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

It seems we have the same priorities :-)

However, before I rush and order these two Highpoint 1820's ($300), it
may be wise to ask the linux serial-ata specialist:

Jeff Garzik
jgarzik@pobox.com

I'll e-mail him tomorrow. May I provide your e-mail address to him ? He
was skeptical about Highpoint's linux support, but maybe things have
changed since 2/1/2004 (when Highpoint posted an opensource module for
the 1820 controller).

Building the server is a priority to me, but I must wait for a few days
anyway (Paypal refuses a transaction, when it shouldn't).

Anyway, if we can get a definitive word about this controller, I think
it might help a lot of people on Linux-RAID... I mean, a 64-bit 133MHz
SATA controller with 8 ports, for about $150 is really nice :-)

So.. if you're still interested, please let me know what you think,
before I e-mail Jeff.

Best Regards,
Jo=C3=ABl


On Sun, 2004-01-18 at 23:29, Ming Zhang wrote:
> On Sun, 2004-01-18 at 16:51, Jo=C3=ABl Bourquard wrote:
> > On Sun, 2004-01-18 at 22:29, Hendrik Visage wrote:
> > > On Sun, Jan 18, 2004 at 03:54:44PM -0500, Ming Zhang wrote:
> > > > Hi, I want to setup a software raid and lvm configuration with =
2-4TB raw
> > > > disk space. I wonder if you can give me some suggestions on wha=
t kind of
> > > > sata controllers are friendly to my purpose? :)
> > >=20
> > > Those supported properly in the kernel :)
> > >=20
> > > At present I'm using the onboard Via & Promise (20378) for SATA +=
 (evms)
> > > software RAID, but there are others that have different views on =
which
> > > controller(s) to use.
> > >=20
> >=20
> > Unfortunately an onboard SATA RAID controller will not be enough fo=
r
> > 2-4TB.
> >=20
> yes, so that is why i want to buy a separate sata controller.
>=20
>=20
> > I'm looking to build the exact same thing (at least 2TB) using 256G=
B
> > SATA disks.
> >=20
> > If money is no issue, the 8- or 12-port 3ware SATA RAID controllers=
 have
> > excellent linux support.
> money is always an issue. :)
>=20
>=20
> >=20
> > For software RAID, I think it's overkill.. why buy a RAID coprocess=
or
> > when you don't actually use it ?
> >=20
> > I think I'll go with two Highpoint 1820 (8-port) PCI-X controllers =
and
> > see how it works..
> >=20
> > Linux support wasn't their strong point in the past, but it seems t=
hey
> > released an "open-source" kernel module on 2nd January, 2004.
> >=20
> > Maybe a RAID guru can have a look at it, and see if it's a marketin=
g
> > joke or not ?
> >=20
> > Anyway, for the price I think I'll take the risk and order two of t=
hem
> > next week.
> yes, that price sounds great. hope to get u comments on that card soo=
n.
> thanks a lot.
>=20
> >=20
> > Regards,
> > Jo=C3=ABl
> >=20
> >=20
> > > Hendrik
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> >=20
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
