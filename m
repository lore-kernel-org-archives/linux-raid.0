Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0070C61DA4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCFV3i (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjCFV3C (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C514436698
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O4GlzpdNdgKEUc4K1S8siOM463GeVxJmMdoirKnxo4M=;
        b=VzRsK70NvFZVcc0Faiv75JMvNRD4H/mfYeyzTOpGmjV0ctQQQBDLXQGnLDpUye/LRl5GI8
        XCEQHBhOSxcOotPcuiNGyrApX4dr1c82fP04+uDLs+vNQOqw5tqvqAV+zCYWAQj1Q1N6Ns
        viFgUK4Zi7aH9Lh/on25vJUcTS65KPE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-KWKvGeRVNAmQ-NBY-ZWcFw-1; Mon, 06 Mar 2023 16:28:09 -0500
X-MC-Unique: KWKvGeRVNAmQ-NBY-ZWcFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4828F802D2F
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:09 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BC43400DFA1;
        Mon,  6 Mar 2023 21:28:07 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 10/34] md: remove trailing whitespace [ERROR]
Date:   Mon,  6 Mar 2023 22:27:33 +0100
Message-Id: <17ce00f49d8ba635c410c62998ef57bddb0a4dff.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ff4699babdd6..132979e597dd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2156,28 +2156,29 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 		max_sectors = bdev_nr_sectors(rdev->bdev) - rdev->data_offset;
 		if (!num_sectors || num_sectors > max_sectors)
 			num_sectors = max_sectors;
-	} else if (rdev->mddev->bitmap_info.offset) {
-		/* minor version 0 with bitmap we can't move */
-		return 0;
 	} else {
-		/* minor version 0; superblock after data */
-		sector_t sb_start, bm_space;
-		sector_t dev_size = bdev_nr_sectors(rdev->bdev);
+		if (!rdev->mddev->bitmap_info.offset) {
+			/* minor version 0; superblock after data */
+			sector_t sb_start, bm_space;
+			sector_t dev_size = bdev_nr_sectors(rdev->bdev);
 
-		/* 8K is for superblock */
-		sb_start = dev_size - 8*2;
-		sb_start &= ~(sector_t)(4*2 - 1);
+			/* 8K is for superblock */
+			sb_start = dev_size - 8*2;
+			sb_start &= ~(sector_t)(4*2 - 1);
 
-		bm_space = super_1_choose_bm_space(dev_size);
+			bm_space = super_1_choose_bm_space(dev_size);
 
-		/* Space that can be used to store date needs to decrease
-		 * superblock bitmap space and bad block space(4K)
-		 */
-		max_sectors = sb_start - bm_space - 4*2;
+			/* Space that can be used to store date needs to decrease
+			 * superblock bitmap space and bad block space(4K)
+			 */
+			max_sectors = sb_start - bm_space - 4*2;
 
-		if (!num_sectors || num_sectors > max_sectors)
-			num_sectors = max_sectors;
-		rdev->sb_start = sb_start;
+			if (!num_sectors || num_sectors > max_sectors)
+				num_sectors = max_sectors;
+			rdev->sb_start = sb_start;
+		} else
+			/* minor version 0 with bitmap we can't move */
+			return 0;
 	}
 	sb = page_address(rdev->sb_page);
 	sb->data_size = cpu_to_le64(num_sectors);
@@ -4608,7 +4609,7 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
 			if (buf == end)
 				break;
 		}
-		if (*end && !isspace(*end)) 
+		if (*end && !isspace(*end))
 			break;
 		md_bitmap_dirty_bits(mddev->bitmap, chunk, end_chunk);
 		buf = skip_spaces(end);
-- 
2.39.2

