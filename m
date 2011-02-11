From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/4] imsm: prepare update for level migrations reshape
Date: Fri, 11 Feb 2011 14:43:59 +0100
Message-ID: <20110211134359.6212.93337.stgit@gklab-128-013.igk.intel.com>
References: <20110211133959.6212.57757.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110211133959.6212.57757.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

For level migrations:
1. raid0->raid5
2. raid5->raid0

metadata update is prepared
If migration raid0->raid5 can get spare device it is included in to update also.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |  105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e06a6f4..fbc71ab 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -305,6 +305,7 @@ enum imsm_update_type {
 	update_rename_array,
 	update_add_remove_disk,
 	update_reshape_container_disks,
+	update_reshape_migration,
 	update_takeover
 };
 
@@ -340,6 +341,12 @@ struct imsm_update_reshape {
 	enum imsm_update_type type;
 	int old_raid_disks;
 	int new_raid_disks;
+	/* fields for array migration changes
+	 */
+	int subdev;
+	int new_level;
+	int new_layout;
+
 	int new_disks[1]; /* new_raid_disks - old_raid_disks makedev number */
 };
 
@@ -6132,6 +6139,9 @@ static void imsm_process_update(struct supertype *st,
 			super->updates_pending++;
 		break;
 	}
+	case update_reshape_migration: {
+		break;
+	}
 	case update_activate_spare: {
 		struct imsm_update_activate_spare *u = (void *) update->buf; 
 		struct imsm_dev *dev = get_imsm_dev(super, u->array);
@@ -6525,6 +6535,9 @@ static void imsm_prepare_update(struct supertype *st,
 		dprintf("New anchor length is %llu\n", (unsigned long long)len);
 		break;
 	}
+	case update_reshape_migration: {
+		break;
+	}
 	case update_create_array: {
 		struct imsm_update_create_array *u = (void *) update->buf;
 		struct intel_dev *dv;
@@ -6891,6 +6904,78 @@ abort:
 	return 0;
 }
 
+/******************************************************************************
+ * function: imsm_create_metadata_update_for_migration()
+ *           Creates update for IMSM array.
+ *
+ ******************************************************************************/
+static int imsm_create_metadata_update_for_migration(
+					struct supertype *st,
+					struct geo_params *geo,
+					struct imsm_update_reshape **updatep)
+{
+	struct intel_super *super = st->sb;
+	int update_memory_size = 0;
+	struct imsm_update_reshape *u = NULL;
+	int delta_disks = 0;
+
+	dprintf("imsm_create_metadata_update_for_migration(enter)"
+		" New Level = %i\n", geo->level);
+	delta_disks = 0;
+
+	/* size of all update data without anchor */
+	update_memory_size = sizeof(struct imsm_update_reshape);
+
+	/* now add space for spare disks that we need to add. */
+	if (delta_disks > 0)
+		update_memory_size += sizeof(u->new_disks[0])
+					* (delta_disks - 1);
+
+	u = calloc(1, update_memory_size);
+	if (u == NULL) {
+		dprintf("error: cannot get memory for "
+			"imsm_create_metadata_update_for_migration\n");
+		return 0;
+	}
+	u->type = update_reshape_migration;
+	u->subdev = super->current_vol;
+	u->new_level = geo->level;
+	u->new_layout = geo->layout;
+	u->new_raid_disks = u->old_raid_disks = geo->raid_disks;
+	u->new_disks[0] = -1;
+	if (geo->level == 5) {
+		struct mdinfo *spares = NULL;
+
+		u->new_raid_disks++;
+		spares = get_spares_for_grow(st);
+		if (spares) {
+			struct dl *dl;
+			struct mdinfo *dev;
+
+			dev = spares->devs;
+			if (dev) {
+				u->new_disks[0] = makedev(dev->disk.major,
+							  dev->disk.minor);
+				dl = get_disk_super(super,
+						    dev->disk.major,
+						    dev->disk.minor);
+				dl->index = u->old_raid_disks;
+				dev = dev->next;
+			}
+			sysfs_free(spares);
+		} else {
+			free(u);
+			dprintf("error: cannot get spare device "
+				"for requested migration");
+			return 0;
+		}
+	}
+	dprintf("imsm: reshape update preparation : OK\n");
+	*updatep = u;
+
+	return update_memory_size;
+}
+
 static void imsm_update_metadata_locally(struct supertype *st,
 					 void *buf, int len)
 {
@@ -7145,9 +7230,25 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 		case CH_TAKEOVER:
 			ret_val = imsm_takeover(st, &geo);
 			break;
-		case CH_MIGRATION:
+		case CH_MIGRATION: {
+			struct imsm_update_reshape *u = NULL;
+			int len =
+				imsm_create_metadata_update_for_migration(
+					st, &geo, &u);
+			if (len < 1) {
+				dprintf("imsm: "
+					"Cannot prepare update\n");
+			}
 			ret_val = 0;
-			break;
+			/* update metadata locally */
+			imsm_update_metadata_locally(st, u, len);
+			/* and possibly remotely */
+			if (st->update_tail)
+				append_metadata_update(st, u, len);
+			else
+				free(u);
+		}
+		break;
 		default:
 			ret_val = 1;
 		}

