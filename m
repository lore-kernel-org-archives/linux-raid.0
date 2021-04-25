Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C40C433ED
	for <linux-raid@archiver.kernel.org>; Sun, 25 Apr 2021 09:23:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ED716102A
	for <linux-raid@archiver.kernel.org>; Sun, 25 Apr 2021 09:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhDYJX7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 25 Apr 2021 05:23:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229797AbhDYJXu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sun, 25 Apr 2021 05:23:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619342590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=uX7UYXuo75g2ZZ4lJLKIW5ncGaPEAg4b1S/fe6ijJW0=;
        b=Cp1OtDgezCpWozFoYrklDEy5nElwXeHzT+o8gM7TNMoib2UmfljTSdLbxxr3V2+PvtwIDk
        7hdDVZM87HKcY4fQ94D6u8aIWVRv+3krWr9bP5WplaQaayOKLBdtnh6waeIUQiB5+A7xVG
        bOgU1fbhMwofl0xhnsLqnRX9s69GNEw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-udXt5vN0Mx6bgAq_VCE8yA-1; Sun, 25 Apr 2021 05:23:07 -0400
X-MC-Unique: udXt5vN0Mx6bgAq_VCE8yA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC82818397A3;
        Sun, 25 Apr 2021 09:23:05 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0CDD60BE5;
        Sun, 25 Apr 2021 09:22:59 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org, dan.j.williams@intel.com, yuyufen@huawei.com,
        ncroxon@redhat.com, heinzm@redhat.com
Subject: [PATCH 1/1] async_xor: It should add src_offs when dropping destination page
Date:   Sun, 25 Apr 2021 17:22:57 +0800
Message-Id: <1619342577-6034-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Now we support sharing one page if PAGE_SIZE is not equal stripe size. To support this,
it needs to support calculating xor value with different offsets for each r5dev. One
offset array is used to record those offsets.

In RMW mode, parity page is used as a source page. It sets ASYNC_TX_XOR_DROP_DST before
calculating xor value in ops_run_prexor5. So it needs to add src_list and src_offs at
the same time. Now it only needs src_list. So the xor value which is calculated is wrong.
It can cause data corruption problem.

I can reproduce this problem 100% on a POWER8 machine. The steps are:
mdadm -CR /dev/md0 -l5 -n3 /dev/sdb1 /dev/sdc1 /dev/sdd1 --size=3G
mkfs.xfs /dev/md0
mount /dev/md0 /mnt/test
mount: /mnt/test: mount(2) system call failed: Structure needs cleaning.

Fixes: 29bcff787 ("md/raid5: add new xor function to support different page offset")
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 crypto/async_tx/async_xor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index a057ecb..6cd7f70 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -233,6 +233,7 @@ async_xor_offs(struct page *dest, unsigned int offset,
 		if (submit->flags & ASYNC_TX_XOR_DROP_DST) {
 			src_cnt--;
 			src_list++;
+			src_offs++;
 		}
 
 		/* wait for any prerequisite operations */
-- 
2.7.5

