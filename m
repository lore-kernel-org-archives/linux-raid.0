Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16687273805
	for <linux-raid@vger.kernel.org>; Mon, 24 Nov 2025 23:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028104; cv=none; b=b7HuEJAYG1v26LbgS+OcHM/rxMN4vmauC/tJusnfRHbEHiGsbxzjbREys9mjGAWl8OkSGUMG0LblogIOPl7C8RRO9PI5NhCSUfFC3ZMAn2ydsuH2G00idZ7ly1WYjn8AG+tmNdzyApWAjZIxZt2i8ngUUfUcVIc1hlaabvMEElA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028104; c=relaxed/simple;
	bh=0HZiUPVVqiDv8ZEl67pEJba49nGpbGLpzJLHrHVWkJs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qXRMQHLs4WcfbIoXfprqFz01WcT9CQc+CBInUd3MUXey5v5IRk8pn2AQ/bguCI9A4fQM8niaQ/Wl10tdM8eVKzHhS3hD5exSMQ59Dky4kqEk9SP15ojP2yDyqxwHSSgo3x9G5ZUV1KQ4x/0d4KvKsWDWe+p45KF97SAbZwD0klo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bPL86y/i; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bPL86y/i"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-297f35be2ffso73563915ad.2
        for <linux-raid@vger.kernel.org>; Mon, 24 Nov 2025 15:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764028101; x=1764632901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L8zwVcuAssRnEQZ8e7ewIMIsPfvOXMAA4RWGmHyZ+Rs=;
        b=bPL86y/iBZjOidhBAl6VEV+QifNIHQrW4C3Ep/nwnKCbwUYO59IpTBFsDTtTEXt8yx
         FJpoB8nln2MJ0VffyNsLuxsbAfCrlFlqVQdFMMBONxF0RNtxGWy73OnTLTVzfvdxyT/l
         1a5MQ5SILc0M6AkSTMRTtkdDAAw9Lhar88tFes+HRhPfsfPrH0YQpWIRbMdqpN8JxpT5
         pn89jOdNkpwNkPjwlZ7wuYN9CfRt97F+rlWz4bReRFYlh2UbtSsd3m2VD8CYzxEdUPwJ
         1hrdyU71mzSM4j22YMWsrdkPTHruHM0KynglrtZuDsfqrhVEhrIXc/umLfuVoTM6pkLZ
         4c1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764028101; x=1764632901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L8zwVcuAssRnEQZ8e7ewIMIsPfvOXMAA4RWGmHyZ+Rs=;
        b=R3h8KiZyFUB3zctQ9IsIeroFewMMduB/Q50E6bXdWVQMu/SIugvcjykGzPTFrJQp4R
         dmBjhqX9R8xyMoJGP4/rhogtdNJF1LXD7AG7E467cHIobTEw4bFzKaOnP2tKrC8FneZQ
         R0y/j0fEmAeI9+a8IanODyPeC46RAF0eRJB8zzs4CwIp71MeASz04DV3LbASst0VbK35
         AUn6O2mtrLDrs791gpy3SH32wyYr77WTacyuEphpjKFwXms5OBoQoirFpF+HoYcS9mcj
         qReHO81xlGESCDCQd6OGT9O/fZUfb560xrDIHgXcRZvM4vZyIgmLJH5bSRLAj7wRyq0a
         xF7g==
X-Forwarded-Encrypted: i=1; AJvYcCUYnSkg/gr9ZcAPzKTCgmbeD3QjtAthREKcCYmv0bz2I8LBQCQcALpjNDCsgA2S83NkfL0fHNttNr4S@vger.kernel.org
X-Gm-Message-State: AOJu0YxIsCSkP1x3L65gILIBZOu4tGiFqdN8MEZIbV6SzNVAqwhrHM5l
	9P5EK1w9wMFTq8n3KLoMoqJjBltdf6/MKNAo3h2t+4r0KWVkk5QbrD6y
