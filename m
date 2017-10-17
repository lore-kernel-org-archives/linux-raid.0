From: NeilBrown <neilb@suse.com>
Subject: [PATCH] md: create new workqueue for object destruction
Date: Tue, 17 Oct 2017 16:04:52 +1100
Message-ID: <87mv4qjrez.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


lockdep currently complains about a potential deadlock
with sysfs access taking reconfig_mutex, and that
waiting for a work queue to complete.

The cause is inappropriate overloading of work-items
on work-queues.

We currently have two work-queues: md_wq and md_misc_wq.
They service 5 different tasks:

  mddev->flush_work                       md_wq
  mddev->event_work (for dm-raid)         md_misc_wq
  mddev->del_work (mddev_delayed_delete)  md_misc_wq
  mddev->del_work (md_start_sync)         md_misc_wq
  rdev->del_work                          md_misc_wq

We need to call flush_workqueue() for md_start_sync and ->event_work
while holding reconfig_mutex, but mustn't hold it when
flushing mddev_delayed_delete or rdev->del_work.

md_wq is a bit special as it has WQ_MEM_RECLAIM so it is
best to leave that alone.

So create a new workqueue, md_del_wq, and a new work_struct,
mddev->sync_work, so we can keep two classes of work separate.

md_del_wq and ->del_work are used only for destroying rdev
and mddev.
md_misc_wq is used for event_work and sync_work.

Also document the purpose of each flush_workqueue() call.

This removes the lockdep warning.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/md.c | 51 ++++++++++++++++++++++++++++-----------------------
 drivers/md/md.h |  1 +
 2 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index bf06ff017eda..a9f1352b3849 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -91,6 +91,7 @@ EXPORT_SYMBOL(md_cluster_mod);
=20
 static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
 static struct workqueue_struct *md_wq;
+static struct workqueue_struct *md_del_wq;
 static struct workqueue_struct *md_misc_wq;
=20
 static int remove_and_add_spares(struct mddev *mddev,
@@ -529,7 +530,7 @@ static void mddev_put(struct mddev *mddev)
 			 * succeed in waiting for the work to be done.
 			 */
 			INIT_WORK(&mddev->del_work, mddev_delayed_delete);
=2D			queue_work(md_misc_wq, &mddev->del_work);
+			queue_work(md_del_wq, &mddev->del_work);
 		} else
 			kfree(mddev);
 	}
@@ -2264,7 +2265,7 @@ static void unbind_rdev_from_array(struct md_rdev *rd=
ev)
 	synchronize_rcu();
 	INIT_WORK(&rdev->del_work, md_delayed_delete);
 	kobject_get(&rdev->kobj);
=2D	queue_work(md_misc_wq, &rdev->del_work);
+	queue_work(md_del_wq, &rdev->del_work);
 }
=20
 /*
@@ -4298,7 +4299,8 @@ new_dev_store(struct mddev *mddev, const char *buf, s=
ize_t len)
 	    minor !=3D MINOR(dev))
 		return -EOVERFLOW;
=20
=2D	flush_workqueue(md_misc_wq);
+	/* Ensure old devices are fully deleted (rdev->del_work) */
+	flush_workqueue(md_del_wq);
=20
 	err =3D mddev_lock(mddev);
 	if (err)
