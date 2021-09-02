Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 949F8C4320A
	for <linux-raid@archiver.kernel.org>; Thu,  2 Sep 2021 02:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F79961058
	for <linux-raid@archiver.kernel.org>; Thu,  2 Sep 2021 02:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243008AbhIBCiG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Sep 2021 22:38:06 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39804 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbhIBCiD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Sep 2021 22:38:03 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 10A7822478;
        Thu,  2 Sep 2021 02:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630550225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=SvPBMFS+g1GFulNl5irsx/sMDQbAjfmEbCzH7LXwYLs=;
        b=AVwxxIlI5lJpSpONv/nlkPnxb/NmnnoQbC4Siafb1osJUi6Uai7GKH6kgdXITKcA2xbl57
        uBAQNvsc59RiliSK0Ik2E+UqxJDPubI8DIdHvh6oyFXzfG3Hu3r58TlhpAc93RlNVVJb8x
        Y8LqBlwulko04zLvf4OJlyMh9R0DRfo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630550225;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=SvPBMFS+g1GFulNl5irsx/sMDQbAjfmEbCzH7LXwYLs=;
        b=D/XI5BRAOtUzBmzaFkpqqqE+62pMnJYThuWQsDw1VawoaQ4KmzN8wiNvbMjDjmj6W8g72C
        r1W2RIqnUlSVG+Dw==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 192D2A3B83;
        Thu,  2 Sep 2021 02:37:02 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-raid@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, George Gkioulis <ggkioulis@suse.com>,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH v2] Monitor: print message before quit for no array to monitor
Date:   Thu,  2 Sep 2021 10:36:44 +0800
Message-Id: <20210902023644.509-1-colyli@suse.de>
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
Cc: Jes Sorensen <jsorensen@fb.com>
---
Changelog:
v2: add CC to Jes, and fix typo.
v1: the original version.

 Monitor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Monitor.c b/Monitor.c
index f541229..5f399c4 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -258,6 +258,7 @@ int Monitor(struct mddev_dev *devlist,
 			if (oneshot)
 				break;
 			else if (!anyredundant) {
+				pr_err("Stop for no array to monitor\n");
 				break;
 			}
 			else {
-- 
2.31.1

