From: Neil Brown <neilb@suse.de>
Subject: Re: md looping on recovery of raid1 array
Date: Thu, 18 Dec 2008 16:34:40 +1100
Message-ID: <18761.57584.185497.562584@notabene.brown>
References: <20081215210153.GA13505@bguogx620.starentnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bin Guo on Monday December 15
Sender: linux-raid-owner@vger.kernel.org
To: Bin Guo <bguo@starentnetworks.com>
Cc: linux-raid@vger.kernel.org, Ryan_MichaelS@emc.com
List-Id: linux-raid.ids

On Monday December 15, bguo@starentnetworks.com wrote:
> Hi,
> 
>   I had similar errors to the problem reported in
> 
> http://marc.info/?l=linux-raid&m=118385063014256&w=2
> 
> Using manually coded patch similar to scsi fault injection
> tests, I can reproduce the problem:
> 
>   1. create degraded raid1 with only disk "sda1"
>   2. inject permanent I/O error on a block on "sda1"
>   3. try to add spare disk "sdb1" to the raid
> 
> Now raid code would loop to sync:

Below is the patch I expect to submit to fix this.

Thanks.

NeilBrown


From 6d9701cba935838b33a2b5df9c693c27c621c2d5 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 18 Dec 2008 12:19:14 +1100
Subject: [PATCH] md: don't retry recovery of raid1 that fails due to error on source drive.

If a raid1 has only one working drive and it has a sector which
gives an error on read, then an attempt to recover onto a spare will
fail, but as the single remaining drive is not removed from the
array, the recovery will be immediately re-attempted, resulting
in an infinite recovery loop.

So detect this situation and don't retry recovery once an error
on the lone remaining drive is detected.

Allow recovery to be retried once every time a spare is added
in case the problem wasn't actually a media error.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c           |    5 ++++-
 drivers/md/raid1.c        |    8 ++++++--
 include/linux/raid/md_k.h |    3 +++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index bef91b8..03cd257 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1500,6 +1500,9 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 
 	list_add_rcu(&rdev->same_set, &mddev->disks);
 	bd_claim_by_disk(rdev->bdev, rdev->bdev->bd_holder, mddev->gendisk);
+
+	/* May as well allow recovery to be retried once */
+	mddev->recovery_disabled = 0;
 	return 0;
 
  fail:
@@ -6175,7 +6178,7 @@ static int remove_and_add_spares(mddev_t *mddev)
 			}
 		}
 
-	if (mddev->degraded && ! mddev->ro) {
+	if (mddev->degraded && ! mddev->ro && !mddev->recovery_disabled) {
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(In_sync, &rdev->flags) &&
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c165b1e..7b4f5f7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1016,12 +1016,16 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 	 * else mark the drive as failed
 	 */
 	if (test_bit(In_sync, &rdev->flags)
-	    && (conf->raid_disks - mddev->degraded) == 1)
+	    && (conf->raid_disks - mddev->degraded) == 1) {
 		/*
 		 * Don't fail the drive, act as though we were just a
-		 * normal single drive
+		 * normal single drive.
+		 * However don't try a recovery from this drive as
+		 * it is very likely to fail.
 		 */
+		mddev->recovery_disabled = 1;
 		return;
+	}
 	if (test_and_clear_bit(In_sync, &rdev->flags)) {
 		unsigned long flags;
 		spin_lock_irqsave(&conf->device_lock, flags);
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index dac4217..9743e4d 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -218,6 +218,9 @@ struct mddev_s
 #define	MD_RECOVERY_FROZEN	9
 
 	unsigned long			recovery;
+	int				recovery_disabled; /* if we detect that recovery
+							    * will always fail, set this
+							    * so we don't loop trying */
 
 	int				in_sync;	/* know to not need resync */
 	struct mutex			reconfig_mutex;
-- 
1.5.6.5

