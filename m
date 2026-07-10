Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18940405C45
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 10:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783678587; cv=none; b=q+qCTInDFn+VaJLOU6Gx8qDu6C//oyyYLzrICzyBRJ/TYZvj5jFQGsMYavrmPqY0zeGohdQCYY3+wy9g3FcfpCD12X9XhkSRHaoAvr0eYgv7O9x4P/zae6lSRPxeoW7EVoM3dhdHXhWlVV2OhGEZur4GmRahnzlR+ISHzc8a7IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783678587; c=relaxed/simple;
	bh=vpWol1tRmIS2LWSbAfl0XKPRYz2NlD0X6ph51kt02us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvGzkShmLEOyt1JYVU+WpQs4vHi3xtMv3ZOiqd+pgn0gOOVm3+UjgP7InO/CxCaXYb/tbRdYEx7wjQydciRuQzW/En5EeJjzUZwg4VDEPScmZSz/1FO9XdlPe0wH9kNGxD3iNlch6qnlQH5s4CqFc+4erx/CXwR7QI0SLVquEDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yaha3uo8; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yaha3uo8"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493f6de72faso757605e9.0
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 03:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783678580; x=1784283380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bSeLDzEoDs8fRhcqQi+T9x/Op3hPFFXdqP0g91gxk84=;
        b=Yaha3uo8JqBWYSwHYGluYluWDXji5sbgpoiP37M4wqlTr+p4S3IXrh8Sj/xwvPEWwi
         z4oFH5Yu99ZOKZhfsMPIbKIsjVRrizIORv4E3rCodK9GGZ/ZdgZhLjj/zO6lku4nnilQ
         bc+eqISf9VphyPilvi+lES9mNf1Y2hX1a8eotaHj9XatxbS0Ed4EmotIef2zMAaa/Q5L
         ypV4rDnN1xROPOrSh86w2QR2I3mvKxFDw89vxNZ3JnF/7233EIwV559MOnVcJwdHb45z
         X+i474hF0qQWnK0XgQo1rKaubIHg1+SmjI01kJEywwjLT7nLuVOugAMJfZyC/jPxq9H1
         MVnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783678580; x=1784283380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bSeLDzEoDs8fRhcqQi+T9x/Op3hPFFXdqP0g91gxk84=;
        b=F8ES+HgE/5ZBLH+vAWqwfzlemreA9bPsIU7wC/3YGrNFDGyqgiw7F7BdCmVy5/CdO3
         4HmepZ26Vifjhqrou2PY0UC022JBj6N54gJgz4RlaDdudD3Zoqy3ZylITSnn6QmJboro
         nztorfnjkO+8VOOPY5r9NoxRe3zYRsyN7q1kolglDXRzryDh7bh0G0RJUJM0bVPrGC66
         MsZXttamCq9UGMB7hkAFsN3OJXAJ4CxE6+oIUAU2chB4OHshTB2jaACW/L5Ylmo4aPrl
         e5xYAjlqSIKAIYSGrvXsPphcH4X8xKr455wQYeolK9C43Pt2EzndI1QEsB8IfdrfBL3X
         66ZA==
X-Gm-Message-State: AOJu0YxPdHnsKekSOyKzWg4bL7q7ai/9wwISLc/nddWQQ22Tne9w4Rjk
	rcuzY+jVGTp+6q8YeFMcFww6GiJ57qcGYMoA4E0ZFmHHs5v8Ey3ONAu6
X-Gm-Gg: AfdE7ck54pbdLKOj1qoabm9XL0H+Lms+wP+0FFE5xqSz3V2lsAq23qiiAgDDEfOkNwP
	swvG21vYXrZiK6U3empLM+yv1SSUOWud1wyANrortLl5mmmAbyCDs9fh9vnpVS9i2vOnGc9rFeg
	rTKYpy3rXGZSaOG+6nTXXJyfEptexDEbZAfryOmv5K9IUoEfYhOC+Ier4ctSgGhEgIV+3aFW9XD
	JjEcw8KwKLfpjemgVyKFEL78CGNh3JJgDCAXdyJYSS6d0sgRXzRecX5vlX7AvneFn82MmWR75Ru
	NkzrBcqWBye2TJfFCt+GHlKpu3IM4niM3Wk+C7KMZYZmFKGIlvPe0CFRLOJk/l1hp+YdIs05blU
	fmeYySf+ygV0vLwjPLoFxg2HIcMNP7OpKmNDTcArF+uwPC1j8seBR9uvzybce1uNWD8IdKJ3VVU
	8gqEeOGZHc4sOFjh80gNJOixhCj9BKC7GjccGwa3RSmUkPntvcONETwmnFdm1UKV3lDkif2FUJd
	o0=
X-Received: by 2002:a05:600c:46cd:b0:492:6f5c:fd8c with SMTP id 5b1f17b1804b1-493f2b3fedcmr26876775e9.15.1783678580171;
        Fri, 10 Jul 2026 03:16:20 -0700 (PDT)
