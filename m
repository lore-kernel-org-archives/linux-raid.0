From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid5: Flush data when do_md_stop in order to avoid
 stripe_cache leaking.
Date: Tue, 17 Jul 2012 11:04:11 +1000
Message-ID: <20120717110411.661de0bd@notabene.brown>
References: <201207131357572035860@gmail.com>
	<20120716182030.2d560594@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4QjYKCBdpO4nRtVpChZgoNP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120716182030.2d560594@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/4QjYKCBdpO4nRtVpChZgoNP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jul 2012 18:20:30 +1000 NeilBrown <neilb@suse.de> wrote:

> On Fri, 13 Jul 2012 13:58:00 +0800 majianpeng <majianpeng@gmail.com> wrot=
e:
>=20
> > I found some kernel message below:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> > [  432.213819] BUG raid5-md0 (Not tainted): Objects remaining on kmem_c=
ache_close()
> > [  432.213820]
> > -----------------------------------------------------------------------=
------
> > [  432.213820]
> > [  432.213823] INFO: Slab 0xffffea00029cae00 objects=3D24 used=3D1
> > fp=3D0xffff8800a72bb910 flags=3D0x100000000004080
> > [  432.213825] Pid: 6207, comm: mdadm Not tainted 3.5.0-rc6+ #56
> > [  432.213827] Call Trace:
> > [  432.213833]  [<ffffffff8111b4a1>] slab_err+0x71/0x80
> > [  432.213836]  [<ffffffff810e4998>] ? __free_pages+0x18/0x30
> > [  432.213839]  [<ffffffff8111f45a>] ? kmem_cache_destroy+0x16a/0x3a0
> > [  432.213841]  [<ffffffff8111f47d>] kmem_cache_destroy+0x18d/0x3a0
> > [  432.213845]  [<ffffffffa007ef8d>] free_conf+0x2d/0xf0 [raid456]
> > [  432.213848]  [<ffffffffa007f8b1>] stop+0x41/0x60 [raid456]
>=20
> This is certainly something to be concerned about...
>=20
>=20
> >=20
> > By the following steps, it can reappear.
> > 1:create raid5
> > 2:dd if=3D/dev/zero of=3D/dev/md0 bs=3D1M
> > 3:when exec "mdadm -S /dev/md0", press "CTRL+C" in dd-command screen.
>=20
> Thanks - this worked first time.
> Thought the 'bug' I got was different.
>=20
> [  526.720419] BUG: unable to handle kernel paging request at ffff8801363=
fbe30
> [  526.720877] IP: [<ffffffff8183cb34>] raid5_end_write_request+0x1f4/0x2=
f0
>=20
> I think it is the same root cause though.
>=20
> >=20
> > In commit 271f5a9b8f8ae0db95de72779d115c9d0b9d3cc5
> > Author: NeilBrown <neilb@suse.de>
> > Remove invalidate_partition call from do_md_stop
> >=20
> > Because the deadlock, Neil remove the flush data.But in this pathch,Neil
> > only thoungt the filesystem,but not consider the raw block deivces.
>=20
> Please don't try to guess what I am thinking ;-)
>=20
> Raw block device access is in many ways just like filesystem access.
> /dev/md0 provides access to a special filesystem that provides exactly one
> file which is 1-1 mapped to the block device. e.g It uses the same page c=
ache
> as other filesystems.
>=20
> do_md_stop will fail with -EBUSY if any program has the block device open.
> When the last program closes /dev/md0, __blkdev_put will call sync_blockd=
ev
> which will flush out any writes.  So when do_md_stop starts disassembling=
 the
> array there should be no writes.
> But there are.
>=20
> The problem happens if some other program (dd in this case) closes /dev/m=
d0
> between the time that mdadm opens it and the time that mdadm issues the
> STOP_ARRAY ioctl.
> In this case dd isn't the last program with /dev/md0 open, so the
> sync_blockdev in __blkdev_put isn't called.
>=20
> So if mdadm stopped the array by effectively doing
>    echo clear > /sys/block/md0/md/array_state
> (without holding /dev/md0 open) this race could not happen.  Either the
> 'echo' would, or the last close of /dev/md0 would have happened and the b=
lock
> device will have been flushed.
>=20
> So the problem is that the ioctl holds the block device open preventing t=
he
> last flush.  So the fix should be in md_ioctl.
> in md_ioctl we have a pointer to the bdev, so we don't need to try to find
> one with bdget_disk.
>=20
> Unfortunately we need to call sync_blockdev *after* taking ->open_mutex
> otherwise the race still exists, and md_ioctl can't currently take open_m=
utex.
>=20
> We need to fix md_set_readonly too - it has the same problem.
> Maybe I'll pass the bdev in to these two functions and get them to
> call sync_blockdev after taking the lock and checking the count.
>=20
> But it's late today - I'll sort this out tomorrow.
>=20

