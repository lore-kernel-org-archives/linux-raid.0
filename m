Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F6CCC433DB
	for <linux-raid@archiver.kernel.org>; Fri, 26 Feb 2021 01:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB79464F21
	for <linux-raid@archiver.kernel.org>; Fri, 26 Feb 2021 01:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhBZBDZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:03:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:54474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231414AbhBZBDW (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 25 Feb 2021 20:03:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E912FAAC5;
        Fri, 26 Feb 2021 01:02:40 +0000 (UTC)
From:   NeilBrown <neilb@suse.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Date:   Fri, 26 Feb 2021 12:02:36 +1100
Subject: [PATCH mdadm] Grow: be careful of corrupt dev_roles list
cc:     linux-raid@vger.kernel.org
Message-ID: <87pn0niqtv.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


I've seen a case where the dev_roles list of a linear array
was corrupt.  ->max_dev was > 128 and > raid_disks, and the
extra slots were '0', not 0xFFFE or 0xFFFF.

This caused problems when a 128th device was added.

So:
 1/ make Grow_Add_device more robust so that if numbers
   look wrong, it fails-safe.

 2/ make examine_super1() report details if the dev_roles
   array is corrupt.

Signed-off-by: NeilBrown <neilb@suse.de>
=2D--
 Grow.c   | 15 ++++++++++++---
 super1.c | 48 ++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/Grow.c b/Grow.c
index 6b8321c5172f..19ac3f479564 100644
=2D-- a/Grow.c
+++ b/Grow.c
@@ -197,7 +197,12 @@ int Grow_Add_device(char *devname, int fd, char *newde=
v)
 	info.disk.minor =3D minor(rdev);
 	info.disk.raid_disk =3D d;
 	info.disk.state =3D (1 << MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE);
=2D	st->ss->update_super(st, &info, "linear-grow-new", newdev, 0, 0, NULL);
+	if (st->ss->update_super(st, &info, "linear-grow-new", newdev,
+				 0, 0, NULL) !=3D 0) {
+		pr_err("Preparing new metadata failed on %s\n", newdev);
+		close(nfd);
+		return 1;
+	}
=20
 	if (st->ss->store_super(st, nfd)) {
 		pr_err("Cannot store new superblock on %s\n", newdev);
@@ -250,8 +255,12 @@ int Grow_Add_device(char *devname, int fd, char *newde=
v)
 		info.array.active_disks =3D nd+1;
 		info.array.working_disks =3D nd+1;
=20
=2D		st->ss->update_super(st, &info, "linear-grow-update", dv,
=2D				     0, 0, NULL);
+		if (st->ss->update_super(st, &info, "linear-grow-update", dv,
+				     0, 0, NULL) !=3D 0) {
+			pr_err("Updating metadata failed on %s\n", dv);
+			close(fd2);
+			return 1;
+		}
=20
 		if (st->ss->store_super(st, fd2)) {
 			pr_err("Cannot store new superblock on %s\n", dv);
diff --git a/super1.c b/super1.c
index 8b0d6ff3d8bc..e8f4715f5c03 100644
=2D-- a/super1.c
+++ b/super1.c
@@ -330,6 +330,7 @@ static void examine_super1(struct supertype *st, char *=
homehost)
 	int layout;
 	unsigned long long sb_offset;
 	struct mdinfo info;
+	int inconsistent =3D 0;
=20
 	printf("          Magic : %08x\n", __le32_to_cpu(sb->magic));
 	printf("        Version : 1");
@@ -576,14 +577,16 @@ static void examine_super1(struct supertype *st, char=
 *homehost)
 			if (role =3D=3D d)
 				cnt++;
 		}
=2D		if (cnt =3D=3D 2)
+		if (cnt =3D=3D 2 && __le32_to_cpu(sb->level) > 0)
 			printf("R");
 		else if (cnt =3D=3D 1)
 			printf("A");
 		else if (cnt =3D=3D 0)
 			printf(".");
=2D		else
+		else {
 			printf("?");
+			inconsistent =3D 1;
+		}
 	}
 #if 0
 	/* This is confusing too */
@@ -598,6 +601,21 @@ static void examine_super1(struct supertype *st, char =
*homehost)
 #endif
 	printf(" ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D replacing)");
 	printf("\n");
+	for (d =3D 0; d < __le32_to_cpu(sb->max_dev); d++) {
+		unsigned int r =3D __le16_to_cpu(sb->dev_roles[d]);
+		if (r <=3D MD_DISK_ROLE_MAX &&
+		    r > __le32_to_cpu(sb->raid_disks) + delta_extra)
+			inconsistent =3D 1;
+	}
+	if (inconsistent) {
+		printf("WARNING Array state is inconsistent - each number should appear =
only once\n");
+		for (d =3D 0; d < __le32_to_cpu(sb->max_dev); d++)
+			if (__le16_to_cpu(sb->dev_roles[d]) >=3D MD_DISK_ROLE_FAULTY)
+				printf(" %d:-", d);
+			else
+				printf(" %d:%d", d, __le16_to_cpu(sb->dev_roles[d]));
+		printf("\n");
+	}
 }
=20
 static void brief_examine_super1(struct supertype *st, int verbose)
@@ -1264,19 +1282,25 @@ static int update_super1(struct supertype *st, stru=
ct mdinfo *info,
 			rv =3D 1;
 		}
 	} else if (strcmp(update, "linear-grow-new") =3D=3D 0) {
=2D		unsigned int i;
+		int i;
 		int fd;
=2D		unsigned int max =3D __le32_to_cpu(sb->max_dev);
+		int max =3D __le32_to_cpu(sb->max_dev);
+
+		if (max > MAX_DEVS)
+			return -2;
=20
 		for (i =3D 0; i < max; i++)
 			if (__le16_to_cpu(sb->dev_roles[i]) >=3D
 			    MD_DISK_ROLE_FAULTY)
 				break;
+		if (i !=3D info->disk.number)
+			return -2;
 		sb->dev_number =3D __cpu_to_le32(i);
=2D		info->disk.number =3D i;
=2D		if (i >=3D max) {
+
+		if (i =3D=3D max)
 			sb->max_dev =3D __cpu_to_le32(max+1);
=2D		}
+		if (i > max)
+			return -2;
=20
 		random_uuid(sb->device_uuid);
=20
@@ -1302,10 +1326,14 @@ static int update_super1(struct supertype *st, stru=
ct mdinfo *info,
 		}
 	} else if (strcmp(update, "linear-grow-update") =3D=3D 0) {
 		int max =3D __le32_to_cpu(sb->max_dev);
=2D		sb->raid_disks =3D __cpu_to_le32(info->array.raid_disks);
=2D		if (info->array.raid_disks > max) {
+		int i =3D info->disk.number;
+		if (max > MAX_DEVS || i > MAX_DEVS)
+			return -2;
+		if (i > max)
+			return -2;
+		if (i =3D=3D max)
 			sb->max_dev =3D __cpu_to_le32(max+1);
=2D		}
+		sb->raid_disks =3D __cpu_to_le32(info->array.raid_disks);
 		sb->dev_roles[info->disk.number] =3D
 			__cpu_to_le16(info->disk.raid_disk);
 	} else if (strcmp(update, "resync") =3D=3D 0) {
=2D-=20
2.30.1


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJCBAEBCAAsFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAmA4SKwOHG5laWxiQHN1
c2UuZGUACgkQOeye3VZigbn07RAAwev9DFYJ2tRDmyzUx/G8rtCiwl6mnO+7lLuM
4rTOyahiedgWZu+UzjSycuBT5qSiE0g3uLgeKQ5KKyyjKlHQrVV116xgVzdW2Two
1aC9IiILM/YODmjOP+oowtgNcELPVtEhp2zUBV5T5gsr8vnRhtNYP0qHPywM0YKT
v//Ta3mn8Bih+3Md1sU255L9LGgBAO4YH3S/P6ARro8APusDbNtb6E2UBRAVImsw
9Ljudx31NMvAJyASawZAntyHjhu4lpParJzLHa6mlCK5juMRK/APr+4hkQk/sini
ZmsuGDXN7+1bgwDfBlo7YAov6GWPBCKr9HKCeKiBEvA59+J8dXi4CiX2rTsp8/4O
61+51lpMEfntzr1XUjT1OOWP+At92opZti//lFW5cSiV0fMsYSobOM7rlz+0jFbL
kbmytYeZZe60eFdSmFfBAO673DKuIDdnug3UKktgprf48yvIU/1m1PZaO/6EDeZx
CeqhstDAlfSzjq5unwO/F1c4NUlAdJlpwukOCRC+uQsuT0g4bY89aH/UzaHvnaRi
vnejaS4gBqxFzPWN5pPWfOZV+PxCkxICr3m6VP3eFjw0KP18k7XPS1YhopNeEpxy
VClnv4Xq0lPxZGmqK41vEZhcFeP+xIKVWofXaLTUpmIcGq7p4M42+GBCrHGbV5/M
e+/EDyw=
=YBT9
-----END PGP SIGNATURE-----
--=-=-=--
