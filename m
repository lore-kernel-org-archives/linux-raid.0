Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B528208A6
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 10:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705573778; cv=none; b=PX093xxz0FDG/AnYhMGQJ+In2RdXmDCwpLMDGeBJGeSDBQ0P9DDuqV4B5L8WkXJ9rAZr270CQeXLcusCe+Dk+hKk2mXB0o5cSA/cLGRckrWti0UclQrtsUGOG2TfLOH+3j6eThiFL7/vGmnOJ10gDN2+CXmVTOETLpUDXaaMrXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705573778; c=relaxed/simple;
	bh=ylKlVMMig6OQ3rh6A0xfqa48sxHDjDH1JA8mhhYHRhM=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding; b=bzfHuLKSjBe3VwUmX0v2E57bxHcYk/pfUe0LfwMWXHbcM0cZfj2Np92HZfOrJX3f5ju9wpdGUdmj4x0+vYbqY9EfDs9paz/N2QtF6/VwklC+Z4PdG12HvJuNhSv76HuAJfti42RdRiJFPDvw9Mk61cDI5pvXu8OVl/Eq5CK7+bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kRggl65x; arc=none smtp.client-ip=192.55.52.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kRggl65x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705573776; x=1737109776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ylKlVMMig6OQ3rh6A0xfqa48sxHDjDH1JA8mhhYHRhM=;
  b=kRggl65x5tdS+tuICSSUO489vadjV46HNuNaKcDurYH0l4mxBg/yKF73
   v4NsQUXmnp8w9LHv5iRm19pO3fYYbnUh8o7yOzrVrHZoWXT/ItXSHo3Yv
   gAaGUVqLtD/v9ZNSdv+tXvevVFXIlFSrpEJh4ldHjRyyzu9znVP0CYz1u
   tFrMX+cmZZ+rsFk3luRvWhzALRTAxdgIH06b0eJSFZ1/QJg45laENZtfJ
   bCwfL5JKiO0t6bfcMncie2E5Z595VOuT4yBxE5r81jM4c1+vK5pYx+wLV
   U18c0On+S2mBKgkDi13PqwYTbUoZzmyyxrQFkqNFQhKOMp3BCbCyNu67E
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="486563758"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="486563758"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 02:29:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="26735660"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa001.fm.intel.com with ESMTP; 18 Jan 2024 02:29:34 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH v2 1/3] Define sysfs max buffer size
Date: Thu, 18 Jan 2024 11:28:40 +0100
Message-Id: <20240118102842.12304-2-mateusz.kusiak@intel.com>
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

sysfs_get_str() usages have inconsistant buffer size.
This results in wild buffer declarations and redundant memory usage.

Define maximum buffer size for sysfs strings.
Replace wild sysfs string buffer sizes for globaly defined value.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Grow.c        | 36 ++++++++++++++++++------------------
 Incremental.c |  2 +-
 Manage.c      |  8 ++++----
 Monitor.c     |  6 +++---
 managemon.c   |  6 +++---
 mdadm.h       |  2 ++
 monitor.c     | 20 ++++++++++----------
 msg.c         |  4 ++--
 super-intel.c | 14 +++++++-------
 sysfs.c       |  8 ++++----
 10 files changed, 54 insertions(+), 52 deletions(-)

