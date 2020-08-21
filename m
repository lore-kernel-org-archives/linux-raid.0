Return-Path: <SRS0=1IH2=B7=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16479C433E1
	for <linux-raid@archiver.kernel.org>; Fri, 21 Aug 2020 05:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFEE421734
	for <linux-raid@archiver.kernel.org>; Fri, 21 Aug 2020 05:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgHUFKC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Aug 2020 01:10:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:46468 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgHUFKB (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 21 Aug 2020 01:10:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 332E2AD3C;
        Fri, 21 Aug 2020 05:10:28 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jsorensen@fb.com, linux-raid@vger.kernel.org
Cc:     Ali Abdallah <ali.abdallah@suse.com>, Coly Li <colyli@suse.de>
Subject: [PATCH] mdcheck: fix syntax error in mdcheck_start.timer
Date:   Fri, 21 Aug 2020 13:09:55 +0800
Message-Id: <20200821050955.13435-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Ali Abdallah <ali.abdallah@suse.com>

From: Ali Abdallah <ali.abdallah@suse.com>

systemd fails to parse mdadm-timer Calendar specification, here is the
error log message:

systemd[1]: [/usr/lib/systemd/system/mdcheck_start.timer:12] Failed to parse calendar specification, ignoring: Sun *-*-1..7 1:00:00
systemd[1]: mdcheck_start.timer: Timer unit lacks value setting. Refusing.

This patch fixes the mistaken syntax in mdcheck_start.timer and solve
the above error messsage.

Signed-off-by: Ali Abdallah <ali.abdallah@suse.com>
Acked-by: Coly Li <colyli@suse.de>
---
 systemd/mdcheck_start.timer | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/systemd/mdcheck_start.timer b/systemd/mdcheck_start.timer
index 9e7e02a..ba15ef5 100644
--- a/systemd/mdcheck_start.timer
+++ b/systemd/mdcheck_start.timer
@@ -9,7 +9,7 @@
 Description=MD array scrubbing
 
 [Timer]
-OnCalendar=Sun *-*-1..7 1:00:00
+OnCalendar=Sun *-*-* 1:00:00
 
 [Install]
 WantedBy= mdmonitor.service
-- 
2.26.2

