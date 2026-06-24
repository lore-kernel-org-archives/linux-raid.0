Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121133A963C
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316471; cv=none; b=fVL0GzOJjRSqpBS4ZL/VqX/B0QVKYR835DDs9u3I+ReUHqsPW3IGilsGZvfRFwVWkx1+4NMvHOBznymDe5EWJZpAvvH4RNl8dFNgBAJQLfXDQ7ct7LWSlNvLuMOvzyEDb2484MllzrM/jaQKsK6P9I7ncFE4+i35u4wUL7CDxmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316471; c=relaxed/simple;
	bh=5oslTZgyVVbc/FeAxMn7kdZ4BfUgM2DZuzcfIckqHUw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B1gmDy9NwOzVyS0bGB1SxS++tHeug0Yx3irIzcLH23IO3j+xZ2AZDK95Y+/0I/CXu4BT4GUoUHT87ZzIGw7nHD4baSeSJdfc/vFsZn7pnnbHLiKyrFqUMu9NRg0FqJ+G1QqwdAr4Pn++5oIiJiHPJKUGKFb22qJJZlrTapPzGM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=USNFyBV6; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="USNFyBV6"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-37d55e8d3e3so10073a91.0
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316469; x=1782921269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=118MZcwCl0K0Xriee8aQ19Cp+uefrlM2nkM0sdxLZSw=;
        b=USNFyBV6+fWE1wo9dQ6Fd/fj8ON9JKrRgbPa/2rowcuVHEc/pQYBKMBT7sbvW97wdf
         3PHjZCaU1ktco5Xe5F+/ns8ZHSkMi934On6FyCPWXvyTkp4Xoej9K8OG62HUx2kGLhZ2
         Lq8rYfi8MvTD/SPzlutmWYbonkP9sgy6u6t9yxpsLniWca2VjFqdSTqFR+j4Ab4qf6kn
         A1Ag4RAVzC7dzj6pgpNKnPSppNF7NYCdhW73Vl+KSd1owgGeTBILA5qTwaE/w4v6gQwS
         95+wK5RjR627/vGQH8VYGwwfEnHKmMTFk7yFC/NQK8Tc1Jp6+7+S8zazR8A+ipV6qguk
         HXKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316469; x=1782921269;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=118MZcwCl0K0Xriee8aQ19Cp+uefrlM2nkM0sdxLZSw=;
        b=ZyNGqXGNAuf6Nn2KuHA4/9zDT7bU2/wGd8CSGlWO5QKkG3k6KmrCQjLl3PdFEpoSEb
         9ns+d5i2gpVz8CIBOHW79YL8UykMuCOKdUnyywt9w8vcSkKOOrnWgP1975ZxaSVnNKRu
         BuR2oFphY87XceZ/CjYZ/pexluhqmv9ormq7SVjGdnZCvkTZSmMT8hib1dfWT8KKj01D
         R0F/tYUoE8BPJG7bYlqqELtSj3nIEgtu+E6k6Kqc3fuX5Jwm3TM/FPaJxu3MMAK1QZlR
         ncO2E5an/mgu6YGdniA0oLdflolxITb+68zeAXNpnLCvuKrwBUwp6WtKYiwiWSiZZFFf
         WjEA==
X-Forwarded-Encrypted: i=1; AHgh+RoZoHLgMg0fJXRosV0MjsdS4AVGl89koikFk7DeYGwrouAoBQr09ypJaqW/RRiIPZMX9DuSAZMiKfg4@vger.kernel.org
X-Gm-Message-State: AOJu0YzA/zFpFMZfrF8RYzT7jp4HbBRKOwnAgiUAees6fPKLEx78RyFn
	ipsUZy5ZX7o/tsTnBg5tPcBYFX5GWu6tmkDNp9DYzoqgTJ9Ypq0cX6Xs
X-Gm-Gg: AfdE7cnZDyP/UAb9HfldO7GJ7tGIDVeSTWgvIgohXsdlzbFc/lCrtu74m2bvoyA0Oh1
	U6WLOOzMuxUjJZgwQjW/Zk4M17SBxKBD1m2Bw2YS9/KDywjPVp+bcqFyfRjk1fEjGGKA5wZ+a5L
	AIa96/psoueFC/+pDvM0RAY/5oQUQkFil2j/VgERZ8YOoPxJJPyviBXd3lRDYXeYRBhTi5N7GKX
	bdprP24HB/dR8LFxBn07fuAh5/PBWfdcUH/jaFgdPmuaNLTBEkKFJQfFZGhEYB3MdivkWP+SOmB
	FcU9aNwGHvUUIlbXTRvPGp5R3Pj/v7/vvlYX7Zsm5OYYVpfEYsAyIg7spIUfEpMuojkWQ8lCFcR
	Mmzj2z9zUmsdcCi5iq0B+FmxhZS19Udw+IBzZYMLvOZ10KmuEuDSjiVr5y4/b7SXZlQCc6R0sW0
	laR6r1/91cO2kioea5jvKdcUE1jYko+eIGfHi5DqDOzvImnkMU2Dr0VGmbR7NVNB+Wu7jqcEmfL
	kpsepw=
X-Received: by 2002:a17:90b:3f4f:b0:369:1dbb:4732 with SMTP id 98e67ed59e1d1-37defc79762mr805079a91.0.1782316469301;
        Wed, 24 Jun 2026 08:54:29 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37df3af8563sm54939a91.5.2026.06.24.08.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:54:29 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 0/5] md: minor cleanups in md core and raid5/raid1/raid10
Date: Wed, 24 Jun 2026 08:54:16 -0700
Message-ID: <20260624155421.211626-1-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A handful of small, no-functional-change cleanups noticed while reading
the md code:

 - drop an unused parameter from check_decay_read_errors();
 - use max() in raid5_calc_degraded();
 - make is_mddev_idle() take a bool init flag, matching the helper it
   forwards to;
 - declare a sector count as sector_t rather than int in status_resync();
 - rewrite a self-contradictory comment above the resync ETA math.

No behavioral change in any patch.  Built and functionally sanity-tested
(RAID5/RAID6 create, rebuild, scrub) on x86_64, including a run with KASAN
and lockdep enabled -- with concurrent /proc/mdstat polling to exercise
status_resync() -- and no reports.

Hiroshi Nishida (5):
  md/raid1,raid10: drop unused mddev arg from check_decay_read_errors()
  md/raid5: use max() in raid5_calc_degraded()
  md: make is_mddev_idle() take a bool init flag
  md: use sector_t for recovery_active in status_resync()
  md: clarify the resync ETA comment in status_resync()

 drivers/md/md.c       | 26 ++++++++++----------------
 drivers/md/raid1-10.c |  4 ++--
 drivers/md/raid5.c    |  4 +---
 3 files changed, 13 insertions(+), 21 deletions(-)

base-commit: 55b77337bdd088c77461588e5ec094421b89911b

-- 
2.43.0

