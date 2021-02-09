Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BFCC433DB
	for <linux-raid@archiver.kernel.org>; Tue,  9 Feb 2021 09:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB08764E88
	for <linux-raid@archiver.kernel.org>; Tue,  9 Feb 2021 09:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBIJnY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:43:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42020 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230144AbhBIJlY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 9 Feb 2021 04:41:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612863598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=dKcvbNtEe9bhwZiM4KBxe/TcRpV/gAq8AJZ9zHFDxWg=;
        b=Et2s5zOCQJMmpibe9BlPIvTrovln7GEXdFJMZudrOszdg3D7f/N/3fyuj49I7zTrHNfacN
        JazsxTa1c5ReP9+h9LR0iY7vFiYSs3ZLbEzrXP+7vIxDRDrTuv5yiYlqazI5wLN6dvjkYU
        0DEcglhQwKGlB+BcQ3b5uvUj01ALbgc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-IciD3cIwM8GX4Tlb96HCTQ-1; Tue, 09 Feb 2021 04:39:56 -0500
X-MC-Unique: IciD3cIwM8GX4Tlb96HCTQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32F0580196C;
        Tue,  9 Feb 2021 09:39:55 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 478D660C04;
        Tue,  9 Feb 2021 09:39:52 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, ncroxon@redhat.com
Subject: [PATCH 1/1] It should be FAILED when raid has not enough active disks
Date:   Tue,  9 Feb 2021 17:39:51 +0800
Message-Id: <1612863591-5725-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It can't remove the disk if there are not enough disks. For example, raid5 can't remove the
second disk. If the second disk is unplug from machine, it's better show missing and the raid
should be FAILED. It's better for administrator to monitor the raid.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Detail.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/Detail.c b/Detail.c
index f8dea6f..cd26fb0 100644
--- a/Detail.c
+++ b/Detail.c
@@ -355,9 +355,14 @@ int Detail(char *dev, struct context *c)
 	avail = xcalloc(array.raid_disks, 1);
 
 	for (d = 0; d < array.raid_disks; d++) {
-
-		if ((disks[d*2].state & (1<<MD_DISK_SYNC)) ||
-		    (disks[d*2+1].state & (1<<MD_DISK_SYNC))) {
+		char *dv, *dv_rep;
+		dv = map_dev_preferred(disks[d*2].major,
+				disks[d*2].minor, 0, c->prefer);
+		dv_rep = map_dev_preferred(disks[d*2+1].major,
+				disks[d*2+1].minor, 0, c->prefer);
+
+		if ((dv && (disks[d*2].state & (1<<MD_DISK_SYNC))) ||
+		    (dv_rep && (disks[d*2+1].state & (1<<MD_DISK_SYNC)))) {
 			avail_disks ++;
 			avail[d] = 1;
 		} else
@@ -789,7 +794,8 @@ This is pretty boring
 						       &max_devices, n_devices);
 			else
 				printf("   %s", dv);
-		}
+		} else if (disk.major | disk.minor)
+			printf("   missing");
 		if (!c->brief)
 			printf("\n");
 	}
-- 
2.7.5

