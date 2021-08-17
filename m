Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE39C4338F
	for <linux-raid@archiver.kernel.org>; Tue, 17 Aug 2021 13:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 495E960F5E
	for <linux-raid@archiver.kernel.org>; Tue, 17 Aug 2021 13:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbhHQNP0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Aug 2021 09:15:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235463AbhHQNP0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 17 Aug 2021 09:15:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629206092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vu8OHd355vwZvKcIufDu4EPj4u2/DjEZhTm7xl9syHk=;
        b=PXgNwiBn5QSjkVF7AVlwD9hOiRMZm6fOXCUjou83iIStqHsdxrB5O16lmwqUROpH08RpbV
        Xb2QOa+xnZ6uA7gqneCmnKS+GC/4TJra7ZGasJzLo62rHTfzPxsu8Ic7IeAm2Iau/SIE5t
        bu0kUJ1sjFxcqI9BkP6Y+65AbMTxXHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-l5E8dlDJNi6JM_LT_Sb2rw-1; Tue, 17 Aug 2021 09:14:50 -0400
X-MC-Unique: l5E8dlDJNi6JM_LT_Sb2rw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFC532E74;
        Tue, 17 Aug 2021 13:14:49 +0000 (UTC)
Received: from localhost (dhcp-17-75.bos.redhat.com [10.18.17.75])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A164D60C0F;
        Tue, 17 Aug 2021 13:14:49 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     jes@trained-monkey.org, mariusz.tkaczyk@linux.intel.com,
        neilb@suse.de, xni@redhat.com, linux-raid@vger.kernel.org
Subject: [PATCH] Fix potential overlap dest buffer
Date:   Tue, 17 Aug 2021 09:14:48 -0400
Message-Id: <20210817131448.2496995-1-ncroxon@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

To meet requirements of Common Criteria certification vulnerablility
assessment. Static code analysis has been run and found the following
error.  Overlapping_buffer: The source buffer potentially overlaps
with the destination buffer, which results in undefined
behavior for "memcpy".

The change is to use memmove instead of memcpy.

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
 sha1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sha1.c b/sha1.c
index 11be7045..89b32f46 100644
--- a/sha1.c
+++ b/sha1.c
@@ -258,7 +258,7 @@ sha1_process_bytes (const void *buffer, size_t len, struct sha1_ctx *ctx)
 	{
 	  sha1_process_block (ctx->buffer, 64, ctx);
 	  left_over -= 64;
-	  memcpy (ctx->buffer, &ctx->buffer[16], left_over);
+	  memmove (ctx->buffer, &ctx->buffer[16], left_over);
 	}
       ctx->buflen = left_over;
     }
-- 
2.29.2

