From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 12/13] imsm: rename subarray: main procedure and command
 line support
Date: Thu, 22 Apr 2010 23:13:03 +0100
Message-ID: <66C59AD0932712458090B447266D638CD405E3C0@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Added possibility to change the name of IMSM volume.

	mdadm --misc --update=name <new-name> [ -N <name> | -u <uuid> ] \
		<container-or-devlist>

<new-name> must follow --update=name (or -U=name),
<container-or-devlist> is the list of devices provided with the same
rules as delete subarray.
Note that target array must be stopped before an attempt to rename.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 Manage.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mdadm.c  |   18 ++++++++++--
 mdadm.h  |    1 +
 3 files changed, 104 insertions(+), 3 deletions(-)

diff --git a/Manage.c b/Manage.c
index f848d8b..e867790 100644
--- a/Manage.c
+++ b/Manage.c
@@ -871,4 +871,92 @@ int autodetect(void)
 	}
 	return rv;
 }
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
+		strncpy(new_name, devlist->devname, sizeof(new_name));
+		devlist = devlist->next;
+	} else {
+		for (dv = devlist; dv;)
+		{
+			if (dv->used == 1) {
+				mddev_dev_t t;
+				t = dv;
+				strncpy(new_name, dv->devname, sizeof(new_name));
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
+						fprintf(stderr, Name ": Attempting to modify properties of array,"
+							" which is active.\n    Stop array and try again\n");
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
index 7cc2ad9..c6b28b7 100644
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
 			rv = DeleteSubarray(devlist, force, quiet, &ident);
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
index 81fde4c..ae9d48d 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -828,6 +828,7 @@ extern int Monitor(mddev_dev_t devlist,
 
 extern int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl);
 extern int DeleteSubarray(mddev_dev_t devlist, int force, int quiet, struct mddev_ident_s *ident);
+extern int Rename(mddev_dev_t devlist, int force, int quiet, struct mddev_ident_s *ident);
 extern int Wait(char *dev);
 extern int WaitClean(char *dev, int sock, int verbose);
 
-- 
1.6.4.2


--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski
Software Development Engineer


