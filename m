From: NeilBrown <neilb@suse.com>
Subject: Re: Stuck in md_write_start because MD_SB_CHANGE_PENDING can't be cleared
Date: Tue, 05 Sep 2017 11:36:12 +1000
Message-ID: <87k21ec4fn.fsf@notabene.neil.brown.name>
References: <546311999.4473128.1504339295016.JavaMail.zimbra@redhat.com> <877exfdx7x.fsf@notabene.neil.brown.name> <22698eb3-35f7-04e5-96e8-26470d892655@redhat.com> <b5856cb8-0ea6-7bf2-10a0-76dd69d04698@redhat.com> <87y3pvc9ha.fsf@notabene.neil.brown.name> <34fedde7-cef9-34ff-1403-9d097267eb55@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <34fedde7-cef9-34ff-1403-9d097267eb55@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>
Cc: shli@kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 04 2017, Xiao Ni wrote:

>
>
> In function handle_stripe:
> 4697         if (s.handle_bad_blocks ||
> 4698             test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
> 4699                 set_bit(STRIPE_HANDLE, &sh->state);
> 4700                 goto finish;
> 4701         }
>
> Because MD_SB_CHANGE_PENDING is set, so the stripes can't be handled.
>

Right, of course.  I see what is happening now.

=2D raid5d cannot complete stripes until the metadata is written
=2D the metadata cannot be written until raid5d gets the mddev_lock
=2D mddev_lock is held by the write to suspend_hi
=2D the write to suspend_hi is waiting for raid5_quiesce
=2D raid5_quiesce is waiting for some stripes to complete.

We could declare that ->quiesce(, 1) cannot be called while holding the
lock.
We could possible allow it but only if md_update_sb() is called first,
though that might still be racy.

=2D>quiesce(, 1) is currently called from:
 mddev_suspend
 suspend_lo_store
 suspend_hi_store
 __md_stop_writes
 mddev_detach
 set_bitmap_file
 update_array_info (when setting/removing internal bitmap)
 md_do_sync

and most of those are call with the lock held, or take the lock.

Maybe we should *require* that mddev_lock is held when calling
=2D>quiesce() and have ->quiesce() do the metadata update.

Something like the following maybe.  Can you test it?
Thanks,
NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b01e458d31e9..999ccf08c5db 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5805,9 +5805,11 @@ void md_stop(struct mddev *mddev)
 	/* stop the array and free an attached data structures.
 	 * This is called from dm-raid
 	 */
+	mddev_lock_nointr(mddev);
 	__md_stop(mddev);
 	if (mddev->bio_set)
 		bioset_free(mddev->bio_set);
+	mddev_unlock(mddev);
 }
=20
 EXPORT_SYMBOL_GPL(md_stop);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0fc2748aaf95..cde5a82eb404 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4316,6 +4316,8 @@ static void handle_stripe_expansion(struct r5conf *co=
nf, struct stripe_head *sh)
=20
 			/* place all the copies on one channel */
 			init_async_submit(&submit, 0, tx, NULL, NULL, NULL);
+			WARN_ON(sh2->dev[dd_idx].page !=3D sh2->dev[dd_idx].orig_page);
+			WARN_ON(sh->dev[i].page !=3D sh->dev[i].orig_page);
 			tx =3D async_memcpy(sh2->dev[dd_idx].page,
 					  sh->dev[i].page, 0, 0, STRIPE_SIZE,
 					  &submit);
@@ -8031,7 +8033,10 @@ static void raid5_quiesce(struct mddev *mddev, int s=
tate)
 		wait_event_cmd(conf->wait_for_quiescent,
 				    atomic_read(&conf->active_stripes) =3D=3D 0 &&
 				    atomic_read(&conf->active_aligned_reads) =3D=3D 0,
=2D				    unlock_all_device_hash_locks_irq(conf),
+				    ({unlock_all_device_hash_locks_irq(conf);
+					if (mddev->sb_flags)
+						md_update_sb(mddev, 0);
+				    }),
 				    lock_all_device_hash_locks_irq(conf));
 		conf->quiesce =3D 1;
 		unlock_all_device_hash_locks_irq(conf);

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmt/40ACgkQOeye3VZi
gbkJ9A/6Asd120XttmBoPlXDuHlq5QMIp/9Wg9myw7g9KtpEhOJ0YKpleTeBouja
01jTcrtaSWRsWor4vNe94Y6oh98DYOArRcrwCkQIfMs/pZA+2DfOD80MdswIe7wE
LXj3J+0hBaBq/Zy23urZZCpjp0RFpL6WFgWZVT0gPqpczd8Y0XfHgD81+yC2Lli7
Z3JS90apZuypht6kANd96YJbSfXPCc5e73naGciMfpD1GKk1T7OaY4dZ4BkExYvc
T0c/fM/oZz5yv0JY9nC+t6fxGsUbFMWVYC+VQuRBt2C8aet60JozgTjDJEq2sCVA
rvAZVJFcy47z3cI3CvcUXxgi2NcW/wCdO5FfBBM/P3ew6jSO2Ol2txZjLJmblhA+
DRYYovnAFo4ACI//B3te1K2QAufBKUjXMskx20nT5qfS0i3nteIScv4QplvX576D
jLCCZK92sPetnebrXCz0s551oPBio6vCEw+dxL9DY9d7B85QlMtw1SHQ2fyz1D2V
H/bMoyYY3AkweoQ5u8VNz/sc4iIdQUWjXRUbs3aAb3FTxf7BWeATpI3w0bQYkYKZ
l9CfGhYSJn5QnMr45cZkGjzinZnDpNCV0ltLsj8TINQctaH6DMIG+aqU8dKXJKYp
16WyfjLLxNFoajJCXinxXY5Hpd3aU8WLb6EYCuMjQlDYALuYF6U=
=F6Hy
-----END PGP SIGNATURE-----
--=-=-=--
