From: FRLinux <frlinux@frlinux.net>
Subject: multiple distros & raid issues
Date: Tue, 03 Aug 2004 18:04:49 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1091552689.8445.3.camel@tux.power.users>
Reply-To: frlinux@frlinux.net
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-D73C4030VPCXVqQNFhGG"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-D73C4030VPCXVqQNFhGG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello,

I noticed a problem with having several distributions on the same
machine (multi boot) and the sil3112 driver. My main distribution is
Gentoo running a kernel 2.6.7 and two soft raid 1 partitions (md0,1)
which are working perfectly.

Now, when booting up on any other distro (i got suse 9.1, fedora core 2,
mandrake 10.0 official and slackware 10), one time out of 2 i get : raid
array in bad state, starting reconstruction, it then disconnects one of
the devices, reattaches it an syncs the whole thing.

Anyone ever witnessed that ?
Thanks for any reply,
Steph
--=20
This mail was sent under Gentoo 2004.1 - Gnome & Kernel 2.6nptl
http://frlinux.net - Site d'aide aux Debutants sous Linux
Public key : http://frlinux.net/files/frlinux_public_key.asc

--=-D73C4030VPCXVqQNFhGG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBD8WxplbM2wjOZgMRAtliAKCkw3mLz0Smx/e6ZWUo+Oc3kvuaCwCdGbqQ
4+FeqW8gLkg/0sfKZdmTfdQ=
=l+Gp
-----END PGP SIGNATURE-----

--=-D73C4030VPCXVqQNFhGG--

