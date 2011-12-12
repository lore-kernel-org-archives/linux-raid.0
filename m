From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/2] imsm: FIX: Use first map only in migration record disk
	operations
Date: Mon, 12 Dec 2011 12:07:53 +0100
Message-ID: <20111212110753.8849.40342.stgit@gklab-128-013.igk.intel.com>
References: <20111212110745.8849.76773.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111212110745.8849.76773.stgit@gklab-128-013.igk.intel.com>
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

 super-intel.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index d90d96b..bfbaf10 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1178,8 +1178,8 @@ void examine_migr_rec_imsm(struct intel_super *super)
 
 		printf("\nMigration Record Information:");
 
-		/* map under migration */
-		map = get_imsm_map(dev, MAP_1);
+		/* first map under migration */
+		map = get_imsm_map(dev, MAP_0);
 		if (map)
 			slot = get_imsm_disk_slot(map, super->disks->index);
 		if ((map == NULL) || (slot > 1) || (slot < 0)) {
@@ -2131,7 +2131,7 @@ static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 	*/
 	if (dev == NULL)
 		return 0;
-	map = get_imsm_map(dev, MAP_1);
+	map = get_imsm_map(dev, MAP_0);
 
 	if (info) {
 		for (sd = info->devs ; sd ; sd = sd->next) {
@@ -2257,7 +2257,7 @@ static int write_imsm_migr_rec(struct supertype *st)
 		dev = get_imsm_dev(super, super->current_vol < 0 ? 0 :
 					  super->current_vol);
 
-	map = get_imsm_map(dev, MAP_X);
+	map = get_imsm_map(dev, MAP_0);
 
 	for (sd = super->disks ; sd ; sd = sd->next) {
 		int slot;

