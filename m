Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BDD7D080
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 11:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207551; cv=none; b=KG6DEq0KdWvmtIcJej4g9uMwC5hjB+e7fC/ja9dIHQgwC8tFsT/XDaxpfJAUDGR11XJ5aSvrj3UEHwIoREWZhGBr62NGMCI0Dq3BCCJ/3VLRC0zCrAX/uHt658yLBP3glxvvvhXw+V9B/oqms8dU+MBiPfBOyFBerqK5zi3esaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207551; c=relaxed/simple;
	bh=ulCJf6ozK7ink5vm8w5nN2Exm9CKrZw1eOjp9/n4bIk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Acg6gzPdUOWUrgS0Xqe+MS7WkSTBql0OqLZkICoBSG9vxq3y+pizeu6mzDxmjXeEiamZvQLs0PvUd32b53wFSy8ueNxTLAkbDe7rHhtfsSVsiN6lRhIp4r0m7fWL6y6viXS0i/4hZ10Zsj0QiAOw9d/UllCo3R5oAu+NW03IRF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VoZ76zum; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VoZ76zum"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709207550; x=1740743550;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ulCJf6ozK7ink5vm8w5nN2Exm9CKrZw1eOjp9/n4bIk=;
  b=VoZ76zum9J6xb1hwSbJN4gLdXRQWW5uc+6W1klmfmkaplxmQkTZldPPW
   ANf62CbU+7Kaazov4SIc60u8nZtXBQguTInpUvqFLjKkUJjwk2xInyDvz
   7wqjXaHyUa1K/MWpb0wZx9XnJAmCSu1OapIsIIiE80Uzfm54uCsdzfmR1
   4jxt+IhYGfTtbZzNvw6MXQtxv8pCOxdvVUon8b8Wq9yrGTsjzglz1i+Xi
   Aqh5+KUl0o+EOnxies9B6pLJjYL+XISzh5g+0rp0UmduebSR7ESLvk/3X
   lpvXyrKgV91QuvQs2yPipTYECLFToIdF3zUmk64mqRstEWuyF3Oq30Lgw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7499434"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7499434"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7754795"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:28 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 01/13] mdadm: Add functions for spare criteria verification
Date: Thu, 29 Feb 2024 12:52:05 +0100
Message-Id: <20240229115217.26543-2-mariusz.tkaczyk@linux.intel.com>
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

It is done similar way in few places. As a result, two almost identical
functions (dev_size_from_id() and dev_sector_size_from_id()) are
removed. Now, it uses same file descriptor to send two ioctls.

Two extern functions are added, in next patches
disk_fd_matches_criteria() is used.

Next optimization is inline zeroing struct spare_criteria. With that,
we don't need to reset values in get_spare_criteria_imsm().

Dedicated boolean field for checking if criteria are filled is added.
We don't need to execute the code if it is not set.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Incremental.c |   2 +-
 Monitor.c     |  14 +------
 mdadm.h       |   6 ++-
 super-intel.c |   4 +-
 util.c        | 112 ++++++++++++++++++++++++++------------------------
 5 files changed, 67 insertions(+), 71 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 30c07c037028..2b5a5859ced7 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -874,7 +874,7 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		struct domainlist *dl = NULL;
 		struct mdinfo *sra;
 		unsigned long long devsize, freesize = 0;
-		struct spare_criteria sc = {0, 0};
+		struct spare_criteria sc = {0};
 
 		if (is_subarray(mp->metadata))
 			continue;
