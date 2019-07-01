From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] md-multipath: Replace a seq_printf() call by seq_putc() in
 multipath_status()
Date: Mon, 1 Jul 2019 13:16:42 +0200
Message-ID: <ad2e4b58-268e-c9e5-8a66-8cb5dee8d91e@web.de>
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
Date: Mon, 1 Jul 2019 13:07:55 +0200

A single character (depending on a condition check) should be put
into a sequence. Thus use the corresponding function =E2=80=9Cseq_putc=E2=
=80=9D.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/md/md-multipath.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index 6780938d2991..3bf6f97ea264 100644
=2D-- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -146,7 +146,8 @@ static void multipath_status(struct seq_file *seq, str=
uct mddev *mddev)
 	rcu_read_lock();
 	for (i =3D 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev =3D rcu_dereference(conf->multipaths[i].rdev);
-		seq_printf (seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : =
"_");
+		seq_putc(seq,
+			 rdev && test_bit(In_sync, &rdev->flags) ? 'U' : '_');
 	}
 	rcu_read_unlock();
 	seq_putc(seq, ']');
=2D-
2.22.0
