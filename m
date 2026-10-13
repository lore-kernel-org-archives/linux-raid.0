Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3D032B112;
	Tue, 13 Oct 2026 14:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791900769; cv=none; b=BMBNatej3J/1+4wyQtVGsQ5v014UhD+X33I5oxMvvMo7baqUA5JOnAYjjc2nrsESTobjjGbSliauJNgs3IdWrRr+V0dhrxsje3vRdx4mCrDustsESdjGYWeUsgML9TtHq2cxmCLdMbwlqenF4cfgSn9SyN+fqA4gfWTG9j8yRU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791900769; c=relaxed/simple;
	bh=qNV404DIR1Mqc4aDJKQovNWTl8kRtkJTp00vwZaFr9A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CZS7bWnHMeeBLNy+gJDR4KseLX7Mjc2QpM+6xyw3RZAfXLZQC1q8ju6SJguCL2A3wB5m2a0RUgbV2gc42ZPdgmmYQm6a3A6rVsidz3n1G2CeQo4A1OLQCznrwEYSxCw4f3KxJ3bCIoOUYJ8F5LdzmQJShyGReYGltN8CbSOGHg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CZHecW7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CZHecW7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60381F000FF;
	Tue, 13 Oct 2026 14:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791900768;
	bh=myQTlTquP0TOZa5/pEIgkOOy5zhZTL0OynJmo/yIUhQ=;
	h=From:To:Cc:Subject:Date;
	b=CZHecW7zJN+KgruOlNRI+VYpLQHUcfdpdmfQ/SCdb4mBdu761OaNU1UilW2Nzobbg
	 S7Wk6KxetWrLybqIJWl8B3/J+Igd2qNSiqWObYY6TV1LFeXvxTNA6X1p1VHqanKj4K
	 Ea1VV0UyBHD6UIjD5rkDrHV69mJ0wVUqoy0WvW1TYxZA8Fh2kHIZZTw4tVIlepnlgD
	 fQ8oCv6tTyUfjuw3Cz+QbvkHhETQL/CJRuC7rcqDCMRXUlpgnRlRzcLJgNYRtaCaA6
	 PjCcCf2+nQRbaGnKeTQP9WGvjajBrvgZfbfrIiQEBGyMTbjS10PRfLsLbYH9ioafLi
	 sTKtiYrjE4Ylw==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Chandradhar Kumar <chandradhar.2003@gmail.com>,
	Chen Cheng <chencheng@fnnas.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Li Youhong <liyouhong@kylinos.cn>,
	Martin Wilck <martin.wilck@suse.com>,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Zizhi Wo <wozizhi@huawei.com>
Subject: [GIT PULL] md-7.4-20261013
Date: Tue, 13 Oct 2026 22:12:39 +0800
Message-ID: <20261013141241.2257621-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Jens,

Please consider pulling the following changes into your for-7.4/block
branch.

This pull request contains:

Bug Fixes:
- Wake RAID10 barrier waiters when a pending-count rollback satisfies
  an active array freeze. (Zizhi Wo)
- Reject v0.90 superblocks whose device count cannot fit the metadata
  format, preventing out-of-bounds access. (Jérémy Jean)
- Track RAID5 disk-array allocation size and avoid removing an
  unregistered CPU hotplug instance on setup or resize failure.
  (Cao Guanghui)
- Validate the RAID0 device count before allocating its device list.
  (Chandradhar Kumar)
- Validate RAID5 journal payload header, size, and checksum bounds
  before accessing them. (Martin Wilck)
- Reject inconsistent RAID5 reshape metadata instead of triggering a
  kernel BUG. (Yogesh Gaur)
- Reject invalid RAID4/5 disk counts before setup and invalid reshape
  disk counts in raid5_run. (Chen Cheng)
- Fix a NULL-pointer dereference in RAID5 setup error handling.
  (Zhihao Cheng)
- Reject RAID5 per-device sizes smaller than one chunk. (Zizhi Wo)
- Fix mddev_unlock() on an unacquired mutex in lbs_store().
  (Jack Wang)
- Give RAID5 io_unit slab caches per-array names to avoid duplicate
  cache names. (Yogesh Gaur)
