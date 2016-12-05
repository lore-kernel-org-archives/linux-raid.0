From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH] mdopen: open md devices O_RDONLY
Date: Mon, 05 Dec 2016 17:27:03 +1100
Message-ID: <87eg1m6gco.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, Marc Smith <marc.smith@mcc.edu>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


There is no need to request write access when opening
the md device, as we never write to it, and none of the
ioctls we use require write access.

If we do open with write access, then when we close, udev notices that
the device was closed after being open for write access, and it
generates a CHANGE event.

This is generally unwanted, and particularly problematic when mdadm is
trying to --stop the array, as the CHANGE event can cause the array to
be re-opened before it completely closed, which results in a new mddev
being allocated.

So just use O_RDONLY instead of O_RDWR.

Reported-by: Marc Smith <marc.smith@mcc.edu>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 mdassemble.c | 2 +-
 mdopen.c     | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mdassemble.c b/mdassemble.c
index 78d363a328c7..471ffeb03ae4 100644
=2D-- a/mdassemble.c
+++ b/mdassemble.c
@@ -32,7 +32,7 @@ char const Name[] =3D "mdassemble";
 /* from mdopen.c */
 int open_mddev(char *dev, int report_errors/*unused*/)
 {
=2D	int mdfd =3D open(dev, O_RDWR);
+	int mdfd =3D open(dev, O_RDONLY);
 	if (mdfd < 0)
 		pr_err("error opening %s: %s\n",
 			dev, strerror(errno));
diff --git a/mdopen.c b/mdopen.c
index 0ea38749a582..685ca3287304 100644
=2D-- a/mdopen.c
+++ b/mdopen.c
@@ -416,9 +416,7 @@ int create_mddev(char *dev, char *name, int autof, int =
trustworthy,
  */
 int open_mddev(char *dev, int report_errors)
 {
=2D	int mdfd =3D open(dev, O_RDWR);
=2D	if (mdfd < 0 && errno =3D=3D EACCES)
=2D		mdfd =3D open(dev, O_RDONLY);
+	int mdfd =3D open(dev, O_RDONLY);
 	if (mdfd < 0) {
 		if (report_errors)
 			pr_err("error opening %s: %s\n",
=2D-=20
2.10.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhFCLcACgkQOeye3VZi
gbmD3hAAkFLH1iNihaW/JIV/8yjV7jae0NGO7wS1ajnEsWvbxc1JOJig7cRkrezr
pcpsNleL2efvuPIrE2Ts3ycOGsPtLJjAHP3kTHYZuujku/uUOem9nimb0OHRFMy7
luy5V5XXhrcT9JLx/V2c+ZazGT0vyuB2O1U1QYEzh1/mwdOalu7kON0MJEtTKPPC
+ik9n2aDxHCkqhm/x5l8qs1xTlpdLJxeY91094UzAdHbfUKBOOqtkkXRA+ach6K+
nZc7RbH0vId6k7DMn9L2KAa1C2SAxLUTwkbFPpmeZRE+sqFVCw6VzqKNaSk13buD
GNElqpe87U2BTEtXrTkz8LoWItIkU0FtsnZ8WYjCQ7HvwmJ8BaYLwdit30xY58dk
KiSIRwQX1GxCAKU0sRIKimtn9Abaf1/o8vtEtyTKmMVs/e2MyWq1drtdpOuQ4ENn
VaIYevKiqbYw0KjL+VMcEB1mSL4Vu1czU9jGpJAyJR+IRkss0Tg38Op6TARtAAvw
6vel0aw2JVsjZ3txIWqR71B800sXRP+wNaN6lV8iC2nnjetlU9jn1xygztfR2FR/
67EM73lf5pb19oKiZhV1Od1pUKZLLXhCpyGQmbCCmpMgPlk+2ghO57AkwLDdrzaR
Y9giwgidSqptrWWqAmZ9k560edIWyxp0V9X32cb8RMfDzV+PMnM=
=CT2E
-----END PGP SIGNATURE-----
--=-=-=--
