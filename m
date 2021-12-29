Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619D9C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 29 Dec 2021 15:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240564AbhL2PjA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Dec 2021 10:39:00 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:35866 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237096AbhL2PjA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Dec 2021 10:39:00 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 15871210F4;
        Wed, 29 Dec 2021 15:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1640792339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5LZTH34HBmFtmRk0UzFW6Vmom/8K4QwdqS+vwsZnsTA=;
        b=qams5SX80WW9cewnzACd0e2GQB+dmpGudDkqTYv4TMqOVLFPYE8fkONbZWCoZGZpBtD3mg
        KSRId8kbwJdji28iS+iPc7taKa5dF6gYDvVhlxGWRjaZaPrHdRdahMd/KeJR6OcrxJG5jY
        oBvMZZnkQlAe46SQkLZ0YnEN/p+3/ZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1640792339;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5LZTH34HBmFtmRk0UzFW6Vmom/8K4QwdqS+vwsZnsTA=;
        b=CyEu05bCyMzivMn34bT7QIdbubjYrTZ4pQiOKRCu/C0Wks7wDqVYV7zN4bzdTBsXrgQxem
        048lI4W1q/dKsZDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 00EB013BCF;
        Wed, 29 Dec 2021 15:38:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zwm3OhKBzGGjaQAAMHmgww
        (envelope-from <dmueller@suse.de>); Wed, 29 Dec 2021 15:38:58 +0000
From:   =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>
To:     linux-raid@vger.kernel.org
Cc:     =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>
Subject: [PATCH] fix multiple definition linking error due to missing extern
Date:   Wed, 29 Dec 2021 16:38:56 +0100
Message-Id: <20211229153856.8443-1-dmueller@suse.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

GCC 10+ defaults to -fno-common, which enforces proper declaration of
external references using "extern". without this change a link would
fail with:

  ld: raid6.a(algos.o):lib/raid6/test/algos.c:28: multiple definition of `raid6_call';
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
2.34.1

