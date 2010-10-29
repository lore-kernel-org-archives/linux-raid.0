From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 01/17] added --path <path_id> to give the information on the
 'path-id' of removed device
Date: Fri, 29 Oct 2010 15:13:49 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FB0@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From f574362aeef0ff53faf37199a394eddf3ce26399 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Wed, 27 Oct 2010 16:20:53 +0200
Subject: [PATCH 01/17] added --path <path_id> to give the information on the 'path-id' of removed device

<path-id> allows to identify the port to which given device is plugged in. In case
of hot-removal, udev can pass this information for future use (eg. write this
name as 'cookie' allowing to detect the fact of reinserting device to the same port).
--path <path-id> parameter has been added to device removal handle (and char *path
has been added to IncrementalRemove() to pass this value) in order to pass path-id
to this handler.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 Incremental.c      |    8 +++++++-
 ReadMe.c           |    2 ++
 mdadm.c            |   21 ++++++++++++++++-----
 mdadm.h            |    3 ++-
 udev-md-raid.rules |    2 +-
 5 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index a60be47..de1003e 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1287,16 +1287,22 @@ int Incremental_container(struct supertype *st, char *devname, int verbose,
  * raid arrays, and if so first fail (if needed) and then remove the device.
  *
  * @devname - The device we want to remove
+ * @id_path - name as found in /dev/disk/by-path for this device
  *
  * Note: the device name must be a kernel name like "sda", so
  * that we can find it in /proc/mdstat
  */
-int IncrementalRemove(char *devname, int verbose)
+int IncrementalRemove(char *devname, char *id_path, int verbose)
 {
 	int mdfd;
 	int rv;
 	struct mdstat_ent *ent;
 	struct mddev_dev_s devlist;
+	if (!id_path) {
+		dprintf(Name ": incremental removal without --path <id_path> "
+			"lacks the possibility to re-add new device in this "
+			"port\n");
+	}
 
 	if (strchr(devname, '/')) {
 		fprintf(stderr, Name ": incremental removal requires a "
diff --git a/ReadMe.c b/ReadMe.c
index b97c55e..07abdb7 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -191,6 +191,8 @@ struct option long_options[] = {
 
     /* For Incremental */
     {"rebuild-map", 0, 0, 'r'},
+    {"path", 1, 0, IncrementalPath},
+
     {0, 0, 0, 0}
 };
 
diff --git a/mdadm.c b/mdadm.c
index 08e8ea4..758632c 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -104,6 +104,7 @@ int main(int argc, char *argv[])
 	int rebuild_map = 0;
 	int auto_update_home = 0;
 	char *subarray = NULL;
+	char *remove_path = NULL;
 
 	int print_help = 0;
 	FILE *outf;
@@ -945,6 +946,14 @@ int main(int argc, char *argv[])
 		case O(INCREMENTAL, 'r'):
 			rebuild_map = 1;
 			continue;
+		case O(INCREMENTAL, IncrementalPath):
+			if (!optarg) {
+				fprintf(stderr, Name ":option --path needs "
+					"obligatory argument\n");
+				exit(2);
+			}
+			remove_path = strdup(optarg);
+			continue;
 		}
 		/* We have now processed all the valid options. Anything else is
 		 * an error
@@ -1589,11 +1598,13 @@ int main(int argc, char *argv[])
 			break;
 		}
 		if (devmode == 'f') {
-			rv = IncrementalRemove(devlist->devname, verbose-quiet);
-			break;
-		}
-		rv = Incremental(devlist->devname, verbose-quiet, runstop,
-				 ss, homehost, require_homehost, autof);
+			rv = IncrementalRemove(devlist->devname, remove_path,
+					       verbose-quiet);
+			free(remove_path);
+		} else
+			rv = Incremental(devlist->devname, verbose-quiet,
+					 runstop, ss, homehost,
+					 require_homehost, autof);
 		break;
 	case AUTODETECT:
 		autodetect();
diff --git a/mdadm.h b/mdadm.h
index 9ad99f0..1cbc9c3 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -280,6 +280,7 @@ enum special_options {
 	DetailPlatform,
 	KillSubarray,
 	UpdateSubarray, /* 16 */
+	IncrementalPath
 };
 
 /* structures read from config file */
@@ -929,7 +930,7 @@ extern int Incremental_container(struct supertype *st, char *devname,
 				 int trustworthy);
 extern void RebuildMap(void);
 extern int IncrementalScan(int verbose);
-extern int IncrementalRemove(char *devname, int verbose);
+extern int IncrementalRemove(char *devname, char *path, int verbose);
 extern int CreateBitmap(char *filename, int force, char uuid[16],
 			unsigned long chunksize, unsigned long daemon_sleep,
 			unsigned long write_behind,
diff --git a/udev-md-raid.rules b/udev-md-raid.rules
index f9607f3..a4a57ac 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -3,7 +3,7 @@
 SUBSYSTEM!="block", GOTO="md_end"
 
 # handle potential components of arrays
-ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="remove", RUN+="/sbin/mdadm -If $name"
+ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
 ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="add", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
 
 # handle md arrays
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

