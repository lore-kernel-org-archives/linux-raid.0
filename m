Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC705C00A5A
	for <linux-raid@archiver.kernel.org>; Thu, 19 Jan 2023 13:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjASNt1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Jan 2023 08:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbjASNtL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Jan 2023 08:49:11 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F9645BC5
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 05:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674136149; x=1705672149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7udgSe1LCUiERyHtBy2M6ATbrZ2Irt5GRczTELGVdyM=;
  b=Copq2YFfz6ychnKjeydvbK7+hMcBynPPhNv6NpdUKBWdX6p9DAg3EK7f
   ibj3ZWzohTqmhKlGmjUfGvDC7owpCp0/KlIt8bQAGQIhJyaGh1EbNfBkp
   VbvsIGNAV8zCS0QlSAfnL7jAy6NMDXfdkxqWNNJvCnkruCE5iASsWT2+8
   3L80DS9TQNpuvBuHOXcetWbG+nOUyHhXbDwZjiS+WHvHMafaLouyltoox
   fIwel0SOurRUFiUvVU/YIyj7785GaOdvFd8iYq6yDfWjlKl3v42gJXOvo
   K3b/JwXpXodrkNeavrU1lBpEmD8pWoo2qLm4stsX5+CiGsbFFR5jMIwom
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="323973389"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="323973389"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 05:49:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="768221948"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="768221948"
Received: from unknown (HELO localhost.elements.local) ([10.102.104.85])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jan 2023 05:49:07 -0800
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH 4/8] Add helpers to determine whether directories or files are soft links
Date:   Thu, 19 Jan 2023 14:30:05 +0100
Message-Id: <20230119133009.12696-5-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230119133009.12696-1-mateusz.grzonka@intel.com>
References: <20230119133009.12696-1-mateusz.grzonka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 mdadm.h |  2 ++
 util.c  | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/mdadm.h b/mdadm.h
index 13f8b4cb..1674ce13 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1777,6 +1777,8 @@ extern void set_dlm_hooks(void);
 #define MSEC_TO_NSEC(msec) ((msec) * 1000000)
 #define USEC_TO_NSEC(usec) ((usec) * 1000)
 extern void sleep_for(unsigned int sec, long nsec, bool wake_after_interrupt);
+extern bool is_directory(const char *path);
+extern bool is_file(const char *path);
 
 #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
 #define ROUND_UP(val, base)	_ROUND_UP(val, (typeof(val))(base))
diff --git a/util.c b/util.c
index 9cd89fa4..5afb7c08 100644
--- a/util.c
+++ b/util.c
@@ -2396,3 +2396,48 @@ void sleep_for(unsigned int sec, long nsec, bool wake_after_interrupt)
 		}
 	} while (!wake_after_interrupt && errno == EINTR);
 }
+
+/* is_directory() - Checks if directory provided by path is indeed a regular directory.
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
+/*
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

