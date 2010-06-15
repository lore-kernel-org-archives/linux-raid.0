From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 2/3] md: fix unwanted slot changes for raid10 takeover
Date: Tue, 15 Jun 2010 09:36:03 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801E8734B3@irsmsx503.ger.corp.intel.com>
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

A new parameter conf->scale_disks was added to raid10
takeover() that cause slot switching in pers->run().
Remove old code for updating device slots.
---
 drivers/md/raid10.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c index a027672..a6ae4a1 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2435,13 +2435,6 @@ static void *raid10_takeover_raid0(mddev_t *mddev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	/* Update slot numbers to obtain
-	 * degraded raid10 with missing mirrors
-	 */
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
-		rdev->raid_disk *= 2;
-	}
-
 	/* Set new parameters */
 	mddev->new_level = 10;
 	/* new layout: far_copies = 1, near_copies = 2 */

