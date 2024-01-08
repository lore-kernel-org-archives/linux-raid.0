Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507537F
	for <linux-raid@vger.kernel.org>; Mon,  8 Jan 2024 00:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5955a4a9b23so853428eaf.1
        for <linux-raid@vger.kernel.org>; Sun, 07 Jan 2024 16:12:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704672755; x=1705277555;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gJXri0e3igKqedV9MMRSMpuopT6n0gOBX9z+warywek=;
        b=HamtjqfZVGAGL29hC0r25Z/1dN7fyWVNe6YTm6xsFHz7Kozw4i5yDB4bBn18MgUMl3
         vBPCmZozbMerpN/37vgt51uNH7ZOlSdfhyc8mMdiUkPKM8vx0TTirYqkjCLiyoVBW4WE
         WGWuUsPSgXtF3i7ArGetMeaUll6eJtDQuh2FvtFcczzXjXajUfgOblwnjsEnSzvHOidi
         L1H2UxcNUAooRFWKCp4SNMaEh4gMNf3Mlh3GBlGkMZ7TZzHCmyz4ca9jorj0jEHtMBiI
         Mey5tV6Ciy0SF4vIiTM0nJyxbCGckOlNdtsgvmB1xIXf8MwMt14c+Uxco54EwJhJYhY2
         AtkA==
X-Gm-Message-State: AOJu0YzFas2IWjSwlR4RP3BXrXp374kNW3Ek/o40QZWKDf/F5aaPTgd6
	JWVroQtgr0S3YrldK3TDHhY=
X-Google-Smtp-Source: AGHT+IF7Xi19m6Sy9kr8Mw7VzbIPAObGDb+4AEIfIh8FINbNRxsXmJYWkp2mUqHlTbsy+7oNqbGwLw==
X-Received: by 2002:a05:6358:880a:b0:175:43ba:2f36 with SMTP id hv10-20020a056358880a00b0017543ba2f36mr1172247rwb.42.1704672755042;
        Sun, 07 Jan 2024 16:12:35 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4d7e:54f3:667:4981:ffa1:7be1])
        by smtp.gmail.com with ESMTPSA id mm11-20020a17090b358b00b0028ad32914basm5084033pjb.41.2024.01.07.16.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jan 2024 16:12:34 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] md/raid1: Use blk_opf_t for read and write operations
Date: Sun,  7 Jan 2024 16:12:23 -0800
Message-ID: <20240108001223.23835-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the type blk_opf_t for read and write operations instead of int. This
patch does not affect the generated code but fixes the following sparse
warning:

drivers/md/raid1.c:1993:60: sparse: sparse: incorrect type in argument 5 (different base types)
     expected restricted blk_opf_t [usertype] opf
     got int rw

Cc: Song Liu <song@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Fixes: 3c5e514db58f ("md/raid1: Use the new blk_opf_t type")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401080657.UjFnvQgX-lkp@intel.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/md/raid1.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 35d12948e0a9..e138922d5129 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1984,12 +1984,12 @@ static void end_sync_write(struct bio *bio)
 }
 
 static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
-			   int sectors, struct page *page, int rw)
+			   int sectors, struct page *page, blk_opf_t rw)
 {
 	if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
 		/* success */
 		return 1;
-	if (rw == WRITE) {
+	if (rw == REQ_OP_WRITE) {
 		set_bit(WriteErrorSeen, &rdev->flags);
 		if (!test_and_set_bit(WantReplacement,
 				      &rdev->flags))
@@ -2106,7 +2106,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			rdev = conf->mirrors[d].rdev;
 			if (r1_sync_page_io(rdev, sect, s,
 					    pages[idx],
-					    WRITE) == 0) {
+					    REQ_OP_WRITE) == 0) {
 				r1_bio->bios[d]->bi_end_io = NULL;
 				rdev_dec_pending(rdev, mddev);
 			}
@@ -2121,7 +2121,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			rdev = conf->mirrors[d].rdev;
 			if (r1_sync_page_io(rdev, sect, s,
 					    pages[idx],
-					    READ) != 0)
+					    REQ_OP_READ) != 0)
 				atomic_add(s, &rdev->corrected_errors);
 		}
 		sectors -= s;
@@ -2333,7 +2333,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 				atomic_inc(&rdev->nr_pending);
 				rcu_read_unlock();
 				r1_sync_page_io(rdev, sect, s,
-						conf->tmppage, WRITE);
+						conf->tmppage, REQ_OP_WRITE);
 				rdev_dec_pending(rdev, mddev);
 			} else
 				rcu_read_unlock();
@@ -2350,7 +2350,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 				atomic_inc(&rdev->nr_pending);
 				rcu_read_unlock();
 				if (r1_sync_page_io(rdev, sect, s,
-						    conf->tmppage, READ)) {
+						conf->tmppage, REQ_OP_READ)) {
 					atomic_add(s, &rdev->corrected_errors);
 					pr_info("md/raid1:%s: read error corrected (%d sectors at %llu on %pg)\n",
 						mdname(mddev), s,