This is what I have come up with.

Thanks again,
NeilBrown


=46rom 6191e4929a4a240b4eab9ca751715945dd9e3180 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 17 Jul 2012 09:23:29 +1000
Subject: [PATCH] md: avoid crash when stopping md array races with closing
 other open fds.

md will refuse to stop an array if any other fd (or mounted fs) is
using it.
When any fs is unmounted of when the last open fd is closed all
pending IO will be flushed (e.g. sync_blockdev call in __blkdev_put)
so there will be no pending IO to worry about when the array is
stopped.

However in order to send the STOP_ARRAY ioctl to stop the array one
must first get and open fd on the block device.
If some fd is being used to write to the block device and it is closed
after mdadm open the block device, but before mdadm issues the
STOP_ARRAY ioctl, then there will be no last-close on the md device so
__blkdev_put will not call sync_blockdev.

If this happens, then IO can still be in-flight while md tears down
the array and bad things can happen (use-after-free and subsequent
havoc).

So in the case where do_md_stop is being called from an open file
descriptor, call sync_block after taking the mutex to ensure there
will be no new openers.

This is needed when setting a read-write device to read-only too.

Cc: stable@vger.kernel.org
Reported-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 415c10e..7bd9c20 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3921,8 +3921,8 @@ array_state_show(struct mddev *mddev, char *page)
 	return sprintf(page, "%s\n", array_states[st]);
 }
=20
-static int do_md_stop(struct mddev * mddev, int ro, int is_open);
-static int md_set_readonly(struct mddev * mddev, int is_open);
+static int do_md_stop(struct mddev * mddev, int ro, struct block_device *b=
dev);
+static int md_set_readonly(struct mddev * mddev, struct block_device *bdev=
);
 static int do_md_run(struct mddev * mddev);
 static int restart_array(struct mddev *mddev);
=20
@@ -3938,14 +3938,14 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
 		/* stopping an active array */
 		if (atomic_read(&mddev->openers) > 0)
 			return -EBUSY;
-		err =3D do_md_stop(mddev, 0, 0);
+		err =3D do_md_stop(mddev, 0, NULL);
 		break;
 	case inactive:
 		/* stopping an active array */
 		if (mddev->pers) {
 			if (atomic_read(&mddev->openers) > 0)
 				return -EBUSY;
-			err =3D do_md_stop(mddev, 2, 0);
+			err =3D do_md_stop(mddev, 2, NULL);
 		} else
 			err =3D 0; /* already inactive */
 		break;
@@ -3953,7 +3953,7 @@ array_state_store(struct mddev *mddev, const char *bu=
f, size_t len)
 		break; /* not supported yet */
 	case readonly:
 		if (mddev->pers)
