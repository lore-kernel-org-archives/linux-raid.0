From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH] md: raid5: update suspend_hi during the reshape
Date: Tue, 9 Nov 2010 17:02:23 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CAB3@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

This patch is required by checkpointing for external metadata functionality.

When performing external reshape it is needed to move suspend_hi forward to keep up with the current reshape_position.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---

 drivers/md/raid5.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c index 53d7579..353c7c6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4353,6 +4353,14 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		wake_up(&conf->wait_for_overlap);
 		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	}
+	if (mddev->external && mddev->reshape_position > mddev->suspend_hi) {
+		if (mddev->reshape_position == MaxSector)
+			mddev->suspend_hi = 0;
+		else
+			mddev->suspend_hi = mddev->reshape_position;
+		mddev->pers->quiesce(mddev, 1);
+		mddev->pers->quiesce(mddev, 0);
+	}
 	return reshape_sectors;
 }
 
@@ -5691,6 +5699,12 @@ static void raid5_finish_reshape(mddev_t *mddev)
 		mddev->chunk_sectors = conf->chunk_sectors;
 		mddev->reshape_position = MaxSector;
 		mddev->delta_disks = 0;
+
+		if (mddev->external) {
+			mddev->suspend_hi = 0;
+			mddev->pers->quiesce(mddev, 1);
+			mddev->pers->quiesce(mddev, 0);
+		}
 	}
 }
 

