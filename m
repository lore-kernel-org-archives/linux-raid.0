From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 09/13] Create: cleanup/unify default geometry handling
Date: Thu, 18 Nov 2010 10:22:33 +0100
Message-ID: <20101118092233.29508.33621.stgit@gklab-170-111.igk.intel.com>
References: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

Support metadata specific level, layout and chunksize defaults.  Kill an
uneeded superswitch methods ahead of adding more for the reshape case.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Create.c      |   21 ++++++---------------
 mdadm.h       |    8 +++-----
 super-ddf.c   |   11 ++++++++++-
 super-intel.c |   15 +++++++++------
 4 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/Create.c b/Create.c
index 2bf7ebe..bc2613a 100644
--- a/Create.c
+++ b/Create.c
@@ -31,8 +31,8 @@ static int default_layout(struct supertype *st, int level, int verbose)
 {
 	int layout = UnSet;
 
-	if (st && st->ss->default_layout)
-		layout = st->ss->default_layout(level);
+	if (st && st->ss->default_geometry)
+		st->ss->default_geometry(st, &level, &layout, NULL);
 
 	if (layout == UnSet)
 		switch(level) {
@@ -120,15 +120,8 @@ int Create(struct supertype *st, char *mddev,
 	int major_num = BITMAP_MAJOR_HI;
 
 	memset(&info, 0, sizeof(info));
-
-	if (level == UnSet) {
-		/* "ddf" and "imsm" metadata only supports one level - should possibly
-		 * push this into metadata handler??
-		 */
-		if (st && (st->ss == &super_ddf || st->ss == &super_imsm))
-			level = LEVEL_CONTAINER;
-	}
-
+	if (level == UnSet && st && st->ss->default_geometry)
+		st->ss->default_geometry(st, &level, NULL, NULL);
 	if (level == UnSet) {
 		fprintf(stderr,
 			Name ": a RAID level is needed to create an array.\n");
@@ -235,11 +228,9 @@ int Create(struct supertype *st, char *mddev,
 	case 6:
 	case 0:
 		if (chunk == 0) {
-			if (st && st->ss->default_chunk)
-				chunk = st->ss->default_chunk(st);
-
+			if (st && st->ss->default_geometry)
+				st->ss->default_geometry(st, NULL, NULL, &chunk);
 			chunk = chunk ? : 512;
-
 			if (verbose > 0)
 				fprintf(stderr, Name ": chunk size defaults to %dK\n", chunk);
 		}
diff --git a/mdadm.h b/mdadm.h
index f7172e9..a4de06f 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -612,7 +612,7 @@ extern struct superswitch {
 	 * added to validate changing size and new devices.  If there are
 	 * inter-device dependencies, it should record sufficient details
 	 * so these can be validated.
-	 * Both 'size' and '*freesize' are in sectors.  chunk is bytes.
+	 * Both 'size' and '*freesize' are in sectors.  chunk is KiB.
 	 */
 	int (*validate_geometry)(struct supertype *st, int level, int layout,
 				 int raiddisks,
@@ -621,10 +621,8 @@ extern struct superswitch {
 				 int verbose);
 
 	struct mdinfo *(*container_content)(struct supertype *st);
-	/* Allow a metadata handler to override mdadm's default layouts */
-	int (*default_layout)(int level); /* optional */
-	/* query the supertype for default chunk size */
-	int (*default_chunk)(struct supertype *st); /* optional */
+	/* query the supertype for default geometry */
+	void (*default_geometry)(struct supertype *st, int *level, int *layout, int *chunk); /* optional */
 	/* Permit subarray's to be deleted from inactive containers */
 	int (*kill_subarray)(struct supertype *st); /* optional */
 	/* Permit subarray's to be modified */
diff --git a/super-ddf.c b/super-ddf.c
index dba5970..772ca97 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3653,6 +3653,15 @@ static int ddf_level_to_layout(int level)
 	}
 }
 
+static void default_geometry_ddf(struct supertype *st, int *level, int *layout, int *chunk)
+{
+	if (level && *level == UnSet)
+		*level = LEVEL_CONTAINER;
+
+	if (level && layout && *layout == UnSet)
+		*layout = ddf_level_to_layout(*level);
+}
+
 struct superswitch super_ddf = {
 #ifndef	MDASSEMBLE
 	.examine_super	= examine_super_ddf,
@@ -3680,7 +3689,7 @@ struct superswitch super_ddf = {
 	.free_super	= free_super_ddf,
 	.match_metadata_desc = match_metadata_desc_ddf,
 	.container_content = container_content_ddf,
-	.default_layout	= ddf_level_to_layout,
+	.default_geometry = default_geometry_ddf,
 
 	.external	= 1,
 
diff --git a/super-intel.c b/super-intel.c
index b880a74..7c5fcc4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4115,14 +4115,18 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 	return 0;
 }
 
-static int default_chunk_imsm(struct supertype *st)
+static void default_geometry_imsm(struct supertype *st, int *level, int *layout, int *chunk)
 {
 	struct intel_super *super = st->sb;
 
-	if (!super->orom)
-		return 0;
+	if (level && *level == UnSet)
+		*level = LEVEL_CONTAINER;
+
+	if (level && layout && *layout == UnSet)
+		*layout = imsm_level_to_layout(*level);
 
-	return imsm_orom_default_chunk(super->orom);
+	if (chunk && (*chunk == UnSet || *chunk == 0) && super->orom)
+		*chunk = imsm_orom_default_chunk(super->orom);
 }
 
 static void handle_missing(struct intel_super *super, struct imsm_dev *dev);
@@ -5567,7 +5571,6 @@ struct superswitch super_imsm = {
 	.brief_detail_super = brief_detail_super_imsm,
 	.write_init_super = write_init_super_imsm,
 	.validate_geometry = validate_geometry_imsm,
-	.default_chunk	= default_chunk_imsm,
 	.add_to_super	= add_to_super_imsm,
 	.detail_platform = detail_platform_imsm,
 	.kill_subarray = kill_subarray_imsm,
@@ -5588,7 +5591,7 @@ struct superswitch super_imsm = {
 	.free_super	= free_super_imsm,
 	.match_metadata_desc = match_metadata_desc_imsm,
 	.container_content = container_content_imsm,
-	.default_layout = imsm_level_to_layout,
+	.default_geometry = default_geometry_imsm,
 
 	.external	= 1,
 	.name = "imsm",

