From: Joe Perches <joe@perches.com>
Subject: [PATCH 06/12] bcache: Use DECLARE_BITMAP
Date: Tue, 19 May 2015 18:37:54 -0700
Message-ID: <2622d6778aa6c62b47b3e686f06a39fda4d1879e.1432085659.git.joe@perches.com>
References: <cover.1432085659.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1432085659.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>
Cc: Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Use the generic mechanism to declare a bitmap instead of unsigned long.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/md/bcache/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index fe080ad..ce64fc8 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -157,7 +157,7 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 
 	for_each_cache(ca, c, iter) {
 		struct journal_device *ja = &ca->journal;
-		unsigned long bitmap[SB_JOURNAL_BUCKETS / BITS_PER_LONG];
+		DECLARE_BITMAP(bitmap, SB_JOURNAL_BUCKETS);
 		unsigned i, l, r, m;
 		uint64_t seq;
 
-- 
2.1.2
