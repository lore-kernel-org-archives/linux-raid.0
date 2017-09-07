From: NeilBrown <neilb@suse.com>
Subject: Re: Stuck in md_write_start because MD_SB_CHANGE_PENDING can't be cleared
Date: Thu, 07 Sep 2017 15:37:45 +1000
Message-ID: <87bmmnax1y.fsf@notabene.neil.brown.name>
References: <546311999.4473128.1504339295016.JavaMail.zimbra@redhat.com> <877exfdx7x.fsf@notabene.neil.brown.name> <22698eb3-35f7-04e5-96e8-26470d892655@redhat.com> <b5856cb8-0ea6-7bf2-10a0-76dd69d04698@redhat.com> <87y3pvc9ha.fsf@notabene.neil.brown.name> <34fedde7-cef9-34ff-1403-9d097267eb55@redhat.com> <87k21ec4fn.fsf@notabene.neil.brown.name> <3a5955de-e6a1-de83-b00b-1984f7125799@redhat.com> <624049285.8379021.1504748277805.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <624049285.8379021.1504748277805.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>
Cc: shli@kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 06 2017, Xiao Ni wrote:

> ----- Original Message -----
>> From: "Xiao Ni" <xni@redhat.com>
>> To: "NeilBrown" <neilb@suse.com>, "linux-raid" <linux-raid@vger.kernel.o=
rg>
>> Cc: shli@kernel.org
>> Sent: Tuesday, September 5, 2017 10:15:00 AM
>> Subject: Re: Stuck in md_write_start because MD_SB_CHANGE_PENDING can't =
be cleared
>>=20
>>=20
>>=20
>> On 09/05/2017 09:36 AM, NeilBrown wrote:
>> > On Mon, Sep 04 2017, Xiao Ni wrote:
>> >
>> >>
>> >> In function handle_stripe:
>> >> 4697         if (s.handle_bad_blocks ||
>> >> 4698             test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flag=
s)) {
>> >> 4699                 set_bit(STRIPE_HANDLE, &sh->state);
>> >> 4700                 goto finish;
>> >> 4701         }
>> >>
>> >> Because MD_SB_CHANGE_PENDING is set, so the stripes can't be handled.
>> >>
>> > Right, of course.  I see what is happening now.
>> >
>> > - raid5d cannot complete stripes until the metadata is written
>> > - the metadata cannot be written until raid5d gets the mddev_lock
>> > - mddev_lock is held by the write to suspend_hi
>> > - the write to suspend_hi is waiting for raid5_quiesce
>> > - raid5_quiesce is waiting for some stripes to complete.
>> >
>> > We could declare that ->quiesce(, 1) cannot be called while holding the
>> > lock.
>> > We could possible allow it but only if md_update_sb() is called first,
>> > though that might still be racy.
>> >
>> > ->quiesce(, 1) is currently called from:
>> >   mddev_suspend
>> >   suspend_lo_store
>> >   suspend_hi_store
>> >   __md_stop_writes
>> >   mddev_detach
>> >   set_bitmap_file
>> >   update_array_info (when setting/removing internal bitmap)
>> >   md_do_sync
>> >
>> > and most of those are call with the lock held, or take the lock.
>> >
>> > Maybe we should *require* that mddev_lock is held when calling
>> > ->quiesce() and have ->quiesce() do the metadata update.
>> >
>> > Something like the following maybe.  Can you test it?
>>=20
>> Hi Neil
>>=20
>> Thanks for the analysis. I need to thing for a while :)
>> I already added the patch and the test is running now. It usually needs
>> more than 5
>> hours to reproduce this problem. I'll let it run more than 24 hours.
>> I'll update the test
>> result later.
>
> Hi Neil
>
> The problem still exists. But it doesn't show calltrace this time. It
> was stuck yesterday. I didn't notice that because there has no calltrace.
>
> echo file raid5.c +p > /sys/kernel/debug/dynamic_debug/control
>
> It shows that raid5d is still spinning.