diff --git a/Grow.c b/Grow.c
index 8fa978756a82..8ca8ee781d1b 100644
--- a/Grow.c
+++ b/Grow.c
@@ -545,7 +545,7 @@ int Grow_consistency_policy(char *devname, int fd, struct context *c, struct sha
 	char *subarray = NULL;
 	int ret = 0;
 	char container_dev[PATH_MAX];
-	char buf[20];
+	char buf[SYSFS_MAX_BUF_SIZE];
 
 	if (s->consistency_policy != CONSISTENCY_POLICY_RESYNC &&
 	    s->consistency_policy != CONSISTENCY_POLICY_PPL) {
@@ -594,7 +594,7 @@ int Grow_consistency_policy(char *devname, int fd, struct context *c, struct sha
 	}
 
 	if (s->consistency_policy == CONSISTENCY_POLICY_PPL) {
-		if (sysfs_get_str(sra, NULL, "sync_action", buf, 20) <= 0) {
+		if (sysfs_get_str(sra, NULL, "sync_action", buf, sizeof(buf)) <= 0) {
 			ret = 1;
 			goto free_info;
 		} else if (strcmp(buf, "reshape\n") == 0) {
@@ -817,12 +817,12 @@ static int freeze(struct supertype *st)
 	else {
 		struct mdinfo *sra = sysfs_read(-1, st->devnm, GET_VERSION);
 		int err;
-		char buf[20];
+		char buf[SYSFS_MAX_BUF_SIZE];
 
 		if (!sra)
 			return -1;
 		/* Need to clear any 'read-auto' status */
-		if (sysfs_get_str(sra, NULL, "array_state", buf, 20) > 0 &&
+		if (sysfs_get_str(sra, NULL, "array_state", buf, sizeof(buf)) > 0 &&
 		    strncmp(buf, "read-auto", 9) == 0)
 			sysfs_set_str(sra, NULL, "array_state", "clean");
 
@@ -838,10 +838,10 @@ static void unfreeze(struct supertype *st)
 		return unfreeze_container(st);
 	else {
 		struct mdinfo *sra = sysfs_read(-1, st->devnm, GET_VERSION);
-		char buf[20];
+		char buf[SYSFS_MAX_BUF_SIZE];
 
 		if (sra &&
-		    sysfs_get_str(sra, NULL, "sync_action", buf, 20) > 0 &&
+		    sysfs_get_str(sra, NULL, "sync_action", buf, sizeof(buf)) > 0 &&
 		    strcmp(buf, "frozen\n") == 0)
 			sysfs_set_str(sra, NULL, "sync_action", "idle");
 		sysfs_free(sra);
@@ -851,12 +851,12 @@ static void unfreeze(struct supertype *st)
 static void wait_reshape(struct mdinfo *sra)
 {
 	int fd = sysfs_get_fd(sra, NULL, "sync_action");
-	char action[20];
+	char action[SYSFS_MAX_BUF_SIZE];
 
 	if (fd < 0)
 		return;
 
-	while (sysfs_fd_get_str(fd, action, 20) > 0 &&
+	while (sysfs_fd_get_str(fd, action, sizeof(action)) > 0 &&
 	       strncmp(action, "reshape", 7) == 0)
 		sysfs_wait(fd, NULL);
 	close(fd);
@@ -902,7 +902,7 @@ static int subarray_set_num(char *container, struct mdinfo *sra, char *name, int
 	 * to close a race with the array_state going clean before the
 	 * next write to raid_disks / stripe_cache_size
 	 */
-	char safe[50];
+	char safe[SYSFS_MAX_BUF_SIZE];
 	int rc;
 
 	/* only 'raid_disks' and 'stripe_cache_size' trigger md_allow_write */
@@ -2396,11 +2396,11 @@ release:
 static int verify_reshape_position(struct mdinfo *info, int level)
 {
 	int ret_val = 0;
-	char buf[40];
+	char buf[SYSFS_MAX_BUF_SIZE];
 	int rv;
 
 	/* read sync_max, failure can mean raid0 array */
-	rv = sysfs_get_str(info, NULL, "sync_max", buf, 40);
+	rv = sysfs_get_str(info, NULL, "sync_max", buf, sizeof(buf));
 
 	if (rv > 0) {
 		char *ep;
@@ -3040,7 +3040,7 @@ static int reshape_array(char *container, int fd, char *devname,
 	unsigned long long array_size;
 	int done;
 	struct mdinfo *sra = NULL;
-	char buf[20];
+	char buf[SYSFS_MAX_BUF_SIZE];
 
 	/* when reshaping a RAID0, the component_size might be zero.
 	 * So try to fix that up.
@@ -3916,7 +3916,7 @@ int progress_reshape(struct mdinfo *info, struct reshape *reshape,
 	unsigned long long array_size = (info->component_size
 					 * reshape->before.data_disks);
 	int fd;
-	char buf[20];
+	char buf[SYSFS_MAX_BUF_SIZE];
 
 	/* First, we unsuspend any region that is now known to be safe.
 	 * If suspend_point is on the 'wrong' side of reshape_progress, then
@@ -4094,8 +4094,8 @@ int progress_reshape(struct mdinfo *info, struct reshape *reshape,
 		/* Check that sync_action is still 'reshape' to avoid
 		 * waiting forever on a dead array
 		 */
-		char action[20];
-		if (sysfs_get_str(info, NULL, "sync_action", action, 20) <= 0 ||
+		char action[SYSFS_MAX_BUF_SIZE];
+		if (sysfs_get_str(info, NULL, "sync_action", action, sizeof(action)) <= 0 ||
 		    strncmp(action, "reshape", 7) != 0)
 			break;
 		/* Some kernels reset 'sync_completed' to zero
@@ -4121,8 +4121,8 @@ int progress_reshape(struct mdinfo *info, struct reshape *reshape,
 	 */
 	if (completed == 0) {
 		unsigned long long reshapep;
-		char action[20];
-		if (sysfs_get_str(info, NULL, "sync_action", action, 20) > 0 &&
+		char action[SYSFS_MAX_BUF_SIZE];
+		if (sysfs_get_str(info, NULL, "sync_action", action, sizeof(action)) > 0 &&
 		    strncmp(action, "idle", 4) == 0 &&
 		    sysfs_get_ll(info, NULL,
 				 "reshape_position", &reshapep) == 0)
@@ -4240,7 +4240,7 @@ static int grow_backup(struct mdinfo *sra,
 			if (sd->disk.state & (1<<MD_DISK_FAULTY))
 				continue;
 			if (sd->disk.state & (1<<MD_DISK_SYNC)) {
-				char sbuf[100];
+				char sbuf[SYSFS_MAX_BUF_SIZE];
 
 				if (sysfs_get_str(sra, sd, "state",
 						  sbuf, sizeof(sbuf)) < 0 ||
diff --git a/Incremental.c b/Incremental.c
index 3551c65ba753..52e396237e64 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1650,7 +1650,7 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
 	struct mdstat_ent *ent;
 	struct mddev_dev devlist;
 	struct mdinfo mdi;
-	char buf[32];
+	char buf[SYSFS_MAX_BUF_SIZE];
 
 	if (!id_path)
 		dprintf("incremental removal without --path <id_path> lacks the possibility to re-add new device in this port\n");
diff --git a/Manage.c b/Manage.c
index 915322667788..d66dc7b8af91 100644
--- a/Manage.c
+++ b/Manage.c
@@ -181,7 +181,7 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 	char container[32];
 	int err;
 	int count;
-	char buf[32];
+	char buf[SYSFS_MAX_BUF_SIZE];
 	unsigned long long rd1, rd2;
 
 	if (will_retry && verbose == 0)
@@ -312,7 +312,7 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 	if (mdi && is_level456(mdi->array.level) &&
 	    sysfs_attribute_available(mdi, NULL, "sync_action") &&
 	    sysfs_attribute_available(mdi, NULL, "reshape_direction") &&
-	    sysfs_get_str(mdi, NULL, "sync_action", buf, 20) > 0 &&
+	    sysfs_get_str(mdi, NULL, "sync_action", buf, sizeof(buf)) > 0 &&
 	    strcmp(buf, "reshape\n") == 0 &&
 	    sysfs_get_two(mdi, NULL, "raid_disks", &rd1, &rd2) == 2) {
 		unsigned long long position, curr;
@@ -1519,8 +1519,8 @@ int Manage_subdevs(char *devname, int fd,
 			sprintf(dname, "dev-%s", dv->devname);
 			sysfd = sysfs_open(fd2devnm(fd), dname, "block/dev");
 			if (sysfd >= 0) {
-				char dn[20];
-				if (sysfs_fd_get_str(sysfd, dn, 20) > 0 &&
+				char dn[SYSFS_MAX_BUF_SIZE];
+				if (sysfs_fd_get_str(sysfd, dn, sizeof(dn)) > 0 &&
 				    sscanf(dn, "%d:%d", &mj,&mn) == 2) {
 					rdev = makedev(mj,mn);
 					found = 1;
diff --git a/Monitor.c b/Monitor.c
index 9a1f2514534e..824a69fc6b79 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -1309,12 +1309,12 @@ int Wait(char *dev)
 			 * sync_action does.
 			 */
 			struct mdinfo mdi;
-			char buf[21];
+			char buf[SYSFS_MAX_BUF_SIZE];
 
 			if (sysfs_init(&mdi, -1, devnm))
 				return 2;
 			if (sysfs_get_str(&mdi, NULL, "sync_action",
-					  buf, 20) > 0 &&
+					  buf, sizeof(buf)) > 0 &&
 			    strcmp(buf,"idle\n") != 0) {
 				e->percent = RESYNC_UNKNOWN;
 				if (strcmp(buf, "frozen\n") == 0) {
@@ -1393,7 +1393,7 @@ int WaitClean(char *dev, int verbose)
 
 	if (rv) {
 		int state_fd = sysfs_open(fd2devnm(fd), NULL, "array_state");
-		char buf[20];
+		char buf[SYSFS_MAX_BUF_SIZE];
 		int delay = 5000;
 
 		/* minimize the safe_mode_delay and prepare to wait up to 5s
diff --git a/managemon.c b/managemon.c
index a7bfa8f618a4..358459e79435 100644
--- a/managemon.c
+++ b/managemon.c
@@ -454,7 +454,7 @@ static void manage_member(struct mdstat_ent *mdstat,
 	 * trying to find and assign a spare.
 	 * We do that whenever the monitor tells us too.
 	 */
-	char buf[64];
+	char buf[SYSFS_MAX_BUF_SIZE];
 	int frozen;
 	struct supertype *container = a->container;
 	struct mdinfo *mdi;
@@ -664,7 +664,7 @@ static void manage_new(struct mdstat_ent *mdstat,
 	struct mdinfo *mdi = NULL, *di;
 	int i, inst;
 	int failed = 0;
-	char buf[40];
+	char buf[SYSFS_MAX_BUF_SIZE];
 
 	/* check if array is ready to be monitored */
 	if (!mdstat->active || !mdstat->level)
@@ -738,7 +738,7 @@ static void manage_new(struct mdstat_ent *mdstat,
 	 * read this information for new arrays only (empty victim)
 	 */
 	if ((victim == NULL) &&
-	    (sysfs_get_str(mdi, NULL, "sync_action", buf, 40) > 0) &&
+	    (sysfs_get_str(mdi, NULL, "sync_action", buf, sizeof(buf)) > 0) &&
 	    (strncmp(buf, "reshape", 7) == 0)) {
 		if (sysfs_get_ll(mdi, NULL, "reshape_position",
 			&new->last_checkpoint) != 0)
diff --git a/mdadm.h b/mdadm.h
index 8dcd8b86f35a..46692730801e 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -767,6 +767,8 @@ enum sysfs_read_flags {
 	GET_DEVS_ALL	= (1 << 27),
 };
 
+#define SYSFS_MAX_BUF_SIZE 64
+
 /* If fd >= 0, get the array it is open on,
  * else use devnm.
  */
diff --git a/monitor.c b/monitor.c
index 820a93d0ceaf..f54d07b24f59 100644
--- a/monitor.c
+++ b/monitor.c
@@ -81,10 +81,10 @@ static int read_attr(char *buf, int len, int fd)
 
 static void read_resync_start(int fd, unsigned long long *v)
 {
-	char buf[30];
+	char buf[SYSFS_MAX_BUF_SIZE];
 	int n;
 
-	n = read_attr(buf, 30, fd);
+	n = read_attr(buf, sizeof(buf), fd);
 	if (n <= 0) {
 		dprintf("Failed to read resync_start (%d)\n", fd);
 		return;
@@ -98,11 +98,11 @@ static void read_resync_start(int fd, unsigned long long *v)
 static unsigned long long read_sync_completed(int fd)
 {
 	unsigned long long val;
-	char buf[50];
+	char buf[SYSFS_MAX_BUF_SIZE];
 	int n;
 	char *ep;
 
-	n = read_attr(buf, 50, fd);
+	n = read_attr(buf, sizeof(buf), fd);
 
 	if (n <= 0)
 		return 0;
@@ -115,8 +115,8 @@ static unsigned long long read_sync_completed(int fd)
 
 static enum array_state read_state(int fd)
 {
-	char buf[20];
-	int n = read_attr(buf, 20, fd);
+	char buf[SYSFS_MAX_BUF_SIZE];
+	int n = read_attr(buf, sizeof(buf), fd);
 
 	if (n <= 0)
 		return bad_word;
@@ -125,8 +125,8 @@ static enum array_state read_state(int fd)
 
 static enum sync_action read_action( int fd)
 {
-	char buf[20];
-	int n = read_attr(buf, 20, fd);
+	char buf[SYSFS_MAX_BUF_SIZE];
+	int n = read_attr(buf, sizeof(buf), fd);
 
 	if (n <= 0)
 		return bad_action;
@@ -135,7 +135,7 @@ static enum sync_action read_action( int fd)
 
 int read_dev_state(int fd)
 {
-	char buf[100];
+	char buf[SYSFS_MAX_BUF_SIZE];
 	int n = read_attr(buf, sizeof(buf), fd);
 	char *cp;
 	int rv = 0;
@@ -595,7 +595,7 @@ static int read_and_act(struct active_array *a, fd_set *fds)
 		 */
 		if ((a->curr_action != reshape) &&
 		    (a->prev_action == reshape)) {
-			char buf[40];
+			char buf[SYSFS_MAX_BUF_SIZE];
 			if ((sysfs_get_str(&a->info, NULL,
 					  "reshape_position",
 					  buf,
diff --git a/msg.c b/msg.c
index 45cd45040a61..ba0e25be906d 100644
--- a/msg.c
+++ b/msg.c
@@ -324,7 +324,7 @@ int block_monitor(char *container, const int freeze)
 {
 	struct mdstat_ent *ent, *e, *e2;
 	struct mdinfo *sra = NULL;
-	char buf[64];
+	char buf[SYSFS_MAX_BUF_SIZE];
 	int rv = 0;
 
 	if (check_mdmon_version(container))
@@ -366,7 +366,7 @@ int block_monitor(char *container, const int freeze)
 		     !sysfs_attribute_available(sra, NULL, "sync_action")) ||
 		    (freeze &&
 		     sysfs_attribute_available(sra, NULL, "sync_action") &&
-		     sysfs_get_str(sra, NULL, "sync_action", buf, 20) > 0 &&
+		     sysfs_get_str(sra, NULL, "sync_action", buf, sizeof(buf)) > 0 &&
 		     strcmp(buf, "frozen\n") == 0))
 			/* pass */;
 		else {
diff --git a/super-intel.c b/super-intel.c
index efac07d59c53..c3e832686578 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -11156,11 +11156,11 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 	unsigned int sector_size = super->sector_size;
 	unsigned long long curr_migr_unit = current_migr_unit(migr_rec);
 	unsigned long long num_migr_units = get_num_migr_units(migr_rec);
-	char buffer[20];
+	char buffer[SYSFS_MAX_BUF_SIZE];
 	int skipped_disks = 0;
 	struct dl *dl_disk;
 
-	err = sysfs_get_str(info, NULL, "array_state", (char *)buffer, 20);
+	err = sysfs_get_str(info, NULL, "array_state", (char *)buffer, sizeof(buffer));
 	if (err < 1)
 		return 1;
 
@@ -12079,9 +12079,9 @@ exit_imsm_reshape_super:
 static int read_completed(int fd, unsigned long long *val)
 {
 	int ret;
-	char buf[50];
+	char buf[SYSFS_MAX_BUF_SIZE];
 
-	ret = sysfs_fd_get_str(fd, buf, 50);
+	ret = sysfs_fd_get_str(fd, buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 
@@ -12154,12 +12154,12 @@ int wait_for_reshape_imsm(struct mdinfo *sra, int ndata)
 
 	do {
 		int rc;
-		char action[20];
+		char action[SYSFS_MAX_BUF_SIZE];
 		int timeout = 3000;
 
 		sysfs_wait(fd, &timeout);
 		if (sysfs_get_str(sra, NULL, "sync_action",
-				  action, 20) > 0 &&
+				  action, sizeof(action)) > 0 &&
 				strncmp(action, "reshape", 7) != 0) {
 			if (strncmp(action, "idle", 4) == 0)
 				break;
@@ -12206,7 +12206,7 @@ int check_degradation_change(struct mdinfo *info,
 			if (sd->disk.state & (1<<MD_DISK_FAULTY))
 				continue;
 			if (sd->disk.state & (1<<MD_DISK_SYNC)) {
-				char sbuf[100];
+				char sbuf[SYSFS_MAX_BUF_SIZE];
 				int raid_disk = sd->disk.raid_disk;
 
 				if (sysfs_get_str(info,
diff --git a/sysfs.c b/sysfs.c
index decb02b8d80f..0dc7badfc4b7 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -664,7 +664,7 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 	ver[0] = 0;
 	if (info->array.major_version == -1 &&
 	    info->array.minor_version == -2) {
-		char buf[1024];
+		char buf[SYSFS_MAX_BUF_SIZE];
 
 		strcat(strcpy(ver, "external:"), info->text_version);
 
@@ -675,7 +675,7 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 		 * version first, and preserve the flag
 		 */
 		if (sysfs_get_str(info, NULL, "metadata_version",
-				  buf, 1024) > 0)
+				  buf, sizeof(buf)) > 0)
 			if (strlen(buf) >= 9 && buf[9] == '-')
 				ver[9] = '-';
 
@@ -900,11 +900,11 @@ int sysfs_freeze_array(struct mdinfo *sra)
 	 * return 0 if this kernel doesn't support 'frozen'
 	 * return 1 if it worked.
 	 */
-	char buf[20];
+	char buf[SYSFS_MAX_BUF_SIZE];
 
 	if (!sysfs_attribute_available(sra, NULL, "sync_action"))
 		return 1; /* no sync_action == frozen */
-	if (sysfs_get_str(sra, NULL, "sync_action", buf, 20) <= 0)
+	if (sysfs_get_str(sra, NULL, "sync_action", buf, sizeof(buf)) <= 0)
 		return 0;
 	if (strcmp(buf, "frozen\n") == 0)
 		/* Already frozen */
-- 
2.35.3

