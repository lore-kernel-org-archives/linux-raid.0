Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49AB2E7E62B
	for <linux-raid@archiver.kernel.org>; Wed, 27 Sep 2023 04:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjI0EQ2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Sep 2023 00:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjI0EPS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Sep 2023 00:15:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF911FEA
        for <linux-raid@vger.kernel.org>; Tue, 26 Sep 2023 19:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695783152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fvgiju0dDx3h38+tQSLTDFQ4x7hTX6+ua9uGMxMwqSM=;
        b=NcN7j0XVjXe8dyM/Zm8KpmBuzdTUmsQXbhYiY8+V+yMwtjoffnIfxL/cE7gQBIagMh5mwW
        QfEmhFjMkYF+SOmjgEV1X8D54E4tr5AYgIH7rBh8Nxyzkdb6zgoXxdwKBlt0Krk6rFH2B+
        ajYxwhmtgRnKg/ELDZTeYKDx4rRxODo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-689-ueizcMKmM1aApdHH5PNKGg-1; Tue, 26 Sep 2023 22:52:29 -0400
X-MC-Unique: ueizcMKmM1aApdHH5PNKGg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A53A800962;
        Wed, 27 Sep 2023 02:52:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D51D22156702;
        Wed, 27 Sep 2023 02:52:27 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 3/4] mdadm: Avoid array bounds check of gcc
Date:   Wed, 27 Sep 2023 10:52:18 +0800
Message-Id: <20230927025219.49915-4-xni@redhat.com>
In-Reply-To: <20230927025219.49915-1-xni@redhat.com>
References: <20230927025219.49915-1-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

With gcc version 13.2.1 20230918 (Red Hat 13.2.1-3) (GCC), it reports error:
super-ddf.c:1988:58: error: array subscript -1 is below array bounds of
‘struct phys_disk_entry[0]’ [-Werror=array-bounds=]
The subscrit is defined as int type. And it can be smaller than 0.
To avoid this error, add -Wno-array-bounds flag in Makefile.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 5eac1a4e9690..47da883a9fb9 100644
--- a/Makefile
+++ b/Makefile
@@ -50,7 +50,7 @@ ifeq ($(origin CC),default)
 CC := $(CROSS_COMPILE)gcc
 endif
 CXFLAGS ?= -ggdb
-CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
+CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -Wno-array-bounds
 ifdef WARN_UNUSED
 CWFLAGS += -Wp,-D_FORTIFY_SOURCE=2 -O3
 endif
-- 
2.32.0 (Apple Git-132)

