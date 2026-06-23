Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629D23C943F
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 07:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782199513; cv=none; b=rKEsmpxUeb4aD91jPUCjbMHUj74AAgh6QX6xpPi4LOrbCeUzJzY194U0ZBEhUAoJLe/i+CfcsZnh0xnDaxvMiGpE7O8o2h1pvzMIPoS2v8nR7/M2CDJtmfk2xePMIpyGccvsDwIhuHlJQ/UraFDYpsSOVctKXRUf2VsvBmq5rl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782199513; c=relaxed/simple;
	bh=vZhKRbTK19IGFJ42ixC/mDzsJd/XKY9fdrJd46AOGWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IomUVU/9PWZZMlYvTtvrfhvpMZ7ccPIl2yRQouYDpmt6KZNzpVHZWDDARFNESx1D3aYO/0j+NxzRgYq6/38lv8l9EzaaBI+qiiMly+m1VVw+phsqA4zPWWWdl0t8eMx/sIImjvj5Go888nWsL1WwMQrxC76ijCwM1okSd23IluM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TNtRFoqN; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TNtRFoqN"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45fe59255beso2574915f8f.1
        for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 00:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782199510; x=1782804310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KY47xf/CQxrGCGwB8Qcv69Q2WQ+OmvTJyRKFMzDLFQA=;
        b=TNtRFoqNhtmGCu+cd2EkaNMwFbIH/1kovGVMHU8qUgvX+gmZFDfDGDFBpqalFxCOZZ
         plAi1epnPJ1qMzGBz861NHls2ADZTLYnu7t8R5mmEzYE79t3Ei1rPAaqtLrddROBI4mj
         YT08Guj0fhCBYYwkDa2qACP0xROPqqgjowjkNoUsit0xER46oh+ApzWAuBPpn0xqrzHW
         2UCcmLv/hgklnSlh6/UdiDHpON5UOQquwGeLP9bfz3MToJGLSeWRUBFKtleR5z5Y/D0t
         RiGI/qjmBk1DtE5RHBWEdtt2dJWMd0xqob3DD8VaOxaM8fzeHLdQZ6MZH0v+4MNKck1H
         WUeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782199510; x=1782804310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KY47xf/CQxrGCGwB8Qcv69Q2WQ+OmvTJyRKFMzDLFQA=;
        b=mKmlxUlTQCpOg2vJC4iGEeWcOj2tV9EeqTFnGevNg8H2t4R0J7aqZEIWOH6GxtRg6N
         Sb1uPfsHa6Su8I3FwJStszRuZSWi/DhLH+MDk+CAR6Y5CKTa2B2FCXN00J8Uf4xJsOAX
         gF3TAd4lp2N6UadbOhCI33cpb7iRUmDPEoxQE//o4HfT8a/griW1ew8o4PdV5aXwZzQi
         xcbH8AHDfa6bSmyIca09pTdrXBQsmTxzjkFkLQZMhptgaVDZzWM/aR84iqog/h5uDOzv
         js6dV2LwBjxUc3a0uC1svSK0+eWIg/BQ6SjxuG8d8Svo7/SaCAmBR6IoqBZ0jeT+/UGo
         Cs9g==
X-Gm-Message-State: AOJu0YxY2KHbpFf8++mwYNnW6y0GhD7zHhAaTqjMKnJN28CoHE/x+c+n
	0iCWTAjYVkrJ7zBLpAIZqlOieRzfvM5gP6W3/ne7L7g5cvM3OVfOY8Xy
X-Gm-Gg: AfdE7cnRXVkjFXob37q9NeBYbNjtqdV6rNZxBBvPkTBnw0J/M2R8pMz5Q7AGqaRvhbI
	JHqHtfYogjdeQ1R8c/9bAmfhbWcOFrpv7TJei8uW+H47n9lF4L6XqPWnDtWL+GJVXJGpLw8FaiH
	aQjRtrrlMiLojKWdcGK7CSjU6RReLVaWnPdvn2ryXeMHFcYnFL3nD8tXkPD3Ed0XED+NCt3FYi2
	oIyhfgHp/WRnP3suw9sSfqvpo5be4PDqEsMepFDodEJWxacBkOvuvC31mz64TIKO4B3W3DzV/x2
	DbYef0PaDdMI71eJfsUmxCCLHQtCCIbCbN/KYaDsJ4NouJBTFYcQ2pTbY9GTUOJ6VaWznq3oLwJ
	XbDfkr65j+wsrQK4PWBjH3OVAHCPtjTLcYSQQ1Q2SHW75s0gzDIHyJ0v52/RDsKnZFj69U8JyRQ
	pUlh8g7rCQ/uv3Y065NG0nAM1+1CcIeqrP
X-Received: by 2002:a05:6000:1cc7:b0:45e:8547:f21e with SMTP id ffacd0b85a97d-46adb39b74emr1278261f8f.36.1782199509785;
        Tue, 23 Jun 2026 00:25:09 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de ([141.2.113.173])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46666c57afasm34278743f8f.29.2026.06.23.00.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 00:25:09 -0700 (PDT)
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
Subject: [PATCH 5/7] md/raid10: replace wait loop with wait_event_idle()
Date: Tue, 23 Jun 2026 07:24:54 +0000
Message-ID: <20260623072456.333437-6-abd.masalkhi@gmail.com>
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

The wait loop is equivalent to wait_event_idle() and can be simplified
by usaing it for improving readability.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/raid10.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4bc1d5553ec7..7085fd97b98a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1368,22 +1368,17 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
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

