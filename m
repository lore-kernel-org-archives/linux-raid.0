From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/13] md/multipath: Use kcalloc() in multipath_run()
Date: Sun, 2 Oct 2016 13:56:33 +0200
Message-ID: <0383a635-6b6d-0e70-c3d5-99c05f2c72f7@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Jens Axboe <axboe@fb.com>, NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 20:40:42 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus reuse the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data structure by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/multipath.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 673efbd..bd53451 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -408,7 +408,8 @@ static int multipath_run (struct mddev *mddev)
 		goto out;
 	}
 
-	conf->multipaths = kzalloc(sizeof(struct multipath_info)*mddev->raid_disks,
+	conf->multipaths = kcalloc(mddev->raid_disks,
+				   sizeof(*conf->multipaths),
 				   GFP_KERNEL);
 	if (!conf->multipaths) {
 		printk(KERN_ERR
-- 
2.10.0
