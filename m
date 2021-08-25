Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD2E2C43214
	for <linux-raid@archiver.kernel.org>; Wed, 25 Aug 2021 15:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF3F161027
	for <linux-raid@archiver.kernel.org>; Wed, 25 Aug 2021 15:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241377AbhHYPbE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Aug 2021 11:31:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241030AbhHYPbE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 25 Aug 2021 11:31:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629905418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KsPMINA40v3JchUuqVD7LPv0WICtR6YgLfUxAhNVnNs=;
        b=UsAChOAolm1uAA6WLRbB+Fu1AkGldVU+7Y9eobn7cwR+OnA6CXRbqtNC407iuXk5ZqAe7o
        7NAjUS60U5wffmw3MGgxk9dZcHq49o9wKtJOuJPCUKgyD3J2SaLtEuToJDP9KU3/Sys3AU
        MWuEKYNsoybrRSyCXYbQnaZrt0buFbs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-ZkD9pSmhNL-dDDCoaF37iw-1; Wed, 25 Aug 2021 11:30:16 -0400
X-MC-Unique: ZkD9pSmhNL-dDDCoaF37iw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E3731853032;
        Wed, 25 Aug 2021 15:30:15 +0000 (UTC)
Received: from localhost (dhcp-17-75.bos.redhat.com [10.18.17.75])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 01E2D10013D6;
        Wed, 25 Aug 2021 15:30:14 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     jes@trained-monkey.org, mariusz.tkaczyk@linux.intel.com,
        neilb@suse.de, xni@redhat.com, linux-raid@vger.kernel.org,
        gal.ofri@volumez.com
Subject: [PATCH V5] Fix buffer size warning for strcpy
Date:   Wed, 25 Aug 2021 11:30:14 -0400
Message-Id: <20210825153014.2780505-1-ncroxon@redhat.com>
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
https://people.redhat.com/ncroxon/mdadm-4.2-rc2-scan-results.html

The change is to make the destination size to fit the allocated size.

V5:
Simplify the the strnlen call.

V4:
Code cleanup of the interim "if" statement.

V3: Doc change only:
The code change from filling ve->name with spaces to filling it with
null-terminated is to comform to the SNIA - Common RAID Disk Data
Format Specification. The format for VD_Name (ve->name) specifies
the field to be either ASCII or UNICODE. Bit 2 of the VD_Type field
MUST be used to determine the Unicode or ASCII format of this field.
If this field is not used, all bytes MUST be set to zero.

V2: Change from zero-terminated to zero-padded on memset and
change from using strncpy to memcpy, feedback from Neil Brown.

Tested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
 super-ddf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index dc8e512f..2eb617e6 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2637,9 +2637,11 @@ static int init_super_ddf_bvd(struct supertype *st,
 		ve->init_state = DDF_init_not;
 
 	memset(ve->pad1, 0xff, 14);
-	memset(ve->name, ' ', 16);
-	if (name)
-		strncpy(ve->name, name, 16);
+	memset(ve->name, '\0', sizeof(ve->name));
+	if (name) {
+		int l = strnlen(name, sizeof(ve->name));
+		memcpy(ve->name, name, l);
+	}
 	ddf->virt->populated_vdes =
 		cpu_to_be16(be16_to_cpu(ddf->virt->populated_vdes)+1);
 
-- 
2.29.2

