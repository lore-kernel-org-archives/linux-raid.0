Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57391C04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 15:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbiG1PzF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 11:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbiG1Pyr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 11:54:47 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB61A6C122
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 08:54:46 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id bh13so1859917pgb.4
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 08:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kU+1umJQF2o/NXaZ6DOn2fpiiayOd6S6bPdTx2dKd/k=;
        b=dcP32hnVDAltE5oC+wFB7l+/9L6Z/Bg5HW+o9yRipBBv5uJDAQXieFFGffT0dNJZ7l
         zEqG4XhEhIB0FrK93YOLQ4BJORQ8hjBdq2MOry8P8m+EZz0Cz2Rj7fHJJ1k3L22PNqoW
         9YBcW2a6vn5f+takyY6WspSt+E5TvXmdfcbNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kU+1umJQF2o/NXaZ6DOn2fpiiayOd6S6bPdTx2dKd/k=;
        b=Jd4DQaP7HZ2mKff/zvc/e0aPLJXkmSCUrVttuwWxystUxS9MZn51N2fU9viSr9fB7h
         Hq+wZrulfSSiV2OGFZRDPlqQBrF7UCbP5LqFeV72MK2RZ9hMlLLcKoTxptGv0AvARM5s
         HbtT8E75ybS184utHF2AToAmle3HaukAtJu5/V8aAuYXmYQkNYHRe11usBiFMbhypV7E
         LLuDX39Mu1JstTCbE/5knTX8ilRwYdfu1JEDlQfWWOLEaF81nYp7iO6ojn/e35M43sYi
         jWAKGEgO41mdjHQmB/bQpTgMPF/dqQNzd84POA28r80/8coxuLy72aguHaMLQ70VdDGV
         PaRA==
X-Gm-Message-State: AJIora8egOtY8Q4VJmYwKBFGYqBqtSzCFl2/Zu5FebLv1FLx3CMBliB5
        5xCwRcit0TdRNfH/0kVeQLu+XA==
X-Google-Smtp-Source: AGRyM1uEQZQL0BQQkR3RNvEAFIjhq7+7MXq8qU7ybWJ2B13O/5RNLqRZS5pTd/rmE0sG+MnN8+l1Xg==
X-Received: by 2002:a05:6a00:234c:b0:52b:7cb:ed9d with SMTP id j12-20020a056a00234c00b0052b07cbed9dmr27527599pfj.32.1659023686099;
        Thu, 28 Jul 2022 08:54:46 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:bb10:e729:7f59:7cbc])
        by smtp.gmail.com with UTF8SMTPSA id i6-20020a626d06000000b0052c70770b24sm974115pfc.40.2022.07.28.08.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 08:54:45 -0700 (PDT)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>
Cc:     Douglas Anderson <dianders@chromium.org>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org,
        Milan Broz <gmazyland@gmail.com>, linux-raid@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Matthias Kaehlcke <mka@chromium.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] dm: verity-loadpin: Drop use of dm_table_get_num_targets()
Date:   Thu, 28 Jul 2022 08:54:41 -0700
Message-Id: <20220728085412.1.I242d21b378410eb6f9897a3160efb56e5608c59d@changeid>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Commit 2aec377a2925 ("dm table: remove dm_table_get_num_targets()
wrapper") in linux-dm/for-next removed the function
dm_table_get_num_targets() which is used by verity-loadpin. Access
table->num_targets directly instead of using the defunct wrapper.

Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---

 drivers/md/dm-verity-loadpin.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
index 10c18bc1652c..387ec43aef72 100644
--- a/drivers/md/dm-verity-loadpin.c
+++ b/drivers/md/dm-verity-loadpin.c
@@ -5,6 +5,7 @@
 #include <linux/dm-verity-loadpin.h>
 
 #include "dm.h"
+#include "dm-core.h"
 #include "dm-verity.h"
 
 #define DM_MSG_PREFIX	"verity-loadpin"
@@ -58,7 +59,7 @@ bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev)
 
 	table = dm_get_live_table(md, &srcu_idx);
 
-	if (dm_table_get_num_targets(table) != 1)
+	if (table->num_targets != 1)
 		goto out;
 
 	ti = dm_table_get_target(table, 0);
-- 
2.37.1.455.g008518b4e5-goog

