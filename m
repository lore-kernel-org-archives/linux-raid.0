Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417B73DB31A
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316483; cv=none; b=Fa3mLlc0GEEoKPlUiWpFcvyVQWmM2mJfoPdc4WfQvWAdsaAoCEv33eH7AUdvSL8YrVEGhviLwetAjjS8m6LvRGKbOJ7EqbeqTRt5prjEQsCmhWgj6o/rc2jqAtToGBQynt2ZEOjPNsQdWeIWn9ZOBk+t1T95iS6D1NbiQnGuG8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316483; c=relaxed/simple;
	bh=xHJ6cEFN3aoKFIN0HlOLvWowKMvEPwWQUGULuhOYN8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StIoo/y/wDz1j6zH5Pg9wy4sTOYUiE1iEPdkprfZ4LKLAqIb2/c6MFtcWCQWanIjpQpteKgAqkkP1KMkeRlLZQCG4U/KiY/Mit6FqreZMRTpRrbSelEqV2Qwr6XFxvtiCa0v5K+WDsT1rRMg6ehcADegsrzCAOpgQdauMBwLZdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N7JZ8lVj; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N7JZ8lVj"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-37d4ab2e7c5so1166008a91.2
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316481; x=1782921281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DTdQViIhLFEEJ3XPJPNxf7jlz0OBQdzEoqP2Mr6OZaU=;
        b=N7JZ8lVjFj6nQPyYAOH39eWW9pZdGFUInMMcLibWzkq1YImsXyKnXJaw25sxwbArm6
         Pi6o5x+0G5ri+7G9QpIN52PjBgUt2jN5mc0hy9ajIrrHyrxZ3lCWsH73iH7Xmn3Dgxge
         Gg+lMcwc/r++Yv4VBIHX/lCZ7jVj+7bzC04Oe1SIhzfhxosmhjjqJ33A5K8VgdD9Ffdi
         My+ymcThVDup0KNwMB8pJQmfT4s5GGk6Dic8rXYHoLanLbkW8fX/356KJlTzJtHdmqAH
         O5OIrL0Kf9OE3pKcdn1qm51p7lhtdTVwaqM6FPFJazU2RdENoiwGB4id/6W0aNzSDWvQ
         zkiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316481; x=1782921281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DTdQViIhLFEEJ3XPJPNxf7jlz0OBQdzEoqP2Mr6OZaU=;
        b=eQbDClZ3EDEUEweRynOqIPDPXcY34PfIAJu+Qllych44jXUNIORim925kAxlfEQtE9
         fjBuhsAuKUbtzBfZn/w8OsbalI7eqbj8iisDCjo6yhTvEAMNbVFx4B/kOIsR2BZLam0g
         er70qCqSX3Mr+aUOy8SgPhYpATYx/aqg/gXKpPBIvfIkB7GRhz9JCTC83f4CDBYicbbT
         5b2Uw5q4t6MH8rUZ9xdNDQjiwllfATRU0sfq4L94DyEJy0ElRe4I9vabkHmzV2iSah17
         A1FCy8u1dqBEIM90A19zXqFk2x/a35GoFuv5PTjU1D4SCjN0MZ7yfpdaPYdn8w1c8tBl
         GXxA==
X-Forwarded-Encrypted: i=1; AHgh+Rqo4K/rUai9wwHIxf33JaK3BccPFIVoLPGe9Rc/azHDgWZziWaL839nDsaaOB/iIUtAJlZXS9gSrr79@vger.kernel.org
X-Gm-Message-State: AOJu0YyqbnE0HLKIEq282kw/jWFXFU+jBgSEuvwuthp1pMI1RluHele2
	8EwWEZU37bQOqSEFrZlIKc/n3e4raQdc5G5qhMOemFwjMHsC7oI0ny1g
X-Gm-Gg: AfdE7cl80hi9kSHdtDhGZZNVL2NaB2WbQoSpVVpSYQpavYB4WpQCbSpdrmkl7EMdFnN
	efGSD/9we6R3nxZYJHWFQyK0bNmLnXztieF1/wqQYOFmnEEf5+a6HJASFmWYJMCVemCRU8EgZFM
	v1g0coLCijOJH4fNgRuUkur0XjmjM6A9UFaOXQdZ5dGmRsNavXKneAnCvJK6K1chimUOId/HABy
	Df4J8RvcTRGV4rqlZy4UdbGhVZrtdchchY/KLpe5GOGfIOD8bAHysXsCCEDkDwO+ORmYrfqO5rU
	b2uhGJAhy5oLaZycPeE99wikQGHanVSDGJyiH3BABCaNnt7dLPE9ZuvIjHOLopS5n+DsPbJpA7H
	FPjSb5dOry+c/A7va71SLivWwwqxUn9Id4bju5aCYcBr3zbd+iMgxqp2AEaiK6+BWHofps78x/W
	V8862RNIaG77TI1vflF/5DkQwEd327diNFQfPibhHI5OPx3nikFpOFlgALQF5Aqvn3xn7GHD5nW
	ZKK9H8=
X-Received: by 2002:a17:90b:3847:b0:35f:b987:4dac with SMTP id 98e67ed59e1d1-37de466884cmr3942611a91.12.1782316481212;
        Wed, 24 Jun 2026 08:54:41 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37df3af8563sm54939a91.5.2026.06.24.08.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:54:41 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 2/5] md/raid5: use max() in raid5_calc_degraded()
Date: Wed, 24 Jun 2026 08:54:18 -0700
Message-ID: <20260624155421.211626-3-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260624155421.211626-1-nishidafmly@gmail.com>
References: <20260624155421.211626-1-nishidafmly@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tail of raid5_calc_degraded() open-codes a max of the two computed
degraded counts. Use max() for clarity.

No functional change.

Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid5.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0c5c9fb0606e..2b2aa4f2431c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -741,9 +741,7 @@ int raid5_calc_degraded(struct r5conf *conf)
 			if (conf->raid_disks <= conf->previous_raid_disks)
 				degraded2++;
 	}
-	if (degraded2 > degraded)
-		return degraded2;
-	return degraded;
+	return max(degraded, degraded2);
 }
 
 static bool has_failed(struct r5conf *conf)
-- 
2.43.0

