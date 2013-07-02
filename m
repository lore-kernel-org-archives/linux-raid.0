From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] select_devices: fix scanning of container members
 with dev list
Date: Tue, 2 Jul 2013 11:20:26 +1000
Message-ID: <20130702112026.2047a1e9@notabene.brown>
References: <1371759665-5625-1-git-send-email-mwilck@arcor.de>
	<20130624165547.0c0bd93b@notabene.brown>
	<51CC812C.3030500@arcor.de>
	<51CC94A7.9070904@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mf51U/CtrvB6Y_ivdGz13TU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51CC94A7.9070904@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/mf51U/CtrvB6Y_ivdGz13TU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Jun 2013 21:38:15 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Hi Neil,
>=20
> I wrote:
> > Well, the problem might be fixed differently by having "mdadm -Dbv" in
> > the container case print the container device.
>=20
> I have come up with another patch, based on that idea, that I'll submit
> in a minute. Do you like it better?
>=20

No I don't really.  The container name is already there is "container=3D" so
shouldn't be in "device=3D" as wel.  I did like the factored out "add_devic=
e",
so I kept that :-)

However you have helped me understand what the issue is and I know how I wa=
nt
to fix it.

What I have ended up with is similar to your original patch, except that it
only ignores "device=3D" early if "container=3D" is set, as that is the onl=
y case
that is really a problem.

I've included my patch below and pushed it out into my git tree.

Thanks for your persistence.

NeilBrown


=46rom c39b2e633fd6eb82a8a8e822ef01339806b05bfa Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 2 Jul 2013 11:07:38 +1000
Subject: [PATCH] Assemble: ignore devices=3D if container=3D is present.

If "container=3D" is present, then we are going to assemble from the
given container where that container is made of those devices or not.
So in this case the "devices=3D" is purely documentation and is best
ignored.

As part of this, move the test on the "container=3D" value when that
start with "/" up before the device is opened.  There sooner we test
things, the better.

Reported-by: Martin Wilck <mwilck@arcor.de>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Assemble.c b/Assemble.c
index a0041c6..afe5b05 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -171,8 +171,20 @@ static int select_devices(struct mddev_dev *devlist,
 		if (tmpdev->used > 1)
 			continue;
=20
-		if (ident->devices &&
-		    !match_oneof(ident->devices, devname)) {
+		if (ident->container) {
+			if (ident->container[0] =3D=3D '/' &&
+			    !same_dev(ident->container, devname)) {
+				if (report_mismatch)
+					pr_err("%s is not the container required (%s)\n",
+					       devname, ident->container);
+				continue;
+			}
+		} else if (ident->devices &&
+			   !match_oneof(ident->devices, devname)) {
+			/* Note that we ignore the "device=3D" identifier if a
+			 * "container=3D" is given.  Checking both is unnecessarily
+			 * complicated.
+			 */
 			if (report_mismatch)
 				pr_err("%s is not one of %s\n", devname, ident->devices);
 			continue;
@@ -289,29 +301,20 @@ static int select_devices(struct mddev_dev *devlist,
 			}
 			close(dfd);
=20
-			if (ident->container) {
-				if (ident->container[0] =3D=3D '/' &&
-				    !same_dev(ident->container, devname)) {
+			if (ident->container && ident->container[0] !=3D '/') {
+				/* we have a uuid */
+				int uuid[4];
+
+				content =3D *contentp;
+				tst->ss->getinfo_super(tst, content, NULL);
+
+				if (!parse_uuid(ident->container, uuid) ||
+				    !same_uuid(content->uuid, uuid, tst->ss->swapuuid)) {
 					if (report_mismatch)
-						pr_err("%s is not the container required (%s)\n",
-						       devname, ident->container);
+						pr_err("%s has wrong UUID to be required container\n",
+						       devname);
 					goto loop;
 				}
-				if (ident->container[0] !=3D '/') {
-					/* we have a uuid */
-					int uuid[4];
-
-					content =3D *contentp;
-					tst->ss->getinfo_super(tst, content, NULL);
-
-					if (!parse_uuid(ident->container, uuid) ||
-					    !same_uuid(content->uuid, uuid, tst->ss->swapuuid)) {
-						if (report_mismatch)
-							pr_err("%s has wrong UUID to be required container\n",
-							       devname);
-						goto loop;
-					}
-				}
 			}
 			/* It is worth looking inside this container.
 			 */

--Sig_/mf51U/CtrvB6Y_ivdGz13TU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdIq2jnsnt1WYoG5AQKtQBAAvccNzh9l1FmNtpQR1G9V+LvWQJkjxcu6
w4aQBb20OzLtSHMkmXb6Zh4zyw4+sMLcZVoyezV2l9Gt3JyHx8mCqaqxHgjhklPB
kxiEOydmAG21SbszPypX8VyamXuBT5SY9hxTpuw1CYKuqLiYXNpEKKmiETzabQQe
IpiWIjlTe9zxh19mHDd0FXFMgEB2GM64aeYpqb6+hIAVwEUQ3eIXHLcNX0dAmWvO
2Ucv9plY5p3icqIqBLKgaYFrlzpSqtxKylppJv1BGFz0vV+t6PqAEWHECDQA6av6
mI5e1JzUrijI/hefL4jQhN/8qATqLFYR+4us0acLHv2p+KhJ7nhRCU1bKf6RNcVK
FmmFUU9CONBUW0beY039qISLG/Y+lOkBGn9MPzdSZEjET+eIyk0SblI+H0lrcQRv
j/3WblIl1OjZEZBkDxQuRjJfwjcP3KpVR3bXPM0PAd3Z8aoKWyjaxn4UNhDTigGf
OtwZDTeVE8IAPOUoXMWnyADemAeJ+cOBEKKPwYg9sc66JhFdUaq57jS5EyDBamZF
O6wsSp1lt05bzxMY22Ft7413sEReGFFrAdk8rquGwY0vvtad3hcbokjhTim5NHZb
RPzTygY0qxTTN2uWh1uUHXgLQUztuyTDCZRbRIcw5xVDkZkCTBX2sFWAleTy7VX3
k61wQSVFptQ=
=4uxP
-----END PGP SIGNATURE-----

--Sig_/mf51U/CtrvB6Y_ivdGz13TU--
