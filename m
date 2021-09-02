Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F38A1C432BE
	for <linux-raid@archiver.kernel.org>; Thu,  2 Sep 2021 07:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1F4260EC0
	for <linux-raid@archiver.kernel.org>; Thu,  2 Sep 2021 07:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243571AbhIBHd1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Sep 2021 03:33:27 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:55238 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243208AbhIBHd0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Sep 2021 03:33:26 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 193C421AC5;
        Thu,  2 Sep 2021 07:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630567948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=LMxRRQVFEBAlk0waNA8ZbHyEikIKYDxTwssNZInruXI=;
        b=Zn85PMJFfVn5MNj0I6Q0/1ECMoPohA4o1u1i6dNDt1byIGdB2cnVPYB+CAEGzBFhdAlWr2
        y49VTpePEdTlm5nDZrk0XXh95LJH6fUrMzN4XpVFkd+AoZeUe2en39HDlkC7Tj6pVCcgAC
        xiwBPt5I+eA8WMEE2PJRN+wrt2YFmis=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630567948;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=LMxRRQVFEBAlk0waNA8ZbHyEikIKYDxTwssNZInruXI=;
        b=silZyQ6Ww3C+VO/P/7t2KNLedP+2NBM994E4iy/DhqDrOLf1MXmnOAdKPxasD3Lasfg1lC
        KwMIFV2ZyjS6mAAg==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 02D55A3B9E;
        Thu,  2 Sep 2021 07:32:25 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-raid@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, George Gkioulis <ggkioulis@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH v3] Monitor: print message before quit for no array to monitor
Date:   Thu,  2 Sep 2021 15:32:20 +0800
Message-Id: <20210902073220.19177-1-colyli@suse.de>
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
Suggested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jes Sorensen <jsorensen@fb.com>
---
Changelog:
v3: modify printed message by suggestion from Mariusz.
v2: add CC to Jes, and fix typo.
v1: the original version.

 Monitor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Monitor.c b/Monitor.c
index f541229..839ec78 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -258,6 +258,7 @@ int Monitor(struct mddev_dev *devlist,
 			if (oneshot)
 				break;
 			else if (!anyredundant) {
+				pr_err("No array with redundancy detected, stopping\n");
 				break;
 			}
 			else {
-- 
2.31.1

