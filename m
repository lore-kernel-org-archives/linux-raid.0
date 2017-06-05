From: NeilBrown <neilb@suse.com>
Subject: [PATCH] md: fix deadlock between mddev_suspend() and md_write_start()
Date: Mon, 05 Jun 2017 16:49:39 +1000
Message-ID: <87wp8rc4jg.fsf@notabene.neil.brown.name>
References: <87lgppz221.fsf@esperi.org.uk> <87a865jf9a.fsf@notabene.neil.brown.name> <87fufwy3lr.fsf@esperi.org.uk> <87poezhwsa.fsf@notabene.neil.brown.name> <20170524225735.555dpfe24mi6yxrb@kernel.org> <871sr8h8qx.fsf@notabene.neil.brown.name> <20170530174133.qdj2qsopwug2opp6@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170530174133.qdj2qsopwug2opp6@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


If mddev_suspend() races with md_write_start() we can deadlock
with mddev_suspend() waiting for the request that is currently
in md_write_start() to complete the ->make_request() call,
and md_write_start() waiting for the metadata to be updated
to mark the array as 'dirty'.
As metadata updates done by md_check_recovery() only happen then
the mddev_lock() can be claimed, and as mddev_suspend() is often
called with the lock held, these threads wait indefinitely for each
other.

We fix this by having md_write_start() abort if mddev_suspend()
is happening, and ->make_request() aborts if md_write_start()
aborted.
md_make_request() can detect this abort, decrease the ->active_io
count, and wait for mddev_suspend().

Reported-by: Nix <nix@esperi.org.uk>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/faulty.c    |  5 +++--
 drivers/md/linear.c    |  7 ++++---
 drivers/md/md.c        | 23 +++++++++++++++++------
 drivers/md/md.h        |  4 ++--
 drivers/md/multipath.c |  8 ++++----
 drivers/md/raid0.c     |  7 ++++---
 drivers/md/raid1.c     | 11 +++++++----
 drivers/md/raid10.c    | 10 ++++++----
 drivers/md/raid5.c     | 17 +++++++++--------
 9 files changed, 56 insertions(+), 36 deletions(-)

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index b0536cfd8e17..06a64d5d8c6c 100644
=2D-- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -170,7 +170,7 @@ static void add_sector(struct faulty_conf *conf, sector=
_t start, int mode)
 		conf->nfaults =3D n+1;
 }
=20
=2Dstatic void faulty_make_request(struct mddev *mddev, struct bio *bio)
+static bool faulty_make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct faulty_conf *conf =3D mddev->private;
 	int failit =3D 0;
@@ -182,7 +182,7 @@ static void faulty_make_request(struct mddev *mddev, st=
ruct bio *bio)
 			 * just fail immediately
 			 */
 			bio_io_error(bio);
=2D			return;
+			return true;
 		}
=20
 		if (check_sector(conf, bio->bi_iter.bi_sector,
@@ -224,6 +224,7 @@ static void faulty_make_request(struct mddev *mddev, st=
ruct bio *bio)
 		bio->bi_bdev =3D conf->rdev->bdev;
=20
 	generic_make_request(bio);
+	return true;
 }
=20
 static void faulty_status(struct seq_file *seq, struct mddev *mddev)
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index df6f2c98eca7..5f1eb9189542 100644
=2D-- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -245,7 +245,7 @@ static void linear_free(struct mddev *mddev, void *priv)
 	kfree(conf);
 }
=20
=2Dstatic void linear_make_request(struct mddev *mddev, struct bio *bio)
+static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 {
 	char b[BDEVNAME_SIZE];
 	struct dev_info *tmp_dev;
@@ -254,7 +254,7 @@ static void linear_make_request(struct mddev *mddev, st=
ruct bio *bio)
=20
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
 		md_flush_request(mddev, bio);
=2D		return;
+		return true;
 	}
=20
 	tmp_dev =3D which_dev(mddev, bio_sector);
@@ -292,7 +292,7 @@ static void linear_make_request(struct mddev *mddev, st=
ruct bio *bio)
 		mddev_check_write_zeroes(mddev, bio);
 		generic_make_request(bio);
 	}
=2D	return;
+	return true;
=20
 out_of_bounds:
 	pr_err("md/linear:%s: make_request: Sector %llu out of bounds on dev %s: =
%llu sectors, offset %llu\n",
@@ -302,6 +302,7 @@ static void linear_make_request(struct mddev *mddev, st=
ruct bio *bio)
 	       (unsigned long long)tmp_dev->rdev->sectors,
 	       (unsigned long long)start_sector);
 	bio_io_error(bio);
+	return true;
 }
