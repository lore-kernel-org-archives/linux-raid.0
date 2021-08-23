Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81901C4320E
	for <linux-raid@archiver.kernel.org>; Mon, 23 Aug 2021 12:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BA1E613C8
	for <linux-raid@archiver.kernel.org>; Mon, 23 Aug 2021 12:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236868AbhHWMtW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 Aug 2021 08:49:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31780 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236721AbhHWMtV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 23 Aug 2021 08:49:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629722918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SDUtIo074UbooP/wxgOP7AkwxNnfqp9OtF8qc1I5c3M=;
        b=JICfy8UrcHghXLZkhPZSb2sGsEguqvzOBbCIuDsCzmsktUGCLAW2EXU00gD7vPKua25jNT
        bGI2YHqZY9M0QseIlF12jsM/OE5Ff+rguyt6mZpH/8Gs3R3pV999iq9p+/irC3rbDOEuDF
        OgQYNtC9VmUYRjF34XhMR4k+B93rXos=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-0Ixqlxs7OSa8JgyT56m93g-1; Mon, 23 Aug 2021 08:48:37 -0400
X-MC-Unique: 0Ixqlxs7OSa8JgyT56m93g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 927548042F4;
        Mon, 23 Aug 2021 12:48:36 +0000 (UTC)
Received: from localhost (dhcp-17-75.bos.redhat.com [10.18.17.75])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF4C019C44;
        Mon, 23 Aug 2021 12:48:35 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     jes@trained-monkey.org, xni@redhat.com, linux-raid@vger.kernel.org,
        pg@mdraid.list.sabi.co.UK
Subject: [PATCH V2] disallow create or grow clustered bitmap with writemostly set
Date:   Mon, 23 Aug 2021 08:48:35 -0400
Message-Id: <20210823124835.2516714-1-ncroxon@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Do not support creating an MD array on a clustered system
(--bitmap=clustered) and disks with the write mostly
(--write-mostly) flag set.

Or do not grow an MD array on a non-clustered bitmap to a
clustered bitmap with disks having the write mostly flag set.

The actual results is the MD array is created successfully.
But the expected results should be a failure with an
error message stating:
Can not set --write-mostly with a clustered bitmap.
and disks marked write-mostly are not supported with clustered bitmap.

V2:
Added the device name in the error message during creation:
mdadm -CR /dev/md0 -l1 --raid-devices=2 /dev/sda --write-mostly /dev/sdb --bitmap=clustered
mdadm: Can not set /dev/sdb --write-mostly with a clustered bitmap.

Added the array name in the error message when growing:
mdadm --grow /dev/md0 --bitmap=clustered
mdadm: /dev/md0 disks marked write-mostly are not supported with clustered bitmap

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
 Create.c | 9 +++++++--
 Grow.c   | 5 +++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/Create.c b/Create.c
index f5d57f8c..7e89a0e2 100644
--- a/Create.c
+++ b/Create.c
@@ -899,8 +899,13 @@ int Create(struct supertype *st, char *mddev,
 				else
 					inf->disk.state = 0;
 
-				if (dv->writemostly == FlagSet)
-					inf->disk.state |= (1<<MD_DISK_WRITEMOSTLY);
+				if (dv->writemostly == FlagSet) {
+					if (major_num == BITMAP_MAJOR_CLUSTERED) {
+						pr_err("Can not set %s --write-mostly with a clustered bitmap\n",dv->devname);
+						goto abort_locked;
+					} else
+						inf->disk.state |= (1<<MD_DISK_WRITEMOSTLY);
+				}
 				if (dv->failfast == FlagSet)
 					inf->disk.state |= (1<<MD_DISK_FAILFAST);
 
diff --git a/Grow.c b/Grow.c
index 7506ab46..70f26c7e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -430,6 +430,11 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 			dv = map_dev(disk.major, disk.minor, 1);
 			if (!dv)
 				continue;
+			if (((disk.state & (1 << MD_DISK_WRITEMOSTLY)) == 0) &&
+			   (strcmp(s->bitmap_file, "clustered") == 0)) {
+				pr_err("%s disks marked write-mostly are not supported with clustered bitmap\n",devname);
+				return 1;
+			}
 			fd2 = dev_open(dv, O_RDWR);
 			if (fd2 < 0)
 				continue;
-- 
2.29.2