-			err =3D md_set_readonly(mddev, 0);
+			err =3D md_set_readonly(mddev, NULL);
 		else {
 			mddev->ro =3D 1;
 			set_disk_ro(mddev->gendisk, 1);
@@ -3963,7 +3963,7 @@ array_state_store(struct mddev *mddev, const char *bu=
f, size_t len)
 	case read_auto:
 		if (mddev->pers) {
 			if (mddev->ro =3D=3D 0)
-				err =3D md_set_readonly(mddev, 0);
+				err =3D md_set_readonly(mddev, NULL);
 			else if (mddev->ro =3D=3D 1)
 				err =3D restart_array(mddev);
 			if (err =3D=3D 0) {
@@ -5346,15 +5346,17 @@ void md_stop(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(md_stop);
=20
-static int md_set_readonly(struct mddev *mddev, int is_open)
+static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 {
 	int err =3D 0;
 	mutex_lock(&mddev->open_mutex);
-	if (atomic_read(&mddev->openers) > is_open) {
+	if (atomic_read(&mddev->openers) > !!bdev) {
 		printk("md: %s still in use.\n",mdname(mddev));
 		err =3D -EBUSY;
 		goto out;
 	}
+	if (bdev)
+		sync_blockdev(bdev);
 	if (mddev->pers) {
 		__md_stop_writes(mddev);
=20
@@ -5376,18 +5378,26 @@ out:
  *   0 - completely stop and dis-assemble array
  *   2 - stop but do not disassemble array
  */
-static int do_md_stop(struct mddev * mddev, int mode, int is_open)
+static int do_md_stop(struct mddev * mddev, int mode,
+		      struct block_device *bdev)
 {
 	struct gendisk *disk =3D mddev->gendisk;
 	struct md_rdev *rdev;
=20
 	mutex_lock(&mddev->open_mutex);
-	if (atomic_read(&mddev->openers) > is_open ||
+	if (atomic_read(&mddev->openers) > !!bdev ||
 	    mddev->sysfs_active) {
 		printk("md: %s still in use.\n",mdname(mddev));
 		mutex_unlock(&mddev->open_mutex);
 		return -EBUSY;
 	}
+	if (bdev)
+		/* It is possible IO was issued on some other
+		 * open file which was closed before we took ->open_mutex.
+		 * As that was not the last close __blkdev_put will not
+		 * have called sync_blockdev, so we must.
+		 */
+		sync_blockdev(bdev);
=20
 	if (mddev->pers) {
 		if (mddev->ro)
@@ -5461,7 +5471,7 @@ static void autorun_array(struct mddev *mddev)
 	err =3D do_md_run(mddev);
 	if (err) {
 		printk(KERN_WARNING "md: do_md_run() returned %d\n", err);
-		do_md_stop(mddev, 0, 0);
+		do_md_stop(mddev, 0, NULL);
 	}
 }
=20
@@ -6476,11 +6486,11 @@ static int md_ioctl(struct block_device *bdev, fmod=
e_t mode,
 			goto done_unlock;
=20
 		case STOP_ARRAY:
-			err =3D do_md_stop(mddev, 0, 1);
+			err =3D do_md_stop(mddev, 0, bdev);
 			goto done_unlock;
=20
 		case STOP_ARRAY_RO:
-			err =3D md_set_readonly(mddev, 1);
+			err =3D md_set_readonly(mddev, bdev);
 			goto done_unlock;
=20
 		case BLKROSET:


--Sig_/4QjYKCBdpO4nRtVpChZgoNP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAS6Cznsnt1WYoG5AQKe6w//ZwN4qSAhW62BVLP7B4hGIVELm0f8Fk56
vd0Hl7PcyUofsnQhUcpn3O+Tk+zNdsmzMruxPJRSXQy/fujx8QkWUfdnoZzdvR23
jZVBL/AhM6ZbYTY9/RDyGfTwHYOLyXiY9TJ2BUCZQP49rfTTWY+zFPrJ/J/sIwI+
chO+NByZR6yO5ztfeaXm2Io7kh/EFlTV7UKB8dEL4CxwOPtigZg1+//O4qwwtMgz
kyRo+1fgUURuI0Ay0829mWPVYSn4nxEmnvTEO+DJ8gU19ludJJIEwoCBgMgz/TEX
A/96g7AufGjWG81RyuspbGsxi0LUKy5r/WDg3VOsXdtlziADlZQZlP3VVg67Ur6c
7001rbEAFYAp3rjIEMn6M87mTc7VixJlFTciBeCZvFBx+GkNKg9Gq+PvcXeuOUA+
r6nXg4JpYXszXhmF+lc8eQLb/1KH61lLXRPOwmfBT6xyvkXtglWkP3Q1sYVCDbHM
WwsraCOWLcic2NnY3Ajk+P6Q6ghULBKxnfKhiwxIG3RtQIrzGqTjoLSFs/U8/x32
2xBGeIjSifb96BExdIwDbLPEMut7YkJnQcuzbnbDnco3YbSFRgnxV/xXMhnVyezI
bJfDtCwQDZr/jQxRJ3Yp+4i2ewsEHrTY92CTzySEuPcHb/hMR9yVp5oRPpRIGCu8
ZUv8UPIwCwo=
=Xs6d
-----END PGP SIGNATURE-----

--Sig_/4QjYKCBdpO4nRtVpChZgoNP--
