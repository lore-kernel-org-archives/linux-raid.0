Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A738C04E69
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 08:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbjHNIwG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 04:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbjHNIvf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 04:51:35 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFD7BB
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 01:51:33 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-686b643df5dso2703260b3a.1
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 01:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1692003093; x=1692607893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YxJk6xFqYMyd2Arn2NrhuCFZq+WpZgkUoQ8LNr9Tn9U=;
        b=z5A8Mq4DNvfueMGNESjXSgyINye8JiOBGqS52Pev9HPBvM92wTI5rIirLp4+3Ba05K
         mYt/q7CW4HAw2q0lf0j5Nf+tPk3yLojMzTgROrMiDcReIaHgN+yxF4YFIZ3ZoRoHzi75
         n7Y7/euENKy16U3HhoVU505CIJRsYCyFljQyHZztAtfNYP/vkUlVNwIbWTehA66cgw7H
         Jskl+CS9hW0ydPYxtN/F5ppz0GHVkVUGfp1YrdaFZHRC5w9aofpLh2ZLvm8HrrwMGJTD
         eUwfonluEOKh4q1XEV88otDrmiT9I6ZLDrMzHjs4NulcH/amhMGJeV7+E6S6M1l1Mvfy
         UeNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692003093; x=1692607893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YxJk6xFqYMyd2Arn2NrhuCFZq+WpZgkUoQ8LNr9Tn9U=;
        b=Lt2ANGo8a3NnwV0mWMNagQATagt3GhnanfLzT9WJxRUlvr9ExJrNRU9HpDyu5lQ7GN
         cakDLKH6npvwxRAJ+rOP4VrvRgtVCWwVu//Zg/rFKsIslWQS/jz09/p1ED+gVFx04G0t
         +IbIsUfijQRjwtBPFrKlcsLm1PMzbHJiusbZy0/+l9t1AJVh7RJ36HVcYrKHtFEmoMVg
         gtm6dShmIaibwl2mlw+PzVFLznPyvq0U4i+jHEfFoj7F17Wm40jAs7XDKuiT+GlBBogY
         SWxjrhanjIKpsXS8XHR1ArVIUgC8okr+3zr5cs245bI25LAeX3puGL9w54LGte4gExcA
         zaWA==
X-Gm-Message-State: AOJu0Yx8xQbuBLzAdgPC/3PAQ9R1zt9FodpmVx7ECZExXyiMHkzbxZe1
        HxTRr7B5q/FAviAtsLbQKZb5/+UXpHOsOvdOGw10yHaI
X-Google-Smtp-Source: AGHT+IGHQVtpLPTqgN4QjmWjMMR3idbTYDD0RytfRBFJfQYjuDrXNv9n5xJ+Ib0oOBvhsxKvIxQt3Q==
X-Received: by 2002:a05:6a20:3947:b0:135:293b:efaf with SMTP id r7-20020a056a20394700b00135293befafmr10826465pzg.10.1692003092968;
        Mon, 14 Aug 2023 01:51:32 -0700 (PDT)
Received: from nixos.tailf4e9e.ts.net ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id fk1-20020a056a003a8100b006765cb3255asm7439668pfb.68.2023.08.14.01.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 01:51:32 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     song@kernel.org, djeffery@redhat.com, dan.j.williams@intel.com,
        neilb@suse.de, akpm@linux-foundation.org, neilb@suse.com
Cc:     linux-raid@vger.kernel.org, Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH v5 3/3] md/raid1: keep the barrier held until handle_read_error() finished
Date:   Mon, 14 Aug 2023 16:51:08 +0800
Message-Id: <20230814085108.991040-4-xueshi.hu@smartx.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230814085108.991040-1-xueshi.hu@smartx.com>
References: <20230814085108.991040-1-xueshi.hu@smartx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

handle_read_error() will call allow_barrier() to match the former barrier
raising. However, it should put the allow_barrier() at the end to avoid an
concurrent raid reshape.

Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
---
 drivers/md/raid1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5f17f30a00a9..5a5eb5f1a224 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2499,6 +2499,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	struct mddev *mddev = conf->mddev;
 	struct bio *bio;
 	struct md_rdev *rdev;
+	sector_t sector;
 
 	clear_bit(R1BIO_ReadError, &r1_bio->state);
 	/* we got a read error. Maybe the drive is bad.  Maybe just
@@ -2528,12 +2529,13 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	}
 
 	rdev_dec_pending(rdev, conf->mddev);
-	allow_barrier(conf, r1_bio->sector);
+	sector = r1_bio->sector;
 	bio = r1_bio->master_bio;
 
 	/* Reuse the old r1_bio so that the IO_BLOCKED settings are preserved */
 	r1_bio->state = 0;
 	raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);
+	allow_barrier(conf, sector);
 }
 
 static void raid1d(struct md_thread *thread)
-- 
2.40.1

