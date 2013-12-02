From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Creating new raid5 or 6 with --assume-clean
Date: Mon, 2 Dec 2013 08:48:59 +0000
Message-ID: <20131202084859.GA26327@cthulhu.home.robinhill.me.uk>
References: <20131202030707.GB19621@animx.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131202030707.GB19621@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Dec 01, 2013 at 10:07:07PM -0500, Wakko Warner wrote:

> This is a general question, but I'll give a specific.
>=20
> If I create an array with assume clean and proceed to write to the device,
> what happens with the parity?
>=20
> EX:
> mdadm -C /dev/md0 -n 4 -l 6 -e 1.0 -b internal -c 128 --assume-clean \
> 	sdc2 sdd2 sdf2 sde2
>=20
> Then:
> dd if=3D/dev/zero of=3D/dev/md0 bs=3D1M
>=20
> When it finishes, will all the parity blocks be correct for raid 5 and
> raid6?
>=20
> Would changing md/stripe_cache_size up/down make a difference to the
> parities?
>=20
Doing that specifically should result in all parity being correct, yes.
Providing the writes are not going to a single disk in a stripe (in
which case read-modify-write may be used to update the parity rather
than a full stripe read and parity recalculation) then any write should
result in the parity for that stripe being written correctly. I think
RMW is only used in RAID5 currently though.

Changing the stripe cache size won't affect the parity calculation at
all (except in terms of performance/throughput).

Regards,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlKcSXsACgkQShxCyD40xBIBcQCfYz0BeYTFJSgKxxwgGmgBxrVv
atsAni2YOw5wK/Sq406Qf2LVtQaE48ZH
=lKF3
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
