Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095F34071E2
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 10:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783678581; cv=none; b=oZzFONdLkvTQqRftNSALawVgnNBv6sjVMRY1kbIamEQ8N0LVa7XnLjb3xQRM9KzD+1FxHtuyRMS8Lw/4k2sz4qgV0JsuHK1AE5rYW/ulky46IMrgJl2DOCeSERU6NVHnHjHCdfXUqLENDO0XfRNW8qGykW4Nv6H2KXRmR+w5V5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783678581; c=relaxed/simple;
	bh=DUcXJs4mGLHZ6uymZZALHDG0hWSlwUF/mtempvDSnec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZGhPvN7WuD2Oi4OSQ8Ku2oGPDx32KxEfkHXorXD/Hed/IjWvLEl/K4cz+rTfg0yXu191tZabnDLhRH5iuVayO/6PHhYFKg3kiQncnFeqFH3/2RSIlevoJBBACpTxHNG0rsy4c3mqQZTU83kP6tByZz6JgTs8DZJNBQMJ1MzyJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OY2Xi4+J; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OY2Xi4+J"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493b966dd74so2673305e9.3
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 03:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783678574; x=1784283374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T9GmK302JjUZNyPIbeSQCN1z48qUp83oZeSDjYiDAN4=;
        b=OY2Xi4+J35WOUWG4yUipeQVfNR9W1aMkkrfGdJh9eLt0C3nhm6S6Mqbcau3L82vOQz
         +uWepsfC4bNzsacShKAttPn+69B8ejaWB5WJEh3Bh2oPzHL/kQHYLTrM5AwQox/HKsj9
         QcKXwO6CfSp+WgNK4m+bTPcJrCw5UtjnpLIBSR0v78WU8SckFfL7/GOjQ5Qs40pdsOvD
         LNH1UFR0wm4BQEfzrv8JJMocBHJwtMoxitdwmsnHqv9zXCTl9ay+4/aW8MxC28fi5YDp
         AUPShAz5/XmjstKduKieph09X0rtnMdalln6Eaw4iGks2LN8aiju+bRAC1ohENAnsh2O
         Z5zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783678574; x=1784283374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T9GmK302JjUZNyPIbeSQCN1z48qUp83oZeSDjYiDAN4=;
        b=KkaPKQFzxk+hvfLB7NeMshP+biF31hw2N3bEIuyF7o46RX/BtN97q7X+ejXECQM3iM
         hopLwNX1g6v8nJw/Zqysvu07sWXj7TtSsQa0SFToLoIN/Z/OS39mwNEORk23hs5EQkVa
         3cJieTgNb0+4p2QArmNdBnjJVCbtnFQTqXwfmtlqqzlUeFV0fXNoXbSP7kiGPXeWZ6SF
         qvMziK+7hIZgZrvElo10n2IW6GVJCaX+mhMBfMF5GMsQ4HxO+FzvVoNC8jwQJv5plT+j
         qKm5ZjwoRXwIFS2LAFh586BIXMbjbqC3Ul8rX/4fklLeQAgwMhpeLn5C6GeO+rfuyOwn
         fJfQ==
X-Gm-Message-State: AOJu0YwwOtI3S7lEEEi+NTtRQwSlLml2i8sRyyOMdljdIlhJniRj7mLM
	tWIdnjX+Ntv+o0L7YMrOJaFX65g+mz/Zoun/Q2/89sbOEI3X5uP/r1JP
X-Gm-Gg: AfdE7cnfBTG0dYpWp23QSmmwqmMoMUPqaqYmVNakrW/QN3mEwdLxXqlYDG8nNYIoq5p
	BqhhgnvLR8wNc6g+ygkJfoGmf370zl7Qe/JaPSLshrMSmKgZUi+Yg36EWx/Am1pwUCpI6s7C7AN
	7ucFk0WC3LX5nNX9I6ljOcgrtf4lCLKhQZPx9PDDfdqbosbGG9Gl8Uekx3FSEZNpdlHV8TiRjxR
	Qq3t7WaGVPJw1bow79k48Wbr0ZnE2yvUVGdrC2jbB9giaEc5LsMtGUWaujVgGGsS3HD+jMOMl1X
	OqzHKActDi1dpPFnTK1nRF+ksJy4clwUiZE6f2KyhUI1xk2m5qsWXq659JYRAVB4eIpOaSEwTIo
	Mx4MeWQpdmrNnBjjT8LqDC1jiM7BSTAOzoFcIjeqgMJXZEAnl/QbaeO0HHOjVYPTQcOyRPCVEQE
	bkgtGf29VsPg0ReKIYRqTtMIVZWM3LKsM+ecED6EJ0JmMThV0xI3r0Vm/Jp8VH4t5o
X-Received: by 2002:a05:600c:4e01:b0:492:4cce:53e2 with SMTP id 5b1f17b1804b1-493e6831719mr109196505e9.3.1783678574414;
        Fri, 10 Jul 2026 03:16:14 -0700 (PDT)
Received: from yocto.. (dynamic-176-007-199-185.176.7.pool.telefonica.de. [176.7.199.185])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb670a41sm123554875e9.0.2026.07.10.03.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 03:16:13 -0700 (PDT)
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
Subject: [PATCH v4 5/7] md/raid10: replace wait loop with wait_event_idle()
Date: Fri, 10 Jul 2026 10:15:19 +0000
Message-ID: <20260710101521.1714-6-abd.masalkhi@gmail.com>
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

The wait loop is equivalent to wait_event_idle() and can be simplified
by usaing it for improving readability.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v4:
 - No changes.
 - Link to v3: https://lore.kernel.org/linux-raid/20260708101341.473750-6-abd.masalkhi@gmail.com/

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

