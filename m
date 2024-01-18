Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF221208A6
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 10:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705573788; cv=none; b=KyiQtn3hZpMae2llv8eHzEmq5Q7CSdlcwr7AoxXtfgm326n+6BJnT2TGumb/BxdvJBUj9JYUh/cVgn0E17LiHytfvewrwS4f8yTwFTl9rzyrS1MTu5lKOGGuVhr7NWH/9Ov6HbPV3ARirS9HYasAXX8YhzexSzMU7xlfrF/HMrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705573788; c=relaxed/simple;
	bh=QfU9zSmv29s76Ygc5bsqVYUdV8YDQv+8p84GNySDFb0=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding; b=OI80R6+orFceV6aB/+4e17U6votFn3xF85k7nuWiqjoUWjgrKVbOyjxkns6sn2hET4Ee00/Ds8u6jC+zNxP9Ch4WTfjsFh3C1Vljs8IHr4oepMC4YrjCmDqRS8/n4XmevOAuJixuqetNj167ofIvnD6XhBGYTFD6pYIVexgxzQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dv7Xs5u/; arc=none smtp.client-ip=192.55.52.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dv7Xs5u/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705573785; x=1737109785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QfU9zSmv29s76Ygc5bsqVYUdV8YDQv+8p84GNySDFb0=;
  b=Dv7Xs5u/n6K1KQowjMg/VkJDcuUk1DH3POHQM4HHz9sCqjA92v8Iibdj
   TYi4nukFdbR/04gZBIIMUVVNG2JmD1FQkXLOKL+FgADDqpWEch7hPmsx+
   5Fsuvj395iswlGlP24DB88SV1Bepf37WHeE0upFqSoRpmpqE/+ZLLcc5M
   PnOhKHFdF+VxKUApHxwsPyDH+FwG9RzwR4uvkU1FlmCYyH2HqnUsiNwfm
   kOjaWBamtJbKkADFx7EbMZg6um4QNhG9XF8ISnUKgdxHX24DzHorp0PfX
   HC6536kguD8+wb9+TUWoM8XIbcLBr3cqbTa6qt8BWOL21ROSiPu+N6Xyd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="486563795"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="486563795"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 02:29:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="26735683"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa001.fm.intel.com with ESMTP; 18 Jan 2024 02:29:44 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH v2 2/3] Replace "none" with macro
Date: Thu, 18 Jan 2024 11:28:41 +0100
Message-Id: <20240118102842.12304-3-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240118102842.12304-1-mateusz.kusiak@intel.com>
References: <20240118102842.12304-1-mateusz.kusiak@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

String "none" is used many times throughout the code.
Replace "none" strings with predefined macro.

Add str_is_none() for comparing strings with "none".
Replace str(n)cmp calls with function.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Assemble.c    |  3 +--
 Build.c       |  4 ++--
 Create.c      |  2 +-
 Grow.c        | 15 +++++++--------
 Incremental.c |  2 +-
 Manage.c      |  2 +-
 config.c      |  2 +-
 maps.c        |  4 ++--
 mdadm.c       |  7 +++----
 mdadm.h       | 16 ++++++++++++++++
 monitor.c     |  4 ++--
 super-intel.c |  4 ++--
 sysfs.c       |  4 ++--
 util.c        |  2 +-
 14 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 0879c2ed5473..9d042055ad4e 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -2015,8 +2015,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		if (dev)
 			continue;
 		/* Don't want this one any more */
