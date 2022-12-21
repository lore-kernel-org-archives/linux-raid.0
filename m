Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D213C4332F
	for <linux-raid@archiver.kernel.org>; Wed, 21 Dec 2022 13:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiLUNhP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Dec 2022 08:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiLUNhM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Dec 2022 08:37:12 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0D6BCE
        for <linux-raid@vger.kernel.org>; Wed, 21 Dec 2022 05:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671629831; x=1703165831;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JcXExH1bTi2M8kzChql4QSXITGpeF6VYz9N932ZH6GI=;
  b=jkztxFkHVT8mVRd1OO0LqYPb7nCfzcqva+P5ekBnFyiG/0rV6rhCRJFY
   TFNAi3kNJGRINISbi1GORJh3vin3SlyIc4qSct/wIiI2cPBc8+ApbHMSV
   HCJH97YsXeSkGYgh7r9LPnUOWVrUgEcDXQjuGC91ng7Gc05muez8QQTNf
   nAiOs1ixFcFjPcWWTRhrNe4FIvXelL6X9Vqsb3lCLwK/o6VPxbdVp9RIv
   JErX5bnSIc3IrTXr89CzSMc3Il9ueqgCXRoIZLgEAY7BEysZ7G8Ji+60x
   qORJbOaV01HoNNBBHiU3mIgth9uneERPDUWeTb9hDHkKOamCBwKm+3HXE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="318566694"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="318566694"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 05:37:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="653515402"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="653515402"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by fmsmga007.fm.intel.com with ESMTP; 21 Dec 2022 05:37:09 -0800
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, xni@redhat.com
Subject: [PATCH v2 1/2] incremental, manage: do not verify if remove is safe
Date:   Wed, 21 Dec 2022 07:38:45 +0100
Message-Id: <20221221063846.20710-2-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20221221063846.20710-1-kinga.tanska@intel.com>
References: <20221221063846.20710-1-kinga.tanska@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Function is_remove_safe() was introduced to verify if removing
member device won't cause failed state of the array. This
verification should be used only with set-faulty command. Add
special mode indicating that Incremental removal was executed.
If this mode is used do not execute is_remove_safe() routine.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Incremental.c | 2 +-
 Manage.c      | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 5a5f4c4c..bccfdeb9 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1744,7 +1744,7 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
 
 	memset(&devlist, 0, sizeof(devlist));
 	devlist.devname = devname;
-	devlist.disposition = 'f';
+	devlist.disposition = 'I';
 	/* for a container, we must fail each member array */
 	if (ent->metadata_version &&
 	    strncmp(ent->metadata_version, "external:", 9) == 0) {
diff --git a/Manage.c b/Manage.c
index b1d0e630..1e7f9b56 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1496,8 +1496,9 @@ int Manage_subdevs(char *devname, int fd,
 			/* Assume this is a kernel-internal name like 'sda1' */
 			int found = 0;
 			char dname[55];
-			if (dv->disposition != 'r' && dv->disposition != 'f') {
-				pr_err("%s only meaningful with -r or -f, not -%c\n",
+			if (dv->disposition != 'r' && dv->disposition != 'f' &&
+			    dv->disposition != 'I') {
+				pr_err("%s only meaningful with -r, -f or -I, not -%c\n",
 					dv->devname, dv->disposition);
 				goto abort;
 			}
@@ -1649,7 +1650,7 @@ int Manage_subdevs(char *devname, int fd,
 					close(sysfd);
 				goto abort;
 			}
-
+		case 'I': /* incremental fail */
 			if ((sysfd >= 0 && write(sysfd, "faulty", 6) != 6) ||
 			    (sysfd < 0 && ioctl(fd, SET_DISK_FAULTY,
 						rdev))) {
-- 
2.26.2

