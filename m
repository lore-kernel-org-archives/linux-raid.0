Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F380C43217
	for <linux-raid@archiver.kernel.org>; Fri, 14 Oct 2022 12:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiJNMUj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 14 Oct 2022 08:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiJNMUg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 14 Oct 2022 08:20:36 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63903C34F4
        for <linux-raid@vger.kernel.org>; Fri, 14 Oct 2022 05:20:35 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b12so6596139edd.6
        for <linux-raid@vger.kernel.org>; Fri, 14 Oct 2022 05:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0uYEnGywvne9fopfNBzfu2ahTVWilZnjJ1QFZzgosUc=;
        b=DNN/qK/uZh4ntKOmhei+A2BdCQsRN9P4mp9bgRidsYLBIjh7NoDLaTeCuhjDYxWclM
         y5MTUxzWdEbUqn5UmtoxlsBGA2N9JadUQmpqEbGUqMg2iWSWO9+NrxoZKHV1ffVHs+fZ
         6GupVD9sb20vhbdFA+2hfSqi3Xw2qAVCw/gXVuk8nGiepR8yVVccxWrw+bl5nOwJq8Bb
         tohJ33uQfn8osOJjdSWsk8vA1M5epdW2Jbc1In3LuCIBUT2z3wWbAxvKXy3yUhiLQy97
         DtAfJERbSurx0F9FO5dBl1Llzw95vwn1HO9NA/nQSa8D7OKFQmAQDpDGW1i1trTVEmSG
         UTEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0uYEnGywvne9fopfNBzfu2ahTVWilZnjJ1QFZzgosUc=;
        b=wxKxdy5A/bauzQH+eWlOiYB0gDoMv9aY704t3+b9Iem3CRGtL7Q4BfG7rHByz/wOSB
         oMu2ag3f08XPOuG19FwzAHxY/rVa0I8i7c6BUDf6mvUEVLOR6EWnzBbrdb9svjZctfp1
         cDrOxrBAtEhVp4Ezwip8x0tWFZpdmqqtXsY/Eb4FvXbCjyh/FrzbecxmCBTfhPMIG2wT
         TPTOqI7STJ1g9JrLAahFhfnRgQD6oLZewPYreO0QIFNNcsx5GOm0xSMk5sp4Fhhtp3Gq
         imuyODmqWOoEo8LnOAt60SzDhnx/XTiYe23HlzkbMPAf63smmNDvRZZDiqEa2E0Htv8x
         NzZw==
X-Gm-Message-State: ACrzQf3gk7OUXUQel7Tjvd2FdNUwHIXP2H8jMlxVQTRTtuLwCUaONwAp
        vrHRv8MbPbdLzc7N5LhqO7pkhjG2F+sLVQ==
X-Google-Smtp-Source: AMsMyM4G/1ecYDdnbut2cQJjiuhiu4XMZzExls7CHQeoI0xP7/iQwPCSDVxeD3/OmM+eoeqRqi3deg==
X-Received: by 2002:a05:6402:50cf:b0:45c:dfce:66ae with SMTP id h15-20020a05640250cf00b0045cdfce66aemr3846913edb.370.1665750033552;
        Fri, 14 Oct 2022 05:20:33 -0700 (PDT)
Received: from lb02065.fritz.box ([2001:9e8:141a:3e00:b256:9dae:b5ab:8180])
        by smtp.gmail.com with ESMTPSA id j18-20020a508a92000000b00458b8d4f4d5sm1737141edj.57.2022.10.14.05.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 05:20:33 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org,
        Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
        stable@vger.kernel.org
Subject: [PATCH] md/bitmap: Fix bitmap chunk size overflow issues.
Date:   Fri, 14 Oct 2022 14:20:32 +0200
Message-Id: <20221014122032.47784-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>

- limit bitmap chunk size internal u64 variable to values not overflowing
  the u32 bitmap superblock structure variable stored on persistent media.
- assign bitmap chunk size internal u64 variable from unsigned values to
  avoid possible sign extension artifacts when assigning from a s32 value.

The bug has been there since at least kernel 4.0.

