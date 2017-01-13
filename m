From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 3/4] md/raid5: move comment of fetch_block to right location
Date: Thu, 12 Jan 2017 17:22:42 -0800
Message-ID: <20170113012243.3246467-3-songliubraving@fb.com>
References: <20170113012243.3246467-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170113012243.3246467-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3e75289..d07a319 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3353,13 +3353,6 @@ static int want_replace(struct stripe_head *sh, int disk_idx)
 	return rv;
 }
 
-/* fetch_block - checks the given member device to see if its data needs
- * to be read or computed to satisfy a request.
- *
- * Returns 1 when no more member devices need to be checked, otherwise returns
- * 0 to tell the loop in handle_stripe_fill to continue
- */
-
 static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 			   int disk_idx, int disks)
 {
@@ -3450,6 +3443,12 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 	return 0;
 }
 
+/* fetch_block - checks the given member device to see if its data needs
+ * to be read or computed to satisfy a request.
+ *
+ * Returns 1 when no more member devices need to be checked, otherwise returns
+ * 0 to tell the loop in handle_stripe_fill to continue
+ */
 static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
 		       int disk_idx, int disks)
 {
-- 
2.9.3

