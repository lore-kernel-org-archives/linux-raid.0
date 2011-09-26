From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] imsm: fix: stopped resync does not continue after
	auto-assemblation
Date: Mon, 26 Sep 2011 14:54:47 +0200
Message-ID: <20110926125446.14365.9519.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Resync stopped with "mdadm -Ss" command does not continue
after issuing "mdadm -As" command.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index ed522ae..95627d1 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2267,7 +2267,8 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	info->custom_array_size   = __le32_to_cpu(dev->size_high);
 	info->custom_array_size   <<= 32;
 	info->custom_array_size   |= __le32_to_cpu(dev->size_low);
-	if (prev_map && map->map_state == prev_map->map_state) {
+	if (prev_map && map->map_state == prev_map->map_state &&
+			(migr_type(dev) == MIGR_GEN_MIGR)) {
 		info->reshape_active = 1;
 		info->new_level = get_imsm_raid_level(map);
 		info->new_layout = imsm_level_to_layout(info->new_level);

