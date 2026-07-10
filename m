Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E81F3E0256
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 10:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783678573; cv=none; b=IKErAuGLXYwB+5NdGaAO9pNy++WX6jLkEieZnN2oV/sMq+gPKvzPPFpxo6l/b8ZF4cZJVEl0gZzv1vUzZMpjEaGYkWUYz2RPkkrWxmkHa1I6hDuU2vnBNMcPlJHvslyiAYQH+NBdjsq0u36X4WlLAyiN5CQIlnOyAZci2q4CYng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783678573; c=relaxed/simple;
	bh=1tlFjz/cCmyQHjce8cSURjPwovVmOpmqfVBATU2ybJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8i6OH7P+DtZ02vHY65ug1JcGeHPI9CysAi0tj+NW9zO46acFL0yGQsJUYc6V3z9fiNoUBo3tR0l45a7wvuOxubPFBz9qscqyo0OJiwBEeTiBjKGvH/X300aCYBmNyL2R9jCRZsYREroxx86itkUlmiebgd/tRWbuKZ3JMga0Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kyIjCGeB; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kyIjCGeB"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493b7612475so5892005e9.3
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 03:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783678570; x=1784283370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l+6lrXW8MRgVUIlREriBzz+n9VJVDvmnQ2y2tzCDScM=;
        b=kyIjCGeB1zBW5vz1gqUGl2qoA5isRqdNsvYuqt+VzTpEk8q1SfdRCcyzd7o9qP5lDj
         40exawOwB9P4WtAQOmKourc9VlJ40jJqkRgkvZfxNUSdKfv0Gz8soKjnPjVDPSbPjW4s
         1Gav4QxEQ4R2BvH/9RKa7EY8tX46IYYsTKdx2fdyjouPL1FPvmmyoCvNd3GbArXkFMBg
         /VXIe+Yncexy3hsdCRSeeSo2lt+roq/VcHo2yGgg30QXnk4JL68568kLKWc249pPuZ6f
         Ak1zdYiOrTJceYUgIkjUDtfIhxwd3qG8CuQ4CeBkEO86yjkL2iijk3Y4nDybDYEAH3bc
         uLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783678570; x=1784283370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l+6lrXW8MRgVUIlREriBzz+n9VJVDvmnQ2y2tzCDScM=;
        b=BaMLFKLPFemhw0bXhqVKChdv9UTeeYRkK0Ph4p9sR+gls6fz4UVPNYEJe6eL0cRN2z
         jTXiHb+SjRXMdQVTwaCbtYeb23Mv8e7zvTvkGeo9md6/PqcGmqXldXeXuj6EWSdkszQZ
         yJEgHH1OeyYDTznrMW6MNNyXOm2fI8DFsuogaSCdYIERbTcD41ncSXxUVDoaMwm5ymR8
         eR7Dwop5KW0Vu1/h8XYXPfk1bkgB7PkiceG4tU0OGyf6JCzahWIFaUN5DV3sj0s1E7kj
         9BUmeYm/gNG4RuYYslpNVJ4GlUnjdegDLVbrY6STpaNwDQJwFhZHhZ4FZ3Q7FLl8wvlx
         Vmlg==
X-Gm-Message-State: AOJu0YzVinr0glX8gHR4r1hYoZwjjtuJ1DUg0oqHNIaMGhCOmyPKbC0F
	oOB0pg0V0kjhgLPU/ZUQ+kwiUSvFdEwFkT1WodMU122/vv0GyOcxPMTY
X-Gm-Gg: AfdE7cmsddtif1M6YnJr3ehfU9eOSBKVGzq/6Qd1oSHwtF9ysQ42iX01T2ZH+uYmncH
	E6WC7PiAsFXbUd3Ao7dlrbZaEiIlxVQZQLZb7gFowBfuoAmT9Fl662XXsAvXW+S9BPp+YV+mZuc
	P/wV8xjpAw/xYc8nFo6MVGqG/08MsZbO+G00wqEqVOE4iK7MIlMZ7tLha1QdD34diP30kZxylZw
	uC+Q2Mgkb9XFNNEuKA/erLvMHbn9HjT92+bbpy2iFNC3yMxbsA24ljCAUr8bYRw6/3hHTkP7Mru
	gtQSiHF18rJNCV5dpjzFbXjDr+f/lGKSxuEBTsg1P8JEZ6SusUERK6XOfiHwHB+O0rIhv+EICcJ
	ulT45yO4aAzYsr3yO73sNlUfKWrVsljq3vrT8WFHZX6o1xPlwuEPxoNH92QZcXbFl5ti46sik6E
	5JCelUZfpXMuCJ2SnxNLkw6mjfmZ8swBTl7G6hH9fFbNYzjbwDqIqnLHGcQ2o+vPtBJkCkCQnMx
	GQ=
X-Received: by 2002:a05:600c:c3cf:10b0:493:f0f5:f2db with SMTP id 5b1f17b1804b1-493f0f5f3aemr32432155e9.22.1783678569482;
        Fri, 10 Jul 2026 03:16:09 -0700 (PDT)
Received: from yocto.. (dynamic-176-007-199-185.176.7.pool.telefonica.de. [176.7.199.185])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb670a41sm123554875e9.0.2026.07.10.03.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 03:16:08 -0700 (PDT)
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
Subject: [PATCH v4 3/7] md/raid10: consistently fail atomic writes that require splitting
Date: Fri, 10 Jul 2026 10:15:17 +0000
Message-ID: <20260710101521.1714-4-abd.masalkhi@gmail.com>
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

RAID10 currently handles one badblock path explicitly by failing atomic
writes with EIO. However, another badblock path can also reduce the
writable range and force the bio through bio_submit_split_bioset(),
which implicitly completes the bio with EINVAL.

Fix this by handling atomic writes in the common split check. If RAID10
determines that an atomic write would require splitting, complete the
bio with EIO.

Fixes: a1d9b4fd42d9 ("md/raid10: Atomic write support")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v4:
 - No changes.
 - Link to v3: https://lore.kernel.org/linux-raid/20260708101341.473750-4-abd.masalkhi@gmail.com/

Changes in v3:
 - No changes.
 - Link to v2: https://lore.kernel.org/linux-raid/20260628142420.1051027-4-abd.masalkhi@gmail.com/

Changes in v2:
 - Drop the early atomic write split check from raid10_write_request()
   and rely on queue limits instead.
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-4-abd.masalkhi@gmail.com/
---
 drivers/md/raid10.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index bd322eccdc3f..3480fc7907f0 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1356,6 +1356,7 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 	int i, k;
 	sector_t sectors;
 	int max_sectors;
+	bool atomic = bio->bi_opf & REQ_ATOMIC;
 
 	if ((mddev_is_clustered(mddev) &&
 	     mddev->cluster_ops->area_resyncing(mddev, WRITE,
@@ -1464,16 +1465,6 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
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
@@ -1493,6 +1484,9 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
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

