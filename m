From: NeilBrown <neilb@suse.com>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Fri, 26 May 2017 13:23:06 +1000
Message-ID: <87inkogv39.fsf@notabene.neil.brown.name>
References: <87lgppz221.fsf@esperi.org.uk> <87a865jf9a.fsf@notabene.neil.brown.name> <87fufwy3lr.fsf@esperi.org.uk> <87poezhwsa.fsf@notabene.neil.brown.name> <20170524225735.555dpfe24mi6yxrb@kernel.org> <877f15iuzf.fsf@notabene.neil.brown.name> <20170525014647.vwauunwyizjpdl5i@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170525014647.vwauunwyizjpdl5i@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, May 24 2017, Shaohua Li wrote:

> On Thu, May 25, 2017 at 11:30:12AM +1000, Neil Brown wrote:
>> On Wed, May 24 2017, Shaohua Li wrote:
>>=20
>> > On Wed, May 24, 2017 at 11:24:21AM +1000, Neil Brown wrote:
>> >>=20
>> >>=20
>> >>=20
>> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> >> index 10367ffe92e3..a7b9c0576479 100644
>> >> --- a/drivers/md/md.c
>> >> +++ b/drivers/md/md.c
>> >> @@ -324,8 +324,12 @@ static blk_qc_t md_make_request(struct request_q=
ueue *q, struct bio *bio)
>> >>  void mddev_suspend(struct mddev *mddev)
>> >>  {
>> >>  	WARN_ON_ONCE(mddev->thread && current =3D=3D mddev->thread->tsk);
>> >> +
>> >>  	if (mddev->suspended++)
>> >>  		return;
>> >> +#ifdef CONFIG_LOCKDEP
>> >> +	WARN_ON_ONCE(debug_locks && lockdep_is_held(&mddev->reconfig_mutex)=
);
>> >> +#endif
>> >>  	synchronize_rcu();
>> >>  	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) =3D=3D 0);
>> >>  	mddev->pers->quiesce(mddev, 1);
>> >> @@ -3594,9 +3598,12 @@ level_store(struct mddev *mddev, const char *b=
uf, size_t len)
>> >>  	if (slen =3D=3D 0 || slen >=3D sizeof(clevel))
>> >>  		return -EINVAL;
>> >>=20=20
>> >> +	mddev_suspend(mddev);
>> >>  	rv =3D mddev_lock(mddev);
>> >> -	if (rv)
>> >> +	if (rv) {
>> >> +		mddev_resume(mddev);
>> >>  		return rv;
>> >> +	}
>> >>=20=20
>> >>  	if (mddev->pers =3D=3D NULL) {
>> >>  		strncpy(mddev->clevel, buf, slen);
>> >> @@ -3687,7 +3694,6 @@ level_store(struct mddev *mddev, const char *bu=
f, size_t len)
>> >>  	}
>> >>=20=20
>> >>  	/* Looks like we have a winner */
>> >> -	mddev_suspend(mddev);
>> >>  	mddev_detach(mddev);
>> >>=20=20
>> >>  	spin_lock(&mddev->lock);
>> >> @@ -3771,13 +3777,13 @@ level_store(struct mddev *mddev, const char *=
buf, size_t len)
>> >>  	blk_set_stacking_limits(&mddev->queue->limits);
>> >>  	pers->run(mddev);
>> >>  	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>> >> -	mddev_resume(mddev);
>> >>  	if (!mddev->thread)
>> >>  		md_update_sb(mddev, 1);
>> >>  	sysfs_notify(&mddev->kobj, NULL, "level");
>> >>  	md_new_event(mddev);
>> >>  	rv =3D len;
>> >>  out_unlock:
>> >> +	mddev_resume(mddev);
>> >>  	mddev_unlock(mddev);
>> >>  	return rv;
>> >>  }
>> >> @@ -4490,6 +4496,7 @@ action_store(struct mddev *mddev, const char *p=
age, size_t len)
>> >>  		int err;
>> >>  		if (mddev->pers->start_reshape =3D=3D NULL)
>> >>  			return -EINVAL;
>> >> +		mddev_suspend(mddev);
>> >>  		err =3D mddev_lock(mddev);
>> >>  		if (!err) {
>> >>  			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>> >> @@ -4500,6 +4507,7 @@ action_store(struct mddev *mddev, const char *p=
age, size_t len)
>> >>  			}
>> >>  			mddev_unlock(mddev);
>> >>  		}
>> >> +		mddev_resume(mddev);
>> >>  		if (err)
>> >>  			return err;
>> >>  		sysfs_notify(&mddev->kobj, NULL, "degraded");
>> >
>> > The analysis makes a lot of sense, thanks! The patch looks not solving=
 the
