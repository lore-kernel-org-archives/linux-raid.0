Return-Path: <SRS0=1sSQ=DF=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F59C2D0A8
	for <linux-raid@archiver.kernel.org>; Mon, 28 Sep 2020 16:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 504C72065D
	for <linux-raid@archiver.kernel.org>; Mon, 28 Sep 2020 16:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgI1QQj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Sep 2020 12:16:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33215 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgI1QQj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 28 Sep 2020 12:16:39 -0400
Received: from mail-qv1-f71.google.com ([209.85.219.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <eric.desrochers@canonical.com>)
        id 1kMvpM-00021G-5Y
        for linux-raid@vger.kernel.org; Mon, 28 Sep 2020 16:16:36 +0000
Received: by mail-qv1-f71.google.com with SMTP id di5so900972qvb.13
        for <linux-raid@vger.kernel.org>; Mon, 28 Sep 2020 09:16:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e75M8i8rPmJJAWc92l4ApsOESsoe7OiYEefV5g9u9m8=;
        b=EOYUNr+d9vItY9hmElsBYpqpJ7NWSMfOfuercQR9Tbc/dBUYKgSeIOFmQ0hTjyOesJ
         26QPAWv78opHXw9cEAQB7g6JHuy7YUqYsQiMMdpmfwZi9Ggw7xS9E7pgJNZvCeCnpBA0
         0GiWJIujIjERT5We7ZHp4+TjWZMFL/9udwq+a4+Ijyd80NpBnAW3qr3TnMriqiw1Keo1
         tT1q6xMwdtBjZDcl9D+onH0rvH0Wij9cBjTjk+KesSgZ6wv2BUz4k6Yt6m7BhzwTVpro
         xA3E48ap/rEJtJJKEovAzAR4rcE+7HuR25FTLYGFN2dYPvfB5FGzasBmXpcpsTuuaBIc
         tanA==
X-Gm-Message-State: AOAM533ZhZLzdiOyF3HCgyLyeuvL+fWrMo7NvFQzBH8SNEXjTtvOoYwA
        xFCw7heeB2dyoLLolOkF4kkBIw5oZSjR66bn7pDDR7uZWYpd/n7LNZhTl+5vBxp7FVO5Zy5kMeQ
        oBvMifkrab9UcH/DZ8JNUcozPoA9LILHnwwYXEaw=
X-Received: by 2002:ae9:e413:: with SMTP id q19mr211931qkc.214.1601309794570;
        Mon, 28 Sep 2020 09:16:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyzCBVbfO+I++zv+avecI8nMCV2yphYKFhVciDeazKWdbYQZBTVm8vDh1OWaoMK/KmT6DRFw==
X-Received: by 2002:ae9:e413:: with SMTP id q19mr211905qkc.214.1601309794218;
        Mon, 28 Sep 2020 09:16:34 -0700 (PDT)
Received: from thinkpad.in.azkaban.com (modemcable063.174-201-24.mc.videotron.ca. [24.201.174.63])
        by smtp.gmail.com with ESMTPSA id s20sm1411849qkg.65.2020.09.28.09.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 09:16:33 -0700 (PDT)
From:   Eric Desrochers <eric.desrochers@canonical.com>
To:     linux-raid@vger.kernel.org
Cc:     Eric Desrochers <eric.desrochers@canonical.com>
Subject: [PATCH] mdcheck: Remove extra spaces in systemd timer directives
Date:   Mon, 28 Sep 2020 12:16:30 -0400
Message-Id: <20200928161630.21260-1-eric.desrochers@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

At package maintainer level, this is causing 'mdadm' to fail
to build. (e.g. In debian, causing debhelper's dh_installsystemd to not
find units to install due to the extra space.)

 "dh_installsystemd: error: Package 'mdadm' does not install unit ''. "

Signoff-by: Eric Desrochers <eric.desrochers@canonical.com>
---
 systemd/mdcheck_continue.timer | 2 +-
 systemd/mdcheck_start.timer    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/systemd/mdcheck_continue.timer b/systemd/mdcheck_continue.timer
index dba1074..3150fee 100644
--- a/systemd/mdcheck_continue.timer
+++ b/systemd/mdcheck_continue.timer
@@ -12,4 +12,4 @@ Description=MD array scrubbing - continuation
 OnCalendar= 1:05:00
 
 [Install]
-WantedBy= mdmonitor.service
+WantedBy=mdmonitor.service
diff --git a/systemd/mdcheck_start.timer b/systemd/mdcheck_start.timer
index 9e7e02a..e5d727a 100644
--- a/systemd/mdcheck_start.timer
+++ b/systemd/mdcheck_start.timer
@@ -12,5 +12,5 @@ Description=MD array scrubbing
 OnCalendar=Sun *-*-1..7 1:00:00
 
 [Install]
-WantedBy= mdmonitor.service
-Also= mdcheck_continue.timer
+WantedBy=mdmonitor.service
+Also=mdcheck_continue.timer
-- 
2.25.1

