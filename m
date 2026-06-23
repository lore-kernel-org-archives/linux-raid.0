Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E783F3C7DE1
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 07:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782199509; cv=none; b=JjXG/wbsl62VD3GHhBkjU7UZ1dCRrZZsPSExa4dtR6TxonsA0uUQ/1fdPoV1xHwx0JDoqJu3T0QvIr/WWhZFgWySrYuwLvIAE/6OMASifltMK1ah1r2PRzCVjUurk+WnAO5eqBfupe9KSW6MzSrYhf014UtLv2EpwNOb162t0ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782199509; c=relaxed/simple;
	bh=N+kjfNFbnJrVuEvIDPXtFCoWFM1vFaMXIVwmagMstyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6Zxx0jnka8+mZSqmbqbnatUR6JiwvQV/QobIYXvD/YWcoVdmYnOddZkm0Zufo7ZJhq1cXxRNoaiXaGA7HYvito4qrny62A3f+dwxxdERvwslHE0W8MMUPBBDITehrNk1KRgJ9/HdKLU5OnBac1ES8cRSOpdWDAvFsG7SeDf/y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d/+LnFZC; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d/+LnFZC"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-45ef779c1c2so4002237f8f.1
        for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 00:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782199506; x=1782804306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VIFjRPPEXKQTE3A+CGpLv825sdOkZ2+uc4Qrz2P3CXE=;
        b=d/+LnFZCQDzVk2xQnREZK7jA5XG/rpT6RZPvUn0GcYc96y1ArEmKQ58vy+1nxIzqLE
         UB/Qy+k834nXzLhVDCGM2k0oUKvS3wg6Ip+Ea+5qT5Y7ryrcsZEKlrRqikhFXb83gfkB
         dZh3iSa+mwc27BvxTwN8P+JI8xO4cLQn5eYpA/blTjKAQeanKRh1wNXA09SFlxzLDDT7
         2TmsXnBEplzPBCAsw4WGkfZaKWfYUPQM/V5P4mL+t+4zmNCNpHbRiuMgvOnQcMAH2qs8
         qdQMSoT5pbzmaWzWMTnYD6FxAZ+7sK9uNyTOGVmcpksJDj4vEwQeFI+E9/OLdadHCZQ7
         ixgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782199506; x=1782804306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VIFjRPPEXKQTE3A+CGpLv825sdOkZ2+uc4Qrz2P3CXE=;
        b=A9CMtEvrej0kP4UE32pkeLBtNsw05NdQojERMBe9Q7XUESNSPXMINq8hi6EZZcLtwE
         rMzNh9SLdf0V7EKN+g2YSOEYkWk9KangEJ0SSEEJh1nLzJthrMTepkPS3NM94VlkKc8G
         MZIszjK/o3uFI92ArRB/HhxdbCC+Appc5jTrjflmzjxBVHQ6pPcupAZ5yUY3b5zyXzWp
         qUd88dwbq9dONwN4MhKTqcqNi6FBNTUZvnkd04JXws1Cn+MveyIbxy8Z0YHM/Y666BTj
         gV+mfDDizG2oa3PEUJl01yGAMwmcinIeW/b0seW7OjWfAh1RuE0uBBaEVl18HC0036Jl
         81DQ==
X-Gm-Message-State: AOJu0YyOFZ0qrokNF4aXwZ8q3Kd6JCuqzx+O+bf8STag4r5NNQ7EyFQE
	fVEnpZ90s+2WqwSSjZd0FkuVU1R5kWGi/WYUAab5A0RjWj+0hk8p9KE0yi98CQ==
X-Gm-Gg: AfdE7cmwZw4ELKLuc/npq9GvKAnGqRN+e6N8nt2DWlkRvz5D6FTGJOXjy8xoxEHBTkc
	c985jySHHATH3PsTeHlYA+PQJrh2drr70u6k8MtphpLaplDWZd2iCYq589Mwas6GBn31SWgxOjC
	d+TXCzJQObZDnNdLK/wpwi+s+3ZYG5eJ11200qe5mDtsB7qgBzrgQvQM8T34rJMlrUlOklkFUG7
	b/w6BsqDmz7DuxynZjp04QjBVIjw6sYG/JeVTBZM6VTerz4qvlJ0v5p7vuH9w8B8tfQ1Ce5bxjP
	j4sGFUBnlasDd13MXB/W/eb767Zn9tCYXxOaNzEZsUbldV9mKd9eLQ7F4xhpMz2r10jNpBWqTqL
	ToeCe+z4jxkL8LLN9swqgnNEOGqqKPvyGmxhcVQWxX7ma30jwMUjQ7u2mSEgBPLIFu+qPEbzhL/
	kV5eTQRWT/XUBg/K+Q0EVF4/KG73t2tIy9
X-Received: by 2002:a5d:604c:0:b0:460:1387:19f6 with SMTP id ffacd0b85a97d-465091bcc24mr22976631f8f.36.1782199506504;
        Tue, 23 Jun 2026 00:25:06 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de ([141.2.113.173])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46666c57afasm34278743f8f.29.2026.06.23.00.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 00:25:06 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	abd.masalkhi@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] md/raid10: handle atomic writes that require splitting
Date: Tue, 23 Jun 2026 07:24:52 +0000
Message-ID: <20260623072456.333437-4-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623072456.333437-1-abd.masalkhi@gmail.com>
References: <20260623072456.333437-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a request already requires splitting when entering
raid10_write_request(), the current code allows it to proceed until it
eventually reaches the split path. Along the way, the bio may instead
fail due to other conditions and return a different status, even though
the request was invalid as an atomic write from the beginning.

Additionally, an otherwise valid atomic write may later require
splitting because bad blocks reduce the writable range. In this case,
the bio currently completes with either EINVAL or EIO, whereas it should
complete with EIO consistently.

Fixes: a1d9b4fd42d9 ("md/raid10: Atomic write support")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/raid10.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index bd322eccdc3f..840f0446c231 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1356,6 +1356,13 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 	int i, k;
 	sector_t sectors;
 	int max_sectors;
+	bool atomic = bio->bi_opf & REQ_ATOMIC;
+
+	if (atomic && r10_bio->sectors != bio_sectors(bio)) {
+		bio_endio_status(bio, BLK_STS_INVAL);
+		free_r10bio(r10_bio);
+		return false;
+	}
 
 	if ((mddev_is_clustered(mddev) &&
 	     mddev->cluster_ops->area_resyncing(mddev, WRITE,
@@ -1464,16 +1471,6 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 			if (is_bad) {
 				int good_sectors;
 
-				/*
-				 * We cannot atomically write this, so just
-				 * error in that case. It could be possible to
-				 * atomically write other mirrors, but the
-				 * complexity of supporting that is not worth
-				 * the benefit.
-				 */
-				if (bio->bi_opf & REQ_ATOMIC)
-					goto err_handle;
-
 				good_sectors = first_bad - dev_sector;
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
@@ -1493,6 +1490,9 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		r10_bio->sectors = max_sectors;
 
 	if (r10_bio->sectors < bio_sectors(bio)) {
+		if (atomic)
+			goto err_handle;
+
 		allow_barrier(conf);
 		bio = bio_submit_split_bioset(bio, r10_bio->sectors,
 					      &conf->bio_split);
-- 
2.43.0

