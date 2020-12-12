Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB15C2BB48
	for <linux-raid@archiver.kernel.org>; Sat, 12 Dec 2020 16:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CA16230FB
	for <linux-raid@archiver.kernel.org>; Sat, 12 Dec 2020 16:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393098AbgLLQVa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Dec 2020 11:21:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:57712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439498AbgLLQKu (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 12 Dec 2020 11:10:50 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 5/5] dm table: Remove BUG_ON(in_interrupt())
Date:   Sat, 12 Dec 2020 11:09:09 -0500
Message-Id: <20201212160910.2335511-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160910.2335511-1-sashal@kernel.org>
References: <20201212160910.2335511-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit e7b624183d921b49ef0a96329f21647d38865ee9 ]

The BUG_ON(in_interrupt()) in dm_table_event() is a historic leftover from
a rework of the dm table code which changed the calling context.

Issuing a BUG for a wrong calling context is frowned upon and
in_interrupt() is deprecated and only covering parts of the wrong
contexts. The sanity check for the context is covered by
CONFIG_DEBUG_ATOMIC_SLEEP and other debug facilities already.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2d3ff028f50c9..62e3dc19b6099 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1250,12 +1250,6 @@ void dm_table_event_callback(struct dm_table *t,
 
 void dm_table_event(struct dm_table *t)
 {
-	/*
-	 * You can no longer call dm_table_event() from interrupt
-	 * context, use a bottom half instead.
-	 */
-	BUG_ON(in_interrupt());
-
 	mutex_lock(&_event_lock);
 	if (t->event_fn)
 		t->event_fn(t->event_context);
-- 
2.27.0

