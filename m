Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588343914E4
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 10:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783678529; cv=none; b=St1vqwh8hjbdm2JG3ZEdJCS2rg/C7jg815vGQ0UHY4AJ8h8xvevmWgEsg8h6LHyoyDjDLU5EAMT2QJs8iC9KOQbwCr4UMQ2HxTkSxILC+BYg3cp8sGcgo9jaGALcVfZsMVty6jNabHlhoAVzOERejGuFj+4twKdPKtURgbLKozQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783678529; c=relaxed/simple;
	bh=IXO62uTbH9oI0QLdZgpyiCnPZLzF+YLCccwb9+C5B94=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BczW5T500TNe4z4F5VJh7SR5BqED3kEKG73dfO/Bp1CT/cdoPZvNY7qFmwLJl6il5FyUs18cqqFU1S8dH15o8Ak6YS/ArQYid21lOJ+rkn4HbOVJ6NXYK1CeJ8GpLBmfxuRnDRwKb90BCd1K1q4PGJz6OXyQCayGtaW5yJwnQrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ba9kHd5p; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ba9kHd5p"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493f6de72faso751515e9.0
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 03:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783678527; x=1784283327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VfBhQRbsBHcc2qVnCFESBQMKDl7GEiKvTk3RcFz/yPw=;
        b=Ba9kHd5pJ9BzmOFDm+P4POInVApID6w6ZsUjEks/AgVCgRCbjApaD5qd2Hjid8kD/b
         T+SFlcztN7q6Zfp6OB3n6Pj2tYeOnqLN0Cza0GwkHAjewQbWivc4LzZfCfwshHZ00ZOt
         y0VchMpQc8HFs9AtdL3e60kU8Txro+XBSRW4n5I4f5IqVw8Ukxw7NSOM7vhInzPFukbf
         /XGRzCFYPSnEwnJyskC8mmpMXBnQfPAhKUvJ8nkpTiSBdCgdJbmCPPTUYabxvurdehv8
         XaEDr54dor7keMbP9O4XsE4sWiDUfgSq7IJylYyH82TljcI+0K8IFXV+4lIM7I+hcg2s
         EBng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783678527; x=1784283327;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VfBhQRbsBHcc2qVnCFESBQMKDl7GEiKvTk3RcFz/yPw=;
        b=WeCY1SwtKB4F8j2SUsCkUnjmjYd+pGHpqMcuWkWQj3ImH890E9A3JzNhp552JKd5Fx
         kGyqx67P+ex9uPXsZQ8s3Gf1axiXPT10dn11DxZmCX6H1QKHzd2g5+eSvXWnBY7YqBcl
         yNl1gGjWKzYcR2wncBJJYni8J5YvnMqsHgR7gK4ypEUtIz4wf9OVkH90VUgJkP/xM8co
         y3w98peCj7PZ7P/6DKg/bryta+zD1l94r4KaRP6HixDh62xW6piRASu+ns0lo9OMjkCN
         5ZaerfFHM47ZLeWDPSW+nOhLZe2gW3n/EzpCgdRlteN+YtHceXkyGGK3Z457H//V25Gv
         JlbA==
X-Gm-Message-State: AOJu0YxO4g87ErYFP7MJDoWhQqJOo7gpHR//yvHa1EgAykEjhKuUx7ic
	17s2LKR8Y6Vp5P3macvLKSisqfHuROB5KFRDsCN+DKdMVdzqZHsbz33E
X-Gm-Gg: AfdE7cn5Ox/bAxaP0gslRRRU4nBVnigRarghRitOFDRQKmKlneSQOqG4I9cTZfs1b80
	WiRu/0GGeltMUBGBUmw8EE26iMXPbFIYzPENQuwoASOXRXBzQ58FLrShWwAiSSL45v6+JwwIRnb
	+jsSpl3/nGwylhq21XFWtjID02XrFvm5y/gETa8bj+DdcICU0Qka1Z+qaJ6/IvxWbEZRyPRA7E4
	ycyIza7fxX5H6vGWTIwvF6Snr0aFMLI6+wJ02vLQXYU7nuSrtZacCtWEJ4nGrfVFEaHFwqJEkID
	F0V5DRGW0kSBg7v1euv3mXR6KQSrNA4WrLRv9FGQceoPFVPBODnfeM3qZcLpJkBxxrOKeCZSV5M
	WR5LzN82W952KxBmSOxyoiZ2Dte+5NjScgovO6nhRES5futbHPXMRZYojFpwcwo2mPCdao+H4/m
	uxT1QcX8ev63sjatKl27/a5J2/uMgY7q9mOdwgiiIFSG0lLu22QapIySQNLlVNu0Qp
X-Received: by 2002:a05:600c:6211:b0:493:b698:9247 with SMTP id 5b1f17b1804b1-493f2b3fee9mr24986235e9.14.1783678526653;
        Fri, 10 Jul 2026 03:15:26 -0700 (PDT)
Received: from yocto.. (dynamic-176-007-199-185.176.7.pool.telefonica.de. [176.7.199.185])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb670a41sm123554875e9.0.2026.07.10.03.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 03:15:26 -0700 (PDT)
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
Subject: [PATCH v4 0/7] md/raid10: fixes, atomic write handling, and error-path cleanup
Date: Fri, 10 Jul 2026 10:15:14 +0000
Message-ID: <20260710101521.1714-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This v4 of series contains a mix of bug fixes and cleanups for RAID10,
along with a related atomic write fix for RAID1.

Changes in v4:
 - Improve the commit message of patch 2.
 - Add Reviewed-by tag from John Garry to patch 2.
 - Link to v3: https://lore.kernel.org/linux-raid/20260708101341.473750-1-abd.masalkhi@gmail.com/

Changes in v3:
 - Set chunk_sectors to BARRIER_UNIT_SECTOR_SIZE instead of setting
   atomic_write_hw_unit_max.
 - Avoid enabling write-behind when the atomic write exceeds the
   write-behind limit.
 - Link to v2: https://lore.kernel.org/linux-raid/20260628142420.1051027-1-abd.masalkhi@gmail.com/

Changes in v2:
 - Expand the commit message to explain why the
   allow_barrier()/wait_barrier() pair is no longer needed.
 - Drop the early atomic write split check from raid1_write_request().
 - Advertise the atomic write size limit via queue limits.
 - Disable write-behind instead of failing atomic writes when the
   BIO_MAX_VECS limit is encountered.
 - Drop the early atomic write split check from raid10_write_request()
   and rely on queue limits instead.
 - Fix a compilation error (bi -> bio).
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-1-abd.masalkhi@gmail.com/

Thanks,
Abd-alrhman,

Abd-Alrhman Masalkhi (7):
  md/raid10: fix r10bio leak in raid10_write_request() error paths
  md/raid1: restrict atomic write limits and handle runtime constraints
  md/raid10: consistently fail atomic writes that require splitting
  md/raid10: remove unnecessary barrier around bio_submit_split_bioset()
  md/raid10: replace wait loop with wait_event_idle()
  md/raid10: simplify write request error handling
  md/raid10: simplify read request error handling

 drivers/md/raid1.c  |  25 ++++------
 drivers/md/raid10.c | 118 +++++++++++++++++++++-----------------------
 2 files changed, 65 insertions(+), 78 deletions(-)

-- 
2.43.0

