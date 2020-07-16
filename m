From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/4] md: raid5-cache: Remove set but unused variable
Date: Thu, 16 Jul 2020 13:54:41 +0900
Message-ID: <20200716045443.662056-3-damien.lemoal@wdc.com>
References: <20200716045443.662056-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200716045443.662056-1-damien.lemoal@wdc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Remove the variable offset in r5c_tree_index() to avoid a "set but not
used" compilation warning when compiling with W=1.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/raid5-cache.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 0bea21d81697..34fd942dad83 100644
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
2.26.2
