From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm segfaults on --grow
Date: Sun, 19 Feb 2012 15:00:41 +1100
Message-ID: <20120219150041.5bc93927@notabene.brown>
References: <CAPkfHa4LzSC-mBrgKVCEGFuKg5ksOJmv6-ZMiqVnZHf+dRNeRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uf.5pMoC/5VhGb27uA4pizn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPkfHa4LzSC-mBrgKVCEGFuKg5ksOJmv6-ZMiqVnZHf+dRNeRA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: eeeee <tw@qwe123.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/uf.5pMoC/5VhGb27uA4pizn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Feb 2012 07:35:08 +0400 eeeee <tw@qwe123.info> wrote:

> i'm doing
> mdadm --grow /dev/md127 -l raid5 -n 6
> and it segfaults!
>=20
> mdadm-3.2.3

Thanks for the report.

Can you please check if this fixes the problem?

NeilBrown


diff --git a/Grow.c b/Grow.c
index 53a7cad..8198ac3 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1275,7 +1275,7 @@ char *analyse_change(struct mdinfo *info, struct resh=
ape *re)
 		break;
=20
 	case 5:
-		/* We get to RAID5 for RAID5 or RAID6 */
+		/* We get to RAID5 from RAID5 or RAID6 */
 		if (re->level !=3D 5 && re->level !=3D 6)
 			return "Cannot convert to RAID5 from this level";
=20
@@ -1297,11 +1297,27 @@ char *analyse_change(struct mdinfo *info, struct re=
shape *re)
 				char layout[40];
 				char *ls =3D map_num(r5layout, info->new_layout);
 				int l;
-				strcat(strcpy(layout, ls), "-6");
-				l =3D map_name(r6layout, layout);
-				if (l =3D=3D UnSet)
-					return "Cannot find RAID6 layout"
-						" to convert to";
+				if (ls) {
+					/* Current RAID6 layout has a RAID5
+					 * equivalent - good
+					 */
+					strcat(strcpy(layout, ls), "-6");
+					l =3D map_name(r6layout, layout);
+					if (l =3D=3D UnSet)
+						return "Cannot find RAID6 layout"
+							" to convert to";
+				} else {
+					/* Current RAID6 has no equivalent.
+					 * If it is already a '-6' layout we
+					 * can leave it unchanged, else we must
+					 * fail
+					 */
+					ls =3D map_num(r6layout, info->new_layout);
+					if (!ls ||
+					    strcmp(ls+strlen(ls)-2, "-6") !=3D 0)
+						return "Please specify new layout";
+					l =3D info->new_layout;
+				}
 				re->after.layout =3D l;
 			}
 		}

--Sig_/uf.5pMoC/5VhGb27uA4pizn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0Bz6jnsnt1WYoG5AQLyoxAAvXAbk8hHWsiPs2ukj+18SZ3dpZHQRrPC
ba3/5DQff3TTHU0lKsuQ0DoH7SvhF8A1qOfh7tXRgXPSKUkdEHkSkRNwcTP+lIMW
YoqQdI8xau0F7DNuoIVlHvLpP4LGjfAqzHYzFAwQMZSaqdrYJQyHsRIwZjKxtny2
tJQCV6voqiTfCmfbrt0RTxIQA5QLMDz8RWV7nMMpWKQWWZI7Lj7SMI7rzAtV1xtq
qJoVLmJwuF5caQjh5yOOOjPVsBzNpU9icywQcf38+2QouKgQaMZ3co0fGLcOvOnN
zvGXocX2eO1NYE4dNtTYJfsB5ORanU19o5Rr5x1Veh0KpKOqddh7Go0XQsH+GWNe
No7LThelPHFoeBR1doMHVSii5x4UgK8iFraoRPOO/g9z3f9w+GSpKKmsgs3jMhbm
bBhS4STsVFQdSkH8Y5/sWFSgXAtGqKTe/+JmJsqNtoRuzPVmcYaFlUeQqihFD+A4
7WbQ7cRzi0PxsPDqWVvaCcvd+y29N4MatbkNon9SNpo/9ooB7MtVj0yV2iy7YVYm
o7BQEaK9y19nzDAwbm77vc+ZWLkUR2LLVLd1zu+Ie/HSpw0faTiMVVW7ffdMQQBu
/6JM3PTUAD+KkISOlcKx0es5owIZvXYE4uw89Gg+8J4LBLSjEbrjQoQ5uX+rsKzU
L8o7pW63mpk=
=uuZJ
-----END PGP SIGNATURE-----

--Sig_/uf.5pMoC/5VhGb27uA4pizn--
