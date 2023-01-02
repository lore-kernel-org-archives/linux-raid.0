Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16D6C4167B
	for <linux-raid@archiver.kernel.org>; Mon,  2 Jan 2023 08:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjABIrG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Jan 2023 03:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbjABIrD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Jan 2023 03:47:03 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4883BD94
        for <linux-raid@vger.kernel.org>; Mon,  2 Jan 2023 00:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672649222; x=1704185222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=385mY5ve58xbIAWNu+ZR139S56ydnfJ01k6LB4jHB6k=;
  b=D8o0LFoZd/TAlHrGgppUMH+9H5SRJ8cz45iq/7uje+VVmk8hqGiAUZox
   jF7izsSVvEUiOJnbDOrBFy8E/AofM/Aqd4vieIz4ci7XiH1/Ttgxgi55w
   BgREEugxI/kjHY02ZEUz1jArTDRbJSo92wTAbeMz61pvqZ2DIVtlo3QIc
   rdxaD6KOomjub6yorHbx9tCnGTAgslOlevoSwts7WQ2ciF8SgB7VsYiC8
   mRyIC6E2uhZtaDV3VcLSHW808EMnaS17akGxhosDr+lhfLl+HRfC9/wJU
   vpMPYVoelbhDwG7QNd1ec7Cl4w7VJxc1B69PwVb2/ElUIAD24NgD8SbNg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="309222515"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="309222515"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2023 00:46:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="983244055"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="983244055"
Received: from unknown (HELO DESKTOP-QODMV9C.igk.intel.com.com) ([10.102.109.29])
  by fmsmga005.fm.intel.com with ESMTP; 02 Jan 2023 00:46:52 -0800
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 2/2] util: remove obsolete code from get_md_name
Date:   Mon,  2 Jan 2023 09:46:22 +0100
Message-Id: <20230102084622.29154-2-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230102084622.29154-1-mateusz.kusiak@intel.com>
References: <20230102084622.29154-1-mateusz.kusiak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

get_md_name() is used only with mdstat entries.
Remove dead code and simplyfy function.

Remove redundadnt checks from mdmon.c

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 mdmon.c |  8 +++-----
 util.c  | 51 +++++++++++++++++----------------------------------
 2 files changed, 20 insertions(+), 39 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index ecf52dc8..60ba3182 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -366,7 +366,7 @@ int main(int argc, char *argv[])
 		if (argv[optind]) {
 			container_name = get_md_name(argv[optind]);
 			if (!container_name)
-				container_name = argv[optind];
+				return 1;
 		}
 	}
 
@@ -403,11 +403,9 @@ int main(int argc, char *argv[])
 
 		return status;
 	} else {
-		int mdfd = open_mddev(container_name, 1);
-
-		if (mdfd < 0)
-			return 1;
+		int mdfd = open_mddev(container_name, 0);
 		devnm = fd2devnm(mdfd);
+
 		close(mdfd);
 	}
 
diff --git a/util.c b/util.c
index 26ffdcea..9cd89fa4 100644
--- a/util.c
+++ b/util.c
@@ -968,47 +968,30 @@ dev_t devnm2devid(char *devnm)
 	return 0;
 }
 
+/**
+ * get_md_name() - Get main dev node of the md device.
+ * @devnm: Md device name or path.
+ *
+ * Function checks if the full name was passed and returns md name
+ * if it is the MD device.
+ *
+ * Return: Main dev node of the md device or NULL if not found.
+ */
 char *get_md_name(char *devnm)
 {
-	/* find /dev/md%d or /dev/md/%d or make a device /dev/.tmp.md%d */
-	/* if dev < 0, want /dev/md/d%d or find mdp in /proc/devices ... */
-
-	static char devname[50];
+	static char devname[NAME_MAX];
 	struct stat stb;
-	dev_t rdev = devnm2devid(devnm);
-	char *dn;
 
-	if (rdev == 0)
-		return 0;
-	if (strncmp(devnm, "md_", 3) == 0) {
-		snprintf(devname, sizeof(devname), "/dev/md/%s",
-			devnm + 3);
-		if (stat(devname, &stb) == 0 &&
-		    (S_IFMT&stb.st_mode) == S_IFBLK && (stb.st_rdev == rdev))
-			return devname;
-	}
-	snprintf(devname, sizeof(devname), "/dev/%s", devnm);
-	if (stat(devname, &stb) == 0 && (S_IFMT&stb.st_mode) == S_IFBLK &&
-	    (stb.st_rdev == rdev))
-		return devname;
+	if (strncmp(devnm, "/dev/", 5) == 0)
+		snprintf(devname, sizeof(devname), "%s", devnm);
+	else
+		snprintf(devname, sizeof(devname), "/dev/%s", devnm);
 
-	snprintf(devname, sizeof(devname), "/dev/md/%s", devnm+2);
-	if (stat(devname, &stb) == 0 && (S_IFMT&stb.st_mode) == S_IFBLK &&
-	    (stb.st_rdev == rdev))
+	if (!is_mddev(devname))
+		return NULL;
+	if (stat(devname, &stb) == 0 && (S_IFMT&stb.st_mode) == S_IFBLK)
 		return devname;
 
-	dn = map_dev(major(rdev), minor(rdev), 0);
-	if (dn)
-		return dn;
-	snprintf(devname, sizeof(devname), "/dev/.tmp.%s", devnm);
-	if (mknod(devname, S_IFBLK | 0600, rdev) == -1)
-		if (errno != EEXIST)
-			return NULL;
-
-	if (stat(devname, &stb) == 0 && (S_IFMT&stb.st_mode) == S_IFBLK &&
-	    (stb.st_rdev == rdev))
-		return devname;
-	unlink(devname);
 	return NULL;
 }
 
-- 
2.26.2