X-Gm-Gg: ASbGnctgoHnmQS5luKjTPwvyKHGJexkrNvyR699DlMYDImlcQLSwh2DJJxIUMXF4kOh
	4fzSVR1y+6wXm3CCxqPN72gNHIeGRNmOSI3Z+1W03yntUkkOFc/OCxIfJZh54skSV+cpxOFLvpU
	yQyYGW9ep7q6gWDZ+FgxmnxBHksImIlXv4nUIfiyXbDsL84g0ipckmf84tan8r0tMlwJYlCYSh7
	o1XaUVX1cBrclWu/4oqVM3lBRhCL3B7eNXGvHXh5kkn4ACjbofu9SFcPOq/HAZ3APMu5wJ8pfGy
	x+iZ9FCZi6NPt9F/p/kkq3haZBPU6QfQ2aFNfufdvCl12I/nH0/ubFJJXNTGGNNO9KZ6cnMNMYF
	qCrOr2wNxqZlOeiFt4mQNJoBLwWFAvlvDMFlHJIWdTyM/YT5dFywQcf0UMWGogbwW+ABQZo7V4n
	i6WP7n8iTIc0HQf6WpqBDoQTSWTShOncicAFGKE2CBkAgPvco=
X-Google-Smtp-Source: AGHT+IEWVgvs7HfQh1Jftv0/sg1EMetPp1p1pbe1p7lp0IBRgw/xws/S7S4QHSHoK5/x2kKFyy9WJQ==
X-Received: by 2002:a05:7022:1093:b0:11a:2ec0:dd02 with SMTP id a92af1059eb24-11c9d85fed4mr7996088c88.33.1764028101157;
        Mon, 24 Nov 2025 15:48:21 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93db556csm74670928c88.1.2025.11.24.15.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 15:48:20 -0800 (PST)
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai@fnnas.com,
	hch@lst.de,
	sagi@grimberg.me,
	kch@nvidia.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	cem@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org,
	bpf@vger.kernel.org,
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Subject: [PATCH V3 0/6] block: ignore __blkdev_issue_discard() ret value
Date: Mon, 24 Nov 2025 15:48:00 -0800
Message-Id: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

__blkdev_issue_discard() only returns value 0, that makes post call
error checking code dead. This patch series revmoes this dead code at
all the call sites and adjust the callers.

Please note that it doesn't change the return type of the function from
int to void in this series, it will be done once this series gets merged
smoothly.

For f2fs and xfs I've ran following test which includes discard
they produce same PASS and FAIL output with and without this patch
series.

  for-next (lblk-fnext)    discard-ret (lblk-discard)
  ---------------------    --------------------------
  FAIL f2fs/008            FAIL f2fs/008
  FAIL f2fs/014            FAIL f2fs/014
  FAIL f2fs/015            FAIL f2fs/015
  PASS f2fs/017            PASS f2fs/017
  PASS xfs/016             PASS xfs/016
  PASS xfs/288             PASS xfs/288
  PASS xfs/432             PASS xfs/432
  PASS xfs/449             PASS xfs/449
  PASS xfs/513             PASS xfs/513
  PASS generic/033         PASS generic/033
  PASS generic/038         PASS generic/038
  PASS generic/098         PASS generic/098
  PASS generic/224         PASS generic/224
  PASS generic/251         PASS generic/251
  PASS generic/260         PASS generic/260
  PASS generic/288         PASS generic/288
  PASS generic/351         PASS generic/351
  PASS generic/455         PASS generic/455
  PASS generic/457         PASS generic/457
  PASS generic/470         PASS generic/470
  PASS generic/482         PASS generic/482
  PASS generic/500         PASS generic/500
  PASS generic/537         PASS generic/537
  PASS generic/608         PASS generic/608
  PASS generic/619         PASS generic/619
  PASS generic/746         PASS generic/746
  PASS generic/757         PASS generic/757
 
For NVMeOF taret I've testing blktest with nvme_trtype=nvme_loop
and all the testcases are passing.

 -ck

Changes from V2:-

1. Add Reviewed-by: tags.
2. Split patch 2 into two separate patches dm and md.
3. Condense __blkdev_issue_discard() parameters for in nvmet patch.
4. Condense __blkdev_issue_discard() parameters for in f2fs patch.

Chaitanya Kulkarni (6):
  block: ignore discard return value
  md: ignore discard return value
  dm: ignore discard return value
  nvmet: ignore discard return value
  f2fs: ignore discard return value
  xfs: ignore discard return value

 block/blk-lib.c                   |  6 +++---
 drivers/md/dm-thin.c              | 12 +++++-------
 drivers/md/md.c                   |  4 ++--
 drivers/nvme/target/io-cmd-bdev.c | 28 +++++++---------------------
 fs/f2fs/segment.c                 | 10 +++-------
 fs/xfs/xfs_discard.c              | 27 +++++----------------------
 fs/xfs/xfs_discard.h              |  2 +-
 7 files changed, 26 insertions(+), 63 deletions(-)

-- 
2.40.0

