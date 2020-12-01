Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9FFC64E7A
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 16:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F1802151B
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 16:55:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kSCb3iz/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390143AbgLAQzN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728700AbgLAQzM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Dec 2020 11:55:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48605C0613D6;
        Tue,  1 Dec 2020 08:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=7J4rGyUG9y14eZzS0se+mu5OZ7ds3yzQqQXlGg9B2To=; b=kSCb3iz/aaY211aN36XgaF3D/l
        uw1zxMNz43dK86G5rmdvhfGoHItFi4SNMzaea6tf7++FsqntOMYZFRe1rolT0mm7NpIUeZjSxK060
        PyuoYvk9+7VEhJBwfY7GBiPc2aBUIuZ07hpTNX7eeI7Cwkp9pA06o2oNdVaYIyICottQj4GSEAzyI
        dwnM+xpaQKVOHc3SrzLpp4UTQOE+dqBvI3Bs4LicYubHD1U1s/SfgXkOA6VfBk7OX4R4phl3gvxtN
        B6Gy3eXLnYIN+ZsokzOWwnvLhvqElO1NZXACE9pNcegBP2BO5Vk7uuxPmxN9wf3lv/vd9vaJooomi
        OjzVqZww==;
Received: from [2001:4bb8:184:6389:bbd8:a1c2:99e0:f58a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk8v4-0005Yr-NF; Tue, 01 Dec 2020 16:54:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 1/9] brd: remove the end of device check in brd_do_bvec
Date:   Tue,  1 Dec 2020 17:54:16 +0100
Message-Id: <20201201165424.2030647-2-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201165424.2030647-1-hch@lst.de>
References: <20201201165424.2030647-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The block layer already checks for this conditions in bio_check_eod
before calling the driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/brd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index c43a6ab4b1f39f..c7c8214190795c 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -285,14 +285,10 @@ static int brd_do_bvec(struct brd_device *brd, struct page *page,
 static blk_qc_t brd_submit_bio(struct bio *bio)
 {
 	struct brd_device *brd = bio->bi_disk->private_data;
+	sector_t sector = bio->bi_iter.bi_sector;
 	struct bio_vec bvec;
-	sector_t sector;
 	struct bvec_iter iter;
 
-	sector = bio->bi_iter.bi_sector;
-	if (bio_end_sector(bio) > get_capacity(bio->bi_disk))
-		goto io_error;
-
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 		int err;
-- 
2.29.2

