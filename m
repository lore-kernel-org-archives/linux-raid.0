From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/2] md/r5cache: disable write back for degraded raid6
Date: Wed, 18 Jan 2017 15:56:49 -0800
Message-ID: <20170118235650.2430923-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

raid6 handles write differently in degraded mode. Specifically,
handle_stripe_fill() is called for writes. As a result, write
back cache has very little performance benefit for degraded
raid6. (On the other hand, write back cache does help sequential
writes on degraded raid4 and raid5).

Write back cache for degraded mode also introduces data integrity
corner cases. This is mostly because handle_stripe_fill() is
called on write. To avoid handling these corner cases, this patch
disables write back cache for degraded raid6.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 4957297..b31ae41 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2371,6 +2371,16 @@ int r5c_try_caching_write(struct r5conf *conf,
 		set_bit(STRIPE_R5C_CACHING, &sh->state);
 	}
 
+	/*
+	 * When raid6 array runs in degraded mode, handle_stripe_fill() is
+	 * called on every write. So write back cache doesn't help the
+	 * performance. To simplify the code, do write-through.
+	 */
+	if (conf->level == 6 && s->failed) {
+		r5c_make_stripe_write_out(sh);
+		return -EAGAIN;
+	}
+
 	for (i = disks; i--; ) {
 		dev = &sh->dev[i];
 		/* if non-overwrite, use writing-out phase */
-- 
2.9.3

