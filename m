Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DAC18784A;
	Sun, 28 Jul 2024 00:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722127757; cv=none; b=Hu2JWKPGZ1hBcFvEq04Ik9cxAPn8kdQKxfjhhi0/9kyrdHoLD2IJZ73LK+65BbUTL6qT4xswqFSNKCVhzgh0voUwekwL77Hi5rerBftinD7g1eeqpg5BdCT3yOauiqI/wky/se/3u/tOA776M7kNHhTKKpEkvkRGpNcBTGLdBfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722127757; c=relaxed/simple;
	bh=etv8VkN+fQ0b1P4YvAek6eRzsIgH6uAOhx1tMQyv6/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZwu7D3RC88JLsyWhM2KtvycJYvAN/5wRHAIwMkfyGUZpG64pVy/1OQbBMP6mvJXDapr3b00oGhJUltGKsciNshKSwz5FrpE5gfLWNjbqZq9lYW+zAOSUKs1oCn/G1DvXgHcklpZUiFPv8yxVQHMQh664HSSq50j99G709N5HMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JchrSEdr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JchrSEdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71399C4AF07;
	Sun, 28 Jul 2024 00:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722127757;
	bh=etv8VkN+fQ0b1P4YvAek6eRzsIgH6uAOhx1tMQyv6/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JchrSEdrtTWUi7SUAxef3FK4ezLoCtPebzltD5UcNVPq0aTZ1PXoq4q6QA/Py9gTO
	 Dd5g/GbgYC5RbijnXqwR3HMfPzkK0j6PY9fbEvfV7BoIvqY36UvTZRq1Gev4s5ek5v
	 iE6orAY6cG3kamB4EswS2LkFu+StCOIVkVHBrIf2DoCrxjdX4vycOJCmsJPgPHuKYN
	 5o2gw/Aeqfa68+wFY/PugfuHAr3LBIKrLQNPT8hBeaw6p/Gh+HT414bNPK4/SoZqM/
	 md9NB8BDAB3IZy7q+AsVtZMsQe+obfe8fyUMFK7l36XPIQPepcgxgyg5pQqRYavWLy
	 cojGOb4QDA0fw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 2/3] md/raid5: avoid BUG_ON() while continue reshape after reassembling
Date: Sat, 27 Jul 2024 20:49:11 -0400
Message-ID: <20240728004913.1705252-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240728004913.1705252-1-sashal@kernel.org>
References: <20240728004913.1705252-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.281
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
index bba5e61cc1456..41556f5d4dcba 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5821,7 +5821,9 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
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
@@ -5839,14 +5841,18 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
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

