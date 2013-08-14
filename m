From: NeilBrown <neilb@suse.de>
Subject: Re: [BUG] md hang at schedule in  md_write_start
Date: Wed, 14 Aug 2013 10:44:10 +1000
Message-ID: <20130814104410.10bb2259@notabene.brown>
References: <52090E6D.10104@profitbricks.com>
	<20130813143115.55dd27d1@notabene.brown>
	<5209E37D.6050107@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/v/MH_plXT2XMqiI4R_8nuPw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5209E37D.6050107@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>
Cc: linux-raid@vger.kernel.org, Jack Wang <xjtuwjp@gmail.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

--Sig_/v/MH_plXT2XMqiI4R_8nuPw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Aug 2013 09:42:53 +0200 Jack Wang <jinpu.wang@profitbricks.com>
wrote:

> On 08/13/2013 06:31 AM, NeilBrown wrote:
> > On Mon, 12 Aug 2013 18:33:49 +0200 Jack Wang <jinpu.wang@profitbricks.c=
om>
> > wrote:
> >=20
> >> Hi Neil,
> >>
> >>
> >> We've found md hang in our test, it's easy to reproduce with script
> >> attached.
> >>
> >> We've tried 3.4 stable kernel and latest mainline, it still exists.
> >>
> >> Looks like flush bdi_writeback_workfn race with md_stop, no idea how to
> >> fix it, could you kindly give us suggestions?
> >>
> >> Best regards,
> >> Jack
> >=20
> > Thanks for the report.  I can see how that deadlock could happen.
> >=20
> > Can you please try this patch and confirm that it fixes it.
> > I'm not really happy with this approach but nothing better occurs to me=
 yet.
> >=20
> > NeilBrown
> >=20
>=20
> Hi Neil,
>=20
> Thanks for quick fix, I tested on 3.4 stable and mainline, it works now.
> Could you give more description about the bug and fix.
>
Thanks for testing.

The problem:
 If you open a block device (e.g. /dev/md0) and write to it the writes will
 be buffered in the page cache until an 'fsync' or similar.
 When the last open file descriptor on the block device is closed, that
 triggers a flush even if there was no fsync.
 So if you
    dd > /dev/md0
    mdadm --stop /dev/md0
 The 'close' that happens when dd exits will flush the cache.  So when mdadm
 opens /dev/md0 the cache will be empty.  This is the normal situation.

 However if "mdadm --stop /dev/md0" open /dev/md0 before 'dd' exits, then
 nothing will trigger the flush and that causes problems as I'll get to in a
 minute.
 Normally if this happened, mdadm would call the STOP_ARRAY ioctl which wou=
ld
 notice that there is an extra open (from dd) and would abort.
 However "mdadm -S" retries a few times if it confirmed that the array wasn=
't
 mounted.  Eventually it opens just before 'dd' closes.  The presence of the
 "mdadm -D" might affect this - it might hold a lock that "mdadm -S" waits a
 little while for.

 Anyway by the time that "mdadm --stop" has called STOP_ARRAY on the open
 file descriptor and got to do_md_stop() it is holding ->reconfig_mutex
 (because md_ioctl() calls mddev_lock()).
 While holding this mutex it calls sync_blockdev() to ensure the page cache
 is flushed.  This is where the problem occurs.
 If the array is currently marked 'clean' and there a dirty pages in the pa=
ge
 cache, md_write_start() while request that the superblock be marked 'dirty=
'.
 This is handled by md_check_recovery() which is called by the array
 managment thread.  However it will only update the superblock if it can get
 ->reconfig_mutex.

 So the "mdadm --stop" thread is holding ->reconfig_mutex and waiting for
 dirty data to be flushed.  The flush thread is waiting for the superblock
 the be updated by the array management thread.  The array management thread
 won't update the superblock until it can get ->reconfig_mutex.
 i.e. a deadlock.

 One way to "fix" it would be to call md_allow_write() in do_md_stop() befo=
re
 calling sync_blockdev().  This would remove the deadlock, but would often
 modify the superblock unnecessarily.

 I would be nice if I could check beforehand if sync_blockdev() will actual=
ly
 write anything and then call md_allow_write() if it would.  But I don't
 think that is possible.

 So the approach I took in the patch I gave you was to set a flag in
 do_md_stop to tell md_check_recovery() that it was ok to update the
 superblock without holding a lock, because the lock is already held.
 I don't really like that though.  It feels like it should be racy.

 I could call sync_blockdev() *before* taking the ->reconfig_mutex but that
 would be racy as another process could theoretically write after the
 sync_blockdev, and close before do_md_stop() checks for other opens....

 However maybe I could make use for ->open_mutex.  This guards opening and
 destroying of the array, which are the issue here.

 Before the mddev_lock() in md_ioctl() I could (in the STOP_ARRAY case)
    lock ->open_mutex
    check that mddev->openers is 1 - abort if not
    set a flag
    release ->open_mutex
    call sync_blockdev.

 Then in md_open()
    after getting ->open_mutex, clear the flag.

 Then in do_md_stop()
    after getting ->open_mutex, if the flag is set, abort with EBUSY.

 This would ensure that the page cache is not dirty when do_md_stop decides
 to stop the array by flushing it early and making sure no-one else can open
 it.

 I think I like this approach better.

 Could you retry the following patch instead?

Thanks
NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a57b0fa..296aac1 100644
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
@@ -5337,8 +5337,14 @@ static int md_set_readonly(struct mddev *mddev, stru=
ct block_device *bdev)
 		err =3D -EBUSY;
 		goto out;
 	}
