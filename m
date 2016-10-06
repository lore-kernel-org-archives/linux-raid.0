From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 29/54] md/raid5: Return directly after a failed kcalloc() in
 alloc_thread_groups()
Date: Thu, 6 Oct 2016 11:29:09 +0200
Message-ID: <5130f28f-7b24-54bd-a90d-37f305cca1be@users.sourceforge.net>
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
Date: Wed, 5 Oct 2016 08:54:40 +0200

The kfree() function was called in up to two cases
by the alloc_thread_groups() function during error handling
even if the passed variable contained a null pointer.

* Return directly after a call of the kcalloc() function failed
  at the beginning.

* Simplify a condition check for memory allocation failures.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid5.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b624ba6..d864871 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6265,10 +6265,12 @@ static int alloc_thread_groups(struct r5conf *conf, int cnt,
 	}
 	*group_cnt = num_possible_nodes();
 	workers = kcalloc(cnt * *group_cnt, sizeof(*workers), GFP_NOIO);
+	if (!workers)
+		return -ENOMEM;
+
 	*worker_groups = kcalloc(*group_cnt, sizeof(**worker_groups), GFP_NOIO);
-	if (!*worker_groups || !workers) {
+	if (!*worker_groups) {
 		kfree(workers);
-		kfree(*worker_groups);
 		return -ENOMEM;
 	}
 
-- 
2.10.1
