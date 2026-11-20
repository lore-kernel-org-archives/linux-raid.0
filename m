Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.43.8.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795200494;
	b=p+6ZScrASdJhchv7sSwvx6SxgwrX65YtPbL4+dUPCnjXGooYhmrrLK6REX58CmDptRWH
	 k4ea0npHAYpHCibw2IgTJ/SPV+MZrJPRDDQEcHxQQV4mUfUiMgE8K5yOz5A3ciJNUEj/m
	 hnOUfxz4UKX8vfEINOc+CzdacbQt7Zmom4Iwq9Xdvi1ZgKnhp2opLeERLzVv2CjzZP2NO
	 YzjgoygSZQruAaE4IPj0Ok4NBvCKighQi14m0ZX9PdDC/nukYveWrz7s+GdChWstXjU7S
	 bgFsB53evzRN339x41HHTiEVmGucqqg6Mev7TsCsHHjhXcBJiIdDFHfvWEUJa6vkpcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795200494;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O3u/kRJBi53QixU6FfvIqm48/9jegF4Ymd95gaTPJXM=;
	b=2VEH9HsykjqbdxD83EnTFOiZF5uYSbHJ6bB+QuT8zCQfOW4cyZbkeXwh5foec01qJmBv
	 lZbmn5uydgyjMvvIpybpmQSUQUSy3UylkdqY20Tl9v+U1tmNC8Ypkw3FKXKaDT+C0JnHL
	 tVySK3FKu/3WYdFD1NV6Orys7Nvggl5T9/4HpOUbH8ofKET9DB489Af6wTw8T7/uJqlMV
	 5NAh7DqyJJBROFFufcmOUDVAsD78V/Lgdv2fuM3rRuTu31R6G/8D2gt8vYVIBuJp4RLGb
	 pirhmRQPIECoW39vT9c+QC0T6Jc34YuDZyxXngt/X3GCQDlO0CtwRZWDcPXZU3Y0tKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=altlinux.org;
	spf=pass smtp.mailfrom=altlinux.org;
	arc=none smtp.remote-ip=193.43.8.18
Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DCE606A330;
	Fri, 20 Nov 2026 18:48:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9DCE606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [193.43.11.2])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id A22EB2337B;
	Fri, 20 Nov 2026 21:48:01 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	kovalev@altlinux.org
Subject: [PATCH] md/raid5: reject an invalid chunk size when continuing a reshape
Date: Fri, 20 Nov 2026 21:48:01 +0300
Message-ID: <20261120184801.614123-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid5_run() handles an array that claims an in-progress reshape
(reshape_position != MaxSector) before any later chunk-size validation.
It computes

	chunk_sectors = max(mddev->chunk_sectors, mddev->new_chunk_sectors);
	new_data_disks = mddev->raid_disks - max_degraded;
	if (sector_div(here_new, chunk_sectors * new_data_disks)) {
	...
	sector_div(here_old, chunk_sectors * (old_disks-max_degraded));

The disk counts are checked earlier in this block, but chunk_sectors is
not: the md/chunk_size sysfs attribute and a v1.x superblock can set it
to any int value. The divisor is then zero for a zero chunk size, and
for any product that is a multiple of 2^32, since sector_div()
truncates the divisor to 32 bits, e.g. 2^30 sectors with four data
disks:

md/raid:md0: not clean -- starting background reconstruction
Oops: divide error: 0000 [#1] SMP KASAN NOPTI
CPU: 3 UID: 0 PID: 1414 Comm: syz.1.18 Not tainted 7.4.0-rc1-next-20261104-alt-syz-box-drivers_md_bcache #1 PREEMPT(lazy)
RIP: 0010:raid5_run+0x5a8/0x27b0 drivers/md/raid5.c:8116
Call Trace:
 <TASK>
 md_run+0xea5/0x2a00 drivers/md/md.c:6808
 do_md_run+0x32/0x660 drivers/md/md.c:6909
 md_ioctl+0x2ab2/0x4040 drivers/md/md.c:8541
 blkdev_ioctl+0x5a9/0x6e0 block/ioctl.c:798
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18a/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x112/0x630 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x00007f562441a40b
 </TASK>

Writing 8 (bytes) to md/chunk_size, a non-MaxSector reshape_position and
then RUN_ARRAY on a raid5 array is enough to trigger it.

check_reshape() and raid5_start_reshape() already reject a zero chunk
size, but an interrupted reshape is resumed by raid5_run() itself and
goes through neither of them.

Reject a chunk size that is not positive or makes either product
overflow int.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: f67055780caa ("[PATCH] md: Checkpoint and allow restart of raid5 reshape")
Cc: stable@vger.kernel.org
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
 drivers/md/raid5.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d52adf81065a..e31ae5d6eece 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8113,6 +8113,13 @@ static int raid5_run(struct mddev *mddev)
 		here_new = mddev->reshape_position;
 		chunk_sectors = max(mddev->chunk_sectors, mddev->new_chunk_sectors);
 		new_data_disks = mddev->raid_disks - max_degraded;
+		if (chunk_sectors <= 0 ||
+		    (u64)chunk_sectors * new_data_disks > INT_MAX ||
+		    (u64)chunk_sectors * (old_disks - max_degraded) > INT_MAX) {
+			pr_warn("md/raid:%s: invalid chunk size for reshape - aborting.\n",
+				mdname(mddev));
+			return -EINVAL;
+		}
 		if (sector_div(here_new, chunk_sectors * new_data_disks)) {
 			pr_warn("md/raid:%s: reshape_position not on a stripe boundary\n",
 				mdname(mddev));
-- 
2.50.1

