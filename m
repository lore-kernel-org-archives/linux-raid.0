From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 08/12] md: expose rdev->sb_start as sysfs attribute
Date: Wed, 07 Dec 2016 12:25:10 +1100
Message-ID: <874m2g4jk9.fsf@notabene.neil.brown.name>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com> <20161205153113.7268-9-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153113.7268-9-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Dec 06 2016, Artur Paszkiewicz wrote:

> This is meant for external metadata arrays, to pass the location of the
> superblock to the kernel.

The whole point of external metadata arrays is that the metadata is
handled externally.  The kernel doesn't need to know where it is.

Certainly the kernel needs to know where the PPL is, but that is quite a
different question to knowing where the superblock is.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhHZPYACgkQOeye3VZi
gbnLMBAAsySLmSTyyK3cTq/Rd3UFFFVJK7oFjzJkeHGr+nffct61EgyTfM5uzh0f
c6Pq8KoD5i69teSG4VwOq2OAVwVgeuR/Q4Yg8jP4w+OIZx1UvBwu4Ho2YNGQntmn
6jd4lTxERAY40PUaGtH/WXg/FGinmrXtI3S7qbadjAqHKx4rwB5Si2yNIXeRuXys
y/UfCT1lPobdSS+sTNIktO+tAf3F55k87TDu/AorkqoAAr5KDmBD1pX6MDYKQ2pp
pHJcCoxw98M5VU5118BMuXB7Rm1Z4rOsULx68rG4tYwoETlqvvkH4F4lgp1HM7kK
QOHyBzIqihrlSndSQvlg5bAAM2ThlBSXxnFoWgN2ZNFfSgppHUChT6UQTHbToifL
YBDMmr8CRgS6qZ0fE2h638KBPwIzCI53PTfbfkDxDIobuZUAqfIzE2W9diz0IoM+
IJBWI1fTo9PLcXLtOSNTbGJIYhiXeaOdWzgDSygstZxC9dak8FQGVYf1rXLUfAmb
OGumI5XtVmOkNcbcjudauxzNprK6pJIQjKyQHBVriIFcPMJYMlYRxC5Uw7O1Vj12
Qq+W4fMfKr2eZpB1+Ao28Px0yEFB97+cGIaoQjHXmY2ZJupe2MetYaa1gVe/E8WS
XTYPxp9vExxmsFhgZvCT4gVCcE1ZvdDqmtyy+IHhyCaG3W3dUCA=
=vlyY
-----END PGP SIGNATURE-----
--=-=-=--
