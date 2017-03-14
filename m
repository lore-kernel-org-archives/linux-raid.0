From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH v1] md:fix a trivial typo in comments
Date: Tue, 14 Mar 2017 15:52:26 +0800
Message-ID: <1489477946-4202-1-git-send-email-zlliu@suse.com>
References: <1489384407-12672-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489384407-12672-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>, Jack Wang <jack.wang.usish@gmail.com>, Guoqing Jiang <gqjiang@suse.com>, John Stoffel <john@stoffel.org>, Coly Li <colyli@suse.de>
List-Id: linux-raid.ids

raid1.c: fix a trivial typo in comments of freeze_array().

Cc: Jack Wang <jack.wang.usish@gmail.com>
Cc: Guoqing Jiang <gqjiang@suse.com>
Cc: John Stoffel <john@stoffel.org>
Cc: Coly Li <colyli@suse.de>
Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fbc2d78..92ca6de 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1027,7 +1027,7 @@ static int get_unqueued_pending(struct r1conf *conf)
 static void freeze_array(struct r1conf *conf, int extra)
 {
 	/* Stop sync I/O and normal I/O and wait for everything to
-	 * go quite.
+	 * go quiet.
 	 * This is called in two situations:
 	 * 1) management command handlers (reshape, remove disk, quiesce).
 	 * 2) one normal I/O request failed.
-- 
2.6.6

