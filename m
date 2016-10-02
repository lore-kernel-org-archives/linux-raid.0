From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 12/13] md/multipath: Delete an unnecessary return statement in
 multipath_make_request()
Date: Sun, 2 Oct 2016 14:09:23 +0200
Message-ID: <5a9f8014-6eec-fba1-4e33-37d6b83da8db@users.sourceforge.net>
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
Date: Sun, 2 Oct 2016 10:55:06 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: void function return statements are not generally useful

Thus remove such a statement here.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/multipath.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index ab6487c..85f6c85 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -139,7 +139,6 @@ static void multipath_make_request(struct mddev *mddev, struct bio *bio)
 	mp_bh->bio.bi_end_io = multipath_end_request;
 	mp_bh->bio.bi_private = mp_bh;
 	generic_make_request(&mp_bh->bio);
-	return;
 }
 
 static void multipath_status(struct seq_file *seq, struct mddev *mddev)
-- 
2.10.0

