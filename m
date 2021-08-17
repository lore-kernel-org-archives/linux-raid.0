Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0127FC4338F
	for <linux-raid@archiver.kernel.org>; Tue, 17 Aug 2021 13:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE0AB60F35
	for <linux-raid@archiver.kernel.org>; Tue, 17 Aug 2021 13:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhHQNGt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Aug 2021 09:06:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229721AbhHQNGs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 17 Aug 2021 09:06:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629205575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YW3w6jS7iwNDGfMtPYrSmkEJmlXikWTAZa43seiEAxY=;
        b=EfzhOsZ4AKC3dEjaqJAFcdkQOoONQyr/JqOvnnnhKSlwcStQU2U6cnwE15TZkUcT0KZxKR
        jYrer7QCYuqF5mk1VXwohi3Ykl3nv1zKvPEgXY/udUjsgzH3jONBnYtUm0/HUvNDxeRlzz
        y2XJYzGRHRJpPeAn88VXJG2Lz52ObEQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-rzjDnQRaOTilPjqzwhNd0A-1; Tue, 17 Aug 2021 09:06:13 -0400
X-MC-Unique: rzjDnQRaOTilPjqzwhNd0A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 687D687D54F;
        Tue, 17 Aug 2021 13:06:12 +0000 (UTC)
Received: from localhost (dhcp-17-75.bos.redhat.com [10.18.17.75])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C8C15DA60;
        Tue, 17 Aug 2021 13:06:12 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     jes@trained-monkey.org, mariusz.tkaczyk@linux.intel.com,
        neilb@suse.de, xni@redhat.com, linux-raid@vger.kernel.org
Subject: [PATCH] Fix buffer size warning for strcpy
Date:   Tue, 17 Aug 2021 09:06:11 -0400
Message-Id: <20210817130611.2496090-1-ncroxon@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

To meet requirements of Common Criteria certification vulnerablility
assessment. Static code analysis has been run and found the following
error:
buffer_size_warning: Calling "strncpy" with a maximum size
argument of 16 bytes on destination array "ve->name" of
size 16 bytes might leave the destination string unterminated.

The change is to make the destination size to fit the allocated size.

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
 super-ddf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index dc8e512f..486183ed 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2637,9 +2637,10 @@ static int init_super_ddf_bvd(struct supertype *st,
 		ve->init_state = DDF_init_not;
 
 	memset(ve->pad1, 0xff, 14);
-	memset(ve->name, ' ', 16);
+	memset(ve->name, ' ', 15);
+	ve->name[15] = '\0';
 	if (name)
-		strncpy(ve->name, name, 16);
+		strncpy(ve->name, name, 15);
 	ddf->virt->populated_vdes =
 		cpu_to_be16(be16_to_cpu(ddf->virt->populated_vdes)+1);
 
-- 
2.29.2