-	if (bdev)
-		sync_blockdev(bdev);
+	if (bdev && !test_bit(MD_STILL_CLOSED, &mddev->flags)) {
+		/* Someone opened the device since we flushed it
+		 * so page cache could be dirty and it is too late
+		 * to flush.  So abort
+		 */
+		mutex_unlock(&mddev->open_mutex);
+		return -EBUSY;
+	}
 	if (mddev->pers) {
 		__md_stop_writes(mddev);
=20
@@ -5373,14 +5379,14 @@ static int do_md_stop(struct mddev * mddev, int mod=
e,
 		mutex_unlock(&mddev->open_mutex);
 		return -EBUSY;
 	}
-	if (bdev)
-		/* It is possible IO was issued on some other
-		 * open file which was closed before we took ->open_mutex.
-		 * As that was not the last close __blkdev_put will not
-		 * have called sync_blockdev, so we must.
+	if (bdev && !test_bit(MD_STILL_CLOSED, &mddev->flags)) {
+		/* Someone opened the device since we flushed it
+		 * so page cache could be dirty and it is too late
+		 * to flush.  So abort
 		 */
-		sync_blockdev(bdev);
-
+		mutex_unlock(&mddev->open_mutex);
+		return -EBUSY;
+	}
 	if (mddev->pers) {
 		if (mddev->ro)
 			set_disk_ro(disk, 0);
@@ -6417,6 +6423,20 @@ static int md_ioctl(struct block_device *bdev, fmode=
_t mode,
 						 !test_bit(MD_RECOVERY_NEEDED,
 							   &mddev->flags),
 						 msecs_to_jiffies(5000));
+	if (cmd =3D=3D STOP_ARRAY || cmd =3D=3D STOP_ARRAY_RO) {
+		/* Need to flush page cache, and ensure no-one else opens
+		 * and writes
+		 */
+		mutex_lock(&mddev->open_mutex);
+		if (atomic_read(&mddev->openers) > 1) {
+			mutex_unlock(&mddev->open_mutex);
+			err =3D -EBUSY;
+			goto abort;
+		}
+		set_bit(MD_STILL_CLOSED, &mddev->flags);
+		mutex_unlock(&mddev->open_mutex);
+		sync_blockdev(bdev);
+	}
 	err =3D mddev_lock(mddev);
 	if (err) {
 		printk(KERN_INFO=20
@@ -6670,6 +6690,7 @@ static int md_open(struct block_device *bdev, fmode_t=
 mode)
=20
 	err =3D 0;
 	atomic_inc(&mddev->openers);
+	clear_bit(MD_STILL_CLOSED, &mddev->flags);
 	mutex_unlock(&mddev->open_mutex);
=20
 	check_disk_change(bdev);
@@ -7814,7 +7835,7 @@ void md_check_recovery(struct mddev *mddev)
 				sysfs_notify_dirent_safe(mddev->sysfs_state);
 		}
=20
-		if (mddev->flags)
+		if (mddev->flags & MD_UPDATE_SB_FLAGS)
 			md_update_sb(mddev, 0);
=20
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 77924d3..8c3c6cf 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -209,7 +209,11 @@ struct mddev {
 #define MD_CHANGE_DEVS	0	/* Some device status has changed */
 #define MD_CHANGE_CLEAN 1	/* transition to or from 'clean' */
 #define MD_CHANGE_PENDING 2	/* switch from 'clean' to 'active' in progress=
 */
+#define MD_UPDATE_SB_FLAGS (1 | 2 | 4)	/* If these are set, md_update_sb n=
eeded */
 #define MD_ARRAY_FIRST_USE 3    /* First use of array, needs initializatio=
n */
+#define MD_STILL_CLOSED	4	/* If we, then array has not been opened since
+				 * md_ioctl checked on it.
+				 */
=20
 	int				suspended;
 	atomic_t			active_io;



--Sig_/v/MH_plXT2XMqiI4R_8nuPw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUgrS2jnsnt1WYoG5AQJx8BAAgh5ILC0zoHhbgm21vxp9lFeAXHqG40h9
5uyJdTwHagtN7NKw2TyerBvMx6AwVaJjuilLZndNJmQ8hbnHk+qHZaupWl7uXWtV
weRKBW/2OTYapPPc4pFy5m1W6jcuxYf59UDr0ZAsegAudRD1mxnG91ztdJFUFprH
UTSJ1JvL6Azu752p1XZGJNXycuWfBj+QF11rrUTSRWVs7l3lfa+WZ3Ox/JvuE0Iy
Pf0w36FjU9PfkcLkPBm9XSCbu4x7r8PKxv8fjRQBoku3zdNytlP1ve5dWlFEtSg/
fkl0rSg8MykDdwqCFn9R+2iMMADifYJ/kXjtCEIgsJmIjsfqqklOBCZUv17HNbjX
r49k9T5ZkbGXDOL+rTUj1x6/YcrEoHPL/jgsaiVjembYDrjFI5ECnHSZHmaHEIPN
zY1xjn8WMCsBHWFr7Pmo/i44L8crFPjoePl1w4ZcJBQ3qt0waiYyxT8RZskv62Bb
0jqxZwO9WWLfUfCYBYKTWGMwPsa9dhFXlh23Kizuv4i5oIZLBYmjm80SUyEB64+7
wBHzhyV8+y7tJuqJffdsi7BVpki19uJgXAAlqGjzJ7HO/EOzEu/U889YVTEXRLyR
tN9WEV7AgIGXZsHAcMSPMxG0ecQ2OO4KUpUNJwzPkyaVsnLuoMEiVUNiU+0ASSzs
9EzFk+iIA9w=
=QBaX
-----END PGP SIGNATURE-----

--Sig_/v/MH_plXT2XMqiI4R_8nuPw--
