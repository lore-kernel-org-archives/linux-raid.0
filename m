Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED167D084
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 11:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207553; cv=none; b=pOA2FaugwgYJgpQD9BB1m9Wu8yUVqkv0EXmA3UlnDHOhl+sEBaIxRyWJ1MuokHgf/ce8A5CJ0sgaxDHMEDTu1e1zLG0JJhqJ7DMrnVY6YoSqGzGigZmAcprmYZXPL6cFMv/UtR0Jycs7o77JmVbi7WTq/SRZfCpQI02fvrhkofQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207553; c=relaxed/simple;
	bh=o90lRPc1Bc0v45HYNlYL2Q12PfMcSaYDnJx9mEawj6Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mke8L1O54XpiSZb1mljFptOxQOvOkHuTI5K4DstgttYU95Cr/Dq6gXI/nk4018czz8O8ZybPdvgfa+xNu62hKiEAIoaa+yy+wFMRTIImCiMlimOq7u4i2U9FJpg1EedfWO4pqhBsUSC2OlS7VXe2qaWHsWWB+8JStqecJwa7Xvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XrF31zeX; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XrF31zeX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709207552; x=1740743552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o90lRPc1Bc0v45HYNlYL2Q12PfMcSaYDnJx9mEawj6Y=;
  b=XrF31zeXCRFniDCuS72jyGbLEZHcU/q0pZCj+31hwJlP0jrz/kCS/GPK
   pH0xUeet1+ir4MYxJGtpBrfFp9whaHsMWp9VGvlzRV7WdkqDMcTBfcQyz
   2kqbiea6faxkiozBwUo+5sT8LxrUdGm0laMAyGYAu/z1IkRFOERp2QVk2
   eroGwSk93YJ8vd0XOo026jcUTvZPnk5zwfJG521tuhvEE5z5uRe4daI+/
   hVV8J5UNzAjcPXuaIDLf+OZhgJnuSGjx/Jcb5CmBSAs0LY0EI+lYek0ZZ
   2oEG0dBeIrHNpqeceSasf98CjT8NeEemaK0OTtGmG8zlUvYAw7uLrBMqk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7499438"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7499438"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7754798"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:31 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 02/13] mdadm: drop get_required_spare_criteria()
Date: Thu, 29 Feb 2024 12:52:06 +0100
Message-Id: <20240229115217.26543-3-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
References: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only IMSM implements get_spare_criteria, so load_super() in
get_required_spare_criteria() is dead code. It is moved inside
metadata handler, because only IMSM implements it.

Give possibility to provide devnode to be opened. With that we can hide
load_container() used only to fill spare criteria inside handler
and simplify implementation in generic code.

Add helper function for testing spare criteria in Incremental and
error messages.

File descriptor in get_spare_criteria_imsm() is always opened on purpose.
New functionality added in next patches will require it. For the same
reason, function is moved to other place.

No functional changes.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Incremental.c |  77 ++++++++++++++++++++++----------
 Monitor.c     |  35 +++------------
 mdadm.h       |   5 +--
 super-intel.c | 120 +++++++++++++++++++++++++++++++++-----------------
 4 files changed, 140 insertions(+), 97 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 2b5a5859ced7..66c2cc86dc5a 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -833,6 +833,53 @@ container_members_max_degradation(struct map_ent *map, struct map_ent *me)
 	return max_degraded;
 }
 
+/**
+ * incremental_external_test_spare_criteria() - helper to test spare criteria.
+ * @st: supertype, must be not NULL, it is duplicated here.
+ * @container_devnm: devnm of the container.
+ * @disk_fd: file descriptor of device to tested.
+ * @verbose: verbose flag.
+ *
+ * The function is used on new drive verification path to check if it can be added to external
+ * container. To test spare criteria, metadata must be loaded. It duplicates super to not mess in
+ * original one.
+ * Function is executed if superblock supports get_spare_criteria(), otherwise success is returned.
+ */
+mdadm_status_t incremental_external_test_spare_criteria(struct supertype *st, char *container_devnm,
+							int disk_fd, int verbose)
+{
+	mdadm_status_t rv = MDADM_STATUS_ERROR;
+	char container_devname[PATH_MAX];
+	struct spare_criteria sc = {0};
+	struct supertype *dup;
+
+	if (!st->ss->get_spare_criteria)
+		return MDADM_STATUS_SUCCESS;
+
+	dup = dup_super(st);
+	snprintf(container_devname, PATH_MAX, "/dev/%s", container_devnm);
+
+	if (dup->ss->get_spare_criteria(dup, container_devname, &sc) != 0) {
+		if (verbose > 1)
+			pr_err("Failed to get spare criteria for %s\n", container_devname);
+		goto out;
+	}
+
+	if (!disk_fd_matches_criteria(disk_fd, &sc)) {
+		if (verbose > 1)
+			pr_err("Disk does not match spare criteria for %s\n", container_devname);
+		goto out;
+	}
+
+	rv = MDADM_STATUS_SUCCESS;
+
+out:
+	dup->ss->free_super(dup);
+	free(dup);
+
+	return rv;
+}
+
 static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 			   struct map_ent *target, int bare,
 			   struct supertype *st, int verbose)
