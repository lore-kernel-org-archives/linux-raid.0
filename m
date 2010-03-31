From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 2/2] imsm: volume rename functionality
Date: Wed, 31 Mar 2010 21:50:47 +0100
Message-ID: <66C59AD0932712458090B447266D638CD3C7EAF5@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Functionality renames array by changing serial ID in the metadata.
Target array must be disassembled before an attempt to rename.

	mdadm --misc --update=name <new-name> [ -N <name> | -u <uuid> ] \
		<container-or-devlist>

<new-name> must follow --update (or -U),
<container-or-devlist> is the list of devices provided with the same rules
as delete subarray.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 Manage.c      |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mdadm.c       |   18 +++++++++--
 mdadm.h       |    2 +
 super-intel.c |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 205 insertions(+), 3 deletions(-)

diff --git a/Manage.c b/Manage.c
index f848d8b..ee15cfa 100644
--- a/Manage.c
+++ b/Manage.c
@@ -871,4 +871,99 @@ int autodetect(void)
 	}
 	return rv;
 }
+
+/*
+ * It may contain no more than 16 characters (not counting the terminating null).
+ * It may  contain any ASCII character with  a value from 32  to 126 (inclusive),
+ * except  it shall not  contain the  backslash character  (ASCII code  92).  All
+ * other characters are invalid.
+ * Check for conformity with these rules is made in st->ss->rename_subarray().
+ */
+
+int Rename(mddev_dev_t devlist, int force, int quiet, struct mddev_ident_s *ident)
+{
+	char new_name[36] = "";
+	mddev_dev_t dv;
+	struct array_dev_list *dl;
+	int rv;
+	int i, found;
+	struct mdinfo info;
+
+	if (!devlist)
+		return 1;
+
+	/* get new name */
+	if (devlist->used == 1) {
+		strncpy(new_name, devlist->devname, 36);
+		devlist = devlist->next;
+	} else {
+		for (dv = devlist; dv;)
+		{
+			if (dv->used == 1) {
+				mddev_dev_t t;
+				t = dv;
+				strncpy(new_name, dv->devname, 36);
+				dv = dv->next;
+				free(t);
+				continue;
+			}
+			dv = dv->next;
+		}
+	}
+
+	if ((dl = check_devices(devlist, force, quiet, "imsm")) == NULL) {
+		return 1;
+	}
+
+	if (new_name[0] == '\0') {
+		if (!quiet)
+			fprintf(stderr, Name ": New name is not provided. Provide new name right after --update=name switch\n");
+		return 1;
+	}
+
+	while(dl) {
+		for (i = 0, found = 0, rv = 0; rv == 0; i++) {
+			snprintf(dl->st->subarray, sizeof(dl->st->subarray) - 1, "%d", i);
+			rv = dl->st->ss->load_super(dl->st, dl->fd, NULL);
+			if (rv)
+				break;
+
+			dl->st->ss->getinfo_super(dl->st, &info);
+			/* match based on subarray number, name or uuid */
+			if ((ident->member_index != -1 && i == ident->member_index) ||
+			    (ident->name[0] && !strncmp(info.name, ident->name, sizeof(info.name))) ||
+			    (ident->uuid_set && same_uuid(info.uuid, ident->uuid, dl->st->ss->swapuuid))) {
+				if (dl->st->loaded_container) {
+					struct map_ent *map;
+					int devname;
+					map_read(&map);
+					if (!find_array_minor(info.text_version, map, &devname)) {
+						fprintf(stderr, Name ": Attempting to modify properties of array, which is active.\n    Stop array and try again\n");
+						map_free(map);
+						return -1;
+					}
+					map_free(map);
+				}
+				rv = dl->st->ss->rename_subarray(dl->st, new_name, dl->fd);
+				found = 1;
+				break;
+			}
+		}
+
+		if (!found) {
+			if (!quiet)
+				fprintf(stderr, Name ": Could not find array with given identifier\n");
+			rv = 1;
+		}
+
+		if (!quiet && rv && found)
+			fprintf(stderr, Name ": Failed to rename\n");
+
+		dl = dl->next;
+	}
+
+	free_array_dev_list(dl);
+
+	return rv;
+}
 #endif
diff --git a/mdadm.c b/mdadm.c
index 65cc4b5..343652d 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -103,6 +103,7 @@ int main(int argc, char *argv[])
 	int dosyslog = 0;
 	int rebuild_map = 0;
 	int auto_update_home = 0;
+	int new_name = 0;

 	int print_help = 0;
 	FILE *outf;
