Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF3810F7;
	Thu, 21 Dec 2023 01:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6Y59PIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA854C433C8;
	Thu, 21 Dec 2023 01:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703122066;
	bh=TgGPuVNkTVJBeSz3CRaPkkdMlpGg5Rk9X00t8GA+alA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6Y59PIzrQL9Z77+QxgwL5oEqEYnx319xp9JfZGLSmHW4Z0MLWhU7Rf04o+iGj3cE
	 H9CoS2DyJQiPnjrQUwV8+6P54TZfHnPZoaroclJUJd8PzxER1/hzHlK7ELS8KWGjpI
	 PGIvieGnxqkEWNUgRuOotmV2k6u0lsrEXA3xZ/EjEU2zmBZMfGl0YYp+4dugGeogvt
	 mcuwrFMRtrYs+ODbnvLdxToDAmWVRgBDuRandzZCIE375g8tT8FxGmTrK4/fyXoObj
	 BomfI59SDqkxN7TswJ/707ohii0F7Y27EORZ8smrmE5Lr7Gn9o7PSV+4wUBWuUW55a
	 xcKzJrWtq8imQ==
From: Song Liu <song@kernel.org>
To: linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: axboe@kernel.dk,
	kent.overstreet@linux.dev,
	janpieter.sollie@edpnet.be,
	colyli@suse.de,
	bagasdotme@gmail.com,
	Song Liu <song@kernel.org>
Subject: [PATCH 2/2] md: Use op_is_flush() to check flush bio
Date: Wed, 20 Dec 2023 17:27:15 -0800
Message-Id: <20231221012715.3048221-3-song@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231221012715.3048221-1-song@kernel.org>
References: <20231221012715.3048221-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

op_is_flush() covers different ways to request flush. Use it instead of
simply checking against REQ_PREFLUSH.

Signed-off-by: Song Liu <song@kernel.org>
---
 drivers/md/raid0.c  | 2 +-
 drivers/md/raid1.c  | 2 +-
 drivers/md/raid10.c | 2 +-
 drivers/md/raid5.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c50a7abda744..20283dc5208a 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -592,7 +592,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 	unsigned chunk_sects;
 	unsigned sectors;
 
-	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
+	if (unlikely(op_is_flush(bio->bi_opf))
 	    && md_flush_request(mddev, bio))
 		return true;
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index aaa434f0c175..5c1dadd7fbb6 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1581,7 +1581,7 @@ static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
 {
 	sector_t sectors;
 
-	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
+	if (unlikely(op_is_flush(bio->bi_opf))
 	    && md_flush_request(mddev, bio))
 		return true;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7412066ea22c..5c6e0a8635f2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1857,7 +1857,7 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 	int chunk_sects = chunk_mask + 1;
 	int sectors = bio_sectors(bio);
 
-	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
+	if (unlikely(op_is_flush(bio->bi_opf))
 	    && md_flush_request(mddev, bio))
 		return true;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e57deb1c6138..1bcf96b490a7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6070,7 +6070,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	enum stripe_result res;
 	int s, stripe_cnt;
 
-	if (unlikely(bi->bi_opf & REQ_PREFLUSH)) {
+	if (unlikely(op_is_flush(bi->bi_opf))) {
 		int ret = log_handle_flush_request(conf, bi);
 
 		if (ret == 0)
-- 
2.34.1

