Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B844C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 15 Dec 2021 06:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240016AbhLOGJe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Dec 2021 01:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240014AbhLOGJd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Dec 2021 01:09:33 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C81C06173E
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 22:09:32 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id s9so19363686qvk.12
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 22:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LrdYNClwmxdW3SkVOsLplX0xzM+nCcA2usXmjGDY+rI=;
        b=CHQc4O4CKajgnogl2sSI3hJ0GAZ34n8Pp3h1m2ipQ8EAF0cSp214X5iN+Cog51PB4P
         TM7ZgUofX1NFUo95XjXRu+8pRyze8W74hZrXHzQfJTA8fVi4R9UF0i4rySAKOLYWuGvn
         +IlSdCQhfaI/t5d/OtrumLc5ncoFvTbaLlsU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LrdYNClwmxdW3SkVOsLplX0xzM+nCcA2usXmjGDY+rI=;
        b=u6BplyeQWoJ4rdrhwfXt8oOkrQa5hZeCRAR2h8ppILd0TblVa2/zLuI55giUx7uuyO
         BZ2RSe1Mx6mlTTcX1rPE1XFq0NLPA0Njx6Z5IZ0agvAhXsEVT5GEQBLbba5GbEVmz1jb
         DjSGp/sEJp5ii/qHG6JmL6RrW7kd8fT4+zUE3tAJDz5neOxddqG1FJDkypPWofKVgzPn
         eyXGheg1zsnSoFvI1Bwy8QGB4L/bg+zIR0WTWkjTq/2/H9pPkl3p2PkSTN54bN52to5S
         HhomOfuZHIqIiINsgKoeIJQScPsv8fCMLXDMuZjDVMFtu0JTMA65MANGDttakaFb2XdO
         lmNw==
X-Gm-Message-State: AOAM531XbuOCQ1as876cORwZOAcM+MT7sVyD3PMxfL5C4u8K7wTnWg6n
        562ffK1L1sPjsIjH7EtXtDJICA==
X-Google-Smtp-Source: ABdhPJzKu1MdqRCH4rRbAOjydrsvVSGyJl8wuqEI6cl1/RIKVjEt4QtuSIo/HHEfeBdjXBzS/oujrQ==
X-Received: by 2002:a0c:ef03:: with SMTP id t3mr9699905qvr.32.1639548571893;
        Tue, 14 Dec 2021 22:09:31 -0800 (PST)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id w2sm818439qta.11.2021.12.14.22.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 22:09:31 -0800 (PST)
From:   Vishal Verma <vverma@digitalocean.com>
To:     song@kernel.org, linux-raid@vger.kernel.org
Cc:     axboe@kernel.dk, rgoldwyn@suse.de,
        Vishal Verma <vverma@digitalocean.com>
Subject: [PATCH v5 4/4] md: raid456 add nowait support
Date:   Wed, 15 Dec 2021 06:09:06 +0000
Message-Id: <20211215060906.3230-4-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211215060906.3230-1-vverma@digitalocean.com>
References: <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
 <20211215060906.3230-1-vverma@digitalocean.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Returns EAGAIN in case the raid456 driver would block
waiting for situations like:

- Reshape operation,
- Discard operation.

Signed-off-by: Vishal Verma <vverma@digitalocean.com>
---
 drivers/md/raid5.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1240a5c16af8..b505e4cec777 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5715,6 +5715,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 		set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
 		if (test_bit(STRIPE_SYNCING, &sh->state)) {
 			raid5_release_stripe(sh);
+			/* Bail out if REQ_NOWAIT is set */
+			if (bi->bi_opf & REQ_NOWAIT) {
+				bio_wouldblock_error(bi);
+				return;
+			}
 			schedule();
 			goto again;
 		}
@@ -5727,6 +5732,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 				set_bit(R5_Overlap, &sh->dev[d].flags);
 				spin_unlock_irq(&sh->stripe_lock);
 				raid5_release_stripe(sh);
+				/* Bail out if REQ_NOWAIT is set */
+				if (bi->bi_opf & REQ_NOWAIT) {
+					bio_wouldblock_error(bi);
+					return;
+				}
 				schedule();
 				goto again;
 			}
@@ -5820,6 +5830,16 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	bi->bi_next = NULL;
 
 	md_account_bio(mddev, &bi);
+	/* Bail out if REQ_NOWAIT is set */
+	if ((bi->bi_opf & REQ_NOWAIT) &&
+	    (conf->reshape_progress != MaxSector) &&
+	    (mddev->reshape_backwards
+	    ? (logical_sector > conf->reshape_progress && logical_sector <= conf->reshape_safe)
+	    : (logical_sector >= conf->reshape_safe && logical_sector < conf->reshape_progress))) {
+		bio_wouldblock_error(bi);
+		return true;
+	}
+
 	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 	for (; logical_sector < last_sector; logical_sector += RAID5_STRIPE_SECTORS(conf)) {
 		int previous;
-- 
2.17.1

