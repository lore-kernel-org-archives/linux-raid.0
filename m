Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FD65338A
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 13:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714396097; cv=none; b=c7zYKkKBqRr8h+GVJ2LiFyfySgZvsybnUnL8DVlZULF9DrzwY5wE5c9LecWzxrP0sO9g5v3E/YzYUn7JUh8/1d+8d4XCJeNFCL20aLESkl6Hsbun6rdM+PUFQwsCgIuFkuQ/cFiUOkz/VuWMvnos8vo8OMN8oJB+/ClI2hnUtl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714396097; c=relaxed/simple;
	bh=Yvd+Pe33bPpCZ3ndtHuUcif1GZH9+zBSLiqUUQW4HQc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V1mvtLgC5nzEysu+lm9Ay23Iw3jxAxVYgeMJpOBS+NJ4ZsxM2RnM4X4Qz6a+2l/M8s1N8InRT2y0HViEIMKI0Y/cpkJxoLRWEmB7NbrvGY3ULvFb7KyQI6bQOlU7QFrqyo5n5Fq8IMz6AXgDs2Yl5g5whdf5DBMh5Di7p6+yTDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZOdeJ42d; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZOdeJ42d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714396097; x=1745932097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Yvd+Pe33bPpCZ3ndtHuUcif1GZH9+zBSLiqUUQW4HQc=;
  b=ZOdeJ42dp+eHmsudGblWJKKGuOKVglAj0yIKRtpIBQ1DAfv4RK05GGxE
   755HpTaWgpegmUk92ThM7Z777VKNMsAQTq6JfPTTnTl0FEJHx5iak6m9F
   W385EdokqyzebP1a2rF2tLyz4Phs3+K9asSsHYwxkmuk5xD8+0DRbaHJ4
   HVr9pPAKK7owOzEHfGCwU/ZLFpFCxXcWsiBSh0pJDtPUkKhFeGPv3UWCz
   pmQ6XNliQsJ/mxYDEoqxfivmLjSkizr+2QFz9Tboi/ygB6vRbfNJceruX
   OwCyEi3o8SESINyxBjp21H0XQNSfoVTIjbRFOKxIjZp20SpxCzJpIRVxM
   w==;
X-CSE-ConnectionGUID: z38DrkxHT0GpF8J2Zh8VFQ==
X-CSE-MsgGUID: 910OcMieSUeo+doYIQU5mw==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="32554569"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="32554569"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 06:08:11 -0700
X-CSE-ConnectionGUID: mMDpdO8fSUya39XOhddNxA==
X-CSE-MsgGUID: 4YYI4HwERn28M3BokyRgOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26609953"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by orviesa007.jf.intel.com with ESMTP; 29 Apr 2024 06:08:10 -0700
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Subject: [PATCH 8/8] imsm: support RAID 10 with more than 4 drives
Date: Mon, 29 Apr 2024 15:07:20 +0200
Message-Id: <20240429130720.260452-9-mateusz.kusiak@intel.com>
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

VROC UEFI driver does not support RAID 10 with more than 4 drives.
Add user prompts if such layout is being created and for R0->R10
reshapes.

Refactor ask() function:
- simplify the code,
- remove dialog reattempts,
- do no pass '?' sign on function calls,
- highlight default option on output.

This patch completes adding support for R10D4+ to IMSM.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Create.c      |  9 ++++++++-
 super-intel.c | 14 ++++++++++++--
 util.c        | 39 +++++++++++++++++++++++++--------------
 3 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/Create.c b/Create.c
index d94253b1ad2e..d033eb68f30c 100644
--- a/Create.c
+++ b/Create.c
@@ -965,6 +965,13 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 		return 1;
 	}
 
