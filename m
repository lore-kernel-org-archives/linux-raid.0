From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 12/22] imsm: update blocks_per_migr_unit() to support
	migration record
Date: Thu, 02 Jun 2011 16:49:51 +0200
Message-ID: <20110602144951.27355.24237.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

blocks_per_migr_unit() has to use information from migration record
for general migration case. This causes to pass intel_super pointer
to this function and some other interfaces changes.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |   46 ++++++++++++++++++++++++++++++----------------
 1 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index c40c02a..d80e530 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -915,9 +915,13 @@ static unsigned long long min_acceptable_spare_size_imsm(struct supertype *st)
 }
 
 #ifndef MDASSEMBLE
-static __u64 blocks_per_migr_unit(struct imsm_dev *dev);
+static __u64 blocks_per_migr_unit(struct intel_super *super,
+				  struct imsm_dev *dev);
 
-static void print_imsm_dev(struct imsm_dev *dev, char *uuid, int disk_idx)
+static void print_imsm_dev(struct intel_super *super,
+			   struct imsm_dev *dev,
+			   char *uuid,
+			   int disk_idx)
 {
 	__u64 sz;
 	int slot, i;
@@ -1008,7 +1012,7 @@ static void print_imsm_dev(struct imsm_dev *dev, char *uuid, int disk_idx)
 		printf(" <-- %s", map_state_str[map->map_state]);
 		printf("\n     Checkpoint : %u (%llu)",
 		       __le32_to_cpu(dev->vol.curr_migr_unit),
-		       (unsigned long long)blocks_per_migr_unit(dev));
+		       (unsigned long long)blocks_per_migr_unit(super, dev));
 	}
 	printf("\n");
 	printf("    Dirty State : %s\n", dev->vol.dirty ? "dirty" : "clean");
@@ -1138,7 +1142,7 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 		info.devs = NULL;
 		getinfo_super_imsm(st, &info, NULL);
 		fname_from_uuid(st, &info, nbuf, ':');
-		print_imsm_dev(dev, nbuf + 5, super->disks->index);
+		print_imsm_dev(super, dev, nbuf + 5, super->disks->index);
 	}
 	for (i = 0; i < mpb->num_disks; i++) {
 		if (i == super->disks->index)
@@ -1784,7 +1788,8 @@ static __u32 map_migr_block(struct imsm_dev *dev, __u32 block)
 	}
 }
 
-static __u64 blocks_per_migr_unit(struct imsm_dev *dev)
+static __u64 blocks_per_migr_unit(struct intel_super *super,
+				  struct imsm_dev *dev)
 {
 	/* calculate the conversion factor between per member 'blocks'
 	 * (md/{resync,rebuild}_start) and imsm migration units, return
@@ -1794,7 +1799,10 @@ static __u64 blocks_per_migr_unit(struct imsm_dev *dev)
 		return 0;
 
 	switch (migr_type(dev)) {
-	case MIGR_GEN_MIGR:
+	case MIGR_GEN_MIGR: {
+		struct migr_record *migr_rec = super->migr_rec;
+		return __le32_to_cpu(migr_rec->blocks_per_unit);
+	}
 	case MIGR_VERIFY:
 	case MIGR_REPAIR:
 	case MIGR_INIT: {
@@ -1992,6 +2000,7 @@ static int write_imsm_migr_rec(struct supertype *st)
 static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info, char *dmap)
 {
 	struct intel_super *super = st->sb;
+	struct migr_record *migr_rec = super->migr_rec;
 	struct imsm_dev *dev = get_imsm_dev(super, super->current_vol);
 	struct imsm_map *map = get_imsm_map(dev, 0);
 	struct imsm_map *prev_map = get_imsm_map(dev, 1);
@@ -2106,15 +2115,17 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 		switch (migr_type(dev)) {
 		case MIGR_REPAIR:
 		case MIGR_INIT: {
-			__u64 blocks_per_unit = blocks_per_migr_unit(dev);
+			__u64 blocks_per_unit = blocks_per_migr_unit(super,
+								     dev);
 			__u64 units = __le32_to_cpu(dev->vol.curr_migr_unit);
 
 			info->resync_start = blocks_per_unit * units;
 			break;
 		}
 		case MIGR_GEN_MIGR: {
-			__u64 blocks_per_unit = blocks_per_migr_unit(dev);
-			__u64 units = __le32_to_cpu(dev->vol.curr_migr_unit);
+			__u64 blocks_per_unit = blocks_per_migr_unit(super,
+								     dev);
+			__u64 units = __le32_to_cpu(migr_rec->curr_migr_unit);
 			unsigned long long array_blocks;
 			int used_disks;
 
@@ -5256,7 +5267,9 @@ static int is_rebuilding(struct imsm_dev *dev)
 		return 0;
 }
 
-static void update_recovery_start(struct imsm_dev *dev, struct mdinfo *array)
+static void update_recovery_start(struct intel_super *super,
+					struct imsm_dev *dev,
+					struct mdinfo *array)
 {
 	struct mdinfo *rebuild = NULL;
 	struct mdinfo *d;
@@ -5283,7 +5296,7 @@ static void update_recovery_start(struct imsm_dev *dev, struct mdinfo *array)
 	}
 
 	units = __le32_to_cpu(dev->vol.curr_migr_unit);
-	rebuild->recovery_start = units * blocks_per_migr_unit(dev);
+	rebuild->recovery_start = units * blocks_per_migr_unit(super, dev);
 }
 
 
@@ -5447,7 +5460,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 			info_d->component_size = __le32_to_cpu(map->blocks_per_member);
 		}
 		/* now that the disk list is up-to-date fixup recovery_start */
-		update_recovery_start(dev, this);
+		update_recovery_start(super, dev, this);
 		this->array.spare_disks += spare_disks;
 		rest = this;
 	}
@@ -5839,7 +5852,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 
 mark_checkpoint:
 	/* check if we can update curr_migr_unit from resync_start, recovery_start */
-	blocks_per_unit = blocks_per_migr_unit(dev);
+	blocks_per_unit = blocks_per_migr_unit(super, dev);
 	if (blocks_per_unit) {
 		__u32 units32;
 		__u64 units;
@@ -8623,9 +8636,10 @@ static int imsm_manage_reshape(
 		sysfs_set_num(sra, NULL, "suspend_hi", next_step);
 
 		/* wait until reshape finish */
-		if (wait_for_reshape_imsm(sra, next_step, ndata) < 0)
-			dprintf("wait_for_reshape_imsm returned error,"
-				" but we ignore it!\n");
+		if (wait_for_reshape_imsm(sra, next_step, ndata) < 0) {
+			dprintf("wait_for_reshape_imsm returned error!\n");
+			goto abort;
+		}
 
 		sra->reshape_progress = next_step;
 

