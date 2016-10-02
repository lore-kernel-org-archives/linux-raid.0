From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 7/13] md/multipath: Delete two unwanted spaces behind
 asterisks
Date: Sun, 2 Oct 2016 14:03:12 +0200
Message-ID: <427b06a9-32a2-66d2-73d8-b480754010a7@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Jens Axboe <axboe@fb.com>, NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 2 Oct 2016 09:39:39 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/multipath.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 7e10603..cb5141f 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -106,10 +106,10 @@ static void multipath_end_request(struct bio *bio)
 	rdev_dec_pending(rdev, conf->mddev);
 }
 
-static void multipath_make_request(struct mddev *mddev, struct bio * bio)
+static void multipath_make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct mpconf *conf = mddev->private;
-	struct multipath_bh * mp_bh;
+	struct multipath_bh *mp_bh;
 	struct multipath_info *multipath;
 
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
-- 
2.10.0

