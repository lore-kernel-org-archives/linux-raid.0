Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778A9C43460
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 00:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CE9560200
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 00:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235682AbhEUA6L (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 May 2021 20:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbhEUA6L (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 May 2021 20:58:11 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B786C061574
        for <linux-raid@vger.kernel.org>; Thu, 20 May 2021 17:56:49 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t11so10094353pjm.0
        for <linux-raid@vger.kernel.org>; Thu, 20 May 2021 17:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TJ+ugSMBveGjJPz9FWfTCPInHoXljdl8ktAdDJPI8Rc=;
        b=kakcR4dzKIjNhpqxYJBB2iv1tHknjutNEcDHaJDGFcpiR7VpTeMJbMHirIwt+jpIpH
         6QUi8FvNR2b1waeLdjCjssoV/r8O0f5UVJe+6HPXvypyPxvuCvt5Qm6OTSpvHdYiXZaF
         G/HFvSaILedxENWlpc18TPsKTCtlv0mjTo3XziPObC+SDXyxS9rV12R9ZzjSEkMWE7MN
         dPab2p7kWDhBb7tj5PxSzeq/93PPzb5GNQ1Hi0wkYY0YsrZUHkt7//yHnfeAXyV+98Of
         00sSEQclEzFK7Ct2lJKQ75PaHHHCxmvrTK2jldh22Buc/Mz4ZznqIznkMdqq1PwMRy7L
         9a8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TJ+ugSMBveGjJPz9FWfTCPInHoXljdl8ktAdDJPI8Rc=;
        b=YRJNNS98jBFOO0rYq39jlREZ3gtEZ8aFJpeOjLx9mYm+hehgCcaXGxp4n//a3K9Ehe
         pWSqVJ64s5/UzpCMxuNOc2QRRnaayPzMR8mkIGqfBlR8zBZOCDfb/jdwyMqYBd7XI+xf
         U0SaLNdj6uVY1N7/e7h3+N+QIEd9GhE5uBSn/os7QrzqF03Ookx972H5llGjqvIwLS0B
         ATp1neXAlfAbj5vkE7W9FTsld5PWw5EZHkQGzFy3tRNx5r3IyCxAiOevYBjKvLfhZ3Cy
         G/anqIESD8O9NC4shnx5ClPetEjEeYhRTmRs8p2NdX0q/9s0VthS9QIcPVwCJxFjRvzZ
         8v+g==
X-Gm-Message-State: AOAM531ex3AbAT9sywPvZQbyhKKkvZ1+uJw/C9xdGbvsA9V1QRB4+RjV
        cyVPV1O17iLoClwrBTh+zM4=
X-Google-Smtp-Source: ABdhPJxfNSCEQZukqvM20sYWw7LMUSqjQm6lm8O4A6MlZ94sxljHYXpLmEbmIB5LaA/9U2jgyVzXig==
X-Received: by 2002:a17:902:c951:b029:ef:9dca:9943 with SMTP id i17-20020a170902c951b02900ef9dca9943mr9122868pla.62.1621558608905;
        Thu, 20 May 2021 17:56:48 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id 5sm7405945pjo.17.2021.05.20.17.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 17:56:48 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
Subject: [PATCH V2 7/7] md: mark some personalities as deprecated
Date:   Fri, 21 May 2021 08:55:21 +0800
Message-Id: <20210521005521.713106-8-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
References: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Mark the three personalities (linear, fault and multipath) as deprecated
because:

1. people usually use dm multipath or nvme multipath.
2. linear is already deprecated in MODULE_ALIAS.
3. no active development and user for fault from my understanding.

Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
---
 drivers/md/Kconfig        | 6 +++---
 drivers/md/md-faulty.c    | 2 +-
 drivers/md/md-linear.c    | 2 +-
 drivers/md/md-multipath.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index f2014385d48b..0602e82a9516 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -47,7 +47,7 @@ config MD_AUTODETECT
 	  If unsure, say Y.
 
 config MD_LINEAR
-	tristate "Linear (append) mode"
+	tristate "Linear (append) mode (deprecated)"
 	depends on BLK_DEV_MD
 	help
 	  If you say Y here, then your multiple devices driver will be able to
@@ -158,7 +158,7 @@ config MD_RAID456
 	  If unsure, say Y.
 
 config MD_MULTIPATH
-	tristate "Multipath I/O support"
+	tristate "Multipath I/O support (deprecated)"
 	depends on BLK_DEV_MD
 	help
 	  MD_MULTIPATH provides a simple multi-path personality for use
@@ -169,7 +169,7 @@ config MD_MULTIPATH
 	  If unsure, say N.
 
 config MD_FAULTY
-	tristate "Faulty test module for MD"
+	tristate "Faulty test module for MD (deprecated)"
 	depends on BLK_DEV_MD
 	help
 	  The "faulty" module allows for a block device that occasionally returns
diff --git a/drivers/md/md-faulty.c b/drivers/md/md-faulty.c
index fda4cb3f936f..c0dc6f2ef4a3 100644
--- a/drivers/md/md-faulty.c
+++ b/drivers/md/md-faulty.c
@@ -357,7 +357,7 @@ static void raid_exit(void)
 module_init(raid_init);
 module_exit(raid_exit);
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Fault injection personality for MD");
+MODULE_DESCRIPTION("Fault injection personality for MD (deprecated)");
 MODULE_ALIAS("md-personality-10"); /* faulty */
 MODULE_ALIAS("md-faulty");
 MODULE_ALIAS("md-level--5");
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 63ed8329a98d..1ff51647a682 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -312,7 +312,7 @@ static void linear_exit (void)
 module_init(linear_init);
 module_exit(linear_exit);
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Linear device concatenation personality for MD");
+MODULE_DESCRIPTION("Linear device concatenation personality for MD (deprecated)");
 MODULE_ALIAS("md-personality-1"); /* LINEAR - deprecated*/
 MODULE_ALIAS("md-linear");
 MODULE_ALIAS("md-level--1");
diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index 776bbe542db5..e7d6486f090f 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -471,7 +471,7 @@ static void __exit multipath_exit (void)
 module_init(multipath_init);
 module_exit(multipath_exit);
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("simple multi-path personality for MD");
+MODULE_DESCRIPTION("simple multi-path personality for MD (deprecated)");
 MODULE_ALIAS("md-personality-7"); /* MULTIPATH */
 MODULE_ALIAS("md-multipath");
 MODULE_ALIAS("md-level--4");
-- 
2.25.1

