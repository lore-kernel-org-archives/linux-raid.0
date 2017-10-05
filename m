From: NeilBrown <neilb@suse.com>
Subject: [PATCH] md: fix deadlock error in recent patch.
Date: Thu, 05 Oct 2017 16:23:16 +1100
Message-ID: <87shey183f.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Linux Raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


A recent patch aimed to cause md_write_start() to fail (rather than
block) when the mddev was suspending, so as to avoid deadlocks.
Unfortunately the test in wait_event() was wrong, and it didn't change
behaviour at all.

We wait_event() must wait until the metadata is written OR the array is
suspending.

Fixes: cc27b0c78c79 ("md: fix deadlock between mddev_suspend() and md_write=
_start()")
Cc: stable@vger.kernel.org
Reported-by: Xiao Ni <xni@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0ff1bbf6c90e..8b2eb0f4122f 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8039,7 +8039,8 @@ bool md_write_start(struct mddev *mddev, struct bio *=
bi)
 	if (did_change)
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	wait_event(mddev->sb_wait,
=2D		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) && !mddev->suspen=
ded);
+		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
+		   mddev->suspended);
 	if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
 		percpu_ref_put(&mddev->writes_pending);
 		return false;
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnVwcQACgkQOeye3VZi
gbnfPBAAkDuSnP5Nj8nQAB0u1tGqiTdkGcFkT2yE5VEwkxAd0SUYzhw5Q6gTBAJm
0HtC2Lz0difCCgvobaTM/6kbhjhGFYNj/4kv8PirD+j6QcHKJudJjqPKbiwBUhxj
rLuBsz9sWNa4gc1WJ+lkqFmMoluxIf6Tx+S8+atyLtKh8S748UXTPrnGYHxzsC2n
PqFs1O9gsXrC6QRTnkQY4/nJ4SSkgpEgC23+6IHig7XrDMEPcp4Y/ATDZ11V1sIS
GEE+zOdfSv+X8wFkDW8El6tIjWGRcnxk7y51SEeJ9AMD9LKifZQvz+8FfgRdXXGi
ccrYzi2nk2QK8YVMl0ZWlC+w9McXhGnB/70Pjs0mfY1tg7vu4bAj+kq3Hepzy36K
cPGnbba24QT1ofbK0wvVJqNBU7CHPFw4BeZJu+eeObymFGvbuc/oiSXpCLb2eK6a
bZI3M0DLeH/SVx1G3AolGuqjKTln9OsaVXYv2EE4ociEltd8BdCA0QcMuGS/Qbt0
Mclp/3NFfqBphpekRZ9heA8jn0O7E/rEIfvz5X2rmV0w5CFMPiOJAuwQ/AUK8I3W
5zxmQNxKPDXMgSlWiginyqHhrUrpCL5E8qGlF2oouykDFseUDhC2ab6f6pPldbEW
j5l02sZa92eTTpauPI41+p1o6iIK6Zh78jbMJRZYHB8jrW20lLE=
=6PJk
-----END PGP SIGNATURE-----
--=-=-=--
