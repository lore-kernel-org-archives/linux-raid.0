From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD: Remember the last sync operation that was performed
Date: Wed, 3 Jul 2013 09:45:53 +1000
Message-ID: <20130703094553.530f21f9@notabene.brown>
References: <1372141439.2016.4.camel@f16>
	<20130626120024.3ab35f02@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jghzotnYgfFTgNkKv29KwTW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130626120024.3ab35f02@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jonathan Brassow <jbrassow@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/jghzotnYgfFTgNkKv29KwTW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Jun 2013 12:00:24 +1000 NeilBrown <neilb@suse.de> wrote:

> On Tue, 25 Jun 2013 01:23:59 -0500 Jonathan Brassow <jbrassow@redhat.com>
> wrote:
>=20
> > MD:  Remember the last sync operation that was performed
> >=20
> > This patch adds a field to the mddev structure to track the last
> > sync operation that was performed.  This is especially useful when
> > it comes to what is recorded in mismatch_cnt in sysfs.  If the
> > last operation was "data-check", then it reports the number of
> > descrepancies found by the user-initiated check.  If it was a
> > "repair" operation, then it is reporting the number of
> > descrepancies repaired.  etc.
> >=20
> > Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> >=20
> > Index: linux-upstream/drivers/md/dm-raid.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-upstream.orig/drivers/md/dm-raid.c
> > +++ linux-upstream/drivers/md/dm-raid.c
> > @@ -1388,6 +1388,7 @@ static void raid_status(struct dm_target
> >  		 *   performing a "check" of the array.
> >  		 */
> >  		DMEMIT(" %llu",
> > +		       (strcmp(rs->md.last_sync_action, "data-check")) ? 0 :
> >  		       (unsigned long long)
> >  		       atomic64_read(&rs->md.resync_mismatches));
> >  		break;
> > @@ -1651,7 +1652,7 @@ static void raid_resume(struct dm_target
> > =20
> >  static struct target_type raid_target =3D {
> >  	.name =3D "raid",
> > -	.version =3D {1, 5, 1},
> > +	.version =3D {1, 5, 2},
> >  	.module =3D THIS_MODULE,
> >  	.ctr =3D raid_ctr,
> >  	.dtr =3D raid_dtr,
> > Index: linux-upstream/drivers/md/md.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-upstream.orig/drivers/md/md.c
> > +++ linux-upstream/drivers/md/md.c
> > @@ -521,6 +521,7 @@ void mddev_init(struct mddev *mddev)
> >  	init_waitqueue_head(&mddev->recovery_wait);
> >  	mddev->reshape_position =3D MaxSector;
> >  	mddev->reshape_backwards =3D 0;
> > +	mddev->last_sync_action =3D "none";
> >  	mddev->resync_min =3D 0;
> >  	mddev->resync_max =3D MaxSector;
> >  	mddev->level =3D LEVEL_NONE;
> > @@ -4272,6 +4273,17 @@ action_store(struct mddev *mddev, const
> >  	return len;
> >  }
> > =20
> > +static struct md_sysfs_entry md_scan_mode =3D
> > +__ATTR(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
> > +
> > +static ssize_t
> > +last_sync_action_show(struct mddev *mddev, char *page)
> > +{
> > +	return sprintf(page, "%s\n", mddev->last_sync_action);
> > +}
> > +
> > +static struct md_sysfs_entry md_last_scan_mode =3D __ATTR_RO(last_sync=
_action);
> > +
> >  static ssize_t
> >  mismatch_cnt_show(struct mddev *mddev, char *page)
> >  {
> > @@ -4280,10 +4292,6 @@ mismatch_cnt_show(struct mddev *mddev, c
> >  		       atomic64_read(&mddev->resync_mismatches));
> >  }
> > =20
> > -static struct md_sysfs_entry md_scan_mode =3D
> > -__ATTR(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
> > -
> > -
> >  static struct md_sysfs_entry md_mismatches =3D __ATTR_RO(mismatch_cnt);
> > =20
> >  static ssize_t
> > @@ -4686,6 +4694,7 @@ static struct attribute *md_default_attr
> > =20
> >  static struct attribute *md_redundancy_attrs[] =3D {
> >  	&md_scan_mode.attr,
> > +	&md_last_scan_mode.attr,
> >  	&md_mismatches.attr,
> >  	&md_sync_min.attr,
> >  	&md_sync_max.attr,
> > @@ -7336,7 +7345,7 @@ void md_do_sync(struct md_thread *thread
> >  		if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
> >  			desc =3D "data-check";
> >  		else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
> > -			desc =3D "requested-resync";
> > +			desc =3D "requested-resync"; /* AKA "repair" */
> >  		else
> >  			desc =3D "resync";
> >  	} else if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
> > @@ -7344,6 +7353,8 @@ void md_do_sync(struct md_thread *thread
> >  	else
> >  		desc =3D "recovery";
> > =20
> > +	mddev->last_sync_action =3D desc;
> > +
> >  	/* we overload curr_resync somewhat here.
> >  	 * 0 =3D=3D not engaged in resync at all
> >  	 * 2 =3D=3D checking that there is no conflict with another sync
> > Index: linux-upstream/drivers/md/md.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-upstream.orig/drivers/md/md.h
> > +++ linux-upstream/drivers/md/md.h
> > @@ -268,6 +268,14 @@ struct mddev {
> > =20
> >  	struct md_thread		*thread;	/* management thread */
> >  	struct md_thread		*sync_thread;	/* doing resync or reconstruct */
> > +
> > +	/* 'last_sync_action' is initialized to "none".  It is set when a
> > +	 * sync operation (i.e "data-check", "requested-resync", "resync",
> > +	 * "recovery", or "reshape") is started.  It holds this value even
> > +	 * when the sync thread is "frozen" (interrupted) or "idle" (stopped
> > +	 * or finished).  It is overwritten when a new sync operation is begu=
n.
> > +	 */
> > +	char				*last_sync_action;
> >  	sector_t			curr_resync;	/* last block scheduled */
> >  	/* As resync requests can complete out of order, we cannot easily tra=
ck
> >  	 * how much resync has been completed.  So we occasionally pause until
> > Index: linux-upstream/Documentation/device-mapper/dm-raid.txt
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-upstream.orig/Documentation/device-mapper/dm-raid.txt
> > +++ linux-upstream/Documentation/device-mapper/dm-raid.txt
> > @@ -223,3 +223,4 @@ Version History
> >  1.5.0   Add message interface to allow manipulation of the sync_action.
> >  	New status (STATUSTYPE_INFO) fields: sync_action and mismatch_cnt.
> >  1.5.1   Add ability to restore transiently failed devices on resume.
> > +1.5.2   'mismatch_cnt' is zero unless [last_]sync_action is "check".
> >=20
> >=20
>=20
> Looks sane.  Applied, thanks.

Actually, I thought better of one little part of this.
The words "data-check" and "requested-resync" only appear in 'dmesg', not in
/sys or /proc and I want it to stay that way.
Also it is important that the new "last_sync_action" has the same set of
words as "sync_action".
So I made that change.  The new patch is below and in my for-next, and will
go to Linus tomorrow.

NeilBrown


=46rom c4a39551451666229b4ea5e8aae8ca0131d00665 Mon Sep 17 00:00:00 2001
From: Jonathan Brassow <jbrassow@redhat.com>
Date: Tue, 25 Jun 2013 01:23:59 -0500
Subject: [PATCH] MD: Remember the last sync operation that was performed

MD:  Remember the last sync operation that was performed

This patch adds a field to the mddev structure to track the last
sync operation that was performed.  This is especially useful when
it comes to what is recorded in mismatch_cnt in sysfs.  If the
last operation was "data-check", then it reports the number of
descrepancies found by the user-initiated check.  If it was a
"repair" operation, then it is reporting the number of
descrepancies repaired.  etc.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device=
-mapper/dm-raid.txt
index 2bb3a68..ef8ba9f 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -223,3 +223,4 @@ Version History
 1.5.0   Add message interface to allow manipulation of the sync_action.
 	New status (STATUSTYPE_INFO) fields: sync_action and mismatch_cnt.
 1.5.1   Add ability to restore transiently failed devices on resume.
+1.5.2   'mismatch_cnt' is zero unless [last_]sync_action is "check".
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 21e8e46..4880b69 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1388,6 +1388,7 @@ static void raid_status(struct dm_target *ti, status_=
type_t type,
 		 *   performing a "check" of the array.
 		 */
 		DMEMIT(" %llu",
+		       (strcmp(rs->md.last_sync_action, "check")) ? 0 :
 		       (unsigned long long)
 		       atomic64_read(&rs->md.resync_mismatches));
 		break;
@@ -1651,7 +1652,7 @@ static void raid_resume(struct dm_target *ti)
=20
 static struct target_type raid_target =3D {
 	.name =3D "raid",
-	.version =3D {1, 5, 1},
+	.version =3D {1, 5, 2},
 	.module =3D THIS_MODULE,
 	.ctr =3D raid_ctr,
 	.dtr =3D raid_dtr,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 26f9452..dddc87b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -521,6 +521,7 @@ void mddev_init(struct mddev *mddev)
 	init_waitqueue_head(&mddev->recovery_wait);
 	mddev->reshape_position =3D MaxSector;
 	mddev->reshape_backwards =3D 0;
+	mddev->last_sync_action =3D "none";
 	mddev->resync_min =3D 0;
 	mddev->resync_max =3D MaxSector;
 	mddev->level =3D LEVEL_NONE;
@@ -4272,6 +4273,17 @@ action_store(struct mddev *mddev, const char *page, =
size_t len)
 	return len;
 }
=20
+static struct md_sysfs_entry md_scan_mode =3D
+__ATTR(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
+
+static ssize_t
+last_sync_action_show(struct mddev *mddev, char *page)
+{
+	return sprintf(page, "%s\n", mddev->last_sync_action);
+}
+
+static struct md_sysfs_entry md_last_scan_mode =3D __ATTR_RO(last_sync_act=
ion);
+
 static ssize_t
 mismatch_cnt_show(struct mddev *mddev, char *page)
 {
@@ -4280,10 +4292,6 @@ mismatch_cnt_show(struct mddev *mddev, char *page)
 		       atomic64_read(&mddev->resync_mismatches));
 }
=20
-static struct md_sysfs_entry md_scan_mode =3D
-__ATTR(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
-
-
 static struct md_sysfs_entry md_mismatches =3D __ATTR_RO(mismatch_cnt);
=20
 static ssize_t
@@ -4686,6 +4694,7 @@ static struct attribute *md_default_attrs[] =3D {
=20
 static struct attribute *md_redundancy_attrs[] =3D {
 	&md_scan_mode.attr,
+	&md_last_scan_mode.attr,
 	&md_mismatches.attr,
 	&md_sync_min.attr,
 	&md_sync_max.attr,
@@ -7329,7 +7338,7 @@ void md_do_sync(struct md_thread *thread)
 	sector_t last_check;
 	int skipped =3D 0;
 	struct md_rdev *rdev;
-	char *desc;
+	char *desc, *action =3D NULL;
 	struct blk_plug plug;
=20
 	/* just incase thread restarts... */
@@ -7339,17 +7348,21 @@ void md_do_sync(struct md_thread *thread)
 		return;
=20
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
-		if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
+		if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
 			desc =3D "data-check";
-		else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+			action =3D "check";
+		} else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
 			desc =3D "requested-resync";
-		else
+			action =3D "repair";
+		} else
 			desc =3D "resync";
 	} else if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		desc =3D "reshape";
 	else
 		desc =3D "recovery";
=20
+	mddev->last_sync_action =3D action ?: desc;
+
 	/* we overload curr_resync somewhat here.
 	 * 0 =3D=3D not engaged in resync at all
 	 * 2 =3D=3D checking that there is no conflict with another sync
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 653f992b6..20f02c0 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -268,6 +268,14 @@ struct mddev {
=20
 	struct md_thread		*thread;	/* management thread */
 	struct md_thread		*sync_thread;	/* doing resync or reconstruct */
+
+	/* 'last_sync_action' is initialized to "none".  It is set when a
+	 * sync operation (i.e "data-check", "requested-resync", "resync",
+	 * "recovery", or "reshape") is started.  It holds this value even
+	 * when the sync thread is "frozen" (interrupted) or "idle" (stopped
+	 * or finished).  It is overwritten when a new sync operation is begun.
+	 */
+	char				*last_sync_action;
 	sector_t			curr_resync;	/* last block scheduled */
 	/* As resync requests can complete out of order, we cannot easily track
 	 * how much resync has been completed.  So we occasionally pause until


--Sig_/jghzotnYgfFTgNkKv29KwTW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdNmMTnsnt1WYoG5AQJ6/hAAxK/qriHB0gCpFWIsB0kMcLaLiPJZwQH7
0EBw3+Hwc24qpE7LAMy6M9LHkPp2z9Gl3VoV71QnxkjWOsP6oMvUOoCe/Q2/Kh7C
tZGfzUNOoThUONDdMHvrvJSPnRlU8yLQBKcKYBhWmZEy1xbNvA+V68vWKhsx3ASs
H6T66A5meQ+tWqwktTE0mVRPRhUS3kFU+rA2qph4Hh+5DHlx9Nrfn+pCxawLHiDU
bkB/8qVOhGU5CsKKHpoGRyBpj/jD8tqW13yptZPjsCLAAogZKtJaKYGuXCfvbc4C
MlnHHuloZJ5g/SeQeLfJDYpOkS4IeNzVwyWjaHLrlxx2tjVMcnGHHBO5ZCz4qa70
kZ2amtx9I1MwGzxDeaVIxoUjkXQo2YIFojzfyBijauxiORAgxMAJm5cF66gkJVIN
/nGa1MnElEwnqnl3IMh6DtHCVfPbxY3FT2hOynViQ5zRp+SeZmmlDKiCDCsWY02h
IVaGnaaHySI9MHYbi+75ydRXHbrRHA4ZW4WjZWd2DjE5PDZPl6HDTm7IlZ7I7NhG
nzkSv9L2TxAmQWrBMqhA3u/B2e3fPEAVUY8bGykDhGC0UqiU4M0weyvNeMl3Ay0i
FLuleGrLcXp2QoKWiHV7izNud5AkY6orgTsamxjU2I9k0cDpynv0NCvco6sA7ZgQ
vm8EQjKkGhg=
=bUFG
-----END PGP SIGNATURE-----

--Sig_/jghzotnYgfFTgNkKv29KwTW--
