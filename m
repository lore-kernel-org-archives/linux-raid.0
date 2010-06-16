From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 3/3] md: enable raid4->raid0 takeover
Date: Wed, 16 Jun 2010 11:56:12 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801E873F07@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From: Maciej Trela <maciej.trela@intel.com>

Only level 5 with layout=PARITY_N can be taken over to raid0 now.
Lets allow level 4 either.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 drivers/md/raid0.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c index ac09b7d..0b45759 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -569,7 +569,7 @@ static void raid0_status(struct seq_file *seq, mddev_t *mddev)
 	return;
 }
 
-static void *raid0_takeover_raid5(mddev_t *mddev)
+static void *raid0_takeover_raid45(mddev_t *mddev)
 {
 	mdk_rdev_t *rdev;
 	raid0_conf_t *priv_conf;
@@ -650,9 +650,9 @@ static void *raid0_takeover(mddev_t *mddev)
 	 *  raid5 - providing it is Raid4 layout and one disk is faulty
 	 *  raid10 - assuming we have all necessary active disks
 	 */
-	if (mddev->level == 5) {
+	if (mddev->level == 5 || mddev->level == 4){
 		if (mddev->layout == ALGORITHM_PARITY_N)
-			return raid0_takeover_raid5(mddev);
+			return raid0_takeover_raid45(mddev);
 
 		printk(KERN_ERR "md/raid0:%s: Raid can only takeover Raid5 with layout: %d\n",
 		       mdname(mddev), ALGORITHM_PARITY_N);

