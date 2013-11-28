From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] bcache: fix sparse non static symbol warning
Date: Thu, 28 Nov 2013 10:31:35 +0800
Message-ID: <CAPgLHd-qv+6z4PBMAUoe8tvTkUFTMhPE1Wv-2dzr9FvEzqZMaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
To: kmo@daterainc.com, neilb@suse.de
Cc: yongjun_wei@trendmicro.com.cn, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

drivers/md/bcache/btree.c:2220:5: warning:
 symbol 'btree_insert_fn' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index b62f379..2a46036 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2217,7 +2217,7 @@ struct btree_insert_op {
 	struct bkey	*replace_key;
 };
 
-int btree_insert_fn(struct btree_op *b_op, struct btree *b)
+static int btree_insert_fn(struct btree_op *b_op, struct btree *b)
 {
 	struct btree_insert_op *op = container_of(b_op,
 					struct btree_insert_op, op);
