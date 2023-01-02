Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082F0C4167B
	for <linux-raid@archiver.kernel.org>; Mon,  2 Jan 2023 08:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjABIqm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Jan 2023 03:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjABIqk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Jan 2023 03:46:40 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8B7D94
        for <linux-raid@vger.kernel.org>; Mon,  2 Jan 2023 00:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672649200; x=1704185200;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZD2oeSABUsSRJi/rjXttjPQ96LHnnKOQn/tz5Wt03js=;
  b=IAnfsYAS3wce/iO3AMck6nUKAKifkuh8qGbXtJ+YqVIQGQ39CP6m6xUq
   tPXJvw4Lh8zrPdeyg2Bop11ViaEWddcmW7x/+Ffoj5zcVwDm4air/UGYD
   IciKHpHFk2j2Zvp7qlpFB7VbT3PTCNe2D6Geyl2YrGp1YE421+lYteJ0f
   l694ZTN+c18eaIy9/S2BgYXjRneMgu+mZ8a/zMbSzCz7pzMZ8Zx77vzPf
   hoI7REiwG88BJ+wytcoLtk1VbZzbzMMjSutEp6FwtJrp8UGr5kI2UYAKT
   yfZaKs3aZ4+Du5t9U64qEEGYxmOLvd+h/Lqhu8nCjCtlU2duVqB+EtMot
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="309222353"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="309222353"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2023 00:46:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="983243915"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="983243915"
Received: from unknown (HELO DESKTOP-QODMV9C.igk.intel.com.com) ([10.102.109.29])
  by fmsmga005.fm.intel.com with ESMTP; 02 Jan 2023 00:46:38 -0800
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 1/2] mdmon: fix segfault
Date:   Mon,  2 Jan 2023 09:46:21 +0100
Message-Id: <20230102084622.29154-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Mdmon crashes if stat2devnm returns null.
Use open_mddev to check if device is mddevice and get name using
fd2devnm.
Refactor container name handling.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Makefile |  2 +-
 mdmon.c  | 26 ++++++++++++--------------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/Makefile b/Makefile
index ec1f99ed..5eac1a4e 100644
--- a/Makefile
+++ b/Makefile
@@ -160,7 +160,7 @@ SRCS =  $(patsubst %.o,%.c,$(OBJS))
 
 INCL = mdadm.h part.h bitmap.h
 
-MON_OBJS = mdmon.o monitor.o managemon.o uuid.o util.o maps.o mdstat.o sysfs.o \
+MON_OBJS = mdmon.o monitor.o managemon.o uuid.o util.o maps.o mdstat.o sysfs.o config.o mapfile.o mdopen.o\
 	policy.o lib.o \
 	Kill.o sg_io.o dlink.o ReadMe.o super-intel.o \
 	super-mbr.o super-gpt.o \
diff --git a/mdmon.c b/mdmon.c
index e9d035eb..ecf52dc8 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -363,14 +363,14 @@ int main(int argc, char *argv[])
 	}
 
 	if (all == 0 && container_name == NULL) {
-		if (argv[optind])
-			container_name = argv[optind];
+		if (argv[optind]) {
+			container_name = get_md_name(argv[optind]);
+			if (!container_name)
+				container_name = argv[optind];
+		}
 	}
 
-	if (container_name == NULL)
-		usage();
-
-	if (argc - optind > 1)
+	if (container_name == NULL || argc - optind > 1)
 		usage();
 
 	if (strcmp(container_name, "/proc/mdstat") == 0)
@@ -402,21 +402,19 @@ int main(int argc, char *argv[])
 		free_mdstat(mdstat);
 
 		return status;
-	} else if (strncmp(container_name, "md", 2) == 0) {
-		int id = devnm2devid(container_name);
-		if (id)
-			devnm = container_name;
 	} else {
-		struct stat st;
+		int mdfd = open_mddev(container_name, 1);
 
-		if (stat(container_name, &st) == 0)
-			devnm = xstrdup(stat2devnm(&st));
+		if (mdfd < 0)
+			return 1;
+		devnm = fd2devnm(mdfd);
+		close(mdfd);
 	}
 
 	if (!devnm) {
 		pr_err("%s is not a valid md device name\n",
 			container_name);
-		exit(1);
+		return 1;
 	}
 	return mdmon(devnm, dofork && do_fork(), takeover);
 }
-- 
2.26.2