@@ -873,8 +920,7 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		struct supertype *st2;
 		struct domainlist *dl = NULL;
 		struct mdinfo *sra;
-		unsigned long long devsize, freesize = 0;
-		struct spare_criteria sc = {0};
+		unsigned long long freesize = 0;
 
 		if (is_subarray(mp->metadata))
 			continue;
@@ -925,34 +971,19 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		if (sra->array.failed_disks == -1)
 			sra->array.failed_disks = container_members_max_degradation(map, mp);
 
-		get_dev_size(dfd, NULL, &devsize);
 		if (sra->component_size == 0) {
-			/* true for containers, here we must read superblock
-			 * to obtain minimum spare size */
-			struct supertype *st3 = dup_super(st2);
-			int mdfd = open_dev(mp->devnm);
-			if (mdfd < 0) {
-				free(st3);
+			/* true for containers */
+			if (incremental_external_test_spare_criteria(st2, mp->devnm, dfd, verbose))
 				goto next;
-			}
-			if (st3->ss->load_container &&
-			    !st3->ss->load_container(st3, mdfd, mp->path)) {
-				if (st3->ss->get_spare_criteria)
-					st3->ss->get_spare_criteria(st3, &sc);
-				st3->ss->free_super(st3);
-			}
-			free(st3);
-			close(mdfd);
 		}
-		if ((sra->component_size > 0 &&
-		     st2->ss->validate_geometry(st2, sra->array.level, sra->array.layout,
+
+		if (sra->component_size > 0 &&
+		    st2->ss->validate_geometry(st2, sra->array.level, sra->array.layout,
 						sra->array.raid_disks, &sra->array.chunk_size,
 						sra->component_size,
 						sra->devs ? sra->devs->data_offset : INVALID_SECTORS,
 						devname, &freesize, sra->consistency_policy,
-						0) &&
-		     freesize < sra->component_size) ||
-		    (sra->component_size == 0 && devsize < sc.min_size)) {
+						0) && freesize < sra->component_size) {
 			if (verbose > 1)
 				pr_err("not adding %s to %s as it is too small\n",
 					devname, mp->path);
diff --git a/Monitor.c b/Monitor.c
index 6917ae6c8e6d..2167523ca3e2 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -1003,34 +1003,6 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist)
 	return new_found;
 }
 
