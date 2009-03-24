From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 2/6] md/raid5: enhance raid5_size to work correctly with
	negative delta_disks
Date: Tue, 24 Mar 2009 19:53:32 +1100
Message-ID: <20090324085332.15383.41510.stgit@notabene.brown>
References: <20090324084629.15383.10271.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090324084629.15383.10271.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is the first of four patches which combine to allow md/raid5 to
reduce the number of devices in the array by restriping the data over
a subset of the devices.

If the number of disks in a raid4/5/6 is being reduced, then the
default size must be based on the new number, not the old number
of devices.
In general, it should be based on the smaller of new and old.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3b71f01..74e89c1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4169,8 +4169,13 @@ raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 
 	if (!sectors)
 		sectors = mddev->dev_sectors;
-	if (!raid_disks)
-		raid_disks = conf->previous_raid_disks;
+	if (!raid_disks) {
+		/* size is defined by the smallest of previous and new size */
+		if (conf->raid_disks < conf->previous_raid_disks)
+			raid_disks = conf->raid_disks;
+		else
+			raid_disks = conf->previous_raid_disks;
+	}
 
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
 	return sectors * (raid_disks - conf->max_degraded);


