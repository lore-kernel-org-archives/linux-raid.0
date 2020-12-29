Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E268AC4332B
	for <linux-raid@archiver.kernel.org>; Tue, 29 Dec 2020 09:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98330207D1
	for <linux-raid@archiver.kernel.org>; Tue, 29 Dec 2020 09:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgL2J3L (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Dec 2020 04:29:11 -0500
Received: from mail.synology.com ([211.23.38.101]:43852 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726156AbgL2J3K (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 29 Dec 2020 04:29:10 -0500
Received: from localhost.localdomain (unknown [10.17.198.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id 553B1CE781AC;
        Tue, 29 Dec 2020 17:21:11 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1609233671; bh=uW8Adw4OvUpDdOcXBQ8eWpTQ3vZt8hQfYkYX0sMcN9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=WjyLSyv1x3fJJQzV+FWwVvw6GU3jkWibYBBjm9PjUJ0OKVWNx+VF+yZXED5FK3bRm
         flgaGcBzEAi257bS/0CdUKgSWkLEfM8iOocZ48B46j8C5Ddekam2JcxhRDeAi857wK
         aJ0IapZ+0OR25ER98oHAfPjYEaDZhlVesWFPlEsA=
From:   dannyshih <dannyshih@synology.com>
To:     axboe@kernel.dk
Cc:     agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        song@kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, Danny Shih <dannyshih@synology.com>
Subject: [PATCH 4/4] md: use submit_bio_noacct_add_head for split bio sending back
Date:   Tue, 29 Dec 2020 17:18:42 +0800
Message-Id: <1609233522-25837-5-git-send-email-dannyshih@synology.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Danny Shih <dannyshih@synology.com>

Use submit_bio_noacct_add_head when sending split bio back to md device.
Otherwise, it might be handled after the lately split bio.

Signed-off-by: Danny Shih <dannyshih@synology.com>
Reviewed-by: Allen Peng <allenpeng@synology.com>
Reviewed-by: Alex Wu <alexwu@synology.com>
---
 drivers/md/md-linear.c | 2 +-
 drivers/md/raid0.c     | 4 ++--
 drivers/md/raid1.c     | 4 ++--
 drivers/md/raid10.c    | 4 ++--
 drivers/md/raid5.c     | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 68cac7d..24418ee 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -243,7 +243,7 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 		struct bio *split = bio_split(bio, end_sector - bio_sector,
 					      GFP_NOIO, &mddev->bio_set);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		submit_bio_noacct_add_head(bio);
 		bio = split;
 	}
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 67f157f..92e82d5 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -447,7 +447,7 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 			zone->zone_end - bio->bi_iter.bi_sector, GFP_NOIO,
 			&mddev->bio_set);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		submit_bio_noacct_add_head(bio);
 		bio = split;
 		end = zone->zone_end;
 	} else
@@ -552,7 +552,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
 					      &mddev->bio_set);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		submit_bio_noacct_add_head(bio);
 		bio = split;
 	}
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c034799..31cec76 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1282,7 +1282,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 		struct bio *split = bio_split(bio, max_sectors,
 					      gfp, &conf->bio_split);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		submit_bio_noacct_add_head(bio);
 		bio = split;
 		r1_bio->master_bio = bio;
 		r1_bio->sectors = max_sectors;
@@ -1453,7 +1453,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		struct bio *split = bio_split(bio, max_sectors,
 					      GFP_NOIO, &conf->bio_split);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		submit_bio_noacct_add_head(bio);
 		bio = split;
 		r1_bio->master_bio = bio;
 		r1_bio->sectors = max_sectors;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c5d88ef..c4dc970 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1177,7 +1177,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 					      gfp, &conf->bio_split);
 		bio_chain(split, bio);
 		allow_barrier(conf);
-		submit_bio_noacct(bio);
+		submit_bio_noacct_add_head(bio);
 		wait_barrier(conf);
 		bio = split;
 		r10_bio->master_bio = bio;
@@ -1460,7 +1460,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 					      GFP_NOIO, &conf->bio_split);
 		bio_chain(split, bio);
 		allow_barrier(conf);
-		submit_bio_noacct(bio);
+		submit_bio_noacct_add_head(bio);
 		wait_barrier(conf);
 		bio = split;
 		r10_bio->master_bio = bio;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3a90cc0..17458ac 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5490,7 +5490,7 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
 		struct r5conf *conf = mddev->private;
 		split = bio_split(raid_bio, sectors, GFP_NOIO, &conf->bio_split);
 		bio_chain(split, raid_bio);
-		submit_bio_noacct(raid_bio);
+		submit_bio_noacct_add_head(raid_bio);
 		raid_bio = split;
 	}
 
-- 
2.7.4

