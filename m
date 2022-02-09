Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A411C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  9 Feb 2022 12:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbiBIMmq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Feb 2022 07:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiBIMmp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Feb 2022 07:42:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53057C05CB86
        for <linux-raid@vger.kernel.org>; Wed,  9 Feb 2022 04:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644410568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K0boWr3oekGE6Cf9h6rhjBSwHVUXEFVn6iztQwveECU=;
        b=G5JD3KIDW/O8aCbWIv+ZDHS1c6XKeFhcD/gRdZME8FohLGY9LruYJ9h5ZZWxr1QBU9ru6u
        SL4GQBwlbLAExdeial1fHTdfi6EG6FtGUoDqnqH3+CgsmW7KFRY1vGqT3KCpzXCe3VIEaM
        dV+5G4VooroBl35HOALdsKnQ67/Ck0E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-6LSmoyDSMu6y7LISfO-g7g-1; Wed, 09 Feb 2022 07:42:47 -0500
X-MC-Unique: 6LSmoyDSMu6y7LISfO-g7g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62E328189CF;
        Wed,  9 Feb 2022 12:42:46 +0000 (UTC)
Received: from localhost (dhcp-17-75.bos.redhat.com [10.18.17.75])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C364E752C5;
        Wed,  9 Feb 2022 12:42:44 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     linux-raid@vger.kernel.org, wuguanghao3@huawei.com,
        mariusz.tkaczyk@linux.intel.com, jes@trained-monkey.org
Subject: [PATCH] Revert "mdadm: fix coredump of mdadm --monitor -r"
Date:   Wed,  9 Feb 2022 07:42:44 -0500
Message-Id: <20220209124244.3466068-1-ncroxon@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This reverts commit 546047688e1c64638f462147c755b58119cabdc8.

mdadm: fix msg when removing a device using the short arg -r

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

# mdadm --set-faulty /dev/md0 /dev/vdd
mdadm: set /dev/vdd faulty in /dev/md0
# mdadm --manage /dev/md0 -r /dev/vdd
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
index 81399765..ee457a54 100644
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