@@ -293,7 +294,8 @@ int main(int argc, char *argv[])
 			continue;
 		}
 		if (opt == 1) {
-		        /* an undecorated option - must be a device name.
+		        /* an undecorated option - must be a device name, except MISC-rename
+			 * New name is provided this way
 			 */
 			if (devs_found > 0 && mode == '@' && !devmode) {
 				fprintf(stderr, Name ": Must give one of -a/-r/-f for subsequent devices at %s\n", optarg);
@@ -312,12 +314,13 @@ int main(int argc, char *argv[])
 			dv->disposition = devmode;
 			dv->writemostly = writemostly;
 			dv->re_add = re_add;
-			dv->used = 0;
+			dv->used = new_name;
 			dv->content = NULL;
 			dv->next = NULL;
 			*devlistend = dv;
 			devlistend = &dv->next;

+			new_name = 0;
 			devs_found++;
 			continue;
 		}
@@ -642,8 +645,11 @@ int main(int argc, char *argv[])
 				continue;
 			if (strcmp(update, "uuid")==0)
 				continue;
-			if (strcmp(update, "name")==0)
+			if (strcmp(update, "name")==0) {
+				if (mode == MISC)
+					new_name = 1;
 				continue;
+			}
 			if (strcmp(update, "homehost")==0)
 				continue;
 			if (strcmp(update, "devicesize")==0)
@@ -1307,6 +1313,12 @@ int main(int argc, char *argv[])
 				exit(2);
 			}
 			rv = Kill_Subarray(devlist, force, quiet, &ident);
+		} else if (update && !strcmp(update, "name")) {
+			if (!ident.uuid_set && !ident.name[0] && ident.member_index == -1) {
+				fprintf(stderr, Name ": Name, Uuid or Member Index must be set for --zero-subarray.\n");
+				exit(2);
+			}
+			rv = Rename(devlist, force, quiet, &ident);
 		} else {
 			if (devlist == NULL) {
 				if ((devmode=='D' || devmode == Waitclean) && scan) {
diff --git a/mdadm.h b/mdadm.h
index f5e239c..4905566 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -596,6 +596,7 @@ extern struct superswitch {
 	int (*write_bitmap)(struct supertype *st, int fd);
 	void (*free_super)(struct supertype *st);
 	int (*delete_subarray)(struct supertype *st, int fd);
+	int (*rename_subarray)(struct supertype *st, char *new_name, int fd);

 	/* validate_geometry is called with an st returned by
 	 * match_metadata_desc.
@@ -826,6 +827,7 @@ extern int Monitor(mddev_dev_t devlist,

 extern int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl);
 extern int Kill_Subarray(mddev_dev_t devlist, int force, int quiet, struct mddev_ident_s *ident);
+extern int Rename(mddev_dev_t devlist, int force, int quiet, struct mddev_ident_s *ident);
 extern int Wait(char *dev);
 extern int WaitClean(char *dev, int sock, int verbose);

diff --git a/super-intel.c b/super-intel.c
index 1b54df8..6348e48 100644
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

@@ -3592,6 +3594,89 @@ int delete_subarray_imsm(struct supertype *st, int fd)
 	return rv;
 }

+#define IMSM_SERIAL_MAX_LEN 16
+
+static int _validate_name(char *name)
+{
+	int i, len;
+
+	if (!name)
+		return 1;
+
+	if ((len = strlen(name)) > IMSM_SERIAL_MAX_LEN)
+		return 1;
+
+	for (i = 0; name[i] && i < len; i++) {
+		if (name[i] < 32 || name[i] > 126 || name[i] == 92)
+			break;
+	}
+
+	if (i < len)
+		return 1;
+	return 0;
+}
+
+static int rename_subarray_imsm(struct supertype *st, char *new_name, int fd)
+{
+	struct intel_super *super;
+	struct imsm_super *mpb;
+	struct imsm_dev *dev;
+	int container_index;
+	int rv = 0;
+
+	if (!st)
+		return 1;
+
+	super = st->sb;
+	mpb = super ? super->anchor : NULL;
+
+	if (!mpb)
+		return 1;
+
+	container_index = super->current_vol;
+
+	if (_validate_name(new_name)) {
+		fprintf(stderr, Name ": New array name contains illegal characters or is too long.\n");
+		return 1;
+	}
+
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
+	dev = get_imsm_dev(super, container_index);
+	strncpy((char *) dev->volume, new_name, MAX_RAID_SERIAL_LEN);
+
+	if (st->arrays) /* mdmon context */
+		super->updates_pending++;
+	else {
+		/* use passed fd if container is not loaded and handle in
+		 * intel_super is not available
+		 */
+		if (!st->loaded_container)
+			super->disks->fd = fd;
+
+		rv = write_super_imsm(super, 0);
+	}
+
+	return rv;
+}
 static int store_super_imsm(struct supertype *st, int fd)
 {
 	struct intel_super *super = st->sb;
@@ -5227,6 +5312,13 @@ static void imsm_process_update(struct supertype *st,
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

@@ -5376,6 +5468,7 @@ struct superswitch super_imsm = {
 	.brief_detail_super = brief_detail_super_imsm,
 	.write_init_super = write_init_super_imsm,
 	.delete_subarray = delete_subarray_imsm,
+	.rename_subarray = rename_subarray_imsm,
 	.validate_geometry = validate_geometry_imsm,
 	.add_to_super	= add_to_super_imsm,
 	.detail_platform = detail_platform_imsm,
--
1.6.4.2

