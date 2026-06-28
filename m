Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3B83AD516
	for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 14:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782656673; cv=none; b=jfz69vnoHCWzlEcZYiZDcdoZD/gKe6Xx9SeO5gzzt+MoyuYUhVrCfc4y5W2o/Rxn5OZLC2PWhIVE4wZUj71sV80COt6aZRfEm57aMrnB0QmwU5SGaZiXkF5cNRV0Pf8RMbmOMEMXR9ZMHCpX/qltCiiahZ+RgRn/z+oUj7OQImg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782656673; c=relaxed/simple;
	bh=1R/KuzTRQ4OYBfyE1PjecBDfm9bxCJCt3XJtXKafr8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxRXpcQ7UuaCjUQ2xPczhtBP8pKllnlnih599eVbxkkbP4g/9IS3gVJTU6EUSpz89RQLUmiS/UnhfyQQz9Mm3DH3H3MV+PNbGdqMf1iO53S2EL4gGrB7VkYF+YBF6O6XkT6k/vdZ5BTf/DnGFoMyOmtBk15DHb8Z00+ZBzoxfF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DT8SN+0Q; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DT8SN+0Q"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493ad116e05so963735e9.3
        for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 07:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782656669; x=1783261469; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xivX3NJ6EZtkbKkLAqCvtj9AF5zdWu3UP6KMCJ/Ac0o=;
        b=DT8SN+0Q/ZYqmILtFybfk2Rz5mkocm7Q9zcDKZQ57W987DX4qtDq8SgRHGh6VXCzrD
         xP1bA8MaJKqDResDZleqUbF4dOUNv5K8/fyUjGd0heGm4peBh7R3UgpM+UMnvwWM1DJB
         8nF+W1Mu4DuBk+rr+WPsWarw/BznR/4nu0Tiq/2AsjCFgjaLCwBUY6y45CBqBuwVZ+NJ
         Er22HwWISHe9byBHLXyUhgsjroZWbUZWmzdEWYyTO/U4fWw7KECD3if4r3hh5CRxzEj4
         ZSqxlaFwXd1KyZv/vYgl5fey/vNUEcQkaNmcr7jhXBByxk+Cpe6zicFno8gQ/iyrszs+
         8v9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782656669; x=1783261469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xivX3NJ6EZtkbKkLAqCvtj9AF5zdWu3UP6KMCJ/Ac0o=;
        b=OKkFkinJVKE37EDpF20sg4hI43rL4uEhwH6rCv/sWKWbxCguuWOSE92+BRi/Nij2aR
         L0rbm34xqLEARlzn7ZmOucZCIVy9mKhXjI/OrWaJM5myTVnYsl/Mg60VBFEJ3DGC19t3
         +RGdAOtcNsdQI3WgMmTz+2yFymY+Jbu+DeJa91O0/UlJpqfmwKtxLYZFVksp+ohA0+bo
         se1Eq5oO5CJSXny/M8nkrCswtpQEHq7t87kXatXhN238MOnEPa6qNB/wDOsSGgmSu4k/
         Cn5knQPQ10/SgBfhPzxRcTUvMe/A5IyMsL/+SggO9Nk8x3MT0L5h44hy1Ja0kGRUhAFQ
         oYVw==
X-Gm-Message-State: AOJu0Yxq7nwGxshKqnpjyPeiQmy0lPZ80tqHmhiu2l1x2vMMLZsw9/G1
	2wvlGzNWdb11aCIgdpCb2gVb9SK5sgcGs+Ovdvz2ZYI3G66Jgq8MnP4ElaD7CA==
X-Gm-Gg: AfdE7cnQul0NnnXlB/GiE1YubHQqt7Li7Sbd5itFrwXaoZUzjoFMXCoOeOumHNq8QV/
	eDiZMR8K7L3E0AVeyB8QJjw22Ggmwe3NVKAEwnGuWMCZiz20lOgf2T9+AU3vFRGYh/iCRcM7dtl
	jqUxqDiECzedv6Bsgfu6DN0MPfnJ7JdFjAmAhcNnBheGLVnbbIm7ZXrofOAwdajLvSKv5pH9GLB
	9ckOy/Y5yQcq23cTAojZIBshZeyAGo6e9jELoeiDkOV/l/R8cb32HGexPjit09KghHBUz5ZBNx+
	Tnm/86y4fYqaO8UOHXz0PRzwF2o3tHPFeCuMCpbjUKyUIXVSKfis/Xr6km9S53LDP9xGNth1O4A
	M7bDJzy4YFuAppRs7k5KrrS+PYAYu/Zx1UsfN2BmjtZ+sFl8kX/lFQJX7URG9vr2QH95IYFzYgA
	Onf15tUNI49csq2lvx4d9f3cawUE6wqVrN4e8PI1y3OZFCsdJJtB4E1UqK8iaIxZNrpL9G1k7qQ
	M3QUtc=
X-Received: by 2002:a05:600c:c118:b0:492:6881:1114 with SMTP id 5b1f17b1804b1-49268811131mr154530535e9.0.1782656669173;
        Sun, 28 Jun 2026 07:24:29 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de (cb-8021x-nat-134-108.net.uni-frankfurt.de. [141.2.134.108])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4728072189asm7819927f8f.30.2026.06.28.07.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 07:24:27 -0700 (PDT)
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
Cc: linux-raid@vger.kernel.org,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH v2 1/7] md/raid10: fix r10bio leak in raid10_write_request() error paths
Date: Sun, 28 Jun 2026 14:24:14 +0000
Message-ID: <20260628142420.1051027-2-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
References: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When raid10_write_request() fails because REQ_NOWAIT is set, the
allocated r10_bio is not freed before returning, resulting in a memory
leak. Free r10_bio before returning from the REQ_NOWAIT error paths.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-raid/20260613184042.BCEC01F000E9@smtp.kernel.org/
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v2:
 - No changes.
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-2-abd.masalkhi@gmail.com/
---
 drivers/md/raid10.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a3cfdd3f5df..bd322eccdc3f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1365,6 +1365,7 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		/* Bail out if REQ_NOWAIT is set for the bio */
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
+			free_r10bio(r10_bio);
 			return false;
 		}
 		for (;;) {
@@ -1398,6 +1399,7 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		if (bio->bi_opf & REQ_NOWAIT) {
 			allow_barrier(conf);
 			bio_wouldblock_error(bio);
+			free_r10bio(r10_bio);
 			return false;
 		}
 		mddev_add_trace_msg(conf->mddev,
-- 
2.43.0

