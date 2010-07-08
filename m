From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: mapping ataXX.YY to a /dev/sdX
Date: Thu, 8 Jul 2010 11:44:22 +0100
Message-ID: <20100708104422.GA32564@cthulhu.home.robinhill.me.uk>
References: <alpine.DEB.1.10.1007070810540.23489@uplift.swm.pp.se>
 <87wrt7ijp3.fsf@rimspace.net>
 <alpine.DEB.1.10.1007071749320.23489@uplift.swm.pp.se>
 <4C35A2FC.5080402@buttersideup.com>
 <alpine.DEB.1.10.1007081214590.23489@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1007081214590.23489@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jul 08, 2010 at 12:26:27PM +0200, Mikael Abrahamsson wrote:

> It seems the driver doesn't implement that, I can see it for the=20
> ICH10R-controller, but not for the SiL-based one this drive is on:
>=20
> [    1.289345] ahci 0000:08:00.0: setting latency timer to 64
> [    1.289436] scsi12 : ahci
> [    1.289501] scsi13 : ahci
> [    1.289542] ata13: SATA max UDMA/133 abar m2048@0xfbeff000 port 0xfbef=
f100 irq 40
> [    1.289546] ata14: SATA max UDMA/133 irq_stat 0x80400040 irq 40, conne=
ction status changed
> [    1.638532] ata13: SATA link down (SStatus 0 SControl 370)
> [    2.218075] ata14: SATA link up 3.0 Gbps (SStatus 123 SControl 370)
> [    2.223478] ata14.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/1=
33
> [    2.223483] ata14.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31=
/32), AA
> [    2.228491] ata14.00: configured for UDMA/133
>=20
It would look like ata14 is the equivalent of scsi13 then - lsscsi or
"cat /proc/scsi" should show you the drives connected on controller 13
(or look in /sys/class/scsi_disk/13*/device/block).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEARECAAYFAkw1rAYACgkQShxCyD40xBIenACggHM+dnWwu1ggeymgufczDbzL
rP8Anja9sbxROA4ah0d55qMNL09MF0/u
=ygcO
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
