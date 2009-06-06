From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: [PATCH] md linear: Protecting mddev with rcu locks to avoid races in
Date: Sat, 6 Jun 2009 20:54:09 +0530
Message-ID: <37d33d830906060824u1bf71f1ej22efc3e8bbcaf2b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Signed-off-by: Sandeep K Sinha <sandeepksinha@gmail.com>

    Protecting mddev with barriers to avoid races.

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 9ad6ec4..a56095c 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -28,9 +28,11 @@
 static inline dev_info_t *which_dev(mddev_t *mddev, sector_t sector)
 {
 	int lo, mid, hi;
-	linear_conf_t *conf =3D mddev_to_conf(mddev);
+	linear_conf_t *conf;=09
 =09
+	rcu_read_lock();
 	lo =3D 0;
+	conf =3D rcu_dereference(mddev->private);
 	hi =3D mddev->raid_disks - 1;

 	/*
@@ -45,7 +47,7 @@ static inline dev_info_t *which_dev(mddev_t *mddev,
sector_t sector)
 		else
 			lo =3D mid + 1;
 	}
-
+	rcu_read_unlock();
 	return conf->disks + lo;
 }

@@ -86,36 +88,49 @@ static int linear_mergeable_bvec(struct request_que=
ue *q,
 static void linear_unplug(struct request_queue *q)
 {
 	mddev_t *mddev =3D q->queuedata;
-	linear_conf_t *conf =3D mddev_to_conf(mddev);
+	linear_conf_t *conf;
 	int i;

+	rcu_read_lock();
+	conf =3D rcu_dereference(mddev->private);
+=09
 	for (i=3D0; i < mddev->raid_disks; i++) {
 		struct request_queue *r_queue =3D bdev_get_queue(conf->disks[i].rdev=
->bdev);
 		blk_unplug(r_queue);
 	}
+	rcu_read_unlock();
 }

 static int linear_congested(void *data, int bits)
 {
 	mddev_t *mddev =3D data;
-	linear_conf_t *conf =3D mddev_to_conf(mddev);
+	linear_conf_t *conf;
 	int i, ret =3D 0;

+	rcu_read_lock();
+	conf =3D rcu_dereference(mddev->private);
+=09
 	for (i =3D 0; i < mddev->raid_disks && !ret ; i++) {
 		struct request_queue *q =3D bdev_get_queue(conf->disks[i].rdev->bdev=
);
 		ret |=3D bdi_congested(&q->backing_dev_info, bits);
 	}
+
+	rcu_read_unlock();
 	return ret;
 }

 static sector_t linear_size(mddev_t *mddev, sector_t sectors, int raid=
_disks)
 {
-	linear_conf_t *conf =3D mddev_to_conf(mddev);
-
+	linear_conf_t *conf;
+	sector_t array_sectors;
+	rcu_read_lock();
+	conf =3D rcu_dereference(mddev->private);
 	WARN_ONCE(sectors || raid_disks,
 		  "%s does not support generic reshape\n", __func__);
-
-	return conf->array_sectors;
+	array_sectors =3D conf->array_sectors;
+	rcu_read_unlock();
+=09
+	return array_sectors;
 }

 static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
@@ -215,15 +230,14 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t =
*rdev)
 		return -EINVAL;

 	rdev->raid_disk =3D rdev->saved_raid_disk;
-
-	newconf =3D linear_conf(mddev,mddev->raid_disks+1);
+	newconf =3D linear_conf(mddev,mddev->raid_disks + 1);

 	if (!newconf)
 		return -ENOMEM;

 	newconf->prev =3D mddev_to_conf(mddev);
-	mddev->private =3D newconf;
 	mddev->raid_disks++;
+	rcu_assign_pointer(mddev->private,newconf);
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	return 0;
@@ -231,14 +245,17 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t =
*rdev)

 static int linear_stop (mddev_t *mddev)
 {
-	linear_conf_t *conf =3D mddev_to_conf(mddev);
-
+	linear_conf_t *conf;
+
+	rcu_read_lock();
+	conf =3D rcu_dereference(mddev->private);
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	do {
 		linear_conf_t *t =3D conf->prev;
 		kfree(conf);
 		conf =3D t;
 	} while (conf);
+	rcu_read_unlock();

 	return 0;
 }
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