=20
 static void linear_status (struct seq_file *seq, struct mddev *mddev)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 23f4adf3a8cc..da59051545a2 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -277,7 +277,7 @@ static blk_qc_t md_make_request(struct request_queue *q=
, struct bio *bio)
 		bio_endio(bio);
 		return BLK_QC_T_NONE;
 	}
=2D	smp_rmb(); /* Ensure implications of  'active' are visible */
+check_suspended:
 	rcu_read_lock();
 	if (mddev->suspended) {
 		DEFINE_WAIT(__wait);
@@ -302,7 +302,11 @@ static blk_qc_t md_make_request(struct request_queue *=
q, struct bio *bio)
 	sectors =3D bio_sectors(bio);
 	/* bio could be mergeable after passing to underlayer */
 	bio->bi_opf &=3D ~REQ_NOMERGE;
=2D	mddev->pers->make_request(mddev, bio);
+	if (!mddev->pers->make_request(mddev, bio)) {
+		atomic_dec(&mddev->active_io);
+		wake_up(&mddev->sb_wait);
+		goto check_suspended;
+	}
=20
 	cpu =3D part_stat_lock();
 	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
@@ -327,6 +331,7 @@ void mddev_suspend(struct mddev *mddev)
 	if (mddev->suspended++)
 		return;
 	synchronize_rcu();
+	wake_up(&mddev->sb_wait);
 	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) =3D=3D 0);
 	mddev->pers->quiesce(mddev, 1);
=20
@@ -7950,12 +7955,14 @@ EXPORT_SYMBOL(md_done_sync);
  * If we need to update some array metadata (e.g. 'active' flag
  * in superblock) before writing, schedule a superblock update
  * and wait for it to complete.
+ * A return value of 'false' means that the write wasn't recorded
+ * and cannot proceed as the array is being suspend.
  */
=2Dvoid md_write_start(struct mddev *mddev, struct bio *bi)
+bool md_write_start(struct mddev *mddev, struct bio *bi)
 {
 	int did_change =3D 0;
 	if (bio_data_dir(bi) !=3D WRITE)
=2D		return;
+		return true;
=20
 	BUG_ON(mddev->ro =3D=3D 1);
 	if (mddev->ro =3D=3D 2) {
@@ -7987,9 +7994,13 @@ void md_write_start(struct mddev *mddev, struct bio =
*bi)
 	if (did_change)
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	wait_event(mddev->sb_wait,
=2D		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
+		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) && !mddev->suspende=
d);
+	if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
+		percpu_ref_put(&mddev->writes_pending);
+		return false;
+	}
+	return true;
 }
=2DEXPORT_SYMBOL(md_write_start);
=20
 /* md_write_inc can only be called when md_write_start() has
  * already been called at least once of the current request.
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 0fa1de42c42b..63d342d560b8 100644
=2D-- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -510,7 +510,7 @@ struct md_personality
 	int level;
 	struct list_head list;
 	struct module *owner;
=2D	void (*make_request)(struct mddev *mddev, struct bio *bio);
+	bool (*make_request)(struct mddev *mddev, struct bio *bio);
 	int (*run)(struct mddev *mddev);
 	void (*free)(struct mddev *mddev, void *priv);
 	void (*status)(struct seq_file *seq, struct mddev *mddev);
@@ -649,7 +649,7 @@ extern void md_wakeup_thread(struct md_thread *thread);
 extern void md_check_recovery(struct mddev *mddev);
 extern void md_reap_sync_thread(struct mddev *mddev);
 extern int mddev_init_writes_pending(struct mddev *mddev);
=2Dextern void md_write_start(struct mddev *mddev, struct bio *bi);
+extern bool md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
 extern void md_write_end(struct mddev *mddev);
 extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index e95d521d93e9..c8d985ba008d 100644
=2D-- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -106,7 +106,7 @@ static void multipath_end_request(struct bio *bio)
 	rdev_dec_pending(rdev, conf->mddev);
 }
=20
=2Dstatic void multipath_make_request(struct mddev *mddev, struct bio * bio)
+static bool multipath_make_request(struct mddev *mddev, struct bio * bio)
 {
 	struct mpconf *conf =3D mddev->private;
 	struct multipath_bh * mp_bh;
@@ -114,7 +114,7 @@ static void multipath_make_request(struct mddev *mddev,=
 struct bio * bio)
=20
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
 		md_flush_request(mddev, bio);
=2D		return;
+		return true;
 	}
=20
 	mp_bh =3D mempool_alloc(conf->pool, GFP_NOIO);
@@ -126,7 +126,7 @@ static void multipath_make_request(struct mddev *mddev,=
 struct bio * bio)
 	if (mp_bh->path < 0) {
 		bio_io_error(bio);
 		mempool_free(mp_bh, conf->pool);
=2D		return;
+		return true;
 	}
 	multipath =3D conf->multipaths + mp_bh->path;
=20
@@ -141,7 +141,7 @@ static void multipath_make_request(struct mddev *mddev,=
 struct bio * bio)
 	mddev_check_writesame(mddev, &mp_bh->bio);
 	mddev_check_write_zeroes(mddev, &mp_bh->bio);
 	generic_make_request(&mp_bh->bio);
=2D	return;
+	return true;
 }
=20
 static void multipath_status(struct seq_file *seq, struct mddev *mddev)
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d6c0bc76e837..94d9ae9b0fd0 100644
=2D-- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -548,7 +548,7 @@ static void raid0_handle_discard(struct mddev *mddev, s=
truct bio *bio)
 	bio_endio(bio);
 }
=20
=2Dstatic void raid0_make_request(struct mddev *mddev, struct bio *bio)
+static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct strip_zone *zone;
 	struct md_rdev *tmp_dev;
@@ -559,12 +559,12 @@ static void raid0_make_request(struct mddev *mddev, s=
truct bio *bio)
=20
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
 		md_flush_request(mddev, bio);
=2D		return;
+		return true;
 	}
=20
 	if (unlikely((bio_op(bio) =3D=3D REQ_OP_DISCARD))) {
 		raid0_handle_discard(mddev, bio);
=2D		return;
+		return true;
 	}
=20
 	bio_sector =3D bio->bi_iter.bi_sector;
@@ -599,6 +599,7 @@ static void raid0_make_request(struct mddev *mddev, str=
uct bio *bio)
 	mddev_check_writesame(mddev, bio);
 	mddev_check_write_zeroes(mddev, bio);
 	generic_make_request(bio);
+	return true;
 }
=20
 static void raid0_status(struct seq_file *seq, struct mddev *mddev)
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e1a7e3d4c5e4..c71739b87ab7 100644
=2D-- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1321,7 +1321,6 @@ static void raid1_write_request(struct mddev *mddev, =
struct bio *bio,
 	 * Continue immediately if no resync is active currently.
 	 */
