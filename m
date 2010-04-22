From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 08/13] mdmon: enable delete subarray for managed containers
Date: Thu, 22 Apr 2010 23:12:20 +0100
Message-ID: <66C59AD0932712458090B447266D638CD405E3BC@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Added new metatata_update type named update_kill_subarray and its
update_process service to perform delete_subarray in context of mdmon. It
allows to modify metadata of managed arrays.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 super-intel.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 10cf814..739ab7d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -283,6 +283,7 @@ enum imsm_update_type {
 	update_activate_spare,
 	update_create_array,
 	update_add_disk,
+	update_kill_subarray,
 };
 
 struct imsm_update_activate_spare {
@@ -3454,6 +3455,12 @@ static int write_init_super_imsm(struct supertype *st)
 }
 #endif
 
+struct imsm_vol_modify_data
+{
+	enum imsm_update_type type;
+	int index;
+};
+
 int delete_subarray_imsm(struct supertype *st, int fd)
 {
 	struct intel_super *super = st->sb;
@@ -3470,8 +3477,24 @@ int delete_subarray_imsm(struct supertype *st, int fd)
 		return 1;
 	}
 
-	if (mdmon_running(st->container_dev))
-		return 1;
+	if (!st->arrays && mdmon_running(st->container_dev)) {
+		/* delegate mdmon to do this job */
+		struct imsm_vol_modify_data *u;
+
+		u = malloc(sizeof(*u));
+		if (!u)
+			return 3;
+
+		u->type = update_kill_subarray;
+		u->index = container_index;
+
+		st->update_tail = &st->updates;
+		append_metadata_update(st, u, sizeof(*u));
+
+		flush_metadata_updates(st);
+
+		return 0;
+	}
 
 	/* First case: 2 volumes */
 	if (mpb->num_raid_devs > 1) {
@@ -3543,6 +3566,28 @@ int delete_subarray_imsm(struct supertype *st, int fd)
 			map_unlock(&map);
 			map_free(map);
 		}
+
+                if (!rv && st->arrays) {
+                        if (st->arrays->info.container_member == container_index) {
+                                struct active_array *t = st->arrays;
+                                st->arrays = st->arrays->next;
+                                free(t);
+                        } else {
+				struct active_array *ap = st->arrays;
+				struct active_array *a = st->arrays->next;
+				while(a) {
+					if (a->info.container_member == container_index) {
+						struct active_array *t = a;
+						ap->next = a->next;
+						a = a->next;
+						free(t);
+					} else {
+						ap = a;
+						a = a->next;
+					}
+				}
+                        }
+                }
 	} else { /* second case: 1 volume */
 		struct dl *d;
 		for (d = super->disks; d; d = d->next)
@@ -5179,6 +5224,13 @@ static void imsm_process_update(struct supertype *st,
 		}
 
 		break;
+	case update_kill_subarray: {
+		struct imsm_vol_modify_data *u = (void *)update->buf;
+
+		super->current_vol = u->index;
+		st->ss->delete_subarray(st, -1);
+		break;
+	}
 	}
 }
 
-- 
1.6.4.2

BBBB

--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski
Software Development Engineer


