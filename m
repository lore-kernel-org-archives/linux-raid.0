From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 31/54] md/raid5: Adjust two function calls together with a
 variable assignment
Date: Thu, 6 Oct 2016 11:31:11 +0200
Message-ID: <529972b2-5251-4cb5-e5cb-70de6628fe71@users.sourceforge.net>
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
Date: Wed, 5 Oct 2016 10:00:07 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: do not use assignment in if condition

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid5.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ef180c0..a37f1f9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -501,11 +501,10 @@ static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
 	int num = sh->raid_conf->pool_size;
 
 	for (i = 0; i < num; i++) {
-		struct page *page;
+		struct page *page = alloc_page(gfp);
 
-		if (!(page = alloc_page(gfp))) {
+		if (!page)
 			return 1;
-		}
 		sh->dev[i].page = page;
 		sh->dev[i].orig_page = page;
 	}
@@ -6525,8 +6524,8 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		goto free_conf;
 
 	conf->mddev = mddev;
-
-	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
+	conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!conf->stripe_hashtbl)
 		goto free_conf;
 
 	/* We init hash_locks[0] separately to that it can be used
-- 
2.10.1
