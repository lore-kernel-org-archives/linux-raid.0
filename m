From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 0/2] md: More block -> sector conversions.
Date: Mon, 26 Jan 2009 19:33:59 +0100
Message-ID: <20090126183359.GG17185@skl-net.de>
References: <1232982852-32747-1-git-send-email-maan@systemlinux.org> <497DD740.8080306@rabbit.us> <20090126160814.GD17185@skl-net.de> <497DF230.1080908@rabbit.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="df+09Je9rNq3P+GE"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <497DF230.1080908@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--df+09Je9rNq3P+GE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18:26, Peter Rabbitson wrote:
> > Can you reproduce the incorrect output for the used device size
> > with the recent master branch of the mdadm git tree?
> >=20
>=20
> Hi Andre,
>=20
> Yes I can:

[snip]

>   Used Dev Size : 576720896 (550.00 GiB 590.56 GB)

This is twice as much as it should be due to a bug in mdadm which bites
only for version1 superblocks. The patch below should fix it. However,
this might not be the most elegant solution because the real bug
is IMHO that get_component_size() multiplies the value from sysfs
(which is always in 1K units) by two, so it returns 2K units which
looks a bit weird.

Since there are more callers of get_component_size() I have to take
a deeper look to come up with a more reasonable patch.

Have fun
Andre

diff --git a/Detail.c b/Detail.c
index 3cee66f..cef1abb 100644
--- a/Detail.c
+++ b/Detail.c
@@ -195,7 +195,7 @@ int Detail(char *dev, int brief, int export, int test, =
char *homehost)
 		if (array.level >=3D 1) {
 			if (array.major_version !=3D 0 &&
 			    (larray_size >=3D 0xFFFFFFFFULL|| array.size =3D=3D 0)) {
-				unsigned long long dsize =3D get_component_size(fd);
+				unsigned long long dsize =3D get_component_size(fd) / 2; /* KB */
 				if (dsize > 0)
 					printf("  Used Dev Size : %llu%s\n",
 					       dsize,
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--df+09Je9rNq3P+GE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJfgIXWto1QDEAkw8RAk8xAKCB7pdY5G6h8/2Z19urw0CVFPo4hQCfczpl
Y29O0Iq29HP8P/7X7Li++nY=
=uFyD
-----END PGP SIGNATURE-----

--df+09Je9rNq3P+GE--
