From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] bcache: Fix sparse non static symbol warning
Date: Thu, 9 Jan 2014 22:21:19 +0800
Message-ID: <CAPgLHd_sYw7iTiNHT8S86QXswOZZhQVsi-hfh5fbZni0L7BiBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
To: kmo@daterainc.com, neilb@suse.de
Cc: yongjun_wei@trendmicro.com.cn, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

drivers/md/bcache/sysfs.c:419:5: warning:
 symbol 'bch_bset_print_stats' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/md/bcache/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index c6ab693..d8458d4 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -416,7 +416,7 @@ static int btree_bset_stats(struct btree_op *b_op, struct btree *b)
 	return MAP_CONTINUE;
 }
 
-int bch_bset_print_stats(struct cache_set *c, char *buf)
+static int bch_bset_print_stats(struct cache_set *c, char *buf)
 {
 	struct bset_stats_op op;
 	int ret;
