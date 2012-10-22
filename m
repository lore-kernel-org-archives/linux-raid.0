From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] Align FAILED to test name to be parsable
Date: Tue, 23 Oct 2012 09:23:56 +1100
Message-ID: <20121023092356.1834e0a1@notabene.brown>
References: <20121022090855.1bb52c91@notabene.brown>
	<364625821.319540709.1350894683732.JavaMail.root@zimbra33-e6.priv.proxad.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XOddwMrOlwBM5Od8=iPiwoC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <364625821.319540709.1350894683732.JavaMail.root@zimbra33-e6.priv.proxad.net>
Sender: linux-raid-owner@vger.kernel.org
To: g.esp@free.fr
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/XOddwMrOlwBM5Od8=iPiwoC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Oct 2012 10:31:23 +0200 (CEST) g.esp@free.fr wrote:

>=20
>=20
> ----- Mail original -----
> > De: "NeilBrown" <neilb@suse.de>
> > =C3=80: "Gilles Espinasse" <g.esp@free.fr>
> > Cc: linux-raid@vger.kernel.org
> > Envoy=C3=A9: Lundi 22 Octobre 2012 00:08:55
> > Objet: Re: [PATCH 1/3] Align FAILED to test name to be parsable
> >=20
> > On Sat, 20 Oct 2012 18:03:22 +0200 Gilles Espinasse <g.esp@free.fr>
> > wrote:
> >=20
> > > Signed-off-by: Gilles Espinasse <g.esp@free.fr>
> > >=20
> > > So 'grep FAILED log' is now meaningfull.
> > > Let both stdout and sderr be displayed after a failed test
> > > ---
> > >  test |    5 +++--
> > >  1 files changed, 3 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/test b/test
> > > index 9340afe..2bb482c 100755
> > > --- a/test
> > > +++ b/test
> > > @@ -222,12 +222,13 @@ do_test() {
> > >      # source script in a subshell, so it has access to our
> > >      # namespace, but cannot change it.
> > >      echo -ne "$_script... "
> > > -    if ( set -ex ; . $_script )  2> $targetdir/log
> > > +    if ( set -ex ; . $_script ) &> $targetdir/log
> > >      then
> > >        echo "succeeded"
> > >        _fail=3D0
> > >      else
> > > -      echo "FAILED - see $targetdir/log for details"
> > > +      echo "FAILED"
> > > +      cat $targetdir/log
> > >        _fail=3D1
> > >      fi
> > >      if [ "$savelogs" =3D=3D "1" ]; then
> >=20
> > Hi,
> >  the patch makes some sense, but it doesn't seem to match the
> >  description,
> >  though maybe I'm just being dense.
> >=20
> >  How does the patch "Align FAILED to test name" ?
> >=20
> > Thanks,
> > NeilBrown
> >=20
> I have a test that failed with
> tests/06r5swap... --- /var/tmp/d1	2012-10-20 08:36:12.000000000 +0200

Ahh, I see what you mean.

I've change the patch description and removed the change to the failed
message, because I don't want the log to appear in-line:

=46rom 45e34015b6f3c9deb4f489095eeedc9343a34b5e Mon Sep 17 00:00:00 2001
From: Gilles Espinasse <g.esp@free.fr>
Date: Tue, 23 Oct 2012 09:12:15 +1100
Subject: [PATCH] test: redirect all output to log file to keep output clean

If a test sent anything to stdout, it would not get logged, and would
mess up the listing of test status.

Signed-off-by: Gilles Espinasse <g.esp@free.fr>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/test b/test
index 48b47d9..e313385 100755
--- a/test
+++ b/test
@@ -227,7 +227,7 @@ do_test() {
     # source script in a subshell, so it has access to our
     # namespace, but cannot change it.
     echo -ne "$_script... "
-    if ( set -ex ; . $_script )  2> $targetdir/log
+    if ( set -ex ; . $_script ) &> $targetdir/log
     then
       echo "succeeded"
       _fail=3D0


and I have added another patch which will make sure we don't lose the logs
when using --keep-going

=46rom 1dc837e4edc805819a1ff40add3d0beecfeecdbb Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 23 Oct 2012 09:21:32 +1100
Subject: [PATCH] test: keep separate log file for each failed test.

If a test failed when --keep-going is selected, give the
log file a name based on the test name, so that all the logs
can be examined afterwards.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/test b/test
index e313385..3f8515f 100755
--- a/test
+++ b/test
@@ -232,7 +232,12 @@ do_test() {
       echo "succeeded"
       _fail=3D0
     else
-      echo "FAILED - see $targetdir/log for details"
+      log=3Dlog
+      if [ $exitonerror =3D=3D 0 ]; then
+	  log=3Dlog-`basename $_script`
+	  mv $targetdir/log $targetdir/$log
+      fi
+      echo "FAILED - see $targetdir/$log for details"
       _fail=3D1
     fi
     if [ "$savelogs" =3D=3D "1" ]; then


Thanks,
NeilBrown

--Sig_/XOddwMrOlwBM5Od8=iPiwoC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUIXHfDnsnt1WYoG5AQI8Lw/+Lmg3bEnWvx8GBG2Nm9pLkY8QSQ5Bb21w
pAumYqm2ajdjmE0OPq565edBYD4WgihvZxsIcmis7DeGPROOYzuNbaRYN1aOqIQ2
Rx5Y5wy3zDIBYZDawqAyaPHs5sAtRUnVK4NRJUMKvazY3qCaXeVVkVnrTp9G39Nw
hY8VNJGMpHbMpCcXvhXw2xsyw7EZ9R2KRZAxRgaENqeJLZ9EgUWmeKl2LAFivk85
Z/F9Zj4PoKFYQiu4Xb8t99lwHW7q5qhCsD6TWP8C5376pJ7hAld3v+hCzSggU7zP
behOGs6SWFz8aDeXMETfyE5xI9wRK/XSo6y71KrkeSy7FQPUSY9DFX6E1heLtEiL
Bqhnrz8abytN860vzVu2VFCieMwBNWxFwKCIQxtxRhuc7LONDg7fjmLOXyhaQVwl
oS4YU8dbSLbV/GhT/fQh08JBEEkuPd9n35C7ziBMa+d+yQX+FtpwbkpJGYJzF2y+
b0Hyr657EETSqOHV3rQf03lT4UUjSrIG3q7SNHa8EmY8Bz7that/UFBkZpInAPyd
tmR63EPRdATGIeM2L+MTke6afz/MSXD1FDHDwkFjpOy1L8kQd9keUgos+QicpcJ/
qMBzaVmjJp5s8Ruvckemx+yITEpXFOoZ5zxmwojW45nKKNxwsd3XNQUmv/tOx+pw
uFlQJtyRGN8=
=vbf1
-----END PGP SIGNATURE-----

--Sig_/XOddwMrOlwBM5Od8=iPiwoC--
