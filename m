Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A12DC001B0
	for <linux-raid@archiver.kernel.org>; Sun,  9 Jul 2023 10:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjGIKaK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 9 Jul 2023 06:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjGIKaJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 9 Jul 2023 06:30:09 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463F7F4
        for <linux-raid@vger.kernel.org>; Sun,  9 Jul 2023 03:30:08 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b852785a65so22342785ad.0
        for <linux-raid@vger.kernel.org>; Sun, 09 Jul 2023 03:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1688898607; x=1691490607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gs/McJuB6h4mc7keVidPugoMclhLpdnhZvr1zie07xI=;
        b=Gemao1RHEYh1BL47dzs4ObslG4pm02SpOAmLDNurZLVFFiKUS8qDVgqTIlL6sntWoo
         /8E6tJ7h8eRJm2Fv2gX2E5xIggJ8JdmG325kWTLHaOe+GyrWmlkTKHm0JaFZ+fSMqomE
         l2BgkRyBUNv46DpBCTM3HAWuIzlvMgS5+8PCJvP/RW+vcI7xbVOTy4w20S5PiwA/y6iz
         SthRMq4t7K/07Yq9z505aAV3uG5iBpJKZHAoQUqD+aupk+zBWokkho+VpAwf1miK+zSz
         DIpwqACDzO0nJnv2et0soTLZd4S+64duT274AgZoqqSXVTIB+TuPxawByia9bqHnW68E
         x6jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688898607; x=1691490607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gs/McJuB6h4mc7keVidPugoMclhLpdnhZvr1zie07xI=;
        b=YBCZuJNxSDo5DsiAmggaKXYkUrnnXDZA8nYPpbqM9lCkv/cypK3MwlGOgtLs5w2sm+
         qqMHHJivse53dsqIkrDHzWVZjt/dP4FnS3gUTNsCp70MSr3ik16tPKde/ic9HwPXeUIn
         k8nZ7ogOXgIc99QvE1j5/trVlWqg3lR2s2kLdFMXtsZAnwxtHPHh62OVh2VCiCzy2J3l
         TbWtaEVzpSYniTgTX9tD+CcO1Na5UevOqV7cfFeLrhInrzRwj8XUcKyNeHgLE0ej/kBi
         uk8n5qW2q7cWDzi+jyFtlDE7UCjnQYtXMNqBMtLt4jRm0enVZRPpIB9DEgpWNFp7gGdq
         MxMA==
X-Gm-Message-State: ABy/qLZZCsZ4ePy+/cANXENe24GvmdsWPBI35hPVE4G3C65RiFd/DgEw
        uiJYiyPIklmBR5htT9PYyNkIumLXlnY3hamZRO0ZbmvyLMZZZQ==
X-Google-Smtp-Source: APBJJlFJMdK68NBuGx+ZKJDoGqi8wII4rEOmMKEkEW9Scd29R2zxcO1tRj3B5zfHDjTDZxnCOVxodA==
X-Received: by 2002:a17:902:d2c1:b0:1b8:6245:1235 with SMTP id n1-20020a170902d2c100b001b862451235mr20467917plc.13.1688898607529;
        Sun, 09 Jul 2023 03:30:07 -0700 (PDT)
Received: from localhost.localdomain ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id i19-20020a170902eb5300b001b9be2e2b3esm4479140pli.277.2023.07.09.03.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jul 2023 03:30:07 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
X-Google-Original-From: Xueshi Hu <hubachelar@gmail.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH v2 1/3] md/raid1: gave up reshape in case there's queued io
Date:   Sun,  9 Jul 2023 18:29:54 +0800
Message-Id: <20230709102956.1716708-2-hubachelar@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230709102956.1716708-1-hubachelar@gmail.com>
References: <20230709102956.1716708-1-hubachelar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Xueshi Hu <xueshi.hu@smartx.com>

When an IO error happens, reschedule_retry() will increase
r1conf::nr_queued, which makes freeze_array() unblocked. However, before
all r1bio in the memory pool are released, the memory pool should not be
modified.

Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
---
 drivers/md/raid1.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index dd25832eb045..ce48cb3af301 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3298,6 +3298,13 @@ static int raid1_reshape(struct mddev *mddev)
 
 	freeze_array(conf, 0);
 
+	if (unlikely(atomic_read(conf->nr_queued))) {
+		kfree(newpoolinfo);
+		mempool_exit(&newpool);
+		unfreeze_array(conf);
+		return -EBUSY;
+	}
+
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
 	conf->r1bio_pool = newpool;
-- 
2.40.1

