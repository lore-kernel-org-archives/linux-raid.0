From: Lars Marowsky-Bree <lmb@suse.de>
Subject: [fixes] Re: Locking bugs in 2.4 md.c
Date: Wed, 24 Sep 2003 12:31:30 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030924103130.GA21004@marowsky-bree.de>
References: <20030918152310.GD30852@marowsky-bree.de> <16234.25885.855209.372799@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16234.25885.855209.372799@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--1LKvkjL3sHcu1TtY
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2003-09-19T12:08:29,
   Neil Brown <neilb@cse.unsw.edu.au> said:

Hi Neil,

your patch needs the following two addendums.

Andi Kleen: Locking in md_seq_next is wrong, should happen in
md_seq_start

Andrea & I: Refcounting for the raidautostart feature is wrong.
This is actually a long-standing bug which is catched by your diffs,
which notice the wrong counter and BUG().

What would happen: user-space open()s /dev/md0, issues
ioctl(RAID_AUTOSTART) - which creates all md devices and sets active =3D=3D
0 ultimately -, and then close()s /dev/md0, which decrements active to
-1. Oops next time md_make_request gets called.

Patch fixes this and adds safeguard to md_release() already.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering		ever tried. ever failed. no matter.
SuSE Labs				try again. fail again. fail better.
Research & Development, SUSE LINUX AG		-- Samuel Beckett


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=md-seqlock
Content-Transfer-Encoding: quoted-printable

--- linux/drivers/md/md.c-o	2003-09-24 09:45:39.000000000 +0000
+++ linux/drivers/md/md.c	2003-09-24 09:47:23.000000000 +0000
@@ -3287,6 +3287,7 @@
=20
 	if (l > 0x10000)
 		return NULL;
+	down_read(&all_mddevs_sem);
 	if (!l--)
 		/* header */
 		return (void*)1;
@@ -3304,7 +3305,6 @@
 	struct list_head *tmp;
 	mddev_t *next_mddev, *mddev =3D v;
=20
-	down_read(&all_mddevs_sem);
 	++*pos;
 	if (v =3D=3D (void*)2)
 		return NULL;

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=md-refcount-fix
Content-Transfer-Encoding: quoted-printable

--- linux-2.4.21/drivers/md/md.c	2003-09-24 10:54:35.000000000 +0200
+++ linux-2.4.21.new/drivers/md/md.c	2003-09-24 10:53:34.000000000 +0200
@@ -60,7 +60,7 @@
 #endif
=20
 #ifndef MODULE
-static void autostart_arrays (void);
+static void autostart_arrays (kdev_t);
 #endif
=20
 static mdk_personality_t *pers[MAX_PERSONALITY];
@@ -2753,7 +2753,7 @@
 #ifndef MODULE
 		case RAID_AUTORUN:
 			err =3D 0;
-			autostart_arrays();
+			autostart_arrays(dev);
 			goto done;
 #endif
=20
@@ -3017,8 +3017,11 @@
 {
 	mddev_t *mddev =3D kdev_to_mddev(inode->i_rdev);
 	if (mddev) {
-		atomic_dec(&mddev->active);
-		atomic_dec(&mddev->active);
+		if (atomic_dec_and_test(&mddev->active))
+			/* Refcount should _never_ drop to zero here! */
+			BUG();
+		else
+			atomic_dec(&mddev->active);
 	}
 	return 0;
 }
@@ -3923,7 +3926,7 @@
 }
=20
=20
-static void autostart_arrays(void)
+static void autostart_arrays(kdev_t countdev)
 {
 	mdk_rdev_t *rdev;
 	int i;
@@ -3954,7 +3957,7 @@
 	}
 	dev_cnt =3D 0;
=20
-	autorun_devices(-1);
+	autorun_devices(countdev);
 }
=20
 static struct {
@@ -4183,7 +4186,7 @@
 	if (raid_setup_args.noautodetect)
 		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. (raid=3Dnoa=
utodetect)\n");
 	else
-		autostart_arrays();
+		autostart_arrays(-1);
 	md_setup_drive();
 	return 0;
 }

--gKMricLos+KVdGMg--

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE/cXKBudf3XQV4S2cRAn0xAJ9PF98+EkvIStA96tTW+PFe4s1t4QCfQnTQ
Fo08npgYS39Y1vZ7NXiVJfQ=
=zHJ9
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
