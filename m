From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: FIX: Just created redundant array is not in
	uninitialized state
Date: Mon, 05 Dec 2011 09:26:52 +0100
Message-ID: <20111205082652.18395.98414.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When redundant array (e.g. raid5) is created metadata shows it is in
normal state. Initialization process is showed in metadata as rebuild from normal
to normal state. Redundant array should be initially in uninitialized state
before it's initialization.

Add code to put array in uninitialized state upon array creation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index a0672bf..b8abea0 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4289,7 +4289,11 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	map->blocks_per_member = __cpu_to_le32(info_to_blocks_per_member(info));
 	map->blocks_per_strip = __cpu_to_le16(info_to_blocks_per_strip(info));
 	map->failed_disk_num = ~0;
-	map->map_state = info->failed_disks ? IMSM_T_STATE_DEGRADED : IMSM_T_STATE_NORMAL;
+	if (info->level > 0)
+		map->map_state = IMSM_T_STATE_UNINITIALIZED;
+	else
+		map->map_state = info->failed_disks ? IMSM_T_STATE_FAILED :
+						      IMSM_T_STATE_NORMAL;
 	map->ddf = 1;
 
 	if (info->level == 1 && info->raid_disks > 2) {

