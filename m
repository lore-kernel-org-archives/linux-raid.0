From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 11/13] mdmon: enable rename subarray for managed containers
Date: Thu, 22 Apr 2010 23:12:41 +0100
Message-ID: <66C59AD0932712458090B447266D638CD405E3BF@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Added new metatata_update type update_rename_subarray and its update_process
service to perform rename_subarray in context of mdmon. It allows to modify
metadata of managed arrays)

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 super-intel.c |   42 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index b26cd06..3b21cd9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -284,6 +284,7 @@ enum imsm_update_type {
 	update_create_array,
 	update_add_disk,
 	update_kill_subarray,
+	update_rename_subarray,
 };
 
 struct imsm_update_activate_spare {
@@ -3458,6 +3459,7 @@ static int write_init_super_imsm(struct supertype *st)
 struct imsm_vol_modify_data
 {
 	enum imsm_update_type type;
+	char name[36];
 	int index;
 };
 
@@ -3646,13 +3648,40 @@ static int rename_subarray_imsm(struct supertype *st, char *new_name, int fd)
 		return 1;
 	}
 
+	/* delegate mdmon to do this job */
+	if (!st->arrays && mdmon_running(st->container_dev)) {
+		struct imsm_vol_modify_data *u;
+
+		u = malloc(sizeof(*u));
+		if (!u)
+			return 3;
+
+		u->type = update_rename_subarray;
+		u->index = container_index;
+		strcpy(u->name, new_name);
+
+		st->update_tail = &st->updates;
+		append_metadata_update(st, u, sizeof(*u));
+
+		flush_metadata_updates(st);
+
+		return 0;
+	}
+
 	dev = get_imsm_dev(super, container_index);
 	strncpy((char *) dev->volume, new_name, MAX_RAID_SERIAL_LEN);
 
-	/* use passed fd as handle in intel_super is not available */
-	super->disks->fd = fd;
+	if (st->arrays) /* mdmon context */
+		super->updates_pending++;
+	else {
+		/* use passed fd as if container is not loaded, handle in
+		 * intel_super is not available
+		 */
+		if (!st->loaded_container)
+			super->disks->fd = fd;
 
-	rv = write_super_imsm(super, 0);
+		rv = write_super_imsm(super, 0);
+	}
 
 	return rv;
 }
@@ -5291,6 +5320,13 @@ static void imsm_process_update(struct supertype *st,
 		st->ss->delete_subarray(st, -1);
 		break;
 	}
+	case update_rename_subarray: {
+		struct imsm_vol_modify_data *u = (void *)update->buf;
+
+		super->current_vol = u->index;
+		st->ss->rename_subarray(st, u->name, -1);
+		break;
+	}
 	}
 }
 
-- 
1.6.4.2


--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski
Software Development Engineer