Cc: stable@vger.kernel.org

Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/md/md-bitmap.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bf6dffadbe6f..b266711485a8 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -486,7 +486,7 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
 	sb = kmap_atomic(bitmap->storage.sb_page);
 	pr_debug("%s: bitmap file superblock:\n", bmname(bitmap));
 	pr_debug("         magic: %08x\n", le32_to_cpu(sb->magic));
-	pr_debug("       version: %d\n", le32_to_cpu(sb->version));
+	pr_debug("       version: %u\n", le32_to_cpu(sb->version));
 	pr_debug("          uuid: %08x.%08x.%08x.%08x\n",
 		 le32_to_cpu(*(__le32 *)(sb->uuid+0)),
 		 le32_to_cpu(*(__le32 *)(sb->uuid+4)),
@@ -497,11 +497,11 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
 	pr_debug("events cleared: %llu\n",
 		 (unsigned long long) le64_to_cpu(sb->events_cleared));
 	pr_debug("         state: %08x\n", le32_to_cpu(sb->state));
-	pr_debug("     chunksize: %d B\n", le32_to_cpu(sb->chunksize));
-	pr_debug("  daemon sleep: %ds\n", le32_to_cpu(sb->daemon_sleep));
+	pr_debug("     chunksize: %u B\n", le32_to_cpu(sb->chunksize));
+	pr_debug("  daemon sleep: %us\n", le32_to_cpu(sb->daemon_sleep));
 	pr_debug("     sync size: %llu KB\n",
 		 (unsigned long long)le64_to_cpu(sb->sync_size)/2);
-	pr_debug("max write behind: %d\n", le32_to_cpu(sb->write_behind));
+	pr_debug("max write behind: %u\n", le32_to_cpu(sb->write_behind));
 	kunmap_atomic(sb);
 }
 
@@ -2105,7 +2105,8 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			bytes = DIV_ROUND_UP(chunks, 8);
 			if (!bitmap->mddev->bitmap_info.external)
 				bytes += sizeof(bitmap_super_t);
-		} while (bytes > (space << 9));
+		} while (bytes > (space << 9) && (chunkshift + BITMAP_BLOCK_SHIFT) <
+			(BITS_PER_BYTE * sizeof(((bitmap_super_t *)0)->chunksize) - 1));
 	} else
 		chunkshift = ffz(~chunksize) - BITMAP_BLOCK_SHIFT;
 
@@ -2150,7 +2151,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	bitmap->counts.missing_pages = pages;
 	bitmap->counts.chunkshift = chunkshift;
 	bitmap->counts.chunks = chunks;
-	bitmap->mddev->bitmap_info.chunksize = 1 << (chunkshift +
+	bitmap->mddev->bitmap_info.chunksize = 1UL << (chunkshift +
 						     BITMAP_BLOCK_SHIFT);
 
 	blocks = min(old_counts.chunks << old_counts.chunkshift,
@@ -2176,8 +2177,8 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 				bitmap->counts.missing_pages = old_counts.pages;
 				bitmap->counts.chunkshift = old_counts.chunkshift;
 				bitmap->counts.chunks = old_counts.chunks;
-				bitmap->mddev->bitmap_info.chunksize = 1 << (old_counts.chunkshift +
-									     BITMAP_BLOCK_SHIFT);
+				bitmap->mddev->bitmap_info.chunksize =
+					1UL << (old_counts.chunkshift + BITMAP_BLOCK_SHIFT);
 				blocks = old_counts.chunks << old_counts.chunkshift;
 				pr_warn("Could not pre-allocate in-memory bitmap for cluster raid\n");
 				break;
@@ -2534,6 +2535,9 @@ chunksize_store(struct mddev *mddev, const char *buf, size_t len)
 	if (csize < 512 ||
 	    !is_power_of_2(csize))
 		return -EINVAL;
+	if (csize >= (1UL << (BITS_PER_BYTE *
+		sizeof(((bitmap_super_t *)0)->chunksize))))
+		return -EOVERFLOW;
 	mddev->bitmap_info.chunksize = csize;
 	return len;
 }
-- 
2.34.1

