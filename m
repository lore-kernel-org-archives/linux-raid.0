From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: [BUG][PATCH] Fix: raid1/raid10 md devices leak memory when stopping
Date: Tue, 16 Apr 2013 20:15:07 +0900 (JST)
Message-ID: <20130416.201507.1380418477042006122.taka@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.

Raid1 and raid10 devices leak memory every time they stop.
This is a patch for linux-3.9.0-rc7 to fix this problem.

Thanks,
Hirokazu Takahashi.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
---
 drivers/md/raid1.c  |    1 +
 drivers/md/raid10.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fd86b37..c055b92 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2901,6 +2901,7 @@ static int stop(struct mddev *mddev)
 	if (conf->r1bio_pool)
 		mempool_destroy(conf->r1bio_pool);
 	kfree(conf->mirrors);
+	safe_put_page(conf->tmppage);
 	kfree(conf->poolinfo);
 	kfree(conf);
 	mddev->private = NULL;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 77b562d..5a1010d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3810,6 +3810,7 @@ static int stop(struct mddev *mddev)
 
 	if (conf->r10bio_pool)
 		mempool_destroy(conf->r10bio_pool);
+	safe_put_page(conf->tmppage);
 	kfree(conf->mirrors);
 	kfree(conf);
 	mddev->private = NULL;
-- 
1.7.1

