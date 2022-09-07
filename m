Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C152EC54EE9
	for <linux-raid@archiver.kernel.org>; Wed,  7 Sep 2022 13:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiIGNOs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Sep 2022 09:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiIGNOj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Sep 2022 09:14:39 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E269FE3
        for <linux-raid@vger.kernel.org>; Wed,  7 Sep 2022 06:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662556466; x=1694092466;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1WcVMLvQ4JeY8NNq53wNRxVRJUCy+50xLcV07gQI8ow=;
  b=fmwIcXaZrEDYv6s1cuzHmttaMyDS88tn7Vi9wBm3fM8IUQh6KFdjFtKY
   3X0SXH833WMkOSkYbcGzAaYHa7U8DTxypPh0xeLPDEcIyZ0xpNAIHJPYX
   1nczGDOJ0Quhup2HIKmg1BG4jIdIPlYxkIgMU1C1hTVLXKzJgqX4zXLli
   SSb6A2fHhzVPx65q5+lkZNDcsI5JKLcQ6wQV3WxpYrq1X7QzoUTXu9gSH
   ZzkYDyyVMR+l52PZccMdOxa64KeucPq5YVIzlrkKKDnSkVZai4IL2Lbe5
   EQVpEsXSjK6SiDcxYEtyRRKYHESkWmD2IW5XpoVIlZ/XxQvIc0h/eDiXV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="296865371"
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="296865371"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 06:14:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="644608648"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.105.50])
  by orsmga008.jf.intel.com with ESMTP; 07 Sep 2022 06:14:24 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH 5/9] Add helpers to determine whether directories or files are soft links
Date:   Wed,  7 Sep 2022 14:56:53 +0200
Message-Id: <20220907125657.12192-6-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220907125657.12192-1-mateusz.grzonka@intel.com>
References: <20220907125657.12192-1-mateusz.grzonka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 mdadm.h |  3 +++
 util.c  | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/mdadm.h b/mdadm.h
index 09915a00..9183ee70 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1707,6 +1707,9 @@ extern int cluster_get_dlmlock(void);
 extern int cluster_release_dlmlock(void);
 extern void set_dlm_hooks(void);
 
+extern bool is_directory(const char *path);
+extern bool is_file(const char *path);
+
 #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
 #define ROUND_UP(val, base)	_ROUND_UP(val, (typeof(val))(base))
 #define ROUND_UP_PTR(ptr, base)	((typeof(ptr)) \
diff --git a/util.c b/util.c
index cc94f96e..97926f19 100644
--- a/util.c
+++ b/util.c
@@ -2375,3 +2375,49 @@ out:
 	close(fd_zero);
 	return ret;
 }
+
+/**
+ * is_directory() - Checks if directory provided by path is indeed a regular directory.
+ * @path: directory path to be checked
+ *
+ * Doesn't accept symlinks.
+ *
+ * Return: true if is a directory, false if not
+ */
+bool is_directory(const char *path)
+{
+	struct stat st;
+
+	if (lstat(path, &st) != 0) {
+		pr_err("%s: %s\n", strerror(errno), path);
+		return false;
+	}
+
+	if (!S_ISDIR(st.st_mode))
+		return false;
+
+	return true;
+}
+
+/**
+ * is_file() - Checks if file provided by path is indeed a regular file.
+ * @path: file path to be checked
+ *
+ * Doesn't accept symlinks.
+ *
+ * Return: true if is  a file, false if not
+ */
+bool is_file(const char *path)
+{
+	struct stat st;
+
+	if (lstat(path, &st) != 0) {
+		pr_err("%s: %s\n", strerror(errno), path);
+		return false;
+	}
+
+	if (!S_ISREG(st.st_mode))
+		return false;
+
+	return true;
+}
-- 
2.26.2

