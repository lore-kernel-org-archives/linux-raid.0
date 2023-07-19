Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCAFEB64DA
	for <linux-raid@archiver.kernel.org>; Wed, 19 Jul 2023 07:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjGSHKf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Jul 2023 03:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjGSHKV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Jul 2023 03:10:21 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF481FF9
        for <linux-raid@vger.kernel.org>; Wed, 19 Jul 2023 00:10:15 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-262cc036fa4so3298336a91.3
        for <linux-raid@vger.kernel.org>; Wed, 19 Jul 2023 00:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1689750615; x=1690355415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+GUfPaqxqaUbNGMzDV0eCmb+o/mlJufIsxGkzLSwirc=;
        b=D4a9wfLwOk+EeiihfhlbyTKToRAV88WCeIllIhlFdwBJG90hPB8ajT+YTto0j/09yh
         dVmq0F4w+7Vz/UDFJtsVrVeolhIAe0J6bOeSfOoQ6XeRADARS8mdcGR4F8QiDZim8XWZ
         SAttiE7YvAuha+u52ZxQ02ZrpdUyLCfhV3r90dG/ka0s0rsCFzvweNeuAGOfpN+zYrLO
         4Q/XBW+5lxLvckWlOlhgcRhET7LSKQnTCqf/Nf0y/3X99zManQXy+OK5uu5tNl6WI+fY
         WuhN3yuV9G/aKtMVJXPdfs/EQshLypsZmEREhWV5paYGJHFrkvdt/lVLglt09XwKNF/y
         s/Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689750615; x=1690355415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+GUfPaqxqaUbNGMzDV0eCmb+o/mlJufIsxGkzLSwirc=;
        b=ZZQXE3y/S6ZixcXBbUTctOVd2o8RPp5C1xUpElueRJsiQMCPg8teZrcEXXYXk5PeeZ
         hxIpWdlxYj9JRoPyDruu4vwXrMf734ZfyPs1bXg7DNQ+3cfQwmoeIFYQIvxod6b9d5RQ
         4waTj7zotp4RjLinFfkefZW+bOClcEn42ze06H2a7iarhzc3LIxeTkbm1NeBQ0yTGBR2
         ZEAQMfj/Yf9VKRekhG9Bo+DcJg0xbKmviHx1Ej1gQfd3HotSCHwTiNaKzw4c7T+qbHug
         JcF7Wk+SzPK1G+9plg/tTjoqRQHsGDb/0UidJ8Oe+P22ML6RcjX75/ATZEsoDDVwiHe+
         OPhA==
X-Gm-Message-State: ABy/qLbpwaQ8bYbGi5cV/sTIkquS3YBAZrodbI2898o5uOmGRs2G+zt7
        C0A59/rNUJhnWoyik6fokyvclQ==
X-Google-Smtp-Source: APBJJlGuywjdg2Q74UiqFyaXEYhAH7hffQgOW+l/KLQj3mmV6MkSGh7JorYRCmqJYn8qhkjpPK+IUQ==
X-Received: by 2002:a17:90b:354a:b0:263:e1db:7275 with SMTP id lt10-20020a17090b354a00b00263e1db7275mr12020194pjb.6.1689750615322;
        Wed, 19 Jul 2023 00:10:15 -0700 (PDT)
Received: from nixos.tailf4e9e.ts.net ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id 11-20020a17090a194b00b002639c4f81cesm667453pjh.3.2023.07.19.00.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 00:10:15 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, yukuai1@huaweicloud.com,
        Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH v3 3/3] md/raid1: check array size before reshape
Date:   Wed, 19 Jul 2023 15:09:54 +0800
Message-Id: <20230719070954.3084379-4-xueshi.hu@smartx.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719070954.3084379-1-xueshi.hu@smartx.com>
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If array size doesn't changed, nothing need to do.

Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
---
 drivers/md/raid1.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 62e86b7d1561..5840b8b0f9b7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3282,9 +3282,6 @@ static int raid1_reshape(struct mddev *mddev)
 	int d, d2;
 	int ret;
 
-	memset(&newpool, 0, sizeof(newpool));
-	memset(&oldpool, 0, sizeof(oldpool));
-
 	/* Cannot change chunk_size, layout, or level */
 	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
 	    mddev->layout != mddev->new_layout ||
@@ -3295,6 +3292,12 @@ static int raid1_reshape(struct mddev *mddev)
 		return -EINVAL;
 	}
 
+	if (mddev->delta_disks == 0)
+		return 0; /* nothing to do */
+
+	memset(&newpool, 0, sizeof(newpool));
+	memset(&oldpool, 0, sizeof(oldpool));
+
 	if (!mddev_is_clustered(mddev))
 		md_allow_write(mddev);
 
-- 
2.40.1

