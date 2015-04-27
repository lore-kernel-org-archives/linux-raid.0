From: NeilBrown <neilb@suse.de>
Subject: [PATCH -stable] block: destroy bdi before blockdev is unregistered.
Date: Mon, 27 Apr 2015 14:12:22 +1000
Message-ID: <20150427141222.5dac22f1@notabene.brown>
References: <20150414171537.GH25394@azat>
	<20150423160551.45345f96@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/XutVKSjTgXr4awFLudJ3h88"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150423160551.45345f96@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Azat Khuzhin <a3at.mail@gmail.com>, Christoph Hellwig <hch@lst.de>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/XutVKSjTgXr4awFLudJ3h88
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Because of the peculiar way that md devices are created (automatically
when the device node is opened), a new device can be created and
registered immediately after the
	blk_unregister_region(disk_devt(disk), disk->minors);
call in del_gendisk().

Therefore it is important that all visible artifacts of the previous
device are removed before this call.  In particular, the 'bdi'.

Since:
commit c4db59d31e39ea067c32163ac961e9c80198fd37
Author: Christoph Hellwig <hch@lst.de>
    fs: don't reassign dirty inodes to default_backing_dev_info

moved the
   device_unregister(bdi->dev);
call from bdi_unregister() to bdi_destroy() it has been quite easy to
lose a race and have a new (e.g.) "md127" be created after the
blk_unregister_region() call and before bdi_destroy() is ultimately
called by the final 'put_disk', which must come after del_gendisk().

The new device finds that the bdi name is already registered in sysfs
and complains

> [ 9627.630029] WARNING: CPU: 18 PID: 3330 at fs/sysfs/dir.c:31 sysfs_warn=
_dup+0x5a/0x70()
> [ 9627.630032] sysfs: cannot create duplicate filename '/devices/virtual/=
bdi/9:127'

We can fix this by moving the bdi_destroy() call out of
blk_release_queue() (which can happen very late when a refcount
reaches zero) and into blk_cleanup_queue() - which happens exactly when the=
 md
device driver calls it.

Then it is only necessary for md to call blk_cleanup_queue() before
del_gendisk().  As loop.c devices are also created on demand by
opening the device node, we make the same change there.

Fixes: c4db59d31e39ea067c32163ac961e9c80198fd37
Reported-by: Azat Khuzhin <a3at.mail@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org (v4.0)
Signed-off-by: NeilBrown <neilb@suse.de>

--
Hi Jens,
 if you could check this and forward on to Linus I'd really appreciate it.

Thanks,
NeilBrown


diff --git a/block/blk-core.c b/block/blk-core.c
index fd154b94447a..7871603f0a29 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -552,6 +552,8 @@ void blk_cleanup_queue(struct request_queue *q)
 		q->queue_lock =3D &q->__queue_lock;
 	spin_unlock_irq(lock);
=20
+	bdi_destroy(&q->backing_dev_info);
+
 	/* @q is and will stay empty, shutdown and put */
 	blk_put_queue(q);
 }
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index faaf36ade7eb..2b8fd302f677 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -522,8 +522,6 @@ static void blk_release_queue(struct kobject *kobj)
=20
 	blk_trace_shutdown(q);
=20
-	bdi_destroy(&q->backing_dev_info);
-
 	ida_simple_remove(&blk_queue_ida, q->id);
 	call_rcu(&q->rcu_head, blk_free_queue_rcu);
 }
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index ae3fcb4199e9..d7173cb1ea76 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1620,8 +1620,8 @@ out:
=20
 static void loop_remove(struct loop_device *lo)
 {
-	del_gendisk(lo->lo_disk);
 	blk_cleanup_queue(lo->lo_queue);
+	del_gendisk(lo->lo_disk);
 	blk_mq_free_tag_set(&lo->tag_set);
 	put_disk(lo->lo_disk);
 	kfree(lo);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d4f31e195e26..593a02476c78 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4818,12 +4818,12 @@ static void md_free(struct kobject *ko)
 	if (mddev->sysfs_state)
 		sysfs_put(mddev->sysfs_state);
=20
+	if (mddev->queue)
+		blk_cleanup_queue(mddev->queue);
 	if (mddev->gendisk) {
 		del_gendisk(mddev->gendisk);
 		put_disk(mddev->gendisk);
 	}
-	if (mddev->queue)
-		blk_cleanup_queue(mddev->queue);
=20
 	kfree(mddev);
 }

--Sig_/XutVKSjTgXr4awFLudJ3h88
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVT23Jznsnt1WYoG5AQLoRQ/+LFCkW/P3CIYhl1L3VSkx4usIrdj4jMdl
8Q8Vc+qmN+I/nV4FQVDfguCzNEpOT4GyvVLVv6QEVd+Bj9u1oQe2LDRojZXDDjjy
ZqW/GsHTznsWnKsKICa+O16SYwY7zj6HEIR447c6eOdEhw3WyhTHpXzOcIHNNDTc
Y2rz0/K4B0dbia6inSBKymVfjQ3T0kvzl2om6peZbkfVz3m1K5l271f3WVj3VE+x
mi1nbsdBKnLhAoFObjTWIueFbCvnTZbHIrIj3ospjwEOgPBUUk8go6HT86jyPCq1
XVzPRw4YCbFPkjI85GKw7zH0O+50H9s788Y4dT+qby3p1rjmOIlDvN8AW9f/i5f0
kY79yNjLSic5szxXy628bYT836dgJB8fsDoTazbYOvkEV+BMs+Us900E9Udo9Vd3
qodeVPYu43oUpZPrRWa0/rnaB7ohKF2AQxlftiTTC656cI+2UmpAcd3JWWUmggzS
dYBdmA1WBKpGhmuBjHxo/YZSxKf4bSGVwoUOGPwKLw+UOg/Oc+YYibRkili9yKqo
atCaGQXYBSnWym+6kJJBruFuzgrh768qKp7v3LyPQnAAdVu4J3zFBsA/YAs/xKLJ
AGTok99wptS25qJgUZyjhUR9wcgTdQepl5rrOqOiAttWlqaqzkc6jvcgj5t71Uvq
ldN6O4EDWXw=
=pWt/
-----END PGP SIGNATURE-----

--Sig_/XutVKSjTgXr4awFLudJ3h88--
