From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 25/54] md/raid5: Use kcalloc() in three functions
Date: Thu, 6 Oct 2016 11:23:52 +0200
Message-ID: <820e039e-c1bc-5586-f4f8-cf3d0ca71604@users.sourceforge.net>
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
Date: Tue, 4 Oct 2016 22:30:12 +0200

* Multiplications for the size determination of memory allocations
  indicated that array data structures should be processed.
  Thus use the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of data structures by pointer dereferences
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

* Delete the local variable "size" which became unnecessary with
  this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid5.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 92ac251..9a43006 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2243,7 +2243,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 	 * is completely stalled, so now is a good time to resize
 	 * conf->disks and the scribble region
 	 */
-	ndisks = kzalloc(newsize * sizeof(struct disk_info), GFP_NOIO);
+	ndisks = kcalloc(newsize, sizeof(*ndisks), GFP_NOIO);
 	if (ndisks) {
 		for (i=0; i<conf->raid_disks; i++)
 			ndisks[i] = conf->disks[i];
@@ -6255,7 +6255,6 @@ static int alloc_thread_groups(struct r5conf *conf, int cnt,
 			       struct r5worker_group **worker_groups)
 {
 	int i, j, k;
-	ssize_t size;
 	struct r5worker *workers;
 
 	*worker_cnt_per_group = cnt;
@@ -6265,10 +6264,8 @@ static int alloc_thread_groups(struct r5conf *conf, int cnt,
 		return 0;
 	}
 	*group_cnt = num_possible_nodes();
-	size = sizeof(struct r5worker) * cnt;
-	workers = kzalloc(size * *group_cnt, GFP_NOIO);
-	*worker_groups = kzalloc(sizeof(struct r5worker_group) *
-				*group_cnt, GFP_NOIO);
+	workers = kcalloc(cnt * *group_cnt, sizeof(*workers), GFP_NOIO);
+	*worker_groups = kcalloc(*group_cnt, sizeof(**worker_groups), GFP_NOIO);
 	if (!*worker_groups || !workers) {
 		kfree(workers);
 		kfree(*worker_groups);
@@ -6519,9 +6516,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	else
 		conf->previous_raid_disks = mddev->raid_disks - mddev->delta_disks;
 	max_disks = max(conf->raid_disks, conf->previous_raid_disks);
-
-	conf->disks = kzalloc(max_disks * sizeof(struct disk_info),
-			      GFP_KERNEL);
+	conf->disks = kcalloc(max_disks, sizeof(*conf->disks), GFP_KERNEL);
 	if (!conf->disks)
 		goto abort;
 
-- 
2.10.1
