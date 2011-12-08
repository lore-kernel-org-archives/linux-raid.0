From: NeilBrown <neilb@suse.de>
Subject: Re: Raid10 and page cache
Date: Thu, 8 Dec 2011 11:10:09 +1100
Message-ID: <20111208111009.6ca1ca19@notabene.brown>
References: <CAJygYd16PWfKe8fK-b150N46CEwzBUqJn1N6dfsGR4yyTgGbTQ@mail.gmail.com>
	<CAJygYd3ofkHp9huD_Q1xoKVb_Q2LTDAnFHf-n+8xyG7ug3wC_Q@mail.gmail.com>
	<20111207092625.7140c5dc@notabene.brown>
	<CAJygYd3fM+wtnU0HkN7s7o=FPizbPNPET2A21jxWk-BJZgdFbA@mail.gmail.com>
	<20111207120133.70ca294c@notabene.brown>
	<CAJygYd3j5HwGyZ7rTKZj5dr=cXDOpy3jK=6AyOVKJY0PX3bdtA@mail.gmail.com>
	<20111207152853.42594fc9@notabene.brown>
	<CAJygYd0UeJ04KOZJLkjO1KoBf6t0Ko_jyCw=HerCtehgkG5DUQ@mail.gmail.com>
	<20111207161003.0aa181d8@notabene.brown>
	<CAJygYd1WgqMYTzvXKKWR9_=Osqd=BPFud20FHXsDz1ag37uJ=g@mail.gmail.com>
	<CAJygYd2by45xJs-RV_v0S8Hd8B1Dk9DP6B+L6MmX=_Va-5Qsvw@mail.gmail.com>
	<CAJygYd1+cVGeRwZXq_WLZr89Q9GX_yPEDvFBuagSG4D9neyoqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3pkAwem/LLaWu1M74bGdT/A"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJygYd1+cVGeRwZXq_WLZr89Q9GX_yPEDvFBuagSG4D9neyoqQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Yucong Sun (=?UTF-8?B?5Y+26Zuo6aOe?=)" <sunyucong@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3pkAwem/LLaWu1M74bGdT/A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Dec 2011 15:37:30 -0800 Yucong Sun (=E5=8F=B6=E9=9B=A8=E9=A3=9E) =
<sunyucong@gmail.com>
wrote:

> Neil, I can't compile latest MD against 2.6.32,  and that commit can't
> be patched into 2.6.32 directly either, can you help me on this?
>=20

This should do it.

NeilBrown

