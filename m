From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/5] fix: array is reassembled inactive if stopped during
	resync
Date: Tue, 08 Mar 2011 14:24:38 +0100
Message-ID: <20110308132438.9578.10049.stgit@gklab-128-013.igk.intel.com>
References: <20110308132228.9578.34611.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110308132228.9578.34611.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

This is adaptation of previous fix to avoid problem appear again.

If initial resync or recovery of a redundant array is not finished
before it is stopped then during assembly md will start it as inactive.
Writing readonly to array_state in assemble_container_content
fails because md thinks the array is during reshape.

In fact we only have a reshape if both current and previous map
states are the same. Otherwise we may have resync or recovery.
Setting reshape_active in such cases causes the issue.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 super-intel.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 90faf27..4628f2d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1758,8 +1758,9 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	info->custom_array_size   = __le32_to_cpu(dev->size_high);
 	info->custom_array_size   <<= 32;
 	info->custom_array_size   |= __le32_to_cpu(dev->size_low);
-	if (prev_map && map->map_state == prev_map->map_state) {
-		info->reshape_active = 1;
+	info->reshape_active = (prev_map != NULL) &&
+			       (map->map_state == prev_map->map_state);
+	if (info->reshape_active) {
 		info->new_level = get_imsm_raid_level(map);
 		info->new_layout = imsm_level_to_layout(info->new_level);
 		info->new_chunk = __le16_to_cpu(map->blocks_per_strip) << 9;

