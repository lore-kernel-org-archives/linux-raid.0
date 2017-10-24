From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 1/4] md-cluster/raid10: set "do_balance = 0" if area is resyncing
Date: Tue, 24 Oct 2017 15:11:50 +0800
Message-ID: <20171024071153.5275-2-gqjiang@suse.com>
References: <20171024071153.5275-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171024071153.5275-1-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

Just like clustered raid1, it is impossible for cluster raid10
to choose the best device for read balance when the area of
array is resyncing. Because we cannot trust the data to be the
same on all devices at that time, so we choose just the first
one to use, so set do_balance to 0.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/raid10.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 615f677ceb1a..61890231972e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -759,8 +759,11 @@ static struct md_rdev *read_balance(struct r10conf *conf,
 	 * the resync window. We take the first readable disk when
 	 * above the resync window.
 	 */
-	if (conf->mddev->recovery_cp < MaxSector
-	    && (this_sector + sectors >= conf->next_resync))
+	if ((conf->mddev->recovery_cp < MaxSector
+	     && (this_sector + sectors >= conf->next_resync)) ||
+	    (mddev_is_clustered(conf->mddev) &&
+	     md_cluster_ops->area_resyncing(conf->mddev, READ, this_sector,
+					    this_sector + sectors)))
 		do_balance = 0;
 
 	for (slot = 0; slot < conf->copies ; slot++) {
-- 
2.10.0