-		if (sysfs_set_str(sra, dev2, "slot", "none") < 0 &&
-		    errno == EBUSY) {
+		if (sysfs_set_str(sra, dev2, "slot", STR_COMMON_NONE) < 0 && errno == EBUSY) {
 			pr_err("Cannot remove old device %s: not updating %s\n", dev2->sys_name, sra->sys_name);
 			sysfs_free(sra);
 			return 1;
diff --git a/Build.c b/Build.c
index 657ab315de62..1fbf8596a9dd 100644
--- a/Build.c
+++ b/Build.c
@@ -82,7 +82,7 @@ int Build(struct mddev_ident *ident, struct mddev_dev *devlist, struct shape *s,
 		return 1;
 	}
 
-	map_update(&map, fd2devnm(mdfd), "none", uuid, chosen_name);
+	map_update(&map, fd2devnm(mdfd), STR_COMMON_NONE, uuid, chosen_name);
 	map_unlock(&map);
 
 	array.level = s->level;
@@ -111,7 +111,7 @@ int Build(struct mddev_ident *ident, struct mddev_dev *devlist, struct shape *s,
 		goto abort;
 	}
 
-	if (s->bitmap_file && strcmp(s->bitmap_file, "none") == 0)
+	if (s->bitmap_file && str_is_none(s->bitmap_file) == true)
 		s->bitmap_file = NULL;
 	if (s->bitmap_file && s->level <= 0) {
 		pr_err("bitmaps not meaningful with level %s\n",
diff --git a/Create.c b/Create.c
index ddd1a79bf393..8082f54a8fdc 100644
--- a/Create.c
+++ b/Create.c
@@ -938,7 +938,7 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 			pr_err("automatically enabling write-intent bitmap on large array\n");
 		s->bitmap_file = "internal";
 	}
-	if (s->bitmap_file && strcmp(s->bitmap_file, "none") == 0)
+	if (s->bitmap_file && str_is_none(s->bitmap_file) == true)
 		s->bitmap_file = NULL;
 
 	if (s->consistency_policy == CONSISTENCY_POLICY_PPL &&
diff --git a/Grow.c b/Grow.c
index 8ca8ee781d1b..f95dae82ef0d 100644
--- a/Grow.c
+++ b/Grow.c
@@ -309,7 +309,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 		return 1;
 	}
 	if (bmf.pathname[0]) {
-		if (strcmp(s->bitmap_file,"none") == 0) {
+		if (str_is_none(s->bitmap_file) == true) {
 			if (ioctl(fd, SET_BITMAP_FILE, -1) != 0) {
 				pr_err("failed to remove bitmap %s\n",
 					bmf.pathname);
@@ -325,7 +325,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 		return 1;
 	}
 	if (array.state & (1 << MD_SB_BITMAP_PRESENT)) {
-		if (strcmp(s->bitmap_file, "none")==0) {
+		if (str_is_none(s->bitmap_file) == true) {
 			array.state &= ~(1 << MD_SB_BITMAP_PRESENT);
 			if (md_set_array_info(fd, &array) != 0) {
 				if (array.state & (1 << MD_SB_CLUSTERED))
@@ -340,7 +340,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 		return 1;
 	}
 
-	if (strcmp(s->bitmap_file, "none") == 0) {
+	if (str_is_none(s->bitmap_file) == true) {
 		pr_err("no bitmap found on %s\n", devname);
 		return 1;
 	}
@@ -1067,7 +1067,7 @@ int remove_disks_for_takeover(struct supertype *st,
 		remaining = sd->next;
 
 		sysfs_set_str(sra, sd, "state", "faulty");
-		sysfs_set_str(sra, sd, "slot", "none");
+		sysfs_set_str(sra, sd, "slot", STR_COMMON_NONE);
 		/* for external metadata disks should be removed in mdmon */
 		if (!st->ss->external)
 			sysfs_set_str(sra, sd, "state", "remove");
@@ -2145,8 +2145,7 @@ size_change_error:
 			 * a backport has been arranged.
 			 */
 			if (sra == NULL ||
-			    sysfs_set_str(sra, NULL, "resync_start",
-					  "none") < 0)
+			    sysfs_set_str(sra, NULL, "resync_start", STR_COMMON_NONE) < 0)
 				pr_err("--assume-clean not supported with --grow on this kernel\n");
 		}
 		md_get_array_info(fd, &array);
@@ -4159,8 +4158,8 @@ check_progress:
 	 * it was just a device failure that leaves us degraded but
 	 * functioning.
 	 */
-	if (sysfs_get_str(info, NULL, "reshape_position", buf,
-			  sizeof(buf)) < 0 || strncmp(buf, "none", 4) != 0) {
+	if (sysfs_get_str(info, NULL, "reshape_position", buf, sizeof(buf)) < 0 ||
+	    str_is_none(buf) == false) {
 		/* The abort might only be temporary.  Wait up to 10
 		 * seconds for fd to contain a valid number again.
 		 */
diff --git a/Incremental.c b/Incremental.c
index 52e396237e64..6cbc164a27b9 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -670,7 +670,7 @@ static void find_reject(int mdfd, struct supertype *st, struct mdinfo *sra,
 			continue;
 
 		if (d->disk.raid_disk > -1)
-			sysfs_set_str(sra, d, "slot", "none");
+			sysfs_set_str(sra, d, "slot", STR_COMMON_NONE);
 		if (sysfs_set_str(sra, d, "state", "remove") == 0)
 			if (verbose >= 0)
 				pr_err("removing old device %s from %s\n",
diff --git a/Manage.c b/Manage.c
index d66dc7b8af91..30302ac833f2 100644
--- a/Manage.c
+++ b/Manage.c
@@ -402,7 +402,7 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 			unsigned long long max_completed;
 			sysfs_get_ll(mdi, NULL, "reshape_position", &curr);
 			sysfs_fd_get_str(scfd, buf, sizeof(buf));
-			if (strncmp(buf, "none", 4) == 0) {
+			if (str_is_none(buf) == true) {
 				/* Either reshape has aborted, or hasn't
 				 * quite started yet.  Wait a bit and
 				 * check  'sync_action' to see.
diff --git a/config.c b/config.c
index 5f12a1f8641c..9a04cae85f52 100644
--- a/config.c
+++ b/config.c
@@ -998,7 +998,7 @@ void load_conffile(void)
 		dl_add(list, dl_strdup("partitions"));
 		devline(list);
 		free_line(list);
-	} else if (strcmp(conffile, "none") != 0) {
+	} else if (str_is_none(conffile) == false) {
 		f = fopen(conffile, "r");
 		/* Debian chose to relocate mdadm.conf into /etc/mdadm/.
 		 * To allow Debian users to compile from clean source and still
diff --git a/maps.c b/maps.c
index b586679acc74..17f8b54dc40f 100644
--- a/maps.c
+++ b/maps.c
@@ -137,14 +137,14 @@ mapping_t faultylayout[] = {
 
 	{ "clear", ClearErrors},
 	{ "flush", ClearFaults},
-	{ "none", ClearErrors},
+	{ STR_COMMON_NONE, ClearErrors},
 	{ "default", ClearErrors},
 	{ NULL, UnSet }
 };
 
 mapping_t consistency_policies[] = {
 	{ "unknown", CONSISTENCY_POLICY_UNKNOWN},
-	{ "none", CONSISTENCY_POLICY_NONE},
+	{ STR_COMMON_NONE, CONSISTENCY_POLICY_NONE},
 	{ "resync", CONSISTENCY_POLICY_RESYNC},
 	{ "bitmap", CONSISTENCY_POLICY_BITMAP},
 	{ "journal", CONSISTENCY_POLICY_JOURNAL},
diff --git a/mdadm.c b/mdadm.c
index 62f981dfbd15..3f1912884d49 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1099,7 +1099,7 @@ int main(int argc, char *argv[])
 				exit(2);
 			}
 			if (strcmp(optarg, "internal") == 0 ||
-			    strcmp(optarg, "none") == 0 ||
+			    strcmp(optarg, STR_COMMON_NONE) == 0 ||
 			    strchr(optarg, '/') != NULL) {
 				s.bitmap_file = optarg;
 				continue;
@@ -1234,13 +1234,12 @@ int main(int argc, char *argv[])
 			pr_err("PPL consistency policy is only supported for RAID level 5.\n");
 			exit(2);
 		} else if (s.consistency_policy == CONSISTENCY_POLICY_BITMAP &&
-			   (!s.bitmap_file ||
-			    strcmp(s.bitmap_file, "none") == 0)) {
+			  (!s.bitmap_file || str_is_none(s.bitmap_file) == true)) {
 			pr_err("--bitmap is required for consistency policy: %s\n",
 			       map_num_s(consistency_policies, s.consistency_policy));
 			exit(2);
 		} else if (s.bitmap_file &&
-			   strcmp(s.bitmap_file, "none") != 0 &&
+			   str_is_none(s.bitmap_file) == false &&
 			   s.consistency_policy != CONSISTENCY_POLICY_BITMAP &&
 			   s.consistency_policy != CONSISTENCY_POLICY_JOURNAL) {
 			pr_err("--bitmap is not compatible with consistency policy: %s\n",
diff --git a/mdadm.h b/mdadm.h
index 46692730801e..709b6104c401 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -2027,3 +2027,19 @@ static inline int is_container(const int level)
 		return 1;
 	return 0;
 }
+
+#define STR_COMMON_NONE "none"
+
+/**
+ * str_is_none() - check if @str starts with "none".
+ * @str: string
+ *
+ * return:
+ * true if string starts with "none", false otherwise.
+ */
+static inline bool str_is_none(char *str)
+{
+	if (strncmp(str, STR_COMMON_NONE, sizeof(STR_COMMON_NONE) - 1) == 0)
+		return true;
+	return false;
+}
diff --git a/monitor.c b/monitor.c
index f54d07b24f59..4acec6783e6e 100644
--- a/monitor.c
+++ b/monitor.c
@@ -89,7 +89,7 @@ static void read_resync_start(int fd, unsigned long long *v)
 		dprintf("Failed to read resync_start (%d)\n", fd);
 		return;
 	}
-	if (strncmp(buf, "none", 4) == 0)
+	if (str_is_none(buf) == true)
 		*v = MaxSector;
 	else
 		*v = strtoull(buf, NULL, 10);
@@ -600,7 +600,7 @@ static int read_and_act(struct active_array *a, fd_set *fds)
 					  "reshape_position",
 					  buf,
 					  sizeof(buf)) >= 0) &&
-			     strncmp(buf, "none", 4) == 0)
+			     str_is_none(buf) == true)
 				a->last_checkpoint = a->info.component_size;
 		}
 		a->container->ss->set_array_state(a, a->curr_state <= clean);
diff --git a/super-intel.c b/super-intel.c
index c3e832686578..01fcc6b3bfb6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1825,7 +1825,7 @@ static void print_imsm_dev(struct intel_super *super,
 	printf("\n");
 	printf("    Failed disk : ");
 	if (map->failed_disk_num == 0xff)
-		printf("none");
+		printf(STR_COMMON_NONE);
 	else
 		printf("%i", map->failed_disk_num);
 	printf("\n");
@@ -12086,7 +12086,7 @@ static int read_completed(int fd, unsigned long long *val)
 		return ret;
 
 	ret = COMPLETED_OK;
-	if (strncmp(buf, "none", 4) == 0) {
+	if (str_is_none(buf) == true) {
 		ret = COMPLETED_NONE;
 	} else if (strncmp(buf, "delayed", 7) == 0) {
 		ret = COMPLETED_DELAYED;
diff --git a/sysfs.c b/sysfs.c
index 0dc7badfc4b7..f95ef7013e84 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -148,7 +148,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 		strcpy(base, "metadata_version");
 		if (load_sys(fname, buf, sizeof(buf)))
 			goto abort;
-		if (strncmp(buf, "none", 4) == 0) {
+		if (str_is_none(buf) == true) {
 			sra->array.major_version =
 				sra->array.minor_version = -1;
 			strcpy(sra->text_version, "");
@@ -244,7 +244,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 			goto abort;
 		if (strncmp(buf, "file", 4) == 0)
 			sra->bitmap_offset = 1;
-		else if (strncmp(buf, "none", 4) == 0)
+		else if (str_is_none(buf) == true)
 			sra->bitmap_offset = 0;
 		else if (buf[0] == '+')
 			sra->bitmap_offset = strtol(buf+1, NULL, 10);
diff --git a/util.c b/util.c
index fa378ebac6ef..b145447370b3 100644
--- a/util.c
+++ b/util.c
@@ -1852,7 +1852,7 @@ int remove_disk(int mdfd, struct supertype *st,
 
 	/* Remove the disk given by 'info' from the array */
 	if (st->ss->external)
-		rv = sysfs_set_str(sra, info, "slot", "none");
+		rv = sysfs_set_str(sra, info, "slot", STR_COMMON_NONE);
 	else
 		rv = ioctl(mdfd, HOT_REMOVE_DISK, makedev(info->disk.major,
 							  info->disk.minor));
-- 
2.35.3

