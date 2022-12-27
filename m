Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE490C4332F
	for <linux-raid@archiver.kernel.org>; Tue, 27 Dec 2022 12:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiL0MtD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 27 Dec 2022 07:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiL0MtB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 27 Dec 2022 07:49:01 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84404F12
        for <linux-raid@vger.kernel.org>; Tue, 27 Dec 2022 04:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672145340; x=1703681340;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CU2CIKL5Xx2Ryfk8LM4TxaA7RoJ+WxH0vPwC6D+cbJ0=;
  b=WXBgLpVIVTph9K6d8sq34nBQ99XPVeN+aJ7AUIo3CHm1Yavrcnm+CRJR
   j79JPIrzi/ViJs0LY915p7lOS+anttWexZDwJMOLrwBPbEcIL7+jbarmP
   hKvWMqU7bjZ267iNt+BeF1OYYMSm/XSw1abTQj1K1CBbTzkvGyLAg3ov+
   JMnfpvUEYhVhu6VH01aYutBko1cfFGhWjo62XkYbcEpMyDwhwmM4uCo6k
   2sM9lwPjwJEvc++8TkeBSJ5AkrBtnX0GJsTMWX8Hvzi7K6UgALTatGRgs
   VBlZbIzOKV1DKuzkTSc9vq/A4S39deSaew2GAmmGsv9/Jl6gnww/G0d+3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="385117695"
X-IronPort-AV: E=Sophos;i="5.96,278,1665471600"; 
   d="scan'208";a="385117695"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2022 04:49:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="646415743"
X-IronPort-AV: E=Sophos;i="5.96,278,1665471600"; 
   d="scan'208";a="646415743"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orsmga007.jf.intel.com with ESMTP; 27 Dec 2022 04:48:59 -0800
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, xni@redhat.com
Subject: [PATCH v3 2/3] incremental, manage: do not verify if remove is safe
Date:   Tue, 27 Dec 2022 06:50:43 +0100
Message-Id: <20221227055044.18168-3-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20221227055044.18168-1-kinga.tanska@intel.com>
References: <20221227055044.18168-1-kinga.tanska@intel.com>
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
index 157a2b98..48b479a7 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1495,8 +1495,9 @@ int Manage_subdevs(char *devname, int fd,
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
@@ -1648,7 +1649,7 @@ int Manage_subdevs(char *devname, int fd,
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

