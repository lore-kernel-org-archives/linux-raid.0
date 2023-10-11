Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B86CD6E67
	for <linux-raid@archiver.kernel.org>; Wed, 11 Oct 2023 13:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjJKNG3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Oct 2023 09:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbjJKNGV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 Oct 2023 09:06:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D7EA9
        for <linux-raid@vger.kernel.org>; Wed, 11 Oct 2023 06:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697029538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MAO3zbc0Lkz/KcHKFrS+OfHy8ojzbWa3T5laG/4T28Q=;
        b=JeIHMylTRO8PzGrpa5aT+UJLAvJTcoggQb3BxucJGjzyDHuX0Qb2zUZ82Vu6eSLz9CrB8k
        4tu1SvFGzzsBwev2niFe7hitms9BN/0HC5qPZbr8Exc6LkttP+GtIXpey3wpIsE489PPtr
        FCGznSp2AruA1LQTnVFxmYTmm6qqxTM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-uae0IGLPOtWTQWDpZHlLIQ-1; Wed, 11 Oct 2023 09:05:35 -0400
X-MC-Unique: uae0IGLPOtWTQWDpZHlLIQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F17A81C07587;
        Wed, 11 Oct 2023 13:05:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.113.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BAD5492B04;
        Wed, 11 Oct 2023 13:05:23 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org,
        colyli@suse.de, neilb@suse.de
Subject: [PATCH 1/1] mdadm/super1: Add MD_FEATURE_RAID0_LAYOUT if sb->layout is set
Date:   Wed, 11 Oct 2023 21:05:22 +0800
Message-Id: <20231011130522.78994-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In kernel space super_1_validate sets mddev->layout to -1 if MD_FEATURE_RAID0_LAYOUT
is not set. MD_FEATURE_RAID0_LAYOUT is set in mdadm write_init_super1. Now only raid
with more than one zone can set this bit. But for raid0 with same size member disks,
it doesn't set this bit. The layout is *unknown* when running mdadm -D command. In
fact it should be RAID0_ORIG_LAYOUT which gets from default_layout.

So set MD_FEATURE_RAID0_LAYOUT when sb->layout has value.

Fixes: 329dfc28debb ('Create: add support for RAID0 layouts.')
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super1.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/super1.c b/super1.c
index 856b02082662..f29751b4a5c7 100644
--- a/super1.c
+++ b/super1.c
@@ -1978,26 +1978,10 @@ static int write_init_super1(struct supertype *st)
 	unsigned long long sb_offset;
 	unsigned long long data_offset;
 	long bm_offset;
-	int raid0_need_layout = 0;
 
-	for (di = st->info; di; di = di->next) {
+	for (di = st->info; di; di = di->next)
 		if (di->disk.state & (1 << MD_DISK_JOURNAL))
 			sb->feature_map |= __cpu_to_le32(MD_FEATURE_JOURNAL);
-		if (sb->level == 0 && sb->layout != 0) {
-			struct devinfo *di2 = st->info;
-			unsigned long long s1, s2;
-			s1 = di->dev_size;
-			if (di->data_offset != INVALID_SECTORS)
-				s1 -= di->data_offset;
-			s1 /= __le32_to_cpu(sb->chunksize);
-			s2 = di2->dev_size;
-			if (di2->data_offset != INVALID_SECTORS)
-				s2 -= di2->data_offset;
-			s2 /= __le32_to_cpu(sb->chunksize);
-			if (s1 != s2)
-				raid0_need_layout = 1;
-		}
-	}
 
 	for (di = st->info; di; di = di->next) {
 		if (di->disk.state & (1 << MD_DISK_FAULTY))
@@ -2139,8 +2123,7 @@ static int write_init_super1(struct supertype *st)
 			sb->bblog_offset = 0;
 		}
 
-		/* RAID0 needs a layout if devices aren't all the same size */
-		if (raid0_need_layout)
+		if (sb->level == 0 && sb->layout)
 			sb->feature_map |= __cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);
 
 		sb->sb_csum = calc_sb_1_csum(sb);
-- 
2.32.0 (Apple Git-132)

