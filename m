From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 25/29] Takeover raid10 -> raid0 for external metadata
Date: Thu, 09 Dec 2010 16:22:07 +0100
Message-ID: <20101209152207.26876.27492.stgit@gklab-170-024.igk.intel.com>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

The patch introduces takeover form level 10 to level 0 for imsm
metadata. This patch contains procedures connected with preparing
and applying metadata update during 10 -> 0 takeover.
When performing takeover 10->0 mdmon should update the external
metadata (due to disk slot and level changes).
To achieve that mdadm, after changing the level in md, mdadm calls
reshape_super() with and prepare the "update_level" metadata update type.
reshape_super) allocates a new imsm_dev with updated disk slot
numbers to be processed by mdmon in process_update().
process_update() discovers missing disks and adds them to imsm
metadata.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---

 super-intel.c |  193 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 193 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 589d40c..14c009b 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5625,6 +5625,92 @@ update_reshape_exit:
 		break;
 	}
 	case update_level: {
+		struct imsm_update_level *u = (void *)update->buf;
+		struct imsm_dev *dev_new, *dev = NULL;
+		struct imsm_map *map;
+		struct dl *d;
+		int i, j;
+		int start_disk;
+
+		dev_new = &u->dev;
+		for (i = 0; i < mpb->num_raid_devs; i++) {
+			dev = get_imsm_dev(super, i);
+			if (strcmp((char *)dev_new->volume,
+				   (char *)dev->volume) == 0)
+				break;
+		}
+		if (i == super->anchor->num_raid_devs)
+			return;
+
+		if (dev == NULL)
+			return;
+
+		struct imsm_disk_changes *changes = (struct imsm_disk_changes *)
+						((void *)u + u->changes_offset);
+		map = get_imsm_map(dev_new, 0);
+		int *tab = (int *)&map->disk_ord_tbl;
+
+		/* iterate through devices to mark unused disks as spare
+		 * and update order table
+		 */
+		for (i = 0; i < u->rm_qan; i++) {
+			struct dl *dm = NULL;
+			for (dm = super->disks; dm; dm = dm->next) {
+				if ((dm->major != changes[i].major) ||
+				    (dm->minor != changes[i].minor))
+					continue;
+				for (j = 0; j < u->disk_qan; j++)
+					if ((tab[j] > dm->index) &&
+					    (dm->index >= 0))
+						tab[j]--;
+				struct dl *du;
+				for (du = super->disks; du; du = du->next)
+					if ((du->index > dm->index) &&
+					    (du->index > 0))
+						du->index--;
+				dm->disk.status = SPARE_DISK;
+				dm->index = -1;
+			}
+		}
+
+		if (u->rm_qan) {
+			/* Remove unused entrys in disk_ord_tbl */
+			for (i = 0; i < u->disk_qan; i++) {
+				if (tab[i] < 0)
+					for (j = i; j < (u->disk_qan - 1); j++)
+						tab[j] = tab[j+1];
+			}
+		}
+
+		imsm_copy_dev(dev, dev_new);
+		map = get_imsm_map(dev, 0);
+		start_disk = mpb->num_disks;
+
+		/* clear missing disks list */
+		while (super->missing) {
+			d = super->missing;
+			super->missing = d->next;
+			__free_imsm_disk(d);
+		}
+		if (u->rm_qan)
+			find_missing(super);
+
+		/* clear new disk entries if number of disks increased*/
+		d = super->missing;
+		for (i = start_disk; i < map->num_members; i++) {
+			if (!d)
+				break;
+			memset(&d->disk, 0, sizeof(d->disk));
+			strcpy((char *)d->disk.serial, "MISSING");
+			d->disk.total_blocks = map->blocks_per_member;
+			/* Set slot for missing disk */
+			set_imsm_ord_tbl_ent(map, i, d->index |
+					     IMSM_ORD_REBUILD);
+			d->raiddisk = i;
+			d = d->next;
+		}
+
+		super->updates_pending++;
 		break;
 	}
 	case update_activate_spare: {
@@ -6193,6 +6279,113 @@ static int update_level_imsm(struct supertype *st, struct mdinfo *info,
 			     struct geo_params *geo, int verbose,
 			     int uuid_set, char *homehost)
 {
+	struct intel_super *super = st->sb;
+	struct imsm_update_level *u;
+	struct imsm_dev *dev_new, *dev = NULL;
+	struct imsm_map *map_new, *map;
+	struct mdinfo *newdi;
+	struct dl *dl;
+	int *tmp_ord_tbl;
+	int i, slot, idx;
+	int len;
+
+	/* update level is used only for 0->10 and 10->0 transitions */
+	if ((info->array.level != 10 && (geo->level != 0)) &&
+		((info->array.level != 0) && (geo->level != 10)))
+		return 1;
+
+	dev = __get_imsm_dev(super->anchor, 0);
+
+	map = get_imsm_map(dev, 0);
+	geo->raid_disks = (geo->level == 10) ? 4 : map->num_members;
+
+	if (!is_raid_level_supported(super->orom,
+				     geo->level,
+				     geo->raid_disks))
+		return 1;
+
+	len = sizeof(struct imsm_update_level) +
+		((geo->raid_disks - 1) * sizeof(__u32)) +
+		(geo->raid_disks * sizeof(struct imsm_disk_changes));
+
+	u = malloc(len);
+	if (u == NULL)
+		return 1;
+
+	u->changes_offset = sizeof(struct imsm_update_level) +
+			    ((geo->raid_disks - 1) * sizeof(__u32));
+	struct imsm_disk_changes *change = (struct imsm_disk_changes *)
+					((void *)u + u->changes_offset);
+	u->rm_qan = 0;
+	u->disk_list = NULL;
+	u->disk_qan = geo->raid_disks;
+
+	dev_new = &u->dev;
+	imsm_copy_dev(dev_new, dev);
+	map_new = get_imsm_map(dev_new, 0);
+
+	tmp_ord_tbl = malloc(sizeof(int) * geo->raid_disks);
+	if (tmp_ord_tbl == NULL) {
+		free(u);
+		return 1;
+	}
+
+	for (i = 0; i < geo->raid_disks; i++) {
+		tmp_ord_tbl[i] = -1;
+		change[i].major = -1;
+		change[i].minor = -1;
+	}
+
+	/* 10->0 transition:
+	 * - mark unused disks
+	 * - update indexes in order table
+	 */
+	if (geo->level == 0) {
+		/* iterate through devices to detect slot changes */
+		i = 0;
+		for (dl = super->disks; dl; dl = dl->next) {
+			idx = -1;
+			for (newdi = info->devs; newdi; newdi = newdi->next) {
+				if ((dl->major != newdi->disk.major) ||
+					    (dl->minor != newdi->disk.minor) ||
+					    (newdi->disk.raid_disk < 0))
+					continue;
+				slot = get_imsm_disk_slot(map, dl->index);
+				idx = get_imsm_ord_tbl_ent(dev_new, slot);
+				tmp_ord_tbl[newdi->disk.raid_disk] = idx;
+				break;
+			}
+			/* if slot not found, mark disk as not used */
+			if ((idx == -1) && (!(dl->disk.status & SPARE_DISK))) {
+				change[i].major = dl->major;
+				change[i].minor = dl->minor;
+				u->rm_qan++;
+				i++;
+			}
+		}
+		for (i = 0; i < geo->raid_disks; i++)
+			set_imsm_ord_tbl_ent(map_new, i, tmp_ord_tbl[i]);
+	}
+
+	map_new->num_members = (geo->level == 10) ?
+				geo->raid_disks :
+				(info->array.raid_disks - u->rm_qan);
+	map_new->map_state = IMSM_T_STATE_NORMAL;
+	map_new->failed_disk_num = 0;
+
+	if (geo->level == 10) {
+		map_new->num_domains = map_new->num_members / 2;
+		map_new->raid_level = 1;
+	} else {
+		map_new->num_domains = 1;
+		map_new->raid_level = geo->level;
+	}
+
+	u->type = update_level;
+	u->delta_disks = 0;
+	u->container_member = info->container_member;
+	append_metadata_update(st, u, len);
+	free(tmp_ord_tbl);
 	return 0;
 }
 

