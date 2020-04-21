From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH RFC v2 2/8] md/raid5: add a member of r5pages for struct stripe_head
Date: Tue, 21 Apr 2020 20:39:46 +0800
Message-ID: <20200421123952.49025-3-yuyufen@huawei.com>
References: <20200421123952.49025-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200421123952.49025-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, colyli@suse.de, xni@redhat.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

Since grow_buffers() uses alloc_page() allocate the buffers for each
stripe_head(), means, it will allocate 64K buffers and just use 4K
of them, after setting STRIPE_SIZE as 4096.

To avoid waste memory, we try to contain multiple 'page' of sh->dev
into one real page. That means, multiple sh->dev[i].page will point to
the only page with different offset. Example of 64K PAGE_SIZE and
4K STRIPE_SIZE as following:

                    64K PAGE_SIZE
          +---+---+---+---+------------------------------+
          |   |   |   |   |
          |   |   |   |   |
          +-+-+-+-+-+-+-+-+------------------------------+
            ^   ^   ^   ^
            |   |   |   +----------------------------+
            |   |   |                                |
            |   |   +-------------------+            |
            |   |                       |            |
            |   +----------+            |            |
            |              |            |            |
            +-+            |            |            |
              |            |            |            |
        +-----+-----+------+-----+------+-----+------+------+
sh      | offset(0) | offset(4K) | offset(8K) | offset(16K) |
 +      +-----------+------------+------------+-------------+
 +----> dev[0].page  dev[1].page  dev[2].page  dev[3].page

After compressing pages, the users of sh->dev[i].page need to be take care:

  1) When issue bio of stripe_head, bi_io_vec.bv_page will point to
     the page directly. So, we should make sure bv_offset been set with
     correct offset.

  2) When compute xor, the page will be passed to computer function.
     So, we also need to pass offset of that page to computer. Let it
     compute correct location of each sh->dev[i].page.

This patch will add a new member of r5pages in stripe_head to manage
all pages needed by each sh->dev[i]. We also add 'offset' for each r5dev
so that users can get related page offset easily. And add helper function
to get page and it's index in r5pages array by disk index. This is patch
in preparation for fallowing changes.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.h | 56 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index b0010991bdc8..6296578e9585 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -246,6 +246,13 @@ struct stripe_head {
 		int 		     target, target2;
 		enum sum_check_flags zero_sum_result;
 	} ops;
+
+	/* These pages will be used by bios in dev[i] */
+	struct r5pages {
+		struct page	**page;
+		int	size; /* page array size */
+	} pages;
+
 	struct r5dev {
 		/* rreq and rvec are used for the replacement device when
 		 * writing data to both devices.
@@ -253,6 +260,7 @@ struct stripe_head {
 		struct bio	req, rreq;
 		struct bio_vec	vec, rvec;
 		struct page	*page, *orig_page;
+		unsigned int	offset;		/* offset of this page */
 		struct bio	*toread, *read, *towrite, *written;
 		sector_t	sector;			/* sector of this page */
 		unsigned long	flags;
@@ -754,6 +762,54 @@ static inline int algorithm_is_DDF(int layout)
 	return layout >= 8 && layout <= 10;
 }
 
+/*
+ * Return corresponding page index of r5pages array.
+ */
+static inline int raid5_get_page_index(struct stripe_head *sh, int disk_idx)
+{
+	WARN_ON(!sh->pages.page);
+	if (disk_idx >= sh->raid_conf->pool_size)
+		return -ENOENT;
+
+	return (disk_idx * STRIPE_SIZE) / PAGE_SIZE;
+}
+
+/*
+ * Return offset of the corresponding page for r5dev.
+ */
+static inline int raid5_get_page_offset(struct stripe_head *sh, int disk_idx)
+{
+	WARN_ON(!sh->pages.page);
+	if (disk_idx >= sh->raid_conf->pool_size)
+		return -ENOENT;
+
+	return (disk_idx * STRIPE_SIZE) % PAGE_SIZE;
+}
+
+/*
+ * Return corresponding page address for r5dev.
+ */
+static inline struct page *
+raid5_get_dev_page(struct stripe_head *sh, int disk_idx)
+{
+	int idx;
+
+	WARN_ON(!sh->pages.page);
+	idx = raid5_get_page_index(sh, disk_idx);
+	return sh->pages.page[idx];
+}
+
+/*
+ * We want to 'compress' multiple buffers to one real page for
+ * stripe_head when PAGE_SIZE is biggger than STRIPE_SIZE. If their
+ * values are equal, no need to use this strategy. For now, it just
+ * support raid level less than 5.
+ */
+static inline int raid5_compress_stripe_pages(struct r5conf *conf)
+{
+	return (PAGE_SIZE > STRIPE_SIZE) && (conf->level < 6);
+}
+
 extern void md_raid5_kick_device(struct r5conf *conf);
 extern int raid5_set_cache_size(struct mddev *mddev, int size);
 extern sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous);
-- 
2.21.1
