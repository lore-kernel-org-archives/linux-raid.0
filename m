Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31E03D34A4
	for <linux-raid@vger.kernel.org>; Wed, 15 Apr 2026 14:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776261814; cv=none; b=q3lDyxjduAooYoKDF1G8A+lmBiLgaiUu935i3N7UNTOMo5MfUxE+n7taPqvj4GvGOzydq0YM3fVBEIHjN00g02g3IZDs2hTJG7waO/dE9Vaq9pt0IBGxb5KA0F2qeAZAyIExL/eNoVddsNHMNabc/wsOMnzkz9sz21oZRKFWWCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776261814; c=relaxed/simple;
	bh=xZCNB5AGwD2i54N1tNoj/rxbNf8IRBctcXt31dr4tTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Awu42OnIxVsX9LjWSd1aNZnaLir91zFg8iZBuuTv7whxwnmrR4v1p7LvA5yDvE4yF2E/fuUcwn+M/UW/lZtlA05CK/wP/KQesnz3huFIvZ/I+ShTZgTpRgqzL5J5D+ni28kbJgWDUi82nVdFM1v1YhyeixpczOhBFdfV4XaW7l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pOonx2sX; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pOonx2sX"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-43d72875729so2501086f8f.3
        for <linux-raid@vger.kernel.org>; Wed, 15 Apr 2026 07:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776261811; x=1776866611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M+9O+2yusy0azBv2IUrWWCy6DoGfMuUXE30z4MsaSig=;
        b=pOonx2sXmZOoOgRUa7tPERmoWq9kdFDNTZbk+feWAxRRWO1z2E96oBp62QgCfjHxUI
         jM9IQhIMsdCos6idTsvfi+Ofy+hVvUK6PPcJ3jg7mMdGWH8GgXIwZVXIfinlD/DYfmyO
         mCUVeEgyOTUTANPrjGtDe+dumdw/+m6zvmYepRc2namW68/Y00NQRnX3qtk7nTPax/45
         7VKtqt2mFNIvzJiAcHz2Xf/HlXviva1/vGVO+54Pf+QE/FV7Lzh1ZJqf2SNbjU6jY5Ji
         RJRswbSE/f7GbwhAjHEQFF3KmzOYVlJoKIiBRgIJj40T7ryknRzRld6iSuf5h/cABJdi
         /fWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776261811; x=1776866611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M+9O+2yusy0azBv2IUrWWCy6DoGfMuUXE30z4MsaSig=;
        b=m+yZ0Zht2WIyr23JjbXTspiBThc11P5j80S2FrEZ+3Vl8qYaEVVwkrmPnJVYHCFqsz
         vKfAu/OaTZ3Y9ndFeLYlqVTZJ85So8XM2tM/H5fdRG4ukKTEOPiDS5KOsvEUZO9BBR8R
         738ViNew8I08nCfAXxBitgeEpqxuWDMG+1hTjHf+mkGceHyRBfK5433audg9kvyKjAPA
         kiDSiGuplX9dCfg1WQnaljsL88ifQQ7tXZlzAlXGwrigl4I88gI9oA+QwKk1yJ+mV4jV
         8KSxlLxoljzX4uhYy46gS5y5mleAQ9BU4dP9Trt+DQSHPr1wTxSFk+Bm3juHIBCflf3D
         Zjxw==
X-Gm-Message-State: AOJu0YzN0e0Oo3993LgA0SkNEeRPFROXDD2u/KA1oECLobgeB2Tp7D90
	kZdM30LaU3MJgvgyEycg+kuD/7K7vfkNHPCf5N63GMPMDsN4c2Te3KqGZFamfQ==
X-Gm-Gg: AeBDievL4zKfXocID7tHW/jqFZQlkeuXxGzV6X/NBcywc2+Ims13wFiYe/lM+Hoib5x
	70UWRpz2Bsb7ZfAz3cOtxPqdZaSAsW8L+SOQwz/gt+FkJmY6p9Kwk35sJqSm12D96r7QP22MaTL
	SwUOlhHXG8Lw/sHSDkB3TUQkX5nlYqr2Kto8zZmJxTeUhHuRzwWThdfxdHqqACieIZ20PQ0vBiW
	L7cMowjU0F/kAE0HTD6X3hlZCRWg8WZ/4c4uzXuIJ6ltqD72qRdGOlxNl4q2TLToM8ZZ4aBCBet
	8AXfJq5Y+lY/BciRojFowGmRZpWe847zwFIjofF0xTtm8LTTNoVgLv+nuamlOjG4qHq4DpFmkgh
	uBKN3gE9JbbEoypmD4HVCiJHKC1vgNOFvddGioHgtXz3tRtBokyUrhlSc6nZsJKL5CfsO7i6vLo
	6BEjf6mqSrjF9W5BG6z1hn2U0=
X-Received: by 2002:a05:6000:24c3:b0:43d:762e:76c6 with SMTP id ffacd0b85a97d-43d762e7865mr20314195f8f.7.1776261811135;
        Wed, 15 Apr 2026 07:03:31 -0700 (PDT)
Received: from yocto.. ([2a02:3037:600:3ec1:dc49:d3d2:7f37:6734])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead3d5f11sm5883236f8f.18.2026.04.15.07.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 07:03:30 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH 1/2] md: replace wait loop with wait_event() in md_handle_request()
Date: Wed, 15 Apr 2026 16:03:18 +0200
Message-ID: <20260415140319.376578-2-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260415140319.376578-1-abd.masalkhi@gmail.com>
References: <20260415140319.376578-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The wait loop is equivalent to wait_event() and can be simplified by
usaing it for improving readability.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac71640ff3a8..ba2b5fb2740e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -397,20 +397,12 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
 {
 check_suspended:
 	if (is_suspended(mddev, bio)) {
-		DEFINE_WAIT(__wait);
 		/* Bail out if REQ_NOWAIT is set for the bio */
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
 			return true;
 		}
-		for (;;) {
-			prepare_to_wait(&mddev->sb_wait, &__wait,
-					TASK_UNINTERRUPTIBLE);
-			if (!is_suspended(mddev, bio))
-				break;
-			schedule();
-		}
-		finish_wait(&mddev->sb_wait, &__wait);
+		wait_event(mddev->sb_wait, !is_suspended(mddev, bio));
 	}
 	if (!percpu_ref_tryget_live(&mddev->active_io))
 		goto check_suspended;
-- 
2.43.0

