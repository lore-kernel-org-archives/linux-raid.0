From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/2] md/raid5: FIX: manually-added spare is not used
Date: Fri, 14 Jan 2011 13:38:32 +0100
Message-ID: <20110114123832.14953.89359.stgit@gklab-128-013.igk.intel.com>
References: <20110114123139.14953.81620.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110114123139.14953.81620.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Manually added spares are not used due to fact that they not added to md configuration.
Counters are updated only.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 drivers/md/raid5.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a2087c7..b98b01c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5592,8 +5592,10 @@ static int raid5_start_reshape(mddev_t *mddev)
 		} else if (rdev->raid_disk >= conf->previous_raid_disks
 			   && !test_bit(Faulty, &rdev->flags)) {
 			/* This is a spare that was manually added */
-			set_bit(In_sync, &rdev->flags);
-			added_devices++;
+			if (raid5_add_disk(mddev, rdev) == 0) {
+			    set_bit(In_sync, &rdev->flags);
+			    added_devices++;
+			}
 		}
 
 	/* When a reshape changes the number of devices, ->degraded

