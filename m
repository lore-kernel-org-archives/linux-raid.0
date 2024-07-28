Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6A3146000;
	Sun, 28 Jul 2024 00:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722127737; cv=none; b=EeSeR8iJM7Fh+tMT4t94qgMq4CeGN3II5UHA2Ja+rl15nYSx+AWVBTrcI4tBpPPcGq9WFDnSL9iIopDGwaLnon+rD6/jdfym+CmgJp2boPl6w20tx4e4z5/S7zGmuV/udb7pmdebJUkSxzb4fxT7skcz6YeYbNGSJZe7rcv9H3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722127737; c=relaxed/simple;
	bh=SGTFrCcVi3wFvI4RBGS0jPpyYv2tdXi1kfUuG4s2C5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRdRZXmKkL2yJbb6P0PwB2vMvvTcWsIaiLG/Lv29K0h9Xf/cWWPuXX+7ap3GpI/th9gyH4o2iQuIAfuH+728YSzmcvuq4VgQUxJrctSmoxewWHBfvnVlFWfkP94gcF+pOEyiGfTpfNbulxk8Jtf/zZHfnIUitUNBDvnbBptRkAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LEZGy8CV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LEZGy8CV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A7AC4AF09;
	Sun, 28 Jul 2024 00:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722127736;
	bh=SGTFrCcVi3wFvI4RBGS0jPpyYv2tdXi1kfUuG4s2C5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEZGy8CVBtWP3KM9PdpSACx/LMuCPgTS9/psVOUvXYtTzY9+T41jpKcoeKihtqXAp
	 enV37wn+HvOyWTfddSDr7EoAJ9oihrscAN5HjhYA42MHehreUbKe2Hl+eXGoMSrqKT
	 xd8fIjF1/B0vy9b7vuXv3Xc6YScd44mCaksFShZfrcnwIemMEFTpDZdXbpmGlWDgVZ
	 IYXzsXrn4VK8dVspjXXPxFN1DJU6hNzAj3VclclACMEFjE4hJ6f4bbH5YNGxOnABpU
	 UjxcsPNq9H0P2mLlY13x3zBwbKrjmpDoR0pmDB2lWk2bPNdIh81Uu5fzzpG5osYO6h
	 thFBe/LG5Z+JA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 4/6] md/raid5: avoid BUG_ON() while continue reshape after reassembling
Date: Sat, 27 Jul 2024 20:48:45 -0400
Message-ID: <20240728004848.1703616-4-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240728004848.1703616-1-sashal@kernel.org>
References: <20240728004848.1703616-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.164
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
index bcd43cca94f9f..87b713142e15d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6007,7 +6007,9 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
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
@@ -6025,14 +6027,18 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
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

