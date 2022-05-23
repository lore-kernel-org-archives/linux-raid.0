Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95569C4332F
	for <linux-raid@archiver.kernel.org>; Mon, 23 May 2022 21:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiEWVO1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 May 2022 17:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiEWVOJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 23 May 2022 17:14:09 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8093F7CDFD
        for <linux-raid@vger.kernel.org>; Mon, 23 May 2022 14:14:08 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id a38so11837220pgl.9
        for <linux-raid@vger.kernel.org>; Mon, 23 May 2022 14:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7sQ9oR+xbg8R35wvoreY201E08AeVxeiXWdeAF7cXRM=;
        b=iNUjyOKjFHBZM89PlCmEcdOGkthobgiSyYUS457qK0QaLGGsWpcgsGmcklWVDWuzmI
         KqTv3dF1RgTfgEThOWi4q26pvTJeVo4ejWLwnmJ56VsIl0HRjxD2PvQphSv7alg9+vrg
         idzlpqgNvFzuYyIGn7F56jBsDWN1CAUUn0bY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7sQ9oR+xbg8R35wvoreY201E08AeVxeiXWdeAF7cXRM=;
        b=eEUmeDRi73XcRJxOqr5WUWKIX41gVwLHYl76/HCBl6Wr3SoO+f/9xOJDmG3AYxj0bw
         xv6r5x3D81KrHMKj89D10+n2x2N3AzoNtjdOWG5J38LQUFegr6YS8uaGNWXqay5/Ko1V
         uhTl2C6vNHm/mPR+KqHu2Zx0L8sO8VbAxgYZSPxmqJO88t7Lgexal0Lukec0yXIcnhIW
         +w3tdwBSojgx4MWMBAkk9xQ4mobMKYpscnB1K13bHAXxf+tZ/Zmtp2txSg3TmudT6246
         nfv0uA8Tk8fLo7UME0007vtQm3BOSFi+PAbNH5jhyoigkWPGLdRIOCirdTzB2rImE/iu
         oaTA==
X-Gm-Message-State: AOAM533Ou4A50rJq1GMz2MPw5zXMBn4gfxahg+D5xDzbhP2mLm2js5ry
        0GScSTEsXBMgT/7wNlCZHziMUg==
X-Google-Smtp-Source: ABdhPJwjJqrTLcWA+nZYZEnU+6VaXKXbwTOJORpnOZ2WXLEU4bYD4BuxvIye0UbjX4g50uxPfvLoDg==
X-Received: by 2002:a63:82c7:0:b0:3f9:e153:6a54 with SMTP id w190-20020a6382c7000000b003f9e1536a54mr12840592pgd.409.1653340448097;
        Mon, 23 May 2022 14:14:08 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:d9e2:8472:9ac:8532])
        by smtp.gmail.com with UTF8SMTPSA id s17-20020a170903215100b0015e8d4eb1b7sm5571230ple.1.2022.05.23.14.14.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 14:14:07 -0700 (PDT)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>
Cc:     Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        linux-security-module@vger.kernel.org,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v6 3/3] dm: verity-loadpin: Use CONFIG_SECURITY_LOADPIN_VERITY for conditional compilation
Date:   Mon, 23 May 2022 14:14:00 -0700
Message-Id: <20220523141325.v6.3.I5aca2dcc3b06de4bf53696cd21329dce8272b8aa@changeid>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
In-Reply-To: <20220523211400.290537-1-mka@chromium.org>
References: <20220523211400.290537-1-mka@chromium.org>
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

Changes in v6:
- none

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
index fb695ecaa5d5..552b817ab102 100644
--- a/include/linux/dm-verity-loadpin.h
+++ b/include/linux/dm-verity-loadpin.h
@@ -15,7 +15,7 @@ struct dm_verity_loadpin_trusted_root_digest {
 	u8 data[];
 };
 
-#if IS_ENABLED(CONFIG_SECURITY_LOADPIN) && IS_BUILTIN(CONFIG_DM_VERITY)
+#if IS_ENABLED(CONFIG_SECURITY_LOADPIN_VERITY)
 bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev);
 #else
 static inline bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev)
-- 
2.36.1.124.g0e6072fb45-goog

