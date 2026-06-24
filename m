Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF463DB306
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316507; cv=none; b=nUQdgTGMYHz1k+3hVptV7C06m/BLs7vCs2iyw0aGQJe3Fh6O5a4lRB4zlg17R544lKhpUNXJQlMsiKOjtZ/eEu4C0gbo0a7Z3Dk90f4RetO/MHekGi2nyU4LqkcQ7jfEqbeAporCkroD8OSSj0MKkKrZ/TcWXJA/bht2OGJDpCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316507; c=relaxed/simple;
	bh=AfzcMQpUjtyGt78pDCF8fP6/S8WB5vl++ExdkqiGcGw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=daNC5ftlTFebfaApm4zov8TJePJQBmCZtt2U6ppgBnj/MxiGoFUhH5tCKueIWAwQkMdP+Q5+R7h32ZCE6Ss9c7exYSJhmdeHX4lYvXZRCr0f8a+g6Cio1miKM5U29KGRE2hFpY6H/Qh/tTcm5Phap9XUJfKP5IQjKIyAYG5oMAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IUY8PJPU; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IUY8PJPU"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84237c55ef9so971969b3a.0
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316505; x=1782921305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7/ufHeEJ+tjBrDVzyTH/Jep68pdbpQAwJZiK+hHQLQs=;
        b=IUY8PJPU3I8ukoBL6hirly60x4qcP2uXdVIf3vGPHqAvkneo67NI7CGud4BSRQG59c
         QB0rTmkG6lNpNlJCfscqx0Pu4H9eCh4FsVcTTL+g8M0sjYzTgxDfIgOj8Jrpbj4PA93e
         Npue1E3PdlexSNdUtnPBQ9yCe1UJVTqU4m2PnXFXVinFx5vquUHwmC8s7EcknH5Ikd/w
         Z+SkM9Ft3NU9TLWFlL7BeblMvHxKwmjFo6KCrxVCJAtJKnyz+90AJUm5cH8WLhYMyrU5
         4DfSDoGaPv5u2GoCzbF1N4ehdxCdSNn0rw1H5ADX9YmHQrGf62p9+zXBELh25pQNnIPz
         xp4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316505; x=1782921305;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7/ufHeEJ+tjBrDVzyTH/Jep68pdbpQAwJZiK+hHQLQs=;
        b=IpoO6BYFGLbSxSSgSr1vQ/pDZpVm2jdtydC2Ln26AuQh9z0wqX4Vzmgs619WxwRuna
         1Z0aMSav6P49Y4HIFmspvGHpN2s8qD3YEVf/G+7BkmZFKcs6M84WhCK1NaD8qCWHa8e/
         WhWf3UoaHpewWrcTo8Ed2BL5cU9kToZr5i3pZfaynrYVQtbQqORuT5PeZn5yodSDANYO
         JLvSASOe5d4fNRAwBb9JNuTfexVyio/IrPmVIkgaCj9ka/WwZv9KDzUc9y0Kg8QuiKgQ
         8U/P7Z/L46uhuvpGrQBI508LR696ScWJuz0sy4NcyjuvSTBjmcfLUrQGdEo2Yg7HFmuK
         sxyg==
X-Forwarded-Encrypted: i=1; AFNElJ88UyjXJfNEAxXDALGBwlYBZvHwWg2eQ+LmOGOKqeyWHPYoQ0K0NXJf3NZyY7XXr9Syq+8mlul2ZFry@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe8ti+Mf3n0r83w/VkiGBPgjlKqP1CBPh+I9lg+2uDHHVlhH9u
	2P1jhQVwV7UICcfqwog/VNvB14ngpsgEY5cWW8/GXHhHnp+hTJgARKAp77nk1hnyQ/k=
X-Gm-Gg: AfdE7ckdsZ7pZM59C8BtXvDG9DMeMs0UTVvV3SkGc/bFYXvM9A7r3+h08ve43y4VfAb
	PwrxdGotDeEtFYVkbLUMX+c3l9eSmN4Hdlbxln07CLlw7bshiXAf6H9s7DYVwTjs3+4WDWrnQgw
	6MGfNMXv/oqNfplZbw1JX5EUE3qo/Koc+Ssdh6UqLNfMl6K2Gia+GYQlddAK0iCk3bBqIEYQxVI
	2PYgxeKUYAVH0+5bzLjHIVUP0cgKrPDMhBVFduA4F158fevsOnavcpVWG/A0Vw3xGN5ZYdG8sDl
	TD5C6fbPDtYIKzU2LmH+8s33h8etDtF35dtNI+ufy1RO81zECMeh49EMB3Dt2Z0v1U/tR51cB5R
	Agb8KCgoLsVx58iyeAzSctUUM5hFtj8Ng9v9LY2gk+YXtgp2E2Y9G07FAQpFMmHJjPoLy8uBNrj
	A2fRbFNFh0kcrs96D+S+k1H3A9EFh1HuOaqNGEplyFPm2Xm1pkQYZLdijYwdCb1sAOUOt2kEVUq
	2+lXU4=
X-Received: by 2002:a05:6a00:6c90:b0:845:3033:6cb7 with SMTP id d2e1a72fcca58-8459524d4d5mr10282550b3a.9.1782316505193;
        Wed, 24 Jun 2026 08:55:05 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40f55cesm2658387b3a.44.2026.06.24.08.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:55:04 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 0/8] md/raid5: scalability and rebuild-path improvements