>> > problem though, because check_recovery will not write super if suspend=
ed isn't
>> > 0.
>>=20
>> Why does that matter?  In what case do you need the superblock to be
>> written, but it doesn't happen.
>>=20
>> check_recovery won't write the superblock while the mddev is locked
>> either, and it is locked for most of level_store().
>> When level_store() finished, it unlocks the device and that will trigger
>> md_check_recovery() to be run, and the metadata will be written then.
>> I don't think there is a particular need to update it before then.
>
> I get confused. md_write_start is waiting for MD_SB_CHANGE_PENDING cleare=
d,
> which is done in check_recovery. Your previous email describes this too.

Uhmm.... yes.  I see your point now.  Maybe we need might first patch as
well, so md_check_recovery() can still update the superblock after
=2D>suspended is set.

However, I starting looking at making sure mddev_suspend() was never
called with mddev_lock() held, and that isn't straight forward.
Most callers of mddev_suspend() do hold the lock.
The only exceptions I found were:
  dm-raid.c in raid_postsuspend()
  raid5-cache.c in r5c_disable_writeback_async() and
  r5c_journal_mode_set().

It might be easiest to change all of those to lock the mddev, then
do the md_update_sb in mddev_suspend, when needed.

i.e. something like the following.  Thoughts?

Thanks,
NeilBrown


diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 7d893228c40f..db79bd22418b 100644
=2D-- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3607,8 +3607,11 @@ static void raid_postsuspend(struct dm_target *ti)
 {
 	struct raid_set *rs =3D ti->private;
=20
=2D	if (!rs->md.suspended)
+	if (!rs->md.suspended) {
+		mddev_lock_nointr(&rs->md);
 		mddev_suspend(&rs->md);
+		mddev_unlock(&rs->md);
+	}
=20
 	rs->md.ro =3D 1;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 10367ffe92e3..6cbb37a7d445 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -320,14 +320,22 @@ static blk_qc_t md_make_request(struct request_queue =
*q, struct bio *bio)
  * are completely handled.
  * Once mddev_detach() is called and completes, the module will be
  * completely unused.
+ * The caller must hold the mddev_lock.
+ * mddev_suspend() will update the superblock if it
+ * turns out that something is waiting in md_write_start().
  */
 void mddev_suspend(struct mddev *mddev)
 {
 	WARN_ON_ONCE(mddev->thread && current =3D=3D mddev->thread->tsk);
 	if (mddev->suspended++)
 		return;
+	lockdep_assert_held(&mddev->reconfig_mutex);
+
 	synchronize_rcu();
=2D	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) =3D=3D 0);
+	wait_event_cmd(mddev->sb_wait, atomic_read(&mddev->active_io) =3D=3D 0,
+		       if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
+			       md_update_sb(mddev, 0),
+		);
 	mddev->pers->quiesce(mddev, 1);
=20
 	del_timer_sync(&mddev->safemode_timer);
@@ -7971,6 +7979,7 @@ void md_write_start(struct mddev *mddev, struct bio *=
bi)
 			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
 			set_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
 			md_wakeup_thread(mddev->thread);
+			wake_up(&mddev->sb_wait);
 			did_change =3D 1;
 		}
 		spin_unlock(&mddev->lock);
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 4c00bc248287..c231c4a29903 100644
=2D-- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -682,13 +682,11 @@ static void r5c_disable_writeback_async(struct work_s=
truct *work)
 	pr_info("md/raid:%s: Disabling writeback cache for degraded array.\n",
 		mdname(mddev));
