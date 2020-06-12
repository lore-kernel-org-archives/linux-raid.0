From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v4 06/15] md/raid5: set correct page offset for bi_io_vec in ops_run_io()
Date: Fri, 12 Jun 2020 19:42:11 +0800
Message-ID: <20200612114220.13126-7-yuyufen@huawei.com>
References: <20200612114220.13126-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200612114220.13126-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

After using r5pages for each sh->dev[i], we need to set correct offset
of that page for bi_io_vec when issue bio. The value of offset is zero
without using r5pages.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3ae2cc8cd1ea..9ab7f99406d6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1200,7 +1200,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				sh->dev[i].vec.bv_page = sh->dev[i].page;
 			bi->bi_vcnt = 1;
 			bi->bi_io_vec[0].bv_len = conf->stripe_size;
-			bi->bi_io_vec[0].bv_offset = 0;
+			bi->bi_io_vec[0].bv_offset = sh->dev[i].offset;
 			bi->bi_iter.bi_size = conf->stripe_size;
 			bi->bi_write_hint = sh->dev[i].write_hint;
 			if (!rrdev)
@@ -1254,7 +1254,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			sh->dev[i].rvec.bv_page = sh->dev[i].page;
 			rbi->bi_vcnt = 1;
 			rbi->bi_io_vec[0].bv_len = conf->stripe_size;
-			rbi->bi_io_vec[0].bv_offset = 0;
+			rbi->bi_io_vec[0].bv_offset = sh->dev[i].offset;
 			rbi->bi_iter.bi_size = conf->stripe_size;
 			rbi->bi_write_hint = sh->dev[i].write_hint;
 			sh->dev[i].write_hint = RWH_WRITE_LIFE_NOT_SET;
-- 
2.21.3
