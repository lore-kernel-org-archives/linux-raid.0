From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 31/35] added --path <path_id> to give the information on the
 'path-id' of removed device
Date: Mon, 16 Aug 2010 11:02:38 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8FA1B@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From febd3f45d8bc4165f574d0d9abe679e3c06da3b8 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Wed, 14 Jul 2010 15:11:02 +0100
Subject: [PATCH 31/35] added --path <path_id> to give the information on the 'path-id' of removed device

<path-id> allows to identify the port to which given device is plugged in. In case
of hot-removal, udev can pass this information for future use (eg. write this
name as 'cookie' allowing to detect the fact of reinserting device to the same port).
--path <path-id> parameter has been added to device removal handle (and char *path
has been added to IncrementalRemove() to pass this value) in order to pass path-id
to this handler.
---
 Incremental.c |    7 ++++++-
 ReadMe.c      |    2 ++
 mdadm.c       |   15 ++++++++++++---
 mdadm.h       |    3 ++-
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 6c30f51..c0a28a4 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -941,12 +941,17 @@ int Incremental_container(struct supertype *st, char *devname, int verbose,
  * Note: the device name must be a kernel name like "sda", so
  * that we can find it in /proc/mdstat
  */
-int IncrementalRemove(char *devname, int verbose)
+int IncrementalRemove(char *devname, char *path, int verbose)
 {
 	int mdfd;
 	struct mdstat_ent *ent;
 	struct mddev_dev_s devlist;
 
+	if (!path) {
+		fprintf(stderr, Name ": incremental removal without --path <path_id> lacks "
+			"the possibility to re-add new device in this port\n");
+	}
+
 	if (strchr(devname, '/')) {
 		fprintf(stderr, Name ": incremental removal requires a "
 			"kernel device name, not a file: %s\n", devname);
diff --git a/ReadMe.c b/ReadMe.c
index 3f36e70..6219e76 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -193,6 +193,8 @@ struct option long_options[] = {
     /* For Incremental */
     {"rebuild-map", 0, 0, 'r'},
     {"grab", 0, 0, 'g'}, /* grab devices for hot spare use */
+    {"path", 1, 0, IncrementalPath},
+
     {0, 0, 0, 0}
 };
 
diff --git a/mdadm.c b/mdadm.c
index bab0ad3..8d7e901 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -105,6 +105,7 @@ int main(int argc, char *argv[])
 	int dosyslog = 0;
 	int rebuild_map = 0;
 	int auto_update_home = 0;
+	char *remove_path = NULL;
 
 	int print_help = 0;
 	FILE *outf;
@@ -917,6 +918,13 @@ int main(int argc, char *argv[])
 		case O(INCREMENTAL, 'g'):
 			new_disk = 1;
 			continue;
+		case O(INCREMENTAL, IncrementalPath):
+			if (!optarg) {
+				fprintf(stderr, Name ":option --path needs obligatory argument\n");
+				exit(2);
+			}
+			remove_path = strdup(optarg);
+			continue;
 		}
 		/* We have now processed all the valid options. Anything else is
 		 * an error
@@ -1563,9 +1571,10 @@ int main(int argc, char *argv[])
 			rv = 1;
 			break;
 		}
-		if (devmode == 'f')
-			rv = IncrementalRemove(devlist->devname, verbose-quiet);
-		else if (new_disk > 0)
+		if (devmode == 'f') {
+			rv = IncrementalRemove(devlist->devname, remove_path, verbose-quiet);
+			free(remove_path);
+		} else if (new_disk > 0)
 			rv = IncrementalNew(devlist->devname, verbose-quiet,
 					    export);
 		else
diff --git a/mdadm.h b/mdadm.h
index a6a8fc0..320c293 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -276,6 +276,7 @@ enum special_options {
 	Waitclean,
 	DetailPlatform,
 	NoSharing,
+	IncrementalPath
 };
 
 enum domain_actions {
@@ -899,7 +900,7 @@ extern int Incremental_container(struct supertype *st, char *devname,
 				 int trustworthy);
 extern void RebuildMap(void);
 extern int IncrementalScan(int verbose);
-extern int IncrementalRemove(char *devname, int verbose);
+extern int IncrementalRemove(char *devname, char *path, int verbose);
 extern int IncrementalNew(char *devname, int verbose, int export);
 extern int CreateBitmap(char *filename, int force, char uuid[16],
 			unsigned long chunksize, unsigned long daemon_sleep,
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

