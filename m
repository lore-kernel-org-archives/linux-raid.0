Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC42EC432BE
	for <linux-raid@archiver.kernel.org>; Thu,  2 Sep 2021 02:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3D7960F91
	for <linux-raid@archiver.kernel.org>; Thu,  2 Sep 2021 02:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243154AbhIBCdR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Sep 2021 22:33:17 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39374 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243187AbhIBCdP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Sep 2021 22:33:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AFCBC22555;
        Thu,  2 Sep 2021 02:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630549936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=bCU/Pj5OFaMnvHcI0AUc0ZOteruxeaT956fWe7O85n4=;
        b=RINZyzzMEHATq/7cx7M8dP8y/vzrD7zmLTjcQ5uBmL/BuTivJsHD1zVxwDbVvAxDpNUX06
        Vb/7hrsXeKbMXbl5EjYTF6z1WMO2tQvGuwL3Pkc54girM4vLhLbKuGNIgG8xDhBqM/mvil
        IGybKr01U5qwMbDzvcIqz1L2BbA3oxQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630549936;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=bCU/Pj5OFaMnvHcI0AUc0ZOteruxeaT956fWe7O85n4=;
        b=lY8yp8vlzUSEFw0lXm8FoeWVKlbJJnZcx5Hm+7lzSai4R6qDlrrG8X6+KmKrX/Gq56UscX
        mZ387hPU8sjwHdAw==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 160D3A3B8E;
        Thu,  2 Sep 2021 02:32:14 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-raid@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, George Gkioulis <ggkioulis@suse.com>
Subject: [PATCH] Monitor: print message before quit for no array to monitor
Date:   Thu,  2 Sep 2021 10:32:09 +0800
Message-Id: <20210902023209.130858-1-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If there is no array device to monitor, Monitor() will stop monitoring
at line 261 from the following code block,
 257                 if (!new_found) {
 258                         if (oneshot)
 259                                 break;
 260                         else if (!anyredundant) {
 261                                 break;
 262                         }

This change was introduced by commit 007087d0898a ("Monitor: stop
notifing about containers"). Before this commit, Monitor() will continue
and won't quit even there is no array to monitor.

It is fine to quit without any array device to monitor, but users may
wonder whether there is something wrong with mdadm program or their
configuration to make mdadm quit monitoring.

This patch adds a simple error message to indicate Monitor() quits for
array device to monitor, which makes users have hint to understand why
mdadm stops monitoring.

Reported-by: George Gkioulis <ggkioulis@suse.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 Monitor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Monitor.c b/Monitor.c
index f541229..88b2c3c 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -258,6 +258,7 @@ int Monitor(struct mddev_dev *devlist,
 			if (oneshot)
 				break;
 			else if (!anyredundant) {
+				pr_info("Stop for no array to monitor\n");
 				break;
 			}
 			else {
-- 
2.31.1

