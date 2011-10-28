From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH] kill-subarray: fix, IMSM cannot kill-subarray with
 unsupported metadata
Date: Fri, 28 Oct 2011 14:46:57 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D4043755@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Hi Neil,
Please review modified patch in response for your comments.
I have introduced two flags, one for activation blocking, second for container wide reshapes
Blocking:
- some arrays in container are blocked, the others can be activated and reshaped,
- some arrays are blocked, others can be activated but container wide reshaped is blocked for all.

Thanks,
Marcin Labun

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, September 07, 2011 6:31 AM
> To: Williams, Dan J
> Cc: Labun, Marcin; linux-raid@vger.kernel.org; Ciechanowski, Ed
> Subject: Re: [PATCH] kill-subarray: fix, cannot kill-subarray with
> unsupported metadata

<cut>

> I think I would like:
>  - container_content always returns info about all arrays, so Examine
> and
>    Kill can work properly
>  - it sets a single flags (MD_SB_INVALID??) to say that the array
> cannot be
>    assembled or manipulated, and maybe stored a message string in the
> 'info'
>    so that common code can print it when it choses to ignore an array
>  - common code checks and ignores MD_SB_INVALID arrays as needed rather
> than
>    having them be removed from the list.
> 
> Reasonable??
> 
> Thanks,
> NeilBrownSubject: 

[PATCH] kill-subarray: fix, IMSM cannot kill-subarray with unsupported metadata


container_content retrieves volume information from disks in the container.
For unsupported volumes the function was not returning mdinfo. When all volumes
were unsupported the function was returning NULL pointer to block actions
on the volumes. Therefore, such volumes were not activated in Incremental
and Assembly. As side effect they also could not be deleted using
kill-subarray since "kill" function requires to obtain a valid mdinfo
from container_content.

This patch fixes the kill-subarray problem by allowing to obtain mdinfo of all
volumes types including unsupported and introducing new array.status flags
There are following changes:
1. Added MD_SB_BLOCK_VOLUME for blocking an array,
other arrays in the container can be activated.

2. Added MD_SB_BLOCK_CONTAINER_RESHAPE block container wide reshapes (like
changing disk numbers in arrays).

3. IMSM container_content handler is to load mdinfo for all volumes and set
both blocking flags in array.state field in mdinfo of unsupported volumes.
In case of some errors, all volumes can be affected. Only blocked
array is not activated (also reshaped as result). The container wide reshapes
are also blocked since by metadata definition they require modifications
of both arrays.

4. Incremental_container and Assemble functions check array.state and do not activate
volumes with blocking bits set.

5. assemble_container_content is changed to check container wide reshapes
before activating reshapes of assembled containers.

6. Grow_reshape and Grow_continue_command checks blocing bits before starting reshapes
or continueing (-G --continue) reshapes.

7. kill-subarray ignores array.state info and can remove requested array.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 Assemble.c    |   22 +++++++++-----
 Grow.c        |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 Incremental.c |   30 ++++++++++++++-------
 md_p.h        |    3 +-
 mdadm.h       |    3 ++
 super-intel.c |   59 ++++++++++++++++++++++++----------------
 6 files changed, 154 insertions(+), 45 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index c97fbea..7f04c87 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -439,13 +439,6 @@ int Assemble(struct supertype *st, char *mddev,
 			     content;
 			     content = content->next) {
 
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
@@ -455,6 +448,12 @@ int Assemble(struct supertype *st, char *mddev,
 						fprintf(stderr, Name ": member %s in %s is already assembled\n",
 							content->text_version,
 							devname);
+				} else if (content->array.state & (1<<MD_SB_BLOCK_VOLUME)) {
+					/* do not assemble arrays with unsupported configurations */
+					fprintf(stderr, Name ": Cannot activate member %s in %s.\n",
+						content->text_version,
+						devname);
+					continue;
 				} else
 					break;
 			}
