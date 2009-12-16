From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: [SOLVED] RAID-10 array won't auto-assemble @ boot of a Xen
 Guest; Works just fine 'manually' ... Any ideas?
Date: Wed, 16 Dec 2009 09:16:15 +0000
Message-ID: <20091216091615.GB15689@cthulhu.home.robinhill.me.uk>
References: <babafd2f0912151558y513b589ay5e43080ef8e697d@mail.gmail.com>
 <babafd2f0912151705sbda2f50i84ca88433713888d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <babafd2f0912151705sbda2f50i84ca88433713888d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Dec 15, 2009 at 05:05:18PM -0800, Ben DJ wrote:

> Apparently, when NOT a "/" or "/boot" drive, the RAID arrays need
>=20
>   chkconfig boot.md on
>=20
> which, strangely, doesn't show up at all in,
>=20
>   chkconfig -- list | grep -i boot
>     list: unknown service
>=20
What about if you leave out the space between the dashes and the list
option?

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAksopV4ACgkQShxCyD40xBI1pACgvXL6HNlL6jgvB4PY/Uq/QfQ+
T7EAniE37C77n+VcA9Nhas1wIKiONItc
=bJ6c
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
