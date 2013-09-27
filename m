From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] bcache: using for_each_clear_bit to simplify the code
Date: Fri, 27 Sep 2013 13:30:34 +0800
Message-ID: <CAPgLHd8F59D5fc0xxrNfK4=JwGVohXF5w6LiNxvbTBeRjvh1qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
Cc: yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Using for_each_clear_bit() to simplify the code.

Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 drivers/md/bcache/journal.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 8435f81..c77980d 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -173,9 +173,7 @@ int bch_journal_read(struct cache_set *c, struct list_head *list,
 		 */
 		pr_debug("falling back to linear search");
 
-		for (l = find_first_zero_bit(bitmap, ca->sb.njournal_buckets);
-		     l < ca->sb.njournal_buckets;
-		     l = find_next_zero_bit(bitmap, ca->sb.njournal_buckets, l + 1))
+		for_each_clear_bit(l,  bitmap,  ca->sb.njournal_buckets)
 			if (read_bucket(l))
 				goto bsearch;
 
