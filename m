From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 09/13] imsm: delete subarray: main procedure and command
 line support
Date: Thu, 22 Apr 2010 23:12:29 +0100
Message-ID: <66C59AD0932712458090B447266D638CD405E3BD@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

To support delete feature patch adds --kill-subarray switch (no short
form) with optional parameter to specify member index. Instead one can
use -N <name> or -u <uuid> to choose array.

    mdadm --kill-subarray[=member-id | -N <name> | -u <uuid> \
    <container-or-devlist>

<container-or-devlist> is either container device or list of devices.
In the second case, if the container with given array is active,
the list of disk devices MUST be complete ie. must contain all valid
container devices. Patch uses routines to check conditions mentioned
above, so either actual delete is invoked on proper set of devices or
action is rejected.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 Kill.c   |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ReadMe.c |    1 +
 mdadm.c  |   14 ++++++++++++++
 mdadm.h  |    3 +++
 4 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/Kill.c b/Kill.c
index e738978..ae1e0fb 100644
--- a/Kill.c
+++ b/Kill.c
@@ -79,3 +79,61 @@ int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl)
 	close(fd);
 	return rv;
 }
+
+int DeleteSubarray(mddev_dev_t devlist, int force, int quiet, struct mddev_ident_s *ident)
+{
+	int	rv;
+	struct array_dev_list *dl = NULL;
+	int i, found;
+	struct mdinfo info;
+
+	if ((dl = check_devices(devlist, force, quiet, "imsm")) == NULL) {
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
+						fprintf(stderr, Name ": Attempting to modify properties of "
+							"array, which is active.\n    Stop array and try again\n");
+						map_free(map);
+						return -1;
+					}
+					map_free(map);
+				}
+				rv = dl->st->ss->delete_subarray(dl->st, dl->fd);
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
+			fprintf(stderr, Name ": Failed to delete\n");
+
+		dl = dl->next;
+	}
+	free_array_dev_list(dl);
+
+	return rv;
+}
+
diff --git a/ReadMe.c b/ReadMe.c
index 9d5a211..adeca20 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -104,6 +104,7 @@ struct option long_options[] = {
     {"grow",      0, 0, 'G'},
     {"incremental",0,0, 'I'},
     {"zero-superblock", 0, 0, 'K'}, /* deliberately no a short_option */
+    {"zero-subarray", 2, 0, ZeroSubarray},
     {"query",	  0, 0, 'Q'},
     {"examine-bitmap", 0, 0, 'X'},
     {"auto-detect", 0, 0, AutoDetect},
diff --git a/mdadm.c b/mdadm.c
index d5e34c0..7cc2ad9 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -124,6 +124,7 @@ int main(int argc, char *argv[])
 	ident.name[0] = 0;
 	ident.container = NULL;
 	ident.member = NULL;
+	ident.member_index = -1;
 
 	while ((option_index = -1) ,
 	       (opt=getopt_long(argc, argv,
@@ -209,6 +210,8 @@ int main(int argc, char *argv[])
 		case 'E':
 		case 'X':
 		case 'Q': newmode = MISC; break;
+		case ZeroSubarray: if (optarg)
+			ident.member_index = atoi(optarg);
 		case 'R':
 		case 'S':
 		case 'o':
@@ -574,6 +577,7 @@ int main(int argc, char *argv[])
 			/* now for the Assemble options */
 		case O(CREATE,'u'): /* uuid of array */
 		case O(ASSEMBLE,'u'): /* uuid of array */
+		case O(MISC,'u'):
 			if (ident.uuid_set) {
 				fprintf(stderr, Name ": uuid cannot be set twice.  "
 					"Second value %s.\n", optarg);
@@ -589,6 +593,7 @@ int main(int argc, char *argv[])
 
 		case O(CREATE,'N'):
 		case O(ASSEMBLE,'N'):
+		case O(MISC,'N'):
 			if (ident.name[0]) {
 				fprintf(stderr, Name ": name cannot be set twice.   "
 					"Second value %s.\n", optarg);
@@ -620,6 +625,7 @@ int main(int argc, char *argv[])
 			continue;
 
 		case O(ASSEMBLE,'U'): /* update the superblock */
+		case O(MISC,'U'): /* update the superblock */
 			if (update) {
 				fprintf(stderr, Name ": Can only update one aspect of superblock, both %s and %s given.\n",
 					update, optarg);
@@ -799,6 +805,7 @@ int main(int argc, char *argv[])
 		case O(MISC,'D'):
 		case O(MISC,'E'):
 		case O(MISC,'K'):
+		case O(MISC, ZeroSubarray):
 		case O(MISC,'R'):
 		case O(MISC,'S'):
 		case O(MISC,'X'):
@@ -907,6 +914,7 @@ int main(int argc, char *argv[])
 		case O(INCREMENTAL, 'r'):
 			rebuild_map = 1;
 			continue;
+
 		}
 		/* We have now processed all the valid options. Anything else is
 		 * an error
@@ -1293,6 +1301,12 @@ int main(int argc, char *argv[])
 				     SparcAdjust, ss, homehost);
 		} else if (devmode == DetailPlatform) {
 			rv = Detail_Platform(ss ? ss->ss : NULL, ss ? scan : 1, verbose);
+		} else if (devmode == ZeroSubarray) {
+			if (!ident.uuid_set && !ident.name[0] && ident.member_index == -1) {
+				fprintf(stderr, Name ": Name, Uuid or Member Index must be set for --zero-subarray.\n");
+				exit(2);
+			}
+			rv = DeleteSubarray(devlist, force, quiet, &ident);
 		} else {
 			if (devlist == NULL) {
 				if ((devmode=='D' || devmode == Waitclean) && scan) {
diff --git a/mdadm.h b/mdadm.h
index 2a5ca3b..118edd0 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -270,6 +270,7 @@ enum special_options {
 	AutoDetect,
 	Waitclean,
 	DetailPlatform,
+	ZeroSubarray
 };
 
 /* structures read from config file */
@@ -310,6 +311,7 @@ typedef struct mddev_ident_s {
 				 * of some other entry.
 				 */
 	char	*member;	/* subarray within a container */
+	int	member_index;	/* subarray index within a container */
 
 	struct mddev_ident_s *next;
 	union {
@@ -824,6 +826,7 @@ extern int Monitor(mddev_dev_t devlist,
 		   int dosyslog, int test, char *pidfile, int increments);
 
 extern int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl);
+extern int DeleteSubarray(mddev_dev_t devlist, int force, int quiet, struct mddev_ident_s *ident);
 extern int Wait(char *dev);
 extern int WaitClean(char *dev, int sock, int verbose);
 
-- 
1.6.4.2


--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski
Software Development Engineer


