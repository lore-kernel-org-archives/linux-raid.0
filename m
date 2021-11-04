Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8527C433F5
	for <linux-raid@archiver.kernel.org>; Thu,  4 Nov 2021 06:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D20D611CE
	for <linux-raid@archiver.kernel.org>; Thu,  4 Nov 2021 06:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhKDGWB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Nov 2021 02:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhKDGWA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Nov 2021 02:22:00 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5983C061714;
        Wed,  3 Nov 2021 23:19:22 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t21so5569537plr.6;
        Wed, 03 Nov 2021 23:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/U/goPBc2l7LrHLx4AC51EQ2/oPni2YaTPXe0f2kGhw=;
        b=nYDU5h7IRL77pha8yYfqIhQUTcDsAGC3DGy3rEfGKPoFNR/IGi+yd0wjvBp0ZDqlkp
         s2Yly0Afy+RgEbH/g9dMEa2DQW/ZveQJkUpN2cPhGCbq2KkiSdFnUZ8xhulUU/IVZr+E
         pB5aXij2Aw2ihyvFLFdPvI5+Zzpl2+GWiZ3w4lnii+qSiQnQW2B1dqXIeiQAFarBcBhZ
         tAshYDPow72HccwGCmKEou5vyYOSP2ufpkwrTL1swJ02Gj0Wrv7fp7fKQAhJYuWMdePB
         S0dlB0EikVDB0GBA6QLxMyLFMqDfxWdyTlOa6D4WPMSd8wLF5uIEpRCrEEDU7ga4GfuV
         flQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/U/goPBc2l7LrHLx4AC51EQ2/oPni2YaTPXe0f2kGhw=;
        b=4gqKux4rmG14Z2rSU8WeNBEWPq9J1QJK+jOjb4+n5wITuBVjYd60rOXNuUttizoGUe
         fHzPJEaL5bVAwu3JflFMQqk0FNoiONSLWP0RkQE+sONVAsuv2iaFl5IDDcDLEvEPFsLC
         7ZmcVSnKxMvkH13zJkk+n7oTRwkVD+j7eheGareMUD6Nv52t6r65OAavTYbnlO38N7P5
         O1si9J6Yaf/e6Gpihr7J9zhNqOas20yYwqwA/vQ3DreNtzE0Kt/A20QshpU152grKKtd
         8r2L/Ce3o5M8NCAQQHwj4vBKzNqo9kfRISrcz3F6Bkwx9Q85Wr1b8FwSFEGyNr4yiWEe
         zbYw==
X-Gm-Message-State: AOAM5338U9LzGea1P80Vx+FbJflHe8EWl/Sb9MRWBHRWCOaMNYVRjw95
        LnK7pqV24GXCJRlE3G7QvzE=
X-Google-Smtp-Source: ABdhPJygIuFeA88vZ942m0biac428JoZbq07kjeDFMhaCVKPq9qlx1mu9/YLjTthOjbbAoPrjNJ0Kg==
X-Received: by 2002:a17:90b:1b0a:: with SMTP id nu10mr19861742pjb.35.1636006762390;
        Wed, 03 Nov 2021 23:19:22 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id d18sm4153900pfv.161.2021.11.03.23.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 23:19:22 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: luo.penghao@zte.com.cn
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] md: Remove redundant assignments
Date:   Thu,  4 Nov 2021 06:19:16 +0000
Message-Id: <20211104061916.2218-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>

The assignment of err will be overwritten next, so this statement
should be deleted.

The clang_analyzer complains as follows:

drivers/md/md-autodetect.c:178:2: warning:

Value stored to 'err' is never read

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 drivers/md/md-autodetect.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 2cf9737..ab425d5 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -175,7 +175,6 @@ static void __init md_setup_drive(struct md_setup_args *args)
 		return;
 	}
 
-	err = -EIO;
 	if (WARN(bdev->bd_disk->fops != &md_fops,
 			"Opening block device %x resulted in non-md device\n",
 			mdev))
-- 
2.15.2


