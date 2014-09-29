From: NeilBrown <neilb@suse.de>
Subject: Re: dmadm question
Date: Tue, 30 Sep 2014 07:30:43 +1000
Message-ID: <20140930073043.6adebbd7@notabene.brown>
References: <661E720A-B65C-4C24-B6A4-A4439596DEB9@lukeodom.com>
	<20140915103154.59bc7293@notabene.brown>
	<56516488c20b6b78729f14731fe8aecf.squirrel@webmail.lukeodom.com>
	<CAA9_cmc_YXg1=uVCm1wQ999ZMOihEv6HB-AO0FL8aiTwvFCQag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/LHSvKQ7BfZsD+eaRoEpT8Vd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmc_YXg1=uVCm1wQ999ZMOihEv6HB-AO0FL8aiTwvFCQag@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: luke@lukeodom.com, linux-raid <linux-raid@vger.kernel.org>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--Sig_/LHSvKQ7BfZsD+eaRoEpT8Vd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Sep 2014 10:38:03 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> Hmm, I wonder if this is a regression.  The last time I saw this
> problem I introduced commit:
>=20

Maybe...

Luke, can you change get_extents() in super-intel.c like this:

        if (dl->index =3D=3D -1)
+               reservation =3D MPB_SECTOR_CNT;
-               reservation =3D imsm_min_reserved_sectors(super);
        else
                reservation =3D MPB_SECTOR_CNT + IMSM_RESERVED_SECTORS;


i.e. replace imsm_min_reserved_sectors(super) with MPB_SECTOR_CNT
and 'make install'.
Then see if your problem goes away?

Thanks,
NeilBrown

--Sig_/LHSvKQ7BfZsD+eaRoEpT8Vd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCnPijnsnt1WYoG5AQJIJhAArW3C9txBHWlpgI4ohxjjgmavSHQsft+P
bSvr7QS6LrH9dOsD2+WU5BcuVAio1gwYWb4NRqymWg6XCh5PeSkO4CGDGIHSQCtu
2ofjST5MF8w0h1BLq+OS43zpX8lSmeNGPWneVJ1E6UdjWu/sUbZD+DCLZ/co0u2L
ThgL6ARsYZTjTIrpp+iYi0adOOGuDqso85zF+Vq2anPfCKc34v+S8vNTgwjdMNFH
dA/lRErWfJPiXHQC88kDSqhcL0KqA3C7X4c8kojqG+WwfOibAdE5ofacMTwZ5Pmb
MY2iMd5vDIK/cQT3gjmmquOhlaEElsg1WkBg5Rvi8xd7KzA+/xOPbLlW3rjy/u0A
LUj4f9XDLgmsJKVgYRrmlHy0036nfpD/698p3VEUL3mImb9L3vPN9LRbTkImUchb
F6BF0ihsLBzqpA3mTYyP+2QwWSUqvSKZyrwkZscfPX5be6mksJ5Zk9iWdQHsrzGu
Olh4rBS/5Q1Lbtt5My6jvGnzYbKrbqJMIOgQg9NLL/DdnMXFwaMz3KOV7aizHTXm
Cp8VpzLJimHEhOgDhVP8dHSDMy6OCz62c0koc04VHbd74XLI+CcGalq4F7Kj72B6
jh+DJccEDSn+jsW3O3Tboy+YA3aGotsYNv89IDGY6fUJYWLkX68/rKgSk6mVMuV5
JV90S6rbgIY=
=6ON6
-----END PGP SIGNATURE-----

--Sig_/LHSvKQ7BfZsD+eaRoEpT8Vd--