Thanks for testing. I've thought some more and I think there is a better
approach.
The fact that we need to take the mutex to write the super block has
caused problems several times before and is a key part of the problem
now.
Maybe we should relax that.  Obviously we don't want two threads
updating the metadata at the same time, but it should be safe to
update it in parallel with other uses of reconfix_mutex.

Holding mddev->lock while copying data from the struct mddev to the
superblock (which we do) should ensure that the superblock is internally
consistent, and that should be enough.

So I propose the following patch.  It certainly needs review and
testing, but I think it should make a big improvement.

Thanks,
NeilBrown


diff --git a/drivers/md/md.c b/drivers/md/md.c
index b01e458d31e9..414a4c1a052d 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2388,6 +2388,15 @@ void md_update_sb(struct mddev *mddev, int force_cha=
nge)
 		return;
 	}
=20
+	if (!force_change && !(mddev->sb_flags & ~BIT(MD_SB_UPDATE_ACTIVE)))
+		return;
+
+	wait_event(mddev->sb_wait,
+		   !test_and_set_bit(MD_SB_UPDATE_ACTIVE, &mddev->sb_flags));
+
+	if (!force_change && !(mddev->sb_flags & ~BIT(MD_SB_UPDATE_ACTIVE)))
+		goto out;
+
 repeat:
 	if (mddev_is_clustered(mddev)) {
 		if (test_and_clear_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags))
@@ -2402,7 +2411,7 @@ void md_update_sb(struct mddev *mddev, int force_chan=
ge)
 			bit_clear_unless(&mddev->sb_flags, BIT(MD_SB_CHANGE_PENDING),
 							 BIT(MD_SB_CHANGE_DEVS) |
 							 BIT(MD_SB_CHANGE_CLEAN));
=2D			return;
+			goto out;
 		}
 	}
=20
@@ -2432,8 +2441,7 @@ void md_update_sb(struct mddev *mddev, int force_chan=
ge)
 				wake_up(&rdev->blocked_wait);
 			}
 		}
=2D		wake_up(&mddev->sb_wait);
=2D		return;
+		goto out;
 	}
=20
 	spin_lock(&mddev->lock);
@@ -2544,6 +2552,9 @@ void md_update_sb(struct mddev *mddev, int force_chan=
ge)
 			       BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_CLEAN)))
 		/* have to write it out again */
 		goto repeat;
