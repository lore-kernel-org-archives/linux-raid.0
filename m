Return-Path: <SRS0=YfF9=D6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F591C4363A
	for <linux-raid@archiver.kernel.org>; Fri, 23 Oct 2020 03:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16CEC2177B
	for <linux-raid@archiver.kernel.org>; Fri, 23 Oct 2020 03:32:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=drivescale-com.20150623.gappssmtp.com header.i=@drivescale-com.20150623.gappssmtp.com header.b="FDqHw2Ab"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460398AbgJWDby (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Oct 2020 23:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374883AbgJWDbp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Oct 2020 23:31:45 -0400
Received: from mail-vs1-xe62.google.com (mail-vs1-xe62.google.com [IPv6:2607:f8b0:4864:20::e62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAD8C0613D4
        for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2020 20:31:44 -0700 (PDT)
Received: by mail-vs1-xe62.google.com with SMTP id d19so113815vso.10
        for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2020 20:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=drivescale-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kVOU56vMIKPwRdSa1DX4NgPyTaBBOM7ISpZAf+v+NPc=;
        b=FDqHw2AbeHw6eX4xu+NIjrtMPLcV35cn+OI5XXsmrMmacbgmO0nReXcxT9fALCsb4J
         dmRS1nB0hZaY/g4t9LFwCbv8qZzbt2OMSGH8tGHpn4p2zme0ya5sWPWYfOKXJ4QcPu2a
         HzY6USAQHcs07Ex4HUobYzn6uMa0oyfATmauyOnRYIOPUzQLcE8UcpmDHSBr2C1rXncV
         i2V/gIdf5ZeJ+Dr8nSEkugfpzi7PVptZWpDjt+iQw/hgaS/31cl0Yy4VppT2vDls6KFQ
         K4rVQw0d04AqNw/Nc4CGCniUENd2mYMWrANS3Epp+JTm02OBYnOMJHq7Qp+oJvqv/AAc
         O7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kVOU56vMIKPwRdSa1DX4NgPyTaBBOM7ISpZAf+v+NPc=;
        b=alcTKDhw/KyZD47AGRgIeG5DgLJp2n5J88BccKG1Pj/RV7VLa6bJnmRBlWGHRuqi00
         RZ5vaORLz3KerRTy8Dmffwmg37yKHl1B3u0/l4AQxp35abNG6Y+2+dBtKcItDrhFPdCH
         0/we/BRAOWBt3uVYSbWUFqoScxK6EYHUzjQAptbjWUyFQezind6Ze3C9BKCxrbtl4fsx
         1e75BGaMFUbvAsFh29QfmtTFk/hcCTku7VRppLLddW8+C2rsDGsmZm2ns9dekOoP10xu
         CDVOZlXlXEXNz+3Dyh8vOe+Rjxigyg7xpUFKasY7+D8msbYaL3RxDOkP2QAHPgKo/x1U
         hn+w==
X-Gm-Message-State: AOAM533uSkK/jsML7AnPb0/ydztdWV3WhM4CTiQXPNtJR8Ibp1VLr9qI
        FW+gjlWDP1nJsFDOLUoSKRIXL3bJPrwFrN9aF4cYrZgNME9Vmg==
X-Google-Smtp-Source: ABdhPJyBqtEAMrygy9f0ONPybfZe//14DeioNF4I0kf3/eYvXo/Ag1D3weXXgQLx7e8KDeaIn4+skGf9Rlch
X-Received: by 2002:a67:ea4e:: with SMTP id r14mr205149vso.47.1603423903465;
        Thu, 22 Oct 2020 20:31:43 -0700 (PDT)
Received: from dcs.hq.drivescale.com ([68.74.115.3])
        by smtp-relay.gmail.com with ESMTP id h12sm41939uar.2.2020.10.22.20.31.43;
        Thu, 22 Oct 2020 20:31:43 -0700 (PDT)
X-Relaying-Domain: drivescale.com
Received: from localhost.localdomain (gw1-dc.hq.drivescale.com [192.168.33.175])
        by dcs.hq.drivescale.com (Postfix) with ESMTP id 891494211A;
        Fri, 23 Oct 2020 03:31:42 +0000 (UTC)
From:   Christopher Unkel <cunkel@drivescale.com>
To:     linux-raid@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Song Liu <song@kernel.org>,
        cunkel@drivescale.com
Subject: [PATCH 1/3] md: align superblock writes to physical blocks
Date:   Thu, 22 Oct 2020 20:31:28 -0700
Message-Id: <20201023033130.11354-2-cunkel@drivescale.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201023033130.11354-1-cunkel@drivescale.com>
References: <20201023033130.11354-1-cunkel@drivescale.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Writes of the md superblock are aligned to the logical blocks of the
containing device, but no attempt is made to align them to physical
block boundaries.  This means that on a "512e" device (4k physical, 512
logical) every superblock update hits the 512-byte emulation and the
possible associated performance penalty.

Respect the physical block alignment when possible.

Signed-off-by: Christopher Unkel <cunkel@drivescale.com>
---
 drivers/md/md.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 98bac4f304ae..2b42850acfb3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1732,6 +1732,21 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	    && rdev->new_data_offset < sb_start + (rdev->sb_size/512))
 		return -EINVAL;
 
+	/* Respect physical block size if feasible. */
+	bmask = queue_physical_block_size(rdev->bdev->bd_disk->queue)-1;
+	if (!((rdev->sb_start * 512) & bmask) && (rdev->sb_size & bmask)) {
+		int candidate_size = (rdev->sb_size | bmask) + 1;
+
+		if (minor_version) {
+			int sectors = candidate_size / 512;
+
+			if (rdev->data_offset >= sb_start + sectors
+			    && rdev->new_data_offset >= sb_start + sectors)
+				rdev->sb_size = candidate_size;
+		} else if (bmask <= 4095)
+			rdev->sb_size = candidate_size;
+	}
+
 	if (sb->level == cpu_to_le32(LEVEL_MULTIPATH))
 		rdev->desc_nr = -1;
 	else
-- 
2.17.1

