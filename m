From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/1] IMSM only run reshape if number of disks has changed
Date: Mon, 17 Oct 2011 22:40:15 +0200
Message-ID: <1318884015-14749-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1318884015-14749-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1318884015-14749-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, dledford@redhat.com, lukasz.dorau@intel.com, adam.kwolek@intel.com, Marcin.Labun@intel.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The IMSM code incorrectly made the assumption that reshape also meant
resync, and used 1 to indicate resync and 2 to indicate a reshape.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super-intel.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 62ccd15..426721d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1766,18 +1766,14 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	info->custom_array_size   = __le32_to_cpu(dev->size_high);
 	info->custom_array_size   <<= 32;
 	info->custom_array_size   |= __le32_to_cpu(dev->size_low);
-	if (prev_map && map->map_state == prev_map->map_state) {
+	info->delta_disks	  = 0;
+	if (prev_map)
+		info->delta_disks = map->num_members - prev_map->num_members;
+	if (info->delta_disks) {
 		info->reshape_active = 1;
 		info->new_level = get_imsm_raid_level(map);
 		info->new_layout = imsm_level_to_layout(info->new_level);
 		info->new_chunk = __le16_to_cpu(map->blocks_per_strip) << 9;
-		info->delta_disks = map->num_members - prev_map->num_members;
-		if (info->delta_disks) {
-			/* this needs to be applied to every array
-			 * in the container.
-			 */
-			info->reshape_active = 2;
-		}
 		/* We shape information that we give to md might have to be
 		 * modify to cope with md's requirement for reshaping arrays.
 		 * For example, when reshaping a RAID0, md requires it to be
@@ -1812,7 +1808,6 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 		info->new_level = UnSet;
 		info->new_layout = UnSet;
 		info->new_chunk = info->array.chunk_size;
-		info->delta_disks = 0;
 	}
 	info->disk.major = 0;
 	info->disk.minor = 0;
-- 
1.7.6.4

