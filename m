Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA23C7618E
	for <linux-raid@archiver.kernel.org>; Fri, 21 Apr 2023 06:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjDUGrr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Apr 2023 02:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjDUGrq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Apr 2023 02:47:46 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A71CE74
        for <linux-raid@vger.kernel.org>; Thu, 20 Apr 2023 23:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682059665; x=1713595665;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tx480VoExG6mKmfqKebARglRWDy1mvq9ezNuLqm4vRM=;
  b=Qm9yyk4V9pywxPhZDT1BNfuGX45h9ArMRVFXSAJHaXRsfFRhLn+Jpp37
   YTBLvL1UyIfCvAb+6fxxFQmI65/6zQvIe3onhodR0qlZ/asXIoqf4RW7V
   9xMQjbBrRvgbhNLJ8mTX+/WFvUBz4M6DQOg5sfF4zMCABoyJozsyJBiDQ
   RxIJD+mfMWSUnSDBXC1e9MFUV1LAT2vLmWDB2zGCEPz2j62EhZykZZIvX
   Qm2tdtqzPc0U8KFzNTkBDxKVqyJ1mo3eElRsjAIavnbwyJ7nKoI9NF0gq
   Kdgje1GPGVt4Z3Is+J0Oj4pjy23iMoXXIIqGIl/iCPaIKSiy1SQdIJzTm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="330128190"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="330128190"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 23:47:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="685641219"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="685641219"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orsmga007.jf.intel.com with ESMTP; 20 Apr 2023 23:47:43 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 1/2] Fix unsafe string functions
Date:   Fri, 21 Apr 2023 01:46:57 +0200
Message-Id: <20230420234658.367-2-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230420234658.367-1-kinga.tanska@intel.com>
References: <20230420234658.367-1-kinga.tanska@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add string length limitations where necessary to
avoid buffer overflows.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 mdmon.c          | 6 +++---
 mdopen.c         | 4 ++--
 platform-intel.c | 2 +-
 super-intel.c    | 6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index cef5bbc8..a2038fe6 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -240,7 +240,7 @@ static int make_control_sock(char *devname)
 		return -1;
 
 	addr.sun_family = PF_LOCAL;
-	strcpy(addr.sun_path, path);
+	snprintf(addr.sun_path, sizeof(addr.sun_path), "%s", path);
 	umask(077); /* ensure no world write access */
 	if (bind(sfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
 		close(sfd);
@@ -389,7 +389,7 @@ int main(int argc, char *argv[])
 
 	if (all) {
 		struct mdstat_ent *mdstat, *e;
-		int container_len = strlen(container_name);
+		int container_len = strnlen(container_name, MD_NAME_MAX);
 
 		/* launch an mdmon instance for each container found */
 		mdstat = mdstat_read(0, 0);
@@ -472,7 +472,7 @@ static int mdmon(char *devnm, int must_fork, int takeover)
 		pfd[0] = pfd[1] = -1;
 
 	container = xcalloc(1, sizeof(*container));
-	strcpy(container->devnm, devnm);
+	snprintf(container->devnm, MD_NAME_MAX, "%s", devnm);
 	container->arrays = NULL;
 	container->sock = -1;
 
diff --git a/mdopen.c b/mdopen.c
index 810f79a3..d76169d9 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -193,14 +193,14 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 
 	if (dev) {
 		if (strncmp(dev, "/dev/md/", 8) == 0) {
-			strcpy(cname, dev+8);
+			snprintf(cname, MD_NAME_MAX, "%s", dev + 8);
 		} else if (strncmp(dev, "/dev/", 5) == 0) {
 			char *e = dev + strlen(dev);
 			while (e > dev && isdigit(e[-1]))
 				e--;
 			if (e[0])
 				num = strtoul(e, NULL, 10);
-			strcpy(cname, dev+5);
+			snprintf(cname, MD_NAME_MAX, "%s", dev + 5);
 			cname[e-(dev+5)] = 0;
 			/* name *must* be mdXX or md_dXX in this context */
 			if (num < 0 ||
diff --git a/platform-intel.c b/platform-intel.c
index 757f0b1b..22ebb2b1 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -201,7 +201,7 @@ struct sys_dev *device_by_id_and_path(__u16 device_id, const char *path)
 
 static int devpath_to_ll(const char *dev_path, const char *entry, unsigned long long *val)
 {
-	char path[strlen(dev_path) + strlen(entry) + 2];
+	char path[strnlen(dev_path, PATH_MAX) + strnlen(entry, PATH_MAX) + 2];
 	int fd;
 	int n;
 
diff --git a/super-intel.c b/super-intel.c
index a5c86cb2..0806bf03 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6990,7 +6990,7 @@ active_arrays_by_format(char *name, char* hba, struct md_list **devlist,
 			int fd = -1;
 			while (dev && !is_fd_valid(fd)) {
 				char *path = xmalloc(strlen(dev->name) + strlen("/dev/") + 1);
-				num = sprintf(path, "%s%s", "/dev/", dev->name);
+				num = snprintf(path, PATH_MAX, "%s%s", "/dev/", dev->name);
 				if (num > 0)
 					fd = open(path, O_RDONLY, 0);
 				if (num <= 0 || !is_fd_valid(fd)) {
@@ -7889,7 +7889,7 @@ static int kill_subarray_imsm(struct supertype *st, char *subarray_id)
 
 		if (i < current_vol)
 			continue;
-		sprintf(subarray, "%u", i);
+		snprintf(subarray, sizeof(subarray), "%u", i);
 		if (is_subarray_active(subarray, st->devnm)) {
 			pr_err("deleting subarray-%d would change the UUID of active subarray-%d, aborting\n",
 			       current_vol, i);
@@ -11262,7 +11262,7 @@ static const char *imsm_get_disk_controller_domain(const char *path)
 	char *drv=NULL;
 	struct stat st;
 
-	strcpy(disk_path, disk_by_path);
+	strncpy(disk_path, disk_by_path, PATH_MAX);
 	strncat(disk_path, path, PATH_MAX - strlen(disk_path) - 1);
 	if (stat(disk_path, &st) == 0) {
 		struct sys_dev* hba;
-- 
2.26.2

