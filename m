Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE37CDB474
	for <linux-raid@archiver.kernel.org>; Tue, 17 Oct 2023 03:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbjJQDwv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Oct 2023 23:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjJQDwu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 Oct 2023 23:52:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C969E83
        for <linux-raid@vger.kernel.org>; Mon, 16 Oct 2023 20:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697514721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hJLIvwP7PLMrfVxQwlxhTRb1MCb7GTnboI6La+iUB/8=;
        b=PBeqQ6FMkwVdgeyEXkOlI7DLGGivru1Ppjd4fzvGvusrboON7L/fZmbh64PEHfUZmzwTi8
        XCsze5Ap5RA8GGqQEUDtbNeDkZTi05LiOQsjIcLNbDPKVD7PvvUKGqbSoocFkDP8f1j7w9
        BQ6MNy9RLsBDFpG/DljNthhwSxAUjRw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-n-9CVyp2MoGJsBJV8sDQQg-1; Mon, 16 Oct 2023 23:51:47 -0400
X-MC-Unique: n-9CVyp2MoGJsBJV8sDQQg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B63E02999B34;
        Tue, 17 Oct 2023 03:51:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35B56492BFA;
        Tue, 17 Oct 2023 03:51:43 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     mariusz.tkaczyk@linux.intel.com, colyli@suse.de, neilb@suse.de,
        linux-raid@vger.kernel.org
Subject: [PATCH V2 1/1] mdadm/super1: Add MD_FEATURE_RAID0_LAYOUT for all raid0 after kernel v5.4
Date:   Tue, 17 Oct 2023 11:51:42 +0800
Message-Id: <20231017035142.41168-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

After and include kernel v5.4, it adds one feature bit MD_FEATURE_RAID0_LAYOUT.
It must need to specify a layout for raid0 with more than one zone. But for
raid0 with one zone, in fact it also has a defalut layout.

Now for raid0 with one zone, *unknown* layout can be seen when running mdadm -D
command. It's the reason that mdadm doesn't set MD_FEATURE_RAID0_LAYOUT for
raid0 with one zone. Then in kernel space, super_1_validate sets mddev->layout
to -1 because of no MD_FEATURE_RAID0_LAYOUT. In fact, in raid0 io path, it
uses the default layout. So in fact after/include kernel v5.4, all raid0 device
have layout.

Fixes: 329dfc28debb ('Create: add support for RAID0 layouts.')
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super1.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/super1.c b/super1.c
index 856b02082662..653a2ea6c0e4 100644
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
+		if (sb->level == 0 && sb->layout && get_linux_version() >= 5004000)
 			sb->feature_map |= __cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);
 
 		sb->sb_csum = calc_sb_1_csum(sb);
-- 
2.32.0 (Apple Git-132)

