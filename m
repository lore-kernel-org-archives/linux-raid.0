Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D601BC6FD1A
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjCFV26 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjCFV2x (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:28:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFEF26591
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CQ5S2yi0PehkBug4H+mp1fpVMp5CYfax2u4s/L/VN8Y=;
        b=gxEXajM5NRSFYpcbGEVQT8Nx5WrUV1U//1FCecVP5N6b951o2DAeT3bmcLea+D1rybL6xM
        lC50bwp2Pq2WMkky4JSlYOnKdS2t2glaqK8mrzo/lBGQJyzhEgmTiAdT8aAQa2Hudo+0Gd
        wYShEbPfClozjlcI44zYWWRDzQFb2Ck=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-C-aaTY6TOJu8mUe9H4fByw-1; Mon, 06 Mar 2023 16:28:02 -0500
X-MC-Unique: C-aaTY6TOJu8mUe9H4fByw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D445E80D0F2
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:01 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BB2E40C83B6;
        Mon,  6 Mar 2023 21:28:00 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 03/34] md: fix EXPORT_SYMBOL() to follow its functions immediately [ERROR]
Date:   Mon,  6 Mar 2023 22:27:26 +0100
Message-Id: <ef49a2973e749179ad4244d25db180b9c8fd84d9.1678136717.git.heinzm@redhat.com>
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
 drivers/md/md.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8727ebab4b95..cfa957c8287b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6271,7 +6271,6 @@ void md_stop(struct mddev *mddev)
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
 }
-
 EXPORT_SYMBOL_GPL(md_stop);
 
 static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
@@ -8585,7 +8584,6 @@ void md_write_end(struct mddev *mddev)
 			  roundup(jiffies, mddev->safemode_delay) +
 			  mddev->safemode_delay);
 }
-
 EXPORT_SYMBOL(md_write_end);
 
 /* This is used by raid0 and raid10 */
-- 
2.39.2

