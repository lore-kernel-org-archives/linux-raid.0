Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA9B4C4338F
	for <linux-raid@archiver.kernel.org>; Mon, 23 Aug 2021 14:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A10CF61186
	for <linux-raid@archiver.kernel.org>; Mon, 23 Aug 2021 14:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhHWOgQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 Aug 2021 10:36:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27771 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230177AbhHWOgQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 23 Aug 2021 10:36:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629729333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K3ynbJMD8LESrwraLXuLT+T98j7BjDiuihcV62hEScM=;
        b=ALvf3b1OHeI6mHxphhC8sKliPUDUWLHTJiwo9EpainAJoEN5dICo4c7873xK99KJGd3eCt
        QX6632NxD4a2adQ/4ywsek16S0KEJZc17Hg/1ohCn/FEZpSx9ExuLWiZE5oG+sZmHKeooE
        6+Q8w1CKYVS322thn5sEszx0J0iYK48=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-vvdNTT2HO2GmDUj5ohFzRw-1; Mon, 23 Aug 2021 10:35:29 -0400
X-MC-Unique: vvdNTT2HO2GmDUj5ohFzRw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 580901082934;
        Mon, 23 Aug 2021 14:35:28 +0000 (UTC)
Received: from localhost (dhcp-17-75.bos.redhat.com [10.18.17.75])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AB525B4BC;
        Mon, 23 Aug 2021 14:35:28 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     jes@trained-monkey.org, mariusz.tkaczyk@linux.intel.com,
        neilb@suse.de, xni@redhat.com, linux-raid@vger.kernel.org,
        gal.ofri@volumez.com
Subject: [PATCH V3] Fix buffer size warning for strcpy
Date:   Mon, 23 Aug 2021 10:35:24 -0400
Message-Id: <20210823143525.2517040-1-ncroxon@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

V3: Doc change only: 
The code change from filling ve->name with spaces to filling it with
null-terminated is to comform to the SNIA - Common RAID Disk Data
Format Specification. The format for VD_Name (ve->name) specifies
the field to be either ASCII or UNICODE. Bit 2 of the VD_Type field
MUST be used to determine the Unicode or ASCII format of this field.
If this field is not used, all bytes MUST be set to zero. 

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

