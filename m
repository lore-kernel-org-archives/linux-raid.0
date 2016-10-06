From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v3 1/8] md/r5cache: Check array size in r5l_init_log
Date: Thu, 6 Oct 2016 00:14:09 -0700
Message-ID: <20161006071416.3295093-2-songliubraving@fb.com>
References: <20161006071416.3295093-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161006071416.3295093-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Currently, r5l_write_stripe checks meta size for each stripe write,
which is not necessary.

With this patch, r5l_init_log checks maximal meta size of the array,
which is (r5l_meta_block + raid_disks x r5l_payload_data_parity).
If this is too big to fit in one page, r5l_init_log aborts.

With current meta data, r5l_log support raid_disks up to 203.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 1b1ab4a..7557791b 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -441,7 +441,6 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 {
 	int write_disks = 0;
 	int data_pages, parity_pages;
-	int meta_size;
 	int reserve;
 	int i;
 	int ret = 0;
@@ -473,15 +472,6 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	parity_pages = 1 + !!(sh->qd_idx >= 0);
 	data_pages = write_disks - parity_pages;
 
-	meta_size =
-		((sizeof(struct r5l_payload_data_parity) + sizeof(__le32))
-		 * data_pages) +
-		sizeof(struct r5l_payload_data_parity) +
-		sizeof(__le32) * parity_pages;
-	/* Doesn't work with very big raid array */
-	if (meta_size + sizeof(struct r5l_meta_block) > PAGE_SIZE)
-		return -EINVAL;
-
 	set_bit(STRIPE_LOG_TRAPPED, &sh->state);
 	/*
 	 * The stripe must enter state machine again to finish the write, so
@@ -1184,6 +1174,22 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 
 	if (PAGE_SIZE != 4096)
 		return -EINVAL;
+
+	/*
+	 * The PAGE_SIZE must be big enough to hold 1 r5l_meta_block and
+	 * raid_disks r5l_payload_data_parity.
+	 *
+	 * Write journal and cache does not work for very big array
+	 * (raid_disks > 203)
+	 */
+	if (sizeof(struct r5l_meta_block) +
+	    ((sizeof(struct r5l_payload_data_parity) + sizeof(__le32)) *
+	     conf->raid_disks) > PAGE_SIZE) {
+		pr_err("md/raid:%s: write journal/cache doesn't work for array with %d disks\n",
+		       mdname(conf->mddev), conf->raid_disks);
+		return -EINVAL;
+	}
+
 	log = kzalloc(sizeof(*log), GFP_KERNEL);
 	if (!log)
 		return -ENOMEM;
-- 
2.9.3

