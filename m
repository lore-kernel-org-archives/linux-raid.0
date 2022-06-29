Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FF6C43334
	for <linux-raid@archiver.kernel.org>; Wed, 29 Jun 2022 17:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiF2RlF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Jun 2022 13:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiF2RlD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Jun 2022 13:41:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF6AE13F6B
        for <linux-raid@vger.kernel.org>; Wed, 29 Jun 2022 10:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656524461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=CbVU1oclpphP38W7DafrHln//7CYqaN9rB0V1ixhBbY=;
        b=AySL/SNJXEEMS2n76ZI3rIsWdIXyJ3/caMav/Mve7vzOMgB3B2Mf/iTEK510r80q3Z/Voi
        XsZD2FYqP6F5CuldUGmKxaWnJSWSYJFp2w21X525mu5bh6PuvClaZ9ES2ttu9xBCovkLgd
        P3B8MkRvWpt6uHEAFBp0sGIUa0Kl77c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-1ZS6-2SDNiSDojAF1RqvKg-1; Wed, 29 Jun 2022 13:40:58 -0400
X-MC-Unique: 1ZS6-2SDNiSDojAF1RqvKg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1174A101A59C;
        Wed, 29 Jun 2022 17:40:58 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 07599C28115;
        Wed, 29 Jun 2022 17:40:58 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 25THevOg018812;
        Wed, 29 Jun 2022 13:40:57 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 25THevEk018809;
        Wed, 29 Jun 2022 13:40:57 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 29 Jun 2022 13:40:57 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     song@kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>
cc:     dm-devel@redhat.com, linux-raid@vger.kernel.org
Subject: [PATCH] dm-raid: fix KASAN warning in raid5_add_disks
Message-ID: <alpine.LRH.2.02.2206291340050.18482@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There's a KASAN warning in raid5_add_disk when running the LVM testsuite.
The warning happens in the test
lvconvert-raid-reshape-linear_to_raid6-single-type.sh. We fix the warning
by verifying that rdev->saved_raid_disk is within limits.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/raid5.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/md/raid5.c
===================================================================
--- linux-2.6.orig/drivers/md/raid5.c	2022-06-24 18:45:53.000000000 +0200
+++ linux-2.6/drivers/md/raid5.c	2022-06-24 18:46:59.000000000 +0200
@@ -8065,6 +8065,7 @@ static int raid5_add_disk(struct mddev *
 	 */
 	if (rdev->saved_raid_disk >= 0 &&
 	    rdev->saved_raid_disk >= first &&
+	    rdev->saved_raid_disk <= last &&
 	    conf->disks[rdev->saved_raid_disk].rdev == NULL)
 		first = rdev->saved_raid_disk;
 

