From: Behan Webster <behanw@converseincode.com>
Subject: [PATCH] md, sysfs, LLVMLinux: Remove nested function from bcache sysfs
Date: Fri, 26 Sep 2014 18:09:29 -0700
Message-ID: <1411780169-3260-1-git-send-email-behanw@converseincode.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: kmo@daterainc.com
Cc: behanw@converseincode.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-raid.ids

Replace the use of nested functions where a normal function will suffice.

Nested functions are not liked by upstream kernel developers in general. Their
use breaks the use of clang as a compiler, and doesn't make the code any
better.

This code now works for both gcc and clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/md/bcache/sysfs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index b3ff57d..53d8baa 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -731,6 +731,11 @@ static struct attribute *bch_cache_set_internal_files[] = {
 };
 KTYPE(bch_cache_set_internal);
 
+static int __bch_cache_cmp(const void *l, const void *r)
+{
+	return *((uint16_t *) r) - *((uint16_t *) l);
+}
+
 SHOW(__bch_cache)
 {
 	struct cache *ca = container_of(kobj, struct cache, kobj);
@@ -755,9 +760,6 @@ SHOW(__bch_cache)
 					       CACHE_REPLACEMENT(&ca->sb));
 
 	if (attr == &sysfs_priority_stats) {
-		int cmp(const void *l, const void *r)
-		{	return *((uint16_t *) r) - *((uint16_t *) l); }
-
 		struct bucket *b;
 		size_t n = ca->sb.nbuckets, i;
 		size_t unused = 0, available = 0, dirty = 0, meta = 0;
@@ -786,7 +788,7 @@ SHOW(__bch_cache)
 			p[i] = ca->buckets[i].prio;
 		mutex_unlock(&ca->set->bucket_lock);
 
-		sort(p, n, sizeof(uint16_t), cmp, NULL);
+		sort(p, n, sizeof(uint16_t), __bch_cache_cmp, NULL);
 
 		while (n &&
 		       !cached[n - 1])
-- 
1.9.1

