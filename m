From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/4] FIX: Always report new raid_disks during migration
Date: Fri, 15 Apr 2011 14:30:31 +0200
Message-ID: <20110415123031.6601.67422.stgit@gklab-128-013.igk.intel.com>
References: <20110415122820.6601.48084.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110415122820.6601.48084.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

To behalf in the similar way as native metadata during migration,
new raid disks number has to be reported by metadata handler.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index dc5e34e..83135a6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1755,7 +1755,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 		if (dl->raiddisk == info->disk.raid_disk)
 			break;
 	info->container_member	  = super->current_vol;
-	info->array.raid_disks    = map_to_analyse->num_members;
+	info->array.raid_disks    = map->num_members;
 	info->array.level	  = get_imsm_raid_level(map_to_analyse);
 	info->array.layout	  = imsm_level_to_layout(info->array.level);
 	info->array.md_minor	  = -1;

