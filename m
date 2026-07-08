Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E203B9D97
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 10:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783505646; cv=none; b=g7FQl/2zka7hLlIC1Tv1nrs/PuIfpLfWrJnqbYYLHWTHLDXfpHhMa4SceGH+e0ogxTUsYYIH1GFmDGp2JnJ8MVuNzb1awIqN3/5Q7cSPbD+foTfWxMIpirTHamc3XlIVbtP/wNoOISM8Rycq+7/MBxTs536r3Ssb+yWe51qiSsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783505646; c=relaxed/simple;
	bh=3bZUfKneljxDo8HIQ26fjHNOBXMBqquVL2p7CIOwnRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVxvz5m/b+F6Sf4lYilD8vaNJSFHg73u3LFzqGQGZfi/NzGWZCYfZuXyXKw+/SYW1oeGB/N1RJYMuCf0Lvn8bd9yAO96Jg02M6G05GNuFBJYeBcQMO8v5ddgkGGCloRSfh2O6AqEEaiq+DRTWLU9kCT5cNWcE1Ja8pzRYXOFX88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rLsvBRVo; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rLsvBRVo"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493c19bad03so4395265e9.2
        for <linux-raid@vger.kernel.org>; Wed, 08 Jul 2026 03:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783505644; x=1784110444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5Xp431BcBJ8pLR+WVQluda46gqnc/9WN4qpj1s9d7Rc=;
        b=rLsvBRVob8y0rfsrDudLQkCBPfW5Fluyh+hLMCmF9N9slbPuyZOqX3f6mYbBdDNVZw
         WRK2HXhJlCY8QgNkKNBsq44ADClTN9zl45+rFUYm4Ju/m4dQJVZaUhrp9fxmMlULU5d8
         jYZq5yf27Yveyoow2gIkl5j1g/NTnOPJol5LzFsayC5jfqE8nJGqM/0CIMkulXkWH7WZ
         q5V3yJGpdmxLEQM7EH4+LMEDTnKt2K+EfMqFcbLrnQovl+MwVUGlMouTSZYG5pwIT77l
         1eqx60A/2HzN/gSayY9hRHTTpF/ak8pH9JXVDhv2IwZtNVpIXQzN5W8GMDYx5PT/Pint
         hyzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783505644; x=1784110444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5Xp431BcBJ8pLR+WVQluda46gqnc/9WN4qpj1s9d7Rc=;
        b=pXaX5MA1DhtD1scWi4VoSYZ/bPAg4BMg6Z5LyIOfP+bxwI6YNnS3tCe3s+H1gUs7IX
         IRhrOaJ04dTMEc9I8W4Fjk9LLHkXvJu14sNiJmxQuMGpfOvIuTVNzJl3CHYTrBykYvJg
         vBsTVhlyx9iU5ed1KveTb/qm/F0GHCpJVZoP9XSgnkjGo9mpl3OcVYF9lMPn7TW1AQiJ
         2C/EAIq7/9d39GpLVprRz2OQbvVprmKIKpbYC8Lrks/3rEmktH/oaAiIiFmQGBLKlYDD
         oAJ37V3FRpUQ9qXjuovP6q2Qbib/w3nCuILme3r8ADY6CVWeyYJq4a4i4jG75BTNkbEl
         GC1Q==
X-Gm-Message-State: AOJu0Yy7dCi0kb4xX/9pz6CVyfBQuMtGZUozmz2wPXsZASt0htgLwHfC
	ejRHzMm17CZLs3aobgIjJWtcr3hYwu+4ygLRkzLJkyE+ZmMiQtdURHJLKOGcpw==
X-Gm-Gg: AfdE7cl2MJtcoR+T1+Sgi+pYqxZ+5ALrG3Krn68bQny4VzZQ5Brr/Su0WoDA/a9Rdwf
	WaELyzR7DnEs+cNAAtZR2NQnbJCwgAFo49eyVefFcHdRspTY0+Pn9PQQibe+wDP7g6eyYhnOqKX
	/yNTkcD/vazJ0nrXq4Og2FsAdney+iIwcEIiVrFxmPhRdbTCRMBsH3tym7bx4ktfMm4OfhPIlid
	CcVvjSyWVK1jIBl9ZhYCpGCe2p0AhVJwFr8Q69IrYUW1eudZ05SKzSPKZ6ewWl5n1+x1NkOgvU8
	EcRMI6Xhlbv/HoqRkCxhCY488HherMvkpPZFjQbcsmxn2Az8u2fMATGOKf6jW8g7tuiSVSzaIby
	DUeedNNHid+sw1fI00+mf9SRTAh+AJVIpmKxt17in9Bz86jQAzaRRpdqiccANAchosOqSh2A2dn
	d7b+VT9KW2
X-Received: by 2002:a05:600c:c84:b0:493:aa24:792b with SMTP id 5b1f17b1804b1-493e685fef8mr17285555e9.22.1783505643363;
        Wed, 08 Jul 2026 03:14:03 -0700 (PDT)
Received: from yocto.. ([195.72.110.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0faee30sm108987515e9.10.2026.07.08.03.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 03:14:02 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	vverma@digitalocean.com,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	abd.masalkhi@gatech.edu,
	linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH v3 7/7] md/raid10: simplify read request error handling
Date: Wed,  8 Jul 2026 10:13:41 +0000
Message-ID: <20260708101341.473750-8-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260708101341.473750-1-abd.masalkhi@gmail.com>
References: <20260708101341.473750-1-abd.masalkhi@gmail.com>
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

