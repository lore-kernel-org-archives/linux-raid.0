Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B11338595;
	Sat,  1 Aug 2026 17:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605166; cv=none; b=dOxApUXuqd3118eDe8/eTvctaAsiZPKZwbU+EwoP6Ip+7c+otC8w0nbhaoLM6w4AU0/SlYPhfjUA4P+lYCs5tvsenZq4X+02ab3NFlX7CBm9DIw3CZJOQJ61fd6Lz+z3CGT5tZQ69PP3F6gaGvk+8fLQujd3niN+shPuzNOE/KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605166; c=relaxed/simple;
	bh=LTFkztd/McgpsPIR/uPOxT8v1TFCYZGx6jvbRYw0/KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VY0hoJI/2Jin5Mz8Xtk03Y4iSEvOQBM3vzJICdz63/lztHCC35GuJ6YHhgN4kQcAYa0GIR2LkwJYNJC0UvFVOCCSDdaIuzj0ujeIPoyGJN+JNMTanRL3TQqWExSvP+ahC3Kf0h+M03ZkBhwJ88Ibxw0NDf7wNB29YQ32avuY9no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HgYXEfKZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HgYXEfKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535A11F00AC4;
	Sat,  1 Aug 2026 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605165;
	bh=cBGJhnuC/GXO4gmNekmp+QNeV9Iz6ZZPjuvwuklDMsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgYXEfKZ1Zm14adIJ3eSHRfTHfcDVeLOZ/Ab/nNvQjS+r+bxCx5PYFNvzfeshwfrG
	 4fj+3+SgRVUG8wCQyPyqKtnB8IIbuXCA9X8jU5uJH+pInmIwwJkMKIF9uYrGWstoKD
	 sFeu77FWmY3FpQlMoDfxMGDCWJzs7J9qGoDw6MLnfXZ4HsQ3BOvX5BsPa7LKOyQ0Q5
	 YgPtbX7KrpScqLq9Pkeg9zkN7gIyXUxuEv/bx4olSKbduI6tt5vy0WQvsB33/B0B3Y
	 0o56FDKdTsM02EfWNz4qavWCcM7jywnOX5WVMZp25Rr+rAAtusFgA9/oWz5hZX2u7H
	 KsQKatgPqYIZw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 04/25] md/raid5: reject zero-sector reshape chunks
Date: Sun,  2 Aug 2026 01:24:58 +0800
Message-ID: <20260801172519.2982121-5-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260801172519.2982121-1-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
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

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0c5c9fb0606e..4276b125f94c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8479,6 +8479,8 @@ static int check_reshape(struct mddev *mddev)
 		return 0; /* nothing to do */
 	if (has_failed(conf))
 		return -EINVAL;
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
 	if (mddev->delta_disks < 0 && mddev->reshape_position == MaxSector) {
 		/* We might be able to shrink, but the devices must
 		 * be made bigger first.
@@ -8522,6 +8524,9 @@ static int raid5_start_reshape(struct mddev *mddev)
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
+
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
-- 
2.51.0

