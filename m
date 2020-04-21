From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH RFC v2 4/8] md/raid5: set correct page offset for bi_io_vec in ops_run_io()
Date: Tue, 21 Apr 2020 20:39:48 +0800
Message-ID: <20200421123952.49025-5-yuyufen@huawei.com>
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

After using r5pages for each sh->dev[i], we need to set correct offset
of that page for bi_io_vec when issue bio. The value of offset is zero
without using r5pages.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0d1e5bf4e5f2..87c3bbfadf54 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1194,7 +1194,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				sh->dev[i].vec.bv_page = sh->dev[i].page;
 			bi->bi_vcnt = 1;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
-			bi->bi_io_vec[0].bv_offset = 0;
+			bi->bi_io_vec[0].bv_offset = sh->dev[i].offset;
 			bi->bi_iter.bi_size = STRIPE_SIZE;
 			bi->bi_write_hint = sh->dev[i].write_hint;
 			if (!rrdev)
@@ -1248,7 +1248,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			sh->dev[i].rvec.bv_page = sh->dev[i].page;
 			rbi->bi_vcnt = 1;
 			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
-			rbi->bi_io_vec[0].bv_offset = 0;
+			rbi->bi_io_vec[0].bv_offset = sh->dev[i].offset;
 			rbi->bi_iter.bi_size = STRIPE_SIZE;
 			rbi->bi_write_hint = sh->dev[i].write_hint;
 			sh->dev[i].write_hint = RWH_WRITE_LIFE_NOT_SET;
-- 
2.21.1
