Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909B03C482
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 13:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714396068; cv=none; b=ZbjS9/dtuKuEIBkkcEDRshloU95ZrhQQEq1dPz+tPdzF7kYv8ixEKuOkMYx0WHGqkKV1DwMamrZCWpg7WKoB4sUnX4nwBGt1d5elETJmEP4C+3/kKIqSyrHOYH+7t3yEopkYYCk1CIhlunJkMmAWwIWiQ50VAgrh/ia793sTlBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714396068; c=relaxed/simple;
	bh=FFvM5gdqxSQLlIWLJUetf6JfQLyJVlLZLpnOmxqu+yo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KqmK+zU1RC0E2VJv9JKiDozrlJQTBDHre9DwKl3X0A9ow9G6KGK0Gw/nfn+i3vp3U39RwNjRpIQejCoQ0S0mQ+8qfmnYrc+DETTse7U20l6AdV+ZrMZYpaxvaCL2Vcb7zAAxGBxxNxfyeqgHX8NjUMJrZEyUuBZgIFmlyJLsCQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a86cp2J2; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a86cp2J2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714396067; x=1745932067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FFvM5gdqxSQLlIWLJUetf6JfQLyJVlLZLpnOmxqu+yo=;
  b=a86cp2J24LnYlz1OEBep9c6usb7gPQ21dWGxuRPbEMia9Tm67B4Q3VBb
   u9zocjkMkz/9uNNxAn1f6V4izY8FhvGi2cd2YAGN1C5HujArnPM/FCNYE
   rgaV1uIc5e02hPZ+kdUHfhPyncvfv2BKW8EnWLouLZYBF8A/SC/D0CUpE
   YCmV2zR7g2ptAlykOkte/StYy0LGtthA8h60skD2Zv9pLLS1zToY2C/8X
   VEJZeYYb/795mDjN0AjmZmXLZnJRGbNF5E/wlgnUJ1V74t2zc52ImPKRh
   hpPUggumOqMQwuZHAKSSMcVmMjbx5PZlr/tbEAToO5m1tRonoLXprr9pr
   g==;
X-CSE-ConnectionGUID: P9umlYRKQjSKrUzrCzyoaA==
X-CSE-MsgGUID: PQSZdR45QQCG3SXq8PASuA==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="32554408"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="32554408"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 06:07:47 -0700
X-CSE-ConnectionGUID: EurQ97mfQpOCTdZ5jqY0wQ==
X-CSE-MsgGUID: Tx/YkCOgR+6rZJpS2rwQDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26609878"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by orviesa007.jf.intel.com with ESMTP; 29 Apr 2024 06:07:46 -0700
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Subject: [PATCH 2/8] mdadm: use struct context in reshape_super()
Date: Mon, 29 Apr 2024 15:07:14 +0200
Message-Id: <20240429130720.260452-3-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429130720.260452-1-mateusz.kusiak@intel.com>
References: <20240429130720.260452-1-mateusz.kusiak@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

reshape_super() takes too many arguments. Change passing params in
favor of single struct.

Add devname pointer and change direction members to struct shape
and use it for reshape_super().

Create reshape_array_size() and reshape_array_non_size() to handle
reshape_super() calls.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Grow.c        | 93 +++++++++++++++++++++++++++++++++++++--------------
 mdadm.h       | 18 +++++-----
 super-intel.c | 43 +++++++++++++++---------
 3 files changed, 105 insertions(+), 49 deletions(-)

diff --git a/Grow.c b/Grow.c
index f477b438e810..87ed9214ef02 100644
--- a/Grow.c
+++ b/Grow.c
@@ -862,9 +862,7 @@ static void wait_reshape(struct mdinfo *sra)
 	close(fd);
 }
 
