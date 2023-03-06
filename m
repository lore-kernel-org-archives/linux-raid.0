Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D60AC61DA4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjCFVag (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjCFV3g (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D557433F
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PW5jOrQ7jZQcYoZtk6moQ2SD0W5Kaqb4PVUUYPR+VMw=;
        b=H6cAI4V+F6VWPbcUuT6Kw17n7SkRR9m6L5txg8AjjTdSZ6xV7qkVBlwBdgZFvHXNAHkDKi
        TEVuxoKl8WzYwYNnueP30tUAhjKNPP3jmMOenah6TjgqDdNjp+D9aR4AF3iHh24TyX0+l5
        fyM+a1jO7OXlLBtdC9HPHXcuP/xkyjM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-XwrUrogSO8GUbTLxYR4bXg-1; Mon, 06 Mar 2023 16:28:27 -0500
X-MC-Unique: XwrUrogSO8GUbTLxYR4bXg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7103F29DD982
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:27 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACEE540B40E4;
        Mon,  6 Mar 2023 21:28:26 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 28/34] md pq: adjust __attribute__ [WARNING]
Date:   Mon,  6 Mar 2023 22:27:51 +0100
Message-Id: <38479f67f872503836d797d5cc623ba598c9ad53.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: heinzm <heinzm@redhat.com>
---
 include/linux/raid/pq.h | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 9e6171c4e7ed..da280aae74af 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -44,10 +44,6 @@ extern const char raid6_empty_zero_page[PAGE_SIZE];
 
 #define __init
 #define __exit
-#ifndef __attribute_const__
-# define __attribute_const__ __attribute__((const))
-#endif
-#define noinline __attribute__((noinline))
 
 #define preempt_enable()
 #define preempt_disable()
@@ -141,12 +137,12 @@ int raid6_select_algo(void);
 #define RAID6_PQ_BAD	3
 
 /* Galois field tables */
-extern const u8 raid6_gfmul[256][256] __attribute__((aligned(256)));
-extern const u8 raid6_vgfmul[256][32] __attribute__((aligned(256)));
-extern const u8 raid6_gfexp[256]      __attribute__((aligned(256)));
-extern const u8 raid6_gflog[256]      __attribute__((aligned(256)));
-extern const u8 raid6_gfinv[256]      __attribute__((aligned(256)));
-extern const u8 raid6_gfexi[256]      __attribute__((aligned(256)));
+extern const u8 raid6_gfmul[256][256] __aligned(256);
+extern const u8 raid6_vgfmul[256][32] __aligned(256);
+extern const u8 raid6_gfexp[256]      __aligned(256);
+extern const u8 raid6_gflog[256]      __aligned(256);
+extern const u8 raid6_gfinv[256]      __aligned(256);
+extern const u8 raid6_gfexi[256]      __aligned(256);
 
 /* Recovery routines */
 extern void (*raid6_2data_recov)(int disks, size_t bytes, int faila, int failb,
-- 
2.39.2

