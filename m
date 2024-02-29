Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2587D084
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 11:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207559; cv=none; b=t1aWAGxloTmy1porVmPcQxUbaSJ3uYMHKaGwxG2keHryD9TuK1H/L+FYIaibxfMhmZCu7SWHmRv3qpYTekfikNxSIaGKY5vGf0rR8uEQQFf7RoZJrEfFhy13XPcKKhFZwDy3VJsRFDsYiq+DDFbJI8DYW0QBOhdNonjQp+mCvQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207559; c=relaxed/simple;
	bh=H8agbCgas9PnYLGKm0C0xh5/kvJR3OtVqbaknpG+11g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s1O5fNgMlors58P+aVrsf82bcI9AektsNbHHu1rkaR5zdkJgn4trWQ/wfxbck+aVMKrSV5UcdnrXcAaEHHPdt5L37Adkr1wnO8lffilIc5jLsxIHZ/C/zYXAkAVCJElhwFEoI+F35IrdeCaunl02l+Buxy5FSZamusdIZketif4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lBpOeJGK; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lBpOeJGK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709207558; x=1740743558;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H8agbCgas9PnYLGKm0C0xh5/kvJR3OtVqbaknpG+11g=;
  b=lBpOeJGKYisdr+ktUx2PYtdy7PcgB/0G92CRHuQ6Ekq+XZCTs8zMMVsU
   dFOYcGmyrGe41zTgSExcFKZgMNoZcrlQyk1sUPN2DvB9mfqLDiHzui4/5
   dhPvlwpEHAF5J4/pSB4BgPcXBcqI8zVPVcM/QGtnFrVSNk964BH0V2Hfa
   RFdrbjZNVcVEh5HOe6fWbJ7YlH4sMDw0g7U3U7gZA+h2kwX68gP8QkOI7
   bBLjoCTUSQJ71Lpf7MXlfbWtWg4OqRq35P2u0vdxRt1YrEq/BQxZlVBAs
   0soJraGoAn/5/XOSL41P5D13JOXownsQeSc1X6fvZ9bvVRlG+r3cy4CqC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7499453"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7499453"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7754813"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:37 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 05/13] mdadm: introduce sysfs_get_container_devnm()
Date: Thu, 29 Feb 2024 12:52:09 +0100
Message-Id: <20240229115217.26543-6-mariusz.tkaczyk@linux.intel.com>
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

There at least two places where it is done directly, so replace them
with function. Print message about creating external array, add "/dev/"
prefix to refer directly to devnode.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Create.c | 21 ++++++++++-----------
 Manage.c | 14 ++++----------
 mdadm.h  |  2 ++
 sysfs.c  | 23 +++++++++++++++++++++++
 4 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/Create.c b/Create.c
index 7e9170b6a1ac..0b7762661c76 100644
--- a/Create.c
+++ b/Create.c
@@ -1142,24 +1142,23 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 
 	if (did_default && c->verbose >= 0) {
 		if (is_subarray(info.text_version)) {
-			char devnm[32];
-			char *ep;
+			char devnm[MD_NAME_MAX];
 			struct mdinfo *mdi;
 
-			strncpy(devnm, info.text_version+1, 32);
-			devnm[31] = 0;
-			ep = strchr(devnm, '/');
-			if (ep)
-				*ep = 0;
+			sysfs_get_container_devnm(&info, devnm);
 
 			mdi = sysfs_read(-1, devnm, GET_VERSION);
+			if (!mdi) {
+				pr_err("Cannot open sysfs for container %s\n", devnm);
+				goto abort_locked;
+			}
+
+			pr_info("Creating array inside %s container /dev/%s\n", mdi->text_version,
+				devnm);
 
-			pr_info("Creating array inside %s container %s\n",
-				mdi?mdi->text_version:"managed", devnm);
 			sysfs_free(mdi);
 		} else
-			pr_info("Defaulting to version %s metadata\n",
-				info.text_version);
+			pr_info("Defaulting to version %s metadata\n", info.text_version);
 	}
 
 	map_update(&map, fd2devnm(mdfd), info.text_version,
diff --git a/Manage.c b/Manage.c
index b3e216cbcec6..969d0ea9d81f 100644
--- a/Manage.c
+++ b/Manage.c
@@ -178,7 +178,7 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 	struct map_ent *map = NULL;
 	struct mdinfo *mdi;
 	char devnm[32];
-	char container[32];
+	char container[MD_NAME_MAX] = {0};
 	int err;
 	int count;
 	char buf[SYSFS_MAX_BUF_SIZE];
@@ -192,15 +192,9 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 	 * to stop is probably a bad idea.
 	 */
 	mdi = sysfs_read(fd, NULL, GET_LEVEL|GET_COMPONENT|GET_VERSION);
-	if (mdi && is_subarray(mdi->text_version)) {
-		char *sl;
-		strncpy(container, mdi->text_version+1, sizeof(container));
-		container[sizeof(container)-1] = 0;
-		sl = strchr(container, '/');
-		if (sl)
-			*sl = 0;
-	} else
-		container[0] = 0;
+	if (mdi && is_subarray(mdi->text_version))
+		sysfs_get_container_devnm(mdi, container);
+
 	close(fd);
 	count = 5;
 	while (((fd = ((devname[0] == '/')
diff --git a/mdadm.h b/mdadm.h
index cbc586f5e3ef..39b86bd08029 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -777,6 +777,8 @@ enum sysfs_read_flags {
 
 #define SYSFS_MAX_BUF_SIZE 64
 
+extern void sysfs_get_container_devnm(struct mdinfo *mdi, char *buf);
+
 /* If fd >= 0, get the array it is open on,
  * else use devnm.
  */
diff --git a/sysfs.c b/sysfs.c
index f95ef7013e84..230b842e4117 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -74,6 +74,29 @@ void sysfs_free(struct mdinfo *sra)
 	}
 }
 
+/**
+ * sysfs_get_container_devnm() - extract container device name.
+ * @mdi: md_info describes member array, with GET_VERSION option.
+ * @buf: buf to fill, must be MD_NAME_MAX.
+ *
+ * External array version is in format {/,-}<container_devnm>/<array_index>
+ * Extract container_devnm from it and safe it in @buf.
+ */
+void sysfs_get_container_devnm(struct mdinfo *mdi, char *buf)
+{
+	char *p;
+
+	assert(is_subarray(mdi->text_version));
+
+	/* Skip first special sign */
+	snprintf(buf, MD_NAME_MAX, "%s", mdi->text_version + 1);
+
+	/* Remove array index */
+	p = strchr(buf, '/');
+	if (p)
+		*p = 0;
+}
+
 int sysfs_open(char *devnm, char *devname, char *attr)
 {
 	char fname[MAX_SYSFS_PATH_LEN];
-- 
2.35.3

