Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A38C4708C
	for <linux-raid@archiver.kernel.org>; Fri, 28 May 2021 06:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1DC2611BD
	for <linux-raid@archiver.kernel.org>; Fri, 28 May 2021 06:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhE1GSU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 May 2021 02:18:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229483AbhE1GST (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 28 May 2021 02:18:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622182604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=9el2OjRh1+xPB6NMRBYfarY5oDHIF+4V5EIyg7Xx3n8=;
        b=LKpn9YaEVxzjS4RqPC5DRvoBBt0aLZ5fQelzLm4ih/sGLdSTs8e+KoRdl47Mk6i41zXCGT
        l3stmBcIe6uPnSfTF5jpCjErqCUkcy0vT1uyQGPPUS9aqw0JhXx7vN4ELQFejoNtwBrLxR
        j1xBpfXGbXu9M2BTA3lBqvFRi+Ftf/k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-zOWXcGafPweehBhuPwGEQQ-1; Fri, 28 May 2021 02:16:43 -0400
X-MC-Unique: zOWXcGafPweehBhuPwGEQQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2179B8042A3;
        Fri, 28 May 2021 06:16:42 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BAF36E419;
        Fri, 28 May 2021 06:16:39 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     ncroxon@redhat.com, oleksandr.shchirskyi@linux.intel.com,
        linux-raid@vger.kernel.org
Subject: [PATCH 1/1] It needs to check offset array is NULL or not in async_xor_offs
Date:   Fri, 28 May 2021 14:16:38 +0800
Message-Id: <1622182598-13110-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Now we support sharing one big page when PAGE_SIZE is not equal 4096.
4096 bytes is the default stripe size. To support this it adds a
page offset array in raid5_percpu's scribble. It passes the page
offset array to async_xor_offs. But there are some users that don't
use the page offset array. In raid5-ppl.c, async_xor passes NULL to
asynx_xor_offs. So it needs to check src_offs is NULL or not.

Fixes: ceaf2966ab08(async_xor: increase src_offs when dropping destination page)
Reported-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 crypto/async_tx/async_xor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 6cd7f70..d8a9152 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -233,7 +233,8 @@ async_xor_offs(struct page *dest, unsigned int offset,
 		if (submit->flags & ASYNC_TX_XOR_DROP_DST) {
 			src_cnt--;
 			src_list++;
-			src_offs++;
+			if (src_offs)
+				src_offs++;
 		}
 
 		/* wait for any prerequisite operations */
-- 
2.7.5

