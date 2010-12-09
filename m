From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 10/29] imsm: Fill delta_disks field in getinfo_super()
Date: Thu, 09 Dec 2010 16:20:03 +0100
Message-ID: <20101209152003.26876.7143.stgit@gklab-170-024.igk.intel.com>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

delta_disks field is not always filled during getinfo_super() call.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 19859ef..07851ce 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1511,6 +1511,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	struct intel_super *super = st->sb;
 	struct imsm_dev *dev = get_imsm_dev(super, super->current_vol);
 	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct imsm_map *prev_map = get_imsm_map(dev, 1);
 	struct dl *dl;
 	char *devname;
 	int map_disks = info->array.raid_disks;
@@ -1542,7 +1543,11 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	info->component_size	  = __le32_to_cpu(map->blocks_per_member);
 	memset(info->uuid, 0, sizeof(info->uuid));
 	info->recovery_start = MaxSector;
-	info->reshape_active = 0;
+	info->reshape_active = (prev_map != NULL);
+	if (info->reshape_active)
+		info->delta_disks = map->num_members - prev_map->num_members;
+	else
+		info->delta_disks = 0;
 
 	if (map->map_state == IMSM_T_STATE_UNINITIALIZED || dev->vol.dirty) {
 		info->resync_start = 0;
@@ -1599,7 +1604,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 			}
 		}
 	}
-}				
+}
 
 /* check the config file to see if we can return a real uuid for this spare */
 static void fixup_container_spare_uuid(struct mdinfo *inf)

