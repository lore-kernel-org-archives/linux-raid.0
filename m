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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD02C47084
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45C49613FA
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbhEYJuA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 May 2021 05:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbhEYJto (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 May 2021 05:49:44 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CFAC061342
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:47:15 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id 69so16084053plc.5
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1QMx24lxJt/AmZQrIDSqtg7B6PBNRHyo2P9UslB599E=;
        b=aimoSS9AVPnsHN/Ev0Auqhz+rK1ZufEcTkFrH26eOjIGpFerpyy+QUv3BiDTsujDEQ
         i6BkjhPz/duaGG6/v2MyFemOTf/5p7utEXe+G45L8nJTm5GyDBZrlj/Pjl0DZGowjOEN
         O/4EjYBVJ19ssoJoY2Egv1TR6C7ADsiFyTr7dTdr+d24kguhMIxJJlSzg+8CRrLFRNiO
         Us+mkLbAkUTHN45TOWfQu31T3Meu0f0AcK7VmiKQHMl8dLu8uP3i+xhIICpEaDHCwdiM
         bZGixjd13s9frtR1p+mG0eGEQjT493jjkAIMKklLG+W+IiAWEBN7EzZ8FSm+RzwxMH5f
         bNWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1QMx24lxJt/AmZQrIDSqtg7B6PBNRHyo2P9UslB599E=;
        b=frSUDa4ZF6UuAQeL0gZooF+CuZFtDVqHzEcf0NuoUb6f3d1lCNNbhgWqm/9pdr+DuH
         xQlXhOh+SwhIVl5XGvs9Pga5/zlmJjYOW/+5pBwRSzuxr890XKYld3iNuNS5phtgbK0Y
         G0oPNcDaUKPVOV4v1iLtgqyEd6aO+MaN5ObjP3uIS2+rTtN78Bw3liw67JZxQ7ZjB3Tl
         9SmZ/YqQcGI+EsrYVAhr9NyH1RqitsN7fArKKaek0p3+MrChCI6nhEy1OFYlwp8lur/1
         qMkr55DeGu3AFktJqjEMwyyRTO/xe2/pS5is0HFCmf673RmAxbz2319gx0ctJa/jdj50
         Po1w==
X-Gm-Message-State: AOAM533B0zonHbvuae7X3mn+dDB8nG7YH7SDhsTLIX5u6vllUbzxRTLw
        HtI0RP/9qDZymKI7SV/euUM=
X-Google-Smtp-Source: ABdhPJwuQmKOg5mCfoZFp/tGEn8XT2tpHwPDYPE4956PEuKiBk7xuUnENsSbweTG6XmKt4h0qRXJrQ==
X-Received: by 2002:a17:90a:d90a:: with SMTP id c10mr29346550pjv.209.1621936035359;
        Tue, 25 May 2021 02:47:15 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id r10sm13114437pfl.159.2021.05.25.02.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 02:47:15 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com,
        hch@infradead.org
Subject: [PATCH V3 8/8] md: mark some personalities as deprecated
Date:   Tue, 25 May 2021 17:46:23 +0800
Message-Id: <20210525094623.763195-9-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Mark the three personalities (linear, fault and multipath) as deprecated
because:

1. people can use dm multipath or nvme multipath.
2. linear is already deprecated in MODULE_ALIAS.
3. no one actively using fault.

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

