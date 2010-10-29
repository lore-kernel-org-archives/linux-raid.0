From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 03/17] extension of IncrementalRemove to store location
 (path-id) of removed device
Date: Fri, 29 Oct 2010 15:15:29 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FB9@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From 39e3e87204d4381007f5d798545a220e5c532516 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Wed, 27 Oct 2010 16:35:48 +0200
Subject: [PATCH 03/17] extension of IncrementalRemove to store location (path-id) of removed device

If the disk is taken out from its port this port information is lost. Only
udev rule can provide us with this information, and then we have to store
it somehow. This patch adds writing 'cookie' file in
/dev/.mdadm/failed-slots directory in form of file named with value
of <path-id> containing the UUID's of arrays holding this device before
it was removed. FAILED_SLOTS_DIR constant has been added to hold the
location of cookie files.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 Incremental.c |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 Makefile      |    3 ++
 mdadm.h       |    9 ++++++
 util.c        |    5 +++
 4 files changed, 99 insertions(+), 1 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index de1003e..bda90bc 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1297,7 +1297,11 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
 	int mdfd;
 	int rv;
 	struct mdstat_ent *ent;
+	struct map_ent *map, *me;
 	struct mddev_dev_s devlist;
+	char path[PATH_MAX];
+	FILE *id_fd;
+
 	if (!id_path) {
 		dprintf(Name ": incremental removal without --path <id_path> "
 			"lacks the possibility to re-add new device in this "
@@ -1315,15 +1319,92 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
 			"of any array\n", devname);
 		return 1;
 	}
+
+	if (id_path) {
+		if (mkdir(FAILED_SLOTS_DIR, S_IRWXU) < 0 && errno != EEXIST) {
+			fprintf(stderr, Name ": can't create file to save path "
+				"to old disk\n");
+			id_path = NULL;
+		} else {
+			snprintf(path, PATH_MAX, FAILED_SLOTS_DIR "/%s", id_path);
+
+			id_fd = fopen(path, "w");
+			if (!id_fd) {
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
-	Manage_subdevs(ent->dev, mdfd, &devlist, verbose, 0);
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
+			fprintf(stderr, Name ": Failed to write to <id_path> "
+				"cookie\n");
+			fclose(id_fd);
+			unlink(path);
+		}
+		Manage_subdevs(ent->dev, mdfd, &devlist, verbose, 0);
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
+				fprintf(stderr,	Name ": Failed to write to "
+					"<id_path> cookie\n");
+				fclose(id_fd);
+				unlink(path);
+			}
+			subfd = open_dev(me->devnum);
+			if (subfd < 0) {
+				fprintf(stderr,
+					Name ": Cannot open array md%d!!\n",
+					me->devnum);
+				fclose(id_fd);
+				map_free(map);
+				return 1;
+			}
+			/* try for each volume, probably only first will work */
+			Manage_subdevs(me->path, subfd, &devlist, verbose, 0);
+			close(subfd);
+		}
+		if (id_path)
+			fclose(id_fd);
+		map_free(map);
+	}
+
 	devlist.disposition = 'r';
 	rv = Manage_subdevs(ent->dev, mdfd, &devlist, verbose, 0);
 	close(mdfd);
diff --git a/Makefile b/Makefile
index 40f65af..2b88818 100644
--- a/Makefile
+++ b/Makefile
@@ -71,8 +71,11 @@ CONFFILEFLAGS = -DCONFFILE=\"$(CONFFILE)\" -DCONFFILE2=\"$(CONFFILE2)\"
 MAP_DIR=/dev/.mdadm
 MAP_FILE = map
 MDMON_DIR = /dev/.mdadm
+# place for autoreplace cookies
+FAILED_SLOTS_DIR = /dev/.mdadm/failed-slots
 DIRFLAGS = -DMAP_DIR=\"$(MAP_DIR)\" -DMAP_FILE=\"$(MAP_FILE)\"
 DIRFLAGS += -DMDMON_DIR=\"$(MDMON_DIR)\"
+DIRFLAGS += -DFAILED_SLOTS_DIR=\"$(FAILED_SLOTS_DIR)\"
 CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(DIRFLAGS)
 
 # The glibc TLS ABI requires applications that call clone(2) to set up
diff --git a/mdadm.h b/mdadm.h
index 1cbc9c3..0899e4e 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -93,6 +93,14 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 #define MDMON_DIR "/dev/.mdadm/"
 #endif /* MDMON_DIR */
 
+/* FAILED_SLOTS is where to save files storing recent removal of array
+ * member in order to allow future reuse of disk inserted in the same
+ * slot for array recovery
+ */
+#ifndef FAILED_SLOTS_DIR
+#define FAILED_SLOTS_DIR "/dev/.mdadm/failed-slots"
+#endif /* FAILED_SLOTS */
+
 #include	"md_u.h"
 #include	"md_p.h"
 #include	"bitmap.h"
@@ -1041,6 +1049,7 @@ extern char *devnum2devname(int num);
 extern int devname2devnum(char *name);
 extern int stat2devnum(struct stat *st);
 extern int fd2devnum(int fd);
+extern int is_external(char *metadata_verison);
 
 static inline int dev2major(int d)
 {
diff --git a/util.c b/util.c
index 0cb251c..bb85253 100644
--- a/util.c
+++ b/util.c
@@ -1779,6 +1779,11 @@ void append_metadata_update(struct supertype *st, void *buf, int len)
 	*st->update_tail = mu;
 	st->update_tail = &mu->next;
 }
+
+int is_external(char *metadata_version)
+{
+	return metadata_version && !strncmp(metadata_version, "external:", 9);
+}
 #endif /* MDASSEMBLE */
 
 #ifdef __TINYC__
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

