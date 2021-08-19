Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DBB1C4338F
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 15:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4752860EFE
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 15:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239964AbhHSPKv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Aug 2021 11:10:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27697 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239151AbhHSPKv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 19 Aug 2021 11:10:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629385814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KSPemEdMnNOEZV92WGMyrEg2Px0wSEbOxDzijUJ03EI=;
        b=ZD+RfDHc8jRu16jGDRwgPejfkqsUWkVVv8gHXYqTH4T+EuyB7l+5akHZW2uvYKCR7ntsEr
        /Mg15FMj2PEKq++RsYvW4BihqsmFpK/02tlZeY1UGyqJEz1+CrXMknUsU/yPWOeCOKwuyT
        5ekpkJ7EruHNA4qsVNq4ociUuK3yNIQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-wM-tf106O5218Kph4Joh9A-1; Thu, 19 Aug 2021 11:10:13 -0400
X-MC-Unique: wM-tf106O5218Kph4Joh9A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4258110D12E8;
        Thu, 19 Aug 2021 15:10:12 +0000 (UTC)
Received: from localhost (dhcp-17-75.bos.redhat.com [10.18.17.75])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 11A2260938;
        Thu, 19 Aug 2021 15:10:11 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     jes@trained-monkey.org, xni@redhat.com, linux-raid@vger.kernel.org
Subject: [PATCH] disallow create or grow clustered bitmap with writemostly set
Date:   Thu, 19 Aug 2021 11:10:11 -0400
Message-Id: <20210819151011.2511557-1-ncroxon@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
 Create.c | 9 +++++++--
 Grow.c   | 5 +++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/Create.c b/Create.c
index f5d57f8c..789a6464 100644
--- a/Create.c
+++ b/Create.c
@@ -899,8 +899,13 @@ int Create(struct supertype *st, char *mddev,
 				else
 					inf->disk.state = 0;
 
-				if (dv->writemostly == FlagSet)
-					inf->disk.state |= (1<<MD_DISK_WRITEMOSTLY);
+				if (dv->writemostly == FlagSet) {
+					if (major_num == BITMAP_MAJOR_CLUSTERED) {
+						pr_err("Can not set --write-mostly with a clustered bitmap\n");
+						goto abort_locked;
+					} else
+						inf->disk.state |= (1<<MD_DISK_WRITEMOSTLY);
+				}
 				if (dv->failfast == FlagSet)
 					inf->disk.state |= (1<<MD_DISK_FAILFAST);
 
diff --git a/Grow.c b/Grow.c
index 7506ab46..f9cc091e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -430,6 +430,11 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 			dv = map_dev(disk.major, disk.minor, 1);
 			if (!dv)
 				continue;
+			if (((disk.state & (1 << MD_DISK_WRITEMOSTLY)) == 0) &&
+			   (strcmp(s->bitmap_file, "clustered") == 0)) {
+				pr_err("disks marked write-mostly are not supported with clustered bitmap\n");
+				return 1;
+			}
 			fd2 = dev_open(dv, O_RDWR);
 			if (fd2 < 0)
 				continue;
-- 
2.29.2

