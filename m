From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] super1: make write_bitmap1 compatible with previous mdadm versions
Date: Wed, 12 Oct 2016 02:24:07 -0400
Message-ID: <1476253447-19865-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>, Neil Brown <neilb@suse.com>
List-Id: linux-raid.ids

For older mdadm version, v1.x metadata has different bitmap_offset,
we can't ensure all the bitmaps are on a 4K boundary since writing
4K for bitmap could corrupt the superblock, and Anthony reported
the bug about it at below link.

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=837964

So let's check about the alignment for bitmap_offset before set
the boundary to 4096 unconditionally. Thanks for Neil's detailed
explanation.

Reported-by: Anthony DeRobertis <anthony@derobert.net>
Fixes: 95a05b37e8eb ("Create n bitmaps for clustered mode")
Cc: Neil Brown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 super1.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/super1.c b/super1.c
index 9f62d23..4fef378 100644
--- a/super1.c
+++ b/super1.c
@@ -2433,7 +2433,15 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 			memset(buf, 0xff, 4096);
 		memcpy(buf, (char *)bms, sizeof(bitmap_super_t));
 
-		towrite = calc_bitmap_size(bms, 4096);
+		/*
+		 * use 4096 boundary if bitmap_offset is aligned
+		 * with 8 sectors, then it should compatible with
+		 * older mdadm.
+		 */
+		if (__le32_to_cpu(sb->bitmap_offset) & 7)
+			towrite = calc_bitmap_size(bms, 512);
+		else
+			towrite = calc_bitmap_size(bms, 4096);
 		while (towrite > 0) {
 			n = towrite;
 			if (n > 4096)
-- 
2.6.6

