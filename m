From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 05/11] imsm: FIX: Remove single map state limitation in getinfo
Date: Thu, 24 Nov 2011 13:17:50 +0100
Message-ID: <20111124121750.5254.73420.stgit@gklab-128-013.igk.intel.com>
References: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

It can occur that degradation during migration occurs on disks that are not
present in both maps /e.g. degradation on just added disk during OLCE/.
This can cause that maps will be in different states (one will be in degraded
and second in normal state). In such situation getinfo_super_imsm_volume()
will not return migration information.

Remove single state limitation in both maps to allow migration information
retrieving.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index a3ca78a..0fc907d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2314,8 +2314,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	info->custom_array_size   |= __le32_to_cpu(dev->size_low);
 	info->recovery_blocked = imsm_reshape_blocks_arrays_changes(st->sb);
 
-	if (prev_map && map->map_state == prev_map->map_state &&
-	    (migr_type(dev) == MIGR_GEN_MIGR)) {
+	if (is_gen_migration(dev)) {
 		info->reshape_active = 1;
 		info->new_level = get_imsm_raid_level(map);
 		info->new_layout = imsm_level_to_layout(info->new_level);

