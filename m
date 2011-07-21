From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 31/34] md/raid10: move rdev->corrected_errors counting
Date: Thu, 21 Jul 2011 12:32:28 +1000
Message-ID: <20110721023228.6728.70830.stgit@notabene.brown>
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

Read errors are considered to corrected if write-back and re-read
cycle is finished without further problems. Thus moving the rdev->
corrected_errors counting after the re-reading looks more reasonable
IMHO.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6721cb0..5def27c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1533,7 +1533,6 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 			    test_bit(In_sync, &rdev->flags)) {
 				atomic_inc(&rdev->nr_pending);
 				rcu_read_unlock();
-				atomic_add(s, &rdev->corrected_errors);
 				if (sync_page_io(rdev,
 						 r10_bio->devs[sl].addr +
 						 sect,
@@ -1598,6 +1597,7 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 					       (unsigned long long)(
 						       sect + rdev->data_offset),
 					       bdevname(rdev->bdev, b));
+					atomic_add(s, &rdev->corrected_errors);
 				}
 
 				rdev_dec_pending(rdev, mddev);


