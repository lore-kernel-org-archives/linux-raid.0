From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 24/34] md: remove ro check in md_check_recovery()
Date: Thu, 21 Jul 2011 12:32:27 +1000
Message-ID: <20110721023227.6728.42013.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Namhyung Kim <namhyung@gmail.com>
List-Id: linux-raid.ids

From: Namhyung Kim <namhyung@gmail.com>

Commit c89a8eee6154 ("Allow faulty devices to be removed from a
readonly array.") added some work on ro array in the function,
but it couldn't be done since we didn't allow the ro array to be
handled from the beginning. Fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0398dc4..77bd8d8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7163,9 +7163,6 @@ void md_check_recovery(mddev_t *mddev)
 	if (mddev->bitmap)
 		bitmap_daemon_work(mddev);
 
-	if (mddev->ro)
-		return;
-
 	if (signal_pending(current)) {
 		if (mddev->pers->sync_request && !mddev->external) {
 			printk(KERN_INFO "md: %s in immediate safe mode\n",


