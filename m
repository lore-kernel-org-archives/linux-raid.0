Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D7CE7E62B
	for <linux-raid@archiver.kernel.org>; Wed, 27 Sep 2023 04:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjI0E0S (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Sep 2023 00:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjI0EZA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Sep 2023 00:25:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC1E6A59
        for <linux-raid@vger.kernel.org>; Tue, 26 Sep 2023 19:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695783150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FTyeewkTkW82Ls4XdGFu2Y3UjGeWA7as05jvbTuSqL4=;
        b=FvtgIBGm5nv1moSnFll8/mvMInTE5yAqLakZFU+ssroC8qJptY8jW7d0XWSRBD7eBMmrOW
        xEn9QHNkukt9HUqTuRsnvT9HwRRT/uBYxOwUx11tN2F3+3ph9a+aqv6cvYoHOxkHvnZ66h
        NuIoT6F5X8Pboy9T55Q7XBiwsiGzShU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-swSULJIgPj-wX_U-t92bww-1; Tue, 26 Sep 2023 22:52:27 -0400
X-MC-Unique: swSULJIgPj-wX_U-t92bww-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 154841C0635C;
        Wed, 27 Sep 2023 02:52:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 975862156702;
        Wed, 27 Sep 2023 02:52:25 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 2/4 v2] mdadm/tests: Don't run mknod before losetup
Date:   Wed, 27 Sep 2023 10:52:17 +0800
Message-Id: <20230927025219.49915-3-xni@redhat.com>
In-Reply-To: <20230927025219.49915-1-xni@redhat.com>
References: <20230927025219.49915-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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

