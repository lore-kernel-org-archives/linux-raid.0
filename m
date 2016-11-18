From: NeilBrown <neilb@suse.com>
Subject: [PATCH v2] md: add block tracing for bio_remapping
Date: Fri, 18 Nov 2016 13:22:04 +1100
Message-ID: <87shqpfrxv.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


The block tracing infrastructure (accessed with blktrace/blkparse)
supports the tracing of mapping bios from one device to another.
This is currently used when a bio in a partition is mapped to the
whole device, when bios are mapped by dm, and for mapping in md/raid5.
Other md personalities do not include this tracing yet, so add it.

When a read-error is detected we redirect the request to a different device.
This could justifiably be seen as a new mapping for the originial bio,
or a secondary mapping for the bio that errors.  This patch uses
the second option.

When md is used under dm-raid, the mappings are not traced as we do
not have access to the block device number of the parent.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--

This is the revised version based on discussions.
Now uses correct sector for linear and raid0, and code for raid1/raid10
rearranged a bit.

 drivers/md/linear.c | 18 ++++++++++++------
 drivers/md/raid0.c  | 13 ++++++++++---
 drivers/md/raid1.c  | 26 ++++++++++++++++++++++++--
 drivers/md/raid10.c | 29 +++++++++++++++++++++++++++--
 4 files changed, 73 insertions(+), 13 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 9c7d4f5483ea..5975c9915684 100644
=2D-- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -21,6 +21,7 @@
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <trace/events/block.h>
 #include "md.h"
 #include "linear.h"
=20
@@ -227,22 +228,22 @@ static void linear_make_request(struct mddev *mddev, =
struct bio *bio)
 	}
=20
 	do {
=2D		tmp_dev =3D which_dev(mddev, bio->bi_iter.bi_sector);
+		sector_t bio_sector =3D bio->bi_iter.bi_sector;
+		tmp_dev =3D which_dev(mddev, bio_sector);
 		start_sector =3D tmp_dev->end_sector - tmp_dev->rdev->sectors;
 		end_sector =3D tmp_dev->end_sector;
 		data_offset =3D tmp_dev->rdev->data_offset;
 		bio->bi_bdev =3D tmp_dev->rdev->bdev;
=20
=2D		if (unlikely(bio->bi_iter.bi_sector >=3D end_sector ||
=2D			     bio->bi_iter.bi_sector < start_sector))
+		if (unlikely(bio_sector >=3D end_sector ||
+			     bio_sector < start_sector))
 			goto out_of_bounds;
=20
 		if (unlikely(bio_end_sector(bio) > end_sector)) {
 			/* This bio crosses a device boundary, so we have to
 			 * split it.
 			 */
=2D			split =3D bio_split(bio, end_sector -
=2D					  bio->bi_iter.bi_sector,
+			split =3D bio_split(bio, end_sector - bio_sector,
 					  GFP_NOIO, fs_bio_set);
 			bio_chain(split, bio);
 		} else {
@@ -256,8 +257,13 @@ static void linear_make_request(struct mddev *mddev, s=
truct bio *bio)
 			 !blk_queue_discard(bdev_get_queue(split->bi_bdev)))) {
 			/* Just ignore it */
 			bio_endio(split);
=2D		} else
+		} else {
+			if (mddev->gendisk)
+				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
+						      split, disk_devt(mddev->gendisk),
+						      bio_sector);
 			generic_make_request(split);
+		}
 	} while (split !=3D bio);
 	return;
=20
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index b3ba77a3c3bc..e628f187e5ad 100644
=2D-- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -21,6 +21,7 @@
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <trace/events/block.h>
 #include "md.h"
 #include "raid0.h"
 #include "raid5.h"
@@ -463,7 +464,8 @@ static void raid0_make_request(struct mddev *mddev, str=
uct bio *bio)
 	}
=20
 	do {
=2D		sector_t sector =3D bio->bi_iter.bi_sector;
+		sector_t bio_sector =3D bio->bi_iter.bi_sector;
+		sector_t sector =3D bio_sector;
 		unsigned chunk_sects =3D mddev->chunk_sectors;
=20
 		unsigned sectors =3D chunk_sects -
@@ -472,7 +474,7 @@ static void raid0_make_request(struct mddev *mddev, str=
uct bio *bio)
 			 : sector_div(sector, chunk_sects));
=20
 		/* Restore due to sector_div */
=2D		sector =3D bio->bi_iter.bi_sector;
+		sector =3D bio_sector;
=20
 		if (sectors < bio_sectors(bio)) {
 			split =3D bio_split(bio, sectors, GFP_NOIO, fs_bio_set);
@@ -491,8 +493,13 @@ static void raid0_make_request(struct mddev *mddev, st=
ruct bio *bio)
 			 !blk_queue_discard(bdev_get_queue(split->bi_bdev)))) {
 			/* Just ignore it */
 			bio_endio(split);
=2D		} else
+		} else {
+			if (mddev->gendisk)
+				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
+						      split, disk_devt(mddev->gendisk),
+						      bio_sector);
 			generic_make_request(split);
+		}
 	} while (split !=3D bio);
 }