+
+out:
+	clear_bit_unlock(MD_SB_UPDATE_ACTIVE, &mddev->sb_flags);
 	wake_up(&mddev->sb_wait);
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
@@ -5606,8 +5617,7 @@ int md_run(struct mddev *mddev)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
=20
=2D	if (mddev->sb_flags)
=2D		md_update_sb(mddev, 0);
+	md_update_sb(mddev, 0);
=20
 	md_new_event(mddev);
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
@@ -8643,17 +8653,14 @@ void md_check_recovery(struct mddev *mddev)
=20
 	if (mddev->ro && !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
 		return;
=2D	if ( ! (
=2D		(mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
+	if ((
 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
 		(mddev->external =3D=3D 0 && mddev->safemode =3D=3D 1) ||
 		(mddev->safemode =3D=3D 2
 		 && !mddev->in_sync && mddev->recovery_cp =3D=3D MaxSector)
=2D		))
=2D		return;
=2D
=2D	if (mddev_trylock(mddev)) {
+		     ) &&
+	    mddev_trylock(mddev)) {
 		int spares =3D 0;
=20
 		if (!mddev->external && mddev->safemode =3D=3D 1)
@@ -8706,9 +8713,6 @@ void md_check_recovery(struct mddev *mddev)
 			spin_unlock(&mddev->lock);
 		}
=20
=2D		if (mddev->sb_flags)
=2D			md_update_sb(mddev, 0);
=2D
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
 		    !test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
 			/* resync/recovery still happening */
@@ -8786,6 +8790,7 @@ void md_check_recovery(struct mddev *mddev)
 		wake_up(&mddev->sb_wait);
 		mddev_unlock(mddev);
 	}
+	md_update_sb(mddev, 0);
 }
 EXPORT_SYMBOL(md_check_recovery);
=20
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 09db03455801..bc8633cf7c40 100644
=2D-- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -243,6 +243,7 @@ enum mddev_sb_flags {
 	MD_SB_CHANGE_CLEAN,	/* transition to or from 'clean' */
 	MD_SB_CHANGE_PENDING,	/* switch from 'clean' to 'active' in progress */
 	MD_SB_NEED_REWRITE,	/* metadata write needs to be repeated */
+	MD_SB_UPDATE_ACTIVE,	/* A thread is running in md_update_sb */
 };
=20
 struct mddev {
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 2dcbafa8e66c..76169dd8ff7c 100644
=2D-- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1334,21 +1334,10 @@ static void r5l_write_super_and_discard_space(struc=
t r5l_log *log,
 	mddev =3D log->rdev->mddev;
 	/*
 	 * Discard could zero data, so before discard we must make sure
=2D	 * superblock is updated to new log tail. Updating superblock (either
=2D	 * directly call md_update_sb() or depend on md thread) must hold
=2D	 * reconfig mutex. On the other hand, raid5_quiesce is called with
=2D	 * reconfig_mutex hold. The first step of raid5_quiesce() is waitting
=2D	 * for all IO finish, hence waitting for reclaim thread, while reclaim
=2D	 * thread is calling this function and waitting for reconfig mutex. So
=2D	 * there is a deadlock. We workaround this issue with a trylock.
=2D	 * FIXME: we could miss discard if we can't take reconfig mutex
+	 * superblock is updated to new log tail.
 	 */
=2D	set_mask_bits(&mddev->sb_flags, 0,
=2D		BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
=2D	if (!mddev_trylock(mddev))
=2D		return;
+
 	md_update_sb(mddev, 1);
=2D	mddev_unlock(mddev);
=20
 	/* discard IO error really doesn't matter, ignore it */
 	if (log->last_checkpoint < end) {

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmw2ysACgkQOeye3VZi
gbl40g//bxoJclC8ixFvYVH/m6tzT1aXRLVadVoHalnZSz6DB8tb72zWzgp61HeN
+/5IsTpVtx10p0nGrT1ttMmq8rqL7g0gqqOy+v/kFGGV8VODo2wOCqXy+T5iCk1j
Ld0BCKBydQgXag/Q56Gp6Yt+fdzVsEK4jf6Hb6k5wc3biCqEODy12/oPgIXGFI8v
m8kRR37F6Yr+YhWEn7J3VxOBf7tfPcRW/7XRAQZdYlj7QwMPzMCQ8grv68G221qF
xxyH1r0ZcOezjVd43BkIhw4Aw/wElcmsqodoTjlyjIFWJvRVqofTl2gmXBRY+2ks
JIvq5bao2XB7vYxPn/y1hPVbxwXhVe7/PeeRlRBoN6QCIZygTwjxiusieMWP0E/R
HCkC2lUUwObpNmPJ3e1Mm1kY8p92fKToBDf49YV01myc5EfQbtWvkknVAs/ZCS4R
66k1PwbM0yPEWdVV5fBAduEDEDjnF7ICCWK7LOxUvtaCTLuegNzGGl7kZ4ReZkbA
PvBxFxaS3TxuUIhVoITa5CNqz7HlPIEoicxMryd1zidJxuLdU1Ag6CuKyqi81AMb
VUEFbC3ct0oD3cEmHYTp1I8niHCjQZkI4YoW3iKCO5Znby7oMLByXHEtiRLzmQUp
xNKsbPTikBiPjegRa6Xx2IakLHFTIheDVTWdHpv2sYyafXnFzck=
=77+d
-----END PGP SIGNATURE-----
--=-=-=--
