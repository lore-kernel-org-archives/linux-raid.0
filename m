From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 1/5 v2] md: always hold reconfig_mutex when calling mddev_suspend()
Date: Thu, 19 Oct 2017 12:17:16 +1100
Message-ID: <87lgk8gcmb.fsf@notabene.neil.brown.name>
References: <150820826980.1646.6380214598725492144.stgit@noble> <150820840340.1646.12365558035859364361.stgit@noble> <20171018061107.42kpztc3nbnhbavi@kernel.org> <87efq0j4d2.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87efq0j4d2.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Most often mddev_suspend() is called with
reconfig_mutex held.  Make this a requirement in
preparation a subsequent patch.  Also require
reconfig_mutex to be held for mddev_resume(),
partly for symmetry and partly to guarantee
no races with incr/decr of mddev->suspend.

Taking the mutex in r5c_disable_writeback_async() is
a little tricky as this is called from a work queue
via log->disable_writeback_work, and flush_work()
is called on that while holding ->reconfig_mutex.
If the work item hasn't run before flush_work()
is called, the work function will not be able to
get the mutex.

So we use mddev_trylock() inside the wait_event() call, and have that
abort when conf->log is set to NULL, which happens before
flush_work() is called.
We wait in mddev->sb_wait and ensure this is woken
when any of the conditions change.  This requires
waking mddev->sb_wait in mddev_unlock().  This is only
like to trigger extra wake_ups of threads that needn't
be woken when metadata is being written, and that
doesn't happen often enough that the cost would be
noticeable.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--

I decided I would just wake_up(&mddev->sb_wait) in mddev_unlock().
It isn't that bad, and every other idea I came up with was worse.

I also now require reconfig_mutex on mddev_resume().  That
ensures the mddev->suspended counted never has races.

Thanks,
NeilBrown


 drivers/md/dm-raid.c     | 10 ++++++++--
 drivers/md/md.c          |  3 +++
 drivers/md/raid5-cache.c | 18 +++++++++++++-----
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 2245d06d2045..49d2193602a5 100644
=2D-- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3629,8 +3629,11 @@ static void raid_postsuspend(struct dm_target *ti)
 {
 	struct raid_set *rs =3D ti->private;
=20
=2D	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags))
+	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
+		mddev_lock_nointr(&rs->md);
 		mddev_suspend(&rs->md);
+		mddev_unlock(&rs->md);
+	}
=20
 	rs->md.ro =3D 1;
 }
@@ -3887,8 +3890,11 @@ static void raid_resume(struct dm_target *ti)
 	if (!(rs->ctr_flags & RESUME_STAY_FROZEN_FLAGS))
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
=20
=2D	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags))
+	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
+		mddev_lock_nointr(mddev);
 		mddev_resume(mddev);
+		mddev_unlock(mddev);
+	}
 }
=20
 static struct target_type raid_target =3D {
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0ff1bbf6c90e..b664dc252106 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -344,6 +344,7 @@ static blk_qc_t md_make_request(struct request_queue *q=
, struct bio *bio)
 void mddev_suspend(struct mddev *mddev)
 {
 	WARN_ON_ONCE(mddev->thread && current =3D=3D mddev->thread->tsk);
+	lockdep_assert_held(&mddev->reconfig_mutex);
 	if (mddev->suspended++)
 		return;
 	synchronize_rcu();
@@ -357,6 +358,7 @@ EXPORT_SYMBOL_GPL(mddev_suspend);
=20
 void mddev_resume(struct mddev *mddev)
 {
+	lockdep_assert_held(&mddev->reconfig_mutex);
 	if (--mddev->suspended)
 		return;
 	wake_up(&mddev->sb_wait);
@@ -663,6 +665,7 @@ void mddev_unlock(struct mddev *mddev)
 	 */
 	spin_lock(&pers_lock);
 	md_wakeup_thread(mddev->thread);
+	wake_up(&mddev->sb_wait);
 	spin_unlock(&pers_lock);
 }
 EXPORT_SYMBOL_GPL(mddev_unlock);
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 0b7406ac8ce1..6a631dd21f0b 100644
=2D-- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -693,6 +693,8 @@ static void r5c_disable_writeback_async(struct work_str=
uct *work)
 	struct r5l_log *log =3D container_of(work, struct r5l_log,
 					   disable_writeback_work);
 	struct mddev *mddev =3D log->rdev->mddev;
+	struct r5conf *conf =3D mddev->private;
+	int locked =3D 0;
=20
 	if (log->r5c_journal_mode =3D=3D R5C_JOURNAL_MODE_WRITE_THROUGH)
 		return;
@@ -701,11 +703,15 @@ static void r5c_disable_writeback_async(struct work_s=
truct *work)
=20
 	/* wait superblock change before suspend */
 	wait_event(mddev->sb_wait,
=2D		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
=2D
=2D	mddev_suspend(mddev);
=2D	log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_THROUGH;
=2D	mddev_resume(mddev);
+		   conf->log =3D=3D NULL ||
+		   (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) &&
+		    (locked =3D mddev_trylock(mddev))));
+	if (locked) {
+		mddev_suspend(mddev);
+		log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_THROUGH;
+		mddev_resume(mddev);
+		mddev_unlock(mddev);
+	}
 }
=20
 static void r5l_submit_current_io(struct r5l_log *log)
@@ -3165,6 +3171,8 @@ void r5l_exit_log(struct r5conf *conf)
 	conf->log =3D NULL;
 	synchronize_rcu();
=20
+	/* Ensure disable_writeback_work wakes up and exits */
+	wake_up(&conf->mddev->sb_wait);
 	flush_work(&log->disable_writeback_work);
 	md_unregister_thread(&log->reclaim_thread);
 	mempool_destroy(log->meta_pool);
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnn/R4ACgkQOeye3VZi
gbk3og//afcL8+dt4M+Wb9bZRruj19FxoESLVnY9JOP47O+CYqXAo8AEsAjtlUtC
Y1d1OeJkDjeCVUpe0T+a1AK6xoPZ52n2Qb4npc/pN98B4LZj9sMAgNxDQUvgEZa/
76tqt7RMlQ+OLIhJoMxAzJQJp2KVrat5Mb2UfzLk4cXbPQ2JMS6Jcr/M1ldjzuUU
pQOK83FbA3yFiSNxqKYsOeRDyFXD3FW5BNOWGKNSqzCH/QNIU5YMW9eiu4cwewjS
tDsNQPLiWkNsyXqfH2l+WLP5gfhD+8kDj6FgcA/zN2mbZoi3bXX7va4gmXaxp4lx
nZ7ULMEi0tYKMOBXOqoVbc5MedaTAu8kac5WlkHkyIPT5FTiJIC9VNPtPnaVOe91
WTFmaXx5mPAdDgs8dgoQYSR+PQbOSWwqGLvt+9G2YfDzO0ciYXEv7DTspNguge3R
5AY4olnt0fZTBVykHYFjKrNaSvn4Aex9x8ZWD9ePNQ4f3CARMm9Uj4sEegYvqztv
0QyDNJIDY9GjlQlQvtwqzjGSJG/qvTBEOgofqDOz8BOMVEpDwpCs8naLBn3j/k+6
Pr+Km0c5TfP8GCI4id750hNFoVe4OLQOU3vNBd7iZYIMVJTxa1GqXmLmZ0bsidCP
El5Ud9RlBkxVyEAtB4e7zGJcqslI+MfMSrUw28wck955Cx9dkvc=
=pAoI
-----END PGP SIGNATURE-----
--=-=-=--
