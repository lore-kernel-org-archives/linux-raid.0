Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485A740759C
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 10:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783678579; cv=none; b=fGwcQV7Tp2STJ9v99ELuHm+ZmyZ9g1ZGPonDNS6+PHsBeGlancgKA4OSf/UUQbetohMNTpD02Z+4DQmbMSG3U4NrCZ1vIbppydemIYV5zGUH73BYqb98pnrBeLNIMjQcZrZH7iKD09o0McYdlwZYYDfLTFM6eVcXFUPDVNYmr8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783678579; c=relaxed/simple;
	bh=N2/4bpj+Xkr951tLE4PruUTtiurHt1Y/kuwTFiLb83c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLl8tdVH/UCRKk4IJVLLoDZW4aqLfRluA3SXJXc0QSc2+D+9FEU7leyHwaMq87ABe3cCvHc79gbUu5vWYCwTAMSp1PcF1vl1nXGA3x0nhXE9RB8tIII9NM1mIvaFkZDG2jkCa3xv7u+lLptxe/Jf53oFOkxFPzLsxUL8Ah/pqv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JijvvJ7m; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JijvvJ7m"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-493c2c0b9a8so6353475e9.1
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 03:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783678572; x=1784283372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sDXS6mRL4qrhgTwIfHDccn9N8HWpnmgy7FQ0KITOahY=;
        b=JijvvJ7muYI6KrG9+3FagUnEQJzoooODlQzWawGYRtuVpvTuiwNyk+tZGg+82VAeOe
         fs4T2zmW0Mk3NNZ55gry4C4/hfoM3NbBiuMcoQqnRjn+yHoxijuy4oNcOWXcTfNwWBi7
         58jLwPc4aHOSjHvdRZ3DjMc9Gbogt9cJsCKsXhFnEa3PiHJepnjoewkBo0F8kwFaLDVQ
         M7ZMFU3g3SUyTwCmW4uWeqKW2mzvdP79ctoo4D8QMCmQ+hu1ol/1lSZTvn6vySoiecQK
         hXXSmdaVMqmSnc/obbWQPLcV/k5F7xgEuyIpMoyMsk0ijJwDpyMBgjeyTuzT6yBxMEFL
         DOyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783678572; x=1784283372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sDXS6mRL4qrhgTwIfHDccn9N8HWpnmgy7FQ0KITOahY=;
        b=OctM2ZdWSSbDY3Qi18GplAXOAUZdaB3U21l/nhLxGBJoxXk/8jwWMqdPOW/PknqwiV
         jKvLTdoAVBhKXPkftvRqAzoYCqcvW5ThyiUZFT8IH2M40QY1gBuxIvN1REiAaPK+8yCB
         qrM+XFjdx0TIj/LE8TKdyZ6z0+vSsFQ2wXaxm6p1KAbTCH8HRFcSYNwsivHWULqkKPf7
         TdEkjGb3WTYrMohknk+/+EWDwTQEiaFeedkiKrgkyXp1Bf781srNW5kQJQdeVAbneC8k
         0YJKqeC0FPlHztTOdpurJSztR2zRasyqHlM3HBFq5Qq18rd9yubB/BWdNPBJQHJ/yNHe
         f4xA==
X-Gm-Message-State: AOJu0YzDVDZNtIEpt2gphz9k+8JiX8E6YWZIOGm3uKbDPKsluB7y7W8+
	QvlMXNmHRTTZmjl2yjRna/z1S+u8w2gJvMOL7ta0Dzpc/Kt1nd4zepG6
X-Gm-Gg: AfdE7clRJRQKDS+5Hb7UdHEN19LjAZxmnkllyVl9mpaXjr7z83PnOBfVf2hW5IRmLPP
	HoxWyNbA2aR1Jpvj11bqcZsFj1PKTzu6DEAORQgJHrwmct56cfSYlCo6bSwL5jGVekqit/xoLip
	9GgCx7Ri/aiG7HAm0iL9ww/xAcqVewZOdhQY+kUCIWwP7VH/h7SBQ6Uc+xEMR/Sspq89BdY5N8T
	7fdXTSv8bVxVdhXu63hKoUcxMNV4eP9NeKMeILlMZ0ILY5cefNOBxGuQQYGD7hb/Y6DVWx3/alO
	NQouzbVtYxon0fO6osrS8ULb7DakArU9bKdBkm/byhtnfbE0LiimED5M01PhxQ1b2OQUdz9C6Ii
	ceJRRULMh+16uYYevFYZciqGkjqcyqJf0Yp5TXct++ICjuMcAuFKejEVOzdPLEOHwL8My+TGYnx
	YMDrP0r9/0HHNmkQstzjXUUjcJ8ZS0BRJEaFPHLFxjjM5MULBp9nM5saquA6C0GglG
X-Received: by 2002:a05:600c:828c:b0:493:bed9:b53d with SMTP id 5b1f17b1804b1-493e68ee07cmr95833595e9.31.1783678572187;
        Fri, 10 Jul 2026 03:16:12 -0700 (PDT)
Received: from yocto.. (dynamic-176-007-199-185.176.7.pool.telefonica.de. [176.7.199.185])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb670a41sm123554875e9.0.2026.07.10.03.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 03:16:11 -0700 (PDT)
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
Subject: [PATCH v4 4/7] md/raid10: remove unnecessary barrier around bio_submit_split_bioset()
Date: Fri, 10 Jul 2026 10:15:18 +0000
Message-ID: <20260710101521.1714-5-abd.masalkhi@gmail.com>
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

raid10_write_request() drops the barrier before calling
bio_submit_split_bioset() and reacquires it afterwards. This is no
longer necessary because the split bio cannot re-enter
raid10_write_request() while the barrier is held.

The allow_barrier()/wait_barrier() pair was introduced by commit
e820d55cb99d ("md: fix raid10 hang issue caused by barrier") when
submit_flushes() called md_handle_request() directly, allowing re-entry
into raid10_write_request(). Since v5.2, submit_flushes() has instead
gone through submit_bio(), eliminating that recursion. submit_flushes()
was later removed entirely by commit b75197e86e6d ("md: Remove flush
handling").

Currently, raid10_write_request() is only entered from the bio
submission path, so the split bio submitted by bio_submit_split_bioset()
cannot recurse back into wait_barrier().

Remove the redundant allow_barrier()/wait_barrier() pair around
bio_submit_split_bioset().

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v4:
 - No changes.
 - Link to v3: https://lore.kernel.org/linux-raid/20260708101341.473750-5-abd.masalkhi@gmail.com/

Changes in v3:
 - No changes.
 - Link to v2: https://lore.kernel.org/linux-raid/20260628142420.1051027-5-abd.masalkhi@gmail.com/

Changes in v2:
 - Expand the commit message to explain why the
   allow_barrier()/wait_barrier() pair is no longer needed.
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-5-abd.masalkhi@gmail.com/
---
 drivers/md/raid10.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3480fc7907f0..2574f60dd771 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1487,10 +1487,8 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
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

