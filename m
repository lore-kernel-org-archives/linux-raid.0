From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 5/6] md/raid5: move comment of fetch_block to right location
Date: Wed, 14 Dec 2016 15:38:05 -0800
Message-ID: <20161214233806.4137850-5-songliubraving@fb.com>
References: <20161214233806.4137850-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161214233806.4137850-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 760af2e..0f25d84 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3309,13 +3309,6 @@ static int want_replace(struct stripe_head *sh, int disk_idx)
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
@@ -3406,6 +3399,12 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
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

