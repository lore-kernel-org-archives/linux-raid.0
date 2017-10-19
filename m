From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 6/5] md: remove special meaning of ->quiesce(.., 2)
Date: Thu, 19 Oct 2017 12:49:15 +1100
Message-ID: <87infbhppg.fsf@notabene.neil.brown.name>
References: <150820826980.1646.6380214598725492144.stgit@noble> <150820840349.1646.9916811766142195995.stgit@noble> <20171018061620.alka3npi6pyd76py@kernel.org> <87bml4j43c.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87bml4j43c.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


The '2' argument means "wake up anything that is waiting".
This is an inelegant part of the design and was added
to help support management of suspend_lo/suspend_hi setting.
Now that suspend_lo/hi is managed in mddev_suspend/resume,
that need is gone.
These is still a couple of places where we call 'quiesce'
with an argument of '2', but they can safely be changed to
call ->quiesce(.., 1); ->quiesce(.., 0) which
achieve the same result at the small cost of pausing IO
briefly.

This removes a small "optimization" from suspend_{hi,lo}_store,
but it isn't clear that optimization served a useful purpose.
The code now is a lot clearer.

Suggested-by: Shaohua Li <shli@kernel.org>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--

As suggested, this remove the special meaning of '2'.

Thanks,
NeilBrown

 drivers/md/md-cluster.c  |  6 +++---
 drivers/md/md.c          | 34 ++++++++++------------------------
 drivers/md/md.h          |  9 ++++-----
 drivers/md/raid0.c       |  2 +-
 drivers/md/raid1.c       | 13 +++----------
 drivers/md/raid10.c      | 10 +++-------
 drivers/md/raid5-cache.c | 12 ++++++------
 drivers/md/raid5-log.h   |  2 +-
 drivers/md/raid5.c       | 18 ++++++------------
 9 files changed, 37 insertions(+), 69 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 03082e17c65c..72ce0bccc865 100644
=2D-- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -442,10 +442,11 @@ static void __remove_suspend_info(struct md_cluster_i=
nfo *cinfo, int slot)
 static void remove_suspend_info(struct mddev *mddev, int slot)
 {
 	struct md_cluster_info *cinfo =3D mddev->cluster_info;
+	mddev->pers->quiesce(mddev, 1);
 	spin_lock_irq(&cinfo->suspend_lock);
 	__remove_suspend_info(cinfo, slot);
 	spin_unlock_irq(&cinfo->suspend_lock);
=2D	mddev->pers->quiesce(mddev, 2);
+	mddev->pers->quiesce(mddev, 0);
 }
=20
=20
@@ -492,13 +493,12 @@ static void process_suspend_info(struct mddev *mddev,
 	s->lo =3D lo;
 	s->hi =3D hi;
 	mddev->pers->quiesce(mddev, 1);
=2D	mddev->pers->quiesce(mddev, 0);
 	spin_lock_irq(&cinfo->suspend_lock);
 	/* Remove existing entry (if exists) before adding */
 	__remove_suspend_info(cinfo, slot);
 	list_add(&s->list, &cinfo->suspend_list);
 	spin_unlock_irq(&cinfo->suspend_lock);
=2D	mddev->pers->quiesce(mddev, 2);
+	mddev->pers->quiesce(mddev, 0);
 }
