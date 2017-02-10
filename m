From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/5] MD: attach data to each bio
Date: Fri, 10 Feb 2017 17:08:54 +1100
Message-ID: <87r336tw5l.fsf@notabene.neil.brown.name>
References: <cover.1486485935.git.shli@fb.com> <79515b1372fa1a1813c00ef0d7e0613a4512183d.1486485935.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79515b1372fa1a1813c00ef0d7e0613a4512183d.1486485935.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: khlebnikov@yandex-team.ru, hch@lst.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 07 2017, Shaohua Li wrote:

> Currently MD is rebusing some bio fields. To remove the hack, we attach
> extra data to each bio. Each personablity can attach extra data to the
> bios, so we don't need to rebuse bio fields.

I must say that I don't really like this approach.
Temporarily modifying ->bi_private and ->bi_end_io seems
.... intrusive.   I suspect it works, but I wonder if it is really
robust in the long term.

How about a different approach..  Your main concern with my first patch
was that it called md_write_start() and md_write_end() much more often,
and these performed atomic ops on "global" variables, particular
writes_pending.

We could change writes_pending to a per-cpu array which we only count
occasionally when needed.  As writes_pending is updated often and
checked rarely, a per-cpu array which is summed on demand seems
appropriate.

The following patch is an early draft - it doesn't obviously fail and
isn't obviously wrong to me.  There is certainly room for improvement
and may be bugs.
Next week I'll work on collection the re-factoring into separate
patches, which are possible good-to-have anyway.

Thoughts?

Thanks,
NeilBrown


diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8926fb781cdc..883c409902b0 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -64,6 +64,8 @@
 #include <linux/raid/md_p.h>
 #include <linux/raid/md_u.h>
 #include <linux/slab.h>
+#include <linux/percpu.h>
+
 #include <trace/events/block.h>
 #include "md.h"
 #include "bitmap.h"
@@ -2250,6 +2252,81 @@ static void export_array(struct mddev *mddev)
 	mddev->major_version =3D 0;
 }
=20
+/*
+ * The percpu writes_pending counters are linked with ->checkers and ->loc=
k.
+ * If ->writes_pending can always be decremented without a lock.
+ * It can only be incremented without a lock if ->checkers is 0 and the te=
st+incr
+ * happen in a rcu_readlocked region.
+ * ->checkers can only be changed under ->lock protection.
+ * To determine if ->writes_pending is totally zero, a quick sum without
+ * locks can be performed. If this is non-zero, then the result is final.
+ * Otherwise ->checkers must be incremented and synchronize_rcu() called.
+ * Then a sum calculated under ->lock, and the result is final until the
+ * ->checkers is decremented, or the lock is dropped.
+ *
+ */
+
+static bool __writes_pending(struct mddev *mddev)
+{
+	long cnt =3D 0;
+	int i;
+	for_each_possible_cpu(i)
+		cnt +=3D *per_cpu_ptr(mddev->writes_pending_percpu, i);
+	return cnt !=3D 0;
+}
+
+static bool set_in_sync(struct mddev *mddev)
+{
+
+	WARN_ON_ONCE(!spin_is_locked(&mddev->lock));
+	if (__writes_pending(mddev)) {
+		if (mddev->safemode =3D=3D 1)
+			mddev->safemode =3D 0;
+		return false;
+	}
+	if (mddev->in_sync)
+		return false;
+
+	mddev->checkers ++;
+	spin_unlock(&mddev->lock);
+	synchronize_rcu();
+	spin_lock(&mddev->lock);
+	if (mddev->in_sync) {
+		/* someone else set it */
+		mddev->checkers --;
+		return false;
+	}
+
+	if (! __writes_pending(mddev))
+		mddev->in_sync =3D 1;
+	if (mddev->safemode =3D=3D 1)
+		mddev->safemode =3D 0;
+	mddev->checkers --;
+	return mddev->in_sync;
+}
+
+static void inc_writes_pending(struct mddev *mddev)
+{
+	rcu_read_lock();
+	if (mddev->checkers =3D=3D 0) {
+		__this_cpu_inc(*mddev->writes_pending_percpu);
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+	/* Need that spinlock */
+	spin_lock(&mddev->lock);
+	this_cpu_inc(*mddev->writes_pending_percpu);
+	spin_unlock(&mddev->lock);
+}
+
+static void zero_writes_pending(struct mddev *mddev)
+{
+	int i;
+	for_each_possible_cpu(i)
+		*per_cpu_ptr(mddev->writes_pending_percpu, i) =3D 0;
+}
+
 static void sync_sbs(struct mddev *mddev, int nospares)
 {
 	/* Update each superblock (in-memory image), but
@@ -3583,7 +3660,6 @@ level_store(struct mddev *mddev, const char *buf, siz=
e_t len)
 	mddev->delta_disks =3D 0;
 	mddev->reshape_backwards =3D 0;
 	mddev->degraded =3D 0;
=2D	spin_unlock(&mddev->lock);
=20
 	if (oldpers->sync_request =3D=3D NULL &&
 	    mddev->external) {
@@ -3596,8 +3672,8 @@ level_store(struct mddev *mddev, const char *buf, siz=
e_t len)
 		 */
 		mddev->in_sync =3D 0;
 		mddev->safemode_delay =3D 0;
=2D		mddev->safemode =3D 0;
 	}
+	spin_unlock(&mddev->lock);
=20
 	oldpers->free(mddev, oldpriv);
=20
@@ -3963,16 +4039,11 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
 			wake_up(&mddev->sb_wait);
 			err =3D 0;
 		} else /* st =3D=3D clean */ {
+			err =3D 0;
 			restart_array(mddev);
=2D			if (atomic_read(&mddev->writes_pending) =3D=3D 0) {
=2D				if (mddev->in_sync =3D=3D 0) {
=2D					mddev->in_sync =3D 1;
=2D					if (mddev->safemode =3D=3D 1)
=2D						mddev->safemode =3D 0;
=2D					set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
=2D				}
=2D				err =3D 0;
=2D			} else
+			if (set_in_sync(mddev))
+				set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
+			else if (!mddev->in_sync)
 				err =3D -EBUSY;
 		}
 		if (!err)
