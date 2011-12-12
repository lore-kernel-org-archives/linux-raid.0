From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/2] imsm: FIX: Limit migration record operation by disk slot
	not by index
Date: Mon, 12 Dec 2011 12:07:45 +0100
Message-ID: <20111212110745.8849.76773.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

imsm should store migration record in to 2 first disks in array.
This should be evaluated based on disk slots, not on disks index.
It is not guaranteed that indexes are equal to slots.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index cea314c..d90d96b 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1129,7 +1129,7 @@ static void print_imsm_dev(struct intel_super *super,
 		printf(" <-- %s", map_state_str[map->map_state]);
 		printf("\n     Checkpoint : %u ",
 			   __le32_to_cpu(dev->vol.curr_migr_unit));
-		if ((is_gen_migration(dev)) && (super->disks->index > 1))
+		if ((is_gen_migration(dev)) && ((slot > 1) || (slot < 0)))
 			printf("(N/A)");
 		else
 			printf("(%llu)", (unsigned long long)
@@ -1170,11 +1170,19 @@ void examine_migr_rec_imsm(struct intel_super *super)
 
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct imsm_dev *dev = __get_imsm_dev(mpb, i);
+		struct imsm_map *map;
+		int slot;
+
 		if (is_gen_migration(dev) == 0)
 				continue;
 
 		printf("\nMigration Record Information:");
-		if (super->disks->index > 1) {
+
+		/* map under migration */
+		map = get_imsm_map(dev, MAP_1);
+		if (map)
+			slot = get_imsm_disk_slot(map, super->disks->index);
+		if ((map == NULL) || (slot > 1) || (slot < 0)) {
 			printf(" Empty\n                              ");
 			printf("Examine one of first two disks in array\n");
 			break;
@@ -2082,6 +2090,19 @@ out:
 	return ret_val;
 }
 
+static struct imsm_dev *imsm_get_device_during_migration(
+	struct intel_super *super)
+{
+
+	struct intel_dev *dv;
+
+	for (dv = super->devlist; dv; dv = dv->next) {
+		if (is_gen_migration(dv->dev))
+			return dv->dev;
+	}
+	return NULL;
+}
+
 /*******************************************************************************
  * Function:	load_imsm_migr_rec
  * Description:	Function reads imsm migration record (it is stored at the last
@@ -2100,13 +2121,31 @@ static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 	char nm[30];
 	int retval = -1;
 	int fd = -1;
+	struct imsm_dev *dev;
+	struct imsm_map *map = NULL;
+	int slot;
+
+	/* find map under migration */
+	dev = imsm_get_device_during_migration(super);
+	/* nothing to load,no migration in progress?
+	*/
+	if (dev == NULL)
+		return 0;
+	map = get_imsm_map(dev, MAP_1);
 
 	if (info) {
 		for (sd = info->devs ; sd ; sd = sd->next) {
+			/* skip spare and failed disks
+			 */
+			if (sd->disk.raid_disk < 0)
+				continue;
 			/* read only from one of the first two slots */
-			if ((sd->disk.raid_disk > 1) ||
-			    (sd->disk.raid_disk < 0))
+			if (map)
+				slot = get_imsm_disk_slot(map,
+							  sd->disk.raid_disk);
+			if ((map == NULL) || (slot > 1) || (slot < 0))
 				continue;
+
 			sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
 			fd = dev_open(nm, O_RDONLY);
 			if (fd >= 0)
@@ -2115,8 +2154,14 @@ static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 	}
 	if (fd < 0) {
 		for (dl = super->disks; dl; dl = dl->next) {
+			/* skip spare and failed disks
+			*/
+			if (dl->index < 0)
+				continue;
 			/* read only from one of the first two slots */
-			if (dl->index > 1)
+			if (map)
+				slot = get_imsm_disk_slot(map, dl->index);
+			if ((map == NULL) || (slot > 1) || (slot < 0))
 				continue;
 			sprintf(nm, "%d:%d", dl->major, dl->minor);
 			fd = dev_open(nm, O_RDONLY);
@@ -2200,11 +2245,32 @@ static int write_imsm_migr_rec(struct supertype *st)
 	struct dl *sd;
 	int len;
 	struct imsm_update_general_migration_checkpoint *u;
+	struct imsm_dev *dev;
+	struct imsm_map *map = NULL;
+
+	/* find map under migration */
+	dev = imsm_get_device_during_migration(super);
+	/* if no migration, write buffer anyway to clear migr_record
+	 * on disk based on first available device
+	*/
+	if (dev == NULL)
+		dev = get_imsm_dev(super, super->current_vol < 0 ? 0 :
+					  super->current_vol);
+
+	map = get_imsm_map(dev, MAP_X);
 
 	for (sd = super->disks ; sd ; sd = sd->next) {
+		int slot;
+
+		/* skip failed and spare devices */
+		if (sd->index < 0)
+			continue;
 		/* write to 2 first slots only */
-		if ((sd->index < 0) || (sd->index > 1))
+		if (map)
+			slot = get_imsm_disk_slot(map, sd->index);
+		if ((map == NULL) || (slot > 1) || (slot < 0))
 			continue;
+
 		sprintf(nm, "%d:%d", sd->major, sd->minor);
 		fd = dev_open(nm, O_RDWR);
 		if (fd < 0)