+	if (st->ss == &super_imsm && s->level == 10 && s->raiddisks > 4) {
+		/* Print no matter runstop was specifed */
+		pr_err("Warning! VROC UEFI driver does not support RAID10 in requested layout.\n");
+		pr_err("Array won't be suitable as boot device.\n");
+		warn = 1;
+	}
+
 	if (!have_container && s->level > 0 && ((maxsize-s->size)*100 > maxsize)) {
 		if (c->runstop != 1 || c->verbose >= 0)
 			pr_err("largest drive (%s) exceeds size (%lluK) by more than 1%%\n",
@@ -984,7 +991,7 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 
 	if (warn) {
 		if (c->runstop!= 1) {
-			if (!ask("Continue creating array? ")) {
+			if (!ask("Continue creating array")) {
 				pr_err("create aborted.\n");
 				return 1;
 			}
diff --git a/super-intel.c b/super-intel.c
index d60915e812d4..2b8b6fda976c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -523,6 +523,7 @@ enum imsm_reshape_type {
 	CH_TAKEOVER,
 	CH_MIGRATION,
 	CH_ARRAY_SIZE,
+	CH_ABORT
 };
 
 /* definition of messages passed to imsm_process_update */
@@ -11898,7 +11899,7 @@ success:
 ****************************************************************************/
 enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 					   struct geo_params *geo,
-					   int direction)
+					   int direction, struct context *c)
 {
 	struct mdinfo info;
 	int change = -1;
@@ -11925,6 +11926,14 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 				check_devs = 1;
 				raid_disks += 1; /* parity disk added */
 			} else if (geo->level == IMSM_T_RAID10) {
+				if (geo->level == IMSM_T_RAID10 && geo->raid_disks > 2 &&
+				    !c->force) {
+					pr_err("Warning! VROC UEFI driver does not support RAID10 in requested layout.\n");
+					pr_err("Array won't be suitable as boot device.\n");
+					pr_err("Note: You can omit this check with \"--force\"\n");
+					if (ask("Do you want to continue") < 1)
+						return CH_ABORT;
+				}
 				change = CH_TAKEOVER;
 				check_devs = 1;
 				raid_disks *= 2; /* mirrors added */
@@ -12219,7 +12228,7 @@ static int imsm_reshape_super(struct supertype *st, struct shape *shape, struct
 			goto exit_imsm_reshape_super;
 		}
 		super->current_vol = dev->index;
-		change = imsm_analyze_change(st, &geo, shape->direction);
+		change = imsm_analyze_change(st, &geo, shape->direction, c);
 		switch (change) {
 		case CH_TAKEOVER:
 			ret_val = imsm_takeover(st, &geo);
@@ -12262,6 +12271,7 @@ static int imsm_reshape_super(struct supertype *st, struct shape *shape, struct
 				free(u);
 		}
 		break;
+		case CH_ABORT:
 		default:
 			ret_val = 1;
 		}
diff --git a/util.c b/util.c
index 9e8370450a8d..4fbf11c4e2bd 100644
--- a/util.c
+++ b/util.c
@@ -725,23 +725,33 @@ int stat_is_blkdev(char *devname, dev_t *rdev)
 	return 1;
 }
 
+/**
+ * ask() - prompt user for "yes/no" dialog.
+ * @mesg: message to be printed, without '?' sign.
+ * Returns: 1 if 'Y/y', 0 otherwise.
+ *
+ * The default value is 'N/n', thus the caps on "N" on prompt.
+ */
 int ask(char *mesg)
 {
-	char *add = "";
-	int i;
-	for (i = 0; i < 5; i++) {
-		char buf[100];
-		fprintf(stderr, "%s%s", mesg, add);
-		fflush(stderr);
-		if (fgets(buf, 100, stdin)==NULL)
-			return 0;
-		if (buf[0]=='y' || buf[0]=='Y')
-			return 1;
-		if (buf[0]=='n' || buf[0]=='N')
-			return 0;
-		add = "(y/n) ";
+	char buf[3] = {0};
+
+	fprintf(stderr, "%s [y/N]? ", mesg);
+	fflush(stderr);
+	if (fgets(buf, 3, stdin) == NULL)
+		return 0;
+	if (strlen(buf) == 1) {
+		pr_err("assuming no.\n");
+		return 0;
 	}
-	pr_err("assuming 'no'\n");
+	if (buf[1] != '\n')
+		goto bad_option;
+	if (toupper(buf[0]) == 'Y')
+		return 1;
+	if (toupper(buf[0]) == 'N')
+		return 0;
+bad_option:
+	pr_err("bad option.\n");
 	return 0;
 }
 
@@ -1868,6 +1878,7 @@ int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info)
 
 	if (st->ss->external)
 		return sysfs_set_array(info);
+
 	memset(&inf, 0, sizeof(inf));
 	inf.major_version = info->array.major_version;
 	inf.minor_version = info->array.minor_version;
-- 
2.39.2

