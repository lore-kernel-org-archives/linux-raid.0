From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] md/r5cache: remove set but not used 'offset'
Date: Thu, 9 Apr 2020 16:54:16 +0800
Message-ID: <20200409085416.47724-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: song@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jason Yan <yanaijie@huawei.com>
List-Id: linux-raid.ids

Fix the following gcc warning:

drivers/md/raid5-cache.c:198:11: warning: variable ‘offset’ set but not
used [-Wunused-but-set-variable]
  sector_t offset;
           ^~~~~~

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/md/raid5-cache.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 9b6da759dca2..eea14fa9e59b 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -195,9 +195,7 @@ struct r5l_log {
 static inline sector_t r5c_tree_index(struct r5conf *conf,
 				      sector_t sect)
 {
-	sector_t offset;
-
-	offset = sector_div(sect, conf->chunk_sectors);
+	sector_div(sect, conf->chunk_sectors);
 	return sect;
 }
 
-- 
2.17.2