Date: Wed, 24 Jun 2026 08:54:44 -0700
Message-ID: <20260624155452.211646-1-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series collects small, individually low-risk md/raid5 changes for
large, many-core, many-disk arrays.  Their common theme is reducing
per-stripe and stripe-cache contention, so the benefit appears mainly
when the raid5 stripe-handling worker threads are in use
(group_thread_cnt > 0); at the default group_thread_cnt = 0 (a single
handling thread) the series is essentially neutral.

 - patches 1-3 remove signed arithmetic from a hot-path divisor, lift an
   arbitrary stripe-cache size cap, and widen a badblock length argument
   that currently truncates large ranges;
 - patch 4 raises NR_STRIPE_HASH_LOCKS (8 -> 32) to spread stripe-hash
   contention on high core-count systems;
 - patches 5 and 8 reduce per-stripe overhead in the resync/recovery
   path and bound the share of the stripe cache a rebuild may hold while
   user I/O is competing;
 - patch 6 allocates each worker group's array on its own NUMA node;
 - patch 7 raises MAX_STRIPE_BATCH (8 -> 32).

Measured effect, treatment vs baseline, % change in mean IOPS (N=3),
swept over group_thread_cnt (RAID6 4+2, 22-core host, ramdisk members):

  workload                       gtc=0   gtc=2   gtc=4   gtc=8
  random 4K write (RMW)          +4.2%   +8.1%  +17.4%   +6.5%
  DB mixed 75/25 8K              +0.4%   +4.2%  +10.3%   +4.7%
  high-concurrency 70/30 4K      +3.9%   +1.2%  +10.0%   +0.2%
  OLTP 70/30 16K                 -0.3%   +4.7%  +10.1%   +9.3%
  partial-stripe write 8K        +1.1%   +4.8%  +11.2%  +14.2%

At the default single handling thread (group_thread_cnt = 0) the series is
neutral (no regression).  As worker threads are added the gain grows,
peaking broadly around group_thread_cnt = 4 at roughly +10-17% across the
whole mix; at gtc = 8 the write-heavy workloads keep gaining while the
read-heavy high-concurrency case has saturated.  (Per-run cv was <1%
except the random-write test, ~5-9%, from a cold first run.)

These numbers are on a ramdisk, which removes device latency and so
overstates the CPU-side contention effect relative to a real device;
they show the direction and the group_thread_cnt dependence, not an
absolute speedup.  The stripe-hash/batch patches (4, 7) and the cache cap
(2) drive this; patch 6 only matters on multi-socket systems (not
exercised above) and patches 5/8 act on the resync/recovery path rather
than this steady-state workload.

Reproduction (stock mdadm + fio):
  mdadm --create /dev/md0 --level=6 --raid-devices=6 --chunk=512 \
        --assume-clean <6 members>
  echo 16384 > /sys/block/md0/md/stripe_cache_size
  echo N     > /sys/block/md0/md/group_thread_cnt      # N = 0,2,4,8
  fio --filename=/dev/md0 --direct=1 --ioengine=libaio --group_reporting \
      --time_based --runtime=15 --name=w <per-workload opts>:
    random write   : --rw=randwrite              --bs=4k  --numjobs=4  --iodepth=32
    DB mixed       : --rw=randrw --rwmixread=75  --bs=8k  --numjobs=8  --iodepth=16
    high-concur.   : --rw=randrw --rwmixread=70  --bs=4k  --numjobs=16 --iodepth=8
    OLTP           : --rw=randrw --rwmixread=70  --bs=16k --numjobs=6  --iodepth=16
    partial-stripe : --rw=randwrite              --bs=8k  --numjobs=4  --iodepth=32

Each patch stands on its own; I am happy to drop or defer any that is not
justified on its own merit.

Functional testing on RAID5 and RAID6: create, fail a member, rebuild
onto a spare / re-add, full data read-back verified, and scrub
("check") reporting mismatch_cnt == 0.  The series was also exercised
with KASAN and lockdep enabled -- including heavy group_thread_cnt
churn on a multi-node setup to stress the per-NUMA-node worker
allocation and the raid5_quiesce hash-lock-all path -- with no reports.

Hiroshi Nishida (8):
  md: change chunk_sectors and stripe cache counts to unsigned int
  md/raid5: raise stripe cache limit from 32768 to 262144
  md: widen badblock sectors param from int to sector_t
  md/raid5: raise NR_STRIPE_HASH_LOCKS from 8 to 32
  md/raid5: submit a window of stripes during resync/recovery
  md/raid5: allocate worker groups per NUMA node
  md/raid5: raise MAX_STRIPE_BATCH from 8 to 32
  md/raid5: reserve stripe cache for user I/O during rebuild

 drivers/md/md.c    |   4 +-
 drivers/md/md.h    |  10 ++--
 drivers/md/raid5.c | 129 ++++++++++++++++++++++++++++++++-------------
 drivers/md/raid5.h |  33 ++++++++----
 4 files changed, 121 insertions(+), 55 deletions(-)

base-commit: 55b77337bdd088c77461588e5ec094421b89911b

-- 
2.43.0

