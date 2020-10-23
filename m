Return-Path: <SRS0=YfF9=D6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07187C388F9
	for <linux-raid@archiver.kernel.org>; Fri, 23 Oct 2020 03:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EE2C2463C
	for <linux-raid@archiver.kernel.org>; Fri, 23 Oct 2020 03:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=drivescale-com.20150623.gappssmtp.com header.i=@drivescale-com.20150623.gappssmtp.com header.b="IPFfdKZ7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374885AbgJWDbq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Oct 2020 23:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374855AbgJWDbo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Oct 2020 23:31:44 -0400
Received: from mail-oi1-x262.google.com (mail-oi1-x262.google.com [IPv6:2607:f8b0:4864:20::262])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C86EC0613D6
        for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2020 20:31:44 -0700 (PDT)
Received: by mail-oi1-x262.google.com with SMTP id n3so412901oie.1
        for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2020 20:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=drivescale-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RhHK93So0VcKlYFbgYUYXeSYVQkNms0+nxyySSnXb+k=;
        b=IPFfdKZ7mj4Gn6Yl/tH8/Q+MuI0fe9tTCLLeMhotRbKJyhaUuHrUntFTcPozjRq4jQ
         0/zjMXzmcPtSrP3uAwhkudtzUYH0ttPOb9Ba0727AiOdYNvgmaY9tMfNGca9wiVfntjW
         Wyvx4HSZE3cAieHlJGxR4qlBiEgJi3IkljP78r0IwYLSC5TiNsCI1nrpqxkcPJzxqOLK
         OD2vUXAJIO3CLAPZqACLpIIdR8kYlcJ/caEiRuCBuR70c+VCNl2ufzTPnhl+C2p7vTUR
         b0smkrP7YD2kMNbs8wP/wqBgD4xZKQyHJcetRsR6c5BB51PY4W+mPYnQ90F1uD9O0UIc
         OhWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RhHK93So0VcKlYFbgYUYXeSYVQkNms0+nxyySSnXb+k=;
        b=V3UmEYp3gcHBc3+hLUaRMhulO57EekpBSTS+V4XzuA6R4J3zXTPF11pMIV8TL1FsGd
         eVlWvwE5sBkTIULixxgAXWu1yCd39dnLxYzsG9sKhOCIPkjTXRG3gFx+reiYIjW2Z4In
         Cg1SSvGjUGYz08+ZVBnmGJw0uRM0+fCArKagpQUVIgx5OS8bnHhcZTEujlGo3ksnBvmu
         YpfVs3IaQufnFKL0Xdve1cTvtvX6k5XV0XToCdRJQBw7yOGUXtLy6mNUdsLbXIjuZVRv
         Kj5kwQ/LgBLQrbYr1+0RiP5iMyHQkvIsxuAYHVuZ6lfMxfkE8iDEHuZ9zCgJ1DkDeYE0
         B4Ug==
X-Gm-Message-State: AOAM532qN8ZB6UKOdPHC/eJq3MFQoxE8rVgysDyEXDTHG6CzPTCVMDn6
        Wa1laY5lUxqVyRTe60P5dK10RQ81HW2bGJvn6DTlljXwDqyyAA==
X-Google-Smtp-Source: ABdhPJybn2Qbcm4XVtdDVaJj0llIw0aTm6KmR3ZYalQvBvvjokAJn1bdXPkcektjFZ84uYebkJI2ytz6owL6
X-Received: by 2002:a05:6808:28c:: with SMTP id z12mr246573oic.70.1603423903944;
        Thu, 22 Oct 2020 20:31:43 -0700 (PDT)
Received: from dcs.hq.drivescale.com ([68.74.115.3])
        by smtp-relay.gmail.com with ESMTP id w2sm42526ooc.20.2020.10.22.20.31.43;
        Thu, 22 Oct 2020 20:31:43 -0700 (PDT)
X-Relaying-Domain: drivescale.com
Received: from localhost.localdomain (gw1-dc.hq.drivescale.com [192.168.33.175])
        by dcs.hq.drivescale.com (Postfix) with ESMTP id 51BBA420D3;
        Fri, 23 Oct 2020 03:31:43 +0000 (UTC)
From:   Christopher Unkel <cunkel@drivescale.com>
To:     linux-raid@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Song Liu <song@kernel.org>,
        cunkel@drivescale.com
Subject: [PATCH 3/3] md: pad writes to end of bitmap to physical blocks
Date:   Thu, 22 Oct 2020 20:31:30 -0700
Message-Id: <20201023033130.11354-4-cunkel@drivescale.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201023033130.11354-1-cunkel@drivescale.com>
References: <20201023033130.11354-1-cunkel@drivescale.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Writes of the last page of the bitmap are padded out to the next logical
block boundary.  However, they are not padded out to the next physical
block boundary, so the writes may be less than a physical block.  On a
"512e" disk (logical block 512 bytes, physical block 4k) and if the last
page of the bitmap is less than 3584 bytes, this means that writes of
the last bitmap page hit the 512-byte emulation.

Respect the physical block boundary as long as the resulting write
doesn't run into other data, and is no longer than a page.  (If the
physical block size is larger than a page no bitmap write will respect
the physical block boundaries.)

Signed-off-by: Christopher Unkel <cunkel@drivescale.com>
---
 drivers/md/md-bitmap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 600b89d5a3ad..21af5f94d495 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -264,10 +264,18 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 
 		if (page->index == store->file_pages-1) {
 			int last_page_size = store->bytes & (PAGE_SIZE-1);
+			int pb_aligned_size;
 			if (last_page_size == 0)
 				last_page_size = PAGE_SIZE;
 			size = roundup(last_page_size,
 				       bdev_logical_block_size(bdev));
+			pb_aligned_size = roundup(last_page_size,
+						  bdev_physical_block_size(bdev));
+			if (pb_aligned_size > size
+			    && pb_aligned_size <= PAGE_SIZE
+			    && sb_write_alignment_ok(mddev, rdev, page, offset,
+						     pb_aligned_size))
+				size = pb_aligned_size;
 		}
 		/* Just make sure we aren't corrupting data or
 		 * metadata
-- 
2.17.1

