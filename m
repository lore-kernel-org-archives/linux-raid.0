Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB7DC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 29 Jun 2022 17:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiF2RkG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Jun 2022 13:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiF2RkF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Jun 2022 13:40:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61F8013F6B
        for <linux-raid@vger.kernel.org>; Wed, 29 Jun 2022 10:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656524403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=/S6wud+ZLtSOOMX8F2pkmM3VdP3etH2GxQPnFHgUtKM=;
        b=YAZkoi79rslrysaz+gIX3e/hRr5XyYRS6100VnHvIOMjtpWXK/qOUhOLIE30jr+Lbuz+TG
        Evz8UQbUKWcediNjpGdH2wjk5ukIKraz20TRGZxoIRLO3VDpbXFHmaXrsq6Z+jXfTj85dr
        2KcrIG63Gv5oKZNrXTtoskLdH8KS7P4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-TNRGqRwyMZCDVYkp5q5OcQ-1; Wed, 29 Jun 2022 13:40:01 -0400
X-MC-Unique: TNRGqRwyMZCDVYkp5q5OcQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93684801E67;
        Wed, 29 Jun 2022 17:40:01 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A79140EC003;
        Wed, 29 Jun 2022 17:40:01 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 25THe1F3018738;
        Wed, 29 Jun 2022 13:40:01 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 25THe1wt018734;
        Wed, 29 Jun 2022 13:40:01 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 29 Jun 2022 13:40:01 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     song@kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>
cc:     dm-devel@redhat.com, linux-raid@vger.kernel.org
Subject: [PATCH] dm-raid: fix KASAN warning in raid5_remove_disk
Message-ID: <alpine.LRH.2.02.2206291332230.18482@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There's a KASAN warning in raid5_remove_disk when running the LVM
testsuite. We fix this warning by verifying that the "number" variable is
within limits.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/raid5.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/raid5.c
===================================================================
--- linux-2.6.orig/drivers/md/raid5.c	2022-06-15 09:06:14.000000000 +0200
+++ linux-2.6/drivers/md/raid5.c	2022-06-16 13:33:18.000000000 +0200
@@ -7933,7 +7933,7 @@ static int raid5_remove_disk(struct mdde
 	int err = 0;
 	int number = rdev->raid_disk;
 	struct md_rdev __rcu **rdevp;
-	struct disk_info *p = conf->disks + number;
+	struct disk_info *p;
 	struct md_rdev *tmp;
 
 	print_raid5_conf(conf);
@@ -7952,6 +7952,9 @@ static int raid5_remove_disk(struct mdde
 		log_exit(conf);
 		return 0;
 	}
+	if (unlikely(number >= conf->pool_size))
+		return 0;
+	p = conf->disks + number;
 	if (rdev == rcu_access_pointer(p->rdev))
 		rdevp = &p->rdev;
 	else if (rdev == rcu_access_pointer(p->replacement))

