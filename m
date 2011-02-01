From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/8] imsm: FIX: put expansion finalization in to one place
Date: Tue, 01 Feb 2011 14:49:28 +0100
Message-ID: <20110201134928.13398.74673.stgit@gklab-128-013.igk.intel.com>
References: <20110201134226.13398.4071.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110201134226.13398.4071.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When a->last_checkpoint variable can reach array end,
reshape finalization can be put in to single place.

There is no need to reset migration variables.
imsm_set_disk() will call end_migration() and this sets
all migration variables to required values.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 62b13b0..d6c2756 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5175,10 +5175,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 			if (a->last_checkpoint >= a->info.component_size) {
 				unsigned long long array_blocks;
 				int used_disks;
-				/* it seems the reshape is all done */
-				dev->vol.migr_state = 0;
-				dev->vol.migr_type = 0;
-				dev->vol.curr_migr_unit = 0;
+				struct mdinfo *mdi;
 
 				used_disks = imsm_num_data_members(dev, -1);
 				array_blocks = map->blocks_per_member * used_disks;
@@ -5189,6 +5186,13 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 				a->check_reshape = 1; /* encourage manager to update
 						       * array size
 						       */
+
+				/* finalize online capacity expansion/reshape */
+				for (mdi = a->info.devs; mdi; mdi = mdi->next)
+					imsm_set_disk(a,
+						      mdi->disk.raid_disk,
+						      mdi->curr_state);
+
 				imsm_progress_container_reshape(super);
 			}
 		}
@@ -5255,19 +5259,6 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 		super->updates_pending++;
 	}
 
-	/* manage online capacity expansion/reshape */
-	if ((a->curr_action != reshape) &&
-	    (a->prev_action == reshape)) {
-		struct mdinfo *mdi;
-
-		/* finalize online capacity expansion/reshape */
-		for (mdi = a->info.devs; mdi; mdi = mdi->next)
-			imsm_set_disk(a, mdi->disk.raid_disk, mdi->curr_state);
-
-		/* check next volume reshape */
-		imsm_progress_container_reshape(super);
-	}
-
 	return consistent;
 }
 

