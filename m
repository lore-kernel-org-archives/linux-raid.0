Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1872741D23D
	for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 08:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027883; cv=none; b=oPxD5TqD1c0+UJXJZc24iIMRRzWLI9iI/Yacl0CKI1m9+njYM+OAVoRKZKNToW8n2Gb2SRgD/6wrf9+pMjXaYIiwFOf40QshYhUjNS4RfKsCZi0NeRVJqkuuDaZE8dsIzsAIDyAQHRdQSm5DZTVs5G6lEiJaOiPs2zOwsOJrxlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027883; c=relaxed/simple;
	bh=gne6jQ1eDgyN6cYZe+ZWpX+VwTcHT+2IRfoXziUB8N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roYQhG/zIjS0fzjCptlJ1B37m4j46jowCgBcbSZk6nVK8NmOBqZ89sj85PxPEFnN2RNtLI8EeySgMrb953Y5WSlfuwWoJUa3aAOeBCmunApcWHEcXGKxiMTR1sDIH0mDkZhlMA7iy+YYawaKa9LYqjDnbJJ0FJr40EZsCIAtHJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Ik4lBZEL; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Ik4lBZEL"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd5faa1cfso1716775e9.0
        for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 01:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1789027879; x=1789632679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OA45OxGe2lbIuXbjnmED/p8Au3ms9csyQD/sDFCo9UY=;
        b=Ik4lBZEL9ox7iKIg74qfl6WWycLFAH5F4uUSDSXnCPH63C1xDRycJY0ngTK52uvxca
         AEFHmX0WKqmfJ5VHu6okFKdcFfW6FPoptd/fgaMOjT4tAXRaZGr72/tKSsgqav69idvU
         Int7BnnTvqlJVUNhuec1Vx4Ss9NCzmJgJRIrMogda/RN0XjckxdAjXmDx9lCjYV8c7lz
         9atRoJLv+Z5APgV4meCzDXoTnsVK1Grn5dbs+YHX3YK3kLbpVJEQB0T4iHDaaIJBrVLf
         KKypE2AEWB6n1xI9BHaXB5UiyEzsjGX3HoWb9XJU4uSUb+ORoEgRWkqRRzaDII0mbWPO
         CiHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027879; x=1789632679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OA45OxGe2lbIuXbjnmED/p8Au3ms9csyQD/sDFCo9UY=;
        b=IlPjCZFuaKOev5HgB8o0m0IWRU8cd+OYqo04qScmc05WnoV1h0F0nuMfjltffcRHIT
         KW/apGvFBfUZqk+UhbEZKY0YkAkXDz5RJHQWnznJCv/9tLYhr1TlM9NOp7tup9b3nes3
         f67wcvzSKzPiMsTfqjy4nGlgFiuaCnHBSr/N7PKvrAlsaR29J6m9br3ti7dZnTgpuZYM
         5Q+/DiS8cxfBo5e570z07NJrj+8iLvugfDBVmRYc3zWKBb0CAH+zCIyArewAT0LdZcIX
         8nsMSnj/2owWCOmCeZ/Uwe7z7HMyyodY3DvP7+xu+cpPEkWiPoGbkmiaprgNTDQgnKIp
         +5RA==
X-Forwarded-Encrypted: i=1; AKwUvByI0iMnHBTo35leBSjz9W6wVO9AbkWM7vRiPJCM4QOI1W1bT/ycSgSRwnEAR2BqPpuXkgYgFnmU1isT@vger.kernel.org
X-Gm-Message-State: AFuF++lCa2OzIlfeTpe9JQ60Tqy5KjhdEEi454NpumtemM3grZZNxDC4
	QRpY1UoGOFYkdPyNo13JUv7htrHGKRPmRoDIWUUPrNvpCMkERhqB8w+VHuReSsyi6kAhtuCEKtn
	pRtlGHNc=
X-Gm-Gg: AYBFou3mJ5kRMWJobgC2ZFgg0+BmBuA3ahEZhf0IFvRHKEsc+l9BVNaPtHeoJR/LdbT
	ae/bU+5kcrK/WHDHfhohMTIOzd80mxxg0z4eOwDKctmwSykzIluqNfB+W1y8JhMbVL14Vz5vihn
	TDrFrPU1I5Xjm4hn/tJpqhv2S9AF6HRwRgX6KZb8AsYNiw2PpGvBn1QAo7BZVz4AifSTAx3z9Qk
	q7c5Zs3yhZMYtf7NHdrIshulrxFD05QJQ/dKDySycZMkcYNrcgJqRanPUCuEYvYE1hbQGZqD7Sb
	cnCDOUtNtvAyZvqjo9pdoBmw4IZbUsrprhNxyfy21tMXB8sphl3fvbPbvALuj1suMisAtJu7Goi
	6/VAGzWsnSLF99KORY7JtAYMlLVysZpHLu8pr/TFM+9Ei3l/xazr0U5aNGcVh6a8w0+6T9p82+T
	E7eGsOj9P48Cl0lvih9M2yV9YPW0swecLvktjfJvdDLNQpVu/7Gs8PhcsFNV+W3HQOVdNFHZmNq
	dE0Z22xZAtdnAncYxnU7TkbsZ3tJG931wqHeS8mqYHt
X-Received: by 2002:a05:600c:c494:b0:49b:916a:e553 with SMTP id 5b1f17b1804b1-49d010c2a57mr296627915e9.0.1789027879077;
        Thu, 10 Sep 2026 01:11:19 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d20fc1be3sm55261135e9.4.2026.09.10.01.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:11:18 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <tom.leiming@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 2/8] md: don't wait for q->limits_lock in check_sb_changes()
Date: Thu, 10 Sep 2026 10:11:07 +0200
Message-ID: <20260910081114.1605746-3-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910081114.1605746-1-jinpu.wang@ionos.com>
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

check_sb_changes() activates a spare another node added, reached from
md_reload_sb() -> process_metadata_update() with reconfig_mutex held.
Stacking the device's limits there waits for q->limits_lock under that
mutex, which deadlocks: the lock's holder waits for the queue to drain,
and that I/O can be waiting for a superblock update needing
reconfig_mutex.

The device is already a member, so its limits are stacked.  Add it with
MDDEV_STACK_SKIP and leave them alone.

Assisted-by: LLM
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/md.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 28fc903ffeea..e60dc2c7eb90 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -10885,7 +10885,14 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 					rdev2->saved_raid_disk = -1;
 				else
 					rdev2->saved_raid_disk = role;
-				ret = remove_and_add_spares(mddev, rdev2, NULL);
+				/*
+				 * reconfig_mutex is held, so q->limits_lock
+				 * cannot be taken here.  The device is
+				 * already a member, its limits are stacked,
+				 * so add it without touching them.
+				 */
+				ret = remove_and_add_spares(mddev, rdev2,
+							    MDDEV_STACK_SKIP);
 				pr_info("Activated spare: %pg\n",
 					rdev2->bdev);
 				/* wakeup mddev->thread here, so array could
-- 
2.43.0

