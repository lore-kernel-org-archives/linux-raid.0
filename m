From: NeilBrown <neilb@suse.de>
Subject: Re: Kernel OOPs after RAID10 assemble
Date: Wed, 21 Sep 2011 15:32:40 +1000
Message-ID: <20110921153240.1767d6c8@notabene.brown>
References: <C8B40B93E2024230AB92E0B360028997@MoshePC>
	<73BD7CAEBC35402D8AB28B442D788A0C@MoshePC>
	<20110912060528.5d8fba4d@notabene.brown>
	<6BFB6C30B63A4B5493F7E7F8651CE557@MoshePC>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/z03f15.skxfjde8mIQPvKW3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6BFB6C30B63A4B5493F7E7F8651CE557@MoshePC>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Melnikov <moshe@zadarastorage.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/z03f15.skxfjde8mIQPvKW3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Sep 2011 08:33:31 +0300 "Moshe Melnikov" <moshe@zadarastorage.co=
m>
wrote:

> I can reproduce it very easily.
>=20
> I don't know how to apply this patch. I have very limited knowledge in Li=
nux=20
> kernel.

If you can't build a kernel there isn't much I can do to help.
If you are using a distro kernel, maybe report the bug and the fix to the
distro and they might release a new kernel in due course.

Thanks for confirming that it is easily reproduced.  That challenged me to
examine the problem again and I see that I was missing something, and can s=
ee
exactly how the set of actions you described would cause exactly that crash.

This patch fixes it properly and will be going upstream shortly.

thanks for your help,

NeilBrown

=46rom 01f96c0a9922cd9919baf9d16febdf7016177a12 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 21 Sep 2011 15:30:20 +1000
Subject: [PATCH] md: Avoid waking up a thread after it has been freed.

Two related problems:

1/ some error paths call "md_unregister_thread(mddev->thread)"
   without subsequently clearing ->thread.  A subsequent call
   to mddev_unlock will try to wake the thread, and crash.

2/ Most calls to md_wakeup_thread are protected against the thread
   disappeared either by:
      - holding the ->mutex
      - having an active request, so something else must be keeping
        the array active.
   However mddev_unlock calls md_wakeup_thread after dropping the
   mutex and without any certainty of an active request, so the
   ->thread could theoretically disappear.
   So we need a spinlock to provide some protections.

So change md_unregister_thread to take a pointer to the thread
pointer, and ensure that it always does the required locking, and
clears the pointer properly.

Reported-by: "Moshe Melnikov" <moshe@zadarastorage.com>
Signed-off-by: NeilBrown <neilb@suse.de>
cc: stable@kernel.org

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5404b22..5c95ccb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -61,6 +61,11 @@
 static void autostart_arrays(int part);
 #endif
=20
+/* pers_list is a list of registered personalities protected
+ * by pers_lock.
+ * pers_lock does extra service to protect accesses to
+ * mddev->thread when the mutex cannot be held.
+ */
 static LIST_HEAD(pers_list);
 static DEFINE_SPINLOCK(pers_lock);
=20
@@ -739,7 +744,12 @@ static void mddev_unlock(mddev_t * mddev)
 	} else
 		mutex_unlock(&mddev->reconfig_mutex);
=20
+	/* was we've dropped the mutex we need a spinlock to
+	 * make sur the thread doesn't disappear
+	 */
+	spin_lock(&pers_lock);
 	md_wakeup_thread(mddev->thread);
+	spin_unlock(&pers_lock);
 }
=20
 static mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr)
@@ -6429,11 +6439,18 @@ mdk_thread_t *md_register_thread(void (*run) (mddev=
_t *), mddev_t *mddev,
 	return thread;
 }
