Return-Path: <SRS0=2a2u=EE=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1F6C4742C
	for <linux-raid@archiver.kernel.org>; Thu, 29 Oct 2020 20:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05288206FA
	for <linux-raid@archiver.kernel.org>; Thu, 29 Oct 2020 20:19:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=drivescale-com.20150623.gappssmtp.com header.i=@drivescale-com.20150623.gappssmtp.com header.b="pye3+GeP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgJ2UTc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Oct 2020 16:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgJ2UT3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Oct 2020 16:19:29 -0400
Received: from mail-pg1-x562.google.com (mail-pg1-x562.google.com [IPv6:2607:f8b0:4864:20::562])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3EAC0613D8
        for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2020 13:19:28 -0700 (PDT)
Received: by mail-pg1-x562.google.com with SMTP id i26so3275416pgl.5
        for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2020 13:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=drivescale-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VJdXq2M79h/WbCSw8Kou/qBfOIz84DHnhWmYbvogvdM=;
        b=pye3+GePMyRSq/GyUePGCiFyMmpbiLgDuVp6hQVKueQ6Xa72Bp2dO591qrS/4ygUrX
         /KPZkeZwU0LBlZKypDotufilYR3gFoXxVxUdI0Tk+b7U47Tj95gL6pqB0Enp+sVIg5Do
         Uvfad+EDmd1DWyDy/Nn9Kw46J9MkKcyeYOa710sL9t//RIDTjbM+r//qc0427c0aQ+r0
         mSRjDqVuk4TLIRlRNnq9raYJPrI8WJ79rnCwdkCMkntBb/L0c2+iaSJlExRv7wkzc2xz
         +/shyJNJOQksoeKwx7WZXhhFiTShgp9XS6eKHZWQFCI6m0x4tY4XU+AIVsUrSDAelCCf
         w88A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VJdXq2M79h/WbCSw8Kou/qBfOIz84DHnhWmYbvogvdM=;
        b=FlFva6k6YBfc5qd/Do4SgrRt1BXtv5e8nM0ivlLhHNAGtWfHWWmPlHMsOyH1RF8YPI
         nSeG6PLKZ/LqDeUqobt7B5oTXvcsj2secoshJcISUQdmr2hxEz1eHnBCKdGaqKBAqQj6
         JiXWIKhuG2jVggu+lnz3DSCmIKXPg73h9pTXoT4YGIT5JXgpbxBJmk9bYT7k/s0YOw96
         tAJ3EpsVAMBR6G43UvgxlsthPKxTkzobTqzG63bpbW8eEXuKkHjtWTWyPPfH0VXuldQd
         moQAVYfJ5vGffwvEnfh9WohC9sEus+K8WETCZjnjWeAuP69otcga0dsicP9OuBS9W5T7
         Fhag==
X-Gm-Message-State: AOAM533wg2n9VlW9e1P79pvgyak/qvfBH3zbPUYabOGlks+TQcVPzdDA
        H4UX3gUfaLK721rGbeMpyfOlWwYCrlcYBjK070/n/WMU67uu+A==
X-Google-Smtp-Source: ABdhPJxsdY3pLwqClkXJF/c9iabcmGoyTA1FOq7Kb9Sn5bflyPjOgCZnGmlYJGtvG2cTnB7zpeh/v4EUIqKV
X-Received: by 2002:a62:7cd4:0:b029:152:b3e8:c59f with SMTP id x203-20020a627cd40000b0290152b3e8c59fmr5902194pfc.2.1604002767692;
        Thu, 29 Oct 2020 13:19:27 -0700 (PDT)
Received: from dcs.hq.drivescale.com ([68.74.115.3])
        by smtp-relay.gmail.com with ESMTP id ei15sm186210pjb.10.2020.10.29.13.19.27;
        Thu, 29 Oct 2020 13:19:27 -0700 (PDT)
X-Relaying-Domain: drivescale.com
Received: from localhost.localdomain (gw1-dc.hq.drivescale.com [192.168.33.175])
        by dcs.hq.drivescale.com (Postfix) with ESMTP id 94EFA42129;
        Thu, 29 Oct 2020 20:19:26 +0000 (UTC)
From:   Christopher Unkel <cunkel@drivescale.com>
To:     linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Christopher Unkel <cunkel@drivescale.com>
Subject: [PATCH 3/3] md: reuse sb length-checking logic
Date:   Thu, 29 Oct 2020 13:13:58 -0700
Message-Id: <20201029201358.29181-4-cunkel@drivescale.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201029201358.29181-1-cunkel@drivescale.com>
References: <20201029201358.29181-1-cunkel@drivescale.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The logic in super_1_load() to check the length of the superblock
against (new_)data_offset has the same purpose as the newly-created
super_1_sb_length_ok().  The latter is also more complete in that it
check for overlap between the superblock write and the bitmap.

Signed-off-by: Christopher Unkel <cunkel@drivescale.com>
---
This series replaces the first patch of the previous series
(https://lkml.org/lkml/2020/10/22/1058), with the following changes:

1. Creates a helper function super_1_sb_length_ok().
2. Fixes operator placement style violation.
3. Covers case in super_1_sync().
4. Refactors duplicate logic.
5. Covers a case in existing code where aligned superblock could
   run into bitmap.

 drivers/md/md.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 802a9a256fe5..3b7bf14922ac 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1768,13 +1768,8 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	atomic_set(&rdev->corrected_errors, le32_to_cpu(sb->cnt_corrected_read));
 
 	super_1_set_rdev_sb_size(rdev, le32_to_cpu(sb->max_dev), minor_version);
-
-	if (minor_version
-	    && rdev->data_offset < sb_start + (rdev->sb_size/512))
-		return -EINVAL;
-	if (minor_version
-	    && rdev->new_data_offset < sb_start + (rdev->sb_size/512))
-		return -EINVAL;
+	if (!super_1_sb_length_ok(rdev, minor_version, rdev->sb_size))
+	    return -EINVAL;
 
 	if (sb->level == cpu_to_le32(LEVEL_MULTIPATH))
 		rdev->desc_nr = -1;
-- 
2.17.1

