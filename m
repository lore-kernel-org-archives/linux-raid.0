From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] md/raid: Replace a seq_printf() call by seq_putc() in three
 functions
Date: Mon, 1 Jul 2019 17:28:13 +0200
Message-ID: <50f0f51c-16c6-8d31-b265-8a007e6f7251@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 1 Jul 2019 17:10:13 +0200

A single character (depending on a condition check) should be put
into a sequence. Thus use the corresponding function =E2=80=9Cseq_putc=E2=
=80=9D.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/md/raid1.c  | 4 ++--
 drivers/md/raid10.c | 3 ++-
 drivers/md/raid5.c  | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 34e26834ad28..769d79a1d2cf 100644
=2D-- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1597,7 +1597,7 @@ static void raid1_status(struct seq_file *seq, struc=
t mddev *mddev)
 	rcu_read_lock();
 	for (i =3D 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev =3D rcu_dereference(conf->mirrors[i].rdev);
-		seq_printf(seq, "%s",
-			   rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
+		seq_putc(seq,
+			 rdev && test_bit(In_sync, &rdev->flags) ? 'U' : '_');
 	}
 	rcu_read_unlock();
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8a1354a08a1a..4e7da5dcbf86 100644
=2D-- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1572,6 +1572,7 @@ static void raid10_status(struct seq_file *seq, stru=
ct mddev *mddev)
 	rcu_read_lock();
 	for (i =3D 0; i < conf->geo.raid_disks; i++) {
 		struct md_rdev *rdev =3D rcu_dereference(conf->mirrors[i].rdev);
-		seq_printf(seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "=
_");
+		seq_putc(seq,
+			 rdev && test_bit(In_sync, &rdev->flags) ? 'U' : '_');
 	}
 	rcu_read_unlock();
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3de4e13bde98..4b0e93869801 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7510,6 +7510,7 @@ static void raid5_status(struct seq_file *seq, struc=
t mddev *mddev)
 	rcu_read_lock();
 	for (i =3D 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev =3D rcu_dereference(conf->disks[i].rdev);
-		seq_printf (seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : =
"_");
+		seq_putc(seq,
+			 rdev && test_bit(In_sync, &rdev->flags) ? 'U' : '_');
 	}
 	rcu_read_unlock();
=2D-
2.22.0
