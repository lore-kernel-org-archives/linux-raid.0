Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8263C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  4 May 2022 19:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243089AbiEDT6K (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 4 May 2022 15:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377745AbiEDT6H (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 4 May 2022 15:58:07 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DD34EA36
        for <linux-raid@vger.kernel.org>; Wed,  4 May 2022 12:54:29 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x18so2385251plg.6
        for <linux-raid@vger.kernel.org>; Wed, 04 May 2022 12:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qM82pLe5LIpNsG3poDlPVKU5bEYefBi/IlcSrVO4JAI=;
        b=neUBEwGA4kq8JLwN5POTUHELuHm+l5M7u79I7XDLezrivLCU1aE6AFNc57wWU+0ODY
         9N0fRDhZ0iUfFp3kqga3HicjJzX8kYd9uLjlyBcfk0hPy4NyqkuuifzyrRzn8XzhgtH4
         CCEL3s0utu1QINUSJ+cZwchHFdenNYLU5VxWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qM82pLe5LIpNsG3poDlPVKU5bEYefBi/IlcSrVO4JAI=;
        b=Fc7oXUtYHwQZlAMADe2NRzoAr7qIoHrzSzzCPukuSG1ydDbky6CXsUhuydSCD9hVKD
         5w8yHpY2/NLOCATuOylqi4tLr7x0rUYc/jQZZE0w2rgLshLwhPrw7xoH+LDu/7rdxFwr
         0Gtn9vxW5Z7sd1nlekB3QgueAM+CnqpKz/Rf6bSTCreu5HQ+o659abSFPPI23DcxYxEg
         mv78/D5qDFvmlz+CmSocqsHGppYs2jtEiknZeX7LbIf5m5C4rPa9Y+MG2o/yu3/GS0zg
         o1nFO2tfqUeDseT3N29tLv2zWTQ2xS4DVN/NiL4P6BTN1PSxDy1by7pOMQOLeqsBfMdb
         0lWA==
X-Gm-Message-State: AOAM532nOYAds1JvvrU6+CS8URV1Cxtp5OzsTP6mNpb7kemyrBlPBBHJ
        aDiPpMAIhQoz1mOmFaGJHJhZlg==
X-Google-Smtp-Source: ABdhPJyQN0M+9153jv/w/MlWINhzXu1GoODr13+92d+vbgDekp0dhUhMFOATx1GkA2fDTz3kWcPUcw==
X-Received: by 2002:a17:903:1249:b0:15e:8b15:b7d2 with SMTP id u9-20020a170903124900b0015e8b15b7d2mr24555926plh.150.1651694068934;
        Wed, 04 May 2022 12:54:28 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:35b6:c77b:be04:3bd5])
        by smtp.gmail.com with UTF8SMTPSA id t3-20020a17090aae0300b001d5e1b124a0sm3727332pjq.7.2022.05.04.12.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 12:54:28 -0700 (PDT)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        linux-security-module@vger.kernel.org,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v3 3/3] dm: verity-loadpin: Use CONFIG_SECURITY_LOADPIN_VERITY for conditional compilation
Date:   Wed,  4 May 2022 12:54:19 -0700
Message-Id: <20220504125404.v3.3.I5aca2dcc3b06de4bf53696cd21329dce8272b8aa@changeid>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
In-Reply-To: <20220504195419.1143099-1-mka@chromium.org>
References: <20220504195419.1143099-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The verity glue for LoadPin is only needed when CONFIG_SECURITY_LOADPIN_VERITY
is set, use this option for conditional compilation instead of the combo of
CONFIG_DM_VERITY and CONFIG_SECURITY_LOADPIN.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---

Changes in v3:
- none

Changes in v2:
- none

 drivers/md/Makefile               | 7 +------
 include/linux/dm-verity-loadpin.h | 2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index e12cd004d375..a96441752ec7 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_DM_LOG_WRITES)	+= dm-log-writes.o
 obj-$(CONFIG_DM_INTEGRITY)	+= dm-integrity.o
 obj-$(CONFIG_DM_ZONED)		+= dm-zoned.o
 obj-$(CONFIG_DM_WRITECACHE)	+= dm-writecache.o
+obj-$(CONFIG_SECURITY_LOADPIN_VERITY)	+= dm-verity-loadpin.o
 
 ifeq ($(CONFIG_DM_INIT),y)
 dm-mod-objs			+= dm-init.o
@@ -100,12 +101,6 @@ ifeq ($(CONFIG_IMA),y)
 dm-mod-objs			+= dm-ima.o
 endif
 
-ifeq ($(CONFIG_DM_VERITY),y)
-ifeq ($(CONFIG_SECURITY_LOADPIN),y)
-dm-mod-objs			+= dm-verity-loadpin.o
-endif
-endif
-
 ifeq ($(CONFIG_DM_VERITY_FEC),y)
 dm-verity-objs			+= dm-verity-fec.o
 endif
diff --git a/include/linux/dm-verity-loadpin.h b/include/linux/dm-verity-loadpin.h
index 12a86911d05a..be63ac76f98d 100644
--- a/include/linux/dm-verity-loadpin.h
+++ b/include/linux/dm-verity-loadpin.h
@@ -13,7 +13,7 @@ struct trusted_root_digest {
 	struct list_head node;
 };
 
-#if IS_ENABLED(CONFIG_SECURITY_LOADPIN) && IS_BUILTIN(CONFIG_DM_VERITY)
+#if IS_ENABLED(CONFIG_SECURITY_LOADPIN_VERITY)
 void dm_verity_loadpin_set_trusted_root_digests(struct list_head *digests);
 bool dm_verity_loadpin_is_md_trusted(struct mapped_device *md);
 #else
-- 
2.36.0.464.gb9c8b46e94-goog

