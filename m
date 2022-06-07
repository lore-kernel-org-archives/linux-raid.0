Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1D5CCA47C
	for <linux-raid@archiver.kernel.org>; Tue,  7 Jun 2022 18:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353803AbiFGSwE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Jun 2022 14:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353986AbiFGSqX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Jun 2022 14:46:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BD418CE06;
        Tue,  7 Jun 2022 10:59:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7E68ACE2422;
        Tue,  7 Jun 2022 17:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08DFC36B00;
        Tue,  7 Jun 2022 17:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624787;
        bh=6DyTdZ+3NmC1WOEKbVtBnVjs6rHMu8f5CzxpA4emPfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6S/oJLLfHPZshxxUM+3YfeyQ2Zc3elpY9+DK0hoPjx/IE5N+7WlbqAdwKcoQiqeq
         ESNo/lynS9NU4VnhM7ASWSk6tUQpBpyNj3S3ea+EYNpAQSoRNnxOoCH4ps12FVf6x5
         2dSDfo3G7VFZub4Mwb0OcB/tO7H3e0VC8ck+8ibaKTfvncnQbNrYNYALPv0jp4yyW1
         e1HLgm6hm5A610PS7c10nSlWWwX4xmxKQNI1fmRucxm9OhgGNDiEKI08NuOPRKIo1m
         1XE4oWeSRB2kMrEPnx+tDUVPJITSA3lYrGz4Mfp6J/D5PPvfqK4H7bnW+XtOTEUsS6
         GVYHdrUV9RzZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 25/38] md: protect md_unregister_thread from reentrancy
Date:   Tue,  7 Jun 2022 13:58:20 -0400
Message-Id: <20220607175835.480735-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175835.480735-1-sashal@kernel.org>
References: <20220607175835.480735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

[ Upstream commit 1e267742283a4b5a8ca65755c44166be27e9aa0f ]

Generally, the md_unregister_thread is called with reconfig_mutex, but
raid_message in dm-raid doesn't hold reconfig_mutex to unregister thread,
so md_unregister_thread can be called simulitaneously from two call sites
in theory.

Then after previous commit which remove the protection of reconfig_mutex
for md_unregister_thread completely, the potential issue could be worse
than before.

Let's take pers_lock at the beginning of function to ensure reentrancy.

Reported-by: Donald Buczek <buczek@molgen.mpg.de>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e4e855976dca..f8f24e9de69a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7968,17 +7968,22 @@ EXPORT_SYMBOL(md_register_thread);
 
 void md_unregister_thread(struct md_thread **threadp)
 {
-	struct md_thread *thread = *threadp;
-	if (!thread)
-		return;
-	pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
-	/* Locking ensures that mddev_unlock does not wake_up a
+	struct md_thread *thread;
+
+	/*
+	 * Locking ensures that mddev_unlock does not wake_up a
 	 * non-existent thread
 	 */
 	spin_lock(&pers_lock);
+	thread = *threadp;
+	if (!thread) {
+		spin_unlock(&pers_lock);
+		return;
+	}
 	*threadp = NULL;
 	spin_unlock(&pers_lock);
 
+	pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
 	kthread_stop(thread->tsk);
 	kfree(thread);
 }
-- 
2.35.1