@@ -4030,15 +4101,9 @@ array_state_store(struct mddev *mddev, const char *b=
uf, size_t len)
 			if (err)
 				break;
 			spin_lock(&mddev->lock);
=2D			if (atomic_read(&mddev->writes_pending) =3D=3D 0) {
=2D				if (mddev->in_sync =3D=3D 0) {
=2D					mddev->in_sync =3D 1;
=2D					if (mddev->safemode =3D=3D 1)
=2D						mddev->safemode =3D 0;
=2D					set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
=2D				}
=2D				err =3D 0;
=2D			} else
+			if (set_in_sync(mddev))
+				set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
+			else if (!mddev->in_sync)
 				err =3D -EBUSY;
 			spin_unlock(&mddev->lock);
 		} else
@@ -4993,6 +5058,9 @@ static void md_free(struct kobject *ko)
 		del_gendisk(mddev->gendisk);
 		put_disk(mddev->gendisk);
 	}
+	if (mddev->writes_pending_percpu) {
+		free_percpu(mddev->writes_pending_percpu);
+	}
=20
 	kfree(mddev);
 }
@@ -5069,6 +5137,13 @@ static int md_alloc(dev_t dev, char *name)
 	blk_queue_make_request(mddev->queue, md_make_request);
 	blk_set_stacking_limits(&mddev->queue->limits);
