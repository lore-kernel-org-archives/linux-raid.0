Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948A4C433F5
	for <linux-raid@archiver.kernel.org>; Sun, 17 Oct 2021 13:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C7D361054
	for <linux-raid@archiver.kernel.org>; Sun, 17 Oct 2021 13:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343777AbhJQNxD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 17 Oct 2021 09:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343773AbhJQNxA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 17 Oct 2021 09:53:00 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85857C061765
        for <linux-raid@vger.kernel.org>; Sun, 17 Oct 2021 06:50:50 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1634478648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EMe8bzhIpvwhGFkd+ZZkUSesVIhIoX8hFMsII5ZI6Qc=;
        b=Sf+3Gj9S0LOg0NqSEtew7f6JCwC/8wst6+W0lqITRwVr6BKqPxsQ4Ojt1z94+ZcsJC3XFn
        UZchBMNSlQMaJNNZIjNYjAMsyGWPr56i7B97uq4AtMA4U6em89n9oZJvfEEyeewnB22VEU
        4CYPA8Oh1wCU++R0SiciS/VpSuXi+94=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/3] md/bitmap: don't set max_write_behind if there is no write mostly device
Date:   Sun, 17 Oct 2021 21:50:17 +0800
Message-Id: <20211017135019.27346-2-guoqing.jiang@linux.dev>
In-Reply-To: <20211017135019.27346-1-guoqing.jiang@linux.dev>
References: <20211017135019.27346-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

We shouldn't set it since write behind IO should only happen to write
mostly device.

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/md/md-bitmap.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index e29c6298ef5c..9424879d8d7e 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2469,11 +2469,29 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	unsigned long backlog;
 	unsigned long old_mwb = mddev->bitmap_info.max_write_behind;
+	struct md_rdev *rdev;
+	bool has_write_mostly = false;
 	int rv = kstrtoul(buf, 10, &backlog);
 	if (rv)
 		return rv;
 	if (backlog > COUNTER_MAX)
 		return -EINVAL;
+
+	/*
+	 * Without write mostly device, it doesn't make sense to set
+	 * backlog for max_write_behind.
+	 */
+	rdev_for_each(rdev, mddev)
+		if (test_bit(WriteMostly, &rdev->flags)) {
+			has_write_mostly = true;
+			break;
+		}
+	if (!has_write_mostly) {
+		pr_warn_ratelimited("%s: can't set backlog, no write mostly"
+				    " device available\n", mdname(mddev));
+		return -EINVAL;
+	}
+
 	mddev->bitmap_info.max_write_behind = backlog;
 	if (!backlog && mddev->serial_info_pool) {
 		/* serial_info_pool is not needed if backlog is zero */
-- 
2.31.1