@@ -4537,6 +4539,7 @@ action_store(struct mddev *mddev, const char *page, s=
ize_t len)
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
 		    mddev_lock(mddev) =3D=3D 0) {
+			/* Ensure sync/recovery has fully started (mddev->sync_work) */
 			flush_workqueue(md_misc_wq);
 			if (mddev->sync_thread) {
 				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
@@ -5280,9 +5283,9 @@ static int md_alloc(dev_t dev, char *name)
 	unit =3D MINOR(mddev->unit) >> shift;
=20
 	/* wait for any previous instance of this device to be
=2D	 * completely removed (mddev_delayed_delete).
+	 * completely removed (mddev_delayed_delete, mddev->del_work).
 	 */
=2D	flush_workqueue(md_misc_wq);
+	flush_workqueue(md_del_wq);
=20
 	mutex_lock(&disks_mutex);
 	error =3D -EEXIST;
@@ -5788,6 +5791,7 @@ static void md_clean(struct mddev *mddev)
 static void __md_stop_writes(struct mddev *mddev)
 {
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	/* Ensure any sync/recovery has fully started (mddev->sync_work) */
 	flush_workqueue(md_misc_wq);
 	if (mddev->sync_thread) {
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
@@ -7128,8 +7132,8 @@ static int md_ioctl(struct block_device *bdev, fmode_=
t mode,
 	}
=20
 	if (cmd =3D=3D ADD_NEW_DISK)
=2D		/* need to ensure md_delayed_delete() has completed */
=2D		flush_workqueue(md_misc_wq);
+		/* need to ensure md_delayed_delete() has completed (rdev->del_work) */
+		flush_workqueue(md_del_wq);
=20
 	if (cmd =3D=3D HOT_REMOVE_DISK)
 		/* need to ensure recovery thread has run */
@@ -7383,8 +7387,8 @@ static int md_open(struct block_device *bdev, fmode_t=
 mode)
 		 * bd_disk.
 		 */
 		mddev_put(mddev);
=2D		/* Wait until bdev->bd_disk is definitely gone */
=2D		flush_workqueue(md_misc_wq);
+		/* Wait until bdev->bd_disk is definitely gone (mddev->del_work) */
+		flush_workqueue(md_del_wq);
 		/* Then retry the open from the top */
 		return -ERESTARTSYS;
 	}
@@ -8631,7 +8635,7 @@ static int remove_and_add_spares(struct mddev *mddev,
=20
 static void md_start_sync(struct work_struct *ws)
 {
=2D	struct mddev *mddev =3D container_of(ws, struct mddev, del_work);
+	struct mddev *mddev =3D container_of(ws, struct mddev, sync_work);
=20
 	mddev->sync_thread =3D md_register_thread(md_do_sync,
 						mddev,
@@ -8823,8 +8827,8 @@ void md_check_recovery(struct mddev *mddev)
 				 */
 				bitmap_write_all(mddev->bitmap);
 			}
=2D			INIT_WORK(&mddev->del_work, md_start_sync);
=2D			queue_work(md_misc_wq, &mddev->del_work);
+			INIT_WORK(&mddev->sync_work, md_start_sync);
+			queue_work(md_misc_wq, &mddev->sync_work);
 			goto unlock;
 		}
 	not_running:
@@ -9018,15 +9022,13 @@ static int __init md_init(void)
 	int ret =3D -ENOMEM;
=20
 	md_wq =3D alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
=2D	if (!md_wq)
=2D		goto err_wq;
=2D
+	md_del_wq =3D alloc_workqueue("md_del", 0, 0);
 	md_misc_wq =3D alloc_workqueue("md_misc", 0, 0);
=2D	if (!md_misc_wq)
=2D		goto err_misc_wq;
+	if (!md_wq || !md_del_wq || !md_misc_wq)
+		goto err;
=20
 	if ((ret =3D register_blkdev(MD_MAJOR, "md")) < 0)
=2D		goto err_md;
+		goto err;
=20
 	if ((ret =3D register_blkdev(0, "mdp")) < 0)
 		goto err_mdp;
@@ -9045,11 +9047,13 @@ static int __init md_init(void)
=20
 err_mdp:
 	unregister_blkdev(MD_MAJOR, "md");
=2Derr_md:
=2D	destroy_workqueue(md_misc_wq);
=2Derr_misc_wq:
=2D	destroy_workqueue(md_wq);
=2Derr_wq:
+err:
+	if (md_wq)
+		destroy_workqueue(md_wq);
+	if (md_del_wq)
+		destroy_workqueue(md_del_wq);
+	if (md_misc_wq)
+		destroy_workqueue(md_misc_wq);
 	return ret;
 }
=20
@@ -9304,6 +9308,7 @@ static __exit void md_exit(void)
 		 */
 	}
 	destroy_workqueue(md_misc_wq);
+	destroy_workqueue(md_del_wq);
 	destroy_workqueue(md_wq);
 }
=20
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 03fc641e5da1..8c2158f3bd59 100644
=2D-- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -397,6 +397,7 @@ struct mddev {
 	struct kernfs_node		*sysfs_action;  /* handle for 'sync_action' */
=20
 	struct work_struct del_work;	/* used for delayed sysfs removal */
+	struct work_struct sync_work;	/* used for async starting of md_do_sync */
=20
 	/* "lock" protects:
 	 *   flush_bio transition from NULL to !NULL
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnlj3UACgkQOeye3VZi
gbmjRg/8DKk/TY2e3s+6jRxB5IdAZX8COuaQfA8L9X5M4/78VFebcqOI/V+yf1vG
9ZqttXXApbYmce8nrFJIyrnKT2liJXR005pmDu2QTBZw0AQajNI8euDuC66UqxwL
QukMxwVPrVc5HVY4FXh0Vdb+m0b/pWf/IxrKnRqDDGNMCMPElnSXn+Z+IIpwS3MP
6kEYWZUA0pJVznhgdXLMHjpFV9WN96NPoKnRKpGFbKDAI7D5WiS6zP8h26frGNu8
PQUs6U4Nkg6SeKLJuAL1LQYr/FYgL60gG98hFw87ShYhgYIyqsOk1I7JWSSxqIBO
pr/kCUn8i4RgjXVW8eeHUFGJImG1gxkfu9TTQVW4BQBQaZlOU+eyJ4rvPHjcIRtU
xZU32T+nTVu7RISX/2Z1XiBdopnRIVvLCPO+h4jrJTxcI1PiAq7rnR2f8G7gP5A7
yw+KB4HwdusUmOzCMGIjllrIgyKEPkOF0Iebhp5D/kIkEEVE8D19dPJ8lgebTV9j
AzdB7aCh/rWUK7F1DWKnxvEax/sknJCoScnHf/YeHJOkbPz2YUitm21sKGjnZWvX
VeGcGnIr6cQAsfLTZjOpLSFdPWj6yUUp2chqWHqcRNy1Relk/dKcRRXdDalHDrZ4
fB7CXi0J+7kg2tHMLcYeN57l72jNwczGBKE1q4X8u3QJ96xdyaI=
=Yd6z
-----END PGP SIGNATURE-----
--=-=-=--
