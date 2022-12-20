Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40786C10F1E
	for <linux-raid@archiver.kernel.org>; Tue, 20 Dec 2022 12:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbiLTMNI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Dec 2022 07:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbiLTMNE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Dec 2022 07:13:04 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF547186F9
        for <linux-raid@vger.kernel.org>; Tue, 20 Dec 2022 04:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671538382; x=1703074382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JcXExH1bTi2M8kzChql4QSXITGpeF6VYz9N932ZH6GI=;
  b=MkSJVw6cea61VZE/4PtZ9cF2aafSSbN5p/r6qhso3hwRwl/bTj/ggjpx
   HihU6FTkRlIg+oN/PGHlEwjP0x/XqqAuxLPcAfVjGpPPEzW2eXcbRFN77
   TC9A3Ks7tSMPdGY09+AOwjBSznrc1EcLfKVjvUpotrlrORmWKcRPheGla
   5fahXGNWOGu2l8FPyV5rMRttEqnTDh6TvXaTuf6DMxO4Rj04V1Ob3OICU
   BdR/eCqT8JazPabUa2ugOvicpoG25lvckuXsZrW4J5lZwzsUNt9tWGMfT
   7u88OUZBXttrMtuIbyuTYV8pjpAILbhUDgPHMDkGY84xYbrOwrM2nWl7L
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="405846284"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="405846284"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 04:13:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="628700773"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="628700773"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orsmga006.jf.intel.com with ESMTP; 20 Dec 2022 04:13:01 -0800
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, xni@redhat.com
Subject: [PATCH 1/2] incremental, manage: do not verify if remove is safe
Date:   Tue, 20 Dec 2022 06:14:32 +0100
Message-Id: <20221220051433.14987-2-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20221220051433.14987-1-kinga.tanska@intel.com>
References: <20221220051433.14987-1-kinga.tanska@intel.com>
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