- Validate v1.x bad-block log size when loading superblocks.
  (Yuchao Zhang)
- Take reconfig_mutex while enabling PPL on an inactive array to
  prevent a NULL PPL configuration. (Nguyen Ngoc Thang)
- Drain released RAID5 stripes before destroying the stripe cache on
  takeover setup failure. (Li Youhong)
- Protect RAID5 big_stripe_tree lookup with RCU. (Sang-Hoon Choi)
- Prevent a NULL mddev->private dereference when stopping an array
  while I/O is being submitted. (Zhihao Cheng)
- Don't publish an md array before md_alloc() finishes initializing
  mddev->kobj. (Yogesh Gaur)

Cleanups:
- Annotate intentional lockless RAID10 freeze-state accesses.
  (Zizhi Wo)
- Add shared RAID write-error and bad-block-sector helpers, and share
  flush_bio_list between RAID1 and RAID10. (Li Youhong)
- Extract RAID5 min_raid_disks() helper. (Chen Cheng)
- Use assign_bit() where applicable in MD/RAID. (Peng Fan)

Thanks,
Kuai

---

The following changes since commit 85bffad4d2fea373a72d68bed8012e8cbccb8ee7:

  block: simplify disk_zone_set_cond() (2026-09-15 06:53:06 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-7.4-20261013

for you to fetch changes up to d1472ca2ca5de8ecd2b358411eb14c031404ecf0:

  md: don't hand out the array before md_alloc() has added mddev->kobj (2026-10-09 11:52:58 +0800)

----------------------------------------------------------------
Cao Guanghui (2):
      md/raid5: track disks array size to fix extra_page leak on error paths
      md/raid5: fix NULL pointer dereference in raid5_free_percpu

Chandradhar Kumar (1):
      md/raid0: validate device count before allocating devlist

Chen Cheng (3):
      md/raid5: reject raid4/5 arrays with too few disks
      md/raid5: extract min_raid_disks()
      md/raid5: reject invalid reshape disks in raid5_run()

Jack Wang (1):
      md: fix mddev_unlock() called without holding lock in lbs_store()

Jérémy Jean (1):
      md: reject v0.90 arrays with too many devices

Li Youhong (4):
      md: add rdev_record_write_error() helper
      md/raid1-10: add rdev_bb_block_sectors() helper
      md/raid1-10: share flush_bio_list between raid1 and raid10
      md/raid5: drain released_stripes before destroying the cache

Martin Wilck (1):
      md/raid5: validate payload size before calculating payload_len

Nguyen Ngoc Thang (1):
      md: take reconfig_mutex when enabling PPL on an inactive array

Peng Fan (1):
      md/raid: use assign_bit() where applicable

Sang-Hoon Choi (1):
      md/raid5: protect big_stripe_tree lookup with RCU

Yogesh Gaur (3):
      md/raid5: don't BUG() on an inconsistent reshape state from the superblock
      md/raid5: give the io_unit slab caches per-array names
      md: don't hand out the array before md_alloc() has added mddev->kobj

Yuchao Zhang (1):
      md: validate bblog_size when loading v1.x badblocks metadata

Zhihao Cheng (2):
      md/raid5: setup_conf: Fix null-ptr-def in error handling path
      md: Fix the null-ptr-deref of 'mddev->private' while submitting IO

Zizhi Wo (3):
      md/raid10: annotate lockless access to array_freeze_pending
      md/raid10: fix missing wakeup in wait_barrier_nolock
      md/raid5: reject a per-device size smaller than one chunk

 drivers/md/md.c          |  72 ++++++++++++++++++++++----------
 drivers/md/md.h          |   7 ++++
 drivers/md/raid0.c       |  16 ++++---
 drivers/md/raid1-10.c    |  27 ++++++++++++
 drivers/md/raid1.c       |  42 +++----------------
 drivers/md/raid10.c      |  59 ++++++--------------------
 drivers/md/raid5-cache.c |  54 ++++++++++++++++++------
 drivers/md/raid5-ppl.c   |  12 +++++-
 drivers/md/raid5.c       | 106 +++++++++++++++++++++++++++++++++++------------
 drivers/md/raid5.h       |   1 +
 10 files changed, 244 insertions(+), 152 deletions(-)
