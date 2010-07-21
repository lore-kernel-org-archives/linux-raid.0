From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 2/2] md: raid5: update suspend_hi during the reshape
Date: Wed, 21 Jul 2010 12:04:29 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040804E2A4996@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From: Maciej Trela <maciej.trela@intel.com>

When performing external reshape it is needed to move suspend_hi forward to keep up with the current reshape_position.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 drivers/md/raid5.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c index b7c6561..1828284 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4340,6 +4340,11 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		wake_up(&conf->wait_for_overlap);
 		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	}
+	if (mddev->external && mddev->reshape_position > mddev->suspend_hi) {
+		mddev->suspend_hi = mddev->reshape_position;
+		mddev->pers->quiesce(mddev, 1);
+		mddev->pers->quiesce(mddev, 0);
+	}
 	return reshape_sectors;
 }

