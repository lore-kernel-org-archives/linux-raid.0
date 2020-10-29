Return-Path: <SRS0=2a2u=EE=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6251AC4742C
	for <linux-raid@archiver.kernel.org>; Thu, 29 Oct 2020 20:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00F3D20639
	for <linux-raid@archiver.kernel.org>; Thu, 29 Oct 2020 20:19:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=drivescale-com.20150623.gappssmtp.com header.i=@drivescale-com.20150623.gappssmtp.com header.b="papIqcpj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgJ2UTm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Oct 2020 16:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgJ2UT2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Oct 2020 16:19:28 -0400
Received: from mail-vs1-xe64.google.com (mail-vs1-xe64.google.com [IPv6:2607:f8b0:4864:20::e64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193F7C0613D5
        for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2020 13:19:28 -0700 (PDT)
Received: by mail-vs1-xe64.google.com with SMTP id h5so2259785vsp.3
        for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2020 13:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=drivescale-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ecgbskNC7kILn/M09bb6Zbg3H3gdB6NlCB1yWqgqIY0=;
        b=papIqcpjLky53BkcAr0vNEue9c3X0epiXTPDnEezKpkjcUvZ6pU9D7Hnuuv37igCUe
         9PoYKhYCasL9FJlFbYxoPrpg0N7Serlb50COi0aGgtkuZdGqgw3k95FuJ3n3TNrx5vPD
         tJtlWxv5YOmy2vTGtdrEPI2AnAwwOCqjuX+Z8K7LgXdC7diQQX3jV/AoT/IJK/ZQDZlV
         Vw/zQDYIgAxebh28eK2pPAC9Y1Z8d+D6/JiqqaTMDZi4V5aXUlRZtdQSM3L+PCB++nRl
         Hek1eCzVxW9jak60aeM+q8xpS53WsaT1QOoo6ba35KniC4cgPbB2HwnQZ2RpCS8xIVqn
         Kxlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ecgbskNC7kILn/M09bb6Zbg3H3gdB6NlCB1yWqgqIY0=;
        b=SIi51e2pV6LTJNAJ6dKrka1qFs6crRaZv0bweV/cjJx6iFDzlqzShKtsmpndJy+MVk
         MCgQV+T8DasbYLc7/J8LMgJkqfcOkuitGqiMeC/z2/bjVxwrQbPSKjQrAWQtAYLIqUXW
         uwdoitxSg5zBaaIoBXld5yAHhMvn++e87VFIBenFgLneZG1z5OiU8zupcHZFrc0DE381
         7xJ+iUfC7SZB0SB/05Ky1lvKSRIQ4ugFaCFBNg6EzEmOy/ewbYwCRFEg17ssfkOjyZhk
         PU7hD+gGMi2LJ0XczJATGiPEHAouAQUAxS8SO2NWGTWVnvh6CX6me9+12W25vyHlipS9
         st1A==
X-Gm-Message-State: AOAM5330xYCLbEgR5tqD+KhFrYs4oeRcOlf94hL00Z608Sn/dKzXAxRV
        oQ0nYH5ZLlu5OL5hfyf+RjFCusv+AUTJWx8xVcvjBe6RkCu4tg==
X-Google-Smtp-Source: ABdhPJzNbYShm4bs3P7IxFz7bbIzREFpJ8XA8MNUwjuxt332v4XXjf9qW1L98vuwfW6ML5FghnMLi6Ip8uZo
X-Received: by 2002:a67:f657:: with SMTP id u23mr4986044vso.50.1604002767125;
        Thu, 29 Oct 2020 13:19:27 -0700 (PDT)
Received: from dcs.hq.drivescale.com ([68.74.115.3])
        by smtp-relay.gmail.com with ESMTP id a6sm602460vkl.11.2020.10.29.13.19.26;
        Thu, 29 Oct 2020 13:19:27 -0700 (PDT)
X-Relaying-Domain: drivescale.com
Received: from localhost.localdomain (gw1-dc.hq.drivescale.com [192.168.33.175])
        by dcs.hq.drivescale.com (Postfix) with ESMTP id 2E7D44210A;
        Thu, 29 Oct 2020 20:19:26 +0000 (UTC)
From:   Christopher Unkel <cunkel@drivescale.com>
To:     linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Christopher Unkel <cunkel@drivescale.com>
Subject: [PATCH 2/3] md: align superblock writes to physical blocks
Date:   Thu, 29 Oct 2020 13:13:57 -0700
Message-Id: <20201029201358.29181-3-cunkel@drivescale.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201029201358.29181-1-cunkel@drivescale.com>
References: <20201029201358.29181-1-cunkel@drivescale.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Writes of the md superblock are aligned to the logical blocks of the
containing device, but no attempt is made to align them to physical
block boundaries.  This means that on a "512e" device (4k physical, 512
logical) every superblock update hits the 512-byte emulation and the
possible associated performance penalty.

Respect the physical block alignment when possible, that is, when the
write padded out to the physical block doesn't run into the data or
bitmap.

Signed-off-by: Christopher Unkel <cunkel@drivescale.com>
---
This series replaces the first patch of the previous series
(https://lkml.org/lkml/2020/10/22/1058), with the following changes:

1. Creates a helper function super_1_sb_length_ok().
2. Fixes operator placement style violation.
3. Covers case in super_1_sync().
4. Refactors duplicate logic.
5. Covers a case in existing code where aligned superblock could
   run into bitmap.

 drivers/md/md.c | 45 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d6a55ca1d52e..802a9a256fe5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1646,15 +1646,52 @@ static __le32 calc_sb_1_csum(struct mdp_superblock_1 *sb)
 	return cpu_to_le32(csum);
 }
 
+static int
+super_1_sb_length_ok(struct md_rdev *rdev, int minor_version, int sb_len)
+{
+	int sectors = sb_len / 512;
+	struct mdp_superblock_1 *sb;
+
+	/* superblock is stored in memory as a single page */
+	if (sb_len > PAGE_SIZE)
+		return 0;
+
+	/* check if sb runs into data */
+	if (minor_version) {
+		if (rdev->sb_start + sectors > rdev->data_offset
+		    || rdev->sb_start + sectors > rdev->new_data_offset)
+			return 0;
+	} else if (sb_len > 4096)
+		return 0;
+
+	/* check if sb runs into bitmap */
+	sb = page_address(rdev->sb_page);
+	if (le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET) {
+		__s32 bitmap_offset = (__s32)le32_to_cpu(sb->bitmap_offset);
+		if (bitmap_offset > 0 && sectors > bitmap_offset)
+			return 0;
+	}
+
+	return 1;
+}
+
 /*
  * set rdev->sb_size to that required for number of devices in array
  * with appropriate padding to underlying sectors
  */
 static void
-super_1_set_rdev_sb_size(struct md_rdev *rdev, int max_dev)
+super_1_set_rdev_sb_size(struct md_rdev *rdev, int max_dev, int minor_version)
 {
 	int sb_size = max_dev * 2 + 256;
-	rdev->sb_size = round_up(sb_size, bdev_logical_block_size(rdev->bdev));
+	int pb_aligned_size = round_up(sb_size,
+				       bdev_physical_block_size(rdev->bdev));
+
+	/* generate physical-block aligned writes if legal */
+	if (super_1_sb_length_ok(rdev, minor_version, pb_aligned_size))
+		rdev->sb_size = pb_aligned_size;
+	else
+		rdev->sb_size = round_up(sb_size,
+					 bdev_logical_block_size(rdev->bdev));
 }
 
 static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_version)
@@ -1730,7 +1767,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		rdev->new_data_offset += (s32)le32_to_cpu(sb->new_offset);
 	atomic_set(&rdev->corrected_errors, le32_to_cpu(sb->cnt_corrected_read));
 
-	super_1_set_rdev_sb_size(rdev, le32_to_cpu(sb->max_dev));
+	super_1_set_rdev_sb_size(rdev, le32_to_cpu(sb->max_dev), minor_version);
 
 	if (minor_version
 	    && rdev->data_offset < sb_start + (rdev->sb_size/512))
@@ -2140,7 +2177,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 
 	if (max_dev > le32_to_cpu(sb->max_dev)) {
 		sb->max_dev = cpu_to_le32(max_dev);
-		super_1_set_rdev_sb_size(rdev, max_dev);
+		super_1_set_rdev_sb_size(rdev, max_dev, mddev->minor_version);
 	} else
 		max_dev = le32_to_cpu(sb->max_dev);
 
-- 
2.17.1

