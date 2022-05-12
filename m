Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10FB7C4332F
	for <linux-raid@archiver.kernel.org>; Thu, 12 May 2022 09:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350016AbiELJV2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 May 2022 05:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351919AbiELJVZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 May 2022 05:21:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86FC34ECE3
        for <linux-raid@vger.kernel.org>; Thu, 12 May 2022 02:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652347281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5CXyKOXmeIbEl+rwyswNrybEwxiDuTA1SswhZitz95s=;
        b=QDsLsqMzw6x0ltaCy5Yk3PJil9ZgK8d3ObEhe7m+V0P5Hv7UDpFvBugClSvY+UaaYKd9+f
        fx1jQXdqV6lqCOski3K+gzeXmjXrFEvwLrYiVNmnqZfgV2UazoGF98XmRHtaJZ6hkFwwBX
        UwNRsa6RSjc4pZp2LQ1fMtdSX0JcUyQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-Vrh3UmYbMBOJt8q-Rw2C9Q-1; Thu, 12 May 2022 05:21:20 -0400
X-MC-Unique: Vrh3UmYbMBOJt8q-Rw2C9Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE4FB382ECC7;
        Thu, 12 May 2022 09:21:19 +0000 (UTC)
Received: from localhost.localdomain (ovpn-14-34.pek2.redhat.com [10.72.14.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B6D156C13B;
        Thu, 12 May 2022 09:21:17 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, ncroxon@redhat.com, heinzm@redhat.com,
        ffan@redhat.com
Subject: [PATCH 2/2] md: Double free io_acct_set bioset
Date:   Thu, 12 May 2022 17:21:09 +0800
Message-Id: <20220512092109.41606-3-xni@redhat.com>
In-Reply-To: <20220512092109.41606-1-xni@redhat.com>
References: <20220512092109.41606-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Now io_acct_set is alloc and free in personality. Remove the codes that
free io_acct_set in md_free and md_stop.

Fixes: 0c031fd37f69 (md: Move alloc/free acct bioset in to personality)
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 53787a32166d..91c6cb3da470 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5598,8 +5598,6 @@ static void md_free(struct kobject *ko)
 
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
-	if (mddev->level != 1 && mddev->level != 10)
-		bioset_exit(&mddev->io_acct_set);
 	kfree(mddev);
 }
 
@@ -6285,8 +6283,6 @@ void md_stop(struct mddev *mddev)
 	__md_stop(mddev);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
-	if (mddev->level != 1 && mddev->level != 10)
-		bioset_exit(&mddev->io_acct_set);
 }
 
 EXPORT_SYMBOL_GPL(md_stop);
-- 
2.32.0 (Apple Git-132)

