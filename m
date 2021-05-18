Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD1B7C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 05:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BEA760FDB
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 05:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240914AbhERFeU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 01:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240761AbhERFeT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 01:34:19 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161C0C061573
        for <linux-raid@vger.kernel.org>; Mon, 17 May 2021 22:33:02 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g24so4889548pji.4
        for <linux-raid@vger.kernel.org>; Mon, 17 May 2021 22:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3VJc2yUzng4VQB19e82N28A7WO9cMZehahmu2E+2OgI=;
        b=TEHFJwlXa2ZtfIox7yQ//hIoJmaIVLQ+2IZt5nykAWy1MT0B1rYlzGtpkzAa8WuNfv
         lLbjd+MvSiQkpYqJ+W/QLKLZUP2snF1iE2ZpwtR+K+XR3g2L4Sq/GR5oTfNZ3u9VVSPY
         lHp1DWt8Gs86j2tT53pE/76kDnESirCPAKaYbMIU6464UtqT63dC7zi1myewd+LUC8f4
         6kPVEZKVN4BpBk4noRYxPOTUuv9mOt7jEZkPvo94/diNks8Z3aTNfx8C/zlnqj4KSat2
         InwBiksVuG+8WUHlPPFA88JHhpkdWrtCzHCQ9abUsONODrCwYa3i2ZALpCdQ/UNOHkMZ
         IVgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3VJc2yUzng4VQB19e82N28A7WO9cMZehahmu2E+2OgI=;
        b=kGS4yFJhx4Xr6JhiNPY6UdZpvp9yV7Jo7qKM/NgU3csGo1+g5Ovt+xqZmDY6m5XUWx
         211TzVvfbYKMq4FBD0cfG+JZi6VE/U76/a87o8wvUFVDIfb/grCLV+KUR9x8UmnRB6+N
         /F5alw2zMxVbP8GJBSRcCySS4snQYsc+4KRwvJdaMpVdRRnJxvEuuOpOtiV6jQz6GkR+
         1x/vdGTnPXSr1KJKJ3bA0EWzIC6GP38xd479mAeFNT3JKKNMuPDY5xGW4hQ3PY5dFM3E
         bc+zTYJH9o8i90N68yNl2uGKZoY+JgV/744NVN7FTulC4yTv7v8Yz+gmcCVaaaXKWYpa
         INlw==
X-Gm-Message-State: AOAM533vRVq/gGGJzCOa4gdhXMLyuEfmXvM5sCrHN5t3cvD16vPra5Id
        +JKD9Bs2mu1iL0nSxs+Fh2E=
X-Google-Smtp-Source: ABdhPJwoLRU9lzocuxBmITFTtTF8ur0Agl0OYFarXrKYSqqWDxhMYE0jjlP4qv0vl1kDaRDPxmpNYw==
X-Received: by 2002:a17:90a:d793:: with SMTP id z19mr3511656pju.91.1621315981638;
        Mon, 17 May 2021 22:33:01 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id z20sm11756726pjq.47.2021.05.17.22.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 22:33:01 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
Subject: [PATCH 0/5] md: io stats accounting
Date:   Tue, 18 May 2021 13:32:20 +0800
Message-Id: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

Based on previous discussion, this set reverts current mechanism, then
switches back to the v1 version from Artur.

Also reuses the current clone infrastructer for mpath, raid1 and raid10.

Thanks,
Guoqing    

Guoqing Jiang (5):
  md: revert io stats accounting
  md: the latest try for improve io stats accounting
  md-multipath: enable io accounting
  md/raid1: enable io accounting
  md/raid10: enable io accounting

 drivers/md/md-multipath.c |  5 ++++
 drivers/md/md-multipath.h |  1 +
 drivers/md/md.c           | 63 ++++++++++++++++++++++-----------------
 drivers/md/md.h           |  2 +-
 drivers/md/raid1.c        | 11 +++++++
 drivers/md/raid1.h        |  1 +
 drivers/md/raid10.c       |  7 +++++
 drivers/md/raid10.h       |  1 +
 8 files changed, 62 insertions(+), 29 deletions(-)

-- 
2.25.1

