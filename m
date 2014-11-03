From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm named array (metadata 1.2) and udev when assembling an
 array in initramfs
Date: Mon, 3 Nov 2014 12:50:20 +1100
Message-ID: <20141103125020.19308fd5@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/S.JFMIEcMho6g0EypdWIwqf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stephen Kent <smkent@smkent.net>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/S.JFMIEcMho6g0EypdWIwqf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Stephen,
 thanks for the bug report.
This patch should fix it.

NeilBrown

=46rom 628cdf19ea35daad22e409e51c0abc7ffb19d6aa Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 3 Nov 2014 12:49:05 +1100
Subject: [PATCH] Rebuildmap: strip local host name from device name.

When /run/mdadm/map is being rebuilt, e.g. by "mdadm -Ir",
if the device doesn't exist in /dev, we have to choose
a name.
Currently we don't strip the hostname which is wrong if
it is the local host.

Reported-by: Stephen Kent <smkent@smkent.net>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/mapfile.c b/mapfile.c
index 4e7f24214b8a..41599df05f97 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -455,12 +455,19 @@ void RebuildMap(void)
 							sep =3D "";
 						}
 					}
-					if (strchr(name, ':'))
-						/* probably a uniquifying
+					if (strchr(name, ':')) {
+						/* Probably a uniquifying
 						 * hostname prefix.  Allow
-						 * without a suffix
+						 * without a suffix, and strip
+						 * hostname if it is us.
 						 */
+						if (homehost && unum =3D=3D -1 &&
+						    strncmp(name, homehost,
+							    strlen(homehost)) =3D=3D 0 &&
+						    name[strlen(homehost)] =3D=3D ':')
+							name +=3D strlen(homehost)+1;
 						unum =3D -1;
+					}
=20
 					while (conflict) {
 						if (unum >=3D 0)

--Sig_/S.JFMIEcMho6g0EypdWIwqf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFbfXTnsnt1WYoG5AQLCig/+IPbcd8Xkw0l/VWoC7zrITzyUCx6er8WB
sq2cNG9fOSk8hjGH0ZeEUty+FZyPbZg3qKq6M/O/33USfm8WAWFFj8+2ti0oQ8op
ZM7dxBXotG5UPlDz+8IbGytudCnKB8boysGtscjzhiLwLBxX51BScJ7u+b7Qru5d
Wbfoxvo6tj+eyiHU+jnNpofY0c5vpamLrmXFJ4eepp3qTn7jcGeCOyz2QqHqNJRj
nVsIU/XyVLlwqYU7Xz/2FBi5oqGB8QNJKEBCWHEnwfDgCk34+svdIG76ut9LVj+V
y/dDWVHbLW4MLMYxq/vTNIS5CcCxzIR7QApp6vZDDp0u/pRCRRlMzITuTCA19E4m
CqSORemJRBEGRcunZwxXh2iBXFzHXpB0QganGsg+v7bUDnWqmNJdAzVfQiz68k7Z
QYUyrmkJjW6Y6/j2ZK6+EL7psH6guSd0ODXa1A2qp33ImYmoZleiqZ3m+igk+QM8
07IkXI0qPdwyUNSs73rsnfHT/nXRejKhBNaYQj32yKefY8UAxN2bO9+Rl496JTRQ
ivrQ8Uf1PBJhKEc+FkP9oCPF3VWg494Ic6BS+EK85Ah9IOpNH1N1q0/Y5oRv3DzC
Vh7u/rkL/o34GQtonD0PmVytD1Rw6d1azCfLu+1rK2SjavlgOxFYLgo7Vce+IVaf
eFA5Az+z5o8=
=7oNe
-----END PGP SIGNATURE-----

--Sig_/S.JFMIEcMho6g0EypdWIwqf--
