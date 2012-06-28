From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 0/3 v3] MD: improve raid1/10 write performance for fast
 storage
Date: Thu, 28 Jun 2012 19:03:52 +1000
Message-ID: <20120628190352.4dc1dd76@notabene.brown>
References: <20120613091143.508417333@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8u6xzNQau56LYqxH8Jw8Gx7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120613091143.508417333@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

--Sig_/8u6xzNQau56LYqxH8Jw8Gx7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Jun 2012 17:11:43 +0800 Shaohua Li <shli@kernel.org> wrote:

> In raid1/10, all write requests are dispatched in a single thread. In fast
> storage, the thread is a bottleneck, because it dispatches request too sl=
ow.
> Also the thread migrates freely, which makes request completion cpu not m=
atch
> with submission cpu even driver/block layer has such capability. This will
> cause bad cache issue. Both these are not a big deal for slow storage.
>=20
> Switching the dispatching to percpu/perthread based dramatically increases
> performance.  The more raid disk number is, the more performance boosts. =
In a
> 4-disk raid10 setup, this can double the throughput.
>=20
> percpu/perthread based dispatch doesn't harm slow storage. This is the wa=
y how
> raw device is accessed, and there is correct block plug set which can hel=
p do
> request merge and reduce lock contention.
>=20
> V2->V3:
> rebase to latest tree and fix cpuhotplug issue
>=20
> V1->V2:
> 1. droped direct dispatch patches. That has better performance imporvemen=
t, but
> is hopelessly made correct.
> 2. Add a MD specific workqueue to do percpu dispatch.


Hi.

I still don't like the per-cpu allocations and the extra work queues.

The following patch demonstrates how I would like to address this issue.  It
should submit requests from the same thread that initially made the request=
 -
at least in most cases.

It leverages the plugging code and pushed everything out on the unplug,
unless that comes from a scheduler call (which should be uncommon).  In that
case it falls back on passing all the requests to the md thread.

Obviously if we proceed with this I'll split this up into neat reviewable
patches.  However before that it would help to know if it really helps as I
think it should.

So would you be able to test it on your SSD hardware and see how it compares
the current code, and to you code?  Thanks.

I have only tested it lightly myself so there could still be bugs, but
hopefully not obvious ones.

A simple "time mkfs" test on very modest hardware show as 25% reduction in
total time (168s -> 127s).  I guess that's a 33% increase in speed?
However sequential writes with 'dd' seem a little slower (14MB/s -> 13.6MB/=
s)

There are some hacks in there that need to be cleaned up, but I think the
general structure looks good.

Thanks,
NeilBrown

diff --git a/block/blk-core.c b/block/blk-core.c
index 3c923a7..17e2b4e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2883,7 +2883,7 @@ static void queue_unplugged(struct request_queue *q, =
unsigned int depth,
=20
 }
=20
-static void flush_plug_callbacks(struct blk_plug *plug)
+static void flush_plug_callbacks(struct blk_plug *plug, bool from_schedule)
 {
 	LIST_HEAD(callbacks);
=20
@@ -2897,7 +2897,7 @@ static void flush_plug_callbacks(struct blk_plug *plu=
g)
 							  struct blk_plug_cb,
 							  list);
 		list_del(&cb->list);
-		cb->callback(cb);
+		cb->callback(cb, from_schedule);
 	}
 }
=20
@@ -2911,7 +2911,7 @@ void blk_flush_plug_list(struct blk_plug *plug, bool =
from_schedule)
=20
 	BUG_ON(plug->magic !=3D PLUG_MAGIC);
=20
-	flush_plug_callbacks(plug);
+	flush_plug_callbacks(plug, from_schedule);
 	if (list_empty(&plug->list))
 		return;
=20
diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 15dbe03..94e7f6b 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1305,7 +1305,7 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t=
 offset, unsigned long sect
 			prepare_to_wait(&bitmap->overflow_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
 			spin_unlock_irq(&bitmap->counts.lock);
-			io_schedule();
+			schedule();
 			finish_wait(&bitmap->overflow_wait, &__wait);
 			continue;
 		}
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c601c4b..bc31165 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -506,12 +506,7 @@ EXPORT_SYMBOL(md_flush_request);
  * personality data where we keep a count of the number of outstanding
  * plugs so other code can see if a plug is active.
  */
