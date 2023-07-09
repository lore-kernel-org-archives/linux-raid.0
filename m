Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8BCEB64DC
	for <linux-raid@archiver.kernel.org>; Sun,  9 Jul 2023 10:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjGIKaS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 9 Jul 2023 06:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjGIKaO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 9 Jul 2023 06:30:14 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FA2F4
        for <linux-raid@vger.kernel.org>; Sun,  9 Jul 2023 03:30:13 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d9443c01a7336-1b7e6512973so21804555ad.3
        for <linux-raid@vger.kernel.org>; Sun, 09 Jul 2023 03:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1688898613; x=1691490613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TNN9QkcmsO3KPgQ0QUmXwgC+bPcPHbUo8MbhwOskXA=;
        b=U2Z5xK6Gd4yg15x3O3BkvRhUyi/0KlDT3nXifbyDMaO1ymSr7R3QXn6ggAwNKGvkeq
         dFgJDhdZT3xUJEruULDOBcqoH0+4j+B/D0kigDdJNQ6x5mVYxDLOtCB8l4bVkwhKl8sQ
         ADL4+qy5bDaaWA+lsJCiHroQ6bJMVl4A7A2bL8SkXkb/5KT75dLIFXHDSrYHyRZdhN4V
         HU4ol4Am53sSGg4la2usEIevnPh7sqMbsNNLeK2KnB34vcZg5wph4eVSr0h7guIE1PHJ
         zI/KgkPx/P6LiZvZSyISR33hUN3pAGajTd9LFy1OtHms+P1XL+arhum9u2pZQfOm+liH
         /MmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688898613; x=1691490613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6TNN9QkcmsO3KPgQ0QUmXwgC+bPcPHbUo8MbhwOskXA=;
        b=QJqgKzo7/9thahavDvm3zIMmpGLz7Ta1lTLRoq4c003xJ8h/bHq8a+xgfkJcvBMI3d
         mi6mCQnSdGVTYM0RzXDMFuxm1vhscGnMaPy8O26crbVxN5TBDK2X/77xrDhn5hKZdP92
         ugLlBr6G/JFR8ThU+lz0N9B8weMHkOFfu09B+Py8QoXNW+DG5PWPvwErv2MSyGTgt+87
         Gza0pt3flNgjfVZE1HdCuA7qJTT2kNMZjpZz3Dfr5d69NPyEGEFjJrc+pq9jnNy7BGTf
         TJFHCdCs6euJ0qEYuTGmH00G6jqbmfbYG4Tg4XHVgL6Uk3mmnXCdG7tWqozH88wd3eOW
         hWwQ==
X-Gm-Message-State: ABy/qLaYLcQ7VJhSIt7lxoVRMIFRPK5LpRVJRVKOM8BBfgLX6OZ8Hzba
        Hb90a/OgCNnA/rA7GhTj1uk6b6ZAKpY3hxlSEj9UYAKDCnwgTYXn
X-Google-Smtp-Source: APBJJlGD5F7LVnxIKEo1rFVhnZq8DCXM1TeLnpbZZaCyWB3juvOL3V0pm0BpHkWIeQvCFopqlpiVsw==
X-Received: by 2002:a17:902:edca:b0:1b6:ab53:c7a5 with SMTP id q10-20020a170902edca00b001b6ab53c7a5mr7432716plk.46.1688898613162;
        Sun, 09 Jul 2023 03:30:13 -0700 (PDT)
Received: from localhost.localdomain ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id i19-20020a170902eb5300b001b9be2e2b3esm4479140pli.277.2023.07.09.03.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jul 2023 03:30:12 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
X-Google-Original-From: Xueshi Hu <hubachelar@gmail.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH v2 3/3] md/raid1: keep holding the barrier in handle_read_error()
Date:   Sun,  9 Jul 2023 18:29:56 +0800
Message-Id: <20230709102956.1716708-4-hubachelar@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230709102956.1716708-1-hubachelar@gmail.com>
References: <20230709102956.1716708-1-hubachelar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Xueshi Hu <xueshi.hu@smartx.com>

Raid reshape changes the r1conf::raid_disks and mempool. Keep holding the
barrier in handle_read_error() to avoid raid reshape.

Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
---
 drivers/md/raid1.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6c54786067b4..43a9c095f94d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1240,20 +1240,20 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 		rcu_read_unlock();
 	}
 
-	/*
-	 * Still need barrier for READ in case that whole
-	 * array is frozen.
-	 */
-	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
-				bio->bi_opf & REQ_NOWAIT)) {
-		bio_wouldblock_error(bio);
-		return;
-	}
-
-	if (!r1_bio)
+	if (!r1_bio) {
+		/*
+		 * Still need barrier for READ in case that whole
+		 * array is frozen.
+		 */
+		if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
+					bio->bi_opf & REQ_NOWAIT)) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		r1_bio = alloc_r1bio(mddev, bio);
-	else
+	} else
 		init_r1bio(r1_bio, mddev, bio);
+
 	r1_bio->sectors = max_read_sectors;
 
 	/*
@@ -2527,7 +2527,6 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	}
 
 	rdev_dec_pending(rdev, conf->mddev);
-	allow_barrier(conf, r1_bio->sector);
 	bio = r1_bio->master_bio;
 
 	/* Reuse the old r1_bio so that the IO_BLOCKED settings are preserved */
-- 
2.40.1

