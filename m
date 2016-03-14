From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 3/3] md: fix typos for stipe
Date: Mon, 14 Mar 2016 17:01:39 +0800
Message-ID: <1457946099-1878-4-git-send-email-gqjiang@suse.com>
References: <1457946099-1878-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457946099-1878-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/bitmap.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 7d5c3a6..5e3fcd6 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -49,8 +49,8 @@
  * When we set a bit, or in the counter (to start a write), if the fields is
  * 0, we first set the disk bit and set the counter to 1.
  *
- * If the counter is 0, the on-disk bit is clear and the stipe is clean
- * Anything that dirties the stipe pushes the counter to 2 (at least)
+ * If the counter is 0, the on-disk bit is clear and the stripe is clean
+ * Anything that dirties the stripe pushes the counter to 2 (at least)
  * and sets the on-disk bit (lazily).
  * If a periodic sweep find the counter at 2, it is decremented to 1.
  * If the sweep find the counter at 1, the on-disk bit is cleared and the
-- 
2.6.2

