Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A60D3148A7;
	Sun,  2 Aug 2026 19:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700261; cv=none; b=sCjDG9LMp1aW6fDOb0vQS0L1OArunZJBzbLdakBQKPxgtlyXTKmJt0ye1i98Zpj2fe4CJ71fTaLBB7vtuNomaF89Axp2v+dzzf2g70iE7gFmfbUYoxBkdkqzYgDNab4oKgkDCNeVaOI4laIrWJd84JvD4gE9vQ9IfOAlBTJ22Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700261; c=relaxed/simple;
	bh=zE8MuNNSsd02gI5QB1ckg1GcfIAg2lMqfGsE4HFnzWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQ1/1/Eowov7k7qTxSIQZgOfWz0Kyy/N8V3lDgZPd3QuGB/31aULrXAZe70Kg+GritnV2mSdZXiWmn5spHDxs65qEinUt0N6hTjnAwLNGXnZqTJHQIiEPP/5SGQ5AqU2SN3KstLhrQ8/eAcIhQwQDRji7O3SvozujPRi9geIwIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hLE2ZYj8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hLE2ZYj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C1A1F00A3A;
	Sun,  2 Aug 2026 19:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700260;
	bh=K/DY461iIKDMYubR0PpYjGrDymcuRKKSv7V6DaMlsKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLE2ZYj8vCXxbEuuWvYb8za7w6xm4CoIgaWmUGLxlByfQzbgN8Va6oOMFO5tftUvw
	 lxMqM56r6fwLgTtYZHZu9773tqcsjCPb33USBE/JN+tzjhYbOUCInDLzTE7vCkK3Xy
	 zw9AKr+CuiFruEBE525nz1lewf4xg2+LLXdF64+KiWQz9X8vOgCNYsIqmsUl5xCijQ
	 h6gCPmVUdJHTM1GbXCv0PVyI/90Sbhrnsv7Xhs/kfeSr8b21eCrXWo/fanigfMPL+M
	 jlKMadMR+1/tGun+6C2/JO/vGAyIUuG2b3hkO0smbE115RRP9dzkco9bD3ccMQ8dvs
	 OPpihtwvYZUKg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 04/29] md/raid5: reject zero-sector reshape chunks
Date: Mon,  3 Aug 2026 03:50:13 +0800
Message-ID: <20260802195038.164272-5-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802195038.164272-1-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Sashiko reported that RAID5 can accept a reshape chunk size that becomes
zero sectors. chunk_size_store() stores the sysfs byte value as n >> 9, so
writing a value below 512 bytes sets mddev->new_chunk_sectors to zero.
RAID5 then accepted that pending reshape geometry and raid5_start_reshape()
installed it into conf->chunk_sectors, letting reshape code divide by zero.

Reject zero-sector chunks both in check_reshape(), where normal sysfs
requests are validated, and in raid5_start_reshape(), so assembly/resume
paths also cannot install zero chunk geometry.

Test script: in QEMU, create a plain three-disk RAID5 array with 64K
chunks, write/read back a small pattern, write 1 to
/sys/block/md0/md/chunk_size, add a fourth disk, and run mdadm --grow
--raid-devices=4 --backup-file=... . The script scans dmesg for divide
error/Oops/KASAN signatures.

Bad kernel, eb29914412c3:

  echo 1 > /sys/block/md0/md/chunk_size
  mdadm --grow /dev/md0 --raid-devices=4 --backup-file=/root/md0-grow.bak

  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
  RIP: raid5_get_active_stripe+0x863/0xc10
  Call Trace:
   raid5_sync_request
   md_do_sync
   md_thread
  Kernel panic - not syncing: Fatal exception

Fixed kernel: echo 1 > /sys/block/md0/md/chunk_size bash: echo: write
error: Invalid argument chunk_write_rc=1 grow_rc=skipped RESULT:
REJECTED_ZERO_CHUNK_NO_OOPS

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e2c5a7072aca..d128d238e1da 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8548,6 +8548,8 @@ static int check_reshape(struct mddev *mddev)
 		return 0; /* nothing to do */
 	if (has_failed(conf))
 		return -EINVAL;
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
 	if (mddev->delta_disks < 0 && mddev->reshape_position == MaxSector) {
 		/* We might be able to shrink, but the devices must
 		 * be made bigger first.
@@ -8591,6 +8593,9 @@ static int raid5_start_reshape(struct mddev *mddev)
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
+
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
-- 
2.51.0

