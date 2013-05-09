From: Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] bcache: Fix incompatible pointer type warning
Date: Thu,  9 May 2013 22:39:26 +0200
Message-ID: <1368131966-17512-1-git-send-email-emilgoode@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: koverstreet@google.com, neilb@suse.de
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
List-Id: linux-raid.ids

The function pointer release in struct block_device_operations
should point to functions declared as void.

Sparse warnings:

drivers/md/bcache/super.c:656:27: warning:
	incorrect type in initializer (different base types)
	drivers/md/bcache/super.c:656:27:
	expected void ( *release )( ... )
	drivers/md/bcache/super.c:656:27:
	got int ( static [toplevel] *<noident> )( ... )

drivers/md/bcache/super.c:656:2: warning:
	initialization from incompatible pointer type [enabled by default]

drivers/md/bcache/super.c:656:2: warning:
	(near initialization for =E2=80=98bcache_ops.release=E2=80=99) [enable=
d by default]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/md/bcache/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 76c7f6c..938bbff 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -637,11 +637,10 @@ static int open_dev(struct block_device *b, fmode=
_t mode)
 	return 0;
 }
=20
-static int release_dev(struct gendisk *b, fmode_t mode)
+static void release_dev(struct gendisk *b, fmode_t mode)
 {
 	struct bcache_device *d =3D b->private_data;
 	closure_put(&d->cl);
-	return 0;
 }
=20
 static int ioctl_dev(struct block_device *b, fmode_t mode,
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
