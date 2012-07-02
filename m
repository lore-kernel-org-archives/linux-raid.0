From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 08/10 v3] raid5: make_request use batch stripe release
Date: Mon, 2 Jul 2012 12:31:12 +1000
Message-ID: <20120702123112.795e1db3@notabene.brown>
References: <20120625072447.268095276@kernel.org>
	<20120625072702.921605418@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mOzT2oxpqug21dfcYp=J_U="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120625072702.921605418@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/mOzT2oxpqug21dfcYp=J_U=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jun 2012 15:24:55 +0800 Shaohua Li <shli@kernel.org> wrote:

> make_request() does stripe release for every stripe and the stripe usuall=
y has
> count 1, which makes previous release_stripe() optimization not work. In =
my
> test, this release_stripe() becomes the heaviest pleace to take
> conf->device_lock after previous patches applied.
>=20
> Below patch makes stripe release batch. All the stripes will be released =
in
> unplug. The STRIPE_ON_UNPLUG_LIST bit is to protect concurrent access str=
ipe
> lru.
>=20

I've applied this patch, but I'm afraid I butchered it a bit first :-)


> @@ -3984,6 +3985,51 @@ static struct stripe_head *__get_priorit
>  	return sh;
>  }
> =20
> +#define raid5_unplug_list(mdcb) (struct list_head *)(mdcb + 1)

I really don't like this sort of construct.  It is much cleaner (I think) to
add to a structure by embedding it in a larger structure, then using
"container_of" to map from the inner to the outer structure.  So I have
changed that.

