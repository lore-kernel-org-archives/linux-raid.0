From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH] set default chunk in validate_geometry
Date: Mon, 21 Feb 2011 10:09:37 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F011197D8D5@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 33fa2700b9911b0815112b223a4df7b1f1716659 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Mon, 21 Feb 2011 10:24:26 +0100
Subject: [PATCH] set default chunk in validate_geometry
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

When chunk size is not set from command line we need to guess it
depending on metadata given on command line or found on listed devices.

Validate_geometry sets the default for it's metadata if chunk is not set.
For external metadata chunk is set only when creating in a container.
For imsm validate_geometry_imsm_orom is responsible for finding default
chunk depending on container metadata loaded. Container will already know
which controller it is attached to, and have this controllers orom
available.
do_default_chunk indicates that we need to find default chunk and
if validate_geometry fails for some metadata it tells us to reset chunk
that may have been set.

Current solution would set default chunk correctly for imsm only if
container device was given on command line. With the list of devices
chunk was always set to 512.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Create.c      |   25 ++++++++++++++-----------
 mdadm.h       |    3 ++-
 super-ddf.c   |   13 ++++++++-----
 super-gpt.c   |    2 +-
 super-intel.c |   28 ++++++++++++++++++----------
 super-mbr.c   |    2 +-
 super0.c      |    5 ++++-
 super1.c      |    5 ++++-
 8 files changed, 52 insertions(+), 31 deletions(-)

