Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31540C4332F
	for <linux-raid@archiver.kernel.org>; Wed, 21 Dec 2022 12:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbiLUMxA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Dec 2022 07:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiLUMw6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Dec 2022 07:52:58 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31E02330F
        for <linux-raid@vger.kernel.org>; Wed, 21 Dec 2022 04:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671627177; x=1703163177;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xXhGB685zT7K+zLs++6cC0rbfQ2HoZ87FtjTFaLyVuk=;
  b=dKHXCb3zaxWwbJXtDTutyBINzuZcVHCVjWaWvZH9IkbycH+mrvAeHNjA
   bmEpUM8N3w7jNe+JjMRKqE1NEmEkJcfQ7q0jDKqCxyq71U9FAiEwgFocE
   S9OH/3INhyQQQhcm5847xoLd+Ppgb0EP/QX2+T33zDvYkbdzVOHP9h9nD
   MBxHdOh0CbtDmbao/j7j1gdj4vka8u7bOr6En5ykWjkq1xu8tIyHoKfmF
   WeMSrIzGJeBKQMuXJO0XUL6hehY1QtipRlsGwFUaz6eXpskAMcZ9tG/04
   XQl6uirgK/+o/d//m8s0N99DispBK1MajijA9D8hqETP3NmFbpu11mlIL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="382088189"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="382088189"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 04:52:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="719937912"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="719937912"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by fmsmga004.fm.intel.com with ESMTP; 21 Dec 2022 04:52:56 -0800
From:   Blazej Kucman <blazej.kucman@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH V2] Grow: fix possible memory leak
Date:   Wed, 21 Dec 2022 13:52:54 +0100
Message-Id: <20221221125254.17932-1-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In function Grow_addbitmap, struct mdinfo
may be allocated but is not freed
in few exit paths. Add free 'mdi' variable
in missing exit paths to avoid possible memory leak.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 Grow.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index e362403a..b73ec2ae 100644
--- a/Grow.c
+++ b/Grow.c
@@ -432,6 +432,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 			if (((disk.state & (1 << MD_DISK_WRITEMOSTLY)) == 0) &&
 			   (strcmp(s->bitmap_file, "clustered") == 0)) {
 				pr_err("%s disks marked write-mostly are not supported with clustered bitmap\n",devname);
+				free(mdi);
 				return 1;
 			}
 			fd2 = dev_open(dv, O_RDWR);
@@ -453,8 +454,10 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 				pr_err("failed to load super-block.\n");
 			}
 			close(fd2);
-			if (rv)
+			if (rv) {
+				free(mdi);
 				return 1;
+			}
 		}
 		if (offset_setable) {
 			st->ss->getinfo_super(st, mdi, NULL);
-- 
2.35.3