-static int reshape_super(struct supertype *st, unsigned long long size,
-			 int level, int layout, int chunksize, int raid_disks,
-			 int delta_disks, char *dev, int direction, struct context *c)
+static int reshape_super(struct supertype *st, struct shape *shape, struct context *c)
 {
 	/* nothing extra to check in the native case */
 	if (!st->ss->external)
@@ -875,8 +873,65 @@ static int reshape_super(struct supertype *st, unsigned long long size,
 		return 1;
 	}
 
-	return st->ss->reshape_super(st, size, level, layout, chunksize, raid_disks,
-				     delta_disks, dev, direction, c);
+	return st->ss->reshape_super(st, shape, c);
+}
+
+/**
+ * reshape_super_size() - Reshape array, size only.
+ *
+ * @st: supertype.
+ * @devname: device name.
+ * @size: component size.
+ * @dir metadata changes direction
+ * Returns: 0 on success, 1 otherwise.
+ *
+ * This function is solely used to change size of the volume.
+ * Setting size is not valid for container.
+ * Size is only change that can be rolled back, thus the @dir param.
+ */
+static int reshape_super_size(struct supertype *st, char *devname,
+			      unsigned long long size, change_dir_t direction,
+			      struct context *c)
+{
+	struct shape shape = {0};
+
+	shape.level = UnSet;
+	shape.layout = UnSet;
+	shape.delta_disks = UnSet;
+	shape.dev = devname;
+	shape.size = size;
+	shape.direction = direction;
+
+	return reshape_super(st, &shape, c);
+}
+
+/**
+ * reshape_super_non_size() - Reshape array, non size changes.
+ *
+ * @st: supertype.
+ * @devname: device name.
+ * @info: superblock info.
+ * Returns: 0 on success, 1 otherwise.
+ *
+ * This function is used for any external array changes but size.
+ * It handles both volumes and containers.
+ * For changes other than size, rollback is not possible.
+ */
+static int reshape_super_non_size(struct supertype *st, char *devname,
+				  struct mdinfo *info, struct context *c)
+{
+	struct shape shape = {0};
+	/* Size already set to zero, not updating size */
+	shape.level = info->new_level;
+	shape.layout = info->new_layout;
+	shape.chunk = info->new_chunk;
+	shape.raiddisks = info->array.raid_disks;
+	shape.delta_disks = info->delta_disks;
+	shape.dev = devname;
+	/* Rollback not possible for non size changes */
+	shape.direction = APPLY_METADATA_CHANGES;
+
+	return reshape_super(st, &shape, c);
 }
 
 static void sync_metadata(struct supertype *st)
@@ -1979,9 +2034,8 @@ int Grow_reshape(char *devname, int fd,
 	}
 
 	/* ========= set size =============== */
