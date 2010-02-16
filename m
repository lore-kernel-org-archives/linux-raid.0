From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 14:46:33 +0000
Message-ID: <20100216144633.GA21587@cthulhu.home.robinhill.me.uk>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <201002142013.24922.volkerarmin@googlemail.com>
 <4B7AAB8D.9030009@anonymous.org.uk>
 <201002161537.08487.volkerarmin@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201002161537.08487.volkerarmin@googlemail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Feb 16, 2010 at 03:37:08PM +0100, Volker Armin Hemmann wrote:

> so assume you have an initrd and metadata 1.x without auto assembling.
>=20
> You do some changes to the raid and screw up something else. Next boot no=
thing=20
> works. Mostly because the mdadm.conf in your initrd is not correct.
>=20
> You whip out your trusty usb stick with a resuce system - and you are stu=
ck.=20
> If autoassembling would work, you would have working md devices you could=
=20
> mount and edit the files you have to. But you don't and the mdadm.conf in=
 the=20
> initrd is outdated.
>=20
> Sounds like 'you are screwed'.
>=20
Or you drop to the recovery shell in the initrd, edit the mdadm.conf
file (or run mdadm with whatever options you like to find out what's
actually happening), and continue with processing the init script and
booting.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkt6r8kACgkQShxCyD40xBL1XgCgpNqOkJF4BDIGe02dlrG4lwtw
WdMAn0yfqf0hr8+6ofdolw+vAWrlG9Nt
=p1iP
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
