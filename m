Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60ACFC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 17 May 2022 23:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiEQXfM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 May 2022 19:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbiEQXfG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 May 2022 19:35:06 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8334D527DF
        for <linux-raid@vger.kernel.org>; Tue, 17 May 2022 16:35:05 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id j6so495475pfe.13
        for <linux-raid@vger.kernel.org>; Tue, 17 May 2022 16:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dDud8QpcHOOGMYFVwG6KRCTw7kIHDGrPd+sI68v2xZg=;
        b=GPXx2iWGpvjahWJ/eNt1vuxX+XfXwsKDhFEE5llZ+iBUQkHBDl8Q1os/RQzkoSp4Xw
         oTtcxIKjZMu/LrvUzup2xopqBZYgA6GQbmmxYEoGNvGbf76Qscn6owliQXAnB1t6K2DR
         4P2qMtKQ+M3+qEFrUp0umfBe7sJ+lxeus7J2A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dDud8QpcHOOGMYFVwG6KRCTw7kIHDGrPd+sI68v2xZg=;
        b=s1nay0EDkXLAzX1ZUlHr+ZsQTci3YXPVxOgy56uHolZ7cEvy2JlNgOR97XVQbaiqzB
         /54vlFTMo/fC73DP/D9xeXBhmjbemZLzTwpKhOGtH7DpAIuVgdHZJKP3HZopYcIymge6
         hfsajS2tXJbXDtBVxRnPn0GREqHl0oe8aIKWNlS0tsKURKkFyV+4bt4SLexZKXci932K
         6YxoluIFSerxlpOAKDATFGcq6BhlwVg96R6O5YBTmUkyq0aqlt0pvJhwW9FSXdwZLdEA
         H9qUHpmX6GA6EwrYyLeA8fu8u7UU6d/UIrczkc5ZTAL1joDgzLaMgi5WV4aPkumg4Mjf
         SaSg==
X-Gm-Message-State: AOAM530cwZY81OuSPHHV+bds4FtAaXpBxghk5XMrtyFF8puc6UXdS/wn
        zJylO/iMv6+ys+fkn4qZ63WBTg==
X-Google-Smtp-Source: ABdhPJyZj+2Vn+6W69AKPRTh2wk4PKvqzqVqTA63hYJRVSIAYcQ/O1m9fMYTQtqsbh7pki5RFa2oow==
X-Received: by 2002:a05:6a00:298a:b0:50e:8e3:b673 with SMTP id cj10-20020a056a00298a00b0050e08e3b673mr24631943pfb.28.1652830505085;
        Tue, 17 May 2022 16:35:05 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:a14:3166:4b67:b688])
        by smtp.gmail.com with UTF8SMTPSA id l17-20020a170903245100b001617e18e253sm162705pls.143.2022.05.17.16.35.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 16:35:04 -0700 (PDT)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>
Cc:     linux-security-module@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v4 3/3] dm: verity-loadpin: Use CONFIG_SECURITY_LOADPIN_VERITY for conditional compilation
Date:   Tue, 17 May 2022 16:34:57 -0700
Message-Id: <20220517163437.v4.3.I5aca2dcc3b06de4bf53696cd21329dce8272b8aa@changeid>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220517233457.1123309-1-mka@chromium.org>
References: <20220517233457.1123309-1-mka@chromium.org>
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
index c2bfd2b9c651..dd66ece9a751 100644
--- a/include/linux/dm-verity-loadpin.h
+++ b/include/linux/dm-verity-loadpin.h
@@ -15,7 +15,7 @@ struct trusted_root_digest {
 	u8 data[];
 };
 
-#if IS_ENABLED(CONFIG_SECURITY_LOADPIN) && IS_BUILTIN(CONFIG_DM_VERITY)
+#if IS_ENABLED(CONFIG_SECURITY_LOADPIN_VERITY)
 bool dm_verity_loadpin_is_sb_trusted(struct super_block *sb);
 #else
 static inline bool dm_verity_loadpin_is_sb_trusted(struct super_block *sb);
-- 
2.36.0.550.gb090851708-goog

