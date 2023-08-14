Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDEECC001DB
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 13:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjHNNyj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 09:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbjHNNyb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 09:54:31 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313CCE7D
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 06:54:31 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-686ba97e4feso4189656b3a.0
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 06:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1692021270; x=1692626070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C3MZQsfMYBt41xrzdTuDgcS6K01tLRziULIDJrxSB8k=;
        b=aSIjw0VMeSHx0eEXGxufJLBmxIfRXmi2hRDUrZ3VcbxMm0PmBZKHIB/QeDZuhTW6le
         ffmrNtODrCQIezXStb194yYH2LmAhJgBhsRTbfA4rh3kjolXmsQhy76DxBz3roCPnNF+
         lJdH/naHYLe+jM6jcKZMTzIB4xnfcDshmIBvfv0AJdLhc6hFCG9qS8gj6UXsYCcP1prK
         qlpsxa49d35f53/2uVmlEqssRUByd1if/pkM3KO5yIIkBINsaIfk4/u3LP92XHcMxnX2
         3wRrhiiFP3YqGP6wHArLWw3LHrYJAnbyA5Dg4ci9I26hPmT+AX3Sp8c+xm2qQTtNEPCq
         WTaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692021270; x=1692626070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C3MZQsfMYBt41xrzdTuDgcS6K01tLRziULIDJrxSB8k=;
        b=jf+XBKQPFYsPOBREOJSIP/dVp2kLQXFu+08Oh59OJ2AnDUmYeVKa68Grea+1xJcX+y
         KNOhZYpLU1iXZwD4vw/b9MV1e8+OCOXaIeAzn2KbIlkGqCj3amHZMCKao/UHFNTYT4JY
         M+uvInDK8OijtJu2dbVZrsV9+7oaU1vuDn+foOd7+o0gogR0/74vqDe27kYgwHpZJ8Tf
         NLeFPiAy+7XP3N5egxW5QDTUzI5FNUCD5zNmGnm0P01TT6lecBcQyFDMQpqWk8q7S8IN
         qDzcyk8lnTAU+7W/oiv3ZVt3/K6Fzm09IIXTFEohvkJ9kaMJcoYmfv7PdrnVQLlA7jkJ
         Bypg==
X-Gm-Message-State: AOJu0YxdOFhIxtBGpQRmRiRFoZ6X7Dx1K7WF67Ueb++0TpdU/2LEF22P
        7T+EcEyFrJQeH2pjiHe94gBYnQ==
X-Google-Smtp-Source: AGHT+IH4j2dOeCx2B7+gSORCx0cb2QJ6nsF7WdiMIn5EQwHSmcX0EcuSIMrf8M+8HnCrk7NqbBJpBw==
X-Received: by 2002:a05:6a20:428f:b0:13a:6413:9004 with SMTP id o15-20020a056a20428f00b0013a64139004mr13493642pzj.43.1692021270624;
        Mon, 14 Aug 2023 06:54:30 -0700 (PDT)
Received: from nixos.tailf4e9e.ts.net ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id m26-20020a056a00165a00b006874a6850e9sm7962122pfc.215.2023.08.14.06.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 06:54:30 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     yukuai3@huawei.com, song@kernel.org, dan.j.williams@intel.com,
        neilb@suse.de, akpm@linux-foundation.org, neilb@suse.com
Cc:     linux-raid@vger.kernel.org, Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH v6 3/3] md/raid1: keep the barrier held until handle_read_error() finished
Date:   Mon, 14 Aug 2023 21:53:56 +0800
Message-Id: <20230814135356.1113639-4-xueshi.hu@smartx.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230814135356.1113639-1-xueshi.hu@smartx.com>
References: <20230814135356.1113639-1-xueshi.hu@smartx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

handle_read_error() will call allow_barrier() to match the former barrier
raising. However, it should put the allow_barrier() at the end to avoid an
concurrent raid reshape.

Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
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

