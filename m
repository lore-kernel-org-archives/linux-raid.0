Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4EC42CB12
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689825; cv=none; b=pOvGV5OXCYuuAPL25OEUTRzFD8SDFRfMDv1Osq2P0w8ZZ5Lj6AdwxxcsVs0nz1/MSPWYuRsRsiYZUtv/fksFLjAiC0DQxH0Tj0pBJU2ADEWsqpm1m9T9CeT8DBFKkV6M7olsh0qMEIFxKCeIvVCX/FHhyDUyqpN7jVsNvpSgmLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689825; c=relaxed/simple;
	bh=pVPc/9i9ANSvvvjIAq97IbRyWohHAdOsPPkZd28l4mk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iLOTBdY9VNSY02mSr8ITP1NdExEzyUbg3bvPQFUmVfJChmLlWDtIpLhZdCGnKkQPmQYNaJx4qLxy54/iEY5fpGh2yGFvj2tbmq6w5fCuQ5EfCJsAGGUj+lE4I2+OUZfe59zJ6p4j3IE+kGPg14+BaWKvuicteaUcxlecC9BOR58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UGpIWV/n; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UGpIWV/n"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38101f85591so1496110a91.1
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 06:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783689824; x=1784294624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QOCrfdDRUfE+tF4OzVq2YVwdlj30R0qZyYamfikbedI=;
        b=UGpIWV/nmenK6/Qy9/jWA8V5PFyblfA+Y6gjzmDuRLAuKztvhF7HQZw/xXy3pCz2kG
         xjTp7tBrRbXkJJxO4Cx/KnlFx/Lh6lo0rlglXkPS1eQm0fYUOITcbKbRd36164bFTkHF
         s9mmqlYdsf8wCO2NbqGi6qR0/C31/N7HZI6BWXByum0a0yhM0wehrearbxpPWq6zCYdR
         yOU5ETuicyySAGcC2mbTsGoGeSTRs38pp6zb/XUXadU/tQIUfsFCnaqmoKifEBJ0JlUa
         fbVD5+AkgRrdXQyUaXVk98F5XMKDaPnxDVpt0qGr7GCgveLIpP5BBBDWmbKuWnPI1kJ0
         lTDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783689824; x=1784294624;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QOCrfdDRUfE+tF4OzVq2YVwdlj30R0qZyYamfikbedI=;
        b=GmyYsosyB+P4hlXN/7Odyb9n/uHA2JfbRZx8BseKxr4bcOzq13kzPuGduAMQKp8qWd
         5TeQjKkHLGy62G52aXCr3Ho5seBx2XZ5sH049Fm+RsbRF6XjLrf6kqnGHdOB0Lrv0deY
         ab8nJ3CNWf0TsDZTPcIzwzSeaLN261xmv0b0bt8TgmDUN8Dd3zDdPk6ADepeOuqcNinq
         1jfl1OQNfIcBVlW1yU0Q3YgBDy/LNBc/xN9+/4oxcLkSkYPTSgrwdF2+lTWk1lJDxO56
         8SRr7NSTgqMXMhuErpsG1A0NcZhwwKV0o8FF0gfBwaBumKz8/wcqe75BhpguMxVBsuV9
         uYFw==
X-Forwarded-Encrypted: i=1; AHgh+RrODjchtyWSVtnk+n2E7eeCm4Ku9NuLlDdENJHzPJnxGKMry4l5mI2KTBeMMI25xoxj0IAbYUMSalIN@vger.kernel.org
X-Gm-Message-State: AOJu0YyoIKBu1xcAlcyLtOkIX7zhcT1xIM6GwM7ZuswJlju+iCFgyf4r
	cNfRwUKJKJqoPuIcvSlFLZWBo46wKyN1xMQs91LP4CYij5bXfy+V4pLd
X-Gm-Gg: AfdE7ckn/Q01cAMDzi6RN6bCnL9eq38hF9lcqVC0MBQbSi4YaUjCAYuP8s4thJyZP5o
	WnpI5uKIHeaI1LiH8J3gqpGuP5oHwlKBfUIjfcUpXJA/P+qpUMEg6ZxBSYOQZPKoFnArMRNVcIM
	EPnv/PM6qGcRtQ5KMEobo602tdAH0H+BRTOA0VTzr6cKERMmNRyleLGI6ogD55/EJcMe5D11K0h
	MoCnQqe3xhfvBuunaBQLnkiQLQnpCeMQhmj6ZKj7NNCd51+jE52IvInstDxrjp9nOIJlthOAInL
	Uo6VfWGSMi0jWkJHPjp7k0BphGh4zjvKPb+bkY03q+LOoYM4Oh6lB0f9cavogUcv2GIvlNCxaVa
	Q8VkTrtveNWwIoDDYudgeOBuBLgKzRpJRd9EWoYraoTNJb1JMLQ74uMs2/CCl/7FRpRbaDVIotJ
	DZTa1PQ623adeINRrFDbcqEaiWVQYGrPNxx/AP6QocEShvbZcnVQh1PlShTcyIxebiSzGfV4R/Q
	3im5pA=
X-Received: by 2002:a17:90b:3b92:b0:36b:769c:c037 with SMTP id 98e67ed59e1d1-38d18ff7096mr3003981a91.5.1783689823526;
        Fri, 10 Jul 2026 06:23:43 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38d2fbc64b5sm549778a91.2.2026.07.10.06.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 06:23:43 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 0/2] md/raid5: reduce resync/recovery dispatch overhead
Date: Fri, 10 Jul 2026 06:23:37 -0700
Message-ID: <20260710132339.7284-1-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two changes to how resync/recovery submits work, reducing per-stripe
overhead on the rebuild path.  Neither adds memory.

  1/2 submits a window of stripes per raid5_sync_request() call instead
      of one at a time.  On a rebuild this reduces the number of
      raid5_sync_request() invocations by ~30x (a call-count measurement,
      not a throughput figure) and bounds the per-stripe jiffy-sleep that
      otherwise throttles progress when the stripe cache is under
      pressure.

  2/2 reserves a small amount of stripe cache for user I/O during a
      rebuild, so foreground I/O is not starved by the resync stream.  A
      pure rebuild with no competing I/O is unchanged.

Both touch only the resync/recovery path and are independent of the other
md patches I'm sending separately.

Hiroshi Nishida (2):
  md/raid5: submit a window of stripes during resync/recovery
  md/raid5: reserve stripe cache for user I/O during rebuild

 drivers/md/raid5.c | 68 +++++++++++++++++++++++++++++++++++++---------
 drivers/md/raid5.h |  2 ++
 2 files changed, 57 insertions(+), 13 deletions(-)


base-commit: 55b77337bdd088c77461588e5ec094421b89911b
-- 
2.43.0