diff --git a/Create.c b/Create.c
index ccda07b..1cadbcc 100644
--- a/Create.c
+++ b/Create.c
@@ -114,6 +114,7 @@ int Create(struct supertype *st, char *mddev,
 	struct mdinfo info, *infos;
 	int did_default = 0;
 	int do_default_layout = 0;
+	int do_default_chunk = 0;
 	unsigned long safe_mode_delay = 0;
 	char chosen_name[1024];
 	struct map_ent *map = NULL;
@@ -229,13 +230,9 @@ int Create(struct supertype *st, char *mddev,
 	case 10:
 	case 6:
 	case 0:
-		if (chunk == 0) {
-			if (st && st->ss->default_geometry)
-				st->ss->default_geometry(st, NULL, NULL, &chunk);
-			chunk = chunk ? : 512;
-			if (verbose > 0)
-				fprintf(stderr, Name ": chunk size defaults to %dK\n", chunk);
-		}
+		if (chunk == 0 || chunk == UnSet)
+			do_default_chunk = 1;
+			/* chunk will be set later */
 		break;
 	case LEVEL_LINEAR:
 		/* a chunksize of zero 0s perfectly valid (and preferred) since 2.6.16 */
@@ -264,7 +261,7 @@ int Create(struct supertype *st, char *mddev,
 		size &= ~(unsigned long long)(chunk - 1);
 	newsize = size * 2;
 	if (st && ! st->ss->validate_geometry(st, level, layout, raiddisks,
-					      chunk, size*2, NULL, &newsize, verbose>=0))
+					      &chunk, size*2, NULL, &newsize, verbose>=0))
 		return 1;
 	if (size == 0) {
 		size = newsize / 2;
@@ -308,10 +305,11 @@ int Create(struct supertype *st, char *mddev,
 					layout = default_layout(st, level, verbose);
 				if (st && !st->ss->validate_geometry
 					    	(st, level, layout, raiddisks,
-						 chunk, size*2, dname, &freesize,
+						 &chunk, size*2, dname, &freesize,
 						 verbose > 0)) {
 					free(st);
 					st = NULL;
+					chunk = do_default_chunk ? 0 : chunk;
 				}
 			}
 
@@ -329,7 +327,7 @@ int Create(struct supertype *st, char *mddev,
 				layout = default_layout(st, level, verbose);
 			if (!st->ss->validate_geometry(st, level, layout,
 						       raiddisks,
-						       chunk, size*2, dname,
+						       &chunk, size*2, dname,
 						       &freesize,
 						       verbose >= 0)) {
 
@@ -341,6 +339,11 @@ int Create(struct supertype *st, char *mddev,
 				continue;
 			}
 		}
+		if (verbose > 0 && do_default_chunk) {
+			do_default_chunk = 0;
+			fprintf(stderr, Name ": chunk size "
+				"defaults to %dK\n", chunk);
+		}
 
 		freesize /= 2; /* convert to K */
 		if (chunk) {
@@ -422,7 +425,7 @@ int Create(struct supertype *st, char *mddev,
 			/* size is meaningful */
 			if (!st->ss->validate_geometry(st, level, layout,
 						       raiddisks,
-						       chunk, minsize*2,
+						       &chunk, minsize*2,
 						       NULL, NULL, 0)) {
 				fprintf(stderr, Name ": devices too large for RAID level %d\n", level);
 				return 1;
diff --git a/mdadm.h b/mdadm.h
index 9f20ba1..a1be856 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -64,6 +64,7 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 #define BLKGETSIZE64 _IOR(0x12,114,size_t) /* return device size in bytes (u64 *arg) */
 #endif
 
+#define DEFAULT_CHUNK 512
 #define DEFAULT_BITMAP_CHUNK 4096
 #define DEFAULT_BITMAP_DELAY 5
 #define DEFAULT_MAX_WRITE_BEHIND 256
@@ -700,7 +701,7 @@ extern struct superswitch {
 	 */
 	int (*validate_geometry)(struct supertype *st, int level, int layout,
 				 int raiddisks,
-				 int chunk, unsigned long long size,
+				 int *chunk, unsigned long long size,
 				 char *subdev, unsigned long long *freesize,
 				 int verbose);
 
diff --git a/super-ddf.c b/super-ddf.c
index 287fa7f..bbf23f3 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2545,13 +2545,13 @@ validate_geometry_ddf_container(struct supertype *st,
 
 static int validate_geometry_ddf_bvd(struct supertype *st,
 				     int level, int layout, int raiddisks,
-				     int chunk, unsigned long long size,
+				     int *chunk, unsigned long long size,
 				     char *dev, unsigned long long *freesize,
 				     int verbose);
 
 static int validate_geometry_ddf(struct supertype *st,
 				 int level, int layout, int raiddisks,
-				 int chunk, unsigned long long size,
+				 int *chunk, unsigned long long size,
 				 char *dev, unsigned long long *freesize,
 				 int verbose)
 {
@@ -2569,7 +2569,7 @@ static int validate_geometry_ddf(struct supertype *st,
 	if (level == LEVEL_CONTAINER) {
 		/* Must be a fresh device to add to a container */
 		return validate_geometry_ddf_container(st, level, layout,
-						       raiddisks, chunk,
+						       raiddisks, chunk?*chunk:0,
 						       size, dev, freesize,
 						       verbose);
 	}
@@ -2596,7 +2596,7 @@ static int validate_geometry_ddf(struct supertype *st,
 			 * chosen so that add_to_super/getinfo_super
 			 * can return them.
 			 */
-			return reserve_space(st, raiddisks, size, chunk, freesize);
+			return reserve_space(st, raiddisks, size, chunk?*chunk:0, freesize);
 		}
 		return 1;
 	}
@@ -2713,7 +2713,7 @@ validate_geometry_ddf_container(struct supertype *st,
 
 static int validate_geometry_ddf_bvd(struct supertype *st,
 				     int level, int layout, int raiddisks,
-				     int chunk, unsigned long long size,
+				     int *chunk, unsigned long long size,
 				     char *dev, unsigned long long *freesize,
 				     int verbose)
 {
@@ -2733,6 +2733,9 @@ static int validate_geometry_ddf_bvd(struct supertype *st,
 	/* We must have the container info already read in. */
 	if (!ddf)
 		return 0;
+	
+	if (chunk && (*chunk == 0 || *chunk == UnSet))
+		*chunk = DEFAULT_CHUNK;
 
 	if (!dev) {
 		/* General test:  make sure there is space for
diff --git a/super-gpt.c b/super-gpt.c
index f60a671..6f852aa 100644
--- a/super-gpt.c
+++ b/super-gpt.c
@@ -193,7 +193,7 @@ static struct supertype *match_metadata_desc(char *arg)
 #ifndef MDASSEMBLE
 static int validate_geometry(struct supertype *st, int level,
 			     int layout, int raiddisks,
-			     int chunk, unsigned long long size,
+			     int *chunk, unsigned long long size,
 			     char *subdev, unsigned long long *freesize,
 			     int verbose)
 {
diff --git a/super-intel.c b/super-intel.c
index f3e248e..e8d2c6b 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4165,17 +4165,21 @@ static int is_raid_level_supported(const struct imsm_orom *orom, int level, int
 #define pr_vrb(fmt, arg...) (void) (verbose && fprintf(stderr, Name fmt, ##arg))
 static int
 validate_geometry_imsm_orom(struct intel_super *super, int level, int layout,
-			    int raiddisks, int chunk, int verbose)
+			    int raiddisks, int *chunk, int verbose)
 {
 	if (!is_raid_level_supported(super->orom, level, raiddisks)) {
 		pr_vrb(": platform does not support raid%d with %d disk%s\n",
 			level, raiddisks, raiddisks > 1 ? "s" : "");
 		return 0;
 	}
-	if (super->orom && level != 1 &&
-	    !imsm_orom_has_chunk(super->orom, chunk)) {
-		pr_vrb(": platform does not support a chunk size of: %d\n", chunk);
-		return 0;
+	if (super->orom && level != 1) {
+		if (chunk && (*chunk == 0 || *chunk == UnSet))
+			*chunk = imsm_orom_default_chunk(super->orom);
+		else if (chunk && !imsm_orom_has_chunk(super->orom, *chunk)) {
+			pr_vrb(": platform does not support a chunk size of: "
+			       "%d\n", *chunk);
+			return 0;
+		}
 	}
 	if (layout != imsm_level_to_layout(level)) {
 		if (level == 5)
@@ -4195,7 +4199,7 @@ validate_geometry_imsm_orom(struct intel_super *super, int level, int layout,
  * FIX ME add ahci details
  */
 static int validate_geometry_imsm_volume(struct supertype *st, int level,
-					 int layout, int raiddisks, int chunk,
+					 int layout, int raiddisks, int *chunk,
 					 unsigned long long size, char *dev,
 					 unsigned long long *freesize,
 					 int verbose)
@@ -4414,7 +4418,7 @@ static int reserve_space(struct supertype *st, int raiddisks,
 }
 
 static int validate_geometry_imsm(struct supertype *st, int level, int layout,
-				  int raiddisks, int chunk, unsigned long long size,
+				  int raiddisks, int *chunk, unsigned long long size,
 				  char *dev, unsigned long long *freesize,
 				  int verbose)
 {
@@ -4428,7 +4432,8 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 	if (level == LEVEL_CONTAINER) {
 		/* Must be a fresh device to add to a container */
 		return validate_geometry_imsm_container(st, level, layout,
-							raiddisks, chunk, size,
+							raiddisks,
+							chunk?*chunk:0, size,
 							dev, freesize,
 							verbose);
 	}
@@ -4447,7 +4452,8 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 							 raiddisks, chunk,
 							 verbose))
 				return 0;
-			return reserve_space(st, raiddisks, size, chunk, freesize);
+			return reserve_space(st, raiddisks, size,
+					     chunk?*chunk:0, freesize);
 		}
 		return 1;
 	}
@@ -6925,6 +6931,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	struct mdinfo info;
 	int change = -1;
 	int check_devs = 0;
+	int chunk;
 
 	getinfo_super_imsm_volume(st, &info, NULL);
 
@@ -6999,11 +7006,12 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	else
 		geo->chunksize = info.array.chunk_size;
 
+	chunk = geo->chunksize / 1024;
 	if (!validate_geometry_imsm(st,
 				    geo->level,
 				    geo->layout,
 				    geo->raid_disks,
-				    (geo->chunksize / 1024),
+				    &chunk,
 				    geo->size,
 				    0, 0, 1))
 		change = -1;
diff --git a/super-mbr.c b/super-mbr.c
index 7d770aa..5eefdf6 100644
--- a/super-mbr.c
+++ b/super-mbr.c
@@ -187,7 +187,7 @@ static struct supertype *match_metadata_desc(char *arg)
 #ifndef MDASSEMBLE
 static int validate_geometry(struct supertype *st, int level,
 			     int layout, int raiddisks,
-			     int chunk, unsigned long long size,
+			     int *chunk, unsigned long long size,
 			     char *subdev, unsigned long long *freesize,
 			     int verbose)
 {
diff --git a/super0.c b/super0.c
index 0b95dac..1947968 100644
--- a/super0.c
+++ b/super0.c
@@ -1090,7 +1090,7 @@ static void free_super0(struct supertype *st)
 #ifndef MDASSEMBLE
 static int validate_geometry0(struct supertype *st, int level,
 			      int layout, int raiddisks,
-			      int chunk, unsigned long long size,
+			      int *chunk, unsigned long long size,
 			      char *subdev, unsigned long long *freesize,
 			      int verbose)
 {
@@ -1115,6 +1115,9 @@ static int validate_geometry0(struct supertype *st, int level,
 	}
 	if (!subdev)
 		return 1;
+	
+	if (chunk && (*chunk == 0 || *chunk == UnSet))
+		*chunk = DEFAULT_CHUNK;
 
 	fd = open(subdev, O_RDONLY|O_EXCL, 0);
 	if (fd < 0) {
diff --git a/super1.c b/super1.c
index 50a5f48..4c68871 100644
--- a/super1.c
+++ b/super1.c
@@ -1654,7 +1654,7 @@ static void free_super1(struct supertype *st)
 #ifndef MDASSEMBLE
 static int validate_geometry1(struct supertype *st, int level,
 			      int layout, int raiddisks,
-			      int chunk, unsigned long long size,
+			      int *chunk, unsigned long long size,
 			      char *subdev, unsigned long long *freesize,
 			      int verbose)
 {
@@ -1668,6 +1668,9 @@ static int validate_geometry1(struct supertype *st, int level,
 	}
 	if (!subdev)
 		return 1;
+	
+	if (chunk && (*chunk == 0 || *chunk == UnSet))
+		*chunk = DEFAULT_CHUNK;
 
 	fd = open(subdev, O_RDONLY|O_EXCL, 0);
 	if (fd < 0) {
-- 
1.7.1