Received: from yocto.. (dynamic-176-007-199-185.176.7.pool.telefonica.de. [176.7.199.185])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb670a41sm123554875e9.0.2026.07.10.03.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 03:16:18 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	vverma@digitalocean.com,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	abd.masalkhi@gmail.com,
	linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Subject: [PATCH v4 7/7] md/raid10: simplify read request error handling
Date: Fri, 10 Jul 2026 10:15:21 +0000
Message-ID: <20260710101521.1714-8-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710101521.1714-1-abd.masalkhi@gmail.com>
References: <20260710101521.1714-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid10_read_request() currently handles bio completion, barrier
handling, and r10_bio lifetime management in several different error
paths. This results in duplicated cleanup logic and increases the risk
of introducing bugs in future modifications.

Make raid10_read_request() return a status to its callers, consolidate
the read error paths, and free r10_bio from a single location in the
callers. Since the callers allocate r10_bio, they should also be
responsible for freeing it when the request fails.

This makes the read path follow the same ownership model as the write
path and simplifies the error handling flow.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v4:
 - No changes.
 - Link to v3: https://lore.kernel.org/linux-raid/20260708101341.473750-8-abd.masalkhi@gmail.com/

Changes in v3:
 - No changes.
 - Link to v2: https://lore.kernel.org/linux-raid/20260628142420.1051027-8-abd.masalkhi@gmail.com/

Changes in v2:
 - Fix a compilation error (bi -> bio).
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-8-abd.masalkhi@gmail.com/
---
 drivers/md/raid10.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d94c1f28a6f6..01162c483644 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1143,7 +1143,7 @@ static bool regular_request_wait(struct mddev *mddev, struct r10conf *conf,
 	return true;
 }
 
-static void raid10_read_request(struct mddev *mddev, struct bio *bio,
+static bool raid10_read_request(struct mddev *mddev, struct bio *bio,
 				struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
@@ -1191,8 +1191,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 
 	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
 		bio_wouldblock_error(bio);
-		free_r10bio(r10_bio);
-		return;
+		return false;
 	}
 
 	rdev = read_balance(conf, r10_bio, &max_sectors);
@@ -1202,8 +1201,8 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 					    mdname(mddev), b,
 					    (unsigned long long)r10_bio->sector);
 		}
-		raid_end_bio_io(r10_bio);
-		return;
+		bio_io_error(bio);
+		goto err_allow_barrier;
 	}
 	if (err_rdev)
 		pr_err_ratelimited("md/raid10:%s: %pg: redirecting sector %llu to another mirror\n",
@@ -1215,10 +1214,8 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		bio = bio_submit_split_bioset(bio, max_sectors,
 					      &conf->bio_split);
 		wait_barrier(conf, false);
-		if (!bio) {
-			set_bit(R10BIO_Returned, &r10_bio->state);
-			goto err_handle;
-		}
+		if (!bio)
+			goto err_dec_pending;
 
 		r10_bio->master_bio = bio;
 		r10_bio->sectors = max_sectors;
@@ -1244,10 +1241,16 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_private = r10_bio;
 	mddev_trace_remap(mddev, read_bio, r10_bio->sector);
 	submit_bio_noacct(read_bio);
-	return;
-err_handle:
+
+	return true;
+
+err_dec_pending:
 	atomic_dec(&rdev->nr_pending);
-	raid_end_bio_io(r10_bio);
+
+err_allow_barrier:
+	allow_barrier(conf);
+
+	return false;
 }
 
 static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
@@ -1538,14 +1541,13 @@ static bool __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
 			conf->geo.raid_disks);
 
-	ret = true;
 	if (bio_data_dir(bio) == READ)
-		raid10_read_request(mddev, bio, r10_bio);
-	else {
+		ret = raid10_read_request(mddev, bio, r10_bio);
+	else
 		ret = raid10_write_request(mddev, bio, r10_bio);
-		if (!ret)
-			free_r10bio(r10_bio);
-	}
+
+	if (!ret)
+		free_r10bio(r10_bio);
 
 	return ret;
 }
@@ -1875,6 +1877,7 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 	sector_t chunk_mask = (conf->geo.chunk_mask & conf->prev.chunk_mask);
 	int chunk_sects = chunk_mask + 1;
 	int sectors = bio_sectors(bio);
+	bool write = bio_data_dir(bio) == WRITE;
 
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
 	    && md_flush_request(mddev, bio))
@@ -1898,7 +1901,7 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 		sectors = chunk_sects -
 			(bio->bi_iter.bi_sector &
 			 (chunk_sects - 1));
-	if (!__make_request(mddev, bio, sectors))
+	if (!__make_request(mddev, bio, sectors) && write)
 		md_write_end(mddev);
 
 	/* In case raid10d snuck in to freeze_array */
@@ -2866,7 +2869,9 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 
 	rdev_dec_pending(rdev, mddev);
 	r10_bio->state = 0;
-	raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
+	if (!raid10_read_request(mddev, r10_bio->master_bio, r10_bio))
+		free_r10bio(r10_bio);
+
 	/*
 	 * allow_barrier after re-submit to ensure no sync io
 	 * can be issued while regular io pending.
-- 
2.43.0

