From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Small fix for 2.4 md.c - using device information before lock_dev()
Date: Wed, 12 Mar 2003 15:06:46 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030312140646.GJ32759@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qjNfmADvan18RZcF"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--qjNfmADvan18RZcF
Content-Type: multipart/mixed; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good morning,

I've been testing md under UML. It appears that UML is exposing a minor bug=
 in
md.c: it is trying to use information about the device (in particular,
blk_sizes[]) before having imported it (which calls lock_dev() and thus mak=
es
the information available in the first place).

This was exposed because UML resets the blk_sizes[] information to zero on
ubd_release().

Working patch attached; it just reorders the function calls. Please apply to
2.4 if appropriate.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
Principal Squirrel=20
SuSE Labs - Research & Development, SuSE Linux AG
 =20
"If anything can go wrong, it will." "Chance favors the prepared (mind)."
  -- Capt. Edward A. Murphy            -- Louis Pasteur

--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="md.c.diff"
Content-Transfer-Encoding: quoted-printable

--- md.c~	Tue Mar 11 15:21:11 2003
+++ md.c	Tue Mar 11 16:54:22 2003
@@ -2456,13 +2456,6 @@
 	}
=20
 	persistent =3D !mddev->sb->not_persistent;
-	size =3D calc_dev_size(dev, mddev, persistent);
-
-	if (size < mddev->sb->size) {
-		printk(KERN_WARNING "md%d: disk size %d blocks < array size %d\n",
-				mdidx(mddev), size, mddev->sb->size);
-		return -ENOSPC;
-	}
=20
 	rdev =3D find_rdev(mddev, dev);
 	if (rdev)
@@ -2473,6 +2466,7 @@
 		printk(KERN_WARNING "md: error, md_import_device() returned %d\n", err);
 		return -EINVAL;
 	}
+=09
 	rdev =3D find_rdev_all(dev);
 	if (!rdev) {
 		MD_BUG();
@@ -2484,6 +2478,15 @@
 		err =3D -EINVAL;
 		goto abort_export;
 	}
+=09
+	size =3D calc_dev_size(dev, mddev, persistent);
+	if (size < mddev->sb->size) {
+		printk(KERN_WARNING "md%d: disk size %d blocks < array size %d\n",
+				mdidx(mddev), size, mddev->sb->size);
+		err =3D -ENOSPC;
+		goto abort_export;
+	}
+=09
 	bind_rdev_to_array(rdev, mddev);
=20
 	/*

--yEPQxsgoJgBvi8ip--

--qjNfmADvan18RZcF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE+bz72udf3XQV4S2cRAlHSAJ0YZ6tvmLTMl0sVX6CGfUcJQvcr+wCfQGBe
xOmHdPlhcTHtTEQEVEcy9gg=
=5YwE
-----END PGP SIGNATURE-----

--qjNfmADvan18RZcF--
