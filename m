From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/4] imsm: FIX: Use function to obtain array layout
Date: Thu, 09 Jun 2011 18:29:29 +0200
Message-ID: <20110609162929.690.53762.stgit@gklab-128-013.igk.intel.com>
References: <20110609162050.690.87261.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110609162050.690.87261.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Function imsm_level_to_layout() should be use to get array layout.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e094b85..8bfe40a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7733,8 +7733,7 @@ int save_backup_imsm(struct supertype *st,
 	if (open_backup_targets(info, new_disks, targets))
 		goto abort;
 
-	if (map_dest->raid_level != 0)
-		dest_layout = ALGORITHM_LEFT_ASYMMETRIC;
+	dest_layout = imsm_level_to_layout(map_dest->raid_level);
 	dest_chunk = __le16_to_cpu(map_dest->blocks_per_strip) * 512;
 
 	if (restore_stripes(targets, /* list of dest devices */
@@ -8781,8 +8780,7 @@ static int imsm_manage_reshape(
 	}
 
 	max_position = sra->component_size * ndata;
-	if (map_src->raid_level != 0)
-		source_layout = ALGORITHM_LEFT_ASYMMETRIC;
+	source_layout = imsm_level_to_layout(map_src->raid_level);
 
 	while (__le32_to_cpu(migr_rec->curr_migr_unit) <
 	       __le32_to_cpu(migr_rec->num_migr_units)) {

