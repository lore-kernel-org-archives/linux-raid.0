Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5386EB64D9
	for <linux-raid@archiver.kernel.org>; Sun,  2 Jul 2023 10:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjGBKEd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 2 Jul 2023 06:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjGBKEb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 2 Jul 2023 06:04:31 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3607810C1
        for <linux-raid@vger.kernel.org>; Sun,  2 Jul 2023 03:04:29 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-666683eb028so1748692b3a.0
        for <linux-raid@vger.kernel.org>; Sun, 02 Jul 2023 03:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1688292268; x=1690884268;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CyWnRizl7RRZLuWt/eBKwNhl/12RLQawGkrHxLOxFCE=;
        b=NB4BeMvtvVHaL7gcYC5aK4OXZGfLMDbJSkCg1Bmhi5c+TIC4DAbbgrFzE0iym21bdv
         J4pj+Px/uW3Ym5TaWydoTAEEw9ByPFhkdsg7ugQX5L3LF+5Oqvhvair7AstHhweRYAR9
         HyruUJJFMpMRBJvADrf0fqNLJuRqwqM/pDnU2FNvN+NZd0CHmVAwG1JJ+BWOEa3NR8Th
         grLSESCq6c80s7MfbRS63k7WXs2rsmgSKrTD8R9V0uv5XeKrss35gUU13nINb+XL1Syn
         4IoHPO/4L1J6HomRf9odH1mimRxhgH8WUJxa6I140T8eGt7et2JSqgHfJfGrs9EK2T/+
         SkRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688292268; x=1690884268;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CyWnRizl7RRZLuWt/eBKwNhl/12RLQawGkrHxLOxFCE=;
        b=dBlGjQo8x2POkDQs/Vzsb0SMgCEy0TlZ1QgwxyIPJ9T5akNaQJje3DNiD2tTFsrKIk
         7fnWucj0SJuS6/iJByf0P9NlP+WWLZthjpmWwfTYGUsThZCnkfgM80TaV6M7+k1b+6a+
         bDEmYl3scY9i5KaFxlhDzpgfLgpOXUVOCjhnHY0heHgZe/CFsmqMQj4LeOiWzt8oV64b
         vIrtp42HCRF1w1nVLlgjIgEyn9POfOY9AXWGpMPTI6XZ81Mxse0Us6qsP09XsH358ys5
         2r7g1HoXaDYVgeY3Y4eb0vqTEY0kPDORVxOUCdSskt+1qh0nmFHBsfaPb4j65WYleQkD
         dIgQ==
X-Gm-Message-State: ABy/qLbNHyYmF+8dXcQUXFWSDGpINkzWMz8DwBAAqKQ4b8cQwvwQ/b58
        V+u14azfOJEJoyhkQLJEOX7X2EhWnyucD7nH5W7cBmrV
X-Google-Smtp-Source: APBJJlGslBVk6rzohiFhXRVwgVUmV5o2ESupx+NqVOwuYPIjzIPEZxb2Q1cZguLBvmnvqlcVjGihgQ==
X-Received: by 2002:a05:6a00:1953:b0:678:ee57:7b29 with SMTP id s19-20020a056a00195300b00678ee577b29mr6951579pfk.30.1688292268323;
        Sun, 02 Jul 2023 03:04:28 -0700 (PDT)
Received: from nixos (61-221-155-12.hinet-ip.hinet.net. [61.221.155.12])
        by smtp.gmail.com with ESMTPSA id u15-20020aa7838f000000b0066a6059d399sm12360156pfm.116.2023.07.02.03.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jul 2023 03:04:28 -0700 (PDT)
Date:   Sun, 2 Jul 2023 18:04:25 +0800
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org
Subject: [PATCH] md/raid1: freeze block layer queue during reshape
Message-ID: <vsag6vp4jokp2k5fkoqb5flklghpakxmglr75vpzgkmzejc47u@ih2255x374rp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When a raid device is reshaped, in-flight bio may reference outdated
r1conf::raid_disks and r1bio::poolinfo. This can trigger a bug in
three possible paths:

1. In function "raid1d". If a bio fails to submit, it will be resent to
raid1d for retrying the submission, which increases r1conf::nr_queued.
If the reshape happens, the in-flight bio cannot be freed normally as
the old mempool has been destroyed.
2. In raid1_write_request. If one raw device is blocked, the kernel will
allow the barrier and wait for the raw device became ready, this makes
the raid reshape possible. Then, the local variable "disks" before the
label "retry_write" is outdated. Additionally, the kernel cannot reuse the
old r1bio.
3. In raid_end_bio_io. The kernel must free the r1bio first and then
allow the barrier.

By freezing the queue, we can ensure that there are no in-flight bios
during reshape. This prevents bio from referencing the outdated
r1conf::raid_disks or r1bio::poolinfo.

Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
---
 drivers/md/raid1.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index dd25832eb045..d8d6825d0af6 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3247,6 +3247,7 @@ static int raid1_reshape(struct mddev *mddev)
 	unsigned long flags;
 	int d, d2;
 	int ret;
+	struct request_queue *q = mddev->queue;
 
 	memset(&newpool, 0, sizeof(newpool));
 	memset(&oldpool, 0, sizeof(oldpool));
@@ -3296,6 +3297,7 @@ static int raid1_reshape(struct mddev *mddev)
 		return -ENOMEM;
 	}
 
+	blk_mq_freeze_queue(q);
 	freeze_array(conf, 0);
 
 	/* ok, everything is stopped */
@@ -3333,6 +3335,7 @@ static int raid1_reshape(struct mddev *mddev)
 	md_wakeup_thread(mddev->thread);
 
 	mempool_exit(&oldpool);
+	blk_mq_unfreeze_queue(q);
 	return 0;
 }
 
-- 
2.40.1

