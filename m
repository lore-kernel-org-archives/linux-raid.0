From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata without
Date: Fri, 13 Oct 2017 14:48:41 +1100
Message-ID: <87376nn1wm.fsf@notabene.neil.brown.name>
References: <150518076229.32691.13542756562323866921.stgit@noble> <874lrc28x8.fsf@notabene.neil.brown.name> <1345780738.18087591.1507512089744.JavaMail.zimbra@redhat.com> <87a810zznc.fsf@notabene.neil.brown.name> <441ae9fe-fd73-2aac-8bb1-c64da28cda27@redhat.com> <871smczx4j.fsf@notabene.neil.brown.name> <ebf97c38-c8e0-aa87-be84-efc8d56802f0@redhat.com> <87vajmwvgn.fsf@notabene.neil.brown.name> <960568852.19225619.1507689864371.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <960568852.19225619.1507689864371.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 10 2017, Xiao Ni wrote:
>
> I added the stack traces as an attachment.=20
>

Thanks.  very helpful.
I think I can see the problem.  The following patch might
fix it.
Thanks for your ongoing testing!

NeilBrown

From: NeilBrown <neilb@suse.com>
Date: Fri, 13 Oct 2017 14:46:37 +1100
Subject: [PATCH] md: move suspend_hi/lo handling into core md code

responding to ->suspend_lo and ->suspend_hi is similar
to responding to ->suspended.  It is best to wait in
the common core code without incrementing ->active_io.
This allows mddev_suspend()/mddev_resume() to work while
requesting are waiting for suspend_lo/hi to change.
This is particularly important as the code to update these
values now uses mddev_suspend().

So move the code for testing suspend_lo/hi out of raid1.c
and raid5.c, and place it in md.c

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/md.c    | 29 +++++++++++++++++++++++------
 drivers/md/raid1.c | 12 ++++--------
 drivers/md/raid5.c | 22 ----------------------
 3 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ae531666f127..93ba3a526718 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -266,16 +266,31 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
  * call has finished, the bio has been linked into some internal structure
  * and so is visible to ->quiesce(), so we don't need the refcount any mor=
e.
  */