diff --git a/Monitor.c b/Monitor.c
index 7cee95d4487a..6917ae6c8e6d 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -1065,22 +1065,12 @@ static dev_t choose_spare(struct state *from, struct state *to,
 	for (d = from->raid; !dev && d < MAX_DISKS; d++) {
 		if (from->devid[d] > 0 && from->devstate[d] == 0) {
 			struct dev_policy *pol;
-			unsigned long long dev_size;
-			unsigned int dev_sector_size;
 
 			if (to->metadata->ss->external &&
 			    test_partition_from_id(from->devid[d]))
 				continue;
 
-			if (sc->min_size &&
-			    dev_size_from_id(from->devid[d], &dev_size) &&
-			    dev_size < sc->min_size)
-				continue;
-
-			if (sc->sector_size &&
-			    dev_sector_size_from_id(from->devid[d],
-						    &dev_sector_size) &&
-			    sc->sector_size != dev_sector_size)
+			if (devid_matches_criteria(from->devid[d], sc) == false)
 				continue;
 
 			pol = devid_policy(from->devid[d]);
@@ -1165,12 +1155,12 @@ static void try_spare_migration(struct state *statelist)
 {
 	struct state *from;
 	struct state *st;
-	struct spare_criteria sc;
 
 	link_containers_with_subarrays(statelist);
 	for (st = statelist; st; st = st->next)
 		if (st->active < st->raid && st->spare == 0 && !st->err) {
 			struct domainlist *domlist = NULL;
+			struct spare_criteria sc = {0};
 			int d;
 			struct state *to = st;
 
diff --git a/mdadm.h b/mdadm.h
index 75c887e4c64c..e8abd7309412 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -430,6 +430,7 @@ struct createinfo {
 };
 
 struct spare_criteria {
+	bool criteria_set;
 	unsigned long long min_size;
 	unsigned int sector_size;
 };
@@ -1368,8 +1369,6 @@ extern struct supertype *dup_super(struct supertype *st);
 extern int get_dev_size(int fd, char *dname, unsigned long long *sizep);
 extern int get_dev_sector_size(int fd, char *dname, unsigned int *sectsizep);
 extern int must_be_container(int fd);
-extern int dev_size_from_id(dev_t id, unsigned long long *size);
-extern int dev_sector_size_from_id(dev_t id, unsigned int *size);
 void wait_for(char *dev, int fd);
 
 /*
@@ -1708,6 +1707,9 @@ extern int assemble_container_content(struct supertype *st, int mdfd,
 #define	INCR_UNSAFE	2
 #define	INCR_ALREADY	4
 #define	INCR_YES	8
+
+extern bool devid_matches_criteria(dev_t devid, struct spare_criteria *sc);
+extern bool disk_fd_matches_criteria(int disk_fd, struct spare_criteria *sc);
 extern struct mdinfo *container_choose_spares(struct supertype *st,
 					      struct spare_criteria *criteria,
 					      struct domainlist *domlist,
diff --git a/super-intel.c b/super-intel.c
index e61f3f6ff662..e22a4bd7de6b 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1748,9 +1748,6 @@ int get_spare_criteria_imsm(struct supertype *st, struct spare_criteria *c)
 	int i;
 	unsigned long long size = 0;
 
-	c->min_size = 0;
-	c->sector_size = 0;
-
 	if (!super)
 		return -EINVAL;
 	/* find first active disk in array */
@@ -1774,6 +1771,7 @@ int get_spare_criteria_imsm(struct supertype *st, struct spare_criteria *c)
 
 	c->min_size = size * 512;
 	c->sector_size = super->sector_size;
+	c->criteria_set = true;
 
 	return 0;
 }
diff --git a/util.c b/util.c
index b145447370b3..041e78cf5426 100644
--- a/util.c
+++ b/util.c
@@ -1266,40 +1266,6 @@ struct supertype *super_by_fd(int fd, char **subarrayp)
 	return st;
 }
 
-int dev_size_from_id(dev_t id, unsigned long long *size)
-{
-	char buf[20];
-	int fd;
-
-	sprintf(buf, "%d:%d", major(id), minor(id));
-	fd = dev_open(buf, O_RDONLY);
-	if (fd < 0)
-		return 0;
-	if (get_dev_size(fd, NULL, size)) {
-		close(fd);
-		return 1;
-	}
-	close(fd);
-	return 0;
-}
-
-int dev_sector_size_from_id(dev_t id, unsigned int *size)
-{
-	char buf[20];
-	int fd;
-
-	sprintf(buf, "%d:%d", major(id), minor(id));
-	fd = dev_open(buf, O_RDONLY);
-	if (fd < 0)
-		return 0;
-	if (get_dev_sector_size(fd, NULL, size)) {
-		close(fd);
-		return 1;
-	}
-	close(fd);
-	return 0;
-}
-
 struct supertype *dup_super(struct supertype *orig)
 {
 	struct supertype *st;
@@ -2088,6 +2054,60 @@ void append_metadata_update(struct supertype *st, void *buf, int len)
 unsigned int __invalid_size_argument_for_IOC = 0;
 #endif
 
+/**
+ * disk_fd_matches_criteria() - check if device matches spare criteria.
+ * @disk_fd: file descriptor of the disk.
+ * @sc: criteria to test.
+ *
+ * Return: true if disk matches criteria, false otherwise.
+ */
+bool disk_fd_matches_criteria(int disk_fd, struct spare_criteria *sc)
+{
+	unsigned int dev_sector_size = 0;
+	unsigned long long dev_size = 0;
+
+	if (!sc->criteria_set)
+		return true;
+
+	if (!get_dev_size(disk_fd, NULL, &dev_size) || dev_size < sc->min_size)
+		return false;
+
+	if (!get_dev_sector_size(disk_fd, NULL, &dev_sector_size) ||
+	    sc->sector_size != dev_sector_size)
+		return false;
+
+	return true;
+}
+
+/**
+ * devid_matches_criteria() - check if device referenced by devid matches spare criteria.
+ * @devid: devid of the device to check.
+ * @sc: criteria to test.
+ *
+ * Return: true if disk matches criteria, false otherwise.
+ */
+bool devid_matches_criteria(dev_t devid, struct spare_criteria *sc)
+{
+	char buf[NAME_MAX];
+	bool ret;
+	int fd;
+
+	if (!sc->criteria_set)
+		return true;
+
+	snprintf(buf, NAME_MAX, "%d:%d", major(devid), minor(devid));
+
+	fd = dev_open(buf, O_RDONLY);
+	if (!is_fd_valid(fd))
+		return false;
+
+	/* Error code inherited */
+	ret = disk_fd_matches_criteria(fd, sc);
+
+	close(fd);
+	return ret;
+}
+
 /* Pick all spares matching given criteria from a container
  * if min_size == 0 do not check size
  * if domlist == NULL do not check domains
@@ -2111,28 +2131,13 @@ struct mdinfo *container_choose_spares(struct supertype *st,
 	dp = &disks->devs;
 	disks->array.spare_disks = 0;
 	while (*dp) {
-		int found = 0;
+		bool found = false;
+
 		d = *dp;
 		if (d->disk.state == 0) {
-			/* check if size is acceptable */
-			unsigned long long dev_size;
-			unsigned int dev_sector_size;
-			int size_valid = 0;
-			int sector_size_valid = 0;
-
 			dev_t dev = makedev(d->disk.major,d->disk.minor);
 
-			if (!criteria->min_size ||
-			   (dev_size_from_id(dev,  &dev_size) &&
-			    dev_size >= criteria->min_size))
-				size_valid = 1;
-
-			if (!criteria->sector_size ||
-			    (dev_sector_size_from_id(dev, &dev_sector_size) &&
-			     criteria->sector_size == dev_sector_size))
-				sector_size_valid = 1;
-
-			found = size_valid && sector_size_valid;
+			found = devid_matches_criteria(dev, criteria);
 
 			/* check if domain matches */
 			if (found && domlist) {
@@ -2141,7 +2146,8 @@ struct mdinfo *container_choose_spares(struct supertype *st,
 					pol_add(&pol, pol_domain,
 						spare_group, NULL);
 				if (domain_test(domlist, pol, metadata) != 1)
-					found = 0;
+					found = false;
+
 				dev_policy_free(pol);
 			}
 		}
-- 
2.35.3

