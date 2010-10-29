From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 04/17] Incremental for bare disks, implementation of
 spare-same port policy action
Date: Fri, 29 Oct 2010 15:19:19 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FBD@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From 4517cd72456d54c11b93ddb44718dba05ff36a77 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Wed, 27 Oct 2010 16:22:10 +0200
Subject: [PATCH 04/17] Incremental for bare disks, implementation of spare-same port policy action

The idea of this patch is to allow adding of bare device to the container
if device is plugged into the same port as recently removed device.
New action act_spare_same_port has been added. Triggers array_try_spare
to look for cookie file (named after udev's path-id of device) containing
the uuid of valid array. If it is found and uuid matches current array
such disk can be used as spare.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 Incremental.c      |  139 +++++++++++++++++++++++++++++++++++++++-------------
 mdadm.h            |    4 ++
 policy.c           |    6 ++-
 udev-md-raid.rules |    5 +-
 4 files changed, 116 insertions(+), 38 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index bda90bc..dafe152 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -716,8 +716,20 @@ static int count_active(struct supertype *st, int mdfd, char **availp,
 	return cnt + cnt1;
 }
 
+FILE *get_cookie_fd(char *path)
+{
+	char cookie_path[PATH_MAX];
+
+	if (!path)
+		return NULL;
+
+	snprintf(cookie_path, PATH_MAX, FAILED_SLOTS_DIR "/%s", path);
+	return fopen(cookie_path, "r");
+}
+
 static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
-			   struct supertype *st, int verbose)
+			   struct supertype *st,
+			   enum policy_action action, int verbose)
 {
 	/* This device doesn't have any md metadata
 	 * If it is 'bare' and theh device policy allows 'spare' look for
@@ -727,9 +739,10 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 	 */
 	int rv = -1;
 	struct stat stb;
-	struct map_ent *mp, *map = NULL;
-	struct mdinfo *chosen = NULL;
+	struct map_ent *mp, *mpsub, *map = NULL;
+	struct mdinfo *chosen = NULL, disk;
 	int dfd = *dfdp;
+	FILE *cfd;		/* file handle of cookie */
 
 	if (fstat(dfd, &stb) != 0)
 		return 1;
@@ -742,6 +755,9 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 	 *  - are of an size for which the device will be useful
 	 * and we choose the one that is the most degraded
 	 */
+	disk.disk.major = major(stb.st_rdev);
+	disk.disk.minor = minor(stb.st_rdev);
+	cfd = get_cookie_fd(disk_path(&disk));
 
 	if (map_lock(&map)) {
 		fprintf(stderr, Name ": failed to get exclusive lock on "
@@ -753,6 +769,9 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		struct domainlist *dl = NULL;
 		struct mdinfo *sra;
 		unsigned long long devsize;
+		char line[100];
+		if (cfd)
+			rewind(cfd);
 
 		if (is_subarray(mp->metadata))
 			continue;
@@ -806,6 +825,43 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 
 			goto next;
 		}
+		/* test for cookie. If any uuid found in cookie file
+		 * matches with uuid of array (or child array in case of
+		 * external metadata) disk is taken into account
+		 */
+		if (cfd && action == act_spare_same_slot) {
+			int uuid[4];
+			memcpy(uuid, uuid_match_any, sizeof(uuid));
+			while (fgets(line, sizeof(line), cfd)) {
+				if (sscanf(line, "%08x:%08x:%08x:%08x",
+					   &uuid[0], &uuid[1],
+					   &uuid[2], &uuid[3]) != 4) {
+					memcpy(uuid, uuid_match_any, sizeof(uuid));
+					continue;
+				}
+
+				if (st2->ss->external) {
+					/* scan child arrays and match uuid with cookie */
+					for (mpsub = map; mpsub; mpsub = mpsub->next) {
+						if (!is_subarray(mpsub->metadata))
+							continue;
+						/* match parent device */
+						if (devname2devnum(mpsub->metadata + 1) != mp->devnum)
+							continue;
+						if (memcmp(mpsub->uuid, uuid, sizeof(uuid)) == 0)
+							break;
+					}
+					if (!mpsub)
+						goto next;
+				} else {
+					if (memcmp(mp->uuid, uuid, sizeof(uuid)) != 0)
+						goto next;
+				}
+			}
+		if (memcmp(uuid, uuid_match_any, sizeof(uuid)) == 0)
+			goto next;
+		}
+
 		/* all tests passed, OK to add to this array */
 		if (!chosen) {
 			chosen = sra;
@@ -998,6 +1054,32 @@ static int partition_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 	return 0;
 }
 
+static int is_bare(int dfd)
+{
+	char bufpad[4096 + 4096];
+	char *buf = (char *)(((long)bufpad + 4096) & ~4095);
+
+	if (lseek(dfd, 0, SEEK_SET) != 0 ||
+		read(dfd, buf, 4096) != 4096)
+		return 0;
+
+	if (buf[0] != '\0' && buf[0] != '\x5a' && buf[0] != '\xff')
+		return 0;
+	if (memcmp(buf, buf+1, 4095) != 0)
+		return 0;
+
+	/* OK, first 4K appear blank, try the end. */
+	if (lseek(dfd, -4096, SEEK_END) < 0 ||
+		read(dfd, buf, 4096) != 4096)
+		return 0;
+
+	if (buf[0] != '\0' && buf[0] != '\x5a' && buf[0] != '\xff')
+		return 0;
+	if (memcmp(buf, buf+1, 4095) != 0)
+		return 0;
+
+	return 1;
+}
 
 /* adding a spare to a regular array is quite different from adding one to
  * a set-of-partitions virtual array.
@@ -1011,43 +1093,31 @@ static int try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 	int rv;
 	int arrays_ok = 0;
 	int partitions_ok = 0;
-	char bufpad[4096 + 4096];
-	char *buf = (char*)(((long)bufpad + 4096) & ~4095);
 	int dfd = *dfdp;
+	enum policy_action action;
 
 	/* Can only add a spare if device has at least one domains */
 	if (pol_find(pol, pol_domain) == NULL)
 		return 1;
 	/* And only if some action allows spares */
-	if (!policy_action_allows(pol, st?st->ss->name:NULL, act_spare))
+	action = policy_action(pol, st ? st->ss->name : NULL);
+	if (action < act_spare_same_slot)
 		return 1;
 
-	/* Now check if the device is bare - we don't add non-bare devices
-	 * yet even if action=-spare
-	 */
-
-	if (lseek(dfd, 0, SEEK_SET) != 0 ||
-	    read(dfd, buf, 4096) != 4096) {
-	not_bare:
-		if (verbose > 1)
-			fprintf(stderr, Name ": %s is not bare, so not considering as a spare\n",
-				devname);
-		return 1;
+	if (action != act_spare_same_slot) {
+		/* Now check if the device is bare - we don't add non-bare
+		 * devices yet even if action=-spare, but ommit this check for
+		 * "same port" replacement. We take any device without metadata
+		 * in such case.
+		 */
+		if (!is_bare(dfd)) {
+			if (verbose > 1)
+				fprintf(stderr, Name ": %s is not bare, so not "
+					"considering as a spare\n",
+					devname);
+			return 1;
+		}
 	}
-	if (buf[0] != '\0' && buf[0] != '\x5a' && buf[0] != '\xff')
-		goto not_bare;
-	if (memcmp(buf, buf+1, 4095) != 0)
-		goto not_bare;
-
-	/* OK, first 4K appear blank, try the end. */
-	if (lseek(dfd, -4096, SEEK_END) < 0 ||
-	    read(dfd, buf, 4096) != 4096)
-		goto not_bare;
-
-	if (buf[0] != '\0' && buf[0] != '\x5a' && buf[0] != '\xff')
-		goto not_bare;
-	if (memcmp(buf, buf+1, 4095) != 0)
-		goto not_bare;
 
 	/* This device passes our test for 'is bare'.
 	 * Let's see what policy allows for such things.
@@ -1056,7 +1126,7 @@ static int try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		/* just try try 'array' or 'partition' based on this metadata */
 		if (st->ss->add_to_super)
 			return array_try_spare(devname, dfdp, pol,
-					       st, verbose);
+					       st, action, verbose);
 		else
 			return partition_try_spare(devname, dfdp, pol,
 						   st, verbose);
@@ -1064,7 +1134,8 @@ static int try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 	/* Now see which metadata type support spare */
 	for (i = 0; (!arrays_ok || !partitions_ok) && superlist[i] ; i++) {
 		if (superlist[i]->add_to_super && !arrays_ok &&
-		    policy_action_allows(pol, superlist[i]->name, act_spare))
+		    policy_action_allows(pol, superlist[i]->name,
+					 act_spare_same_slot))
 			arrays_ok = 1;
 		if (superlist[i]->add_to_super == NULL && !partitions_ok &&
 		    policy_action_allows(pol, superlist[i]->name, act_spare))
@@ -1072,7 +1143,7 @@ static int try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 	}
 	rv = 0;
 	if (arrays_ok)
-		rv = array_try_spare(devname, dfdp, pol, st, verbose);
+		rv = array_try_spare(devname, dfdp, pol, st, action, verbose);
 	if (rv == 0 && partitions_ok)
 		rv = partition_try_spare(devname, dfdp, pol, st, verbose);
 	return rv;
diff --git a/mdadm.h b/mdadm.h
index 0899e4e..450fb11 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -814,6 +814,7 @@ enum policy_action {
 	act_default,
 	act_include,
 	act_re_add,
+	act_spare_same_slot,
 	act_spare,
 	act_force_spare,
 	act_err
@@ -1050,6 +1051,9 @@ extern int devname2devnum(char *name);
 extern int stat2devnum(struct stat *st);
 extern int fd2devnum(int fd);
 extern int is_external(char *metadata_verison);
+extern enum policy_action policy_action(struct dev_policy *plist,
+					const char *metadata);
+extern char *disk_path(struct mdinfo *disk);
 
 static inline int dev2major(int d)
 {
diff --git a/policy.c b/policy.c
index 945d37f..dae8e44 100644
--- a/policy.c
+++ b/policy.c
@@ -188,7 +188,7 @@ struct dev_policy *pol_find(struct dev_policy *pol, char *name)
 	return pol;
 }
 
-static char *disk_path(struct mdinfo *disk)
+char *disk_path(struct mdinfo *disk)
 {
 	struct stat stb;
 	int prefix_len;
@@ -518,6 +518,8 @@ static enum policy_action map_act(char *act)
 		return act_include;
 	if (strcmp(act, "re-add") == 0)
 		return act_re_add;
+	if (strcmp(act, "spare-same-slot") == 0)
+		return act_spare_same_slot;
 	if (strcmp(act, "spare") == 0)
 		return act_spare;
 	if (strcmp(act, "force-spare") == 0)
@@ -525,7 +527,7 @@ static enum policy_action map_act(char *act)
 	return act_err;
 }
 
-static enum policy_action policy_action(struct dev_policy *plist, const char *metadata)
+enum policy_action policy_action(struct dev_policy *plist, const char *metadata)
 {
 	enum policy_action rv = act_default;
 	struct dev_policy *p;
diff --git a/udev-md-raid.rules b/udev-md-raid.rules
index 1d89833..36dd51e 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -4,9 +4,10 @@ SUBSYSTEM!="block", GOTO="md_end"
 
 # handle potential components of arrays
 ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
-ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="add", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
 ENV{ID_FS_TYPE}=="isw_raid_member", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
-ENV{ID_FS_TYPE}=="isw_raid_member", ACTION=="add", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
+# try incremental for each block device and not md. Most cases should not create
+# unnecessary overhead, as no "heavy" disk operations are performed
+ACTION=="add", KERNEL!="md*", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
 
 # handle md arrays
 ACTION!="add|change", GOTO="md_end"
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

