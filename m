From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/8] imsm: FIX: local mdadm update shouldn't be done in update
	creation function.
Date: Wed, 12 Jan 2011 14:54:42 +0100
Message-ID: <20110112135442.15045.61099.stgit@gklab-128-013.igk.intel.com>
References: <20110112132954.15045.41564.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112132954.15045.41564.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Local update is performed based on created update, so this code can broke
local update and it is not necessary as prepare and process update functions
are used.

Code removed.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 7038433..de41702 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6492,19 +6492,6 @@ static int imsm_create_metadata_update_for_reshape(
 		mpb->num_disks++;
 		dev = dev->next;
 	}
-	/* Now update the metadata so that container_content will find
-	 * the new devices
-	 */
-	for (i = 0; i < mpb->num_raid_devs; i++) {
-		int d;
-		struct imsm_dev *dev = get_imsm_dev(super, i);
-		struct imsm_map *map = get_imsm_map(dev, 0);
-		map->num_members = geo->raid_disks;
-		for (d = 0; d < delta_disks; d++) {
-			set_imsm_ord_tbl_ent(map, old_raid_disks + d,
-					     mpb->num_disks - delta_disks + d);
-		}
-	}
 
 abort:
 	/* free spares

