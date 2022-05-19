Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF900C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 19 May 2022 00:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbiESAs0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 May 2022 20:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbiESAsP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 18 May 2022 20:48:15 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F283F313
        for <linux-raid@vger.kernel.org>; Wed, 18 May 2022 17:48:02 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id k16so3695108pff.5
        for <linux-raid@vger.kernel.org>; Wed, 18 May 2022 17:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B6MA4+HMYbPobnbYL1B2L1IK014KXRJf7a7TG+xfkZ8=;
        b=Z5bDlAZoAJZzaN0On3Z6T7UXu6nBH07V6MPFeCvzeYdB7AGHqgryugiokuZYFZ8ZGy
         EpudKlTFAPEab5DxDvnEy1lIzUNPCHMkCFsBv5BMABvUw1FexfGOxVs1Zdnha01KAYjb
         V0cqc2H2myg58EeZp9uWNZMXVwVLoxwwTgin8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B6MA4+HMYbPobnbYL1B2L1IK014KXRJf7a7TG+xfkZ8=;
        b=8Mx5HxJmG58Xrkzwmm4gpF5SeO1USOyfFnXhZHYBJ0mhsYPeZ0BKEu9nFz+PM6uscE
         kViqu/meHcuRln50m1/pLoWA/JBqDj6+aveIgxx1v8jguGul4y621XFPQWFq6kvS/c5f
         SXrVuf2XBN00xfZcDxP6hbXk6qD9oDePMRxXJc6T/+TMPXYPdOKrqeh/nExu9OSAw7mO
         l3U0rs17bBh4V05TXFx9Z6XktNP+2BaWC0igDasrw3go76RZeoBcbLUFNQndAuIiB97l
         shgPgIoUd8Wceyy5/0VvXegtZhRfJgyyWG9vR21yVkoZXyT+MzuvMtXVUADme4ZrNa1U
         RGmw==
X-Gm-Message-State: AOAM530ebulc4o5VResaPtCdW8yR3ECsoJgZY89gducVZnkbftn+w0ow
        fXMJy9CqIG52fiYkgZMZL/Oc7g==
X-Google-Smtp-Source: ABdhPJyMv1v72T0i8iVgL2HihKH/xs6LPltgtmNa5ruAuiR2wEA/c9aCEr6jXvMkXU6kAJcVSw0lsw==
X-Received: by 2002:a65:550c:0:b0:3da:fde8:62d7 with SMTP id f12-20020a65550c000000b003dafde862d7mr1783122pgr.334.1652921281818;
        Wed, 18 May 2022 17:48:01 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:e229:79ea:227e:d9dd])
        by smtp.gmail.com with UTF8SMTPSA id e11-20020a17090a9a8b00b001df4c27e5a5sm4154913pjp.35.2022.05.18.17.48.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 17:48:01 -0700 (PDT)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>
Cc:     Song Liu <song@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Milan Broz <gmazyland@gmail.com>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v5 3/3] dm: verity-loadpin: Use CONFIG_SECURITY_LOADPIN_VERITY for conditional compilation
Date:   Wed, 18 May 2022 17:47:54 -0700
Message-Id: <20220518174739.v5.3.I5aca2dcc3b06de4bf53696cd21329dce8272b8aa@changeid>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
In-Reply-To: <20220519004754.2174254-1-mka@chromium.org>
References: <20220519004754.2174254-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The verity glue for LoadPin is only needed when CONFIG_SECURITY_LOADPIN_VERITY
is set, use this option for conditional compilation instead of the combo of
CONFIG_DM_VERITY and CONFIG_SECURITY_LOADPIN.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
---

Changes in v5:
- added 'Acked-by' tag from Kees

Changes in v4:
- none

Changes in v3:
- none

Changes in v2:
- none

 drivers/md/Makefile               | 7 +------
 include/linux/dm-verity-loadpin.h | 2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 71771901c823..a96441752ec7 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_DM_LOG_WRITES)	+= dm-log-writes.o
 obj-$(CONFIG_DM_INTEGRITY)	+= dm-integrity.o
 obj-$(CONFIG_DM_ZONED)		+= dm-zoned.o
 obj-$(CONFIG_DM_WRITECACHE)	+= dm-writecache.o
+obj-$(CONFIG_SECURITY_LOADPIN_VERITY)	+= dm-verity-loadpin.o
 
 ifeq ($(CONFIG_DM_INIT),y)
 dm-mod-objs			+= dm-init.o
@@ -108,12 +109,6 @@ ifeq ($(CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG),y)
 dm-verity-objs			+= dm-verity-verify-sig.o
 endif
 
-ifeq ($(CONFIG_DM_VERITY),y)
-ifeq ($(CONFIG_SECURITY_LOADPIN),y)
-dm-verity-objs			+= dm-verity-loadpin.o
-endif
-endif
-
 ifeq ($(CONFIG_DM_AUDIT),y)
 dm-mod-objs			+= dm-audit.o
 endif
diff --git a/include/linux/dm-verity-loadpin.h b/include/linux/dm-verity-loadpin.h
index d37146dbb1a8..ac5d9f56c3a3 100644
--- a/include/linux/dm-verity-loadpin.h
+++ b/include/linux/dm-verity-loadpin.h
@@ -15,7 +15,7 @@ struct trusted_root_digest {
 	u8 data[];
 };
 
-#if IS_ENABLED(CONFIG_SECURITY_LOADPIN) && IS_BUILTIN(CONFIG_DM_VERITY)
+#if IS_ENABLED(CONFIG_SECURITY_LOADPIN_VERITY)
 bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev);
 #else
 static inline bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev)
-- 
2.36.1.124.g0e6072fb45-goog

