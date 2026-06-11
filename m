Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF2E25A2DD
	for <linux-raid@vger.kernel.org>; Thu, 11 Jun 2026 13:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781184307; cv=none; b=rRMvT4HUlCsc7W1CfJ0vpvqBnyCf1s+YuRwE6yOrmxM0RE7Kj2jK9fjSAjR9Q7bhhQP/4bThkX21hoMwVBUUuwExzUKUHPK0tCSoxe1SPsbTet7V0gbetjWH6zmzFB0htZ4w7OBUpYIp+zIuHwN8gbvG6tNQDBQZBteYJdbsjLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781184307; c=relaxed/simple;
	bh=BAMEiUiopOcpdnGhnvapHqJfRaDABZc555dgBdJXTz0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OmMt4Ig19QZDJr02hs94/dvXNrOat27A5hSwwejM8e5zqeK9XKSzwGrh2a7ejs1Rgb+e+QQfSOefJS9jhozrpFBI5Nq3M4FbW1w72qfteWqOmY/Ar51X0pqPDSfNvy0mI5oG9l9SVtXA10TRuvV8+14FlpA9wZAAI+7T4kPI578=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eZkO0I+I; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eZkO0I+I"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490b64c8311so86980205e9.3
        for <linux-raid@vger.kernel.org>; Thu, 11 Jun 2026 06:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781184304; x=1781789104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=owt/z5np0YVYSdI1cK0JnJY4WIKgIAsBPKeWf8hMHBs=;
        b=eZkO0I+I2UkmBe2kHiIMOffUC4z1uZnVjQuJNHZ95UCMWgLxXutoQyGeudWPakc58s
         Ppct0YQh6Ni4DUZc80oJ72NsANyGFmglbB6uAX8BgS1pzPq/UoLAynIwwox3uJ9eDXrq
         PI7KjlSA8GgkHIvtQT/eXnAZvo1Z1KrSzMEWE/ACBaJLWv316WBq0bSsI6x6kQ7ihDlf
         hlQgyoLMkpLRGkXUH1rzmVzDL+3w2ohtV/F+PvH3DJRxDKNXVgX59jOylqTE0xFfkP4H
         ZyWzJp0n9aqx0l9APFPZPBykT8jC/hI8qHRVzrVlJAu5HULlnZjzlUPers1ezMCSWOSm
         8t5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781184304; x=1781789104;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owt/z5np0YVYSdI1cK0JnJY4WIKgIAsBPKeWf8hMHBs=;
        b=lcAyGWWZrZyhpeMyaoB5EuwUmL4QbeHYorJ38prQZfY8EPmJrkYMGkJNeKLnBgzSg7
         H1Xmd4RBb/9MYT2GV7irsuFIIYKo3zLikU4a1SMQKOfyPhUQYG/wbgoStox5n3hxlNJX
         wRrug+3DdPSrAqYeYjOKHNetWJfqNmu5hRV+DdRl/ltBd+63TxVGfExPhYZ4NZJY9gPq
         kUhr1ajJ/ijcVbWLw80WIcKl3J7ZrUndLI+oz7SJivEMdKP6pVYyYPe8v58Op4XJyRyk
         NDaY49OB2VD8y+dA3rX62GJrDyJaA+ewZjNt3t0qsz93y6bVQAJ3Qpq2uCKTNpDgoDqL
         m2UQ==
X-Gm-Message-State: AOJu0Yyw2wggzPPgGE23lBq11GQXWGx2B0jSEujE82Sw9l2hhlEZ3J0b
	pdbcNy3e/KTmcnoFfiBVcGSqXPlf6SOsIhIrFeJoK3wt2BUdJ2Rrul0e
X-Gm-Gg: Acq92OEDY2PUlFE9QrXnz1WfAYG9LxAB0tXpyn5D7jb2E7uh2r2Nowzi43zSlHhbYOg
	Sqs4rkOPRx+LVrjsRDpGr50/ty9x9aULC/MkcUgky/QxSYKLesWzHzfPmjeBg3XFNwPwgW0IQJG
	d2WdppgxJO/tNvUP/4bzTRbqRKsIZZOm53Vbm7Rz4GBpsf4WlwVNLSD+wDW4G4vk3L7mZXm04F3
	d8UyEvogmqCn1MZn9QIwsJKYqif003T5vftYGrgS2s/S/YvuFCIHSK9JY8flx2oHkWhHkXNHw/c
	iD8etzph4epMJsZHcf6B827kz+8vh73pooBeldf8/3cTjXjgZiBeiFy0g96AUR6EbQvQJLqTooB
	I4/nTeGOMyXRj9Q9C/aF0lBVrB/tbjaFdaqFNVsjUWcIJmN8JZ9jhdjlzblGPndxs/54qgsjVnk
	NS9nM2+fjdQatP0wM2kQxfeLKADun+Ajej8L5yDkjQflDwXIs6tkm6xw==
X-Received: by 2002:a05:600c:3e8f:b0:48f:d612:3c59 with SMTP id 5b1f17b1804b1-490e55cdef4mr39242575e9.9.1781184304071;
        Thu, 11 Jun 2026 06:25:04 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de ([141.2.113.162])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2c7ead0sm73770415e9.3.2026.06.11.06.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 06:25:03 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH] md/raid1: release barrier when REQ_NOWAIT write would block
Date: Thu, 11 Jun 2026 13:25:00 +0000
Message-ID: <20260611132500.763528-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid1_write_request() calls wait_barrier(), which raises
conf->nr_pending, before calling wait_blocked_rdev(). When
wait_blocked_rdev() fails for a REQ_NOWAIT write, the bio is completed
and the function returns without calling allow_barrier(), leaking the
nr_pending reference taken by wait_barrier().

freeze_array() waits for nr_pending to drop to zero, so a leaked
reference prevents the array from ever being frozen again. Any later
operation that freezes the array then hangs, including resync, reshape,
device removal and array teardown.

Release the barrier on the REQ_NOWAIT failure path.

Fixes: 88ed59c4cc6c ("md/raid1: factor out helper to handle blocked rdev from raid1_write_request()")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260611083514.754922-1-abd.masalkhi@gmail.com?part=1
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/raid1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6263a1d45f86..e9086ba1f796 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1522,6 +1522,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	int max_sectors;
 	bool write_behind = false;
 	bool is_discard = (bio_op(bio) == REQ_OP_DISCARD);
+	sector_t sector = bio->bi_iter.bi_sector;
 
 	if (mddev_is_clustered(mddev) &&
 	    mddev->cluster_ops->area_resyncing(mddev, WRITE,
@@ -1550,6 +1551,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	if (!wait_blocked_rdev(mddev, bio)) {
 		bio_wouldblock_error(bio);
+		allow_barrier(conf, sector);
 		return;
 	}
 
-- 
2.43.0

