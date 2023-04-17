Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E29F5C77B76
	for <linux-raid@archiver.kernel.org>; Mon, 17 Apr 2023 17:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjDQRPp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 Apr 2023 13:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjDQRPo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 17 Apr 2023 13:15:44 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C69F2
        for <linux-raid@vger.kernel.org>; Mon, 17 Apr 2023 10:15:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 799091F45F;
        Mon, 17 Apr 2023 17:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681751741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=S6r+mFXXb/hPTl5jC+sCdii9jOeQB+lBC2phA6Blo88=;
        b=GaYaqLwiKPHfopDcdtJ8t7UyZJ4mrz8eHBrLLoPdwQKlOkS3iC0YHhKgfFxB/K5rpxRE6W
        gdfjuThhlpgs3tXn8LaisQZryqAcXSpuj6erfDMKpB1Bm6mluSDZi4HwgKgNyagxY029p+
        binduINQXXE+/Q0z/DS44cPgPDDILII=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681751741;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=S6r+mFXXb/hPTl5jC+sCdii9jOeQB+lBC2phA6Blo88=;
        b=/QNW/5UxgP7fGogxVlT1nMDSeNAlqtg4zHLBVtePez6D+ZQoDsXsnnAxZOXqxNdmi237cI
        rJaCkGwhLZNhbmAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6929B1390E;
        Mon, 17 Apr 2023 17:15:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3sefGb1+PWRxbgAAMHmgww
        (envelope-from <jack@suse.cz>); Mon, 17 Apr 2023 17:15:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id D1551A0735; Mon, 17 Apr 2023 19:15:40 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     linux-raid@vger.kernel.org
Cc:     Song Liu <song@kernel.org>, Logan Gunthorpe <logang@deltatee.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH] md/raid5: Improve performance for sequential IO
Date:   Mon, 17 Apr 2023 19:15:37 +0200
Message-Id: <20230417171537.17899-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4386; i=jack@suse.cz; h=from:subject; bh=KyZZjA5JaC+xLX9HRT81XUFXzRgdpMkfubmuA/H8f58=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBkPX6jEb3ab2t26dTWM15zkPg0WeKEXFV0DSAujpJj GZvecwOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZD1+owAKCRCcnaoHP2RA2eWrCA DTKbO83upKVGD9od92Za4Gvyxx9s7FBxOfgzhpbIN8CwjH6mRZ0egmjeayFnjOWJpG8lDId1U113h1 l/Zr+WxgHp2kdZhL85uGywe0JqfaT5LxGyv0kySni5FGUM6aMnPyBXxvWT5JahPePvApsPzrhdrRhl mCj3LoAZAOQINNB8oQYxT2Q/7NM+AXN3DSw9U682rJyWNwYGaDVOTGIW1tg5eAmWSFKEKnsdQXUJFr 43gLShgqzCd0y2KJYUCbvt7m424w1FkSjAi0PhTbqKaA2YCVYoZj4gnOYaLAJSBbKLJua+3RWFDyj7 huYfulsD+pPUDqlBjBJyMjdshbyjVK
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Commit 7e55c60acfbb ("md/raid5: Pivot raid5_make_request()") changed the
order in which requests for underlying disks are created. Since for
large sequential IO adding of requests frequently races with md_raid5
thread submitting bios to underlying disks, this results in a change in
IO pattern because intermediate states of new order of request creation
result in more smaller discontiguous requests. For RAID5 on top of three
rotational disks our performance testing revealed this results in
regression in write throughput:

iozone -a -s 131072000 -y 4 -q 8 -i 0 -i 1 -R

before 7e55c60acfbb:
              KB  reclen   write rewrite    read    reread
       131072000       4  493670  525964   524575   513384
       131072000       8  540467  532880   512028   513703

after 7e55c60acfbb:
              KB  reclen   write rewrite    read    reread
       131072000       4  421785  456184   531278   509248
       131072000       8  459283  456354   528449   543834

To reduce the amount of discontiguous requests we can start generating
requests with the stripe with the lowest chunk offset as that has the
best chance of being adjacent to IO queued previously. This improves the
performance to:
              KB  reclen   write rewrite    read    reread
       131072000       4  497682  506317   518043   514559
       131072000       8  514048  501886   506453   504319

restoring big part of the regression.

Fixes: 7e55c60acfbb ("md/raid5: Pivot raid5_make_request()")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/md/raid5.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

I'm by no means raid5 expert but this is what I was able to come up with. Any
opinion or ideas how to fix the problem in a better way?

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7b820b81d8c2..f787c9e5b10e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6079,6 +6079,38 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 	return ret;
 }
 
+/*
+ * If the bio covers multiple data disks, find sector within the bio that has
+ * the lowest chunk offset in the first chunk.
+ */
+static sector_t raid5_bio_lowest_chunk_sector(struct r5conf *conf,
+					      struct bio *bi)
+{
+	int sectors_per_chunk = conf->chunk_sectors;
+	int raid_disks = conf->raid_disks;
+	int dd_idx;
+	struct stripe_head sh;
+	unsigned int chunk_offset;
+	sector_t r_sector = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
+	sector_t sector;
+
+	/* We pass in fake stripe_head to get back parity disk numbers */
+	sector = raid5_compute_sector(conf, r_sector, 0, &dd_idx, &sh);
+	chunk_offset = sector_div(sector, sectors_per_chunk);
+	if (sectors_per_chunk - chunk_offset >= bio_sectors(bi))
+		return r_sector;
+	/*
+	 * Bio crosses to the next data disk. Check whether it's in the same
+	 * chunk.
+	 */
+	dd_idx++;
+	while (dd_idx == sh.pd_idx || dd_idx == sh.qd_idx)
+		dd_idx++;
+	if (dd_idx >= raid_disks)
+		return r_sector;
+	return r_sector + sectors_per_chunk - chunk_offset;
+}
+
 static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
@@ -6150,6 +6182,17 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	}
 	md_account_bio(mddev, &bi);
 
+	/*
+	 * Lets start with the stripe with the lowest chunk offset in the first
+	 * chunk. That has the best chances of creating IOs adjacent to
+	 * previous IOs in case of sequential IO and thus creates the most
+	 * sequential IO pattern. We don't bother with the optimization when
+	 * reshaping as the performance benefit is not worth the complexity.
+	 */
+	if (likely(conf->reshape_progress == MaxSector))
+		logical_sector = raid5_bio_lowest_chunk_sector(conf, bi);
+	s = (logical_sector - ctx.first_sector) >> RAID5_STRIPE_SHIFT(conf);
+
 	add_wait_queue(&conf->wait_for_overlap, &wait);
 	while (1) {
 		res = make_stripe_request(mddev, conf, &ctx, logical_sector,
@@ -6178,7 +6221,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 			continue;
 		}
 
-		s = find_first_bit(ctx.sectors_to_do, stripe_cnt);
+		s = find_next_bit_wrap(ctx.sectors_to_do, stripe_cnt, s);
 		if (s == stripe_cnt)
 			break;
 
-- 
2.35.3

