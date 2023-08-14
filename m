Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FA5C04E69
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 13:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjHNNyl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 09:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjHNNyX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 09:54:23 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FCDE7D
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 06:54:22 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-688142a392eso3166245b3a.3
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 06:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1692021262; x=1692626062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lxdE2Q9T1UX2QI7uu1gFMik2XpiMuGjdCiq1TVfU6V0=;
        b=tGWHk+X5xic9wmoatJ059bBc5+bAlv/iXTBYwinz/0cP93jW2bj4RVhWhfB1qBYuCP
         95bFy2IaM7uFETzxIipK8y3VWwUsgJH7f/jhfQg8xn4uzbk6IGU4sSt2Bs04x2esKnsX
         302imBbTbMjuxQ5rVD4cx4XwajSMeIq+oOPIQgfryyboWsAT9heslGHSHo775pnjl+9I
         SZeBrOgAiUlHKBnPOgBz2xUk3UVOAcL4ZgKwolvddAiamf6uqEUQpi/ghhzgltjf3PEo
         SqKt0SZJsaimH0dGgjIZRgZcQbkxWy4z88+JSY1wu3NMJHs4qG9NuOw/KJafZ5d/iNW4
         Wdnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692021262; x=1692626062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lxdE2Q9T1UX2QI7uu1gFMik2XpiMuGjdCiq1TVfU6V0=;
        b=d/aiK4vUvLbIIK4AYpQL/vsQK3BERsz8Pv0dEc+JO4rv3TQgw9C2PwRehCZjQD0b9e
         lnNAGv5U8j2nqP9+XF3plGzC3gtlh7/jN1MmFjwEjuAjVVX6bP8ibsSjTiXB24962DGE
         08jjCQpZJkrOez9H0lT3imX/Bh1FVsvO5FHVd+BvmQnPCHgrlZRBhPlbp6NL+5cAGg5c
         HwSFniGpXAEgzAdKkfPavgBJeqXAEy+im2IvsViLyY5MpSxYIfTVe7iPeb5faZCCGBi8
         WzGju5lT0kT9Niho+1fPlfmpNJ6k3fFOL/XAzQIvQJNlsAAeUtBDNJsAXEPlCqAhxuqO
         dHHg==
X-Gm-Message-State: AOJu0YweY8Hj4ZQZk7NPyn4JoIopRXQ4KLA5ZcOTyqWptsYuvddSb0n8
        /b0a3y9BRwRLaZ1EuJMZeg2xBQ==
X-Google-Smtp-Source: AGHT+IGyxBs1Am1hZ6Ysv3NF3J2PmmouELd2lJvBLjzWavaypnWGaYdXMu4Ay/HKYFFnGzI46Ljrlw==
X-Received: by 2002:a05:6a00:134c:b0:682:a6c5:6f28 with SMTP id k12-20020a056a00134c00b00682a6c56f28mr14455219pfu.32.1692021261937;
        Mon, 14 Aug 2023 06:54:21 -0700 (PDT)
Received: from nixos.tailf4e9e.ts.net ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id m26-20020a056a00165a00b006874a6850e9sm7962122pfc.215.2023.08.14.06.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 06:54:21 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     yukuai3@huawei.com, song@kernel.org, dan.j.williams@intel.com,
        neilb@suse.de, akpm@linux-foundation.org, neilb@suse.com
Cc:     linux-raid@vger.kernel.org, Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH v6 1/3] md/raid1: call free_r1bio() before allow_barrier()
Date:   Mon, 14 Aug 2023 21:53:54 +0800
Message-Id: <20230814135356.1113639-2-xueshi.hu@smartx.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230814135356.1113639-1-xueshi.hu@smartx.com>
References: <20230814135356.1113639-1-xueshi.hu@smartx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

After allow_barrier(), an concurrent raid1_reshape() will replace old
mempool and r1conf::raid_disks, which are necessary when freeing the
r1bio. Change the execution order of free_r1bio() and allow_barrier() so
that kernel can free r1bio safely.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
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

