From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 32/35] extension of IncrementalRemove to store location
 (port) of removed device
Date: Mon, 16 Aug 2010 11:03:02 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8FA1D@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 130a095e85a4ff6110694ea68d21ea1c24644377 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Wed, 14 Jul 2010 16:44:43 +0200
Subject: [PATCH 32/35] extension of IncrementalRemove to store location (port) of removed device

If the disk is taken out from its port this port information is lost. Only
udev rule can provide us with this information, and then we have to store
it somehow. This patch adds writing 'cookie' file in
/var/run/mdadm/failed-slots directory in form of file named with value
of <path-id>, containing the UUID's of arrays holding this device before
it was removed. FAILED_SLOTS constant has been added to hold the location
of cookie files.
---
 Incremental.c |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 Makefile      |    8 +++--
 mdadm.h       |    8 +++++
 3 files changed, 92 insertions(+), 7 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index c0a28a4..9d63a86 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -937,18 +937,22 @@ int Incremental_container(struct supertype *st, char *devname, int verbose,
  * raid arrays, and if so first fail (if needed) and then remove the device.
  *
  * @devname - The device we want to remove
+ * @id_path - name as found in /dev/disk/by-path for this device
  *
  * Note: the device name must be a kernel name like "sda", so
  * that we can find it in /proc/mdstat
  */
-int IncrementalRemove(char *devname, char *path, int verbose)
+int IncrementalRemove(char *devname, char *id_path, int verbose)
 {
 	int mdfd;
 	struct mdstat_ent *ent;
+	struct map_ent *map, *me;
 	struct mddev_dev_s devlist;
+	char path[PATH_MAX];
+	FILE *id_fd;
 
-	if (!path) {
-		fprintf(stderr, Name ": incremental removal without --path <path_id> lacks "
+	if (!id_path) {
+		fprintf(stderr, Name ": incremental removal without --path <id_path> lacks "
 			"the possibility to re-add new device in this port\n");
 	}
 
@@ -963,15 +967,86 @@ int IncrementalRemove(char *devname, char *path, int verbose)
 			"of any array\n", devname);
 		return 1;
 	}
+
+	if (id_path) {
+		if (mkdir(FAILED_SLOTS, S_IRWXU) < 0 && errno != EEXIST) {
+			fprintf(stderr, Name ": can't create file to save path to old disk\n");
+			id_path = NULL;
+		} else {
+			snprintf(path, PATH_MAX, FAILED_SLOTS "/%s", id_path);
+
+			if ((id_fd = fopen(path, "w")) == NULL) {
+				fprintf(stderr, Name ": can't create file to"
+						     " save path to old disk\n");
+				id_path = NULL;
+			}
+		}
+	}
+
 	mdfd = open_dev(ent->devnum);
 	if (mdfd < 0) {
 		fprintf(stderr, Name ": Cannot open array %s!!\n", ent->dev);
 		return 1;
 	}
+
 	memset(&devlist, 0, sizeof(devlist));
 	devlist.devname = devname;
 	devlist.disposition = 'f';
-	Manage_subdevs(ent->dev, mdfd, &devlist, verbose);
+
+	map_read(&map);
+	if (!map) {
+		fprintf(stderr, Name ": Cannot open/read map file\n");
+		return 1;
+	}
+
+	/* slightly different behavior for native and external */
+	if (!is_external(ent->metadata_version)) {
+		me = map_by_devnum(&map, ent->devnum);
+		/* just write array device */
+		if (id_path && fprintf(id_fd, "%08x:%08x:%08x:%08x\n",
+				       me->uuid[0],
+				       me->uuid[1],
+				       me->uuid[2],
+				       me->uuid[3]) < 0) {
+			fprintf(stderr, Name ": Failed to write to <id_path> cookie\n");
+			fclose(id_fd);
+			unlink(path);
+		}
+		Manage_subdevs(ent->dev, mdfd, &devlist, verbose);
+	} else {
+		int subfd;
+		/* write device for all array members */
+		for (me = map; me; me = me->next) {
+			if (!is_subarray(me->metadata) ||
+			    devname2devnum(me->metadata + 1) != ent->devnum)
+				continue;
+			/* found member, so */
+			/* create file with names of arrays containing old disk */
+			if (id_path && fprintf(id_fd, "%08x:%08x:%08x:%08x\n",
+						me->uuid[0],
+						me->uuid[1],
+						me->uuid[2],
+						me->uuid[3]) < 0) {
+				fprintf(stderr, Name ": Failed to write to <id_path> cookie\n");
+				fclose(id_fd);
+				unlink(path);
+			}
+			subfd = open_dev(me->devnum);
+			if (subfd < 0) {
+				fprintf(stderr, Name ": Cannot open array md%d!!\n", me->devnum);
+				fclose(id_fd);
+				map_free(map);
+				return 1;
+			}
+			/* try for each volume, probably only first will work */
+			Manage_subdevs(me->path, subfd, &devlist, verbose);
+			close(subfd);
+		}
+		if (id_path)
+			fclose(id_fd);
+		map_free(map);
+	}
+
 	devlist.disposition = 'r';
 	return Manage_subdevs(ent->dev, mdfd, &devlist, verbose);
 }
diff --git a/Makefile b/Makefile
index 354554c..31fcbc9 100644
--- a/Makefile
+++ b/Makefile
@@ -71,8 +71,10 @@ CONFFILEFLAGS = -DCONFFILE=\"$(CONFFILE)\" -DCONFFILE2=\"$(CONFFILE2)\"
 ALT_RUN = /lib/init/rw/mdadm
 ALT_MAPFILE = map
 VAR_RUN = /var/run/mdadm
-ALTFLAGS = -DALT_RUN=\"$(ALT_RUN)\" -DALT_MAPFILE=\"$(ALT_MAPFILE)\"
-VARFLAGS = -DVAR_RUN=\"$(VAR_RUN)\"
+# place for autoreplace cookies
+FAILED_SLOTS = /var/run/mdadm/failed-slots
+ALTFLAGS = -DALT_RUN=\"$(ALT_RUN)\" -DALT_MAPFILE=\"$(ALT_MAPFILE)\" -DFAILED_SLOTS=\"$(FAILED_SLOTS)\"
+VARFLAGS = -DVAR_RUN=\"$(VAR_RUN)\" -DFAILED_SLOTS=\"$(FAILED_SLOTS)\"
 CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(ALTFLAGS) $(VARFLAGS)
 
 # If you want a static binary, you might uncomment these
@@ -233,7 +235,7 @@ install-man: mdadm.8 md.4 mdadm.conf.5 mdmon.8
 	$(INSTALL) -D -m 644 mdadm.conf.5 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5
 
 install-udev: udev-md-raid.rules udev-early-md.rules
-	$(INSTALL) -D -m 644 udev-early-md.rules $(DESTDIR)/lib/udev/rules.d/05-md-early.rules
+	$(INSTALL) -D -m 644 udev-early-md.rules $(DESTDIR)/lib/udev/rules.d/61-md-early.rules
 	$(INSTALL) -D -m 644 udev-md-raid.rules $(DESTDIR)/lib/udev/rules.d/64-md-raid.rules
 
 uninstall:
diff --git a/mdadm.h b/mdadm.h
index 320c293..316dec2 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -91,6 +91,14 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 #define ALT_MAPFILE "map"
 #endif /* ALT_MAPFILE */
 
+/* FAILED_SLOTS is where to save files storing recent removal of array
+ * member in order to allow future reuse of disk inserted in the same
+ * slot for array recovery
+ */
+#ifndef FAILED_SLOTS
+#define FAILED_SLOTS "/var/run/mdadm/failed-slots"
+#endif /* FAILED_SLOTS */
+
 #include	"md_u.h"
 #include	"md_p.h"
 #include	"bitmap.h"
-- 
1.6.4.2

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

