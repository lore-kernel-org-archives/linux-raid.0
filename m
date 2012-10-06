From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Promise SATA TX4 300 + 3TB disks?
Date: Fri, 05 Oct 2012 20:57:00 -0500
Message-ID: <506F8FEC.7040402@hardwarefreak.com>
References: <818058745.20121005012826@oudeis.org> <20121005123653.0a5398e0@natsu> <506E9E77.1080002@hardwarefreak.com> <20121005145011.673f4974@natsu> <719665592.20121005153321@oudeis.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <719665592.20121005153321@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/5/2012 8:33 AM, Rainer F=FCgenstein wrote:
> roman, stan,
>=20
> thanks for your input. I should have added some more information:
>=20
> the mainboard is an intel D510MO which has "only" one PCI slot and 2
> SATA ports. one port runs a 60GB SSD (system), the 2nd one a 3TB WD
> drive for temporary data.
> http://www.intel.com/content/www/us/en/motherboards/desktop-motherboa=
rds/desktop-board-di510mo.html
>=20
> the 4x 1.5TB drives are connected to the promise TX4 300 in the only
> PCI slot.
>=20
> lspci:
> 00:1f.2 SATA controller: Intel Corporation N10/ICH7 Family SATA Contr=
oller [AHCI mode] (rev 01)
> according to the kernel wiki PMP is not supported by the ICH7 chipset=
=2E

Ok, that sucks.  So you're stuck with PCI on this box.  As I mentioned,
contact Promise and inquire about using 3TB drives with the 300 TX4,
just for piece of mind.

As John mentioned the TX4 BIOS/firmware shouldn't be an issue.  This is
a 48bit LBA controller and theoretically can access a single disk drive
of up to 144PB in size.

The barrier here, if any, will be your kernel.  If you're running a 32
bit kernel you can't address all 48 LBA bits, only 32 of them.  Thus yo=
u
can only access ~2TB of an LBA48 3TB drive.  The math:

((((2^32=3D4294967296) * 512B) =3D 2199023255552) / 1048576^2) =3D 2TB

This is the cause of the 2TB drive size limit you read about all over
the web.  If you have a 64bit kernel with an LBA48 controller (most are=
)
then this shouldn't be an issue, as all 48 LBA bits are addressable by =
a
64bit kernel.  With a 64bit kernel, if the TX4 doesn't give you all 3TB
per drive, then there's a driver or firmware bug present.

> the 2nd application is an old avantek server with a tyan S2882-D
> mainboard and 8 drive bays which I want to fill with old drives for
> backup purposes. the 4port onboard SATA controller doesn't even
> recognize 750GB drives (hangs at startup).
> http://www.tyan.com/archive/products/html/thunderk8sdpro.html

Assuming the hot swap bays in the chassis are indeed SATA/SAS and not
SCSI/SCA, then your best, least expensive, solution is the SuperMicro
AOC-SAT2-MV8 64-bit PCI-X133MHz:

http://www.newegg.com/Product/Product.aspx?Item=3DN82E16815121009

Provides you 8 SATA-II ports in a PCI-X 133MHz card for the same price
as two 4 port PCI 32/33 cards, but with 4 times the bandwidth.  Nobody
makes an 8 port PCI 32/33 card, so this is as good as it gets for the
money.  Check your Tyan manual.  Running a PCI-X 133 card usually
requires disabling/leaving empty the sister slot on that PCI-X bus,
and/or setting some jumpers.  This Tyan board, as with most PCI-X
workstation/entry server boards, has two PCI-X buses, two slots on each
bus.  These bandwidth and bus electrical loading hoops PCI-X requires u=
s
to jump through directly resulted in the birth of serial PCI Express
interconnect.  No more shared buses, all slots usable, no hoops.

You provided no details of the chassis or backplane(s) or I could tell
you which, if any, reverse breakout cables you need.  If the
backplane(s) have 8 cable connectors you're golden.  If they have
2xSFF8087 connections then you'll need two reverse breakout cables.

--=20
Stan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
