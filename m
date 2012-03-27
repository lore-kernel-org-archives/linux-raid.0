From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid5:Fix recover/replace stop if handle stipe failed
Date: Tue, 27 Mar 2012 14:26:42 +1100
Message-ID: <20120327142642.3e40547d@notabene.brown>
References: <201203141507458909278@gmail.com>
	<201203141727412189832@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rOmFdKeO7oa8VlJ2EAafMV6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203141727412189832@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/rOmFdKeO7oa8VlJ2EAafMV6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Mar 2012 17:27:44 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> I created a raid5 using three disks and disk0 add bad blocks.I set faulty=
 disk2 and remov disk2 and readd disk2.
> It seems to recover well and set disk2 badblocks  as disk0.
> But the md0_resync repeatly stop and start.
> The recovery_start of disk2 all the same .
>=20

Thanks for the extra details (and sorry for the delay in replying).

There certainly is something wrong with handling bad blocks during recovery.

I think this patch should fix it.  Are you able to test it and confirm?

Thanks,
NeilBrown


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 23ac880..2186e0e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2471,39 +2471,41 @@ handle_failed_sync(struct r5conf *conf, struct stri=
pe_head *sh,
 	int abort =3D 0;
 	int i;
=20
-	md_done_sync(conf->mddev, STRIPE_SECTORS, 0);
 	clear_bit(STRIPE_SYNCING, &sh->state);
 	s->syncing =3D 0;
 	s->replacing =3D 0;
 	/* There is nothing more to do for sync/check/repair.
+	 * Don't even need to abort as that is handled elsewhere
+	 * if needed, and not always wanted e.g. if there is a known
+	 * bad block here.
 	 * For recover/replace we need to record a bad block on all
 	 * non-sync devices, or abort the recovery
 	 */
-	if (!test_bit(MD_RECOVERY_RECOVER, &conf->mddev->recovery))
-		return;
-	/* During recovery devices cannot be removed, so locking and
-	 * refcounting of rdevs is not needed
-	 */
-	for (i =3D 0; i < conf->raid_disks; i++) {
-		struct md_rdev *rdev =3D conf->disks[i].rdev;
-		if (rdev
-		    && !test_bit(Faulty, &rdev->flags)
-		    && !test_bit(In_sync, &rdev->flags)
-		    && !rdev_set_badblocks(rdev, sh->sector,
-					   STRIPE_SECTORS, 0))
-			abort =3D 1;
-		rdev =3D conf->disks[i].replacement;
-		if (rdev
-		    && !test_bit(Faulty, &rdev->flags)
-		    && !test_bit(In_sync, &rdev->flags)
-		    && !rdev_set_badblocks(rdev, sh->sector,
-					   STRIPE_SECTORS, 0))
-			abort =3D 1;
-	}
-	if (abort) {
-		conf->recovery_disabled =3D conf->mddev->recovery_disabled;
-		set_bit(MD_RECOVERY_INTR, &conf->mddev->recovery);
+	if (test_bit(MD_RECOVERY_RECOVER, &conf->mddev->recovery)) {
+		/* During recovery devices cannot be removed, so
+		 * locking and refcounting of rdevs is not needed
+		 */
+		for (i =3D 0; i < conf->raid_disks; i++) {
+			struct md_rdev *rdev =3D conf->disks[i].rdev;
+			if (rdev
+			    && !test_bit(Faulty, &rdev->flags)
+			    && !test_bit(In_sync, &rdev->flags)
+			    && !rdev_set_badblocks(rdev, sh->sector,
+						   STRIPE_SECTORS, 0))
+				abort =3D 1;
+			rdev =3D conf->disks[i].replacement;
+			if (rdev
+			    && !test_bit(Faulty, &rdev->flags)
+			    && !test_bit(In_sync, &rdev->flags)
+			    && !rdev_set_badblocks(rdev, sh->sector,
+						   STRIPE_SECTORS, 0))
+				abort =3D 1;
+		}
+		if (abort)
+			conf->recovery_disabled =3D
+				conf->mddev->recovery_disabled;
 	}
+	md_done_sync(conf->mddev, STRIPE_SECTORS, !abort);
 }
=20
 static int want_replace(struct stripe_head *sh, int disk_idx)
@@ -3203,7 +3205,8 @@ static void analyse_stripe(struct stripe_head *sh, st=
ruct stripe_head_state *s)
 			/* Not in-sync */;
 		else if (is_bad) {
 			/* also not in-sync */
-			if (!test_bit(WriteErrorSeen, &rdev->flags)) {
+			if (!test_bit(WriteErrorSeen, &rdev->flags) &&
+			    test_bit(R5_UPTODATE, &sh->devs[i].flags)) {
 				/* treat as in-sync, but with a read error
 				 * which we can now try to correct
 				 */

--Sig_/rOmFdKeO7oa8VlJ2EAafMV6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3Ezcjnsnt1WYoG5AQJwyxAAhRDhTre6TTHVxeyK8t6dozjJhfxxE1rY
0Gv91gtzoE38G3SCAIsLswyvIAdkwHin+72kHbgvV3SuV+fUnZdi0cEpDZpxCCdD
X17CtLjSdROj+wb8QuUQJO0qi2+af1HyKI6wwLQf/lCKbGoKG/nN2ZA/NbngHPn0
CcHR9+bap4+BgnR2fUJypdyZ7SdDNN48XRAQtuSFcun53y1Nk9ePHuKBHN28b395
o9jBhIjHIzpOrIWmgVf6mOlVQZfwxStWNtjKXi7MKJVojW14vMh6HGjDBaPiXiK5
6bU570PkwKoHRD63kMcJjKo2mu/s+Xm46DM2aztQSS+Z8v/GZyiDpdruv7l8r7xT
g54rHacdr/XHZaH0lsJS6KR7Hd3q7TasvBVM8z486Q2XfcMvHPIuHMEStzE3zEy8
fBEvsJUqqYzYkT3qx4gYwk+fE5DN1G6VIQ/CtyXUDBSrzfqbVlbcu1OBHBU47CRO
saI4HZrdLzqd+O8WbU+roRyF3Etvpwf0SJCflJJLxioOCTNkqNK/1Lk/W9LC+28h
54AjExTnqd6EaUVqn3pfOlVDtNNacNI0A+8wlzZEv1QwYA68x+1OjXacwiVOyq2N
z3d2dBEiO0hPEBMgATY+olOz/e1wF+FvZ7uNbHJSw3pTsRYnP1Cb3achChB3gg2C
Tpb0bshurRE=
=Ae+d
-----END PGP SIGNATURE-----

--Sig_/rOmFdKeO7oa8VlJ2EAafMV6--
