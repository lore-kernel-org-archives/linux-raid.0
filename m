From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: PATCH[03/03] md: Replacing linear with binary search for linear raid
Date: Tue, 19 May 2009 12:01:04 +0530
Message-ID: <37d33d830905182331i244a6a55l628c4658ca179eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Signed-off-by: Sandeep K Sinha <sandeepksinha@gmail.com>

    Replacing the linear search to perform binary search.

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index c0fb282..6e8db27 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -27,17 +27,33 @@
  */
 static inline dev_info_t *which_dev(mddev_t *mddev, sector_t sector)
 {
-	dev_info_t *hash;
+	int lo, hi, mid;
+	dev_info_t *dev;
 	linear_conf_t *conf =3D mddev_to_conf(mddev);

+	lo =3D 0;
+	hi =3D mddev->raid_disks - 1;
+
 	/*
-	 * Linear Search
+	 * Binary Search
 	 */
-	hash =3D conf->disks;

-	while (sector >=3D hash->rdev->sectors + hash->start_sector)
-		hash++;
-	return hash;
+	while (hi >=3D lo) {
+		mid =3D (hi + lo) / 2;
+		dev =3D conf->disks + mid;
+	=09
+		if(sector >=3D dev->start_sector && sector < dev->start_sector +
dev->rdev->sectors)
+			return dev;
+		else if (sector < dev->start_sector)
+			hi =3D mid;
+		else
+			lo =3D mid + 1;
+	}
+
+	/*
+	 * We should ideally never reach here.
+	 */
+	return dev;
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
