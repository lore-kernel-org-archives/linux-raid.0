From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH] kill-subarray: fix, cannot kill-subarray with unsupported
 metadata
Date: Mon, 5 Sep 2011 14:23:40 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D401BE07@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Subject: [PATCH] kill-subarray: fix, cannot kill-subarray with unsupported metadata

container_content retrieves volume information from disks in the container.
For unsupported volumes the function was not returning mdinfo. When all volumes
were unsupported the function was returning NULL pointer to block actions on the volumes.
Therefore, such volumes were not activated in Incremental and Assembly.
As side effect they also could not be deleted using kill-subarray since
"kill" function requires to obtain a valid mdinfo from container_content.

This patch fixes the kill-subarray problem by allowing to obtain mdinfo
of all volumes types including unsupported. There are following changes:
1. IMSM container_content handler is to load mdinfo for all volumes and
set one of MD_SB_ERRORS_FLAGS flags in array.state field in mdinfo
of unsupported volumes. In case of some errors, all volumes can be affected.
2. Incremental_container and Assemble functions check array.state
and release such a volume mdinfo. Volumes with valid array.state remain on
the volume list and can be handled in the same way as previously.
3. kill-subarray ignores array.state info and can remove requested array.
4. Added MD_SB_ATTR_ERRORS and MD_SB_UNSUP_VOL_ERRORS for two new
types of metadata problems (wrong attributes and unsupported volume type).
5. Move error notifications from common code to IMSM metadata handlers, close
to source of problem.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 Assemble.c    |   36 ++++++++++++++++++++++++++----------
 Incremental.c |   41 +++++++++++++++++++++++++++++++----------
 md_p.h        |    4 ++++
 super-intel.c |   47 ++++++++++++++++++++++++++++-------------------
 4 files changed, 89 insertions(+), 39 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 25cfec1..2b1292e 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -227,6 +227,8 @@ int Assemble(struct supertype *st, char *mddev,
 	struct mddev_dev *tmpdev;
 	struct mdinfo info;
 	struct mdinfo *content = NULL;
+	struct mdinfo *ra = NULL;
+	struct mdinfo *prev = NULL;
 	char *avail;
 	int nextspare = 0;
 	char *name = NULL;
@@ -434,18 +436,32 @@ int Assemble(struct supertype *st, char *mddev,
 			if (verbose > 0)
 				fprintf(stderr, Name ": looking in container %s\n",
 					devname);
-
-			for (content = tst->ss->container_content(tst, NULL);
+			content = tst->ss->container_content(tst, NULL);
+			for (ra = content, prev = NULL ; ra ; ) {
+				if (ra->array.state & MD_SB_ERRORS_FLAGS) {
+					/* detach the element from the list and release it */
+					fprintf(stderr, Name ": Cannot activate array(s): %s "
+						"due to metadata incompatibility.\n",
+						ra->name);
+					if (prev)
+						prev->next = ra->next;
+					else
+						content = ra->next;
+					ra->next = NULL;
+					sysfs_free(ra);
+					/* set next item */
+					if (prev)
+						ra = prev->next;
+					else
+						ra = content;
+				} else {
+					prev = ra;
+					ra = ra->next;
+				}
+			}
+			for (;
 			     content;
 			     content = content->next) {
-
-				/* do not assemble arrays that might have bad blocks */
-				if (content->array.state & (1<<MD_SB_BBM_ERRORS)) {
-					fprintf(stderr, Name ": BBM log found in metadata. "
-								"Cannot activate array(s).\n");
-					tmpdev->used = 2;
-					goto loop;
-				}
 				if (!ident_matches(ident, content, tst,
 						   homehost, update,
 						   report_missmatch ? devname : NULL))
diff --git a/Incremental.c b/Incremental.c
index 951c2a0..23c4bf2 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1421,7 +1421,7 @@ static int Incremental_container(struct supertype *st, char *devname,
 	/* Collect the contents of this container and for each
 	 * array, choose a device name and assemble the array.
 	 */
-
+	struct mdinfo *prev;
 	struct mdinfo *list;
 	struct mdinfo *ra;
 	struct map_ent *map = NULL;
@@ -1460,18 +1460,39 @@ static int Incremental_container(struct supertype *st, char *devname,
 		trustworthy = FOREIGN;
 
 	list = st->ss->container_content(st, NULL);
+	  
+	/* release unsupported volumes to block requested action 
+	 */
+	for (ra = list, prev = NULL ; ra ; ) {
+		if (ra->array.state & MD_SB_ERRORS_FLAGS) {
+			/* detach the element from the list and release it */
+			fprintf(stderr, Name ": Cannot activate array(s): %s "
+				"due to metadata incompatibility.\n",
+				ra->name);
+			if (prev)
+				prev->next = ra->next;
+			else
+				list = ra->next;
+			ra->next = NULL;
+			sysfs_free(ra);
+			/* set next item */
+			if (prev)
+				ra = prev->next;
+			else
+				ra = list;
+		} else {
+			prev = ra;
+			ra = ra->next;
+		}
+	}
+	/* exit if there is no supported metadata volumess */
+	if (list == NULL) {
+		fprintf(stderr, Name ": Cannot activate array(s)\n ");
+		return 2;
+	}
 	if (map_lock(&map))
 		fprintf(stderr, Name ": failed to get exclusive lock on "
 			"mapfile\n");
-	/* do not assemble arrays that might have bad blocks */
-	if (list->array.state & (1<<MD_SB_BBM_ERRORS)) {
-		fprintf(stderr, Name ": BBM log found in metadata. "
-					"Cannot activate array(s).\n");
-		/* free container data and exit */
-		sysfs_free(list);
-		return 2;
-	}
-
 	for (ra = list ; ra ; ra = ra->next) {
 		int mdfd;
 		char chosen_name[1024];
diff --git a/md_p.h b/md_p.h
index 6c79a3d..618f8a4 100644
--- a/md_p.h
+++ b/md_p.h
@@ -101,9 +101,13 @@ typedef struct mdp_device_descriptor_s {
 #define MD_SB_CLEAN		0
 #define MD_SB_ERRORS		1
 #define MD_SB_BBM_ERRORS	2
+#define MD_SB_ATTR_ERRORS	3
+#define MD_SB_UNSUP_VOL_ERRORS	4
 
 #define	MD_SB_BITMAP_PRESENT	8 /* bitmap may be present nearby */
 
+#define MD_SB_ERRORS_FLAGS ((1 << MD_SB_ERRORS) | (1 << MD_SB_BBM_ERRORS) | (1 << MD_SB_ATTR_ERRORS) | (1 << MD_SB_UNSUP_VOL_ERRORS))
+
 typedef struct mdp_superblock_s {
 	/*
 	 * Constant generic information
diff --git a/super-intel.c b/super-intel.c
index a78d723..6ed307b 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5572,19 +5572,23 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 	struct mdinfo *rest = NULL;
 	unsigned int i;
 	int bbm_errors = 0;
+	int attr_errors = 0;
 	struct dl *d;
 	int spare_disks = 0;
 
 	/* do not assemble arrays when not all attributes are supported */
 	if (imsm_check_attributes(mpb->attributes) == 0) {
-		fprintf(stderr, Name ": IMSM metadata loading not allowed "
-			"due to attributes incompatibility.\n");
-		return NULL;
+		attr_errors = 1;
+		fprintf(stderr, Name ": Unsupported attributes in IMSM metadata."
+			"Arrays activation is blocked.\n");
 	}
 
 	/* check for bad blocks */
-	if (imsm_bbm_log_size(super->anchor))
+	if (imsm_bbm_log_size(super->anchor)) {
+		fprintf(stderr, Name ": BBM log found in IMSM metadata."
+			"Arrays activation is blocked.\n");
 		bbm_errors = 1;
+	}
 
 	/* count spare devices, not used in maps
 	 */
@@ -5623,18 +5627,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 		 */
 
 		chunk = __le16_to_cpu(map->blocks_per_strip) >> 1;
-#ifndef MDASSEMBLE
-		if (!validate_geometry_imsm_orom(super,
-						 get_imsm_raid_level(map), /* RAID level */
-						 imsm_level_to_layout(get_imsm_raid_level(map)),
-						 map->num_members, /* raid disks */
-						 &chunk,
-						 1 /* verbose */)) {
-			fprintf(stderr, Name ": RAID gemetry validation failed. "
-				"Cannot proceed with the action(s).\n");
-			continue;
-		}
-#endif /* MDASSEMBLE */
+
 		this = malloc(sizeof(*this));
 		if (!this) {
 			fprintf(stderr, Name ": failed to allocate %zu bytes\n",
@@ -5645,6 +5638,25 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 		super->current_vol = i;
 		getinfo_super_imsm_volume(st, this, NULL);
 		this->next = rest;
+		/* if array has bad blocks, set suitable bit in all arrays state */
+		if (bbm_errors)
+			this->array.state |= (1<<MD_SB_BBM_ERRORS);
+		/* mdadm does not support all metadata features- set suitable bit in all arrays state */
+		if (attr_errors)
+			this->array.state |= (1<<MD_SB_ATTR_ERRORS);
+#ifndef MDASSEMBLE
+		if (!validate_geometry_imsm_orom(super,
+						 get_imsm_raid_level(map), /* RAID level */
+						 imsm_level_to_layout(get_imsm_raid_level(map)),
+						 map->num_members, /* raid disks */
+						 &chunk,
+						 1 /* verbose */)) {
+			fprintf(stderr, Name ": IMSM RAID gemetry validation failed. "
+				"Array %s activation is blocked.\n",
+				dev->volume);
+			this->array.state |= (1<<MD_SB_UNSUP_VOL_ERRORS);
+		}
+#endif /* MDASSEMBLE */
 		for (slot = 0 ; slot <  map->num_members; slot++) {
 			unsigned long long recovery_start;
 			struct mdinfo *info_d;
@@ -5733,9 +5745,6 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 		rest = this;
 	}
 
-	/* if array has bad blocks, set suitable bit in array status */
-	if (bbm_errors)
-		rest->array.state |= (1<<MD_SB_BBM_ERRORS);
 
 	return rest;
 }
-- 
1.6.4.2

