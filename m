From: NeilBrown <neilb@suse.com>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Wed, 24 May 2017 11:24:21 +1000
Message-ID: <87poezhwsa.fsf@notabene.neil.brown.name>
References: <87lgppz221.fsf@esperi.org.uk> <87a865jf9a.fsf@notabene.neil.brown.name> <87fufwy3lr.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fufwy3lr.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, May 22 2017, Nix wrote:

> On 22 May 2017, NeilBrown told this:
>
>> Probably something like this:
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index f6ae1d67bcd0..dbca31be22a1 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -8364,8 +8364,6 @@ static void md_start_sync(struct work_struct *ws)
>>   */
>>  void md_check_recovery(struct mddev *mddev)
>>  {
>> -	if (mddev->suspended)
>> -		return;
>>=20=20
>>  	if (mddev->bitmap)
>>  		bitmap_daemon_work(mddev);
>> @@ -8484,6 +8482,7 @@ void md_check_recovery(struct mddev *mddev)
>>  		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
>>=20=20
>>  		if (!test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
>> +		    mddev->suspended ||
>>  		    test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
>>  			goto not_running;
>>  		/* no recovery is running.
>>
>> though it's late so don't trust anything I write.
>>
>> If you try again it will almost certainly succeed.  I suspect this is a
>> hard race to hit - well done!!!
>
> Definitely not a hard race to hit :( I just hit it again with this
> patch.
>
> Absolutely identical hang:
>
> [  495.833520] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
> [  495.840618] mdadm           D    0  2700   2537 0x00000000
> [  495.847762] Call Trace:
> [  495.854825]  __schedule+0x290/0x810
> [  495.861905]  schedule+0x36/0x80
> [  495.868934]  mddev_suspend+0xb3/0xe0
> [  495.875926]  ? wake_atomic_t_function+0x60/0x60
> [  495.882976]  level_store+0x1a7/0x6c0
> [  495.889953]  ? md_ioctl+0xb7/0x1c10
> [  495.896901]  ? putname+0x53/0x60
> [  495.903807]  md_attr_store+0x83/0xc0
> [  495.910684]  sysfs_kf_write+0x37/0x40
> [  495.917547]  kernfs_fop_write+0x110/0x1a0
> [  495.924429]  __vfs_write+0x28/0x120
> [  495.931270]  ? kernfs_iop_get_link+0x172/0x1e0
> [  495.938126]  ? __alloc_fd+0x3f/0x170
> [  495.944906]  vfs_write+0xb6/0x1d0
> [  495.951646]  SyS_write+0x46/0xb0
> [  495.958338]  entry_SYSCALL_64_fastpath+0x13/0x94
>
> Everything else hangs the same way, too. This was surprising enough that
> I double-checked to be sure the patch was applied: it was. I suspect the
> deadlock is somewhat different than you supposed... (and quite possibly
> not a race at all, or I wouldn't be hitting it so consistently, every
> time. I mean, I only need to miss it *once* and I'll have reshaped... :) )
>
> It seems I can reproduce this on demand, so if you want to throw a patch
> with piles of extra printks my way, feel free.

Did you have md_write_start being called by syslog-ng again?
I wonder what syslog is logging - presumably something about the reshape
starting.
If you kill syslog-ng, can you start the reshape?

Alternately, this might do it.
I think the root problem is that it isn't safe to call mddev_suspend()
while holding the reconfig_mutex.
For complete safety I probably need to move the request_module() call
earlier, as that could block if a device was suspended (no memory
allocation allowed while device is suspended).

Thanks,
NeilBrown



diff --git a/drivers/md/md.c b/drivers/md/md.c
index 10367ffe92e3..a7b9c0576479 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -324,8 +324,12 @@ static blk_qc_t md_make_request(struct request_queue *=
q, struct bio *bio)
 void mddev_suspend(struct mddev *mddev)
 {
 	WARN_ON_ONCE(mddev->thread && current =3D=3D mddev->thread->tsk);
+
 	if (mddev->suspended++)
 		return;
+#ifdef CONFIG_LOCKDEP
+	WARN_ON_ONCE(debug_locks && lockdep_is_held(&mddev->reconfig_mutex));
+#endif
 	synchronize_rcu();
 	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) =3D=3D 0);
 	mddev->pers->quiesce(mddev, 1);
@@ -3594,9 +3598,12 @@ level_store(struct mddev *mddev, const char *buf, si=
ze_t len)
 	if (slen =3D=3D 0 || slen >=3D sizeof(clevel))
 		return -EINVAL;
=20
+	mddev_suspend(mddev);
 	rv =3D mddev_lock(mddev);
=2D	if (rv)
+	if (rv) {
+		mddev_resume(mddev);
 		return rv;
+	}
=20
 	if (mddev->pers =3D=3D NULL) {
 		strncpy(mddev->clevel, buf, slen);
@@ -3687,7 +3694,6 @@ level_store(struct mddev *mddev, const char *buf, siz=
e_t len)
 	}
=20
 	/* Looks like we have a winner */
=2D	mddev_suspend(mddev);
 	mddev_detach(mddev);
=20
 	spin_lock(&mddev->lock);
@@ -3771,13 +3777,13 @@ level_store(struct mddev *mddev, const char *buf, s=
ize_t len)
 	blk_set_stacking_limits(&mddev->queue->limits);
 	pers->run(mddev);
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
=2D	mddev_resume(mddev);
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
 	sysfs_notify(&mddev->kobj, NULL, "level");
 	md_new_event(mddev);
 	rv =3D len;
 out_unlock:
+	mddev_resume(mddev);
 	mddev_unlock(mddev);
 	return rv;
 }
@@ -4490,6 +4496,7 @@ action_store(struct mddev *mddev, const char *page, s=
ize_t len)
 		int err;
 		if (mddev->pers->start_reshape =3D=3D NULL)
 			return -EINVAL;
+		mddev_suspend(mddev);
 		err =3D mddev_lock(mddev);
 		if (!err) {
 			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
@@ -4500,6 +4507,7 @@ action_store(struct mddev *mddev, const char *page, s=
ize_t len)
 			}
 			mddev_unlock(mddev);
 		}