commit ef54b7cf955dc3b7d33248e8591b1a00b4fa998c
Author: NeilBrown <neilb@suse.de>
Date:   Tue Oct 11 16:50:01 2011 +1100

    md: add proper write-congestion reporting to RAID1 and RAID10.
   =20
    RAID1 and RAID10 handle write requests by queuing them for handling by
    a separate thread.  This is because when a write-intent-bitmap is
    active we might need to update the bitmap first, so it is good to
    queue a lot of writes, then do one big bitmap update for them all.
   =20
    However writeback request devices to appear to be congested after a
    while so it can make some guesstimate of throughput.  The infinite
    queue defeats that (note that RAID5 has already has a finite queue so
    it doesn't suffer from this problem).
   =20
    So impose a limit on the number of pending write requests.  By default
    it is 1024 which seems to be generally suitable.  Make it configurable
    via module option just in case someone finds a regression.
   =20
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e07ce2e..fe7ae3c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -50,6 +50,11 @@
  */
 #define	NR_RAID1_BIOS 256
=20
+/* When there are this many requests queue to be written by
+ * the raid1 thread, we become 'congested' to provide back-pressure
+ * for writeback.
+ */
+static int max_queued_requests =3D 1024;
=20
 static void unplug_slaves(mddev_t *mddev);
=20
@@ -576,7 +581,8 @@ static int raid1_congested(void *data, int bits)
 	conf_t *conf =3D mddev->private;
 	int i, ret =3D 0;
=20
-	if (mddev_congested(mddev, bits))
+	if (mddev_congested(mddev, bits) &&
+	    conf->pending_count >=3D max_queued_requests)
 		return 1;
=20
 	rcu_read_lock();
@@ -613,10 +619,12 @@ static int flush_pending_writes(conf_t *conf)
 		struct bio *bio;
 		bio =3D bio_list_get(&conf->pending_bio_list);
 		blk_remove_plug(conf->mddev->queue);
+		conf->pending_count =3D 0;
 		spin_unlock_irq(&conf->device_lock);
 		/* flush any pending bitmap writes to
 		 * disk before proceeding w/ I/O */
 		bitmap_unplug(conf->mddev->bitmap);
+		wake_up(&conf->wait_barrier);
=20
 		while (bio) { /* submit pending writes */
 			struct bio *next =3D bio->bi_next;
@@ -789,6 +797,7 @@ static int make_request(struct request_queue *q, struct=
 bio * bio)
 	int cpu;
 	bool do_barriers;
 	mdk_rdev_t *blocked_rdev;
+	int cnt =3D 0;
=20
 	/*
 	 * Register the new request and wait if the reconstruction
@@ -864,6 +873,11 @@ static int make_request(struct request_queue *q, struc=
t bio * bio)
 	/*
 	 * WRITE:
 	 */
+	if (conf->pending_count >=3D max_queued_requests) {
+		md_wakeup_thread(mddev->thread);
+		wait_event(conf->wait_barrier,
+			   conf->pending_count < max_queued_requests);
+	}
 	/* first select target devices under spinlock and
 	 * inc refcount on their rdev.  Record them by setting
 	 * bios[x] to bio
@@ -970,6 +984,7 @@ static int make_request(struct request_queue *q, struct=
 bio * bio)
 		atomic_inc(&r1_bio->remaining);
=20
 		bio_list_add(&bl, mbio);
+		cnt++;
 	}
 	kfree(behind_pages); /* the behind pages are attached to the bios now */
=20
@@ -978,6 +993,7 @@ static int make_request(struct request_queue *q, struct=
 bio * bio)
 	spin_lock_irqsave(&conf->device_lock, flags);
 	bio_list_merge(&conf->pending_bio_list, &bl);
 	bio_list_init(&bl);
+	conf->pending_count +=3D cnt;
=20
 	blk_plug_device(mddev->queue);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
@@ -2021,7 +2037,7 @@ static int run(mddev_t *mddev)
=20
 	bio_list_init(&conf->pending_bio_list);
 	bio_list_init(&conf->flushing_bio_list);
-
+	conf->pending_count =3D 0;
=20
 	mddev->degraded =3D 0;
 	for (i =3D 0; i < conf->raid_disks; i++) {
@@ -2317,3 +2333,5 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-3"); /* RAID1 */
 MODULE_ALIAS("md-raid1");
 MODULE_ALIAS("md-level-1");
+
+module_param(max_queued_requests, int, S_IRUGO|S_IWUSR);
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index e87b84d..520288c 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -38,6 +38,7 @@ struct r1_private_data_s {
 	/* queue of writes that have been unplugged */
 	struct bio_list		flushing_bio_list;
=20
+	int			pending_count;
 	/* for use when syncing mirrors: */
=20
 	spinlock_t		resync_lock;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c2cb7b8..4c7d9b5 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -59,6 +59,11 @@ static void unplug_slaves(mddev_t *mddev);
=20
 static void allow_barrier(conf_t *conf);
 static void lower_barrier(conf_t *conf);
+/* When there are this many requests queue to be written by
+ * the raid10 thread, we become 'congested' to provide back-pressure
+ * for writeback.
+ */
+static int max_queued_requests =3D 1024;
=20
 static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
@@ -631,6 +636,10 @@ static int raid10_congested(void *data, int bits)
 	conf_t *conf =3D mddev->private;
 	int i, ret =3D 0;
=20
+	if ((bits & (1 << BDI_async_congested)) &&
+	    conf->pending_count >=3D max_queued_requests)
+		return 1;
+
 	if (mddev_congested(mddev, bits))
 		return 1;
 	rcu_read_lock();
@@ -660,10 +669,12 @@ static int flush_pending_writes(conf_t *conf)
 		struct bio *bio;
 		bio =3D bio_list_get(&conf->pending_bio_list);
 		blk_remove_plug(conf->mddev->queue);
+		conf->pending_count =3D 0;
 		spin_unlock_irq(&conf->device_lock);
 		/* flush any pending bitmap writes to disk
 		 * before proceeding w/ I/O */
 		bitmap_unplug(conf->mddev->bitmap);
+		wake_up(&conf->wait_barrier);
=20
 		while (bio) { /* submit pending writes */
 			struct bio *next =3D bio->bi_next;
@@ -802,6 +813,7 @@ static int make_request(struct request_queue *q, struct=
 bio * bio)
 	struct bio_list bl;
 	unsigned long flags;
 	mdk_rdev_t *blocked_rdev;
+	int cnt =3D 0;
=20
 	if (unlikely(bio_rw_flagged(bio, BIO_RW_BARRIER))) {
 		bio_endio(bio, -EOPNOTSUPP);
@@ -894,6 +906,11 @@ static int make_request(struct request_queue *q, struc=
t bio * bio)
 	/*
 	 * WRITE:
 	 */
+	if (conf->pending_count >=3D max_queued_requests) {
+		md_wakeup_thread(mddev->thread);
+		wait_event(conf->wait_barrier,
+			   conf->pending_count < max_queued_requests);
+	}
 	/* first select target devices under rcu_lock and
 	 * inc refcount on their rdev.  Record them by setting
 	 * bios[x] to bio
@@ -957,6 +974,7 @@ static int make_request(struct request_queue *q, struct=
 bio * bio)
=20
 		atomic_inc(&r10_bio->remaining);
 		bio_list_add(&bl, mbio);
+		cnt++
 	}
=20
 	if (unlikely(!atomic_read(&r10_bio->remaining))) {
@@ -970,6 +988,7 @@ static int make_request(struct request_queue *q, struct=
 bio * bio)
 	spin_lock_irqsave(&conf->device_lock, flags);
 	bio_list_merge(&conf->pending_bio_list, &bl);
 	blk_plug_device(mddev->queue);
+	conf->pending_count +=3D cnt;
 	spin_unlock_irqrestore(&conf->device_lock, flags);
=20
 	/* In case raid10d snuck in to freeze_array */
@@ -2318,3 +2337,5 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-9"); /* RAID10 */
 MODULE_ALIAS("md-raid10");
 MODULE_ALIAS("md-level-10");
+
+module_param(max_queued_requests, int, S_IRUGO|S_IWUSR);
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 59cd1ef..e6e1613 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -39,7 +39,7 @@ struct r10_private_data_s {
 	struct list_head	retry_list;
 	/* queue pending writes and submit them on unplug */
 	struct bio_list		pending_bio_list;
-
+	int			pending_count;
=20
 	spinlock_t		resync_lock;
 	int nr_pending;



--Sig_/3pkAwem/LLaWu1M74bGdT/A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuAAYTnsnt1WYoG5AQL7QRAAjQisK6SW7A6ql2I1Y6zF1Bd+z5VBE1++
lB5B/o7ViIhrkMu5c3jKkCrcYLemko8wGeyL+xsoU91HP2a/q0A5TwvS6R1bWi76
x5hXCjpp7M9t/a+Ao/eoGW4/krBb7c3lu7NJtmjuk5/48v1c+WtisMFcwltfAM0c
N40Ha4gyjofzF+lzrrHaM1Gh1UUvSuZwWqRxWlEvge8Mv87y4Qlthh5QwEpm0Vqi
nRSFYeRDzQA8/BkCEjteEJdP0lBibWmU0U1zMOD7EON7JuAyY68tdaA6XrAqwY02
AVuPadBNlQgOVak/oFftiF5Z7ctmg0UlZjr/4cMA/gy4EMyQMW43sbkMuxUGccUs
90G32ONBZddXk9DMUyDdOwHwRTS+qjF/rupeHBoafD5hvnoM7dKIokmKzkBzYYwE
3nQTyHzY78C2IrkKxIkYNQ6VPB+HHREAuOCPKtx0bUR+ZSHvzl7UcbbKxrlwsYUi
L/NZ/cYaBpSLeQw2xu8iN6ydu1A9CdMv6yIAp25axnxAwfrx3qcMJ7WIilUrjhCt
dHXDHCRi+PCZrCdSsZiPCN1dRYbmuv6QbzcHNUQy0rfZ7TJIeyWliqRRXMJ0hxTR
YlPCikNHEF4MuppiSmfqwZlcwRsm4dlHzgCCwcTl887ZcMVurCLaVQeoj27FAOV0
jdzX+kaFTrY=
=OwPR
-----END PGP SIGNATURE-----

--Sig_/3pkAwem/LLaWu1M74bGdT/A--
