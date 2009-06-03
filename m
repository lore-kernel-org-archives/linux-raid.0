From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH/RFC 0/2] md: personality pushdown patches -- intro
Date: Wed, 3 Jun 2009 11:22:31 +0200
Message-ID: <20090603092231.GZ11504@skl-net.de>
References: <1243603122-11116-1-git-send-email-maan@systemlinux.org> <18977.45309.243141.219288@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vDpQvD79HZx/5O2q"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18977.45309.243141.219288@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--vDpQvD79HZx/5O2q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08:19, Neil Brown wrote:

> The second is heading in the right direction.
> However md_bitmap_present is as much of a layering violation in its
> own way as the previous code was - diving in to the metatype_type
> specific data.
>=20
> You will notice in bitmap_create that an array has a bitmap if and
> only if (mddev->bitmap_file || mddev->bitmap_offset).
> So that is the test which should be used in md_bitmap_present.

I see. And this makes the code much simpler. In fact it's so simple
that we might probably want to inline it.

> Also the function name "md_bitmap_present" give no hint that it will
> report an error - it reads like a simple test.
> Maybe "md_check_no_bitmap" to indicate what the function is expecting
> to find?

Yup, md_check_no_bitmap is more descriptive. The patch below addresses
both issues.

Thanks
Andre
---

commit cb2e46af5393cfed1b46182e2ca19a4adb7a4e0d
Author: Andre Noll <maan@systemlinux.org>
Date:   Tue Jun 2 21:49:29 2009 +0200

    md: Move check for bitmap presence to personality code.
   =20
    If the superblock of a component device indicates the presence of a
    bitmap but the corresponding raid personality does not support bitmaps
    (raid0, linear, multipath, faulty), then something is seriously wrong
    and we'd better refuse to run such an array.
   =20
    Currently, this check is performed while the superblocks are examined,
    i.e. before entering personality code. Therefore the generic md layer
    must know which raid levels support bitmaps and which do not.
   =20
    This patch avoids this layer violation without adding identical code
    to various personalities. This is accomplished by introducing a new
    public function to md.c, md_check_no_bitmap(), which replaces the
    hard-coded checks in the superblock loading functions.
   =20
    A call to md_check_no_bitmap() is added to the ->run method of each
    personality which does not support bitmaps and assembly is aborted
    if at least one component device contains a bitmap.
   =20
    Signed-off-by: Andre Noll <maan@systemlinux.org>

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 6e83b38..87d88db 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -299,8 +299,12 @@ static int run(mddev_t *mddev)
 {
 	mdk_rdev_t *rdev;
 	int i;
+	conf_t *conf;
=20
-	conf_t *conf =3D kmalloc(sizeof(*conf), GFP_KERNEL);
+	if (md_check_no_bitmap(mddev))
+		return -EINVAL;
+
+	conf =3D kmalloc(sizeof(*conf), GFP_KERNEL);
 	if (!conf)
 		return -ENOMEM;
=20
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 56c46e0..f9c713d 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -183,6 +183,8 @@ static int linear_run (mddev_t *mddev)
 {
 	linear_conf_t *conf;
=20
+	if (md_check_no_bitmap(mddev))
+		return -EINVAL;
 	mddev->queue->queue_lock =3D &mddev->queue->__queue_lock;
 	conf =3D linear_conf(mddev, mddev->raid_disks);
=20
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 812a1f7..aaeaa69 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -748,6 +748,24 @@ struct super_type  {
 };
=20
 /*
+ * Check that the given mddev has no bitmap.
+ *
+ * This function is called from the run method of all personalities that d=
o not
+ * support bitmaps. It prints an error message and returns non-zero if mdd=
ev
+ * has a bitmap. Otherwise, it returns 0.
+ *
+ */
+int md_check_no_bitmap(mddev_t *mddev)
+{
+	if (!mddev->bitmap_file && !mddev->bitmap_offset)
+		return 0;
+	printk(KERN_ERR "%s: bitmaps are not supported for %s\n",
+		mdname(mddev), mddev->pers->name);
+	return 1;
+}
+EXPORT_SYMBOL(md_bitmap_present);
+
+/*
  * load_super for 0.90.0=20
  */
 static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_v=
ersion)
@@ -800,17 +818,6 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t =
*refdev, int minor_version
 	rdev->data_offset =3D 0;
 	rdev->sb_size =3D MD_SB_BYTES;
=20
-	if (sb->state & (1<<MD_SB_BITMAP_PRESENT)) {
-		if (sb->level !=3D 1 && sb->level !=3D 4
-		    && sb->level !=3D 5 && sb->level !=3D 6
-		    && sb->level !=3D 10) {
-			/* FIXME use a better test */
-			printk(KERN_WARNING
-			       "md: bitmaps not supported for this level.\n");
-			goto abort;
-		}
-	}
-
 	if (sb->level =3D=3D LEVEL_MULTIPATH)
 		rdev->desc_nr =3D -1;
 	else
@@ -1188,17 +1195,6 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t=
 *refdev, int minor_version)
 		       bdevname(rdev->bdev,b));
 		return -EINVAL;
 	}
-	if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET)) {
-		if (sb->level !=3D cpu_to_le32(1) &&
-		    sb->level !=3D cpu_to_le32(4) &&
-		    sb->level !=3D cpu_to_le32(5) &&
-		    sb->level !=3D cpu_to_le32(6) &&
-		    sb->level !=3D cpu_to_le32(10)) {
-			printk(KERN_WARNING
-			       "md: bitmaps not supported for this level.\n");
-			return -EINVAL;
-		}
-	}
=20
 	rdev->preferred_minor =3D 0xffff;
 	rdev->data_offset =3D le64_to_cpu(sb->data_offset);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index bac7c2b..ccc0ace 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -437,5 +437,6 @@ extern void md_new_event(mddev_t *mddev);
 extern int md_allow_write(mddev_t *mddev);
 extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
 extern void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors);
+extern int md_check_no_bitmap(mddev_t *mddev);
=20
 #endif /* _MD_MD_H */
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index ca387ba..fb8a5e7 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -421,6 +421,9 @@ static int multipath_run (mddev_t *mddev)
 	struct multipath_info *disk;
 	mdk_rdev_t *rdev;
=20
+	if (md_check_no_bitmap(mddev))
+		return -EINVAL;
+
 	if (mddev->level !=3D LEVEL_MULTIPATH) {
 		printk("multipath: %s: raid level not set to multipath IO (%d)\n",
 		       mdname(mddev), mddev->level);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 0fcd9b5..3c78b42 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -311,6 +311,8 @@ static int raid0_run(mddev_t *mddev)
 		printk(KERN_ERR "md/raid0: chunk size must be a power of 2.\n");
 		return -EINVAL;
 	}
+	if (md_check_no_bitmap(mddev))
+		return -EINVAL;
 	blk_queue_max_sectors(mddev->queue, mddev->chunk_sectors);
 	mddev->queue->queue_lock =3D &mddev->queue->__queue_lock;
=20
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--vDpQvD79HZx/5O2q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKJkDXWto1QDEAkw8RApfmAKCqqustmebFWHqjXVSNKPyqVL7qswCfW1SC
M+eVleKzW3oTKsEtsAmrn80=
=H7PN
-----END PGP SIGNATURE-----

--vDpQvD79HZx/5O2q--
