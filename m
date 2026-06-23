Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A1F3C8717
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 07:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782199511; cv=none; b=kan4kOt7tR4AFoau3DPNJQwDQGWSIJfIAWTqvF/XwkphIo5deUKBU6WJRR3EKo2IKv+11aG03BKqXOMJKBSfZiYbsBoomogFOnGlrhrIDNt4+C8bNxdT2F2/UlDTnlIS8hKulDDpMAtQFmWG/D9/T8cYab+taPxvI4IT0R//+8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782199511; c=relaxed/simple;
	bh=Tf65jRv9T9pqleNRibnCWqQ43RxeQ07aFOoUy7y9BsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGbg1ucndi2DH5dwqB+v6JrrtV36+WDrbSYw9eii/Vl1ZnZWENizTEoyxUGoh9Vg0FpDwsuSQZyYSf6CjJtnLgw/OZAWBnhKNQzEWoZw3mWh30BPM5ny4Mv7czDeHFLwsTGgjkbGzY7NHxaGPBu9Prk4EFJ1wtZHInnlyIA10Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=maClWFuj; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="maClWFuj"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-45eea68dd6fso2611116f8f.2
        for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 00:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782199508; x=1782804308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SreigGRJ0f8Yys6hesZPmI6HAXoV0TV9U6A/rcqRU/c=;
        b=maClWFujKK5qkGCfDgWyhbeHZBkuwNjbzQWO6BH+tU/ou8UL4x1I7zxVTDtpkK6JG5
         h7eYHsKO22/ivNGlBo7R/CDEp6Qjf9cgNJse4fXYi9hdpuV1HIibmDuBOOMKf3HoR2//
         VLk1XRNlMvhfgZI/fzN1lArb90QECtbYVYykg/n+0UNNMXAP8VRjlp/euGifl/WNa44n
         36wPRPVL1HVCdbJxTAfDb6Mq/dyEc+fidx5XhQBi/CfFVL8Voj1g4lVCrZq+eEv8G0gZ
         1yxl+f7IMTFwSdtktHFFcBygAKkIgT96M9u0rit3T5KTqgs+cBUR2WMqyix+GaFmwP1O
         ocOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782199508; x=1782804308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SreigGRJ0f8Yys6hesZPmI6HAXoV0TV9U6A/rcqRU/c=;
        b=YQ+46NsGNo2uRlLH57sLA2inQId3chJp67UTGFETLp8UsPE5xmlYrVYlpsWMSATK+/
         zjbLgLQAsUrzpXowF83hx0i6YQCCtExnq4OD/xYwQnfTwUW/EVm13ay2dz9eyAU9TDU7
         Iis+U4SN31J7UxFJNDxzdk8OHz8K2wSst5hj0wzT5q9+0prf9hIvWUO28yW56FjHCtvq
         lfSmjUprkEO6XcdhUuCTKp4hX12Go9WKZqNP9zz6/rKBadVYxraOYOJw8AkMe2VQd3W5
         i2pUgHsaYBDrngjeGf4y4JBaSj+nLrR6PsdHdFt0tquF+bJq+yhO7EpOxFPegey5GpgZ
         r+1A==
X-Gm-Message-State: AOJu0YyOPCPipnTVO+lNkFaRASDi9ITgi+8HpaVVZCuqozJer4VgZDQ1
	aKRYSx6mS2tQ5sqjBqd6pxYzfKNCIqXVQ8j/pZ9n/Gq5wFx3M/QOZnoS
X-Gm-Gg: AfdE7ckuqWOAmciLExzWV3YgP4CYFGw59ZIa7w/frUxwe/FxIBgk2M3OEQK5Ik6okAs
	p9AlRUIFaOzhJ0mdrRDXZ78WRat/vYondZPlcX1CmrNEChhnnX8QtQUmCxqU4QvZucbVugAYGqb
	I43AzE4cr34AA3wKMr95+SVaupk6bIlZI2XNjnNcwLu9DxocrYXRi5hrFMKZwEOOiaMnGCAlMGn
	rwgn7BECnXQB8sGdtnkvJCeyxdLz6ERfm2VwYeKlA/E4UbwcdL/+/jWhGKkUJzjBQKAgoy2tSgd
	jOgI27hXwv6vV1b9kb/wkA6wCVr1FOKLLwYlpi0PM8dSyNRt3lCHtz2pP22D2/v8atb1Hj04d6t
	lSSpRK9lSnhfBkm9aU2TIQMuHCdKjwFEdaFT2tyhmqY8HeLLWJ+e9jIv4BZPnjrObIjC3LyrsTP
	sJnsNEZNjgE7W2uw8eGNMQmhWJiUtQ9Wgm
X-Received: by 2002:a05:6000:4703:b0:461:a159:48e9 with SMTP id ffacd0b85a97d-46ad95c1bbfmr1997987f8f.17.1782199508235;
        Tue, 23 Jun 2026 00:25:08 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de ([141.2.113.173])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46666c57afasm34278743f8f.29.2026.06.23.00.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 00:25:07 -0700 (PDT)
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
Subject: [PATCH 4/7] md/raid10: raid10_write_request() drops the barrier before calling
Date: Tue, 23 Jun 2026 07:24:53 +0000
Message-ID: <20260623072456.333437-5-abd.masalkhi@gmail.com>
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

bio_submit_split_bioset() and reacquires it afterwards. This is
unnecessary because bio_submit_split_bioset() does not require
releasing the barrier protection.

Remove the redundant allow_barrier()/wait_barrier() pair around
bio_submit_split_bioset().

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/raid10.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 840f0446c231..4bc1d5553ec7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1493,10 +1493,8 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		if (atomic)
 			goto err_handle;
 
-		allow_barrier(conf);
 		bio = bio_submit_split_bioset(bio, r10_bio->sectors,
 					      &conf->bio_split);
-		wait_barrier(conf, false);
 		if (!bio) {
 			set_bit(R10BIO_Returned, &r10_bio->state);
 			goto err_handle;
-- 
2.43.0

