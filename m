From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: md0: unknown partition table - should I worry?
Date: Wed, 11 Nov 2009 09:03:55 +0000
Message-ID: <20091111090355.GA9137@cthulhu.home.robinhill.me.uk>
References: <200911102324.47474.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200911102324.47474.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Nov 10, 2009 at 11:24:44PM +0100, Dexter Filmore wrote:

> Today md0 degraded (debian 5.0 i386, raid5, 5x500 samsung sata) so I chec=
ked=20
> the logs and noticed on each rebootI got this in /var/log/messages:
>=20
> md0: unknown partition table
>=20
> md0 is all LVM2 and volumes mount fine, so is this normal?=20
>=20
If you're using whole-disk RAID rather than RAID on partitions then this
is normal, yes.  Something (possibly udev, in order to create the
relevant dev entries) is trying to read the partition table and failing
as there isn't one.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkr6ffoACgkQShxCyD40xBKkBACfcd3PnJsgaMDDeo9ABHrvMXSE
u/QAni8Hhe8vg2Xtr5YXXFnrbkcjYM7y
=qmgK
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
