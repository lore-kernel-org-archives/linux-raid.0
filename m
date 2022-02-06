Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B63C433EF
	for <linux-raid@archiver.kernel.org>; Sun,  6 Feb 2022 20:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238167AbiBFU67 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 6 Feb 2022 15:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbiBFU66 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 6 Feb 2022 15:58:58 -0500
X-Greylist: delayed 435 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 12:58:57 PST
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8457C06173B
        for <linux-raid@vger.kernel.org>; Sun,  6 Feb 2022 12:58:57 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 00D831F386;
        Sun,  6 Feb 2022 20:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644180701; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CKuTzZlszbNehKBUrWxmNkvh5/C9qBO0M7ffLgssIOQ=;
        b=deMcgaE95WHgJd3N8JY1LOU9ZbfokYOTQ2sM/CUMFsHpuUdZl/obxBzOEU37ypdd23wmFQ
        KUtX8EnMhDyuEXhWLO6ztaRGzJFlTiShBszdvPcsRHhNK2C/EKEw8uQrbo/VdfFdNrjPeJ
        Um49ySUga2ffOllJiHR76UhND4bibeU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644180701;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CKuTzZlszbNehKBUrWxmNkvh5/C9qBO0M7ffLgssIOQ=;
        b=3Z5W+mZGal0+WQHLWDVHoL1ocK3tS1DHkjGo1bVks1vEasTvA7PFDB2L58zdgAfTpCyuK1
        T7YITSKbCUQOa2Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E06E613519;
        Sun,  6 Feb 2022 20:51:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OUfONdw0AGLTOgAAMHmgww
        (envelope-from <dmueller@suse.de>); Sun, 06 Feb 2022 20:51:40 +0000
From:   =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>
To:     linux-raid@vger.kernel.org
Cc:     =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>
Subject: [PATCH] fix multiple definition linking error due to missing extern
Date:   Sun,  6 Feb 2022 21:51:37 +0100
Message-Id: <20220206205137.21717-1-dmueller@suse.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

GCC 10+ defaults to -fno-common, which enforces proper declaration of
external references using "extern". without this change a link would
fail with:

  lib/raid6/test/algos.c:28: multiple definition of `raid6_call';
  lib/raid6/test/test.c:22: first defined here

Signed-off-by: Dirk Müller <dmueller@suse.de>
---
 lib/raid6/test/test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/raid6/test/test.c b/lib/raid6/test/test.c
index a3cf071941ab..ab0459150a61 100644
--- a/lib/raid6/test/test.c
+++ b/lib/raid6/test/test.c
@@ -19,7 +19,7 @@
 #define NDISKS		16	/* Including P and Q */
 
 const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
-struct raid6_calls raid6_call;
+extern struct raid6_calls raid6_call;
 
 char *dataptrs[NDISKS];
 char data[NDISKS][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
-- 
2.35.1