+static bool is_suspended(struct mddev *mddev, struct bio *bio)
+{
+	if (mddev->suspended)
+		return true;
+	if (bio_data_dir(bio) !=3D WRITE)
+		return false;
+	if (mddev->suspend_lo >=3D mddev->suspend_hi)
+		return false;
+	if (bio->bi_iter.bi_sector >=3D mddev->suspend_hi)
+		return false;
+	if (bio_end_sector(bio) < mddev->suspend_lo)
+		return false;
+	return true;
+}
+
 void md_handle_request(struct mddev *mddev, struct bio *bio)
 {
 check_suspended:
 	rcu_read_lock();
=2D	if (mddev->suspended) {
+	if (is_suspended(mddev, bio)) {
 		DEFINE_WAIT(__wait);
 		for (;;) {
 			prepare_to_wait(&mddev->sb_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
=2D			if (!mddev->suspended)
+			if (!is_suspended(mddev, bio))
 				break;
 			rcu_read_unlock();
 			schedule();
@@ -4854,10 +4869,11 @@ suspend_lo_store(struct mddev *mddev, const char *b=
uf, size_t len)
 		goto unlock;
 	old =3D mddev->suspend_lo;
 	mddev->suspend_lo =3D new;
=2D	if (new >=3D old)
+	if (new >=3D old) {
 		/* Shrinking suspended region */
+		wake_up(&mddev->sb_wait);
 		mddev->pers->quiesce(mddev, 2);
=2D	else {
+	} else {
 		/* Expanding suspended region - need to wait */
 		mddev_suspend(mddev);
 		mddev_resume(mddev);
@@ -4897,10 +4913,11 @@ suspend_hi_store(struct mddev *mddev, const char *b=
uf, size_t len)
 		goto unlock;
 	old =3D mddev->suspend_hi;
 	mddev->suspend_hi =3D new;
=2D	if (new <=3D old)
+	if (new <=3D old) {
 		/* Shrinking suspended region */
+		wake_up(&mddev->sb_wait);
 		mddev->pers->quiesce(mddev, 2);
=2D	else {
+	} else {
 		/* Expanding suspended region - need to wait */
 		mddev_suspend(mddev);
 		mddev_resume(mddev);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f3f3e40dc9d8..277a145b3ff5 100644
=2D-- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1310,11 +1310,9 @@ static void raid1_write_request(struct mddev *mddev,=
 struct bio *bio,
 	 */
=20
=20
=2D	if ((bio_end_sector(bio) > mddev->suspend_lo &&
=2D	    bio->bi_iter.bi_sector < mddev->suspend_hi) ||
=2D	    (mddev_is_clustered(mddev) &&
+	if (mddev_is_clustered(mddev) &&
 	     md_cluster_ops->area_resyncing(mddev, WRITE,
=2D		     bio->bi_iter.bi_sector, bio_end_sector(bio)))) {
+		     bio->bi_iter.bi_sector, bio_end_sector(bio))) {
=20
 		/*
 		 * As the suspend_* range is controlled by userspace, we want
@@ -1325,12 +1323,10 @@ static void raid1_write_request(struct mddev *mddev=
, struct bio *bio,
 			sigset_t full, old;
 			prepare_to_wait(&conf->wait_barrier,
 					&w, TASK_INTERRUPTIBLE);
=2D			if (bio_end_sector(bio) <=3D mddev->suspend_lo ||
=2D			    bio->bi_iter.bi_sector >=3D mddev->suspend_hi ||
=2D			    (mddev_is_clustered(mddev) &&
+			if (mddev_is_clustered(mddev) &&
 			     !md_cluster_ops->area_resyncing(mddev, WRITE,
 				     bio->bi_iter.bi_sector,
=2D				     bio_end_sector(bio))))
+				     bio_end_sector(bio)))
 				break;
 			sigfillset(&full);
 			sigprocmask(SIG_BLOCK, &full, &old);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 51c9dac6e744..1f9f2d80c004 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5685,28 +5685,6 @@ static bool raid5_make_request(struct mddev *mddev, =
struct bio * bi)
 				goto retry;
 			}
=20
=2D			if (rw =3D=3D WRITE &&
=2D			    logical_sector >=3D mddev->suspend_lo &&
=2D			    logical_sector < mddev->suspend_hi) {
=2D				raid5_release_stripe(sh);
=2D				/* As the suspend_* range is controlled by
=2D				 * userspace, we want an interruptible
=2D				 * wait.
=2D				 */
=2D				prepare_to_wait(&conf->wait_for_overlap,
=2D						&w, TASK_INTERRUPTIBLE);
=2D				if (logical_sector >=3D mddev->suspend_lo &&
=2D				    logical_sector < mddev->suspend_hi) {
=2D					sigset_t full, old;
=2D					sigfillset(&full);
=2D					sigprocmask(SIG_BLOCK, &full, &old);
=2D					schedule();
=2D					sigprocmask(SIG_SETMASK, &old, NULL);
=2D					do_prepare =3D true;
=2D				}
=2D				goto retry;
=2D			}
=2D
 			if (test_bit(STRIPE_EXPANDING, &sh->state) ||
 			    !add_stripe_bio(sh, bi, dd_idx, rw, previous)) {
 				/* Stripe is busy expanding or
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlngN5sACgkQOeye3VZi
gbnsrRAAr2WaQjnqNuGLw9DaGOBQCP0Vd82oj3i4t7tXNs7mw+5Qqpiulj9xtcpK
ynbBmwH2wpxl8uAZ7tvqQyMWocY6V4dLt9FlVQZIZZ5bDtJvHcS5T/RHuiYwovLF
DlMutIPaeiZGGFxxvALBDoR5mJVDwj7t6jaUXIgZPuJfanCVL/eMLowcA0nwZUv4
SCC2IfiG6Q1bqRMQbK/3Q6CbcMhNuxDvVaYsdF9BrQjOqklPTZ+XMI3dZyaBVVN3
w0cu/pQxYYTatNBXcXCBEWEMJMeub+jqGSLCm71zNRkz9gAcNFO1S0mA07/c4u+e
D2G6ubbZ940s/abHDGDm9vrm3kS+42i83DZRoPd46mUvjB6Jm8Kty2ougO3m6/KW
AaZkBods0vrVzeRrixIEa0SHVYbszSj/kxfhM6vuYceIKPbF8bJQf/HSymoH8j14
KoqJYMT0VNh2v7IYU1shKRSkOVlV5XAtX711H4DUBOrMeAPpLGnv0RG8/fMi7WsO
vrbLGy4alYylqrArJdJ/RVUz0XsxyMpj10tTlw3IEUx+qWuh5QNHuamFcUgmbi5C
/F1xBubGfRo2lYg4u7vhOvi/zB8Ai3DP/cc/ghJhwB8nQDyT5g563579ikIYxmNc
ySb985fdbd9o2xNUYchz6N437+ST3q+hlk90tTZTraw6N2H0oCk=
=4uz+
-----END PGP SIGNATURE-----
--=-=-=--
