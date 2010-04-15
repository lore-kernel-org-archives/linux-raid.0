From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 10/28] md: Relax checks on ->max_disks when external
	metadata handling is used.
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.6937.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When metadata is being managed by user-space, md doesn't know
what the maximum number of devices allowed in an array is
so ->max_disks is 0.  In this case we should allow any (+ve)
number of disks.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 30389bc..9385d1e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2774,8 +2774,9 @@ static void analyze_sbs(mddev_t * mddev)
 
 	i = 0;
 	rdev_for_each(rdev, tmp, mddev) {
-		if (rdev->desc_nr >= mddev->max_disks ||
-		    i > mddev->max_disks) {
+		if (mddev->max_disks &&
+		    (rdev->desc_nr >= mddev->max_disks ||
+		     i > mddev->max_disks)) {
 			printk(KERN_WARNING
 			       "md: %s: %s: only %d devices permitted\n",
 			       mdname(mddev), bdevname(rdev->bdev, b),
@@ -5363,7 +5364,7 @@ static int update_raid_disks(mddev_t *mddev, int raid_disks)
 	if (mddev->pers->check_reshape == NULL)
 		return -EINVAL;
 	if (raid_disks <= 0 ||
-	    raid_disks >= mddev->max_disks)
+	    (mddev->max_disks && raid_disks >= mddev->max_disks))
 		return -EINVAL;
 	if (mddev->sync_thread || mddev->reshape_position != MaxSector)
 		return -EBUSY;


