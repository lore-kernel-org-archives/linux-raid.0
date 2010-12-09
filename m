From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 26/29] Takeover raid0 -> raid10 for external metadata
Date: Thu, 09 Dec 2010 16:22:16 +0100
Message-ID: <20101209152216.26876.4532.stgit@gklab-170-024.igk.intel.com>
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

The patch introduces takeover form level 0 to level 10 for imsm
metadata. This patch contains procedures connected with preparing
and applying metadata update during 0 -> 10 takeover.

When performing takeover 0->10 mdmon should update the external
metadata (due to disk slot and level changes).
To achieve that mdadm, after changing the level in md, calls
reshape_super() with and prepare the "update_level" metadata update
type.
reshape_super) allocates a new imsm_dev with updated disk slot
numbers to be processed by mdmon in process_update().
process_update() discovers missing disks and adds them to imsm
metadata.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---

 Grow.c        |    2 ++
 super-intel.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 833b0bc..3d74db1 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1368,6 +1368,8 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				}
 				goto release;
 			}
+			if (level == 10)
+				goto release;
 			orig = array;
 			orig_level = orig.level;
 			ioctl(fd, GET_ARRAY_INFO, &array);
diff --git a/super-intel.c b/super-intel.c
index 14c009b..0488c1c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3624,6 +3624,8 @@ static int write_super_imsm(struct supertype *st, int doclose)
 	for (d = super->disks; d ; d = d->next) {
 		if (d->index < 0)
 			continue;
+		if (d->fd < 0)
+			continue;
 		if (store_imsm_mpb(d->fd, mpb))
 			fprintf(stderr, "%s: failed for device %d:%d %s\n",
 				__func__, d->major, d->minor, strerror(errno));
@@ -5682,6 +5684,25 @@ update_reshape_exit:
 			}
 		}
 
+		if (u->add_qan)
+			for (i = 0; i < u->disk_qan; i++)
+				tab[i] = i;
+
+		struct dl *dc;
+		for (i = 0; i < u->add_qan; i++) {
+			/* update indexes in current list */
+			for (dc = super->disks; dc; dc = dc->next) {
+				if (dc->index >= changes[i].index)
+					dc->index++;
+			}
+			/* mark dummy disks for rebuild */
+			tab[changes[i].index] |= IMSM_ORD_REBUILD;
+		}
+		/* append dummy disk list at the end of current list */
+		for (dc = super->disks; dc->next; dc = dc->next)
+			; /* nothing to do, just go to the end of list */
+		dc->next = u->disk_list;
+
 		imsm_copy_dev(dev, dev_new);
 		map = get_imsm_map(dev, 0);
 		start_disk = mpb->num_disks;
@@ -6098,6 +6119,33 @@ static void imsm_prepare_update(struct supertype *st,
 		break;
 	}
 	case update_level: {
+		struct imsm_update_level *u = (void *) update->buf;
+		int i;
+		struct imsm_disk_changes *changes = (struct imsm_disk_changes *)
+						((void *)u + u->changes_offset);
+
+		dprintf("prepare_update(): update level\n");
+
+		for (i = 0; i < u->add_qan; i++) {
+			struct dl *d = calloc(1, sizeof(struct dl));
+			if (!d)
+				break;
+			memcpy(d, super->disks, sizeof(struct dl));
+
+			d->disk.status = FAILED_DISK;
+			strcpy((char *)d->disk.serial, "dummy");
+			strcpy((char *)d->serial, "dummy");
+			d->disk.scsi_id = 0;
+			d->fd = -1;
+			d->minor = 0;
+			d->major = 0;
+			d->index = changes[i].index;
+			d->next = u->disk_list;
+			u->disk_list = d;
+		}
+		len = disks_to_mpb_size(u->add_qan +
+					mpb->num_disks -
+					u->rm_qan);
 		break;
 	}
 	case update_create_array: {
@@ -6317,6 +6365,7 @@ static int update_level_imsm(struct supertype *st, struct mdinfo *info,
 	struct imsm_disk_changes *change = (struct imsm_disk_changes *)
 					((void *)u + u->changes_offset);
 	u->rm_qan = 0;
+	u->add_qan = 0;
 	u->disk_list = NULL;
 	u->disk_qan = geo->raid_disks;
 
@@ -6334,6 +6383,7 @@ static int update_level_imsm(struct supertype *st, struct mdinfo *info,
 		tmp_ord_tbl[i] = -1;
 		change[i].major = -1;
 		change[i].minor = -1;
+		change[i].index = -1;
 	}
 
 	/* 10->0 transition:
@@ -6367,9 +6417,28 @@ static int update_level_imsm(struct supertype *st, struct mdinfo *info,
 			set_imsm_ord_tbl_ent(map_new, i, tmp_ord_tbl[i]);
 	}
 
+	/* 0->10 transition:
+	 * - add dummy disks to metdata
+	 * - store slots for dummy disks in update buffer
+	 */
+	if (geo->level == 10) {
+		u->add_qan = 0;
+		for (i = 0; i < geo->raid_disks; i++) {
+			int found = 0;
+			for (newdi = info->devs; newdi; newdi = newdi->next) {
+				if (newdi->disk.raid_disk == i) {
+					found = 1;
+					break;
+				}
+			}
+		if (!found)
+			change[u->add_qan++].index = i;
+		}
+	}
+
 	map_new->num_members = (geo->level == 10) ?
-				geo->raid_disks :
-				(info->array.raid_disks - u->rm_qan);
+		geo->raid_disks :
+		(info->array.raid_disks - u->rm_qan);
 	map_new->map_state = IMSM_T_STATE_NORMAL;
 	map_new->failed_disk_num = 0;
 

