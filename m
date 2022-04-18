Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31890C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 18 Apr 2022 17:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347190AbiDRRrJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Apr 2022 13:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346846AbiDRRrI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Apr 2022 13:47:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C61430F5B
        for <linux-raid@vger.kernel.org>; Mon, 18 Apr 2022 10:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650303868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LnkRM0HW2YYLqspOmPvsxTHjZZfEFLgJUTnQtu6wWX4=;
        b=d7rAltIxVmXwhKQ9IaAkTX32qXrPx2DhndTqVh2OBPqRvbsaTPdEWMtEiwwH21ss3vztED
        8ZPko0/BOX8yfdPpr+u0wv2Hv/czAlLnfEPPtJ6z+Ci88Le2pQ1e1NnivNUEKgO1cANGnZ
        o/QD1QZJxrRxpq76c7al9YWJljLJ9Xc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-9ckji3UPMcyQEssi6KZSjQ-1; Mon, 18 Apr 2022 13:44:25 -0400
X-MC-Unique: 9ckji3UPMcyQEssi6KZSjQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBC5C1014A6B;
        Mon, 18 Apr 2022 17:44:24 +0000 (UTC)
Received: from localhost (dhcp-17-75.bos.redhat.com [10.18.17.75])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D585536BB7;
        Mon, 18 Apr 2022 17:44:24 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     jes@trained-monkey.org, linux-raid@vger.kernel.org,
        mariusz.tkaczyk@linux.intel.com, wuguanghao3@huawei.com,
        colyli@suse.de
Subject: [PATCH] Revert "mdadm: fix coredump of mdadm --monitor -r"
Date:   Mon, 18 Apr 2022 13:44:23 -0400
Message-Id: <20220418174423.846026-1-ncroxon@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This reverts commit 546047688e1c64638f462147c755b58119cabdc8.

The change from commit mdadm: fix coredump of mdadm
--monitor -r broke the printing of the return message when
passing -r to mdadm --manage, the removal of a device from
an array.

If the current code reverts this commit, both issues are
still fixed.

The original problem reported that the fix tried to address
was:  The --monitor -r option requires a parameter,
otherwise a null pointer will be manipulated when
converting to integer data, and a core dump will appear.

The original problem was really fixed with:
60815698c0a Refactor parse_num and use it to parse optarg.
Which added a check for NULL in 'optarg' before moving it
to the 'increments' variable.

New issue: When trying to remove a device using the short
argument -r, instead of the long argument --remove, the
output is empty. The problem started when commit
546047688e1c was added.

Steps to Reproduce:
1. create/assemble /dev/md0 device
2. mdadm --manage /dev/md0 -r /dev/vdxx

Actual results:
Nothing, empty output, nothing happens, the device is still
connected to the array.

The output should have stated "mdadm: hot remove failed
for /dev/vdxx: Device or resource busy", if the device was
still active. Or it should remove the device and print
a message:

mdadm: set /dev/vdd faulty in /dev/md0
mdadm: hot removed /dev/vdd from /dev/md0

The following commit should be reverted as it breaks
mdadm --manage -r.

commit 546047688e1c64638f462147c755b58119cabdc8
Author: Wu Guanghao <wuguanghao3@huawei.com>
Date:   Mon Aug 16 15:24:51 2021 +0800
mdadm: fix coredump of mdadm --monitor -r

-Nigel

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
 ReadMe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ReadMe.c b/ReadMe.c
index 8f873c48..bec1be9a 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -81,11 +81,11 @@ char Version[] = "mdadm - v" VERSION " - " VERS_DATE EXTRAVERSION "\n";
  *     found, it is started.
  */
 
-char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k";
+char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
 char short_bitmap_options[]=
-		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
+		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
 char short_bitmap_auto_options[]=
-		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
+		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
 
 struct option long_options[] = {
     {"manage",    0, 0, ManageOpt},
-- 
2.29.2

