From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 5/5] imsm: verify maximum supported active volumes in
 assembly
Date: Fri, 13 Jan 2012 11:20:27 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D4075DE9@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "neilb@suse.de" <neilb@suse.de>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Subject: [PATCH 5/5] imsm: verify maximum supported active volumes in assembly

Block assemblation of volumes when the total number of supported
volumes is exceeded.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 Assemble.c    |    3 +-
 Grow.c        |    6 +++-
 Incremental.c |    3 +-
 mdadm.h       |    1 +
 super-intel.c |   73 +++++++++++++++++++++++++++++++++++++++++++-------------
 util.c        |    1 +
 6 files changed, 66 insertions(+), 21 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index fd94461..1d2604f 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -438,7 +438,7 @@ int Assemble(struct supertype *st, char *mddev,
 			if (verbose > 0)
 				fprintf(stderr, Name ": looking in container %s\n",
 					devname);
-
+			tst->check_volumes_number = 1;
 			for (content = tst->ss->container_content(tst, NULL);
 			     content;
 			     content = content->next) {
@@ -460,6 +460,7 @@ int Assemble(struct supertype *st, char *mddev,
 				} else
 					break;
 			}
+			tst->check_volumes_number = 0;
 			if (!content) {
 				tmpdev->used = 2;
 				goto loop; /* empty container */
diff --git a/Grow.c b/Grow.c
index 5dab37c..3a8b5c3 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1493,8 +1493,9 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		if (st->ss->container_content) {
 			struct mdinfo *cc = NULL;
 			struct mdinfo *content = NULL;
-
+			st->check_volumes_number = 1;
 			cc = st->ss->container_content(st, subarray);
+			st->check_volumes_number = 0;
 			for (content = cc; content ; content = content->next) {
 				int allow_reshape = 1;
 
@@ -3813,8 +3814,9 @@ int Grow_continue_command(char *devname, int fd,
 			ret_val = 1;
 			goto Grow_continue_command_exit;
 		}
-
+		st->check_volumes_number = 1;
 		cc = st->ss->container_content(st, subarray);
+		st->check_volumes_number = 0;
 		for (content = cc; content ; content = content->next) {
 			char *array;
 			int allow_reshape = 1;
diff --git a/Incremental.c b/Incremental.c
index 60175af..0e37f98 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1407,8 +1407,9 @@ static int Incremental_container(struct supertype *st, char *devname,
 		trustworthy = LOCAL;
 	else
 		trustworthy = FOREIGN;
-
+	st->check_volumes_number = 1;
 	list = st->ss->container_content(st, NULL);
+	st->check_volumes_number = 0;
 	/* when nothing to activate - quit */
 	if (list == NULL)
 		return 0;
diff --git a/mdadm.h b/mdadm.h
index f274ae7..ac96bc4 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -849,6 +849,7 @@ struct supertype {
 	int minor_version;
 	int max_devs;
 	int container_dev;    /* devnum of container */
+	int check_volumes_number;
 	void *sb;
 	void *info;
 	int ignore_hw_compat; /* used to inform metadata handlers that it should ignore
diff --git a/super-intel.c b/super-intel.c
index 51826bc..7fc1841 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -497,6 +497,9 @@ static const char *_sys_dev_type[] = {
 	[SYS_DEV_SAS] = "SAS",
 	[SYS_DEV_SATA] = "SATA"
 };
+#ifndef MDASSEMBLE
+static int imsm_find_array_minor_by_subdev(int subdev, int container, int *minor);
+#endif
 
 const char *get_sys_dev_type(enum sys_dev_type type)
 {
@@ -616,6 +619,7 @@ static struct supertype *match_metadata_desc_imsm(char *arg)
 	st->ss = &super_imsm;
 	st->max_devs = IMSM_MAX_DEVICES;
 	st->minor_version = 0;
+	st->check_volumes_number = 0;
 	st->sb = NULL;
 	return st;
 }
@@ -5658,6 +5662,7 @@ count_volumes_list(struct md_list *devlist, char *homehost,
 	}
 	if (*found != 0) {
 		int err;
+		st->check_volumes_number = 0;
 		if ((err = load_super_imsm_all(st, -1, &st->sb, NULL, devlist, 0)) == 0) {
 			struct mdinfo *iter, *head = st->ss->container_content(st, NULL);
 			for (iter = head; iter; iter = iter->next) {
@@ -5701,7 +5706,7 @@ count_volumes_list(struct md_list *devlist, char *homehost,
 
 
 static int
-count_volumes(char *hba, int dpa, int verbose)
+count_volumes(char *hba, int dpa, int active_only, int verbose)
 {
 	struct md_list *devlist = NULL;
 	int count = 0;
@@ -5712,10 +5717,14 @@ count_volumes(char *hba, int dpa, int verbose)
 	if (devlist == NULL)
 		return 0;
 	  
-	count = active_arrays_by_format("imsm", hba, &devlist, dpa, verbose);
+	count = active_arrays_by_format("imsm", hba, &devlist, /*subarray,*/
+					dpa, verbose);
 	dprintf(" path: %s active arrays: %d\n", hba, count);
 	if (devlist == NULL)
 		return 0;
+	if (active_only)
+		goto release;
+
 	do  {
 		found = 0;
 		count += count_volumes_list(devlist,
@@ -5726,7 +5735,8 @@ count_volumes(char *hba, int dpa, int verbose)
 	} while (found);
 	
 	dprintf("path: %s total number of volumes: %d\n", hba, count);
-	
+
+ release:	
 	while(devlist) {
 		struct md_list *dv = devlist;
 		devlist = devlist->next;
@@ -5815,6 +5825,17 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 			"Cannot proceed with the action(s).\n");
 		return 0;
 	}
+	if (super->orom) {
+		int count = count_volumes(super->hba->path,
+					  super->orom->dpa,
+					  0, /* count all volumes */
+					  verbose);
+		if (super->orom->vphba <= count) {
+			pr_vrb(": platform does not support more then %d raid volumes.\n",
+			       super->orom->vphba);
+			return 0;
+		}
+	}
 	if (!dev) {
 		/* General test:  make sure there is space for
 		 * 'raiddisks' device extents of size 'size' at a given
@@ -5956,15 +5977,6 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 
 	*freesize = maxsize;
 	
-	if (super->orom) {
-		int count = count_volumes(super->hba->path,
-				      super->orom->dpa, verbose);
-		if (super->orom->vphba <= count) {
-			pr_vrb(": platform does not support more then %d raid volumes.\n",
-			       super->orom->vphba);
-			return 0;
-		}
-	}
 	return 1;
 }
 
@@ -6091,7 +6103,9 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 			if (super->orom && freesize) {
 				int count;
 				count = count_volumes(super->hba->path,
-						      super->orom->dpa, verbose);
+						      super->orom->dpa,
+						      0, /* count all volumes */
+						      verbose);
 				if (super->orom->vphba <= count) {
 					pr_vrb(": platform does not support more"
 					       "then %d raid volumes.\n",
@@ -6414,7 +6428,9 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 	int sb_errors = 0;
 	struct dl *d;
 	int spare_disks = 0;
-
+#ifndef MDASSEMBLE
+	int count = -1;
+#endif
 	/* do not assemble arrays when not all attributes are supported */
 	if (imsm_check_attributes(mpb->attributes) == 0) {
 		sb_errors = 1;
@@ -6428,8 +6444,6 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 			"Arrays activation is blocked.\n");
 		sb_errors = 1;
 	}
-
-
 	/* count spare devices, not used in maps
 	 */
 	for (d = super->disks; d; d = d->next)
@@ -6444,6 +6458,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 		int slot;
 #ifndef MDASSEMBLE
 		int chunk;
+		int devnum;
 #endif
 		char *ep;
 
@@ -6502,7 +6517,31 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 			this->array.state |=
 			  (1<<MD_SB_BLOCK_CONTAINER_RESHAPE) |
 			  (1<<MD_SB_BLOCK_VOLUME);
-
+#ifndef MDASSEMBLE
+		/* for inactive arrays check blocking condition */
+		if ((super->orom) &&
+		    (st->check_volumes_number) &&
+		    (imsm_find_array_minor_by_subdev(i,
+						     st->container_dev,
+						     &devnum) != 0)) {
+			/* get volumes number */
+			if (count == -1)
+				count = count_volumes(super->hba->path,
+						      super->orom->dpa,
+						      1, /* active only */
+						      0);
+			count++;
+			if (super->orom->vphba < count) {
+				this->array.state |=
+				  (1<<MD_SB_BLOCK_CONTAINER_RESHAPE) |
+				  (1<<MD_SB_BLOCK_VOLUME);
+				fprintf(stderr, Name ": platform does not support more then %d raid volumes.\n"
+					"Array %s activation is blocked.\n\n",
+					super->orom->vphba,
+					dev->volume);
+			}
+		  }
+#endif			
 		for (slot = 0 ; slot <  map->num_members; slot++) {
 			unsigned long long recovery_start;
 			struct mdinfo *info_d;
diff --git a/util.c b/util.c
index e95a366..ea18915 100644
--- a/util.c
+++ b/util.c
@@ -1020,6 +1020,7 @@ struct supertype *dup_super(struct supertype *orig)
 	st->ss = orig->ss;
 	st->max_devs = orig->max_devs;
 	st->minor_version = orig->minor_version;
+	st->check_volumes_number = orig->check_volumes_number;
 	st->sb = NULL;
 	st->info = NULL;
 	return st;
-- 
1.7.1

