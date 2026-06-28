Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984273B14A8
	for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 14:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782656687; cv=none; b=u80MRel6NGf3eLtCebViSB0g6+4J/aUUJZEByfCMv8Obakn/v09yoTCr6Ic7E6k/8N+nuT9mszqEr0rEEiPPP7SB2Af1OW8UkhdT4JgDFphnHS7CR8WB6jIZtPUOt6ijYr3uLICQcV9PqTgNuqELyYgnQNJMOljkWHpvxgFEdrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782656687; c=relaxed/simple;
	bh=b6iP812E/S4AUBzMr6TGHGVkrfmOrTJLacq94xcyJ2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjXDEwecSXlnfbpqyJq1nb/HrlCac+GTt6jVitvMMV8/Oszd3UlCY2DikOeO3LLatU+z3wWTse2i/nYrKppWM0lq9s+57zIVAyQQIoM4bb1vuDVP6vRl8Hoo3Fk9VbIX7j8Z4Kw79GdTCznmmIBc4dM/OgqWsrEdF4VPKZ4ojYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XBX6rjUA; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XBX6rjUA"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4631679f204so1883994f8f.0
        for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 07:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782656683; x=1783261483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ayWrbW+jc26EuCDFJ6wgpKAN5JGPsLDXOp0AK1j+d5s=;
        b=XBX6rjUAFExG95kfzeA6LcHyV4/2I8CsiE4JMyvbdEy4xSdfdDYFyK2+dIcs/tcjO5
         bqpwekCFe58ivAFwH8dghWtozq+Qqkr7nBf1HsnT1XTwI/ZbAFJXtGKUk+mTgs5NQDSy
         MIwHzdve+45rLUM8oIWxspnpXiiCUMeOCOPohK73J4ZAt4fa4NR7P8VnYDPsD9UpaG3l
         vq35C6qS/2aaf1NPsy7Gn7eBfX153L9QbrjxUTei2DV2NAgCvekKrWtlyVIwkljmY49u
         dwswGkOwLyZWA9xCJJuPcHSM7UviosktoON4F1fzAXyx+Wos24WE9OXhYyEg6vIIPshs
         UhIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782656683; x=1783261483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ayWrbW+jc26EuCDFJ6wgpKAN5JGPsLDXOp0AK1j+d5s=;
        b=pqGOmv4kN3879BLSF4q9Z1Ez7aIi5WfRVDKXBo+TfgzJnJ7G97dtVdYgRJVTiGzIeS
         TnOuHIVM38Kc7NEgVyPG19THpFi8OIXEw8v59/XNES9zOvgRtBp2lRQehrpPp30CQoQ6
         XX3FXWZeK8rw/FZcvPM/bbIzARuqg/FW57bjwzb0PLgDFxh0U35910T1a+a2rt9zJyZW
         tcIND8Z+OPtBSXXYkjRR993QxrOGdC7atBvq9gVNY+Wim/HjKUhfiZMrH7UU59VQkVTc
         R3uuVNRXHGkt8XKhVsRXpfP8CG6sTsmqUW/FyEmePpj3xLFZmRGmQWQQe2yUlccoL20T
         IT3g==
X-Gm-Message-State: AOJu0YwHJh2cMUxcZVFoEU46HNXs0fGw7owDiSD24XCU2S5m1NxU/rk6
	HktAeSsa2wrxuoZno2gJOVr3j65JOKGAgdsmKaxYLjjjbIoxpLtNvlip
X-Gm-Gg: AfdE7ckzXrTWjczh+GmApbyuAcdZ1XdmQS92qdn2fGM+zqyiC7V8MQ4WcYxKVI+FZv3
	F9ZDJe09PnBaL0AWutaiOQyZIC4fLYEFZAl1owbDUn2fBPYZp11EnAuN9uEqUnlSo3LIC3Zx+Lh
	P93ZtbrbsY0j4PqGSSzGmuBG9qLGIUi0Y1xmpkPmhXKR0E0CIgbxHCyyY8MakOQuTt7MUsmSHTu
	f3yYxB0aJc5qEX+IGx+S5cB332DyV/NmxHTOW8LXPGAsWAEXMVmiZ5AIigk8BusMmWeTKs7OpOT
	XCXCH/4BT4dC1MKkD68YR68pNbrBmzMSwsdLFQn2TshN0gHmigRFFsm8zjABleHM9/7S4GlXx09
	9aBk3q60r+HnlNR6ggPWVXcpxLW3dr9lEYrs6MMGWgDIP653kluO6evDy8RuC0C7ITmyAFAvduD
	gs+J59IgErZNHec/2GxbHFqCDuIXRVTmzslLdyZiIl7f1BHLXLiiK7YNm7dfW6EtAoFXuWmxu8t
	Z/KxHE=
X-Received: by 2002:a05:6000:240f:b0:46f:8082:157d with SMTP id ffacd0b85a97d-46f80821678mr12286347f8f.28.1782656682774;
        Sun, 28 Jun 2026 07:24:42 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de (cb-8021x-nat-134-108.net.uni-frankfurt.de. [141.2.134.108])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4728072189asm7819927f8f.30.2026.06.28.07.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 07:24:41 -0700 (PDT)
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
Subject: [PATCH v2 5/7] md/raid10: replace wait loop with wait_event_idle()
Date: Sun, 28 Jun 2026 14:24:18 +0000
Message-ID: <20260628142420.1051027-6-abd.masalkhi@gmail.com>
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

The wait loop is equivalent to wait_event_idle() and can be simplified
by usaing it for improving readability.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
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