=20
 static void process_add_new_disk(struct mddev *mddev, struct cluster_msg *=
cmsg)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4be3140adfe8..e1e7e8dc6878 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4857,7 +4857,7 @@ suspend_lo_show(struct mddev *mddev, char *page)
 static ssize_t
 suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
 {
=2D	unsigned long long old, new;
+	unsigned long long new;
 	int err;
=20
 	err =3D kstrtoull(buf, 10, &new);
@@ -4873,17 +4873,10 @@ suspend_lo_store(struct mddev *mddev, const char *b=
uf, size_t len)
 	if (mddev->pers =3D=3D NULL ||
 	    mddev->pers->quiesce =3D=3D NULL)
 		goto unlock;
=2D	old =3D mddev->suspend_lo;
+	mddev_suspend(mddev);
 	mddev->suspend_lo =3D new;
=2D	if (new >=3D old) {
=2D		/* Shrinking suspended region */
=2D		wake_up(&mddev->sb_wait);
=2D		mddev->pers->quiesce(mddev, 2);
=2D	} else {
=2D		/* Expanding suspended region - need to wait */
=2D		mddev_suspend(mddev);
=2D		mddev_resume(mddev);
=2D	}
+	mddev_resume(mddev);
+
 	err =3D 0;
 unlock:
 	mddev_unlock(mddev);
@@ -4901,7 +4894,7 @@ suspend_hi_show(struct mddev *mddev, char *page)
 static ssize_t
 suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
 {
=2D	unsigned long long old, new;
+	unsigned long long new;
 	int err;
=20
 	err =3D kstrtoull(buf, 10, &new);
@@ -4914,20 +4907,13 @@ suspend_hi_store(struct mddev *mddev, const char *b=
uf, size_t len)
 	if (err)
 		return err;
 	err =3D -EINVAL;
=2D	if (mddev->pers =3D=3D NULL ||
=2D	    mddev->pers->quiesce =3D=3D NULL)
+	if (mddev->pers =3D=3D NULL)
 		goto unlock;
=2D	old =3D mddev->suspend_hi;
+
+	mddev_suspend(mddev);
 	mddev->suspend_hi =3D new;
=2D	if (new <=3D old) {
=2D		/* Shrinking suspended region */
=2D		wake_up(&mddev->sb_wait);
=2D		mddev->pers->quiesce(mddev, 2);
=2D	} else {
=2D		/* Expanding suspended region - need to wait */
=2D		mddev_suspend(mddev);
=2D		mddev_resume(mddev);
=2D	}
+	mddev_resume(mddev);
+
 	err =3D 0;
 unlock:
 	mddev_unlock(mddev);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8c2158f3bd59..5dcdba84932f 100644
=2D-- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -545,12 +545,11 @@ struct md_personality
 	int (*check_reshape) (struct mddev *mddev);
 	int (*start_reshape) (struct mddev *mddev);
 	void (*finish_reshape) (struct mddev *mddev);
=2D	/* quiesce moves between quiescence states
=2D	 * 0 - fully active
=2D	 * 1 - no new requests allowed
=2D	 * others - reserved
+	/* quiesce suspends or resumes internal processing.
+	 * 1 - stop new actions and wait for action io to complete
+	 * 0 - return to normal behaviour
 	 */
=2D	void (*quiesce) (struct mddev *mddev, int state);
+	void (*quiesce) (struct mddev *mddev, int quiesce);
 	/* takeover is used to transition an array from one
 	 * personality to another.  The new personality must be able
 	 * to handle the data in the current layout.
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 5a00fc118470..5ecba9eef441 100644
=2D-- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -768,7 +768,7 @@ static void *raid0_takeover(struct mddev *mddev)
 	return ERR_PTR(-EINVAL);
 }
=20
=2Dstatic void raid0_quiesce(struct mddev *mddev, int state)
+static void raid0_quiesce(struct mddev *mddev, int quiesce)
 {
 }
=20
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 277a145b3ff5..5f21cb9ac778 100644
=2D-- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3273,21 +3273,14 @@ static int raid1_reshape(struct mddev *mddev)
 	return 0;
 }
=20
=2Dstatic void raid1_quiesce(struct mddev *mddev, int state)
+static void raid1_quiesce(struct mddev *mddev, int quiesce)
 {
 	struct r1conf *conf =3D mddev->private;
=20
=2D	switch(state) {
=2D	case 2: /* wake for suspend */
=2D		wake_up(&conf->wait_barrier);
=2D		break;
=2D	case 1:
+	if (quiesce)
 		freeze_array(conf, 0);
=2D		break;
=2D	case 0:
+	else
 		unfreeze_array(conf);
=2D		break;
=2D	}
 }
=20
 static void *raid1_takeover(struct mddev *mddev)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 374df5796649..76f042bf9a57 100644
=2D-- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3832,18 +3832,14 @@ static void raid10_free(struct mddev *mddev, void *=
priv)
 	kfree(conf);
 }
=20
=2Dstatic void raid10_quiesce(struct mddev *mddev, int state)
+static void raid10_quiesce(struct mddev *mddev, int quiesce)
 {
 	struct r10conf *conf =3D mddev->private;
=20
=2D	switch(state) {
=2D	case 1:
+	if (quiesce)
 		raise_barrier(conf, 0);
=2D		break;
=2D	case 0:
+	else
 		lower_barrier(conf);
=2D		break;
=2D	}
 }
=20
 static int raid10_resize(struct mddev *mddev, sector_t sectors)
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 6a631dd21f0b..fce290878eb5 100644
=2D-- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1589,21 +1589,21 @@ void r5l_wake_reclaim(struct r5l_log *log, sector_t=
 space)
 	md_wakeup_thread(log->reclaim_thread);
 }
