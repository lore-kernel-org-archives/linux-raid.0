From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: FIX: Use first map only in migration record disk
	operations
Date: Fri, 09 Dec 2011 12:57:20 +0100
Message-ID: <20111209115720.5396.83087.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

This patch is addition to patch:
    "imsm: FIX: Limit migration record operation by disk slot not by index"
Location of migration record (2 first slots) should be taken on up to date
information. It is in first map.
Change slot verification to use first map only.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 879f4c4..92ff79c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1185,7 +1185,7 @@ void examine_migr_rec_imsm(struct intel_super *super)
 		printf("\nMigration Record Information:");
 
 		/* map under migration */
-		map = get_imsm_map(dev, MAP_1);
+		map = get_imsm_map(dev, MAP_0);
 		if (map)
 			slot = get_imsm_disk_slot(map, super->disks->index);
 		if ((map == NULL) || (slot > 1) || (slot < 0)) {
@@ -2138,7 +2138,7 @@ static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 	*/
 	if (dev == NULL)
 		return 0;
-	map = get_imsm_map(dev, MAP_1);
+	map = get_imsm_map(dev, MAP_0);
 
 	if (info) {
 		for (sd = info->devs ; sd ; sd = sd->next) {
@@ -2269,7 +2269,7 @@ static int write_imsm_migr_rec(struct supertype *st)
 			vol = 0;
 		dev = get_imsm_dev(super, super->current_vol);
 	}
-	map = get_imsm_map(dev, MAP_X);
+	map = get_imsm_map(dev, MAP_0);
 
 	for (sd = super->disks ; sd ; sd = sd->next) {
 		int slot = -1;

