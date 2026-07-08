Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0371532860B
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 10:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783505629; cv=none; b=MImzqAQha3hAobZ69S8HlpTf1TSdiq73DjlwiDRa/jjLZG5dIaqXxsC1paVLwfYv6wifoM4WquTdh9izhLV31CspMHic+TEFSjgdDSx5AeGz4D7Bjh92APK7+TV7ttIQuPs4Os9NLN/xpmGuIsvaLZEls6PqaJ3jkPXC04OUzMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783505629; c=relaxed/simple;
	bh=PsYynXD9+nSYwecgoZwFjl6GaWCS2ncXLqqXV0fwV4U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y/OGVbO+jmeW/hI5J3M23/PbRIRpG94wvdkhKM4dUonRBlkRbce03vzUQTdrZQlW6qll4NcgfDOkxSnfV5lo+J7yr9Z5Bmc3hkionGV7glmcRYi5cwroltln9sf2MdH9yToLYJOvZNZzaLLt0jx8Wsj2XPdrSoTtrOR+oyFRCro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MudlaTJT; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MudlaTJT"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-493b6f1b14bso1954845e9.0
        for <linux-raid@vger.kernel.org>; Wed, 08 Jul 2026 03:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783505625; x=1784110425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Wm6FaqPvsLyWfsHLvZ/JTV+5QMqw2cZsJHsdz6VbIqY=;
        b=MudlaTJTnR+y+1K2LGznvzwwItxXRKPPPQhBnB4V8PNGKarvPF/4di9DIbWOq77RbT
         PHDdTFq51olE3NdtMiT0P5w89Y9PbHhIyh5RlsUG16qc8ZYQic8bOgxzdoShR1ixcJFv
         oo3jDKWoc5aHS7bYSI2CWusCzuVyZAnNPqIopRtxgCc9FJHkahCaxyE3eWaRSCzpK7k7
         xWqNyj4M7cnR+6tyLWWrQ4oB3ihyn1u93A2GmIdfu5XM1meIZE5at6vdo/BbjIB049GG
         yZ2S2jLQ402W9TjAgtfArWVAi9PHH9guSVc3hqJpJwXqg5MhegTJGEC/ZV026m3lwf0w
         /Swg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783505625; x=1784110425;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wm6FaqPvsLyWfsHLvZ/JTV+5QMqw2cZsJHsdz6VbIqY=;
        b=J0qN1vQmIHZC/UaszfIsZ1RNefeIL1khTYhLHEm4Cc5Lv8DeG5C1pskpyT/Mo9wz0Y
         D4vxigSF33yaBkTRELfT+qJ4F5F1Pkb17hvvroEVB8nWh/g+vqximNwck3UCTe2kOTGT
         UgaR4KEwGJbiqCZapnmyAGWjYJZQeHKIt593FvIDxpme8zbS2TlkQfTFzVVRU7oMVT6e
         Y33jIh4e3xKJp+CPCcazuN9vPOEXtBh64TdvigVNj4VYFxwyEhjxQS6sD/InZmgRc8XS
         Ou2YhsKw9KPofCaykCOdlYEBkfrpOaOnznwzDQXQdJXW4DvOOk7NFYrFBBNaIGDpvB02
         c/Dg==
X-Gm-Message-State: AOJu0Ywoo3zBZd+eZdbwFQ8VDXGLuz6Ym0qirnVzKCTCRpUT5g2rx4TF
	rKSekSyZRcglVQJpuzRyw9U5LrsO0kvPI7s28E4q5BbNBzwJgYxRgLHz
X-Gm-Gg: AfdE7cnD/zm+mx2qRTBzXBdvKNxOaiLqF810R/jlqlhlEZCyClNZUC+1CGvbdeGFwY3
	AsgUGC8/H+tWQt0qiHww+aB1uBY/r29w40+szXoHSvdosZD8n/6tyW12GM/EBSDiSNWNx736Qaa
	sm3yVOjn7b6Jdi73InxsdOLih0nY3TklGj/AtC6+zDca/oqFkmIGeCx8SUCnnjsPwO0opYAqV12
	BMnAzQQWaGjr5q4jYuAXyG2PytFOyHoVHAduuUtH8nDOjLgevU3H6qksw1qsXIM9yH2kHhKkUlo
	+JPHgmjQ5u+KJoFlHR2/zKfXvsE60KCXtsid05iWV4lTxf3xc2R8W/ezPUI4jHgC7YSC9TmPnYa
	UOoGURQUf1teB4jL8MDnfASuVj5PuW5/tdMjzoT/UJPB90JiLaUdyEjl+Bhbg4L3UbK2vc63fde
	EMLo0c9Bco
X-Received: by 2002:a05:600c:8b62:b0:493:adcb:d368 with SMTP id 5b1f17b1804b1-493e6843f10mr19904185e9.9.1783505625156;
        Wed, 08 Jul 2026 03:13:45 -0700 (PDT)
Received: from yocto.. ([195.72.110.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0faee30sm108987515e9.10.2026.07.08.03.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 03:13:44 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	vverma@digitalocean.com,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	abd.masalkhi@gatech.edu,
	linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH v3 0/7] md/raid10: fixes, atomic write handling, and error-path cleanup
Date: Wed,  8 Jul 2026 10:13:34 +0000
Message-ID: <20260708101341.473750-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This v3 of series contains a mix of bug fixes and cleanups for RAID10,
along with a related atomic write fix for RAID1.

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
  md/raid1: advertise atomic write limits and handle runtime constraints
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