=20
=2Dvoid r5l_quiesce(struct r5l_log *log, int state)
+void r5l_quiesce(struct r5l_log *log, int quiesce)
 {
 	struct mddev *mddev;
=2D	if (!log || state =3D=3D 2)
+	if (!log)
 		return;
=2D	if (state =3D=3D 0)
=2D		kthread_unpark(log->reclaim_thread->tsk);
=2D	else if (state =3D=3D 1) {
+
+	if (quiesce) {
 		/* make sure r5l_write_super_and_discard_space exits */
 		mddev =3D log->rdev->mddev;
 		wake_up(&mddev->sb_wait);
 		kthread_park(log->reclaim_thread->tsk);
 		r5l_wake_reclaim(log, MaxSector);
 		r5l_do_reclaim(log);
=2D	}
+	} else
+		kthread_unpark(log->reclaim_thread->tsk);
 }
=20
 bool r5l_log_disk_error(struct r5conf *conf)
diff --git a/drivers/md/raid5-log.h b/drivers/md/raid5-log.h
index 328d67aedda4..c3596a27a5a8 100644
=2D-- a/drivers/md/raid5-log.h
+++ b/drivers/md/raid5-log.h
@@ -8,7 +8,7 @@ extern void r5l_write_stripe_run(struct r5l_log *log);
 extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
 extern void r5l_stripe_write_finished(struct stripe_head *sh);
 extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
=2Dextern void r5l_quiesce(struct r5l_log *log, int state);
+extern void r5l_quiesce(struct r5l_log *log, int quiesce);
 extern bool r5l_log_disk_error(struct r5conf *conf);
 extern bool r5c_is_writeback(struct r5l_log *log);
 extern int
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 89ad79614309..13db3d31e983 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8026,16 +8026,12 @@ static void raid5_finish_reshape(struct mddev *mdde=
v)
 	}
 }
=20
=2Dstatic void raid5_quiesce(struct mddev *mddev, int state)
+static void raid5_quiesce(struct mddev *mddev, int quiesce)
 {
 	struct r5conf *conf =3D mddev->private;
=20
=2D	switch(state) {
=2D	case 2: /* resume for a suspend */
=2D		wake_up(&conf->wait_for_overlap);
=2D		break;
=2D
=2D	case 1: /* stop all writes */
+	if (quiesce) {
+		/* stop all writes */
 		lock_all_device_hash_locks_irq(conf);
 		/* '2' tells resync/reshape to pause so that all
 		 * active stripes can drain
@@ -8051,17 +8047,15 @@ static void raid5_quiesce(struct mddev *mddev, int =
state)
 		unlock_all_device_hash_locks_irq(conf);
 		/* allow reshape to continue */
 		wake_up(&conf->wait_for_overlap);
=2D		break;
=2D
=2D	case 0: /* re-enable writes */
+	} else {
+		/* re-enable writes */
 		lock_all_device_hash_locks_irq(conf);
 		conf->quiesce =3D 0;
 		wake_up(&conf->wait_for_quiescent);
 		wake_up(&conf->wait_for_overlap);
 		unlock_all_device_hash_locks_irq(conf);
=2D		break;
 	}
=2D	r5l_quiesce(conf->log, state);
+	r5l_quiesce(conf->log, quiesce);
 }
=20
 static void *raid45_takeover_raid0(struct mddev *mddev, int level)
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnoBJ0ACgkQOeye3VZi
gblZfxAAubmdDByPfrZGVQdfWtbnLOuh/qBTpjmrHMA/FHSXd1knCB6G8EYKhZql
Ltw5dAHkUndP1XGxiBr9bywfgl9FpNSfgjKtUoqTLjG5dqVLLm0BGY/J313kKCW9
jp/ixDEa9HvarX+F2eKvXcwSrcaJwlp6xJo6kQdpGrmThbpGIvL3sN+v5cSksFyY
EQKa9YZunEnoh18twEmhWDDk9bGSbW/juEfxovqY6GM4K+DeD+WkGf2c1a5uJzpx
/I5RgUPu8nn1a0cJfMrzPP0v0rU5GsRafRg1pE2xQoNz5/i563Jpj5EoEU2MM7Xu
MHfe9soX6Khp3AErvF7PCWEwneZtaPRhN/7CsULjLiU/g6k2Cp/2S0XjYB7MC6XI
yuj2rdsj2jTwUoeWc8UjIX8pXFiqJhMItUJxI9wD/PzkkYuNb/faxr02zyKi8Ud6
4NGzVyL0WRwDfnS1YreRtakk/sEf3UA1beb+dKF7MFgGYep6qQrqSsfGcxmX/Bwx
PFrbjY8DlJmdeDVQTvMxR1wjZROHdreU6GobQpGGUr5Jy8iABB3Kzum9XWDVjqFG
uwEKUiTJVKBwrt7QGtPWmqGE30oF71ELLkLbFAPUmWO34vjFNvudBybMp0SWHJr7
pDHg1NCdxqbVp9PurQZr2HdYD2uNTAtl+vTEf0Fhr77h9fORkI0=
=irdT
-----END PGP SIGNATURE-----
--=-=-=--
