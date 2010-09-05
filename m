From: Kulikov Vasiliy <segooon@gmail.com>
Subject: [PATCH] md: do not use ++ in rcu_dereference() argument
Date: Sun,  5 Sep 2010 22:32:18 +0400
Message-ID: <1283711539-7123-1-git-send-email-segooon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>, Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

=46rom: Vasiliy Kulikov <segooon@gmail.com>

rcu_dereference() is macro, so it might use its argument twice.
Argument must not has side effects.

It was found by compiler warning:
drivers/md/raid1.c: In function =E2=80=98read_balance=E2=80=99:
drivers/md/raid1.c:445: warning: operation on =E2=80=98new_disk=E2=80=99=
 may be undefined

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 drivers/md/raid1.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ad83a4d..12194df 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -442,7 +442,7 @@ static int read_balance(conf_t *conf, r1bio_t *r1_b=
io)
 		     r1_bio->bios[new_disk] =3D=3D IO_BLOCKED ||
 		     !rdev || !test_bit(In_sync, &rdev->flags)
 			     || test_bit(WriteMostly, &rdev->flags);
-		     rdev =3D rcu_dereference(conf->mirrors[++new_disk].rdev)) {
+		     rdev =3D rcu_dereference(conf->mirrors[new_disk].rdev)) {
=20
 			if (rdev && test_bit(In_sync, &rdev->flags) &&
 				r1_bio->bios[new_disk] !=3D IO_BLOCKED)
@@ -452,6 +452,7 @@ static int read_balance(conf_t *conf, r1bio_t *r1_b=
io)
 				new_disk =3D wonly_disk;
 				break;
 			}
+			new_disk++;
 		}
 		goto rb_out;
 	}
--=20
1.7.0.4