> @@ -4114,7 +4161,14 @@ static void make_request(struct mddev *m
>  			if ((bi->bi_rw & REQ_SYNC) &&
>  			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  				atomic_inc(&conf->preread_active_stripes);
> -			release_stripe(sh);
> +			/*
> +			 * We must recheck here. schedule() might be called
> +			 * above which makes unplug invoked already, so the old
> +			 * mdcb is invalid
> +			 */

I agree that this is an important check, but as a 'schedule()' can
theoretically happen at any time that preempt isn't explicitly disabled, we
really need to be even more careful.  So I have changed the md code to
disable preempt, and require the caller to re-enable preempt after it has
used the returned value.

The resulting serious should appear in my for-next shortly.  However for
easier review I'll include two patches below.  The first change
mddev_check_plugged to disable preemption.
The second is a diff against your patch which changes it to use an embedded
structure and container_of.
I haven't actually tested this yet, so there may be further changes.

Thanks,
NeilBrown

=46rom 04b7dd7d0ad4a21622cad7c10821f914a8d9ccd3 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 2 Jul 2012 12:14:49 +1000
Subject: [PATCH] md/plug: disable preempt when reported a plug is present.

As 'schedule' will unplug a queue, a plug added by
mddev_check_plugged is only valid until the next schedule().
So call preempt_disable before installing the plug, and require the
called to call preempt_enable once the value has been used.

Signed-off-by: NeilBrown  <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1369c9d..63ea6d6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -512,6 +512,10 @@ static void plugger_unplug(struct blk_plug_cb *cb)
=20
 /* Check that an unplug wakeup will come shortly.
  * If not, wakeup the md thread immediately
+ * Note that the structure returned is only value until
+ * the next schedule(), so preemption is disabled when it
+ * is not NULL, and must be re-enabled after the value
+ * has been used.
  */
 struct md_plug_cb *mddev_check_plugged(struct mddev *mddev,
 				       md_unplug_func_t unplug, size_t size)
@@ -522,6 +526,7 @@ struct md_plug_cb *mddev_check_plugged(struct mddev *md=
dev,
 	if (!plug)
 		return NULL;
=20
+	preempt_disable();
 	list_for_each_entry(mdcb, &plug->cb_list, cb.list) {
 		if (mdcb->cb.callback =3D=3D plugger_unplug &&
 		    mdcb->mddev =3D=3D mddev) {
@@ -533,6 +538,7 @@ struct md_plug_cb *mddev_check_plugged(struct mddev *md=
dev,
 			return mdcb;
 		}
 	}
+	preempt_enable();
 	/* Not currently on the callback list */
 	if (size < sizeof(*mdcb))
 		size =3D sizeof(*mdcb);
@@ -540,6 +546,7 @@ struct md_plug_cb *mddev_check_plugged(struct mddev *md=
dev,
 	if (!mdcb)
 		return NULL;
=20
+	preempt_disable();
 	mdcb->mddev =3D mddev;
 	mdcb->cb.callback =3D plugger_unplug;
 	atomic_inc(&mddev->plug_cnt);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ebce488..2e19b68 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -883,7 +883,6 @@ static void make_request(struct mddev *mddev, struct bi=
o * bio)
 	const unsigned long do_sync =3D (bio->bi_rw & REQ_SYNC);
 	const unsigned long do_flush_fua =3D (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
 	struct md_rdev *blocked_rdev;
-	int plugged;
 	int first_clone;
 	int sectors_handled;
 	int max_sectors;
@@ -1034,8 +1033,6 @@ read_again:
 	 * the bad blocks.  Each set of writes gets it's own r1bio
 	 * with a set of bios attached.
 	 */
-	plugged =3D !!mddev_check_plugged(mddev, NULL, 0);
-
 	disks =3D conf->raid_disks * 2;
  retry_write:
 	blocked_rdev =3D NULL;
@@ -1214,8 +1211,11 @@ read_again:
 	/* In case raid1d snuck in to freeze_array */
 	wake_up(&conf->wait_barrier);
=20
-	if (do_sync || !bitmap || !plugged)
+	if (do_sync ||
+	    !mddev_check_plugged(mddev, NULL, 0))
 		md_wakeup_thread(mddev->thread);
+	else
+		preempt_enable();
 }
=20
 static void status(struct seq_file *seq, struct mddev *mddev)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 978a996..54f4b33 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1039,7 +1039,6 @@ static void make_request(struct mddev *mddev, struct =
bio * bio)
 	const unsigned long do_fua =3D (bio->bi_rw & REQ_FUA);
 	unsigned long flags;
 	struct md_rdev *blocked_rdev;
-	int plugged;
 	int sectors_handled;
 	int max_sectors;
 	int sectors;
@@ -1239,7 +1238,6 @@ read_again:
 	 * of r10_bios is recored in bio->bi_phys_segments just as with
 	 * the read case.
 	 */
-	plugged =3D !!mddev_check_plugged(mddev, NULL, 0);
=20
 	r10_bio->read_slot =3D -1; /* make sure repl_bio gets freed */
 	raid10_find_phys(conf, r10_bio);
@@ -1449,8 +1447,11 @@ retry_write:
 	/* In case raid10d snuck in to freeze_array */
 	wake_up(&conf->wait_barrier);
=20
-	if (do_sync || !mddev->bitmap || !plugged)
+	if (do_sync ||
+	    !mddev_check_plugged(mddev, NULL, 0))
 		md_wakeup_thread(mddev->thread);
+	else
+		preempt_enable();
 }
=20
 static void status(struct seq_file *seq, struct mddev *mddev)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0a23037..e9e920c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4004,7 +4004,6 @@ static void make_request(struct mddev *mddev, struct =
bio * bi)
 	struct stripe_head *sh;
 	const int rw =3D bio_data_dir(bi);
 	int remaining;
-	int plugged;
=20
 	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bi);
@@ -4023,7 +4022,6 @@ static void make_request(struct mddev *mddev, struct =
bio * bi)
 	bi->bi_next =3D NULL;
 	bi->bi_phys_segments =3D 1;	/* over-loaded to count active stripes */
=20
-	plugged =3D !!mddev_check_plugged(mddev, NULL, 0);
 	for (;logical_sector < last_sector; logical_sector +=3D STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
 		int previous;
@@ -4134,8 +4132,10 @@ static void make_request(struct mddev *mddev, struct=
 bio * bi)
 		}
 		=09
 	}
-	if (!plugged)
+	if (!mddev_check_plugged(mddev, NULL, 0))
 		md_wakeup_thread(mddev->thread);
+	else
+		preempt_enable();
=20
 	spin_lock_irq(&conf->device_lock);
 	remaining =3D raid5_dec_bi_phys_segments(bi);






diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index fc98086..ef3baa4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3996,18 +3996,23 @@ static struct stripe_head *__get_priority_stripe(st=
ruct r5conf *conf)
 	return sh;
 }
=20
-#define raid5_unplug_list(mdcb) (struct list_head *)(mdcb + 1)
+struct raid5_plug_cb {
+	struct md_plug_cb	cb;
+	struct list_head	list;
+};
+
 static void raid5_unplug(struct md_plug_cb *mdcb)
 {
-	struct list_head *list =3D raid5_unplug_list(mdcb);
+	struct raid5_plug_cb *cb =3D container_of(
+		mdcb, struct raid5_plug_cb, cb);
 	struct stripe_head *sh;
 	struct r5conf *conf =3D mdcb->mddev->private;
=20
-	if (list->next =3D=3D NULL || list_empty(list))
+	if (cb->list.next =3D=3D NULL || list_empty(&cb->list))
 		return;
 	spin_lock_irq(&conf->device_lock);
-	while (!list_empty(list)) {
-		sh =3D list_entry(list->next, struct stripe_head, lru);
+	while (!list_empty(&cb->list)) {
+		sh =3D list_first_entry(&cb->list, struct stripe_head, lru);
 		list_del_init(&sh->lru);
 		/*
 		 * avoid race release_stripe_plug() sees STRIPE_ON_UNPLUG_LIST
@@ -4024,20 +4029,20 @@ static void release_stripe_plug(struct mddev *mddev,
 				struct stripe_head *sh)
 {
 	struct md_plug_cb *mdcb =3D mddev_check_plugged(mddev, raid5_unplug,
-						      sizeof(struct list_head));
-	struct list_head *list =3D raid5_unplug_list(mdcb);
+						      sizeof(struct raid5_plug_cb));
+	struct raid5_plug_cb *cb;
 	if (!mdcb) {
 		release_stripe(sh);
 		return;
 	}
=20
-	if (list->next =3D=3D NULL) {
-		INIT_LIST_HEAD(list);
-		mdcb->unplug =3D raid5_unplug;
-	}
+	cb =3D container_of(mdcb, struct raid5_plug_cb, cb);
+
+	if (cb->list.next =3D=3D NULL)
+		INIT_LIST_HEAD(&cb->list);
=20
 	if (!test_and_set_bit(STRIPE_ON_UNPLUG_LIST, &sh->state))
-		list_add_tail(&sh->lru, list);
+		list_add_tail(&sh->lru, &cb->list);
 	else
 		release_stripe(sh);
 	preempt_enable();
@@ -4180,7 +4185,7 @@ static void make_request(struct mddev *mddev, struct =
bio * bi)
 		}
 		=09
 	}
-	if (!mddev_check_plugged(mddev, raid5_unplug, sizeof(struct list_head)))
+	if (!mddev_check_plugged(mddev, raid5_unplug, sizeof(struct raid5_plug_cb=
)))
 		md_wakeup_thread(mddev->thread);
 	else
 		preempt_enable();



--Sig_/mOzT2oxpqug21dfcYp=J_U=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/EH8Dnsnt1WYoG5AQIsMQ/+N4nkQylsltWIdnNaMzNMwEXrYMAY1wKC
7fsSkNeP/NB3WtuLDdGXjMoEu//f1L0mlsPZ/MUC14ahwkfU05oHyXdQR6g43ZiI
SYIxoWXld/mHNvPNZ2bqBE6egacskJtqhZ8F9nXAsFiDPCeoEwSyzHfay2uk+q4c
CTpucIHYuhkWjjcCjYlauhWxqk9kO8Wo3iKuQAq4fsoVypJqrNafQg9N7huwGUYl
wMroj/XFUqFqglZpDlCQBZh29HycHjkszXCmevSiGC1hF/A/rLvZjkj9jWiRJd3M
skgAiAReAtHIhxp03y+MhGFU+YG3LWR2eN0n2GBphCRBOi6bqteH+kNZ5EYeid6k
Yvlbg/wk/qyO+aHu09ErWiFcad/PvT5hMbsxcaF+VKJAli7dfbaYfy/poo66/AnJ
tgb7c6rKV3nzC3kYckfZfbtG5LvGkimUdujHSrtO1oPYsseHwW7O6MJ/GcEsAb60
Mr5Bdo2TbtL24hUqWijulffBQ9ZgStGPuuGFvpba6wIehMGIoDSvHnmMxdx0mgrb
HlfEu6LzcbqlMLjGh1alBZ3wW1avuDaEeo7BY8zhi27bU9P44lpooWPC0aLl/q1Q
kvcjL0T18VSaOiECQXP70cp3vVK7KvUb8IAfH1Zcjsr8nMra+bcA5+QCvhe4qCen
iYZ88W+IQQk=
=WMt0
-----END PGP SIGNATURE-----

--Sig_/mOzT2oxpqug21dfcYp=J_U=--
