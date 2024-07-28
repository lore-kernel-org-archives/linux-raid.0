Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395397B3FE;
	Sun, 28 Jul 2024 00:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722127704; cv=none; b=Poka6BOh9TyIncmhe49O5UCiG90zRoDshVrQIbxEuEv9zrVUmzIF+Nid3/csXqgmPujFXZ/ZhEe7Na0ysb90e3e2pkRieMXkbtUamqBShvp/+cvmGxDTDYV+mCHkGEGw/mvytyvAbAvUSacimpFYES+0T5LbpoRzK1Bjv1ccVqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722127704; c=relaxed/simple;
	bh=HaKCViKiQULRS16apVrDUEKp7bHHHV5NyX8Lz1CLW+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrgDwPhEn4PpcAe9UspSI5FSNP6aGdP0lyj305W87pndAa70yFyh6vtXsLHXttdRd55cwZf+xe4qQXxUUzWflbs3XJY8798N0q/KegNMroPcreSNeI1iiRCpXkna8QY267ArEqrWZHs18HXWPtjKjeijqVCqfJO4y+loL9wG8VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E/IGp5D+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E/IGp5D+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464A3C4AF07;
	Sun, 28 Jul 2024 00:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722127704;
	bh=HaKCViKiQULRS16apVrDUEKp7bHHHV5NyX8Lz1CLW+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/IGp5D+u1ichW0dxP60NNj2X1ktUkZjfVC37FfvaqcldngxqlbMsI0MZcAgK0vot
	 C5xnQCwutWl96ywAvKVXFUdfdauNjL80CbX77o1nICaFHi3JKYQK3CyKtqDdQDbVNI
	 XH0AJ1vKlxG+awJFvr1YJdNQOOklHNAIEUc00CCiCw+UU6yPr4p4/dJMCQhtFKT0c4
	 vlP6bN9D6ybi1y9EvvhrEmw3008MgbbtIfhyGdt74mP4TpHCVi08zPKkElOSM1gN19
	 wMudTH6JRAhcMuxiMNsGjIlHDoDzVd4tbV2GoP/oeUGXrKLDfcZFhP+9yCe7wRbL6C
	 seo8VzDqkHTpg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 6/9] md/raid5: avoid BUG_ON() while continue reshape after reassembling
Date: Sat, 27 Jul 2024 20:48:07 -0400
Message-ID: <20240728004812.1701139-6-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240728004812.1701139-1-sashal@kernel.org>
References: <20240728004812.1701139-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.43
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 305a5170dc5cf3d395bb4c4e9239bca6d0b54b49 ]

Currently, mdadm support --revert-reshape to abort the reshape while
reassembling, as the test 07revert-grow. However, following BUG_ON()
can be triggerred by the test:

kernel BUG at drivers/md/raid5.c:6278!
invalid opcode: 0000 [#1] PREEMPT SMP PTI
irq event stamp: 158985
CPU: 6 PID: 891 Comm: md0_reshape Not tainted 6.9.0-03335-g7592a0b0049a #94
RIP: 0010:reshape_request+0x3f1/0xe60
Call Trace:
 <TASK>
 raid5_sync_request+0x43d/0x550
 md_do_sync+0xb7a/0x2110
 md_thread+0x294/0x2b0
 kthread+0x147/0x1c0
 ret_from_fork+0x59/0x70
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Root cause is that --revert-reshape update the raid_disks from 5 to 4,
while reshape position is still set, and after reassembling the array,
reshape position will be read from super block, then during reshape the
checking of 'writepos' that is caculated by old reshape position will
fail.

Fix this panic the easy way first, by converting the BUG_ON() to
WARN_ON(), and stop the reshape if checkings fail.

Noted that mdadm must fix --revert-shape as well, and probably md/raid
should enhance metadata validation as well, however this means
reassemble will fail and there must be user tools to fix the wrong
metadata.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240611132251.1967786-13-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1507540a9cb4e..2c7f11e576673 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6326,7 +6326,9 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	safepos = conf->reshape_safe;
 	sector_div(safepos, data_disks);
 	if (mddev->reshape_backwards) {
-		BUG_ON(writepos < reshape_sectors);
+		if (WARN_ON(writepos < reshape_sectors))
+			return MaxSector;
+
 		writepos -= reshape_sectors;
 		readpos += reshape_sectors;
 		safepos += reshape_sectors;
@@ -6344,14 +6346,18 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	 * to set 'stripe_addr' which is where we will write to.
 	 */
 	if (mddev->reshape_backwards) {
-		BUG_ON(conf->reshape_progress == 0);
+		if (WARN_ON(conf->reshape_progress == 0))
+			return MaxSector;
+
 		stripe_addr = writepos;
-		BUG_ON((mddev->dev_sectors &
-			~((sector_t)reshape_sectors - 1))
-		       - reshape_sectors - stripe_addr
-		       != sector_nr);
+		if (WARN_ON((mddev->dev_sectors &
+		    ~((sector_t)reshape_sectors - 1)) -
+		    reshape_sectors - stripe_addr != sector_nr))
+			return MaxSector;
 	} else {
-		BUG_ON(writepos != sector_nr + reshape_sectors);
+		if (WARN_ON(writepos != sector_nr + reshape_sectors))
+			return MaxSector;
+
 		stripe_addr = sector_nr;
 	}
 
-- 
2.43.0

