Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73C23F9294
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689815; cv=none; b=X2yExq7bV8wXmeEoUlURKG+pBDctRCnzXkcQVkBoTENiPBvZYQHMt3Vn8rBEDUxxjNd4o4AGCPDDkKjpiTZAwTtj+Hd7UgIrlYnUZ+NLbVulUrE3Bxcu8Yt8DGa/rPil7pqgk4QRvnMz4abAryY1lz2JJ4xghGRtDWECuJGfqoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689815; c=relaxed/simple;
	bh=BfLl/q18W5yYQeIQBruV/e9ZpSEUmlct7luvOzIpmgw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YAlQhvtOv/l46nYRqa7h4HBIW2+xBNU0xVo6yoYAyitwGpI5w0XnEcd4PixeZIxQpopTMLybC9uE4CoioXcMHyR5hyPPbF8bhc7xmpkCTfL/gtFQTPweih9YRfZR9TP6ajmBsRF2TzEGApKHPcbG0FzE2qkj37FUyL/xZPlr2A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qtnHLtb8; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qtnHLtb8"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-385ea3ce80dso1110521a91.2
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 06:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783689814; x=1784294614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3/61ccPKf9iIkSXbLxMl3TYnG/v8KEzCfxESbxzxiVk=;
        b=qtnHLtb8chlKKl7AryktL5YkPTtK54DmAbFF2X90K0yha7ykXNIz7RXiUayY98QNsZ
         RC6m5uiwS/jCIUwtq0ldxgOqr2kSXXfTUpvu2p0Call2pvcWUYfKfW7GIOKX7KFRji5a
         i0AM6afPXGEx18pJeyFNRZ+jI/khX6Pp/FmOm3C2pBXPQbvcaW+mhnfMBM+GkoU9JU2Z
         wF4CIRyQUVNaDp1Bw37BJB18+HVywoQmTDO/cZ+qFTKwz22hszx5FuK3HfwDF+erwRrn
         Tlfimh6Ows0EYU29N0z9vPB2ihMhFU5qD5O1LesOmddXDy3yiSkgoo6wL5Wjy6CFvend
         2yhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783689814; x=1784294614;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3/61ccPKf9iIkSXbLxMl3TYnG/v8KEzCfxESbxzxiVk=;
        b=h1yBRF98YmA+xDtq0HyK/eCCCQn4O574kuT80WscDSlvkk7g4HNWH/9dtMYRSPylss
         RUGmMB8ecFbfy0LZSK3/a+QwPtiMZe/JwfaDbWgZH+F2KCkEW8MkLUcwhEnmiLyMabPj
         ahzJEYJph/p6m73SazYuAY86lR+JCKtLRVWgSBhL+kTTUYPYPnypWZ1gMuYqwQ+68kLe
         DpXhSlriEPqNCrgneYZkyzQaVu4THFFW4rBN3/+pj4o6Mm4NWuhdkXGyL/3tvtv9IQfs
         O9GTx54aU+fxlR092w9ZKukpVSMGcmcUFbBZE+tWOiPD7LolfLaW5+zRgNDTn/nuGEUr
         sKyQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr59o0j53h9pouFSOVdFDpWMsChCRygtjU+bxI8vpU9stFycAgxy579eHotKP2nz+tTytJswE0f79Q2@vger.kernel.org
X-Gm-Message-State: AOJu0YyIgwtxox8V+KBZT2GPMEUteAmuJeaa58vDHT2OaPlEs88GgBJx
	17L4PJBK4Q8mhVeyah6hBX7QmSJnFtmyVcY36ntwtp8dPcj8H9Wfvee5
X-Gm-Gg: AfdE7cmfYTCIM2xRjyiZhBFyH+UgIqqObjyt8AWhl4X3biRxVzGSGYR2oE5pLKrE6xh
	+zvl79ODDbnnTCrnzvHT0/zXAt6JqsWe1Q8TANYy6HPO0KVS689sUoHDdaz66ep1G7nvMDirRua
	GOgq5Ws1W8h92A4F1j3Vk5YJeiZmFlr++8sRwcm1ljrWf32z7BD1aSTWgO0B/dvYNyMwgSz4HTT
	eOY3oO2jRoLK3kxdJc8GzsxVbuVL5CEFt4p7PQk7QYa1czte0Ffj9NDG0NeR8ZYJMZzd39nPatD
	fSIVso+gYTDgZyWYVDTbcLJIHpD2NmPZpnnR9wiy4kBXghIOZRNz0mgke00fmcLfAuCMrDjV/nJ
	+UVPugC9PSg9N4CQ+TVDNGiYklzdZCSGkppI1c1KK7HuH850d9nkYzRnjg0x7Q64c0xKdkZLHX7
	gL1zZ7i5ee1vaNUyYzB8+yCrAhWhc7z3/ZH9clO7zIJMqZS0k+vAgHBCm4J0GFKZpw2CKOx8KA4
	S0q1UQ=
X-Received: by 2002:a17:90b:3b8d:b0:387:e0cb:7f3 with SMTP id 98e67ed59e1d1-389428905bfmr10738596a91.39.1783689813878;
        Fri, 10 Jul 2026 06:23:33 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a55b413e6sm2710798a91.8.2026.07.10.06.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 06:23:33 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 0/2] md: widen size/count types for large arrays
Date: Fri, 10 Jul 2026 06:23:27 -0700
Message-ID: <20260710132329.7273-1-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two small type-widening fixes for large arrays.  Neither changes
behaviour or memory use on any current configuration.

  1/2 changes chunk_sectors and the stripe-cache count fields to unsigned
      int, matching how they are used and avoiding implicit sign
      extension in the cache shrinker's subtraction.

  2/2 widens the badblocks sector parameters from int to sector_t so the
      helpers do not narrow a sector_t argument on very large devices.

These are independent of the other md/raid5 patches I'm sending and can
be applied on their own.

Hiroshi Nishida (2):
  md: change chunk_sectors and stripe cache counts to unsigned int
  md: widen badblock sectors param from int to sector_t

 drivers/md/md.c    |  4 ++--
 drivers/md/md.h    | 10 +++++-----
 drivers/md/raid5.c | 14 +++++++-------
 drivers/md/raid5.h |  8 ++++----
 4 files changed, 18 insertions(+), 18 deletions(-)


base-commit: 55b77337bdd088c77461588e5ec094421b89911b
-- 
2.43.0

