Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5B2C4338F
	for <linux-raid@archiver.kernel.org>; Mon,  9 Aug 2021 04:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE79F60EB9
	for <linux-raid@archiver.kernel.org>; Mon,  9 Aug 2021 04:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhHIECR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 Aug 2021 00:02:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58301 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229456AbhHIECR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 Aug 2021 00:02:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628481717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=lb0wn/LJsbxWjLhrY5AMhku2wly61NfC9CMyA2aWuN4=;
        b=EsT+ZWk/V7y1ABZYIpNhOTks9d6VhCVBK90v8Q+xYnSb6s3ODOInZUPheiM+bDTaE86cTK
        jQQRqFi9YJUnIfhsrhEutxL+5c5IZwdSpi5eRtLassAODLoQuwBCdSBR5qPM1cFZ/M0miO
        L+ovDTGxQOy4LPfgxrtJL6BoNPeG1uc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-BVsdsDggMOajovu5m1-LEQ-1; Mon, 09 Aug 2021 00:01:53 -0400
X-MC-Unique: BVsdsDggMOajovu5m1-LEQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 148D41008060;
        Mon,  9 Aug 2021 04:01:53 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AB765DA2D;
        Mon,  9 Aug 2021 04:01:51 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     songliubraving@fb.com
Cc:     ncroxon@redhat.com, linux-raid@vger.kernel.org
Subject: [PATCH 1/1] md/raid10: Remove rcu_dereference when it doesn't need rcu lock to protect
Date:   Mon,  9 Aug 2021 12:01:49 +0800
Message-Id: <1628481709-3824-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In the first loop of function raid10_handle_discard. It already
determines which disk need to handle discard request and add the
rdev reference count. So the conf->mirrors will not change until
all bios come back from underlayer disks. It doesn't need to use
rcu_dereference to get rdev.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid10.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 16977e8..cef9869 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1743,9 +1743,8 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	for (disk = 0; disk < geo->raid_disks; disk++) {
 		sector_t dev_start, dev_end;
 		struct bio *mbio, *rbio = NULL;
-		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
-		struct md_rdev *rrdev = rcu_dereference(
-			conf->mirrors[disk].replacement);
+		struct md_rdev *rdev = conf->mirrors[disk].rdev;
+		struct md_rdev *rrdev = conf->mirrors[disk].replacement;
 
 		/*
 		 * Now start to calculate the start and end address for each disk.
-- 
2.7.5

