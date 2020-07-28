From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 4/5] raid5-cache: hold spinlock instead of mutex in r5c_journal_mode_show
Date: Tue, 28 Jul 2020 12:01:42 +0200
Message-ID: <20200728100143.17813-5-guoqing.jiang@cloud.ionos.com>
References: <20200728100143.17813-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200728100143.17813-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

Replace mddev_lock with spin_lock to align with other show methods in
raid5_attrs.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 drivers/md/raid5-cache.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 82eb4a906e31..4337ae0e6af2 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2537,13 +2537,10 @@ static ssize_t r5c_journal_mode_show(struct mddev *mddev, char *page)
 	struct r5conf *conf;
 	int ret;
 
-	ret = mddev_lock(mddev);
-	if (ret)
-		return ret;
-
+	spin_lock(&mddev->lock);
 	conf = mddev->private;
 	if (!conf || !conf->log) {
-		mddev_unlock(mddev);
+		spin_unlock(&mddev->lock);
 		return 0;
 	}
 
@@ -2563,7 +2560,7 @@ static ssize_t r5c_journal_mode_show(struct mddev *mddev, char *page)
 	default:
 		ret = 0;
 	}
-	mddev_unlock(mddev);
+	spin_unlock(&mddev->lock);
 	return ret;
 }
 
-- 
2.17.1
