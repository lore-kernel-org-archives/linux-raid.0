From: NeilBrown <neilb@suse.de>
Subject: Re: raid5.c internal stripe layout
Date: Tue, 19 Aug 2014 13:06:23 +1000
Message-ID: <20140819130623.780c27e3@notabene.brown>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735863E62B@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/4oSk19dfcpGCdXi.qRP4Yq="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735863E62B@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/4oSk19dfcpGCdXi.qRP4Yq=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Aug 2014 18:32:57 +0000 Markus Stockhausen
<stockhausen@collogia.de> wrote:

> Hi,
>=20
> I'm wondering if there are any pros/cons for handling stripes in memory
> exactly in the same layout as on disks. There are several places that cou=
ld
> be simplified if parity disks would be always at the end (DDD..DDPQ). Of=
=20
> course one would have to do the mapping during read/write operations.
>=20
> Cases for optimization would be:
>=20
> - replace conditions "i =3D=3D pd_idx || i =3D=3D qd_qdx" with "i>=3Dpd_i=
dx"
> - run data disk loops starting/ending with pd_idx (triple parity raid som=
eday?)
> - remove syndrome disk order calculation functions
> - Shaohua's last patch could cross chunks
> - ...
>=20
> Just in case I missed a discussion I'm interested if patches are welcome.

My guess is that you would just end up moving the complexity from one place
to another.
If I'm wrong and the change ends up making a noticeable improvement in code
readability, then I would certainly consider it.  But I'm pretty sure it
would be a big change, so it would need to bring a real improvement.

So I'm sceptical but happy to be proven wrong.

NeilBrown


>=20
> Markus


--Sig_/4oSk19dfcpGCdXi.qRP4Yq=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/K/MDnsnt1WYoG5AQKaeg//fpVn/bLlp4iST6EDYniVU4JY2LiH/rMh
PCAim+HlN9PNTRxL5NAuqRgDYZGWkkhDDMd89AL5ghKxBWEPVCHtMPtoX1tDmkmX
36BBrlNK4QxBKb17OhjT1DdKKuU9XmxFdlva7zYrc6ahguPltqZ8P5PWqdfzdBua
LXxJo2HoTSuW86ZVNVXevbM0SVMuzdLIPIDvH3RDUAwu7P8jy4Z95yLARif1hZHj
K28eRU9T2yreWksdPlTvCVeag7EHg583kBecQjWKEfr2/7PZJ7ijuXxAz6K2OxFh
H7AZyLo6G1X1bLb+N981mUaGvqqkdP30xH6qJ7VbQiUp0s6mHDswTyfzGG0lmP91
hU3uJRMYaoLh75a6ndA5o87knlO6neN0NdWYeBFcoQTUfaqqNp7z8LNvuXroy6hV
r7nD+27VIg3kf371nOPxmna2r15Rgr4cWjv7+UtUtVYlg2LHjf939iLiQqkTnxLy
o8N6AjCF5878N9WJrIpkKelY8QeqNgXMgPVguoK7NcJ53rua2S34Mxe9ZuAf4S5c
W4ZiY5pJ4cW4G2w/BPBlrhKFiiXIBQlICS1RHwQZknBJw7+UgPALKynbrhgXC8oe
n9JyA3Rup/VWYC/giuKnGKgJFo5F2wXeuPmdPGuU9BMBg705GUbvj+DGIaThhVi2
h+6EAFgXk2g=
=xEVA
-----END PGP SIGNATURE-----

--Sig_/4oSk19dfcpGCdXi.qRP4Yq=--
