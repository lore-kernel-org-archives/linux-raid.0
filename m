Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B49AC04FE2
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 09:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbjHNJ2l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 05:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236452AbjHNJ2F (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 05:28:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5151CE75
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 02:27:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 37EF621906;
        Mon, 14 Aug 2023 09:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1692005241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NapONduoTTBhZAT+XHnfyYS1nrEB+YxU/de20eZWWhg=;
        b=2E5v7YOV12Xh8nyiBa7Ip+/g7JkkQYF7woe9ur9m1HdsWlyQt8khAOOyEayOhjbGkYVvZl
        GNt+fc57hKZbH+MPn57NQtyU+NYufPlcLbCuG3XwheXJq/JTA0Qxap1N7LDLW57rJkevr9
        saqcNiuyp23z7YCDcEVNWGiu6KaE1AQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1692005241;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NapONduoTTBhZAT+XHnfyYS1nrEB+YxU/de20eZWWhg=;
        b=QHImZQycckvgBDUSc4s9I+frx8JHhXdixjBhZoGGhS039by9O9M81QSNQ2UmyuCZoo29DE
        /Owjg95uK467pcDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 29913138E2;
        Mon, 14 Aug 2023 09:27:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ruYgCnnz2WRLbAAAMHmgww
        (envelope-from <jack@suse.cz>); Mon, 14 Aug 2023 09:27:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 711EEA0774; Mon, 14 Aug 2023 11:27:20 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] md/raid0: Factor out helper for mapping and submitting a bio
Date:   Mon, 14 Aug 2023 11:27:07 +0200
Message-Id: <20230814092720.3931-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230814091452.9670-1-jack@suse.cz>
References: <20230814091452.9670-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3655; i=jack@suse.cz; h=from:subject; bh=Do7huDqgYYYHs3wgoVCa+NOnb6lPBDUHVhTZ2H9Hfcc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBk2fNqodC0uUXvpAZ59FCrYXOW2PT3w8xVXFDAewpy 9Ty6RNWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZNnzagAKCRCcnaoHP2RA2Wh3B/ 4u2zXSwQJAkAWRuAfvZzlo6mgUo8y9O6fh8dHHnmqi+D9wNkfmZfMQHG2mnitQHSrG+xDhpvjIB0KC h4laW8peGR7BD+w1SwwfwVM0B3YLfWY4AY6+xZI1nKuRbVibMnB8oDH86yJCv+uw/1BlBTpDVADSIp cngQRDfssb8bfwG2J8lRxQd/nIehRdSn281EJ2oK2giaIuboQpn04jvj/0PewJTR5S7TEA+WIFaCZ3 onk3Lct61L5FGSo2sT9kh1BSm923uidZfU+83uXsL+IJvi1cwu+JlicNnt7SgBoPDG8G3snWeBLZ9d vuHUVaZYmcto9reqYC9WNPF5znEJ5u
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Factor out helper function for mapping and submitting a bio out of
raid0_make_request(). We will use it later for submitting both parts of
a split bio.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/md/raid0.c | 79 +++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d1ac73fcd852..d3c55f2e9b18 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -557,54 +557,21 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 	bio_endio(bio);
 }
 
-static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
+static void raid0_map_submit_bio(struct mddev *mddev, struct bio *bio)
 {
 	struct r0conf *conf = mddev->private;
 	struct strip_zone *zone;
 	struct md_rdev *tmp_dev;
-	sector_t bio_sector;
-	sector_t sector;
-	sector_t orig_sector;
-	unsigned chunk_sects;
-	unsigned sectors;
-
-	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
-	    && md_flush_request(mddev, bio))
-		return true;
-
-	if (unlikely((bio_op(bio) == REQ_OP_DISCARD))) {
-		raid0_handle_discard(mddev, bio);
-		return true;
-	}
-
-	bio_sector = bio->bi_iter.bi_sector;
-	sector = bio_sector;
-	chunk_sects = mddev->chunk_sectors;
-
-	sectors = chunk_sects -
-		(likely(is_power_of_2(chunk_sects))
-		 ? (sector & (chunk_sects-1))
-		 : sector_div(sector, chunk_sects));
-
-	/* Restore due to sector_div */
-	sector = bio_sector;
-
-	if (sectors < bio_sectors(bio)) {
-		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
-					      &mddev->bio_set);
-		bio_chain(split, bio);
-		submit_bio_noacct(bio);
-		bio = split;
-	}
+	sector_t bio_sector = bio->bi_iter.bi_sector;
+	sector_t sector = bio_sector;
 
 	if (bio->bi_pool != &mddev->bio_set)
 		md_account_bio(mddev, &bio);
 
-	orig_sector = sector;
 	zone = find_zone(mddev->private, &sector);
 	switch (conf->layout) {
 	case RAID0_ORIG_LAYOUT:
-		tmp_dev = map_sector(mddev, zone, orig_sector, &sector);
+		tmp_dev = map_sector(mddev, zone, bio_sector, &sector);
 		break;
 	case RAID0_ALT_MULTIZONE_LAYOUT:
 		tmp_dev = map_sector(mddev, zone, sector, &sector);
@@ -612,13 +579,13 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 	default:
 		WARN(1, "md/raid0:%s: Invalid layout\n", mdname(mddev));
 		bio_io_error(bio);
-		return true;
+		return;
 	}
 
 	if (unlikely(is_rdev_broken(tmp_dev))) {
 		bio_io_error(bio);
 		md_error(mddev, tmp_dev);
-		return true;
+		return;
 	}
 
 	bio_set_dev(bio, tmp_dev->bdev);
@@ -630,6 +597,40 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 				      bio_sector);
 	mddev_check_write_zeroes(mddev, bio);
 	submit_bio_noacct(bio);
+}
+
+static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
+{
+	sector_t sector;
+	unsigned chunk_sects;
+	unsigned sectors;
+
+	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
+	    && md_flush_request(mddev, bio))
+		return true;
+
+	if (unlikely((bio_op(bio) == REQ_OP_DISCARD))) {
+		raid0_handle_discard(mddev, bio);
+		return true;
+	}
+
+	sector = bio->bi_iter.bi_sector;
+	chunk_sects = mddev->chunk_sectors;
+
+	sectors = chunk_sects -
+		(likely(is_power_of_2(chunk_sects))
+		 ? (sector & (chunk_sects-1))
+		 : sector_div(sector, chunk_sects));
+
+	if (sectors < bio_sectors(bio)) {
+		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
+					      &mddev->bio_set);
+		bio_chain(split, bio);
+		submit_bio_noacct(bio);
+		bio = split;
+	}
+
+	raid0_map_submit_bio(mddev, bio);
 	return true;
 }
 
-- 
2.35.3

