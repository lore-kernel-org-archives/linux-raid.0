Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5291DC61DA4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjCFVac (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjCFV3c (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B335B74332
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wMFGFe49ystFuM93WHrs1V4jg1IjsfWgiqXhtTULBpk=;
        b=QkHiLPVa/UZ3Ixk9g4nTlV9zVi/8iTE/y2fAsY+JtPgoIk9VrbTH0RMF+PDZ/JbXy8mtWz
        1yv53IaK3NeET0rFzBVlEDuF2cJnxy7HfDM7IVe7qBfbYdiS/c5yaiCrgsbAbhLJi/CiJC
        hfY7bVfgWGF21l4+XllBwn9ymxZOq+I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-CwHTa8ZQPtCXj_1r95BUOw-1; Mon, 06 Mar 2023 16:28:24 -0500
X-MC-Unique: CwHTa8ZQPtCXj_1r95BUOw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74EFE811E6E
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:24 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0AC840AE20A;
        Mon,  6 Mar 2023 21:28:23 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 25/34] md: remove bogus IS_ENABLED() macro [WARNING]
Date:   Mon,  6 Mar 2023 22:27:48 +0100
Message-Id: <690063b522e4d674e6ef169c0b955b5729feb4b9.1678136717.git.heinzm@redhat.com>
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
 include/linux/raid/pq.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 41c525e4c959..9e6171c4e7ed 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -64,7 +64,6 @@ extern const char raid6_empty_zero_page[PAGE_SIZE];
 #define subsys_initcall(x)
 #define module_exit(x)
 
-#define IS_ENABLED(x) (x)
 #define CONFIG_RAID6_PQ_BENCHMARK 1
 #endif /* __KERNEL__ */
 
-- 
2.39.2

