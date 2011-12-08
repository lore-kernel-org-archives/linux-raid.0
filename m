From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: FIX: Correct make everything and variable initialization
Date: Thu, 08 Dec 2011 14:47:17 +0100
Message-ID: <20111208134717.7802.82360.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

make everything doesn't compile (again) due to not used function warning
and uninitialized variable.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 96b8547..879f4c4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1177,7 +1177,7 @@ void examine_migr_rec_imsm(struct intel_super *super)
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct imsm_dev *dev = __get_imsm_dev(mpb, i);
 		struct imsm_map *map;
-		int slot;
+		int slot = -1;
 
 		if (is_gen_migration(dev) == 0)
 				continue;
@@ -2130,7 +2130,7 @@ static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 	int fd = -1;
 	struct imsm_dev *dev;
 	struct imsm_map *map = NULL;
-	int slot;
+	int slot = -1;
 
 	/* find map under migration */
 	dev = imsm_get_device_during_migration(super);
@@ -2272,7 +2272,7 @@ static int write_imsm_migr_rec(struct supertype *st)
 	map = get_imsm_map(dev, MAP_X);
 
 	for (sd = super->disks ; sd ; sd = sd->next) {
-		int slot;
+		int slot = -1;
 
 		/* skip failed and spare devices */
 		if (sd->index < 0)
@@ -2568,6 +2568,8 @@ static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev,
 static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev,
 			     int look_in_map);
 
+
+#ifndef MDASSEMBLE
 static void manage_second_map(struct intel_super *super, struct imsm_dev *dev)
 {
 	if (is_gen_migration(dev)) {
@@ -2583,6 +2585,7 @@ static void manage_second_map(struct intel_super *super, struct imsm_dev *dev)
 		}
 	}
 }
+#endif
 
 static struct imsm_disk *get_imsm_missing(struct intel_super *super, __u8 index)
 {
@@ -5801,6 +5804,7 @@ static int is_rebuilding(struct imsm_dev *dev)
 		return 0;
 }
 
+#ifndef MDASSEMBLE
 static int is_initializing(struct imsm_dev *dev)
 {
 	struct imsm_map *migr_map;
@@ -5817,8 +5821,8 @@ static int is_initializing(struct imsm_dev *dev)
 		return 1;
 
 	return 0;
-
 }
+#endif
 
 static void update_recovery_start(struct intel_super *super,
 					struct imsm_dev *dev,