=20
+	mddev->writes_pending_percpu =3D alloc_percpu(long);
+	if (!mddev->writes_pending_percpu) {
+		blk_cleanup_queue(mddev->queue);
+		mddev->queue =3D NULL;
+		goto abort;
+	}
+
 	disk =3D alloc_disk(1 << shift);
 	if (!disk) {
 		blk_cleanup_queue(mddev->queue);
@@ -5152,7 +5227,7 @@ static void md_safemode_timeout(unsigned long data)
 {
 	struct mddev *mddev =3D (struct mddev *) data;
=20
=2D	if (!atomic_read(&mddev->writes_pending)) {
+	if (!__writes_pending(mddev)) {
 		mddev->safemode =3D 1;
 		if (mddev->external)
 			sysfs_notify_dirent_safe(mddev->sysfs_state);
@@ -5358,7 +5433,7 @@ int md_run(struct mddev *mddev)
 	} else if (mddev->ro =3D=3D 2) /* auto-readonly not meaningful */
 		mddev->ro =3D 0;
=20
=2D	atomic_set(&mddev->writes_pending,0);
+	zero_writes_pending(mddev);
 	atomic_set(&mddev->max_corr_read_errors,
 		   MD_DEFAULT_MAX_CORRECTED_READ_ERRORS);
 	mddev->safemode =3D 0;
@@ -5451,7 +5526,6 @@ static int restart_array(struct mddev *mddev)
 			return -EINVAL;
 	}
=20
=2D	mddev->safemode =3D 0;
 	mddev->ro =3D 0;
 	set_disk_ro(disk, 0);
 	pr_debug("md: %s switched to read-write mode.\n", mdname(mddev));
@@ -7767,9 +7841,7 @@ void md_write_start(struct mddev *mddev, struct bio *=
bi)
 		md_wakeup_thread(mddev->sync_thread);
 		did_change =3D 1;
 	}
=2D	atomic_inc(&mddev->writes_pending);
=2D	if (mddev->safemode =3D=3D 1)
=2D		mddev->safemode =3D 0;
+	inc_writes_pending(mddev);
 	if (mddev->in_sync) {
 		spin_lock(&mddev->lock);
 		if (mddev->in_sync) {
@@ -7790,12 +7862,17 @@ EXPORT_SYMBOL(md_write_start);
=20
 void md_write_end(struct mddev *mddev)
 {
=2D	if (atomic_dec_and_test(&mddev->writes_pending)) {
=2D		if (mddev->safemode =3D=3D 2)
+	this_cpu_dec(*mddev->writes_pending_percpu);
+	if (mddev->safemode =3D=3D 2) {
+		if (!__writes_pending(mddev))
 			md_wakeup_thread(mddev->thread);
=2D		else if (mddev->safemode_delay)
=2D			mod_timer(&mddev->safemode_timer, jiffies + mddev->safemode_delay);
=2D	}
+	} else if (mddev->safemode_delay)
+		/* The roundup() ensure this only performs locking once
+		 * every ->safemode_delay jiffies
+		 */
+		mod_timer(&mddev->safemode_timer,
+			  roundup(jiffies, mddev->safemode_delay) + mddev->safemode_delay);
+
 }
 EXPORT_SYMBOL(md_write_end);
=20
@@ -8398,7 +8475,7 @@ void md_check_recovery(struct mddev *mddev)
 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
 		test_bit(MD_RELOAD_SB, &mddev->flags) ||
 		(mddev->external =3D=3D 0 && mddev->safemode =3D=3D 1) ||
=2D		(mddev->safemode =3D=3D 2 && ! atomic_read(&mddev->writes_pending)
+		(mddev->safemode =3D=3D 2 && ! __writes_pending(mddev)
 		 && !mddev->in_sync && mddev->recovery_cp =3D=3D MaxSector)
 		))
 		return;
@@ -8450,19 +8527,14 @@ void md_check_recovery(struct mddev *mddev)
 				md_reload_sb(mddev, mddev->good_device_nr);
 		}
=20
=2D		if (!mddev->external) {
+		if (!mddev->external && mddev->safemode) {
 			int did_change =3D 0;
 			spin_lock(&mddev->lock);
=2D			if (mddev->safemode &&
=2D			    !atomic_read(&mddev->writes_pending) &&
=2D			    !mddev->in_sync &&
=2D			    mddev->recovery_cp =3D=3D MaxSector) {
=2D				mddev->in_sync =3D 1;
+			if (mddev->recovery_cp =3D=3D MaxSector &&
+			    set_in_sync(mddev)) {
 				did_change =3D 1;
 				set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
 			}
=2D			if (mddev->safemode =3D=3D 1)
=2D				mddev->safemode =3D 0;
 			spin_unlock(&mddev->lock);
 			if (did_change)
 				sysfs_notify_dirent_safe(mddev->sysfs_state);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2a514036a83d..7e41f882d33d 100644
=2D-- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -404,7 +404,8 @@ struct mddev {
 							 */
 	unsigned int			safemode_delay;
 	struct timer_list		safemode_timer;
=2D	atomic_t			writes_pending;
+	long				*writes_pending_percpu;
+	int				checkers;	/* # of threads checking writes_pending */
 	struct request_queue		*queue;	/* for plugging ... */
=20
 	struct bitmap			*bitmap; /* the bitmap for the device */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3c7e106c12a2..45d260326efd 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7360,7 +7360,7 @@ static int raid5_remove_disk(struct mddev *mddev, str=
uct md_rdev *rdev)
 		 * we can't wait pending write here, as this is called in
 		 * raid5d, wait will deadlock.
 		 */
=2D		if (atomic_read(&mddev->writes_pending))
+		if (!mddev->in_sync)
 			return -EBUSY;
 		log =3D conf->log;
 		conf->log =3D NULL;

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlidWPYACgkQOeye3VZi
gbmQQBAAhqDPEzWMCQmkbRU3LqbCG7ajj1P/7R97/4n+tC73ibu8tg/te+m1NVjo
CyriUYvc5KBm1rSF6ndGTkTXMYWUusEtHLnYUo88puZ3F/sONjY+m0l1Wu2Rt2AG
krwj/nNdmYDz54kmJpjFlc/Zo+inJI619/09snX5v2BHNMD8xky1PwmNGCraGDea
eDmTDHLd7KZAwEiLuJP33aYMRQN+BJbDi09ZVROhuAZnsZOIrTnju5VkQFKm83sI
jDCeDd3FolcVDqJAoXZFUJGrQ6c1XxEqsU7z+XIaL3jXG5SpVk8/sTLAihqO8k6s
0NAhSRGmZDPFzaIxffaMuY4k7FoCnXQ0yLIPX75uN6yuZwOg12WbZSB0ZIagx+eo
J+T5PpLNemrkhWdUDXwoc31+yjq8IzQURfQEv1j64br/tt/mFPQflv6MreLe+DRX
DDj567FkfanMUxGSR2M+cnihlDYjgFyztznLzi+BNNaNbYRPU9ctEAOI1tMuDlu/
SNGfLJDqdHxv/sF+cyLcv3Ut/6xr7bfwTpXZ2h9HWGui9kfc5RiAstYn3uMA/yeB
TftYmYjRTFShvBCJKRnvv+GPH+TjcEUY20jSNfLshfr0L5eQhXYrSCC5lp8HXhBz
LZiR5but/0rVRCpJrTybhrt2GsPo/tZsPdUhN+h0tM9qvnLo9JU=
=Huyj
-----END PGP SIGNATURE-----
--=-=-=--
