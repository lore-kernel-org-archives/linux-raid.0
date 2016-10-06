From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 34/54] md/raid5: Delete indentation for two jump labels
Date: Thu, 6 Oct 2016 11:34:03 +0200
Message-ID: <5d3faaa0-0f0b-c061-087e-9ba477f3d11d@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Oct 2016 13:45:18 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: labels should not be indented

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid5.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b0a14a6..4debd86 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5089,7 +5089,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	     logical_sector += STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
 		int d;
-	again:
+again:
 		sh = raid5_get_active_stripe(conf, logical_sector, 0, 0, 0);
 		prepare_to_wait(&conf->wait_for_overlap, &w,
 				TASK_UNINTERRUPTIBLE);
@@ -5204,7 +5204,7 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 		int seq;
 
 		do_prepare = false;
-	retry:
+retry:
 		seq = read_seqcount_begin(&conf->gen_lock);
 		previous = 0;
 		if (do_prepare)
-- 
2.10.1
