From: NeilBrown <neilb@suse.de>
Subject: [PATCH 3/4] block: stack unplug
Date: Thu, 26 Jul 2012 12:58:30 +1000
Message-ID: <20120726025830.32180.39904.stgit@notabene.brown>
References: <20120726025650.32180.65163.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120726025650.32180.65163.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>, Shaohua Li <shli@fusionio.com>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

From: Shaohua Li <shli@kernel.org>

MD raid1 prepares to dispatch request in unplug callback. If make_request in
low level queue also uses unplug callback to dispatch request, the low level
queue's unplug callback will not be called. Recheck the callback list helps
this case.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 block/blk-core.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7296d3d..bf38a5b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2900,17 +2900,16 @@ static void flush_plug_callbacks(struct blk_plug *plug)
 {
 	LIST_HEAD(callbacks);
 
-	if (list_empty(&plug->cb_list))
-		return;
-
-	list_splice_init(&plug->cb_list, &callbacks);
+	while (!list_empty(&plug->cb_list)) {
+		list_splice_init(&plug->cb_list, &callbacks);
 
-	while (!list_empty(&callbacks)) {
-		struct blk_plug_cb *cb = list_first_entry(&callbacks,
+		while (!list_empty(&callbacks)) {
+			struct blk_plug_cb *cb = list_first_entry(&callbacks,
 							  struct blk_plug_cb,
 							  list);
-		list_del(&cb->list);
-		cb->callback(cb);
+			list_del(&cb->list);
+			cb->callback(cb);
+		}
 	}
 }
 


