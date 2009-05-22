From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: [PATCH] md: Protecting mddev with barriers to avoid races
Date: Fri, 22 May 2009 13:48:22 +0530
Message-ID: <37d33d830905220118o1c5d6518l49b3dd1177d0a25e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Signed-off-by: Sandeep K Sinha <sandeepksinha@gmail.com>
Date:   Fri May 22 13:46:56 2009 +0530

    Protecting mddev with barriers to avoid races.

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 9ad6ec4..e2dbda8 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -28,10 +28,12 @@
 static inline dev_info_t *which_dev(mddev_t *mddev, sector_t sector)
 {
        int lo, mid, hi;
-       linear_conf_t *conf =3D mddev_to_conf(mddev);
+       linear_conf_t *conf;

        lo =3D 0;
        hi =3D mddev->raid_disks - 1;
+       barrier();
+       conf =3D mddev_to_conf(mddev);

        /*
         * Binary Search
@@ -223,6 +225,7 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t *r=
dev)

        newconf->prev =3D mddev_to_conf(mddev);
        mddev->private =3D newconf;
+       barrier();
        mddev->raid_disks++;
        md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
        set_capacity(mddev->gendisk, mddev->array_sectors);



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
