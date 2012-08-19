From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Inexpensive RAID1 controller for home server?
Date: Sun, 19 Aug 2012 15:34:43 +0600
Message-ID: <20120819153443.7f697ca6@natsu>
References: <CAK2H+eeLncyi6tCrM-vEhDzT7ykOA6LJP+Qka56rxUFGv2_urw@mail.gmail.com>
	<50306707.40302@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DR7=t55jDAm9Nnpg4m/qGK9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50306707.40302@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Mark Knecht <markknecht@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/DR7=t55jDAm9Nnpg4m/qGK9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 18 Aug 2012 23:09:43 -0500
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 8/18/2012 2:18 PM, Mark Knecht wrote:
> > Hi,
> >    I wonder if there is direct knowledge here about this controller?
> >=20
> > http://www.amazon.com/HighPoint-Rocket-SATA-PCI-Express-Controller/dp/B=
002VEWBGO
> >=20
> >    I'm looking to add an inexpensive 2-port controller for a home
> > server that's out of ports on the MB but has room in the chassis for a
> > couple more drives running RAID1. The machine has been successfully
> > running mdadm for the last couple of years and the power supply is
> > plenty big enough to take on the new hardware.
> >=20
> >    According the the Highpoint site is has native Linux support so it
> > doesn't appear there are any major driver availability issues. The one
> > problem I've read about that concerns me is it may conflict with
> > existing on-board Marvell eSATA controllers which this machine has.
>=20
> Given the potential Marvell conflict issue, go with Silicon Image:
>=20
> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16815124027
>=20
> All Silicon Image chips are supported in mainline, have been forever.
>=20

Now, maybe I am missing something and Mark Knecht is your worst enemy --
because I see no other explanation why give him such a terrible advice.

Silicon Image chips are well known for having caused data corruption to many
people including in discussions on this list, usually this triggers when bo=
th
ports on the card are accessed at high speed in parallel.

There is also a performance-related reason to avoid Silicon Image (if
having them corrupt data isn't enough for someone):

  "Warning: the overall bottleneck of the PCIe link is 150-175MB/s, or
  75-88MB/s/port, but the chip has a 110-120MB/s bottleneck per port. So a
  single SATA device on a single port cannot fully use the 150-175MB/s by
  itself, it will be bottlenecked at 110-120MB/s."
=20
   -- http://blog.zorinaq.com/?e=3D10


Now, what to choose instead:

I highly doubt having two Marvell controllers in a system would lead to a
conflict; and as the article linked above concludes, a Marvell 88SE912x wou=
ld
be an excellent choice, as it "supports PCIe gen2 [...] is also fully AHCI
compliant, in other words robust, well-designed, and virtually compatible w=
ith
all operating systems".

But if Mark believes there could be a conflict, and wants a non-Marvell
recommendation, I'd say take a look at a JMicron, which is also the second
recommendation in that article.
http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816124047

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/DR7=t55jDAm9Nnpg4m/qGK9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAwszMACgkQTLKSvz+PZwjbDQCeOkqDTfm6jdtW4y70hzR3J82j
Jx8AoJTeKOv/BomyR05JQsmBsBDLy7gc
=XWpp
-----END PGP SIGNATURE-----

--Sig_/DR7=t55jDAm9Nnpg4m/qGK9--
