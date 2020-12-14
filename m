Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C74C2BB9A
	for <linux-raid@archiver.kernel.org>; Mon, 14 Dec 2020 17:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B7EE22525
	for <linux-raid@archiver.kernel.org>; Mon, 14 Dec 2020 17:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731177AbgLNRXA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Dec 2020 12:23:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:38484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392060AbgLNRW4 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 14 Dec 2020 12:22:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1607966501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Td5ERxaNgUghcR2CxTx8m9mGiiPHBazU6UM5nID5BOE=;
        b=qFMZiue3biMH/B8IdMLyHGbeEYMzLalCDyQM5DLAgI1cWvt4ZDH6P49ZwtcIumGpJhsu+v
        wp75nL3LX/wdcBO1F/kYsH0xDT0J6XLcDa5Tl4cL3M9C21nQJ6tAYTv2bhcH8lVS9ZsEPl
        oZkeWQmObe2itzVhNbSB8Rg9JojqBRc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 58FDCAC7F;
        Mon, 14 Dec 2020 17:21:41 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>
Cc:     dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dm integrity: select the Kconfig option CRYPTO_SKCIPHER
Date:   Mon, 14 Dec 2020 18:18:11 +0100
Message-Id: <20201214171811.27582-1-ailiop@suse.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The integrity target relies on skcipher for encryption/decryption, but
certain kernel configurations may not enable CRYPTO_SKCIPHER, leading to
compilation errors due to unresolved symbols. Explicitly select
CRYPTO_SKCIPHER for DM_INTEGRITY, since it is unconditionally dependent
on it.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 drivers/md/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 30ba3573626c..5c0e7063f5f5 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -585,6 +585,7 @@ config DM_INTEGRITY
 	select BLK_DEV_INTEGRITY
 	select DM_BUFIO
 	select CRYPTO
+	select CRYPTO_SKCIPHER
 	select ASYNC_XOR
 	help
 	  This device-mapper target emulates a block device that has
-- 
2.29.1

