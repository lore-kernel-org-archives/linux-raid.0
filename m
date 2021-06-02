Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8C2C47080
	for <linux-raid@archiver.kernel.org>; Wed,  2 Jun 2021 01:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45DD8613AD
	for <linux-raid@archiver.kernel.org>; Wed,  2 Jun 2021 01:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhFBBTI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Jun 2021 21:19:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229687AbhFBBTI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Jun 2021 21:19:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622596645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=wKdzfkxYNgJ1IZAdxSqBvrfPiUtoeGwL3fqBfMOsMXA=;
        b=ac1Akv0jHlTMA9gykd/Rb/C/BC+LUPfN1OrrwwFENYqX26xOR/uHBJQMLHtSO7+LdrHgzi
        b+r9kn/HwrQG619too//EV42wHmGFYgW6N2GGwXCZag3GJHKRFpLqwIKPMB/ReNn6HY4uL
        xscgLTAfUCTnB8WNAveISxZF8Y1damQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-GUn1RCCwN36MzVDv_BzrfA-1; Tue, 01 Jun 2021 21:17:24 -0400
X-MC-Unique: GUn1RCCwN36MzVDv_BzrfA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92579188E3C1;
        Wed,  2 Jun 2021 01:17:23 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A464F5D6DC;
        Wed,  2 Jun 2021 01:17:21 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     ncroxon@redhat.com, linux-raid@vger.kernel.org
Subject: [PATCH 1/1] mdadm/super1: It needs to specify int32 for bitmap_offset
Date:   Wed,  2 Jun 2021 09:17:19 +0800
Message-Id: <1622596639-3767-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

For super1.0 bitmap offset is -16. So it needs to use int type for bitmap offset.

Fixes: 1fe2e1007310 (mdadm/bitmap: locate bitmap calcuate bitmap position wrongly)
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/super1.c b/super1.c
index c05e623..a12a5bc 100644
--- a/super1.c
+++ b/super1.c
@@ -2631,7 +2631,7 @@ static int locate_bitmap1(struct supertype *st, int fd, int node_num)
 	else
 		ret = -1;
 
-	offset = __le64_to_cpu(sb->super_offset) + __le32_to_cpu(sb->bitmap_offset);
+	offset = __le64_to_cpu(sb->super_offset) + (int32_t)__le32_to_cpu(sb->bitmap_offset);
 	if (node_num) {
 		bms = (bitmap_super_t*)(((char*)sb)+MAX_SB_SIZE);
 		bm_sectors_per_node = calc_bitmap_size(bms, 4096) >> 9;
-- 
2.7.5