=20
=2D	md_write_start(mddev, bio); /* wait on superblock update early */
=20
 	if ((bio_end_sector(bio) > mddev->suspend_lo &&
 	    bio->bi_iter.bi_sector < mddev->suspend_hi) ||
@@ -1550,13 +1549,13 @@ static void raid1_write_request(struct mddev *mddev=
, struct bio *bio,
 	wake_up(&conf->wait_barrier);
 }
=20
=2Dstatic void raid1_make_request(struct mddev *mddev, struct bio *bio)
+static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
 {
 	sector_t sectors;
=20
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
 		md_flush_request(mddev, bio);
=2D		return;
+		return true;
 	}
=20
 	/*
@@ -1571,8 +1570,12 @@ static void raid1_make_request(struct mddev *mddev, =
struct bio *bio)
=20
 	if (bio_data_dir(bio) =3D=3D READ)
 		raid1_read_request(mddev, bio, sectors, NULL);
=2D	else
+	else {
+		if (!md_write_start(mddev,bio))
+			return false;
 		raid1_write_request(mddev, bio, sectors);
+	}
+	return true;
 }
=20
 static void raid1_status(struct seq_file *seq, struct mddev *mddev)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 797ed60abd5e..52acffa7a06a 100644
=2D-- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1303,8 +1303,6 @@ static void raid10_write_request(struct mddev *mddev,=
 struct bio *bio,
 	sector_t sectors;
 	int max_sectors;
=20
=2D	md_write_start(mddev, bio);
=2D
 	/*
 	 * Register the new request and wait if the reconstruction
 	 * thread has put up a bar for new requests.
@@ -1525,7 +1523,7 @@ static void __make_request(struct mddev *mddev, struc=
t bio *bio, int sectors)
 		raid10_write_request(mddev, bio, r10_bio);
 }
=20
=2Dstatic void raid10_make_request(struct mddev *mddev, struct bio *bio)
+static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct r10conf *conf =3D mddev->private;
 	sector_t chunk_mask =3D (conf->geo.chunk_mask & conf->prev.chunk_mask);
@@ -1534,9 +1532,12 @@ static void raid10_make_request(struct mddev *mddev,=
 struct bio *bio)
=20
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
 		md_flush_request(mddev, bio);
=2D		return;
+		return true;
 	}
=20
+	if (!md_write_start(mddev, bio))
+		return false;
+
 	/*
 	 * If this request crosses a chunk boundary, we need to split
 	 * it.
@@ -1553,6 +1554,7 @@ static void raid10_make_request(struct mddev *mddev, =
struct bio *bio)
=20
 	/* In case raid10d snuck in to freeze_array */
 	wake_up(&conf->wait_barrier);
+	return true;
 }
