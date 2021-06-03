Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5FAC47082
	for <linux-raid@archiver.kernel.org>; Thu,  3 Jun 2021 09:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E63A6100A
	for <linux-raid@archiver.kernel.org>; Thu,  3 Jun 2021 09:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhFCJXf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Jun 2021 05:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFCJXf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Jun 2021 05:23:35 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32A5C06174A
        for <linux-raid@vger.kernel.org>; Thu,  3 Jun 2021 02:21:44 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c13so2593563plz.0
        for <linux-raid@vger.kernel.org>; Thu, 03 Jun 2021 02:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5AAS03L5ETEyXJmY7BKzSTzkPIrfsAOYUCBonylEsIc=;
        b=EjtjPpjbmxF4VehDttASrL02pubglXKhaTWHGm3fzZfA3hrQdGjxya8RMivQO5TeUY
         aW37tY5W1JSdDcGKUReFU3L0oIyvyqRSCtgPpd6JlRV/c/93NABiUwyJGUVks3Qv5vi2
         1E4rzKMObZ4RVHU7GafFsK/y2L8HVjkurldc6rMGs6UxDftKIueKUlE2YuQijr2uLQLq
         s7zXBLKNfNQ00R09Y8phtZGKz5wG5ITHJb+GT8hYvunPUii771ZBzDyyIPCcwhkOvBmO
         ntTIg5HNuehogngtXFWxyu1v48rosHxUcfs3+CzYXPI+6TnqSjxH3eB7uTMU+z/4BnlW
         WSKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5AAS03L5ETEyXJmY7BKzSTzkPIrfsAOYUCBonylEsIc=;
        b=R3vTUVXopQhAqJgpXy3RuMKxbY2mYvdhbkEfpX48DV8Q32QettejUyG1jQ98dpBGHQ
         zZ47nJPEIB/X5mnNlnt7epJxBko9Vqq+DT+m42jziPjJtDlJPqqAmj2vhFpVBZZhVgog
         nMj/sk7gXnc/p5JU+iQob3fZSXMx5FZ8KEDv+e2pmaxkaqBJmMCfnM4tsIOAZ0qGQvTz
         TWPIBvMMS8kOwYeGuQRSXUSA7CnyrhTyQuXltaCt924XvpXy5qNIz4gq7+dOAg7wVp+5
         /FIpuRJKHnMmr9nPws2gMjVafGP6SwO3SHIFqCw7c8us+gvXNS6PlBIJ32eEp0+tzO5y
         Y19w==
X-Gm-Message-State: AOAM533v+fWxOFCEV5Anxp4hB4+55iFa38Is6DFB4bkkYrciC5GFy1zJ
        OYGl3wpNVEn31O7r8Ldg+0M=
X-Google-Smtp-Source: ABdhPJxpa5iK0syILaHGJ0AvEpXk10vo2leghfFGWRKvPqD584i4xyHNiSaCGsz8j3a4gqqyDxUOvw==
X-Received: by 2002:a17:90a:c68a:: with SMTP id n10mr10303256pjt.32.1622712104284;
        Thu, 03 Jun 2021 02:21:44 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id c24sm1937249pfn.63.2021.06.03.02.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 02:21:43 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 0/2] incremental patches about io stats
Date:   Thu,  3 Jun 2021 17:21:05 +0800
Message-Id: <20210603092107.1415706-1-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

The first one addressed Christoph's comment, and I also add another one
to explain why error handling is not needed there. Please review.

Thanks,
Guoqing

Guoqing Jiang (2):
  md: check level before create and exit io_acct_set
  md: add comments in md_integrity_register

 drivers/md/md.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

-- 
2.25.1

