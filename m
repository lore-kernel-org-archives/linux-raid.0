Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0558C433E6
	for <linux-raid@archiver.kernel.org>; Tue,  5 Jan 2021 10:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8675C224F9
	for <linux-raid@archiver.kernel.org>; Tue,  5 Jan 2021 10:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbhAEKIU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Jan 2021 05:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728054AbhAEKIT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Jan 2021 05:08:19 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B60EC061793;
        Tue,  5 Jan 2021 02:07:39 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id o6so27647043iob.10;
        Tue, 05 Jan 2021 02:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ccgp0E4J7ckyMBD4S6oa4zMRT5+hLIG3b8SFsxJtqgc=;
        b=jQcfDMrbHYolNtINIECH9yXVONwXqWTPajdwaDyOJAyy+8K944lEVJichjqBoFTEOA
         ZplKD2EVZQu43FJE+jZ+tAdzd8qRFLyY4o9X1H8gYdhpzFbaDUTHvG73fApA8p1tFzc1
         G6/JcbTA97Ss7datuoJPfCT20IOc2+WKvJUbK9vaCUQ1qPy50pcllC5HIraiCvceH5Rz
         P6MoohTATljkVoY1g+Q0lnnqlgN9rHUaLa6Fh2/sk87fGw//OHrhuy5sAQjG5C7XVKaY
         N/kWBHjj3jST43pTqGR1rdCjIWuCyi+CQo3CZSMIoNwM79UBCNye4elvYNBB978YHsLv
         YbQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ccgp0E4J7ckyMBD4S6oa4zMRT5+hLIG3b8SFsxJtqgc=;
        b=kwfNF+4xNHb0yy5O9SxJxApeG/OVW9xfxl6YzwLLfTzxNXshHzFPjQ7huvwN+VwEwB
         CAadBeD6Dzr5ppnsFCC3t8IpP/32Rg+rStkk4LBnegowgkbZSkkwsS6EaTbGW6KbQKG8
         odYekYQjrrs4VmCbrwxuMv4GKrYRyRpnFprq4eFPLepi/P/1GFoJa/EAgVYj/zya99fx
         hAmUcBDZyL1NEnA8f8GEh1vKO8Q3yOe6O3OUZEpLNmY5JM1pugC6Qvgl5fJdqZMJBJQR
         dRwMq8VnyMU17Vkfzekpk6oHf5T8QTjh2S+rb+9rkyqV86AnYViwO1tLzNOzV5QRwPYB
         gqBQ==
X-Gm-Message-State: AOAM530RWSO4LHkQrsY7FE8hr+3W5krXMahDh8F3Ua0WO+2xCrc5V+4K
        ObOKBhHwBFsSf3tu4tl0FYg=
X-Google-Smtp-Source: ABdhPJynVL0XaQ3YFzifBmzpkJjRWDlbjn3Pz6YeaKeymHLhnqauorQNsT+tWTVW4ijSCcyXvzLbNg==
X-Received: by 2002:a02:9f8b:: with SMTP id a11mr66785147jam.108.1609841258942;
        Tue, 05 Jan 2021 02:07:38 -0800 (PST)
Received: from localhost.localdomain ([156.146.37.136])
        by smtp.gmail.com with ESMTPSA id v66sm38930437iod.34.2021.01.05.02.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 02:07:38 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     song@kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: md: Fix another spelling at top of the file
Date:   Tue,  5 Jan 2021 15:37:36 +0530
Message-Id: <20210105100736.6237-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

s/fautly/faulty/p

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/md/md-faulty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-faulty.c b/drivers/md/md-faulty.c
index fda4cb3f936f..076b93f7d443 100644
--- a/drivers/md/md-faulty.c
+++ b/drivers/md/md-faulty.c
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 2004 Neil Brown
  *
- * fautly-device-simulator personality for md
+ * faulty-device-simulator personality for md
  */


--
2.26.2