-static int get_required_spare_criteria(struct state *st,
-				       struct spare_criteria *sc)
-{
-	int fd;
-
-	if (!st->metadata || !st->metadata->ss->get_spare_criteria) {
-		sc->min_size = 0;
-		sc->sector_size = 0;
-		return 0;
-	}
-
-	fd = open(st->devname, O_RDONLY);
-	if (fd < 0)
-		return 1;
-	if (st->metadata->ss->external)
-		st->metadata->ss->load_container(st->metadata, fd, st->devname);
-	else
-		st->metadata->ss->load_super(st->metadata, fd, st->devname);
-	close(fd);
-	if (!st->metadata->sb)
-		return 1;
-
-	st->metadata->ss->get_spare_criteria(st->metadata, sc);
-	st->metadata->ss->free_super(st->metadata);
-
-	return 0;
-}
-
 static int check_donor(struct state *from, struct state *to)
 {
 	struct state *sub;
@@ -1173,8 +1145,11 @@ static void try_spare_migration(struct state *statelist)
 				/* member of a container */
 				to = to->parent;
 
-			if (get_required_spare_criteria(to, &sc))
-				continue;
+			if (to->metadata->ss->get_spare_criteria)
+				if (to->metadata->ss->get_spare_criteria(to->metadata, to->devname,
+									 &sc))
+					continue;
+
 			if (to->metadata->ss->external) {
 				/* We must make sure there is
 				 * no suitable spare in container already.
diff --git a/mdadm.h b/mdadm.h
index e8abd7309412..cbc586f5e3ef 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1116,10 +1116,9 @@ extern struct superswitch {
 	 * Return spare criteria for array:
 	 * - minimum disk size can be used in array;
 	 * - sector size can be used in array.
-	 * Return values: 0 - for success and -EINVAL on error.
 	 */
-	int (*get_spare_criteria)(struct supertype *st,
-				  struct spare_criteria *sc);
+	mdadm_status_t (*get_spare_criteria)(struct supertype *st, char *mddev_path,
+					     struct spare_criteria *sc);
 	/* Find somewhere to put a bitmap - possibly auto-size it - and
 	 * update the metadata to record this.  The array may be newly
 	 * created, in which case data_size may be updated, or it might
diff --git a/super-intel.c b/super-intel.c
index e22a4bd7de6b..90928dce722e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1736,46 +1736,6 @@ static __u32 imsm_min_reserved_sectors(struct intel_super *super)
 	return  (remainder < rv) ? remainder : rv;
 }
 
-/*
- * Return minimum size of a spare and sector size
- * that can be used in this array
- */
-int get_spare_criteria_imsm(struct supertype *st, struct spare_criteria *c)
-{
-	struct intel_super *super = st->sb;
-	struct dl *dl;
-	struct extent *e;
-	int i;
-	unsigned long long size = 0;
-
-	if (!super)
-		return -EINVAL;
-	/* find first active disk in array */
-	dl = super->disks;
-	while (dl && (is_failed(&dl->disk) || dl->index == -1))
-		dl = dl->next;
-	if (!dl)
-		return -EINVAL;
-	/* find last lba used by subarrays */
-	e = get_extents(super, dl, 0);
-	if (!e)
-		return -EINVAL;
-	for (i = 0; e[i].size; i++)
-		continue;
-	if (i > 0)
-		size = e[i-1].start + e[i-1].size;
-	free(e);
-
-	/* add the amount of space needed for metadata */
-	size += imsm_min_reserved_sectors(super);
-
-	c->min_size = size * 512;
-	c->sector_size = super->sector_size;
-	c->criteria_set = true;
-
-	return 0;
-}
-
 static bool is_gen_migration(struct imsm_dev *dev);
 
 #define IMSM_4K_DIV 8
@@ -11295,6 +11255,84 @@ static const char *imsm_get_disk_controller_domain(const char *path)
 	return drv;
 }
 
+/**
+ * get_spare_criteria_imsm() - set spare criteria.
+ * @st: supertype.
+ * @mddev_path: path to md device devnode, it must be container.
+ * @c: spare_criteria struct to fill, not NULL.
+ *
+ * If superblock is not loaded, use mddev_path to load_container. It must be given in this case.
+ * Filles size and sector size accordingly to superblock.
+ */
+mdadm_status_t get_spare_criteria_imsm(struct supertype *st, char *mddev_path,
+				       struct spare_criteria *c)
+{
+	mdadm_status_t ret = MDADM_STATUS_ERROR;
+	bool free_superblock = false;
+	unsigned long long size = 0;
+	struct intel_super *super;
+	struct extent *e;
+	struct dl *dl;
+	int i;
+
+	/* If no superblock and no mddev_path, we cannot load superblock. */
+	assert(st->sb || mddev_path);
+
+	if (mddev_path) {
+		int fd = open(mddev_path, O_RDONLY);
+
+		if (!is_fd_valid(fd))
+			return MDADM_STATUS_ERROR;
+
+		if (!st->sb) {
+			if (load_container_imsm(st, fd, st->devnm)) {
+				close(fd);
+				return MDADM_STATUS_ERROR;
+			}
+			free_superblock = true;
+		}
+		close(fd);
+	}
+
+	super = st->sb;
+
+	/* find first active disk in array */
+	dl = super->disks;
+	while (dl && (is_failed(&dl->disk) || dl->index == -1))
+		dl = dl->next;
+
+	if (!dl)
+		goto out;
+
+	/* find last lba used by subarrays */
+	e = get_extents(super, dl, 0);
+	if (!e)
+		goto out;
+
+	for (i = 0; e[i].size; i++)
+		continue;
+	if (i > 0)
+		size = e[i - 1].start + e[i - 1].size;
+	free(e);
+
+	/* add the amount of space needed for metadata */
+	size += imsm_min_reserved_sectors(super);
+
+	c->min_size = size * 512;
+	c->sector_size = super->sector_size;
+	c->criteria_set = true;
+	ret = MDADM_STATUS_SUCCESS;
+
+out:
+	if (free_superblock)
+		free_super_imsm(st);
+
+	if (ret != MDADM_STATUS_SUCCESS)
+		c->criteria_set = false;
+
+	return ret;
+}
+
 static char *imsm_find_array_devnm_by_subdev(int subdev, char *container)
 {
 	static char devnm[32];
@@ -11425,7 +11463,7 @@ static struct mdinfo *get_spares_for_grow(struct supertype *st)
 {
 	struct spare_criteria sc;
 
-	get_spare_criteria_imsm(st, &sc);
+	get_spare_criteria_imsm(st, NULL, &sc);
 	return container_choose_spares(st, &sc, NULL, NULL, NULL, 0);
 }
 
-- 
2.35.3

