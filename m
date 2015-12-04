From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 2/2] md: update comment for md_allow_write
Date: Sat,  5 Dec 2015 02:32:52 +0800
Message-ID: <1449253972-26997-2-git-send-email-gqjiang@suse.com>
References: <1449253972-26997-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449253972-26997-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: gqjiang@suse.com, neilb@suse.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

MD_CHANGE_CLEAN had been replaced with MD_CHANGE_PENDING after
commit 070dc6 ("md: resolve confusion of MD_CHANGE_CLEAN"),
so make the change accordingly.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5ee18a0..0feff1c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7701,7 +7701,7 @@ EXPORT_SYMBOL(md_write_end);
  * attempting a GFP_KERNEL allocation while holding the mddev lock.
  * Must be called with mddev_lock held.
  *
- * In the ->external case MD_CHANGE_CLEAN can not be cleared until mddev->lock
+ * In the ->external case MD_CHANGE_PENDING can not be cleared until mddev->lock
  * is dropped, so return -EAGAIN after notifying userspace.
  */
 int md_allow_write(struct mddev *mddev)
-- 
2.1.4