-struct md_plug_cb {
-	struct blk_plug_cb cb;
-	struct mddev *mddev;
-};
-
-static void plugger_unplug(struct blk_plug_cb *cb)
+static void plugger_unplug(struct blk_plug_cb *cb, bool from_schedule)
 {
 	struct md_plug_cb *mdcb =3D container_of(cb, struct md_plug_cb, cb);
 	if (atomic_dec_and_test(&mdcb->mddev->plug_cnt))
@@ -522,35 +517,41 @@ static void plugger_unplug(struct blk_plug_cb *cb)
 /* Check that an unplug wakeup will come shortly.
  * If not, wakeup the md thread immediately
  */
-int mddev_check_plugged(struct mddev *mddev)
+struct md_plug_cb *mddev_check_plugged(struct mddev *mddev, size_t size,
+				      void (*callback)(struct blk_plug_cb *,bool))
 {
 	struct blk_plug *plug =3D current->plug;
 	struct md_plug_cb *mdcb;
=20
 	if (!plug)
-		return 0;
+		return NULL;
+
+	if (callback =3D=3D NULL)
+		callback =3D plugger_unplug;
+	if (size =3D=3D 0)
+		size =3D sizeof(*mdcb);
=20
 	list_for_each_entry(mdcb, &plug->cb_list, cb.list) {
-		if (mdcb->cb.callback =3D=3D plugger_unplug &&
+		if (mdcb->cb.callback =3D=3D callback &&
 		    mdcb->mddev =3D=3D mddev) {
 			/* Already on the list, move to top */
 			if (mdcb !=3D list_first_entry(&plug->cb_list,
 						    struct md_plug_cb,
 						    cb.list))
 				list_move(&mdcb->cb.list, &plug->cb_list);
-			return 1;
+			return mdcb;
 		}
 	}
 	/* Not currently on the callback list */
-	mdcb =3D kmalloc(sizeof(*mdcb), GFP_ATOMIC);
+	mdcb =3D kzalloc(size, GFP_ATOMIC);
 	if (!mdcb)
-		return 0;
+		return NULL;
=20
 	mdcb->mddev =3D mddev;
-	mdcb->cb.callback =3D plugger_unplug;
+	mdcb->cb.callback =3D callback;
 	atomic_inc(&mddev->plug_cnt);
 	list_add(&mdcb->cb.list, &plug->cb_list);
-	return 1;
+	return mdcb;
 }
 EXPORT_SYMBOL_GPL(mddev_check_plugged);
=20
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7b4a3c3..c59fd53 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -630,6 +630,13 @@ extern struct bio *bio_clone_mddev(struct bio *bio, gf=
p_t gfp_mask,
 				   struct mddev *mddev);
 extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 				   struct mddev *mddev);
-extern int mddev_check_plugged(struct mddev *mddev);
+struct md_plug_cb {
+	struct blk_plug_cb cb;
+	struct mddev *mddev;
+};
+
+extern struct md_plug_cb *mddev_check_plugged(
+	struct mddev *mddev, size_t size,
+	void (*callback)(struct blk_plug_cb *,bool));
 extern void md_trim_bio(struct bio *bio, int offset, int size);
 #endif /* _MD_MD_H */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 39b2a8a..c8c5d62 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -870,6 +870,47 @@ do_sync_io:
 	pr_debug("%dB behind alloc failed, doing sync I/O\n", bio->bi_size);
 }
