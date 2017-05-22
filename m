From: NeilBrown <neilb@suse.com>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Mon, 22 May 2017 21:35:29 +1000
Message-ID: <87a865jf9a.fsf@notabene.neil.brown.name>
References: <87lgppz221.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <87lgppz221.fsf@esperi.org.uk>
Sender: linux-bcache-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org, linux-bcache <linux-bcache@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, May 22 2017, Nix wrote:

> [I think bcache is blameless here, but there may be some interaction, so
>  I've Cc:ed both lists. I'm fairly sure the problem is mddev_suspend()
>  being called from level_store() and scheduling after suspension has
>  happened, but I'm not sure what the fix might be.]
>
> So I have a box with three RAID arrays on the same physical
> rotating-rust devices:
>
>  - a RAID-0 /dev/md/transient atop /dev/sd*2
>  - a RAID-5 /dev/md/fast, a bcache backing device (with disabled cache
>    for now) atop /dev/sd*3
>  - a RAID-5 /dev/md/slow atop /dev/sd*4.
>
> The rootfs and everything the system needs to run, including mdadm, is
> on /dev/md/fast. fs-wise, everything is using xfs except for
> /dev/md/transient, which houses an ext4 (unjournalled, for speed over
> robustness).
>
> I just got a new disk and grew /dev/md/transient to use it without
> incident, then grew /dev/md/slow into a RAID-6:
>
> mdadm --add /dev/md/slow /dev/sdf4
> mdadm --grow /dev/md/slow --level=3D6 --backup-file=3D/.transient/backup-=
slow
>
> This worked fine.
>
> But the *exact same command* applied to /dev/md/fast hangs:
>
> mdadm --add /dev/md/fast /dev/sdf3
> mdadm --grow /dev/md/fast --level=3D6 --backup-file=3D/.transient/backup-=
fast
> [hang here]
>
> At this point, all disk I/O to /dev/md/fast appears suspended: because /
> is on it, this leaves me rather unable to do anything but reboot.
> Thankfully the deadlock seemingly happens before anything crucial is
> done, and the machine reboots and brigns up /dev/md/fast as an
> unreshaped raid5 array with a spare.
>
> Is this workflow impossible? Do you have to reshape the device the
> rootfs is on from early userspace or something like that? If so... this
> leaves a crucial mdadm running across the early userspace transition:
> what do we do about the fs the backup file is on (since the transition
> usually deletes everything)? Do we even *need* a backup file for a
> reshape that's growing onto a spare, as the manpage suggests we do? Do
> we simply have to leave the machine unavailable for days while the
> reshape completes? (I hope not.)
>
> That hangcheck output I was able to capture by eye suggests a deadlock
> in block I/O during a brief instant of suspended I/O to the device. The
> first hang we see comes from bcache, but since it's in "none" mode this
> is pretty clearly just a writeback (note the md_make_request at the top
> there):
>
> [  248.877539] Workqueue: bcache cached_dev_nodata
> [  248.888590] Call Trace:
> [  248.899337]  __schedule+0x290/0x810
> [  248.909745]  schedule+0x36/0x80
> [  248.920113]  md_make_request+0x9c/0x220
> [  248.930229]  ? wake_atomic_t_function+0x60/0x60
> [  248.940063]  generic_make_request+0xfc/0x260
> [  248.949803]  cached_dev_nodata+0x28/0x80
> [  248.959393]  ? cached_dev_nodata+0x28/0x80
> [  248.968998]  process_one_work+0x1e3/0x440
> [  248.978414]  worker_thread+0x48/0x4d0
> [  248.987596]  kthread+0x108/0x140
> [  248.996747]  ? process_one_work+0x440/0x440
> [  249.005965]  ? __kthread_create_on_node+0x150/0x150
> [  249.015264]  ret_from_fork+0x29/0x40
> [  249.024544] INFO: task kworker/u40:5:245 blocked for more than 120 sec=
onds.
>
> This is fairly obviously
>
>         /* If it's a flush, we send the flush to the backing device too */
>         closure_bio_submit(bio, cl);
>
> in drivers/md/bcache/request.c, which is fine.
>
> After that we start to see xfs writeback hangs, all hanging on
> md_make_request() or I/O scheduling:
>
> [  249.062946] Workqueue: writeback wb_workfn (flush-252:5)
> [  249.072733] Call Trace:
> [  249.082390]  __schedule+0x290/0x810
> [  249.092053]  schedule+0x36/0x80
> [  249.101568]  md_make_request+0x9c/0x220
> [  249.110956]  ? wake_atomic_t_function+0x60/0x60
> [  249.120202]  generic_make_request+0xfc/0x260
> [  249.129219]  submit_bio+0x64/0x120
> [  249.137968]  ? submit_bio+0x64/0x120
> [  249.146840]  ? xfs_setfilesize_trans_alloc.isra.4+0x2f/0x70
> [  249.155822]  xfs_submit_ioend+0x70/0x190
> [  249.164805]  xfs_vm_writepages+0x65/0x70
> [  249.173620]  do_writepages+0x1e/0x30
> [  249.182239]  __writeback_single_inode+0x45/0x320
> [  249.190838]  writeback_sb_inodes+0x191/0x490
> [  249.199459]  __writeback_inodes_wb+0x92/0xc0
> [  249.207988]  wb_writeback+0x243/0x2d0
> [  249.216395]  wb_workfn+0x299/0x360
> [  249.224851]  ? wb_workfn+0x299/0x360
> [  249.233393]  process_one_work+0x1e3/0x440
> [  249.242049]  worker_thread+0x48/0x4d0
> [  249.250404]  kthread+0x108/0x140
> [  249.258408]  ? process_one_work+0x440/0x440
> [  249.266148]  ? __kthread_create_on_node+0x150/0x150
> [  249.273652]  ret_from_fork+0x29/0x40
>
> [  249.310928] Workqueue: xfs-cil/dm-5 xlog_cil_push_work
> [  249.318453] Call Trace:
> [  249.325929]  __schedule+0x290/0x810
> [  249.333456]  schedule+0x36/0x80
> [  249.340940]  schedule_timeout+0x207/0x360
> [  249.348461]  ? cached_dev_make_request+0x2bc/0xd00
> [  249.356018]  io_schedule_timeout+0x1e/0x50
> [  249.363533]  ? io_schedule_timeout+0x1e/0x50
> [  249.371078]  wait_for_common_io.constprop.0+0x92/0x110
> [  249.378711]  ? try_to_wake_up+0x400/0x400
> [  249.386339]  wait_for_completion_io+0x18/0x20
> [  249.394026]  submit_bio_wait+0x59/0x70
> [  249.401685]  blkdev_issue_flush+0x5c/0x90
> [  249.409321]  xfs_blkdev_issue_flush+0x19/0x20
> [  249.416951]  xlog_sync+0x2a1/0x3b0
> [  249.424439]  xlog_state_release_iclog+0x6d/0xd0
> [  249.431857]  xlog_write+0x64a/0x6e0
> [  249.439092]  xlog_cil_push+0x230/0x450
> [  249.446169]  xlog_cil_push_work+0x15/0x20
> [  249.453128]  process_one_work+0x1e3/0x440
> [  249.460030]  worker_thread+0x221/0x4d0
> [  249.466942]  kthread+0x108/0x140
> [  249.473843]  ? process_one_work+0x440/0x440
> [  249.480762]  ? __kthread_create_on_node+0x150/0x150
> [  249.487743]  ret_from_fork+0x29/0x40
>
> [  249.524000] Workqueue: xfs-log/dm-5 xfs_log_worker
> [  249.531490] Call Trace:
> [  249.538923]  __schedule+0x290/0x810
> [  249.546366]  schedule+0x36/0x80
> [  249.553756]  schedule_timeout+0x207/0x360
> [  249.561132]  ? check_preempt_curr+0x79/0x90
> [  249.568514]  ? ttwu_do_wakeup.isra.15+0x1e/0x160
> [  249.575957]  wait_for_common+0xaa/0x160
> [  249.583432]  ? wait_for_common+0xaa/0x160
> [  249.590943]  ? try_to_wake_up+0x400/0x400
> [  249.598447]  wait_for_completion+0x1d/0x20
> [  249.605984]  flush_work+0xfb/0x1b0
> [  249.613509]  ? flush_workqueue_prep_pwqs+0x1a0/0x1a0
> [  249.621093]  xlog_cil_force_lsn+0x75/0x1d0
> [  249.628640]  ? dequeue_task_fair+0x757/0x1920
> [  249.636169]  _xfs_log_force+0x76/0x280
> [  249.643524]  ? xfs_log_worker+0x32/0x100
> [  249.650715]  xfs_log_force+0x2c/0x80
> [  249.657719]  xfs_log_worker+0x32/0x100
> [  249.664653]  process_one_work+0x1e3/0x440
> [  249.671498]  worker_thread+0x48/0x4d0
> [  249.678354]  kthread+0x108/0x140
> [  249.685218]  ? process_one_work+0x440/0x440
> [  249.692123]  ? __kthread_create_on_node+0x150/0x150
> [  249.699057]  ret_from_fork+0x29/0x40
>
> [  249.727654] syslog-ng       D    0  1658   1657 0x00000000
> [  249.735066] Call Trace:
> [  249.742333]  __schedule+0x290/0x810
> [  249.749624]  schedule+0x36/0x80
> [  249.756915]  md_write_start+0x8f/0x160
> [  249.764185]  ? wake_atomic_t_function+0x60/0x60
> [  249.771469]  raid5_make_request+0x7a/0xd40
> [  249.778762]  ? bch_data_insert_start+0x4da/0x5e0
> [  249.786143]  ? wake_atomic_t_function+0x60/0x60
> [  249.793571]  md_make_request+0xe3/0x220
> [  249.800976]  generic_make_request+0xfc/0x260
> [  249.808383]  submit_bio+0x64/0x120
> [  249.815838]  ? submit_bio+0x64/0x120
> [  249.823253]  ? xfs_setfilesize_trans_alloc.isra.4+0x2f/0x70
> [  249.830757]  xfs_submit_ioend+0x70/0x190
> [  249.838269]  xfs_vm_writepages+0x65/0x70
> [  249.845668]  do_writepages+0x1e/0x30
> [  249.852899]  __filemap_fdatawrite_range+0x71/0x90
> [  249.860023]  filemap_write_and_wait_range+0x2a/0x70
> [  249.867061]  xfs_file_fsync+0x54/0x190
> [  249.874007]  vfs_fsync_range+0x49/0xa0
> [  249.880934]  ? __fdget_pos+0x17/0x50
> [  249.887793]  ? vfs_writev+0x3c/0x50
> [  249.894700]  do_fsync+0x3d/0x70
> [  249.901565]  SyS_fsync+0x10/0x20
>
> I think we are stuck inside the
>
>         if (mddev->suspended) {
>
> block in md_make_request() in all these cases.
>
> ... and finally it becomes clear that mdadm is blocked and we are in
> real trouble:
>
> [  249.965701] INFO: task mdadm:2712 blocked for more than 120 seconds.
> [  249.973003]       Not tainted 4.11.2-00005-g87b2117c3309-dirty #2
> [  249.980381] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
> [  249.987999] mdadm           D    0  2712   2020 0x00000000
> [  249.995681] Call Trace:
> [  250.003273]  __schedule+0x290/0x810
> [  250.010885]  schedule+0x36/0x80
> [  250.018503]  mddev_suspend+0xb3/0xe0
> [  250.026158]  ? wake_atomic_t_function+0x60/0x60
> [  250.033856]  level_store+0x1a7/0x6c0
> [  250.041478]  ? md_ioctl+0xb7/0x1c10
> [  250.049075]  ? putname+0x53/0x60
> [  250.056554]  md_attr_store+0x83/0xc0
> [  250.063922]  sysfs_kf_write+0x37/0x40
> [  250.071082]  kernfs_fop_write+0x110/0x1a0
> [  250.078127]  __vfs_write+0x28/0x120
> [  250.085166]  ? kernfs_iop_get_link+0x172/0x1e0
> [  250.092199]  ? __alloc_fd+0x3f/0x170
> [  250.099271]  vfs_write+0xb6/0x1d0
> [  250.106307]  SyS_write+0x46/0xb0
> [  250.113227]  entry_SYSCALL_64_fastpath+0x13/0x94
>
> I'm not sure what this is waiting on. It could be *any* of
>
>         synchronize_rcu();
>         wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) =3D=3D =
0);
>         mddev->pers->quiesce(mddev, 1);

