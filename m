Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7B1C27C76
	for <linux-raid@archiver.kernel.org>; Sat, 21 Jan 2023 01:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjAUBtP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjAUBtO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 Jan 2023 20:49:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F803646C
        for <linux-raid@vger.kernel.org>; Fri, 20 Jan 2023 17:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674265706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ek1fXXN2/HsLKN+3CPqx2UP+xmk1gs5BW9WX6ozx/OM=;
        b=A1niUCvQQSsJ44lQzTn/4+7gpXpemhY8xQwWHKnRyn+uDQ9raisPd9scNtyNjbEDnFSn9w
        FEUZANGvGvGob5IqZbNWYKaHBFb+27Q9Y8jnQXiVSlHioK6iGbjGKVYcT9C6PbCidsf8Dg
        71CHyz7zWp/lRKush4jtGwLS4U5voUI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-MwCaw6hJPHqE8dwal9DsTQ-1; Fri, 20 Jan 2023 20:48:22 -0500
X-MC-Unique: MwCaw6hJPHqE8dwal9DsTQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3533229AB443;
        Sat, 21 Jan 2023 01:48:22 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-10.pek2.redhat.com [10.72.13.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46849140EBF6;
        Sat, 21 Jan 2023 01:48:12 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Subject: [PATCH 1/1] md: Free writes_pending in md_stop
Date:   Sat, 21 Jan 2023 09:48:10 +0800
Message-Id: <20230121014810.97838-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

dm raid calls md_stop to stop the raid device. It needs to
free the writes_pending here.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 100c1327e90b..0e9f870e348a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6267,6 +6267,7 @@ void md_stop(struct mddev *mddev)
 	 */
 	__md_stop_writes(mddev);
 	__md_stop(mddev);
+	percpu_ref_exit(&mddev->writes_pending);
 	percpu_ref_exit(&mddev->active_io);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
-- 
2.32.0 (Apple Git-132)

