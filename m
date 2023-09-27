Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22EBE7F158
	for <linux-raid@archiver.kernel.org>; Wed, 27 Sep 2023 03:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjI0D1s (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Sep 2023 23:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjI0DZx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Sep 2023 23:25:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2845A199A
        for <linux-raid@vger.kernel.org>; Tue, 26 Sep 2023 19:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695783148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GhWLW/J+wF3IfDCX1bJmdtWkTTbZeKmfcEYf9lSNTG8=;
        b=L2ceD6rsxtFOlPAF7K8K1b1PZF5+Xu295W1+hh0TES2Afl2c2wJia2cznaQnyGMUhkZJNR
        an6W8mACPJDDG1cWps1yoGa/MevEzG94smTLgTRa/UtkRPDe0DMBMh9s+nGbrcc+0XyP7l
        J2TvWlJraNTcVt163Owclwj1bzPgUIE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-i3H4KY5KMpuW5B9HcwaS3w-1; Tue, 26 Sep 2023 22:52:25 -0400
X-MC-Unique: i3H4KY5KMpuW5B9HcwaS3w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD94B101A529;
        Wed, 27 Sep 2023 02:52:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59D1C2156A27;
        Wed, 27 Sep 2023 02:52:22 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/4 v2] mdadm/tests: Fix regular expression failure
Date:   Wed, 27 Sep 2023 10:52:16 +0800
Message-Id: <20230927025219.49915-2-xni@redhat.com>
In-Reply-To: <20230927025219.49915-1-xni@redhat.com>
References: <20230927025219.49915-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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