@@ -1596,8 +1595,15 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		 (working + preexist + expansion) >=
 			content->array.working_disks) {
 		int err;
+		int start_reshape;
 
-		if (content->reshape_active) {
+		/* There are two types of reshape: container wide or sub-array specific
+		 * Check if metadata requests blocking container wide reshapes
+		 */
+		start_reshape = (content->reshape_active &&
+				 !((content->reshape_active == CONTAINER_RESHAPE) &&
+				   (content->array.state & (1<<MD_SB_BLOCK_CONTAINER_RESHAPE))));
+		if (start_reshape) {
 			int spare = content->array.raid_disks + expansion;
 			if (restore_backup(st, content,
 					   working,
diff --git a/Grow.c b/Grow.c
index 405bf69..220bc98 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1356,6 +1356,39 @@ static int reshape_container(char *container, char *devname,
 			     char *backup_file,
 			     int quiet, int restart, int freeze_reshape);
 
+/*
+ * helper routine to check metadata reshape avalability
+ * 1. Do not "grow" arrays with volume activation blocked
+ * 2. do not reshape containers with container reshape blocked
+ *
+ * IN:
+ *	subarray - array name or NULL for container wide reshape
+ *	content - md device info from container_content
+ * OUT:
+ *	0 - block reshape
+ */
+static int check_reshape(char *subarray, struct mdinfo *content)
+{
+	char *ep;
+	unsigned int idx;
+	printf("subarray: %s\n", subarray);
+
+	
+	if (!subarray) {
+		if (content->array.state & (1<<MD_SB_BLOCK_CONTAINER_RESHAPE))
+			return 0;
+	}
+	else {
+		/* do not "grow" arrays with volume activation blocked */
+		idx = strtoul(subarray, &ep, 10);
+		if ((*ep == '\0') && (content->container_member == (int) idx) &&
+		    (content->array.state & (1<<MD_SB_BLOCK_VOLUME)))
+			return 0;
+	}
+	  
+	return 1;
+}
+
 int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 long long size,
 		 int level, char *layout_str, int chunksize, int raid_disks,
@@ -1466,6 +1499,32 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			return 1;
 		}
 
+		/* check if operation is supported for metadata handler */
+		if (st->ss->container_content) {
+			struct mdinfo *cc = NULL;
+			struct mdinfo *content = NULL;
+
+			cc = st->ss->container_content(st, subarray);
+			for (content = cc; content ; content = content->next) {
+				int allow_reshape;
+
+				/* check if reshape is allowed based on metadata
+				 * indications stored in content.array.status
+				 */
+				allow_reshape = check_reshape(subarray, content);
+				if (!allow_reshape) {
+					fprintf(stderr, Name
+						" cannot reshape arrays in"
+						"container with unsupported"
+						" metadata: %s(%s)\n",
+						devname, container_buf);
+					sysfs_free(cc);
+					free(subarray);
+					return 1;
+				}
+			}
+			sysfs_free(cc);
+		}
 		if (mdmon_running(container_dev))
 			st->update_tail = &st->updates;
 	}
@@ -1498,6 +1557,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			devname);
 		return 1;
 	}
+	
 	frozen = freeze(st);
 	if (frozen < -1) {
 		/* freeze() already spewed the reason */
@@ -3606,6 +3666,9 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 	return 1;
 }
 
+
+
+
 int Grow_continue_command(char *devname, int fd,
 			  char *backup_file, int verbose)
 {
@@ -3675,14 +3738,29 @@ int Grow_continue_command(char *devname, int fd,
 			ret_val = 1;
 			goto Grow_continue_command_exit;
 		}
-
 		cc = st->ss->container_content(st, NULL);
 		for (content = cc; content ; content = content->next) {
 			char *array;
+			int allow_reshape;
 
 			if (content->reshape_active == 0)
 				continue;
-
+			/* the decision about array or container wide reshape is taken
+			   in Grow_continue based content->reshape_active state, therefore
+			   we need to check_reshape based on reshape_active and subarray name
+			*/
+			allow_reshape =
+			  check_reshape((content->reshape_active == CONTAINER_RESHAPE)? NULL : subarray,
+					content);
+			if (!allow_reshape) {
+				fprintf(stderr, 
+					Name " cannot continue reshape of an array in container with unsupported"
+					" metadata: %s(%s)\n",
+					devname, buf);
+				ret_val = 1;
+				goto Grow_continue_command_exit;
+			}
+			
 			array = strchr(content->text_version+1, '/')+1;
 			mdstat = mdstat_by_subdev(array, container_dev);
 			if (!mdstat)
diff --git a/Incremental.c b/Incremental.c
index 472d0b5..52429b9 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1436,6 +1436,8 @@ static int Incremental_container(struct supertype *st, char *devname,
 	struct map_ent *smp;
 	int suuid[4];
 	int sfd;
+	int ra_blocked = 0;
+	int ra_all = 0;
 
 	st->ss->getinfo_super(st, &info, NULL);
 
@@ -1463,25 +1465,26 @@ static int Incremental_container(struct supertype *st, char *devname,
 		trustworthy = FOREIGN;
 
 	list = st->ss->container_content(st, NULL);
+	/* when nothing to activate - quit */
+	if (list == NULL)
+		return 0;
 	if (map_lock(&map))
 		fprintf(stderr, Name ": failed to get exclusive lock on "
 			"mapfile\n");
-	/* do not assemble arrays that might have bad blocks */
-	if (list && list->array.state & (1<<MD_SB_BBM_ERRORS)) {
-		fprintf(stderr, Name ": BBM log found in metadata. "
-					"Cannot activate array(s).\n");
-		/* free container data and exit */
-		sysfs_free(list);
-		map_unlock(&map);
-		return 2;
-	}
-
 	for (ra = list ; ra ; ra = ra->next) {
 		int mdfd;
 		char chosen_name[1024];
 		struct map_ent *mp;
 		struct mddev_ident *match = NULL;
 
+		ra_all++;
+		/* do not activate arrays blocked by metadata handler */
+		if (ra->array.state & (1 << MD_SB_BLOCK_VOLUME)) {
+			fprintf(stderr, Name ": Cannot activate array %s in %s.\n",
+				ra->text_version, devname);
+			ra_blocked++;
+			continue;
+		}
 		mp = map_by_uuid(&map, ra->uuid);
 
 		if (mp) {
@@ -1562,6 +1565,13 @@ static int Incremental_container(struct supertype *st, char *devname,
 		close(mdfd);
 	}
 
+	/* don't move spares to container with volume being activated
+	   when all volumes are blocked */
+	if (ra_all == ra_blocked) {
+		map_unlock(&map);
+		return 0;
+	}
+	  
 	/* Now move all suitable spares from spare container */
 	domains = domain_from_array(list, st->ss->name);
 	memcpy(suuid, uuid_zero, sizeof(int[4]));
diff --git a/md_p.h b/md_p.h
index 6c79a3d..47024d9 100644
--- a/md_p.h
+++ b/md_p.h
@@ -101,7 +101,8 @@ typedef struct mdp_device_descriptor_s {
 #define MD_SB_CLEAN		0
 #define MD_SB_ERRORS		1
 #define MD_SB_BBM_ERRORS	2
-
+#define MD_SB_BLOCK_CONTAINER_RESHAPE 3 /* block container wide reshapes */ 
+#define MD_SB_BLOCK_VOLUME	4 /* block activation of array, other arrays in container can be activated */
 #define	MD_SB_BITMAP_PRESENT	8 /* bitmap may be present nearby */
 
 typedef struct mdp_superblock_s {
diff --git a/mdadm.h b/mdadm.h
index cfef0ad..8316861 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -194,6 +194,9 @@ struct mdinfo {
 	unsigned long long	custom_array_size; /* size for non-default sized
 						    * arrays (in sectors)
 						    */
+#define NO_RESHAPE		0
+#define VOLUME_RESHAPE		1			    
+#define CONTAINER_RESHAPE	2
 	int			reshape_active;
 	unsigned long long	reshape_progress;
 	int			recovery_blocked; /* for external metadata it
diff --git a/super-intel.c b/super-intel.c
index 3cffbf5..e4d71e7 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2306,7 +2306,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 			/* this needs to be applied to every array
 			 * in the container.
 			 */
-			info->reshape_active = 2;
+			info->reshape_active = CONTAINER_RESHAPE;
 		}
 		/* We shape information that we give to md might have to be
 		 * modify to cope with md's requirement for reshaping arrays.
@@ -5686,20 +5686,24 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 	struct imsm_super *mpb = super->anchor;
 	struct mdinfo *rest = NULL;
 	unsigned int i;
-	int bbm_errors = 0;
+	int sb_errors = 0;
 	struct dl *d;
 	int spare_disks = 0;
 
 	/* do not assemble arrays when not all attributes are supported */
 	if (imsm_check_attributes(mpb->attributes) == 0) {
-		fprintf(stderr, Name ": IMSM metadata loading not allowed "
-			"due to attributes incompatibility.\n");
-		return NULL;
+		sb_errors = 1;
+		fprintf(stderr, Name ": Unsupported attributes in IMSM metadata."
+			"Arrays activation is blocked.\n");
 	}
 
 	/* check for bad blocks */
-	if (imsm_bbm_log_size(super->anchor))
-		bbm_errors = 1;
+	if (imsm_bbm_log_size(super->anchor)) {
+		fprintf(stderr,	Name ": BBM log found in IMSM metadata."
+			"Arrays activation is blocked.\n");
+ 		sb_errors = 1;
+	}
+
 
 	/* count spare devices, not used in maps
 	 */
@@ -5728,7 +5732,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 		 */
 		if (dev->vol.migr_state &&
 		    (migr_type(dev) == MIGR_STATE_CHANGE)) {
-			fprintf(stderr, Name ": cannot assemble volume '%.16s':"
+			fprintf(stderr,	Name ": cannot assemble volume '%.16s':"
 				" unsupported migration in progress\n",
 				dev->volume);
 			continue;
@@ -5738,18 +5742,6 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
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
 		this = malloc(sizeof(*this));
 		if (!this) {
 			fprintf(stderr, Name ": failed to allocate %zu bytes\n",
@@ -5760,6 +5752,29 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 		super->current_vol = i;
 		getinfo_super_imsm_volume(st, this, NULL);
 		this->next = rest;
+#ifndef MDASSEMBLE
+		/* mdadm does not support all metadata features- set the bit in all arrays state */
+		if (!validate_geometry_imsm_orom(super,
+						 get_imsm_raid_level(map), /* RAID level */
+						 imsm_level_to_layout(get_imsm_raid_level(map)),
+						 map->num_members, /* raid disks */
+						 &chunk,
+						 1 /* verbose */)) {
+			fprintf(stderr, Name ": IMSM RAID gemetry validation failed. "
+				"Array %s activation is blocked.\n",
+				dev->volume);
+			this->array.state |= 
+			  (1<<MD_SB_BLOCK_CONTAINER_RESHAPE) |
+			  (1<<MD_SB_BLOCK_VOLUME);
+		}
+#endif
+
+		/* if array has bad blocks, set suitable bit in all arrays state */
+		if (sb_errors)
+			this->array.state |= 
+			  (1<<MD_SB_BLOCK_CONTAINER_RESHAPE) |
+			  (1<<MD_SB_BLOCK_VOLUME);
+
 		for (slot = 0 ; slot <  map->num_members; slot++) {
 			unsigned long long recovery_start;
 			struct mdinfo *info_d;
@@ -5848,10 +5863,6 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 		rest = this;
 	}
 
-	/* if array has bad blocks, set suitable bit in array status */
-	if (bbm_errors)
-		rest->array.state |= (1<<MD_SB_BBM_ERRORS);
-
 	return rest;
 }
 
-- 
1.7.1

