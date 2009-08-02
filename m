From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 3/8] md: when a level change reduces the number of devices,
	remove the excess.
Date: Mon, 03 Aug 2009 07:58:18 +1000
Message-ID: <20090802215818.4198.2964.stgit@notabene.brown>
References: <20090802215444.4198.83094.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090802215444.4198.83094.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: stable@kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

When an array is changed from RAID6 to RAID5, fewer drives are
needed.  So any device that is made superfluous by the level
conversion must be marked as not-active.
For the RAID6->RAID5 conversion, this will be a drive which only
has 'Q' blocks on it.

Cc: stable@kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 13535f0..5bd7896 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2694,6 +2694,7 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	ssize_t rv = len;
 	struct mdk_personality *pers;
 	void *priv;
+	mdk_rdev_t *rdev;
 
 	if (mddev->pers == NULL) {
 		if (len == 0)
@@ -2773,6 +2774,12 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	mddev_suspend(mddev);
 	mddev->pers->stop(mddev);
 	module_put(mddev->pers->owner);
+	/* Invalidate devices that are now superfluous */
+	list_for_each_entry(rdev, &mddev->disks, same_set)
+		if (rdev->raid_disk >= mddev->raid_disks) {
+			rdev->raid_disk = -1;
+			clear_bit(In_sync, &rdev->flags);
+		}
 	mddev->pers = pers;
 	mddev->private = priv;
 	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));


