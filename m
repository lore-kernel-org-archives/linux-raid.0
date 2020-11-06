Return-Path: <SRS0=g69Z=EM=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E276FC2D0A3
	for <linux-raid@archiver.kernel.org>; Fri,  6 Nov 2020 22:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 834BB206F9
	for <linux-raid@archiver.kernel.org>; Fri,  6 Nov 2020 22:21:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K1mHa78a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgKFWVJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 6 Nov 2020 17:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729327AbgKFWVE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 6 Nov 2020 17:21:04 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B19C0613D3
        for <linux-raid@vger.kernel.org>; Fri,  6 Nov 2020 14:21:04 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id i26so2045356pgl.5
        for <linux-raid@vger.kernel.org>; Fri, 06 Nov 2020 14:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hwmgfdhv7fom0lkmY8e89sgxqfsvhanxDwfTqstUhYA=;
        b=K1mHa78aV3r7i2ZEesaZoZ2K2k/BXMM6C7Ni2K0p5bL7/NcjMR49/uv4efgyMftqFe
         e8S2ZxWZ4Cau/gJS6heG1M7Oq3C7Cqc7/9doc2CDe9hRBOq4wm0e1ZOltr8UfL6OiHD+
         zxLX7LUEceqy0uZV3NuRT8WXYprKfF3DOknDMNYufR70kgYw2lSWc/TQGvKPDYC818Bj
         ppF2ftZAk4LeisFABJmL3B9yKwZrESeEh0PVljYZmsf1OH5RV2mkvhCJBI2OkLB1GMf4
         pduH0HWDfMsRdh9jHGH1Pn14V4KAv4WjNLjFq0by0y9E4IbjJu4ZaVyW+rAlBv1RUUx+
         xJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hwmgfdhv7fom0lkmY8e89sgxqfsvhanxDwfTqstUhYA=;
        b=IVRnmA8uqjxh+nEi37XBc/qdfawC/IR8wopt+9HYtW+kUWX8oCGievm5gSrNrAFFCo
         be3cOZ6ZyYc7f28lsENFMC43b+MP9HFqAGVPkETQb+pdChWR15FVIvXIPTRg/h5gobSb
         xEaUsUpH+WWIIOmKoZF5IXq6WUBUXXZBX7WDsoAq+XKaenrLwycqZi75zV/UHg0XXLls
         dyUmQhi2x+OerFdwmcOtG43IUrUZc9tUmou7Et+q5Pq/uoG2B6Mk6PTt/o54bOLc4QF0
         2qtXugOlXqkNjzehZ/dVr2OlOD0UyuuuaG59zYC36TVV6AtWEu0QqnFNekJNWDyCdTbZ
         PCpQ==
X-Gm-Message-State: AOAM532DkRndNgPg5MY3f6VAQHYfFJoDhWLAqktsOjUPege9MP1uDMS6
        IIwWEBk6Zf+2HQ7lRc9SGTQ=
X-Google-Smtp-Source: ABdhPJy7GzHhk0aiJtDvm7l200QlXwND3REYpiBhCVfxQS0QPN2CgKM4heoEn91/NQuG7Dig2JQckw==
X-Received: by 2002:a63:540c:: with SMTP id i12mr3531396pgb.32.1604701263950;
        Fri, 06 Nov 2020 14:21:03 -0800 (PST)
Received: from kvigor-fedora-R90RRLH2.thefacebook.com ([2620:10d:c090:400::5:b0c2])
        by smtp.gmail.com with ESMTPSA id r3sm4146436pjl.23.2020.11.06.14.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 14:21:03 -0800 (PST)
From:   Kevin Vigor <kvigor@gmail.com>
To:     song@kernel.org, linux-raid@vger.kernel.org
Cc:     Kevin Vigor <kvigor@gmail.com>
Subject: [PATCH v2] md/raid10: initialize r10_bio->read_slot before use.
Date:   Fri,  6 Nov 2020 14:20:34 -0800
Message-Id: <20201106222034.1304830-1-kvigor@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <CAPhsuW6GqEU7BczF2tpgtEJoU5Fdh4M17N9cobhSMdVY4NPD3w@mail.gmail.com>
References: <CAPhsuW6GqEU7BczF2tpgtEJoU5Fdh4M17N9cobhSMdVY4NPD3w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In __make_request() a new r10bio is allocated and passed to
raid10_read_request(). The read_slot member of the bio is not
initialized, and the raid10_read_request() uses it to index an
array. This leads to occasional panics.

Fix by initializing the field to invalid value and checking for
valid value in raid10_read_request().

Signed-off-by: Kevin Vigor <kvigor@gmail.com>
---
v2:
- rebase onto md-next
---
 drivers/md/raid10.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b7bca6703df8..3153183b7772 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1127,7 +1127,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	struct md_rdev *err_rdev = NULL;
 	gfp_t gfp = GFP_NOIO;
 
-	if (r10_bio->devs[slot].rdev) {
+	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
 		 * This is an error retry, but we cannot
 		 * safely dereference the rdev in the r10_bio,
@@ -1508,6 +1508,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	r10_bio->mddev = mddev;
 	r10_bio->sector = bio->bi_iter.bi_sector;
 	r10_bio->state = 0;
+	r10_bio->read_slot = -1;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->geo.raid_disks);
 
 	if (bio_data_dir(bio) == READ)
-- 
2.26.2

