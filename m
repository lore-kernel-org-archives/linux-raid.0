Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9406AC61DA4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjCFVa4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbjCFV3o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E41F74A69
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WWqWPwAc36DW/+jhuR5a+KhVC0W45qlvrYtC1lizJZU=;
        b=X66roOW5MwgigHiZeG3ZbkI7ovW4sgaD+2qBOF+hcDyZ84LvFDVfuOSxjb/iN9hazKWkoI
        PAPbPA+Py6Dgp/EjKyO8U2eZ7OGcPY9nhsjiOhc8S/3ZHw+p0KwmBGpOaf39OqUw99lzcf
        lf6edD06gBkvNEuk7euOOXXgCqpiWds=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-odKrxz-iNeC2YxTtR94qhQ-1; Mon, 06 Mar 2023 16:28:31 -0500
X-MC-Unique: odKrxz-iNeC2YxTtR94qhQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A2F7800B23
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:31 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B576F40C83B6;
        Mon,  6 Mar 2023 21:28:30 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 32/34] md: prefer kvmalloc_array() with multiply [WARNING]
Date:   Mon,  6 Mar 2023 22:27:55 +0100
Message-Id: <6aced08ad5b32655537d43ba24ba124c3b0b22f9.1678136717.git.heinzm@redhat.com>
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
 drivers/md/md.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9b734720b9c1..3d17773e058f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -164,8 +164,7 @@ static int rdev_init_serial(struct md_rdev *rdev)
 	if (test_bit(CollisionCheck, &rdev->flags))
 		return 0;
 
-	serial = kvmalloc(sizeof(struct serial_in_rdev) * serial_nums,
-			  GFP_KERNEL);
+	serial = kvmalloc_array(serial_nums, sizeof(struct serial_in_rdev), GFP_KERNEL);
 	if (!serial)
 		return -ENOMEM;
 
-- 
2.39.2

