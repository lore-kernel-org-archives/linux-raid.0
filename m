Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BCBC433E6
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jan 2021 20:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0611233FC
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jan 2021 20:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392668AbhATUIe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jan 2021 15:08:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392789AbhATUHN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 20 Jan 2021 15:07:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611173147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6eD7VYWAobROrsiOgUJOrS1jcOUOOIqOtjKgz9OsHdk=;
        b=LyS+7MUgueyDvTzBdbX8WNSnDeYbrji0T1kL2aoBUVTwBrNq/rUkK2qZXJD2K/B7nK54nc
        firGctVo76FgfcPiTRmsXOHswWmBamjqfJB1VY7I6YGXm/K+mJATu0vA6ldN/KdLa9X2X9
        s/y4MdxWnJGXcFeNZAEyKEEkm/C6JVQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-HALJkJQVM4OMUixMEWSzyg-1; Wed, 20 Jan 2021 15:05:45 -0500
X-MC-Unique: HALJkJQVM4OMUixMEWSzyg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18E0380A5C2;
        Wed, 20 Jan 2021 20:05:44 +0000 (UTC)
Received: from localhost (dhcp-17-171.bos.redhat.com [10.18.17.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1CFB5D74D;
        Wed, 20 Jan 2021 20:05:43 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org, xni@redhat.com
Subject: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
Date:   Wed, 20 Jan 2021 15:05:42 -0500
Message-Id: <20210120200542.19139-1-ncroxon@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Reshaping a 3-disk RAID5 to 4-disk RAID6 will cause a hang of
the resync after the grow.

Adding a spare disk to avoid degrading the array when growing
is successful, but not successful when supplying a backup file
on the command line. If the reshape job is not already running,
set the sync_max value to max.

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
 Grow.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 6b8321c..5c2512f 100644
--- a/Grow.c
+++ b/Grow.c
@@ -931,12 +931,15 @@ int start_reshape(struct mdinfo *sra, int already_running,
 	err = err ?: sysfs_set_num(sra, NULL, "sync_max", sync_max_to_set);
 	if (!already_running && err == 0) {
 		int cnt = 5;
+		int err2;
 		do {
 			err = sysfs_set_str(sra, NULL, "sync_action",
 					    "reshape");
-			if (err)
+			err2 = sysfs_set_str(sra, NULL, "sync_max",
+					    "max");
+			if (err || err2)
 				sleep(1);
-		} while (err && errno == EBUSY && cnt-- > 0);
+		} while (err && err2 && errno == EBUSY && cnt-- > 0);
 	}
 	return err;
 }
-- 
2.20.1

