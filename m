From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] imsm: fix: correct printing value of blocks per migration unit
Date: Fri, 18 Nov 2011 15:28:36 +0100
Message-ID: <20111118142836.12499.22937.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The value of blocks per migration unit is not printed correctly
when the metadata's content is examined using -E option on disks
without present migration record. (Migration record is present only
on 2 first disks in array due to IMSM compatibility restrictions.)

Printing the value of blocks per migration unit was corrected.
It is printed as N/A (Not Available) for disks
without the migration record.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2d9444e..360c4cc 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1018,6 +1018,8 @@ static unsigned long long min_acceptable_spare_size_imsm(struct supertype *st)
 static __u64 blocks_per_migr_unit(struct intel_super *super,
 				  struct imsm_dev *dev);
 
+static int is_gen_migration(struct imsm_dev *dev);
+
 static void print_imsm_dev(struct intel_super *super,
 			   struct imsm_dev *dev,
 			   char *uuid,
@@ -1110,9 +1112,13 @@ static void print_imsm_dev(struct intel_super *super,
 		struct imsm_map *map = get_imsm_map(dev, 1);
 
 		printf(" <-- %s", map_state_str[map->map_state]);
-		printf("\n     Checkpoint : %u (%llu)",
-		       __le32_to_cpu(dev->vol.curr_migr_unit),
-		       (unsigned long long)blocks_per_migr_unit(super, dev));
+		printf("\n     Checkpoint : %u ",
+			   __le32_to_cpu(dev->vol.curr_migr_unit));
+		if ((is_gen_migration(dev)) && (super->disks->index > 1))
+			printf("(N/A)");
+		else
+			printf("(%llu)", (unsigned long long)
+				   blocks_per_migr_unit(super, dev));
 	}
 	printf("\n");
 	printf("    Dirty State : %s\n", dev->vol.dirty ? "dirty" : "clean");
@@ -1141,8 +1147,6 @@ static void print_imsm_disk(struct imsm_disk *disk, int index, __u32 reserved)
 	       human_size(sz * 512));
 }
 
-static int is_gen_migration(struct imsm_dev *dev);
-
 void examine_migr_rec_imsm(struct intel_super *super)
 {
 	struct migr_record *migr_rec = super->migr_rec;

