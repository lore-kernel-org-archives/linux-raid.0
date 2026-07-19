Received: from mail-wr2-f0.google.com (mail-wr2-f0.google.com [74.125.225.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF24B25B086
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 14:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784472256; cv=none; b=oTuhp97NLlNfcmUWGFe9y3cIQjX//WbzN0IbpVRQpxSjD1Ohqvc/z9daAzNDLb+1fYD4UHLxiU4kqan6nj+qZFo06Jl2+dBA9b8wsLSUOzbNlQfcLGpj4kuImF30ygUDQIDj97AHJ8f8LJ4FF44QeGaJcZkPc2sJJFVhRFmtUIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784472256; c=relaxed/simple;
	bh=8MBXsyLLxAUg+CH8c3/gbAKIJJLBe7bs1gRWJLSsMdc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o4GawHDaliKwm5xNMnlHtel1SDwDnKBkZsZkJ7ZYwmMKQfPjQIzckzfKh69DK5zVzCYuE9uq3QIrZWMoVkkLwNHr8Fsvd0PDdoL2PeP9S681bk0f35b3RT/LRGHqur0hW5dreVQF3214gnNBwzhWk1mHrNzDN7uyRaca41LNUNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=oNTH4IzD; arc=none smtp.client-ip=74.125.225.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="oNTH4IzD"
Received: by mail-wr2-f0.google.com with SMTP id ffacd0b85a97d-47f4c92d1b3so1478633f8f.0
        for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 07:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784472253; x=1785077053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sOlxg46bKwxaY89a+uw5QYUB5zKovPOM5G9/5kcuk8Y=;
        b=oNTH4IzDU3ezX0vc27GH9fv46PJF1u1oKrMcFB70b0ezX0IRvu5lr2fhF/NOX/eZFa
         9KVv7mnQsn672serHZoP59RLCgURx1aXGm4Ot18Z8xidM/qELekajEtT7jmeIl3xuCUJ
         9wr1VY8ZRRBfF7c0eU6sXafOtwksA+bo9K7FbRWKX0bJVUo7tEfy0tSXWUcLZ33qanFo
         pCBzsfRD7sy1p/lJ1Q73R1506JJGUjWwLBtI6/t3xXHM9chGVd1BIUxNWzk4krN+ypWU
         oVz9Lj7C1C2cy/FKM9lnR2V9dEFmL5hn9dRbBB2qmi1hxPaut8qgAXOh8Dx8Pfu8X+12
         L6Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784472253; x=1785077053;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sOlxg46bKwxaY89a+uw5QYUB5zKovPOM5G9/5kcuk8Y=;
        b=sulHnYvl9028hHdcCYqgRWSobQO/uXXpTLVS8A0T5pm5yvl/eAiY3kaNadzvP2ZjzU
         DhGZp14Gt4Ruz7PZv0wkDt9DKkZegdnEVmodGNEpFLJ+wrGJSZ+sY+E76HJtMNKc0xbu
         k9ijkg+NTkZ4P2nVI6REk5x0h5ia9TrXScPkcEbVUDVP4J43IrXg+GC3akogDLI1C6pb
         MRpmkLMrmAJbIej5NJoKSH8UlSxzjYpKRf0x8vggZl+1v+XWX+X2B/mR0eGqPwv+leOk
         l8GElkzqbWX2CgZGKs45MLCM1xFcr7uPveNfbE7iWqqrjPj9KXYNbzx/OxkwxkZhRI8f
         9PYQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq6vDtftY2T2cY/g/DuFDM9d5L6rT0lWuL4QsRd0Uk4tVrfblcX5ZPIxsi2Gfex/FsfGmjde97K1u5a@vger.kernel.org
X-Gm-Message-State: AOJu0YwVPJbbRpBxyXxw/3L4lESN75Dt9DwmxoDTc6OlZs9Hut7myxIg
	F5zW5iEdftjgMoFfSnvoqmk5qCjDshvh2hsuArsdYBur+GOSpsRrQLS8Nsmqu/fsew==
X-Gm-Gg: AfdE7cnafOqbsDGqrwiDTtfvgnZvYt89gG+MvwEp6nwnNzZWc5lzvNlq9tYb5hJa2io
	rJ/3362YwoPYt5/eYW++vtLqJOrdORyyFE033o8lSTcaIxkKJZ6naVqXU8nhrrfQDtxpiFkrXmC
	CwpmnlBQV4i5UCEeROWS7qdT3Qkz/lK9HEULkbnCzgEVcd9gku3H7+764Oah1Fl64ZJnRp84fms
	6s/xVtzD8HXs1ELrJUyLtwdQKd42q00AD7hrOQV6c1U0toLdeczooIatpRye3XT8GO8nrg4nJwQ
	u9p6/makB83QlWKpyhOPfpgmLZv9qYX/BKg+yJlZiGVzqqEPGAOJIfjdT1JTS2+thRaLrG6emJi
	hocybpUP8m/q6xi8t2iv144v2tYuVybs0STIgyStjCS2IbEtyBTPcKGAxlu2eDQ==
X-Received: by 2002:a05:600c:c0c3:10b0:493:72d3:4a81 with SMTP id 5b1f17b1804b1-4954a3dc87bmr85186325e9.16.1784472252429;
        Sun, 19 Jul 2026 07:44:12 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49549c9c940sm190238905e9.13.2026.07.19.07.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 07:44:12 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] md: bitmap superblock robustness and assemble diagnostics
Date: Sun, 19 Jul 2026 14:44:05 +0000
Message-ID: <20260719144409.940492-1-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While testing llbitmap we found two bugs with the same root cause:
the bitmap superblock's state field is untrusted input, but both
bitmap loaders copy it into runtime flags unmasked.  A single wrong
bit on disk -- which pre-v4.15 kernels wrote themselves, and which
corruption or an external write can plant today -- can brick an
array (patch 1, classic bitmap: assemble fails with -EIO) or
silently disable its bitmap for the array's lifetime (patch 2,
llbitmap).  Patch 3 fixes a kmap_local ordering violation in the
llbitmap superblock reader (hardening; no observable bug on
production configs, hence no stable tag).  Patch 4 adds the events
counters to the "kicking non-fresh" warning so a kicked member can
be judged from dmesg alone.

Testing: patches 1-2 verified with their in-message dd reproducers
on unpatched and patched kernels (state field forged on every
member); patch 3 by build and inspection; patch 4's warning format
exercised during a non-fresh assemble.  The series builds W=1-clean
and applies to current master and to md-7.2.  Independent of the
raid10-recovery series posted separately.

The patches were developed with AI assistance (see the Assisted-by
trailers); all code was human-reviewed and tested as described above.

Mykola Marzhan (4):
  md/md-bitmap: mask sb->state on load to drop runtime-only bits
  md/md-llbitmap: mask sb->state on load to drop runtime-only bits
  md/md-llbitmap: unmap sb page before freeing it
  md: include events counters when kicking non-fresh device

 drivers/md/md-bitmap.c   |  9 +++++++--
 drivers/md/md-llbitmap.c | 12 ++++++++++--
 drivers/md/md.c          | 25 +++++++++++++++++++++++--
 3 files changed, 40 insertions(+), 6 deletions(-)


base-commit: 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
-- 
2.43.0

