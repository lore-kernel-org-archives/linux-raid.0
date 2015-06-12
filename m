From: NeilBrown <neilb@suse.de>
Subject: [GIT PULL REQUEST] one last md update for 4.1
Date: Fri, 12 Jun 2015 20:23:01 +1000
Message-ID: <20150612202301.17513c1b@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6BTb6sA.v4csqrA8Sd78Zcq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, linux RAID <linux-raid@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/6BTb6sA.v4csqrA8Sd78Zcq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hasn't been a good cycle for md has it :-(
This pull request includes the fix for the hang I mentioned in my last
pull request, and another little bug.
4.2 should be much quieter

Thanks,
NeilBrown



The following changes since commit c65b99f046843d2455aa231747b5a07a999a9f3d:

  Linux 4.1-rc6 (2015-05-31 19:01:07 -0700)

are available in the git repository at:

  git://neil.brown.name/md tags/md/4.1-rc7-fixes

for you to fetch changes up to ea358cd0d2c634ff1379a1392edcdf2289f31e13:

  md: make sure MD_RECOVERY_DONE is clear before starting recovery/resync (=
2015-06-12 20:16:33 +1000)

----------------------------------------------------------------
Three more md fixes for 4.1

The main issue fixed here is a rare race which can result in two reshape
threads running at once, which doesn't end well.
Also a minor issue with a write to a sysfs file returning the wrong value.
Backports to 4.0-stable are indicated.

----------------------------------------------------------------
NeilBrown (3):
      md: don't return 0 from array_state_store
      md: Close race when setting 'action' to 'idle'.
      md: make sure MD_RECOVERY_DONE is clear before starting recovery/resy=
nc

 drivers/md/md.c     | 14 ++++++++------
 drivers/md/raid10.c |  1 +
 drivers/md/raid5.c  |  1 +
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 27506302eb7a..4dbed4a67aaf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3834,7 +3834,7 @@ array_state_store(struct mddev *mddev, const char *bu=
f, size_t len)
 				err =3D -EBUSY;
 		}
 		spin_unlock(&mddev->lock);
-		return err;
+		return err ?: len;
 	}
 	err =3D mddev_lock(mddev);
 	if (err)
@@ -4217,13 +4217,14 @@ action_store(struct mddev *mddev, const char *page,=
 size_t len)
 			set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		else
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-		flush_workqueue(md_misc_wq);
-		if (mddev->sync_thread) {
-			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			if (mddev_lock(mddev) =3D=3D 0) {
+		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
+		    mddev_lock(mddev) =3D=3D 0) {
+			flush_workqueue(md_misc_wq);
+			if (mddev->sync_thread) {
+				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 				md_reap_sync_thread(mddev);
-				mddev_unlock(mddev);
 			}
+			mddev_unlock(mddev);
 		}
 	} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
 		   test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
@@ -8261,6 +8262,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	if (mddev_is_clustered(mddev))
 		md_cluster_ops->metadata_update_finish(mddev);
 	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e793ab6b3570..f55c3f35b746 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4156,6 +4156,7 @@ static int raid10_start_reshape(struct mddev *mddev)
=20
 	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
=20
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 553d54b87052..b6793d2e051f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7354,6 +7354,7 @@ static int raid5_start_reshape(struct mddev *mddev)
=20
 	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 	mddev->sync_thread =3D md_register_thread(md_do_sync, mddev,

--Sig_/6BTb6sA.v4csqrA8Sd78Zcq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVXqzBTnsnt1WYoG5AQKvdRAArDyASiUEc2JEjLtupf/B175eeYiH+Q+r
eIPIoaLXU6LGAdNwSVjsjZA1Ni08ujDFdVm2oLcPyj97gPaGWDTqnDv5j5bpHLJc
rkieUI2jdjBfUxn/KAdBIldnZEN4zKJ+XO4whT0OOx/34nSgV64DJ7yMOvmtm5qE
Y7dTuczajsNEpo9+Xew0rRYgcg4J51DP5sMBo/rE2HwUvmo9xs7fVmWTq4GMXXf7
WUmgJgkU1CTuC6GWT+qcN7X/sNIw7ciHmq9/ciUmhf/7tvZngebq+iawdtd1MTib
Nb/aQqu/Tgr2LS68mJ+50hMZlyfqcnYdPFoUWZBUj0axhb8az4VBdQ8X7nnkPCNb
GEg7bFGVMQ8j2lbMBcCm/54IjV+TWnsFdzrBf1ELUohBV2GWxtYWq/m3V0DdIHJH
h5Ma00EAEx8yqpqHb8+pyTOAdoePE7xpopvwga0AdoDkIiIyyn1AFN1rvuGZ9gD/
ITORFw9GGxzi1abnGmZZMB6tHzWiv7kYAcWfwJf9JvByoSX+Edeg6oeQj7IWDb0Z
kUp27tR3gpTN8DWkkzR3QxbZUgbWXLqsWsJ98AbyzPx2P/nPFPJtUNfPQK86C6kd
qLwVuvDZkvQin/Op7460olkUABh/9iM7y9xGISbyd6dq19d4qiloCc2AAk9YT7JE
ceddNLjB2PM=
=SD3j
-----END PGP SIGNATURE-----

--Sig_/6BTb6sA.v4csqrA8Sd78Zcq--
