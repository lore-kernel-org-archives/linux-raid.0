From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: PATCH[03/03] md: Binary search in linear raid
Date: Tue, 19 May 2009 16:22:54 +0530
Message-ID: <37d33d830905190352r5380ac16m166b621c13356bc1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
This patch replaces the linear search in which_dev to binary search.

Author: Sandeep K Sinha <sandeepksinha@gmail.com>
Date:   Tue May 19 16:14:15 2009 +0530

    Replaces the linear search to binary search in which_dev.

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index f7f6bb9..9ad6ec4 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -27,14 +27,26 @@
  */
 static inline dev_info_t *which_dev(mddev_t *mddev, sector_t sector)
 {
-	dev_info_t *hash;
+	int lo, mid, hi;
 	linear_conf_t *conf =3D mddev_to_conf(mddev);
+=09
+	lo =3D 0;
+	hi =3D mddev->raid_disks - 1;

-	hash =3D conf->disks;
+	/*
+	 * Binary Search
+	 */
+
+	while (hi > lo) {
+
+		mid =3D (hi + lo) / 2;
+		if (sector < conf->disks[mid].end_sector)
+			hi =3D mid;
+		else
+			lo =3D mid + 1;
+	}

-	while (sector >=3D hash->end_sector)
-		hash++;
-	return hash;
+	return conf->disks + lo;
 }

 /**

--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
