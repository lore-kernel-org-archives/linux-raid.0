Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 990F5C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 24 Jul 2022 18:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiGXS3a (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 24 Jul 2022 14:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbiGXS3a (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 24 Jul 2022 14:29:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A428210559
        for <linux-raid@vger.kernel.org>; Sun, 24 Jul 2022 11:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658687367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=xJo6J+3JJzgd7TKTBXnQTWatITlW0jEp0bM+PCfGVjI=;
        b=H7+Xapapb13u6zX5CUALHfzCKf8lVhIA/oGqrSMXF3HmnJmw44Q/7AAaLpa5Zsmyfssb0k
        mIBQqPOeI4AfIrhfjAhkYStQ5TKrjlE4WcSQ3AHFhQOLREwdiq8w4iOCfM9GK/zTApQpBU
        /uKE4qFBpcXz6e2wc4itFhylcypZKdY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-B1rI_JjZPQm59Me1kXOwTw-1; Sun, 24 Jul 2022 14:29:26 -0400
X-MC-Unique: B1rI_JjZPQm59Me1kXOwTw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C2643C02B63;
        Sun, 24 Jul 2022 18:29:26 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 21F901121314;
        Sun, 24 Jul 2022 18:29:26 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 26OITQ3N026314;
        Sun, 24 Jul 2022 14:29:26 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 26OITQdf026310;
        Sun, 24 Jul 2022 14:29:26 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Sun, 24 Jul 2022 14:29:26 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Song Liu <song@kernel.org>
cc:     linux-raid@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
Subject: [PATCH] md-raid10: fix KASAN warning
Message-ID: <alpine.LRH.2.02.2207241426320.26078@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There's a KASAN warning in raid10_remove_disk when running the lvm
test lvconvert-raid-reshape.sh. We fix this warning by verifying that the
value "number" is valid.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/raid10.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/raid10.c
===================================================================
--- linux-2.6.orig/drivers/md/raid10.c	2022-07-13 19:05:50.000000000 +0200
+++ linux-2.6/drivers/md/raid10.c	2022-07-13 19:07:05.000000000 +0200
@@ -2167,9 +2167,12 @@ static int raid10_remove_disk(struct mdd
 	int err = 0;
 	int number = rdev->raid_disk;
 	struct md_rdev **rdevp;
-	struct raid10_info *p = conf->mirrors + number;
+	struct raid10_info *p;
 
 	print_conf(conf);
+	if (unlikely(number >= mddev->raid_disks))
+		return 0;
+	p = conf->mirrors + number;
 	if (rdev == p->rdev)
 		rdevp = &p->rdev;
 	else if (rdev == p->replacement)

