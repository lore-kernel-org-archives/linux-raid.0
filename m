Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E693EEE57E5
	for <linux-raid@archiver.kernel.org>; Fri,  8 Sep 2023 08:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237916AbjIHIpd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Sep 2023 04:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjIHIpc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Sep 2023 04:45:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201CB1BC8
        for <linux-raid@vger.kernel.org>; Fri,  8 Sep 2023 01:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694162682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FTyeewkTkW82Ls4XdGFu2Y3UjGeWA7as05jvbTuSqL4=;
        b=hlJcUkBdejW6IUdJRm51K9dmcui0J0JY3lH2bVqVmFJacB3uaaPMuiU481nkSd3k8a36tR
        8VQdcGR5gZYdM9QoqqX3z4Vip1EIo9o0IUmbl49Db8GMJxT3Pz0poDqiCxq1Y5sj4cZfOj
        UOq7/SDapydZuQMl1LqWOuwgV8N4MhM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-1QeEjLRFOUirsUyP57NhZQ-1; Fri, 08 Sep 2023 04:44:38 -0400
X-MC-Unique: 1QeEjLRFOUirsUyP57NhZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55854816525;
        Fri,  8 Sep 2023 08:44:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08E7B2026D4B;
        Fri,  8 Sep 2023 08:44:36 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/1] mdadm/tests: Don't run mknod before losetup
Date:   Fri,  8 Sep 2023 16:44:35 +0800
Message-Id: <20230908084435.30674-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Sometimes it can fail:
losetup: /var/tmp/mdtest0: failed to set up loop device: No such device or address
/dev/loop0 and /var/tmp/mdtest0 are already created before losetup.

Because losetup can create device node by itself. So remove mknod.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/func.sh | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/func.sh b/tests/func.sh
index 9710a53b8a73..5053b0121f1d 100644
--- a/tests/func.sh
+++ b/tests/func.sh
@@ -170,7 +170,6 @@ do_setup() {
 				dd if=/dev/zero of=$targetdir/mdtest$d count=$sz bs=1K > /dev/null 2>&1
 			# make sure udev doesn't touch
 			mdadm --zero $targetdir/mdtest$d 2> /dev/null
-			[ -b /dev/loop$d ] || mknod /dev/loop$d b 7 $d
 			if [ $d -eq 7 ]
 			then
 				losetup /dev/loop$d $targetdir/mdtest6 # for multipath use
-- 
2.32.0 (Apple Git-132)