=20
=2D	/* wait superblock change before suspend */
=2D	wait_event(mddev->sb_wait,
=2D		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
=2D
+	mddev_lock_nointr(mddev);
 	mddev_suspend(mddev);
 	log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_THROUGH;
 	mddev_resume(mddev);
+	mddev_unlock(mddev);
 }
=20
 static void r5l_submit_current_io(struct r5l_log *log)
@@ -2542,6 +2540,7 @@ int r5c_journal_mode_set(struct mddev *mddev, int mod=
e)
 {
 	struct r5conf *conf =3D mddev->private;
 	struct r5l_log *log =3D conf->log;
+	int ret =3D 0;
=20
 	if (!log)
 		return -ENODEV;
@@ -2550,17 +2549,20 @@ int r5c_journal_mode_set(struct mddev *mddev, int m=
ode)
 	    mode > R5C_JOURNAL_MODE_WRITE_BACK)
 		return -EINVAL;
=20
+	mddev_lock_nointr(mddev);
 	if (raid5_calc_degraded(conf) > 0 &&
 	    mode =3D=3D R5C_JOURNAL_MODE_WRITE_BACK)
=2D		return -EINVAL;
=2D
=2D	mddev_suspend(mddev);
=2D	conf->log->r5c_journal_mode =3D mode;
=2D	mddev_resume(mddev);
+		ret =3D -EINVAL;
+	else {
+		mddev_suspend(mddev);
+		conf->log->r5c_journal_mode =3D mode;
+		mddev_resume(mddev);
=20
=2D	pr_debug("md/raid:%s: setting r5c cache mode to %d: %s\n",
=2D		 mdname(mddev), mode, r5c_journal_mode_str[mode]);
=2D	return 0;
+		pr_debug("md/raid:%s: setting r5c cache mode to %d: %s\n",
+			 mdname(mddev), mode, r5c_journal_mode_str[mode]);
+	}
+	mddev_unlock(mddev);
+	return ret;
 }
 EXPORT_SYMBOL(r5c_journal_mode_set);
=20

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlknn5wACgkQOeye3VZi
gbl+gQ/9Fi/ovrM6OREe/Oo7NN9QJ7tM27iy/qDxi/+PYduVtEUhmkT+Yzb5zmj2
kb89zrSgPv5UcRHjLYuhPUehob2BA4QImWDR1Njnn008L/gHux8+O738Qga8maOh
lvW7sIQRR32b8lDcqyf+Aphzj27IKNHHo5ZJAwNxkcgcg5dVkRPsjjV1KxRvUruO
WdC6iTOw9xMdKvdRAIXqyQARRTuwILr2LscyltfrsxQe8Ojve044fIh7Ft/ajg2f
14WKAGft+09ZZIm54NXIQqfkR+/h9VA1Ac4RfiVtQ5Rek0V3OhqGPB0xzHExcQ7l
yEK7nynDWOnmZRI5XXxJlT2EDpRpvG+dK0EzGvN5b/rBn9M4TMa8mASXYKyd4Npo
YXabQIyidQozItG/qwluwLE7vgjKBH4HGrGEKt3ucuvAtyAevaevud8+unnd7KnB
8hbrewDLYhv9Cv9xjMRQ+75XFnWhC0vm+sssRNpa/fD/WrqQrlTyzvRm8PflV2y8
+NslFIJ7hTrw6RrrdkGhMhkEH+pI6AUsRD6kbFCIHgNcsXJgDljIJ9GaYeT1voWN
IH4RUpWweCAAr8iI1WJZy06paM/rIBrlQ68V4CXlzajXkHKGw9uCoKPWQQchtPIh
WZBISIri4Y7LTPwB+26k6Zv0KkELah7wJ8lKGYk9/Ljr7DmEuio=
=juJa
-----END PGP SIGNATURE-----
--=-=-=--
