From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/4] imsm: Fill recovery_blocked field present in mdinfo
Date: Mon, 03 Oct 2011 18:13:53 +0200
Message-ID: <20111003161353.18410.19596.stgit@gklab-128-013.igk.intel.com>
References: <20111003160839.18410.33275.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111003160839.18410.33275.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

If any reshape in container is active set recovery_blocked field.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 8e9e977..e761819 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2251,8 +2251,7 @@ int imsm_reshape_blocks_arrays_changes(struct intel_super *super)
 	 */
 	for (i_dev = super->devlist; i_dev; i_dev = i_dev->next) {
 		dev = i_dev->dev;
-		if (dev->vol.migr_state &&
-		    dev->vol.migr_type == MIGR_GEN_MIGR) {
+		if (is_gen_migration(dev)) {
 			/* No repair during any migration in container
 			 */
 			rv = 1;
@@ -2294,6 +2293,8 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	info->custom_array_size   = __le32_to_cpu(dev->size_high);
 	info->custom_array_size   <<= 32;
 	info->custom_array_size   |= __le32_to_cpu(dev->size_low);
+	info->recovery_blocked = imsm_reshape_blocks_arrays_changes(st->sb);
+
 	if (prev_map && map->map_state == prev_map->map_state) {
 		info->reshape_active = 1;
 		info->new_level = get_imsm_raid_level(map);
@@ -2516,6 +2517,7 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 	info->disk.state = 0;
 	info->name[0] = 0;
 	info->recovery_start = MaxSector;
+	info->recovery_blocked = imsm_reshape_blocks_arrays_changes(st->sb);
 
 	/* do we have the all the insync disks that we expect? */
 	mpb = super->anchor;

