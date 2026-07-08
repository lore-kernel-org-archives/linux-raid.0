Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CE23AEF46
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 10:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783505641; cv=none; b=eLDx0eJh9vEoOdO/rWzceg3HuPVcQMLLRSgzbqmax/O0om4YsNTYVBkS8AR272emM96Fiprw70vdj0lOLIBwlECP09eKS1lZuGjnyE9RVtoMc56mgzgcxjUYgW4W/NF+dvAaQaP9I7uhZ4Tv6sUNGinyLaOaS3erB22MEEAmRRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783505641; c=relaxed/simple;
	bh=/vvBYYy/IlrB61xJNCjmSeJbeuTW47g2qMBJ4nLd0jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJR61kqoj1/wFIpCourznaClddvNoUNLzgwaszWjC1BaRPOfqoIF3uXJSUqGxo8iJicNMFWJt9MOOh/m7oXU7yhAPxhKTp40zXFydxAjvjOEXtdKoi+FCg84NjsM7RjRo+UtVfaC2s1SFmTNegUwUaZUcoOGiM378UggqgbtZ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AJZRFUdG; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AJZRFUdG"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4938d5f86f3so3130885e9.1
        for <linux-raid@vger.kernel.org>; Wed, 08 Jul 2026 03:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783505639; x=1784110439; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+TT1kUvRZlzcPE0vcjEwUQWMwkfn7aOpBX+r8M0A5qk=;
        b=AJZRFUdGONNML1OvCbynjc7bYeNMYUfMMugPiIdklxKU+hMYrs0t0qRgUQOPdooM9t
         MSP02Zl9r7mFk0upKwa4ZbbbdHl24Ga29ywTM0QqJnaB8HpQJaclxGI/dfpG2ZCEnEmW
         2xZnrmV7WoW9fMa6S9P5VwPIXUdffajEj/Z7bqodbI8FspzywZY+4HzxXYm3Ipo8FXQ4
         k37Rq0RQn5wmoLwN+hb9HDN9FlviT2FJZIiw1LsXoP5s6hCnHthydFYurP4iW0jerMl4
         AQkQl2Aufb3LxuGALmqJPBrdFupa8r+l2AX+QlC7igl5WHPCU8twRvOy5JUh7QS6ccjo
         V+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783505639; x=1784110439;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+TT1kUvRZlzcPE0vcjEwUQWMwkfn7aOpBX+r8M0A5qk=;
        b=ct8rh8YJlDAGvCdaJkhi2P850a1VzTPaxuNPRuaeDPAqa35uhdbB2JaEAM/hmFrWfS
         YWorTWErf24+oHFaG93vAP485C1oIcVZNL9ZcP23UtffgTAVFQT4J2rGNhaEAMuWeJ6e
         /rY6s5d2tS8DV+wfvzVXbUktjWHHNWNyfZLiJ01gMuIq+oWbMv1yQlHIOeFneiztjR6M
         y6rLd6GSv189LTZ4YWr5zWU4Y5G/Qfy3LFxTqFbI+FuaZMLQAALaPH4J7XrUwHHDkujR
         krSTGmQhWGBZXx6cyi4GNQMxJ9RuOsBOd5HgUK5ONO0a4px+jK1Zo9niHb8hR0PIbG4X
         Z9eg==
X-Gm-Message-State: AOJu0YzZpJnmOp+J0ottkSDD5U9UgFBT9YKK9YlOwT91S6JSgY3IgQ1X
	Es3EdhxeFFT9pHrDlUP2KD8tXe0q4KwepApG2oRDe1fVfa8/Me4nA+Oy
X-Gm-Gg: AfdE7ckNE4YN3XfPGG8UzEIbquoZbXwIZJi5PHtQijB1XU9to/fDQ5bvtSwwIl/wA0b
	CfHQoMaZCnfY+FPLdmE+MPINvGzwQ51MNV9ez41Bi59PbhNG1/LOfvziQ6t7eutRn3xICWhMs/J
	CuGlPv4dOLjSF5e1joSP95PvCLnGtYJ9g/Xq8/BEBh3CvK1gSX6ipX+6LV+Jn9UfIW8x1pe8F0N
	oifYpDlM87IbQD8jycaEevqzfHZIjcn93uM3EYCp85088xkpJ1eB8bEg8M77Ew7u+ReF6e26Es2
	A95lNy3ezQ8nHZHbg4DCi5cyOGDeA6mOWImVsWSJg237egrUR7U+M6LaYYt5LK+XCPfLOHe2/Xo
	uqiIwIhlqMu0xOKnDuZrZZMlC918udIZmXZKrtuIYVOY2WU8AFLoNruz+REmJNVndVB/NVmp1hT
	Xmgnf1iNG6
X-Received: by 2002:a05:600c:8a0d:10b0:492:7025:13fd with SMTP id 5b1f17b1804b1-493e65c1de0mr13045175e9.0.1783505638423;
        Wed, 08 Jul 2026 03:13:58 -0700 (PDT)
Received: from yocto.. ([195.72.110.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0faee30sm108987515e9.10.2026.07.08.03.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 03:13:56 -0700 (PDT)
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
Subject: [PATCH v3 5/7] md/raid10: replace wait loop with wait_event_idle()
Date: Wed,  8 Jul 2026 10:13:39 +0000
Message-ID: <20260708101341.473750-6-abd.masalkhi@gmail.com>
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

The wait loop is equivalent to wait_event_idle() and can be simplified
by usaing it for improving readability.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v3:
 - No changes.
 - Link to v2: https://lore.kernel.org/linux-raid/20260628142420.1051027-6-abd.masalkhi@gmail.com/

Changes in v2:
 - No changes.
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-6-abd.masalkhi@gmail.com/
---
 drivers/md/raid10.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2574f60dd771..57813f249578 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1362,22 +1362,17 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 	     mddev->cluster_ops->area_resyncing(mddev, WRITE,
 						bio->bi_iter.bi_sector,
 						bio_end_sector(bio)))) {
-		DEFINE_WAIT(w);
 		/* Bail out if REQ_NOWAIT is set for the bio */
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
 			free_r10bio(r10_bio);
 			return false;
 		}
-		for (;;) {
-			prepare_to_wait(&conf->wait_barrier,
-					&w, TASK_IDLE);
-			if (!mddev->cluster_ops->area_resyncing(mddev, WRITE,
-				 bio->bi_iter.bi_sector, bio_end_sector(bio)))
-				break;
-			schedule();
-		}
-		finish_wait(&conf->wait_barrier, &w);
+
+		wait_event_idle(conf->wait_barrier,
+				!mddev->cluster_ops->area_resyncing(mddev, WRITE,
+								    bio->bi_iter.bi_sector,
+								    bio_end_sector(bio)));
 	}
 
 	sectors = r10_bio->sectors;
-- 
2.43.0