=20
+struct raid1_plug_cb {
+	struct md_plug_cb	cb;
+	struct bio_list		pending;
+	int			pending_cnt;
+};
+
+static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
+{
+	struct raid1_plug_cb *plug =3D container_of(cb, struct raid1_plug_cb,
+						  cb.cb);
+	struct mddev *mddev =3D plug->cb.mddev;
+	struct r1conf *conf =3D mddev->private;
+	struct bio *bio;
+
+	spin_lock_irq(&conf->device_lock);
+	if (from_schedule) {
+		bio_list_merge(&conf->pending_bio_list, &plug->pending);
+		conf->pending_count +=3D plug->pending_cnt;
+	}
+	if (atomic_dec_and_test(&mddev->plug_cnt))
+		md_wakeup_thread(mddev->thread);
+	spin_unlock_irq(&conf->device_lock);
+	if (from_schedule) {
+		kfree(plug);
+		return;
+	}
+
+	/* we aren't scheduling, so we can do the write-out directly. */
+	bio =3D bio_list_get(&plug->pending);
+	bitmap_unplug(mddev->bitmap);
+	wake_up(&conf->wait_barrier);
+
+	while (bio) { /* submit pending writes */
+		struct bio *next =3D bio->bi_next;
+		bio->bi_next =3D NULL;
+		generic_make_request(bio);
+		bio =3D next;
+	}
+	kfree(plug);
+}
+
 static void make_request(struct mddev *mddev, struct bio * bio)
 {
 	struct r1conf *conf =3D mddev->private;
@@ -883,7 +924,8 @@ static void make_request(struct mddev *mddev, struct bi=
o * bio)
 	const unsigned long do_sync =3D (bio->bi_rw & REQ_SYNC);
 	const unsigned long do_flush_fua =3D (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
 	struct md_rdev *blocked_rdev;
-	int plugged;
+	struct md_plug_cb *cb;
+	struct raid1_plug_cb *plug =3D NULL;
 	int first_clone;
 	int sectors_handled;
 	int max_sectors;
@@ -1034,7 +1076,6 @@ read_again:
 	 * the bad blocks.  Each set of writes gets it's own r1bio
 	 * with a set of bios attached.
 	 */
-	plugged =3D mddev_check_plugged(mddev);
=20
 	disks =3D conf->raid_disks * 2;
  retry_write:
@@ -1187,9 +1228,20 @@ read_again:
 		mbio->bi_private =3D r1_bio;
=20
 		atomic_inc(&r1_bio->remaining);
+
+		cb =3D mddev_check_plugged(mddev, sizeof(*plug), raid1_unplug);
+		if (cb)
+			plug =3D container_of(cb, struct raid1_plug_cb, cb);
+		else
+			plug =3D NULL;
 		spin_lock_irqsave(&conf->device_lock, flags);
-		bio_list_add(&conf->pending_bio_list, mbio);
-		conf->pending_count++;
+		if (plug) {
+			bio_list_add(&plug->pending, mbio);
+			plug->pending_cnt++;
+		} else {
+			bio_list_add(&conf->pending_bio_list, mbio);
+			conf->pending_count++;
+		}
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 	/* Mustn't call r1_bio_write_done before this next test,
@@ -1214,7 +1266,7 @@ read_again:
 	/* In case raid1d snuck in to freeze_array */
 	wake_up(&conf->wait_barrier);
=20
-	if (do_sync || !bitmap || !plugged)
+	if (do_sync || !bitmap || !plug)
 		md_wakeup_thread(mddev->thread);
 }
=20
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0ee7602..ada2429 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1239,7 +1239,7 @@ read_again:
 	 * of r10_bios is recored in bio->bi_phys_segments just as with
 	 * the read case.
 	 */
-	plugged =3D mddev_check_plugged(mddev);
+	plugged =3D mddev_check_plugged(mddev, 0, NULL);
=20
 	r10_bio->read_slot =3D -1; /* make sure repl_bio gets freed */
 	raid10_find_phys(conf, r10_bio);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 51169ec..5cb037b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3995,7 +3995,7 @@ static void make_request(struct mddev *mddev, struct =
bio * bi)
 	struct stripe_head *sh;
 	const int rw =3D bio_data_dir(bi);
 	int remaining;
-	int plugged;
+	struct md_plug_cb *plugged;
=20
 	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bi);
@@ -4014,7 +4014,7 @@ static void make_request(struct mddev *mddev, struct =
bio * bi)
 	bi->bi_next =3D NULL;
 	bi->bi_phys_segments =3D 1;	/* over-loaded to count active stripes */
=20
-	plugged =3D mddev_check_plugged(mddev);
+	plugged =3D mddev_check_plugged(mddev, 0, NULL);
 	for (;logical_sector < last_sector; logical_sector +=3D STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
 		int previous;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ba43f40..390e660 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -914,7 +914,7 @@ struct blk_plug {
=20
 struct blk_plug_cb {
 	struct list_head list;
-	void (*callback)(struct blk_plug_cb *);
+	void (*callback)(struct blk_plug_cb *, bool);
 };
=20
 extern void blk_start_plug(struct blk_plug *);

--Sig_/8u6xzNQau56LYqxH8Jw8Gx7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+wd+Dnsnt1WYoG5AQIbTg/+MMIaGSp8I6zllKkK9ShrLCbJ+sNoWdbn
WieS8GgOZ++lvs+qTjpNSH1CHzmNznaYUyLftMKQ1AZh2uTXo8/1t4kNVvpbMWse
vwjqZULasO8o2rxOFeFACisuYHHqTMpw2EBCua6DlBfOgt1yHz6Y31SwozYzGRnl
tcc1Veu/Uu4kfXGgnIypkGoHE0wphj6pJCEWOsb/mClpcHT8eIR268QTi5oPtsIx
/3IR9Ya/l+Pg1sbUbSru41gUhmqF+W2X+UopkU0R6IzGYBVM/enhqmrFQw3bvBsq
wjzn1SreLvSgiD2gA9UxT59BFAA88xf+HRQ33rYmghsqoKqnGoxhZeSSHvw7Muhp
hZJcqhuf4mhDo1HbIceRfZE6bo2c0hMtoMoYSOoF+3Wk2yAhmLoej7tF/n08Cuip
WDzOm00Sb1xtZC8MZYbR850mzHYjJsT8tNVuMAqxgj6nojgKxn/h9gHikK0zunLy
Bkil9OyKf6O3gIJutuaGZYFzSs/i/9+Roj5fS/fwqAnn7oe7jfIgVqMAVALAnB1r
5uRGaEEEbzfOCq2zHWimUQjionfAzTfRQe2N+wShiNik2WTls2Km7SKQQeCezP95
K6zgSuBCuJahUm9OiZM0D6i5h+Z3uKxVXHXsUlctAZrWi/HAwNY/msvR/UM0SpDD
BiREB6k8Qd4=
=eOia
-----END PGP SIGNATURE-----

--Sig_/8u6xzNQau56LYqxH8Jw8Gx7--