-	if (s->size > 0 &&
-	    (s->size == MAX_SIZE || s->size != (unsigned)array.size)) {
-		unsigned long long orig_size = get_component_size(fd)/2;
+	if (s->size > 0 && (s->size == MAX_SIZE || s->size != (unsigned)array.size)) {
+		unsigned long long orig_size = get_component_size(fd) / 2;
 		unsigned long long min_csize;
 		struct mdinfo *mdi;
 		int raid0_takeover = 0;
@@ -2001,8 +2055,7 @@ int Grow_reshape(char *devname, int fd,
 			goto release;
 		}
 
-		if (reshape_super(st, s->size, UnSet, UnSet, 0, 0, UnSet,
-				  devname, APPLY_METADATA_CHANGES, c)) {
+		if (reshape_super_size(st, devname, s->size, APPLY_METADATA_CHANGES, c)) {
 			rv = 1;
 			goto release;
 		}
@@ -2120,8 +2173,8 @@ size_change_error:
 			int err = errno;
 
 			/* restore metadata */
-			if (reshape_super(st, orig_size, UnSet, UnSet, 0, 0, UnSet,
-			                  devname, ROLLBACK_METADATA_CHANGES, c) == 0)
+			if (reshape_super_size(st, devname, orig_size,
+					       ROLLBACK_METADATA_CHANGES, c) == 0)
 				sync_metadata(st);
 			pr_err("Cannot set device size for %s: %s\n",
 				devname, strerror(err));
@@ -2351,11 +2404,7 @@ size_change_error:
 		/* Impose these changes on a single array.  First
 		 * check that the metadata is OK with the change.
 		 */
-
-		if (reshape_super(st, 0, info.new_level,
-				  info.new_layout, info.new_chunk,
-				  info.array.raid_disks, info.delta_disks,
-				  devname, APPLY_METADATA_CHANGES, c)) {
+		if (reshape_super_non_size(st, devname, &info, c)) {
 			rv = 1;
 			goto release;
 		}
@@ -3668,14 +3717,8 @@ int reshape_container(char *container, char *devname,
 	int rv = restart;
 	char last_devnm[32] = "";
 
-	/* component_size is not meaningful for a container,
-	 * so pass '0' meaning 'no change'
-	 */
-	if (!restart &&
-	    reshape_super(st, 0, info->new_level,
-			  info->new_layout, info->new_chunk,
-			  info->array.raid_disks, info->delta_disks,
-			  devname, APPLY_METADATA_CHANGES, c)) {
+	/* component_size is not meaningful for a container */
+	if (!restart && reshape_super_non_size(st, devname, info, c)) {
 		unfreeze(st);
 		return 1;
 	}
diff --git a/mdadm.h b/mdadm.h
index 0ade4bebc400..2ff3e46383cd 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -594,6 +594,11 @@ enum flag_mode {
 	FlagDefault, FlagSet, FlagClear,
 };
 
+typedef enum {
+	ROLLBACK_METADATA_CHANGES,
+	APPLY_METADATA_CHANGES
+} change_dir_t;
+
 /* structures read from config file */
 /* List of mddevice names and identifiers
  * Identifiers can be:
@@ -667,7 +672,9 @@ struct context {
 };
 
 struct shape {
+	char	*dev;
 	int	raiddisks;
+	int	delta_disks;
 	int	sparedisks;
 	int	journaldisks;
 	int	level;
@@ -682,6 +689,7 @@ struct shape {
 	unsigned long long size;
 	unsigned long long data_offset;
 	int	consistency_policy;
+	change_dir_t direction;
 };
 
 /* List of device names - wildcards expanded */
@@ -1229,14 +1237,8 @@ extern struct superswitch {
 	 * initialized to indicate if reshape is being performed at the
 	 * container or subarray level
 	 */
-#define APPLY_METADATA_CHANGES		1
-#define ROLLBACK_METADATA_CHANGES	0
-
-	int (*reshape_super)(struct supertype *st,
-			     unsigned long long size, int level,
-			     int layout, int chunksize, int raid_disks,
-			     int delta_disks, char *dev, int direction,
-			     struct context *c);
+
+	int (*reshape_super)(struct supertype *st, struct shape *shape, struct context *c);
 	int (*manage_reshape)( /* optional */
 		int afd, struct mdinfo *sra, struct reshape *reshape,
 		struct supertype *st, unsigned long blocks,
diff --git a/super-intel.c b/super-intel.c
index 417da2672504..1a8a7b125025 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -12152,26 +12152,37 @@ exit:
 	return ret_val;
 }
 
-static int imsm_reshape_super(struct supertype *st, unsigned long long size,
-			      int level, int layout, int chunksize, int raid_disks,
-			      int delta_disks, char *dev, int direction, struct context *c)
+/**
+ * shape_to_geo() - fill geo_params from shape.
+ *
+ * @shape: array details.
+ * @geo: new geometry params.
+ * Returns: 0 on success, 1 otherwise.
+ */
+static void shape_to_geo(struct shape *shape, struct geo_params *geo)
+{
+	assert(shape);
+	assert(geo);
+
+	geo->dev_name = shape->dev;
+	geo->size = shape->size;
+	geo->level = shape->level;
+	geo->layout = shape->layout;
+	geo->chunksize = shape->chunk;
+	geo->raid_disks = shape->raiddisks;
+}
+
+static int imsm_reshape_super(struct supertype *st, struct shape *shape, struct context *c)
 {
 	int ret_val = 1;
-	struct geo_params geo;
+	struct geo_params geo = {0};
 
 	dprintf("(enter)\n");
 
-	memset(&geo, 0, sizeof(struct geo_params));
-
-	geo.dev_name = dev;
+	shape_to_geo(shape, &geo);
 	strcpy(geo.devnm, st->devnm);
-	geo.size = size;
-	geo.level = level;
-	geo.layout = layout;
-	geo.chunksize = chunksize;
-	geo.raid_disks = raid_disks;
-	if (delta_disks != UnSet)
-		geo.raid_disks += delta_disks;
+	if (shape->delta_disks != UnSet)
+		geo.raid_disks += shape->delta_disks;
 
 	dprintf("for level      : %i\n", geo.level);
 	dprintf("for raid_disks : %i\n", geo.raid_disks);
@@ -12182,7 +12193,7 @@ static int imsm_reshape_super(struct supertype *st, unsigned long long size,
 		int old_raid_disks = 0;
 
 		if (imsm_reshape_is_allowed_on_container(
-			    st, &geo, &old_raid_disks, direction)) {
+			    st, &geo, &old_raid_disks, shape->direction)) {
 			struct imsm_update_reshape *u = NULL;
 			int len;
 
@@ -12236,7 +12247,7 @@ static int imsm_reshape_super(struct supertype *st, unsigned long long size,
 			goto exit_imsm_reshape_super;
 		}
 		super->current_vol = dev->index;
-		change = imsm_analyze_change(st, &geo, direction);
+		change = imsm_analyze_change(st, &geo, shape->direction);
 		switch (change) {
 		case CH_TAKEOVER:
 			ret_val = imsm_takeover(st, &geo);
-- 
2.39.2

