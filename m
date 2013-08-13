From: NeilBrown <neilb@suse.de>
Subject: Re: [BUG] md hang at schedule in  md_write_start
Date: Tue, 13 Aug 2013 14:31:15 +1000
Message-ID: <20130813143115.55dd27d1@notabene.brown>
References: <52090E6D.10104@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/l.nWFOtSgSl7b5AHt6b5qRW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52090E6D.10104@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>
Cc: linux-raid@vger.kernel.org, Jack Wang <xjtuwjp@gmail.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

--Sig_/l.nWFOtSgSl7b5AHt6b5qRW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Aug 2013 18:33:49 +0200 Jack Wang <jinpu.wang@profitbricks.com>
wrote:

> Hi Neil,
>=20
>=20
> We've found md hang in our test, it's easy to reproduce with script
> attached.
>=20
> We've tried 3.4 stable kernel and latest mainline, it still exists.
>=20
> Looks like flush bdi_writeback_workfn race with md_stop, no idea how to
> fix it, could you kindly give us suggestions?
>=20
> Best regards,
> Jack

Thanks for the report.  I can see how that deadlock could happen.

Can you please try this patch and confirm that it fixes it.
I'm not really happy with this approach but nothing better occurs to me yet.

NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a57b0fa..c66af69 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5144,7 +5144,7 @@ int md_run(struct mddev *mddev)
 =09
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 =09
-	if (mddev->flags)
+	if (mddev->flags & MD_UPDATE_SB_FLAGS)
 		md_update_sb(mddev, 0);
=20
 	md_new_event(mddev);
@@ -5289,7 +5289,7 @@ static void __md_stop_writes(struct mddev *mddev)
 	md_super_wait(mddev);
=20
 	if (mddev->ro =3D=3D 0 &&
-	    (!mddev->in_sync || mddev->flags)) {
+	    (!mddev->in_sync || (mddev->flags & MD_UPDATE_SB_FLAGS))) {
 		/* mark array as shutdown cleanly */
 		mddev->in_sync =3D 1;
 		md_update_sb(mddev, 1);
@@ -5337,8 +5337,11 @@ static int md_set_readonly(struct mddev *mddev, stru=
ct block_device *bdev)
 		err =3D -EBUSY;
 		goto out;
 	}
-	if (bdev)
+	if (bdev) {
+		set_bit(MD_FINAL_FLUSH, &mddev->flags);
 		sync_blockdev(bdev);
+		clear_bit(MD_FINAL_FLUSH, &mddev->flags);
+	}
 	if (mddev->pers) {
 		__md_stop_writes(mddev);
=20
@@ -5373,13 +5376,16 @@ static int do_md_stop(struct mddev * mddev, int mod=
e,
 		mutex_unlock(&mddev->open_mutex);
 		return -EBUSY;
 	}
-	if (bdev)
+	if (bdev) {
 		/* It is possible IO was issued on some other
 		 * open file which was closed before we took ->open_mutex.
 		 * As that was not the last close __blkdev_put will not
 		 * have called sync_blockdev, so we must.
 		 */
+		set_bit(MD_FINAL_FLUSH, &mddev->flags);
 		sync_blockdev(bdev);
+		clear_bit(MD_FINAL_FLUSH, &mddev->flags);
+	}
=20
 	if (mddev->pers) {
 		if (mddev->ro)
@@ -7814,7 +7820,7 @@ void md_check_recovery(struct mddev *mddev)
 				sysfs_notify_dirent_safe(mddev->sysfs_state);
 		}
=20
-		if (mddev->flags)
+		if (mddev->flags & MD_UPDATE_SB_FLAGS)
 			md_update_sb(mddev, 0);
=20
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
@@ -7904,7 +7910,10 @@ void md_check_recovery(struct mddev *mddev)
 					sysfs_notify_dirent_safe(mddev->sysfs_action);
 		}
 		mddev_unlock(mddev);
-	}
+	} else if (test_bit(MD_FINAL_FLUSH, &mddev->flags) &&
+		   mddev->in_sync =3D=3D 0 &&
+		   (mddev->flags & MD_UPDATE_SB_FLAGS))
+		md_update_sb(mddev, 0);
 }
=20
 void md_reap_sync_thread(struct mddev *mddev)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 77924d3..e1e003a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -209,7 +209,12 @@ struct mddev {
 #define MD_CHANGE_DEVS	0	/* Some device status has changed */
 #define MD_CHANGE_CLEAN 1	/* transition to or from 'clean' */
 #define MD_CHANGE_PENDING 2	/* switch from 'clean' to 'active' in progress=
 */
+#define MD_UPDATE_SB_FLAGS (1 | 2 | 4)	/* If these are set, md_update_sb n=
eeded */
 #define MD_ARRAY_FIRST_USE 3    /* First use of array, needs initializatio=
n */
+#define MD_FINAL_FLUSH	4	/* md_check_recovery is permitted to call
+				 * md_update_sb() to switch to 'active'
+				 * without taking reconfig_mutex
+				 */
=20
 	int				suspended;
 	atomic_t			active_io;

--Sig_/l.nWFOtSgSl7b5AHt6b5qRW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUgm2lDnsnt1WYoG5AQJGcQ//acTD9vipMLPIOHq7E/HjEnS3rEMKkqTR
oNrMvsdBlWS8prKTGAChsKvGn9ituqvSRZP3hPTJqWZSZ70IAxCC/qR7ev/JDWXQ
9riu42+m0gXrFXipVmcSTjZvH1X0xZHrgvWxLmUK8MD2+Mpq5XLfs7FXDChur+QG
ncyG66d9Rx0FrZit2px0ntK9D4z5TVvVXH1CGLEg/KgChgF6shD1XNW5P6dtvrwb
iCCiNL71Hc2Uos4eG4nyl1XxHzOz0UONQlxuMn+ftoZ/NUioJco1GenRjV8bkgRW
9j/gUYTUqvcMFClJN0KEUzJvKcTxPlM9q09ZMnfO/g0hq6xWI0/yJdHE2v04lnQT
HuT8QpxXXi5s7Cuj0PKGWZCnruWNnQqXyYm1i0d9yb4mqRpIWI7A/VjnpxilZZAz
niFk0yq2twA+zY8uLNMqQ9pmpnrAFer3ueOD5EY+kWQEY3ydZJML787m1Wx0Fc4n
nHJmcfQYyKBj7pyOkpc+DZSTQu0VZpYCZ4L4GVp0/j8IAe6lON5DsfwXc3YTmd0H
nNJOWc0bTpAGbb4y4PNVoTy/JrVFQ0asUrX9mk04YmzQe5VR4mCUgfWDBTEi7hUw
mIl5vuza6LnzBpb2/GamikfbvGQnjF5tmghTxcscLFYdU/L+Kn0dddccVLBXOAeY
d3XPVQtyFKQ=
=hcyE
-----END PGP SIGNATURE-----

--Sig_/l.nWFOtSgSl7b5AHt6b5qRW--
