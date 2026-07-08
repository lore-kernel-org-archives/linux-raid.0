Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF414048A7
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 08:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783500556; cv=none; b=TfgmwcMtR3LCGmpKT3vctKlakLPfOxlRXnVzMofv3VKPAs9Km8erhgCO+FQR6Ds9OIgwH7BQLHAwmmySECMy7TN+sGboyDKORobL6DH8RQx2yOa2g4z3PhcRgbJJS1D8LvNR5uJjq9QxmSmqa8aevuAp2uQjJKoSdHdrMosDJok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783500556; c=relaxed/simple;
	bh=CjohiO+dqMRGjRDKVlufqxdXnNaBPKZAqLa3pu11X5E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mj/kzsMsxSZB7hmGoLAwqgt8jSg/YlrRzSaDc9VHbwlExsdKQ+BNqoTKmvWgsTTVMBOmb9Qe0nKvns/irldm3HTAjJG+leBhTUlVnzY/7stuX44fxI7SeA4s/Lu8+jIp0pXhPiB4pWOFiY54E/I4m4/6xlArJqioJFYSPXa3rA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NkxA8R9d; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NkxA8R9d"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cce6a0c9c3so4914345ad.1
        for <linux-raid@vger.kernel.org>; Wed, 08 Jul 2026 01:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783500554; x=1784105354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S2atXC3q4fE4OqkyNTQzT9VeYJAnSdOqbguBhd2DVe0=;
        b=NkxA8R9ddiLM5gf+tJwHGVOUV5SzafnKO3si/lx6AZsZbT2aG3gWdKFXW+kBRJxnwL
         DPXs40IKc43eb1TcVyLtvo8eAxQ3wrBoPnoaC0vnWMJ1ePqFeNtWmjGMavNWumztR9RD
         /8PNAqwURPj1elCNYNGGSZGdVCzcwO6p6x923SI6kDlf/tSkV8pZ0k/R+lb4jGU6gmq9
         aE8bPElTko2wbhkk8800U7aEYkQ9CtKEfuBJxEtxaDzxkuwGoJ4fQ/h0G6TJRNn2+Mhe
         aTcSCynWHd/7ckQri7Rx4Qpix32LUOIZDUXTxMNaR+fwBRoeqNrCnzOCC4vTvtrixiVE
         DLsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783500554; x=1784105354;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S2atXC3q4fE4OqkyNTQzT9VeYJAnSdOqbguBhd2DVe0=;
        b=ir3Anx6n2CbpJxd19g0JGhSItE0g2CHeSR81/09uQr+8w6ahQkk18GlDdQ3CHS8AmF
         SQ8zS4+hN3wesVOmK1FxlmOR2m3+0GogD90z8v7UK6Vn8zvauPfPmDXyHsIU1E0/hJBb
         ko7QtZ2smt+2j/gM3s+A6dYm6ITBpu+lGfYYaNzbAgXQ8rFkVYh8ayOQp2M31LeTlrFK
         Q83bgXKIuEJTCCkXo9sCk31DM/GGvWZhEuMFpEJg1sHZDpQJfNXAElrMG41xPHsLeSn1
         rUCflgQ84NNTk+sk2y9GU+K4qnWxjjgBgF9oONbLnz6NeNdfD/s6cfaefx5UfyGRGQRU
         5Muw==
X-Forwarded-Encrypted: i=1; AHgh+Rrv8DjUzLVyVeSjXslyySKEOIgJnfSxWqc0DWaODNoC3QujOLA3kRYiBwj71CKtfnePRG8VEYKL30CZ@vger.kernel.org
X-Gm-Message-State: AOJu0YykcQl9seDeMvLrm3j8HX7eln7h5QutL9hbVXLFBrwmFFwmjhVi
	KuJXmdlqHdNhIkFMqOHxcd6P3dnmVs5sZ9Ua7T77Yb+MdlYH3ds5fcrE
X-Gm-Gg: AfdE7cntK3/BQydaNVrkdl98fv9tV09lM8b4D8oVUIqXH1m/ufyWhW/S5OFEGH5LaLU
	eFLwqXDaqV8ov1CylRY6ieEIb74wCUIWjNqTuTiqrWzsZ5nhPRI7t1vrA/OtUKatOv2i3nyiIqk
	dRMCRAba8JWDRuoxMA3spkpj8xbI+oXCulVuwkRu9hlzAZxmUTG/HOG5UkGF4AyZ1K7oBnDLFsj
	caZF4iIrlq1NXTmVKS/icb2YcHwE9IANat8LCgss51OACKb6q9lOOyC4lImyI8bj84I3u0+eAgv
	Om7hALg0vkh1A3O6ruPhHjOwXQnTWuy+dtwRh55imi5mubg4EtL8Jstu/7xnYOGbpO64BVABkwE
	6NdAbyB5iO1mpWDM5blTKGj2TMX22r3EZn48aym3kfwAKj/jwtVyedeQZ/rsHBVySdgHvXHmz7u
	6k+B4L2g==
X-Received: by 2002:a17:903:4684:b0:2ca:9ab:e723 with SMTP id d9443c01a7336-2ccea481a57mr17263475ad.33.1783500554279;
        Wed, 08 Jul 2026 01:49:14 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1000::f280])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bf77e4sm24536395ad.22.2026.07.08.01.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 01:49:13 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Josh Hunt <johunt@akamai.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] md/raid10: free r10_bio on write NOWAIT exits
Date: Wed,  8 Jul 2026 16:47:01 +0800
Message-ID: <20260708084701.737763-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The change referenced by the Fixes tag made a NOWAIT early exit in
raid10_write_request() free the r10_bio directly instead of using
raid_end_bio_io(), avoiding an unmatched allow_barrier() while still
returning the r10_bio object to the mempool.

The same function has two other NOWAIT early exits. One is before
regular_request_wait(), where the request has not taken a barrier
reference. The other is in the reshape metadata path, where the barrier
reference is released explicitly with allow_barrier(). Both paths end the
bio and return false, but neither returns the r10_bio object to the
mempool.

Free the r10_bio on both NOWAIT exits. Keep the existing barrier handling
unchanged, since only the reshape path has taken a barrier reference.

Fixes: 7d96f3120a7f ("md/raid10: fix deadlock with check operation and nowait requests")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/md/raid10.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a3cfdd3f5df..d480344c5b8f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1364,6 +1364,7 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		DEFINE_WAIT(w);
 		/* Bail out if REQ_NOWAIT is set for the bio */
 		if (bio->bi_opf & REQ_NOWAIT) {
+			free_r10bio(r10_bio);
 			bio_wouldblock_error(bio);
 			return false;
 		}
@@ -1397,6 +1398,7 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		md_wakeup_thread(mddev->thread);
 		if (bio->bi_opf & REQ_NOWAIT) {
 			allow_barrier(conf);
+			free_r10bio(r10_bio);
 			bio_wouldblock_error(bio);
 			return false;
 		}
-- 
2.43.0

