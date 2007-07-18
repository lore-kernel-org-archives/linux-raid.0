From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  Software RAID5 Horrible Write Speed On 3ware Controller!!
Date: Wed, 18 Jul 2007 13:51:16 +0100
Message-ID: <20070718125116.GB29835@cthulhu.home.robinhill.me.uk>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan> <20070718110525.GF13772@boogie.lpds.sztaki.hu> <Pine.LNX.4.64.0707180718000.7659@p34.internal.lan> <469DF8D3.8020908@theendofthetunnel.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <469DF8D3.8020908@theendofthetunnel.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Jul 18, 2007 at 01:26:11PM +0200, Hannes Dorbath wrote:

> I think what you might be experiencing is that XFS can read su,sw values=
=20
> from the MD device and will automatically optimize itself, while it=20
> can't do that for the HW RAID device. It is absolutely essential to=20
> align your file system, to prevent implicit reads, needed for parity=20
> calculations.
>=20
> Set su to the stripe size you have configured in your controller (like=20
> 128K) and sw to 9 (for a 10 disk RAID 5 array).
>=20
Just to pick up on this one (as I'm about to reformat my array as XFS) -
does this actually work with a hardware controller?  Is there any
assurance that the XFS stripes align with the hardware RAID stripes?  Or
could you just end up offsetting everything so that every 128k chunk on
the XFS side of things fits half-and-half into two hardware raid chunks
(especially if the array has been partitioned)?  In which case would
it be better (performance-wise) to provide the su,sw values or not?

I'm planning on doing some benchmarking first but thought I'd check
whether there's any definitive answers first.

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7-ecc0.1.6 (GNU/Linux)

iD8DBQFGngzDShxCyD40xBIRAjC5AKCSAOA060qvdWhwV7Dc++PynxTmfACeN5Th
jZdTCtYdesLZ4TY+Cdqrdg4=
=YJA0
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