=20
 static void raid10_status(struct seq_file *seq, struct mddev *mddev)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 861fc9a8d1be..ad1a644a17bc 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5469,7 +5469,6 @@ static void make_discard_request(struct mddev *mddev,=
 struct bio *bi)
 	last_sector =3D bi->bi_iter.bi_sector + (bi->bi_iter.bi_size>>9);
=20
 	bi->bi_next =3D NULL;
=2D	md_write_start(mddev, bi);
=20
 	stripe_sectors =3D conf->chunk_sectors *
 		(conf->raid_disks - conf->max_degraded);
@@ -5539,11 +5538,10 @@ static void make_discard_request(struct mddev *mdde=
v, struct bio *bi)
 		release_stripe_plug(mddev, sh);
 	}
=20
=2D	md_write_end(mddev);
 	bio_endio(bi);
 }
=20
=2Dstatic void raid5_make_request(struct mddev *mddev, struct bio * bi)
+static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 {
 	struct r5conf *conf =3D mddev->private;
 	int dd_idx;
@@ -5559,10 +5557,10 @@ static void raid5_make_request(struct mddev *mddev,=
 struct bio * bi)
 		int ret =3D r5l_handle_flush_request(conf->log, bi);
=20
 		if (ret =3D=3D 0)
=2D			return;
+			return true;
 		if (ret =3D=3D -ENODEV) {
 			md_flush_request(mddev, bi);
=2D			return;
+			return true;
 		}
 		/* ret =3D=3D -EAGAIN, fallback */
 		/*
@@ -5572,6 +5570,8 @@ static void raid5_make_request(struct mddev *mddev, s=
truct bio * bi)
 		do_flush =3D bi->bi_opf & REQ_PREFLUSH;
 	}
=20
+	if (!md_write_start(mddev, bi))
+		return false;
 	/*
 	 * If array is degraded, better not do chunk aligned read because
 	 * later we might have to read it again in order to reconstruct
@@ -5581,18 +5581,18 @@ static void raid5_make_request(struct mddev *mddev,=
 struct bio * bi)
 	    mddev->reshape_position =3D=3D MaxSector) {
 		bi =3D chunk_aligned_read(mddev, bi);
 		if (!bi)
=2D			return;
+			return true;
 	}
=20
 	if (unlikely(bio_op(bi) =3D=3D REQ_OP_DISCARD)) {
 		make_discard_request(mddev, bi);
=2D		return;
+		md_write_end(mddev);
+		return true;
 	}
=20
 	logical_sector =3D bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector =3D bio_end_sector(bi);
 	bi->bi_next =3D NULL;
=2D	md_write_start(mddev, bi);
=20
 	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 	for (;logical_sector < last_sector; logical_sector +=3D STRIPE_SECTORS) {
@@ -5730,6 +5730,7 @@ static void raid5_make_request(struct mddev *mddev, s=
truct bio * bi)
 	if (rw =3D=3D WRITE)
 		md_write_end(mddev);
 	bio_endio(bi);
+	return true;
 }
=20
 static sector_t raid5_size(struct mddev *mddev, sector_t sectors, int raid=
_disks);
=2D-=20
2.12.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlk0/wUACgkQOeye3VZi
gbnEdw//d9NZrItynlD5aK3BKslcjMC8IyJLbGHu235zNDMjkPF8m3+4JQ5BPLH5
gVzoWuygfxrnmNlODpWCFwVMq+lDdnKKN/pnj3ZNhLvejibt5zll+eIIsYruvYy1
mIwT760W0yLUZSlY3hAAG6qxm0xKTYAE6Fm0da/95jccv8ZDeWzbL3/fAX9OYU2D
9IMhei4A0lKYNxKPCGcU8xCFt5M1fXxS8KHevTROCVQmZUm1Y19oTZOg6l0B7iRi
FYHAk15TF1jrB7LpFaYi/cQnLCtykxOYfTpMkg9R8TDcsngrFe4hu5FyXJcC1gnl
b0EDSVmMrX1SfatmQF/97+7ZbeGok564rCtNXuOlnZMTQoOYXy/2OiF1FbuVLMR5
XnPOKDQQZS8qDbNl0B7OLBr3ZErrsPhxnp45faKlGtyfZKFJWj9n1P38e79E5i9m
ISP7Tj5bB8SVWNv5kk9gX1yYX/nB900TuPkXcvf7C0yp21jTd5F8nlz3ygmZc1mi
NmVQrq75OmkO/0hCP6rjUfqNmptjZBduvIviaGWarVpdj5mGpAhaaYQq2tCqqbaR
J2/W0kP9DXqpHrdyU62CHu1ajtVM53TF/PQFGIqQ5nsbn2koeeF7NzVHhvM4c9eD
nLCOkcEYfRNJvNHrSdzF4JbeRuxryCE9n0RL55FxO5+8eqp64+Y=
=fiUv
-----END PGP SIGNATURE-----
--=-=-=--
