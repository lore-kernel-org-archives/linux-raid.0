Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331ECEB64DD
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 08:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjHNIvb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 04:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbjHNIv3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 04:51:29 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6301BF
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 01:51:28 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-686ba97e4feso3959974b3a.0
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 01:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1692003088; x=1692607888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JYH9G+Wt6Ub5OE4dUzW+0/2J+mzsvG/nR+TsZwqDITw=;
        b=JQO8nPP8tAnsFE77Kf75i+mjqeukEdDjug3P4Ol03TUmYpMuFw08d6qmjt8z85xX84
         DhAJ1cWO3ml+FTvguVtxQcEDgxtV/vbXlea6TL7TpmYbaxW3UnLG6ajVROQwlwf7fG6D
         Y87BcshvQeHHfoqMX2rcvbhNyqoLUk5i7gbOuh6eAebrOc/tSe8A4vo/5xwJ/6Qbowr4
         NvNYSFidlYFOPMdAaaiFTZiUTgaG9MXk7H9nyBxsAa/N/27xuT6pgV2/5p/ssR1DKBdY
         YAEpzBGP/o48F6icTFiu14y3MW7ujidz0Dy/+KBkEyZ8zrI2+1aqamCi0S1DK0PBraEK
         xrEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692003088; x=1692607888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JYH9G+Wt6Ub5OE4dUzW+0/2J+mzsvG/nR+TsZwqDITw=;
        b=LvJD0Km9EC0p32PHwlG2g+pL9pgcwakGzGE01oqm76BZZCvVD9fcM1Ty/NvxIBtzXN
         EIavmhgUFuVpOMXn5Kaz5+/fQNsEzKT3SYQmoNcm28Ksg/Ix6oDTDPQUYY+nEhyS0cOV
         yaMHwOmT7aCH4Q4YIkorv91jpojxRFqsQlsVnEi5ttoXDqKOWjixlB0XLP2h98rXIeJU
         LSHOtERnj7pQYCYxjWd9MUJIlVmMbvTBrsQCMYQEDrAAcHYOYdlbLTyJGx00Uprjz6D2
         chx10OiKoI+hPjGPcCy8WND4ewU4HMBSa29gXahq1FqGnPcz9FT9Lq9Mv4643YdxC+pv
         aNTQ==
X-Gm-Message-State: AOJu0YzyyND42AJcovPkuXxWUXNT3mfo3YduGQn3H7lh8eXezQjhXm6X
        9ljvBubSvMnWW0Nj9hHJtoZTkaTXgU9wJm7Z+yUCTGXY
X-Google-Smtp-Source: AGHT+IHZDM8HenNPnRE++mOH5+KBAfHhah9kpsKQN6+Zf0AaG1BybiZV0OMykyj25Id8DA8VUNSLEw==
X-Received: by 2002:a05:6a20:431a:b0:13f:9232:fd39 with SMTP id h26-20020a056a20431a00b0013f9232fd39mr13073181pzk.53.1692003087859;
        Mon, 14 Aug 2023 01:51:27 -0700 (PDT)
Received: from nixos.tailf4e9e.ts.net ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id fk1-20020a056a003a8100b006765cb3255asm7439668pfb.68.2023.08.14.01.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 01:51:27 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     song@kernel.org, djeffery@redhat.com, dan.j.williams@intel.com,
        neilb@suse.de, akpm@linux-foundation.org, neilb@suse.com
Cc:     linux-raid@vger.kernel.org, Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH v5 1/3] md/raid1: call free_r1bio() before allow_barrier()
Date:   Mon, 14 Aug 2023 16:51:06 +0800
Message-Id: <20230814085108.991040-2-xueshi.hu@smartx.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230814085108.991040-1-xueshi.hu@smartx.com>
References: <20230814085108.991040-1-xueshi.hu@smartx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

After allow_barrier(), an concurrent raid1_reshape() will replace old
mempool and r1conf::raid_disks, which are necessary when freeing the
r1bio. Change the execution order of free_r1bio() and allow_barrier() so
that kernel can free r1bio safely.

Fixes: c91114c2b89d ("md/raid1: release pending accounting for an I/O only after write-behind is also finished")
Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
---
 drivers/md/raid1.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index dd25832eb045..dbbee0c14a5b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -313,6 +313,7 @@ static void raid_end_bio_io(struct r1bio *r1_bio)
 {
 	struct bio *bio = r1_bio->master_bio;
 	struct r1conf *conf = r1_bio->mddev->private;
+	sector_t sector = r1_bio->sector;
 
 	/* if nobody has done the final endio yet, do it now */
 	if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
@@ -323,13 +324,13 @@ static void raid_end_bio_io(struct r1bio *r1_bio)
 
 		call_bio_endio(r1_bio);
 	}
+
+	free_r1bio(r1_bio);
 	/*
 	 * Wake up any possible resync thread that waits for the device
 	 * to go idle.  All I/Os, even write-behind writes, are done.
 	 */
-	allow_barrier(conf, r1_bio->sector);
-
-	free_r1bio(r1_bio);
+	allow_barrier(conf, sector);
 }
 
 /*
-- 
2.40.1