It says 'schedule()' so it is in wait_event().

>
> since they all can probably schedule and if quiescing involves talking
> to the device, we have already suspended it, so we're doomed.
>
> I'm not sure how we can quiesce before we suspend and prevent things
> from trying to issue more crucial requests (paging in mdadm?) before we
> resume again, but I'm fairly sure that *something* different needs to be
> done.

Congratulations.  You have found a bug that dates from 2011.

Commit: 68866e425be2 ("MD: no sync IO while suspended")

(I think).

A write request gets to raid5_make_request() before mddev_suspend() sets
mddev->suspended.
raid5_make_request() needs md_write_start() to mark the array "dirty"
which it asks the md thread to do, but before the thread gets to the
task, mddev->suspend has been set, so md_check_recovery() doesn't update
the superblock, so md_write_start() doesn't proceed, so the request
never completes, so mddev_suspend() blocks indefinitely.

I think that md_check_recovery() need to test for mddev->suspended
somewhere else.
It needs to allow superblock updates, and probably needs to reap the
recovery thread, but must not start a new recovery thread.

Probably something like this:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f6ae1d67bcd0..dbca31be22a1 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8364,8 +8364,6 @@ static void md_start_sync(struct work_struct *ws)
  */
 void md_check_recovery(struct mddev *mddev)
 {
=2D	if (mddev->suspended)
=2D		return;
=20
 	if (mddev->bitmap)
 		bitmap_daemon_work(mddev);
@@ -8484,6 +8482,7 @@ void md_check_recovery(struct mddev *mddev)
 		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
=20
 		if (!test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
+		    mddev->suspended ||
 		    test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
 			goto not_running;
 		/* no recovery is running.

though it's late so don't trust anything I write.

If you try again it will almost certainly succeed.  I suspect this is a
hard race to hit - well done!!!

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkizQEACgkQOeye3VZi
gbkuDQ/+NvvlFGWpVOgTvLorOiH7gyK6etTVyDJMCVCL+w0O26Loe9vHB2bKW4NV
FyurnMIg5oU8YUvoWkQI1OthWq5w2fTmZWGdmGsi6CQqVov2uL0luMjsfeELC8K5
hgebuwNBPJqqzrbCcXC6+KG704v26Q38RGNceHqcrXy5WnUiekqhDGvA/yLkBHwt
8jYHke3UCsXDLO4EbnDdrKrs/8i1UxDHdo33EixdJkjgsVPfMTAcyIcpm9oZ6bXO
ANsEZJEl7C/1ZELNBz2XEuwFkzzvv4bw4EeyoO3Q1p5hmYNd9s9rDdCS0pUBfdJx
GFFzpFgq5j18nQF+l7ngnvReJn0HsL2mHbsV6QyjfSiLhWfbTbKP+tZW1VUJ/pYH
gI0MMb9pZnsiCDjWga5Ii1GDnMZGraVaDJISOkHtObFHv2XVOKo8h0lNufKtYSca
bTk4DjFU3ksSjlZYrBtLi5aU4NHZv3RyKImii7utk+QwXStGJcsC6KEiEsgH9ryA
A/rlvBj7YVRgt2GvJYxkShWYc6rw8BNX1tKXFXmC23uP5SliFcXK6L2avR0L/+DO
ZRFsZJV7Ium9ut+DvOunvTDtzk3lHi37QslGyIAELBc5QSy8d4l0m+O2MpDVEv7m
kQnztthnVB+Lp4t3QX7TQgZA2ijxSou0Oze3ZBesCZJmSuzIhAk=
=7kny
-----END PGP SIGNATURE-----
--=-=-=--
