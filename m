Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A602EC874B
	for <linux-raid@archiver.kernel.org>; Thu,  7 Sep 2023 18:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237858AbjIGSJu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Sep 2023 14:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242991AbjIGSJt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Sep 2023 14:09:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047801700
        for <linux-raid@vger.kernel.org>; Thu,  7 Sep 2023 11:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694110107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GhWLW/J+wF3IfDCX1bJmdtWkTTbZeKmfcEYf9lSNTG8=;
        b=bBTPYWHNCOCChLtizvvBXIvOe6UtFs02YqC6ACFzkc4noG2PogM6W9eYcGeuHdmpaf2YQj
        3d2vXI8x6VN6+XMDM+IOrLfFXDbzYYHy+tXAZ9QG0sbFYJzP4suIZDJudIMzrNER2JRwDf
        jpH+KybOkmY+SOWIdQdaeH6iXXus1c8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-eoejIEhhMgGzFCWkLdAKMQ-1; Thu, 07 Sep 2023 08:48:10 -0400
X-MC-Unique: eoejIEhhMgGzFCWkLdAKMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15C8D101CA85;
        Thu,  7 Sep 2023 12:48:10 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DB481121314;
        Thu,  7 Sep 2023 12:48:08 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/1] mdadm/tests: Fix regular expression failure
Date:   Thu,  7 Sep 2023 20:48:06 +0800
Message-Id: <20230907124806.20877-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The test fails because of the regular expression.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/06name | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/06name b/tests/06name
index 4d5e824d3e0e..86eaab69e3a1 100644
--- a/tests/06name
+++ b/tests/06name
@@ -3,8 +3,8 @@ set -x
 # create an array with a name
 
 mdadm -CR $md0 -l0 -n2 --metadata=1 --name="Fred" $dev0 $dev1
-mdadm -E $dev0 | grep 'Name : [^:]*:Fred ' > /dev/null || exit 1
-mdadm -D $md0 | grep 'Name : [^:]*:Fred ' > /dev/null || exit 1
+mdadm -E $dev0 | grep 'Name : Fred' > /dev/null || exit 1
+mdadm -D $md0 | grep 'Name : Fred' > /dev/null || exit 1
 mdadm -S $md0
 
 mdadm -A $md0 --name="Fred" $devlist
-- 
2.32.0 (Apple Git-132)