+		mddev_resume(mddev);
 		if (err)
 			return err;
 		sysfs_notify(&mddev->kobj, NULL, "degraded");

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkk4MUACgkQOeye3VZi
gbmtuBAAjc7XVYq39uKarT+5E0WaRUVeJ5rvj74E8Q1THU709XCk43P1rX6hrtV4
6hdt7NCF4SMGn0ic03763Qkdtk1BTFsGKKfq97BYZCpMHb7IqLqYJFt31mr776h8
zJsWiX/oByZSB6x9prw9VQhDXOtNXxa7J5V0vDeOy6EDfrkUovTcYY/KcTxHw20L
cGCnCXMVKTonPzkxRJpYEWZbAYp0Bk0eSTwaucH+pQwxTm85clcdOZRepdchis+e
O6nx7daWX1j/Mzk5QB9oxszOMUXoLvfkTah6rzB4ZVOnSp4Jnt/RpQDkwIHEqM8p
OwRRBsleyYykOiJUZ6f19j1C3ts2D/nyCLEwSDh2XFqUNCePDCZ5vfRucDsIOe8u
YM16WlVUyMNj1HFZZoTsvfxQ+dx1pzlCeR1D5z+WEY2e3pne+cgyUAmC2/OTy7La
iT6GqeBb44Gj16TrqS5BVpcUUD9hWQMGvjKDAw/ziHPr1JcRH4QqKODp7h/GRkGi
VYbY+Fe6WEewJJCnCCwhP7O3wglMDl0j8H6xmeH9coPQ706rNK3nINObdnIyLnpQ
drUQF+WqGT6kYm29tVbdFEH3UfjZzDZVAhD3j3Hhwg027PamoL6Hm4Tl4J9E5SWV
vfuJ201LrPalYf4TKfBYE9V7xLX/mX9ydD+k4MgQbQOEY9QGK9E=
=lsFZ
-----END PGP SIGNATURE-----
--=-=-=--