=20
-void md_unregister_thread(mdk_thread_t *thread)
+void md_unregister_thread(mdk_thread_t **threadp)
 {
+	mdk_thread_t *thread =3D *threadp;
 	if (!thread)
 		return;
 	dprintk("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
+	/* Locking ensures that mddev_unlock does not wake_up a
+	 * non-existent thread
+	 */
+	spin_lock(&pers_lock);
+	*threadp =3D NULL;
+	spin_unlock(&pers_lock);
=20
 	kthread_stop(thread->tsk);
 	kfree(thread);
@@ -7340,8 +7357,7 @@ static void reap_sync_thread(mddev_t *mddev)
 	mdk_rdev_t *rdev;
=20
 	/* resync has finished, collect result */
-	md_unregister_thread(mddev->sync_thread);
-	mddev->sync_thread =3D NULL;
+	md_unregister_thread(&mddev->sync_thread);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
 		/* success...*/
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1e586bb..0a309dc 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -560,7 +560,7 @@ extern int register_md_personality(struct mdk_personali=
ty *p);
 extern int unregister_md_personality(struct mdk_personality *p);
 extern mdk_thread_t * md_register_thread(void (*run) (mddev_t *mddev),
 				mddev_t *mddev, const char *name);
-extern void md_unregister_thread(mdk_thread_t *thread);
+extern void md_unregister_thread(mdk_thread_t **threadp);
 extern void md_wakeup_thread(mdk_thread_t *thread);
 extern void md_check_recovery(mddev_t *mddev);
 extern void md_write_start(mddev_t *mddev, struct bio *bi);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 3535c23..d5b5fb3 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -514,8 +514,7 @@ static int multipath_stop (mddev_t *mddev)
 {
 	multipath_conf_t *conf =3D mddev->private;
=20
-	md_unregister_thread(mddev->thread);
-	mddev->thread =3D NULL;
+	md_unregister_thread(&mddev->thread);
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	mempool_destroy(conf->pool);
 	kfree(conf->multipaths);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f4622dd..d9587df 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2562,8 +2562,7 @@ static int stop(mddev_t *mddev)
 	raise_barrier(conf);
 	lower_barrier(conf);
=20
-	md_unregister_thread(mddev->thread);
-	mddev->thread =3D NULL;
+	md_unregister_thread(&mddev->thread);
 	if (conf->r1bio_pool)
 		mempool_destroy(conf->r1bio_pool);
 	kfree(conf->mirrors);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d7a8468..0cd9672 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2955,7 +2955,7 @@ static int run(mddev_t *mddev)
 	return 0;
=20
 out_free_conf:
-	md_unregister_thread(mddev->thread);
+	md_unregister_thread(&mddev->thread);
 	if (conf->r10bio_pool)
 		mempool_destroy(conf->r10bio_pool);
 	safe_put_page(conf->tmppage);
@@ -2973,8 +2973,7 @@ static int stop(mddev_t *mddev)
 	raise_barrier(conf, 0);
 	lower_barrier(conf);
=20
-	md_unregister_thread(mddev->thread);
-	mddev->thread =3D NULL;
+	md_unregister_thread(&mddev->thread);
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	if (conf->r10bio_pool)
 		mempool_destroy(conf->r10bio_pool);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 43709fa..ac5e8b5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4941,8 +4941,7 @@ static int run(mddev_t *mddev)
=20
 	return 0;
 abort:
-	md_unregister_thread(mddev->thread);
-	mddev->thread =3D NULL;
+	md_unregister_thread(&mddev->thread);
 	if (conf) {
 		print_raid5_conf(conf);
 		free_conf(conf);
@@ -4956,8 +4955,7 @@ static int stop(mddev_t *mddev)
 {
 	raid5_conf_t *conf =3D mddev->private;
=20
-	md_unregister_thread(mddev->thread);
-	mddev->thread =3D NULL;
+	md_unregister_thread(&mddev->thread);
 	if (mddev->queue)
 		mddev->queue->backing_dev_info.congested_fn =3D NULL;
 	free_conf(conf);

--Sig_/z03f15.skxfjde8mIQPvKW3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeXb4G5fc6gV+Wb0RAjX/AKCA/npH4BYEHuP/huKDNgBsKPeNGwCgzP8e
K8+nOIy4cNRXkzfxrz982O8=
=QfC/
-----END PGP SIGNATURE-----

--Sig_/z03f15.skxfjde8mIQPvKW3--
