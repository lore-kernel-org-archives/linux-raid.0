From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] mdadm: handle super == NULL case in avail_size1
Date: Thu, 31 Aug 2017 10:37:51 -0700
Message-ID: <20170831173751.2910909-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

Summary:

Handling super == NULL case in avail_size1() was removed a while
back. However, it is still useful in the following stack:

avail_size1() with st->sb == NULL
array_try_spare() with st == NULL
try_spare() with st == NULL
Incremental() with st == NULL

This patch adds the handling of super == NULL back to avail_size1().

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 super1.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/super1.c b/super1.c
index f6a1045..5e8d967 100644
--- a/super1.c
+++ b/super1.c
@@ -2340,7 +2340,9 @@ static __u64 avail_size1(struct supertype *st, __u64 devsize,
 	if (devsize < 24)
 		return 0;
 
-	if (__le32_to_cpu(super->feature_map) & MD_FEATURE_BITMAP_OFFSET) {
+	if (!super)
+		bmspace = choose_bm_space(devsize);
+	else if (__le32_to_cpu(super->feature_map) & MD_FEATURE_BITMAP_OFFSET) {
 		/* hot-add. allow for actual size of bitmap */
 		struct bitmap_super_s *bsb;
 		bsb = (struct bitmap_super_s *)(((char*)super)+MAX_SB_SIZE);
@@ -2350,7 +2352,7 @@ static __u64 avail_size1(struct supertype *st, __u64 devsize,
 	}
 
 	/* Allow space for bad block log */
-	if (super->bblog_size)
+	if (super && super->bblog_size)
 		bbspace = __le16_to_cpu(super->bblog_size);
 
 	if (st->minor_version < 0)
-- 
2.9.5