=20
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9ac61cd85e5c..2dc1934925ec 100644
=2D-- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -37,6 +37,7 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/ratelimit.h>
+#include <trace/events/block.h>
 #include "md.h"
 #include "raid1.h"
 #include "bitmap.h"
@@ -1162,6 +1163,11 @@ static void raid1_make_request(struct mddev *mddev, =
struct bio * bio)
 		bio_set_op_attrs(read_bio, op, do_sync);
 		read_bio->bi_private =3D r1_bio;
=20
+		if (mddev->gendisk)
+			trace_block_bio_remap(bdev_get_queue(read_bio->bi_bdev),
+					      read_bio, disk_devt(mddev->gendisk),
+					      r1_bio->sector);
+
 		if (max_sectors < r1_bio->sectors) {
 			/* could not read all from this device, so we will
 			 * need another r1_bio.
@@ -1367,13 +1373,20 @@ static void raid1_make_request(struct mddev *mddev,=
 struct bio * bio)
=20
 		mbio->bi_iter.bi_sector	=3D (r1_bio->sector +
 				   conf->mirrors[i].rdev->data_offset);
=2D		mbio->bi_bdev =3D (void*)conf->mirrors[i].rdev;
+		mbio->bi_bdev =3D conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	=3D raid1_end_write_request;
 		bio_set_op_attrs(mbio, op, do_flush_fua | do_sync);
 		mbio->bi_private =3D r1_bio;
=20
 		atomic_inc(&r1_bio->remaining);
=20
+		if (mddev->gendisk)
+			trace_block_bio_remap(bdev_get_queue(mbio->bi_bdev),
+					      mbio, disk_devt(mddev->gendisk),
+					      r1_bio->sector);
+		/* flush_pending_writes() needs access to the rdev so...*/
+		mbio->bi_bdev =3D (void*)conf->mirrors[i].rdev;
+
 		cb =3D blk_check_plugged(raid1_unplug, mddev, sizeof(*plug));
 		if (cb)
 			plug =3D container_of(cb, struct raid1_plug_cb, cb);
@@ -2290,6 +2303,8 @@ static void handle_read_error(struct r1conf *conf, st=
ruct r1bio *r1_bio)
 	struct bio *bio;
 	char b[BDEVNAME_SIZE];
 	struct md_rdev *rdev;
+	dev_t bio_dev;
+	sector_t bio_sector;
=20
 	clear_bit(R1BIO_ReadError, &r1_bio->state);
 	/* we got a read error. Maybe the drive is bad.  Maybe just
@@ -2303,6 +2318,8 @@ static void handle_read_error(struct r1conf *conf, st=
ruct r1bio *r1_bio)
=20
 	bio =3D r1_bio->bios[r1_bio->read_disk];
 	bdevname(bio->bi_bdev, b);
+	bio_dev =3D bio->bi_bdev->bd_dev;
+	bio_sector =3D conf->mirrors[r1_bio->read_disk].rdev->data_offset + r1_bi=
o->sector;
 	bio_put(bio);
 	r1_bio->bios[r1_bio->read_disk] =3D NULL;
=20
@@ -2353,6 +2370,8 @@ static void handle_read_error(struct r1conf *conf, st=
ruct r1bio *r1_bio)
 			else
 				mbio->bi_phys_segments++;
 			spin_unlock_irq(&conf->device_lock);
+			trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
+					      bio, bio_dev, bio_sector);
 			generic_make_request(bio);
 			bio =3D NULL;
=20
@@ -2367,8 +2386,11 @@ static void handle_read_error(struct r1conf *conf, s=
truct r1bio *r1_bio)
 				sectors_handled;
=20
 			goto read_more;
=2D		} else
+		} else {
+			trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
+					      bio, bio_dev, bio_sector);
 			generic_make_request(bio);
+		}
 	}
 }
=20
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5290be3d5c26..c63041ec9415 100644
=2D-- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -25,6 +25,7 @@
 #include <linux/seq_file.h>
 #include <linux/ratelimit.h>
 #include <linux/kthread.h>
+#include <trace/events/block.h>
 #include "md.h"
 #include "raid10.h"
 #include "raid0.h"
@@ -1165,6 +1166,10 @@ static void __make_request(struct mddev *mddev, stru=
ct bio *bio)
 		bio_set_op_attrs(read_bio, op, do_sync);
 		read_bio->bi_private =3D r10_bio;
=20
+		if (mddev->gendisk)
+			trace_block_bio_remap(bdev_get_queue(read_bio->bi_bdev),
+					      read_bio, disk_devt(mddev->gendisk),
+					      r10_bio->sector);
 		if (max_sectors < r10_bio->sectors) {
 			/* Could not read all from this device, so we will
 			 * need another r10_bio.
@@ -1367,11 +1372,17 @@ static void __make_request(struct mddev *mddev, str=
uct bio *bio)
 			mbio->bi_iter.bi_sector	=3D (r10_bio->devs[i].addr+
 					   choose_data_offset(r10_bio,
 							      rdev));
=2D			mbio->bi_bdev =3D (void*)rdev;
+			mbio->bi_bdev =3D rdev->bdev;
 			mbio->bi_end_io	=3D raid10_end_write_request;
 			bio_set_op_attrs(mbio, op, do_sync | do_fua);
 			mbio->bi_private =3D r10_bio;
=20
+			if (conf->mddev->gendisk)
+				trace_block_bio_remap(bdev_get_queue(mbio->bi_bdev),
+						      mbio, disk_devt(conf->mddev->gendisk),
+						      r10_bio->sector);
+			mbio->bi_bdev =3D (void*)rdev;
+
 			atomic_inc(&r10_bio->remaining);
=20
 			cb =3D blk_check_plugged(raid10_unplug, mddev,
@@ -1409,11 +1420,17 @@ static void __make_request(struct mddev *mddev, str=
uct bio *bio)
 			mbio->bi_iter.bi_sector	=3D (r10_bio->devs[i].addr +
 					   choose_data_offset(
 						   r10_bio, rdev));
=2D			mbio->bi_bdev =3D (void*)rdev;
+			mbio->bi_bdev =3D rdev->bdev;
 			mbio->bi_end_io	=3D raid10_end_write_request;
 			bio_set_op_attrs(mbio, op, do_sync | do_fua);
 			mbio->bi_private =3D r10_bio;
=20
+			if (conf->mddev->gendisk)
+				trace_block_bio_remap(bdev_get_queue(mbio->bi_bdev),
+						      mbio, disk_devt(conf->mddev->gendisk),
+						      r10_bio->sector);
+			mbio->bi_bdev =3D (void*)rdev;
+
 			atomic_inc(&r10_bio->remaining);
 			spin_lock_irqsave(&conf->device_lock, flags);
 			bio_list_add(&conf->pending_bio_list, mbio);
@@ -2496,6 +2513,8 @@ static void handle_read_error(struct mddev *mddev, st=
ruct r10bio *r10_bio)
 	char b[BDEVNAME_SIZE];
 	unsigned long do_sync;
 	int max_sectors;
+	dev_t bio_dev;
+	sector_t bio_last_sector;
=20
 	/* we got a read error. Maybe the drive is bad.  Maybe just
 	 * the block and we can fix it.
@@ -2507,6 +2526,8 @@ static void handle_read_error(struct mddev *mddev, st=
ruct r10bio *r10_bio)
 	 */
 	bio =3D r10_bio->devs[slot].bio;
 	bdevname(bio->bi_bdev, b);
+	bio_dev =3D bio->bi_bdev->bd_dev;
+	bio_last_sector =3D r10_bio->devs[slot].addr + rdev->data_offset + r10_bi=
o->sectors;
 	bio_put(bio);
 	r10_bio->devs[slot].bio =3D NULL;
=20
@@ -2546,6 +2567,10 @@ static void handle_read_error(struct mddev *mddev, s=
truct r10bio *r10_bio)
 	bio_set_op_attrs(bio, REQ_OP_READ, do_sync);
 	bio->bi_private =3D r10_bio;
 	bio->bi_end_io =3D raid10_end_read_request;
+	trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
+			      bio, bio_dev,
+			      bio_last_sector - r10_bio->sectors);
+
 	if (max_sectors < r10_bio->sectors) {
 		/* Drat - have to split this up more */
 		struct bio *mbio =3D r10_bio->master_bio;
=2D-=20
2.10.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLmXMAAoJEDnsnt1WYoG5OLAP/3Odm/knj6kWa2mK2oXTuW14
VP7Zz7dIrXkXGYSc7O7gvebzfc/3AafKDtW6N7IdrCNYo5H4R2OuW2PqbECcETsX
nVkSId+BozvGjNyCVO6ex7kA9HtMm/xv50qBKv78HIxR8CKatez5mQ+sAmx+l1lK
vfZgDpJrtN/tBV1BU08vdnbOzgItguuYnwcCk+QjJXPilzRTzKKKnr02GdJIalBj
LlAbuidWvcCE6CJUuckEQ6hmgSvsLgf2JDEhwouhjJR0zE0v1YbSm8yFhYkt9oUl
p8X96ELUXeziQmjhBJIOdiUN5Gk2TopyHLKcpH9iAnWLNdDbZtlkrLQUXw+2DPcY
WrZllSpB/5kCTpqSPYuTCuRoxfFyyZ+nzclGCdko5yoeEUQFjQjCrLE9fWT2VIlT
Ke4VfVRkfrGAhJcKgy89uWh6APiglIAt0m7ipbmja7FdgFYGDKjkAociXziWtrPj
0Al7NjRYgd3cHqHIzaEiYrhfeoFJgOfYuDUmL6b+GpBR7+hJ7Xdvutea5nXEFRUb
ihgwmvpEg9nlB4WOOPJQE/NPsC7nPephMG6kWJ4aAQHrpmAtinIG7Y7fIrD40UVf
vXE3VC/O4H1KNOnvnpx0AaWzayvi7dsdwMrxJVobl9srAMycqLsw6sxgw1RIpH6G
Df7QqxohtAcAvOfbzSar
=Gq1F
-----END PGP SIGNATURE-----
--=-=-=--
