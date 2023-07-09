Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB598EB64DC
	for <linux-raid@archiver.kernel.org>; Sun,  9 Jul 2023 10:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjGIKaO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 9 Jul 2023 06:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjGIKaL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 9 Jul 2023 06:30:11 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D38F4
        for <linux-raid@vger.kernel.org>; Sun,  9 Jul 2023 03:30:10 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d9443c01a7336-1b8b4749013so26103835ad.2
        for <linux-raid@vger.kernel.org>; Sun, 09 Jul 2023 03:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1688898610; x=1691490610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Ccj+V99OsZYt0ldTU5RVfYP8EjPvEfZb6DbZd35Eoc=;
        b=ybBVPdV7Vc52gtsxPFrU/VJ2oQlDH5V4bRY/bGlIBprZq8PaKIwLeP8gxAKbu1hJFn
         eOQ6BRUgN/YNeUbdqYN/byob1iB8s7KC/Bsav56k8ZBy4ApkzIQUuWsOgsaKEdNb7iZ3
         F+7Y1blC68iM0XgE4ftq64BJhEufnD6IuP/0BxFqpFkpyIq/q3RWR1qinhryG8xS7jyj
         pfo9YlVPnL0m5yFLCKoZ+owfB/fLAITDfO9TjC+QKbyxmNSNbZmegkmwVDcsF+gpi7g+
         Bo7FYxHQzS4PQnYDpH1mK0hY6FdIwrVGiNhBZbcS56tPHClyR+u187bezJ1C9hLjWNvX
         cdFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688898610; x=1691490610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Ccj+V99OsZYt0ldTU5RVfYP8EjPvEfZb6DbZd35Eoc=;
        b=c6heKSLEJQOt8mOObwenM2FdPY6Ed+oRIUzkwkF3Ls+u0t5Fnh10gysGbCl441UJhf
         0C0IOMmSFteS6dwT08s3TiGKM4Od0ZiAvvP+wPXUTh0uso3DY+nFzdkUZ3SF3a0hL0Qt
         PX5+R7VMt/owYqe2r0QwAfblKYqJS18OWDQ084HdS7ghyq8SZoe42RR0BSKJr2FogZZq
         DsisiLBs/jo9tTHM8U1zCkrBVmBnvM/3t+lx69DGZd6wT8b5M3fB3aiiDi/N/QF2NFKc
         KR9R3dCGq3bkL8SdS3hopJkIYkzDg0iyl4nGX7Q9dYWS43Cfz4djX2SijsHL4heACO8j
         Pr/Q==
X-Gm-Message-State: ABy/qLauSHiKfKm+irZJxUQYeUB8p5eo9EhIw+xbLVIzUTz0FgoHIeU2
        p6Yi30noq8rUdxCUW1LM1brU0g==
X-Google-Smtp-Source: APBJJlEe0M0R0jtmZBN7ZkhyQlNkIz/U587kbkF41VG4wdE4gAeCwIsO1rfNv4sgso3A8oVXZRX2Lg==
X-Received: by 2002:a17:902:d3c6:b0:1b8:90bd:d157 with SMTP id w6-20020a170902d3c600b001b890bdd157mr9195703plb.26.1688898610446;
        Sun, 09 Jul 2023 03:30:10 -0700 (PDT)
Received: from localhost.localdomain ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id i19-20020a170902eb5300b001b9be2e2b3esm4479140pli.277.2023.07.09.03.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jul 2023 03:30:10 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
X-Google-Original-From: Xueshi Hu <hubachelar@gmail.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH v2 2/3] md/raid1: free old r1bio before retry write
Date:   Sun,  9 Jul 2023 18:29:55 +0800
Message-Id: <20230709102956.1716708-3-hubachelar@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230709102956.1716708-1-hubachelar@gmail.com>
References: <20230709102956.1716708-1-hubachelar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Xueshi Hu <xueshi.hu@smartx.com>

allow_barrier() make reshape possible. Raid reshape changes the
r1conf::raid_disks and mempool, so free the old r1bio and alloc a new one
when retry write.

Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
---
 drivers/md/raid1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ce48cb3af301..6c54786067b4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1373,6 +1373,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		return;
 	}
 
+ retry_write:
 	r1_bio = alloc_r1bio(mddev, bio);
 	r1_bio->sectors = max_write_sectors;
 
@@ -1388,7 +1389,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	 */
 
 	disks = conf->raid_disks * 2;
- retry_write:
 	blocked_rdev = NULL;
 	rcu_read_lock();
 	max_sectors = r1_bio->sectors;
@@ -1468,7 +1468,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		for (j = 0; j < i; j++)
 			if (r1_bio->bios[j])
 				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
-		r1_bio->state = 0;
+		free_r1bio(r1_bio);
 		allow_barrier(conf, bio->bi_iter.bi_sector);
 
 		if (bio->bi_opf & REQ_NOWAIT) {
-- 
2.40.1

