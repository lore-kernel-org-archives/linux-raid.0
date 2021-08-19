Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2062FC4338F
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 13:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F213D6108D
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 13:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbhHSNK6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Aug 2021 09:10:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32304 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229670AbhHSNK6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 19 Aug 2021 09:10:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629378621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=c9t4Iu4oonn1x4A1Pz88f8d1uMmp7pRqqcMgA5pntTs=;
        b=jNBRtOVoOWeXOIbmvKGhg1g70KIFGeUcNfdJAdZDuVP30njnXUsEEcR2A6D8nRgWzSzalg
        45R843ux3NrqO/J3mmswc9tP2fv3s0NJIYAJzRPaTTh+CDwHM+ZAE1B/lkJNK+mP5s1DCs
        A2BkDxk6xuRVOx7QZBA4drLZVsL2RQk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-8SWfWeZZMEWIlaEHzu-iZg-1; Thu, 19 Aug 2021 09:10:19 -0400
X-MC-Unique: 8SWfWeZZMEWIlaEHzu-iZg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B232101C8A6;
        Thu, 19 Aug 2021 13:10:18 +0000 (UTC)
Received: from localhost (dhcp-17-75.bos.redhat.com [10.18.17.75])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 49E551036D04;
        Thu, 19 Aug 2021 13:10:18 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     neilb@suse.de, jes@trained-monkey.org, xni@redhat.com,
        linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com
Subject: [PATCH V2] Fix buffer size warning for strcpy
Date:   Thu, 19 Aug 2021 09:10:17 -0400
Message-Id: <20210819131017.2511208-1-ncroxon@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

To meet requirements of Common Criteria certification vulnerability
assessment. Static code analysis has been run and found the following
error:
buffer_size_warning: Calling "strncpy" with a maximum size
argument of 16 bytes on destination array "ve->name" of
size 16 bytes might leave the destination string unterminated.

The change is to make the destination size to fit the allocated size.

V2: Change from zero-terminated to zero-padded on memset and
change from using strncpy to memcpy, feedback from Neil Brown.

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
 super-ddf.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index dc8e512..1771316 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2637,9 +2637,13 @@ static int init_super_ddf_bvd(struct supertype *st,
 		ve->init_state = DDF_init_not;
 
 	memset(ve->pad1, 0xff, 14);
-	memset(ve->name, ' ', 16);
-	if (name)
-		strncpy(ve->name, name, 16);
+	memset(ve->name, '\0', sizeof(ve->name));
+	if (name) {
+		int l = strlen(ve->name);
+		if (l > 16)
+			l = 16;
+		memcpy(ve->name, name, l);
+	}
 	ddf->virt->populated_vdes =
 		cpu_to_be16(be16_to_cpu(ddf->virt->populated_vdes)+1);
 
-- 
2.29.2

