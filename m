From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH] Mention "endian" in documentation for --update=byte-order
Date: Mon, 08 May 2017 09:40:09 +1000
Message-ID: <87a86onsme.fsf@notabene.neil.brown.name>
References: <5c6e6e5d93d4056839e4f370e00a8e08@mail.athompso.net> <87fugio7cy.fsf@notabene.neil.brown.name> <20170506014117.4d3f1689@pog.tecnopolis.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170506014117.4d3f1689@pog.tecnopolis.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, Trevor Cordes <trevor@tecnopolis.ca>
Cc: Continuation of Round Table discussion <roundtable@muug.ca>, Adam Thompson <athompso@athompso.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


This makes it easier to find as "endian" is a commonly used term.

Reported-by: Trevor Cordes <trevor@tecnopolis.ca>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 mdadm.8.in | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index fb99a5cd9159..388e0edbf89a 100644
=2D-- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1264,7 +1264,8 @@ is correct.
 The
 .B byteorder
 option allows arrays to be moved between machines with different
=2Dbyte-order.
+byte-order, such as from a big-endian machine like a Sparc or some
+MIPS machines, to a little-endian x86_64 machine.
 When assembling such an array for the first time after a move, giving
 .B "\-\-update=3Dbyteorder"
 will cause
=2D-=20
2.12.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkPsFkACgkQOeye3VZi
gbnM7g//QoCGYLjYSb+YDBawbQj7kjvhqy1+Tz5NroZJHI8Tq2s7pX2HtiylSgZs
M4o8O785F7/NG7CRgqMDUY8gcffV4gZxjvZKcW/Ic2pHz99NpRdq04Cu47IFEwan
egYg2SqcFGYFaFe9Ze+Cn/hu3yrLexiwmcA7c/qjoFXWWaW+Ib6PMzSYLi/Vo+qs
IYCY7ObWNG74eBA5I3+F4qV7DCj8iCcNwraWl9EcOM4l+lI0OEoKApHg70pN9jSb
mZlLfuM5NDOmwA4jiPmKYvgyRt2SyXlyHPodRtTJdL/jvr/4gJ0eNe2FcHESuyRK
f3uTk0myxGPLlgi0sXCHAWmxPgsdXdPZjamcjHbmrL0GqG8InJNxZ64KPdtNcLRq
8mAMk+sG+sSaTbBp8YTYz73a7YlWpDXq+8IZggo7F4CYqiqcl4B/9JX07wMPlZ4g
qNu/SHauPYQ8I/NmC57l/Wvk5pigeJ2407hBzKVrF3F4AzwUopp1FJaMq5utYeaC
vJ1QkQRiwHA6VdOV2chHCmsMtWCC41YEdRvLVcbu/wObRWnsEq0OQ1qDmqcf9pg6
nMtXlEJw3SZPFjxeDoAOeKEFWqYZ98xG4Xb0ZkXRbLwkX/yEBna/UeOdCH/F2VA8
uNNzb8o1QQFTVsX5QJpo9pxnPs8MuwB2fAmbJEXCnngGRsrbev4=
=ud73
-----END PGP SIGNATURE-----
--=-=-=--
