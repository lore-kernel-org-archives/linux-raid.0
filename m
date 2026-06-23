Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7623C5DDB
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 07:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782199507; cv=none; b=j2dXtZooIZ2Nrgj1W3MvmWIe7/8tDQymNjyjgKXPufYy8j0Nk0yOMfyvGAUWcL218hb+KUj+jATCkuVn7rhDWkLcVOn8QZUxwtWfA5IZmKr/BOu6CQr1VsVaDoTp1vjeM+N4xWZY6ye0DjFvcDkx58bw7XVNzvzcaWFYcRnCCKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782199507; c=relaxed/simple;
	bh=Ti5Z20ExIs0K9WHF8/Xe9meA6hiiaxMXXpdKn+AHPjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsifHxcbOsZ2iqceYp60CWBzyEL30JPFcR0zgwa2DKX2WtuogW+BcHuZHGd4J9sBkkL/cbivjx/caMfLmvYuIcGkZONduwDfhTfFVaHcvfW8DDTpeIk0kpE5yYsSXySR+JMBvAb83SVZBiSrFHqqWonAjTSm0g6Rj/dsZIIy6Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W45ABOqZ; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W45ABOqZ"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-462cdb88d01so446301f8f.0
        for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 00:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782199504; x=1782804304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cixHBYeYe02mLr64ZFg9yFOYVilxOSWazCrgIgCACI8=;
        b=W45ABOqZ/FIppzlzl6HO67+NssCBwraMUgTdge9Vn64rqodjPDq4QbVj/PA8ZUgNGl
         Yg8xOhmxf7w/sSDNz9Ed2zvRXh623vhGM/EQqLFkiYishdRLfGZ36olk0MYIuVBe5Wso
         3piXL5eQ2/sorfmeAzCpcqsbUoI+np0HPI+P4MSa7Lwzn5qI3qYrhsbbkZl02CTeeh54
         G2u04Nab4rKiVuwX0UtqjBEwvfmIegGn/DOifHbnleGgpGwXNtEOv2ivph1qGLA6O/Vz
         z7mfuL+tJ6JjSdVDLZ+G5uzPM18WcikmWo7t0DZVT4Pspzs8L+UiILOlhC2CBE0WxnQK
         XIfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782199504; x=1782804304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cixHBYeYe02mLr64ZFg9yFOYVilxOSWazCrgIgCACI8=;
        b=W5CSmwwekEyrfWSfvc/Ec1tZI0D0SAPDsp/XOnoziOHwStqvS8XG8H8aVyv3Nj56Le
         qPOwCgltW5B/3i7im8aANMNxPKYNIu9q2QPwyvH+nOfUFebgA570OnMjjIdl+K8sJrmF
         iI4gJbaUfPK/tS9/G4XeQqerS7f28LBAAhfG23TScucnSAab36AawK8g8VrA3j826/m0
         idpWjEHlYuVQnpWmkk0igT3QzgHFUirEDPSBJIc8sfzKfXxDAZUYO4ULs7JGrA488jzn
         v6o1rROA7IiN3ymPSNpG+kJEkFA0vXI+kS5WFfIGwQMmJ6L4v78h4Dvnt66oHqyt/1iN
         JuWA==
X-Gm-Message-State: AOJu0YxZ5jz33jWWuSTW+f3zsG0w7wpSA6NqHE3JHu/++kmHIiX5UPo2
	IeMES1KV9zAPvZXFxgMmFOuX7mY1/HbtU7FToHJRiurZOYg71PvRg29bw4/2EQ==
X-Gm-Gg: AfdE7cnsuauq33xWLJB6/sZ8xdtH9urungVde9p6RWn4RAw5nHoGLtDyuYrRQKmcGgq
	quw1krU6hMrizc74U2ZYz6+SiDJQbIhqT/oMTtTA+7OSaDHhK8cPbPn4tDhWvV4qGqzehPRXQNS
	7CqtMqOrlJgtH2/XtRiIvbOUIxR0FUN2cGXtgLIoOFzM13l9sXwy194AEdT7sMHl2fpEo7iHBf0
	uS9xXK3LDTo6AJXjyx2/WA7uXn4TXaC4McJoeUEIf1Wfyhq2zb0MYUm9vl8OPQWUqhxKrL/+ftx
	UQeGFYHgshY0hOXJBDU2GHkQj6x7llQRtWt0mCl7U59wMLbDdVCoErI3kKgmyxNBcdt6wPScVg5
	62On+dIPWOiDTahY9sIRNx9AUGhQcDjyFEu4ixMNK8Un+4bTMW8zPeftqpQykOBkV7RoMspzndq
	FTTOXfaFabBHWG6NCq4m1Srbfx6ePegO3nQ2bTQkXClGc=
X-Received: by 2002:a5d:5c84:0:b0:460:1378:7b0 with SMTP id ffacd0b85a97d-46a7e9f3dc7mr3809613f8f.5.1782199502728;
        Tue, 23 Jun 2026 00:25:02 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de ([141.2.113.173])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46666c57afasm34278743f8f.29.2026.06.23.00.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 00:25:02 -0700 (PDT)
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
	linux-kernel@vger.kernel.org,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH 1/7] md/raid10: fix r10bio leak in raid10_write_request() error paths
Date: Tue, 23 Jun 2026 07:24:50 +0000
Message-ID: <20260623072456.333437-2-abd.masalkhi@gmail.com>
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

When raid10_write_request() fails because REQ_NOWAIT is set, the
allocated r10_bio is not freed before returning, resulting in a memory
leak. Free r10_bio before returning from the REQ_NOWAIT error paths.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-raid/20260613184042.BCEC01F000E9@smtp.kernel.org/
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
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

