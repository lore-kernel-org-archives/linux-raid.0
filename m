Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E72826B2AC;
	Tue, 22 Apr 2025 02:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288323; cv=none; b=LE44uGaKvFpbnzK/wvw6695Wb4MUUWkpkWtR3LPnwutgnVHNkZz8Bk5cU0nTjNBwthCw1FX4TOg/2e1g4ky7Gv8WMEChDIoxIhM4eNd5rfggeJE1hclXbedLAYqwWbzwkSthml9Ga91KcrgC2O68kdassf2GEHp6xymgR7t4Igg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288323; c=relaxed/simple;
	bh=0cRwv05oQMlAOa5j7nqgo0opysRLENIWkjgjFBXs3b0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YIk2h8ChK0RWdf0tTpqoNi5rhnxkA03gHLyjz6V5a8KGNAfJdXQUGVZaYnm3vEo1VBszwtuHt93vstiRFOkZ40YU/Ouh5oQ//0HP6BFYf5P1xHBoRptV30HR39gK3o5hgQSGhNULB7iy47Bda3IQUxMJmYIoMD7NBHiCohfQvNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EKFG3PpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EKFG3PpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1538FC4CEEC;
	Tue, 22 Apr 2025 02:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288322;
	bh=0cRwv05oQMlAOa5j7nqgo0opysRLENIWkjgjFBXs3b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKFG3PpVZw32KjXXB+vbjKmisEFJ4C9KnfYtnjgmjc11MZa9OIA6Bd8JEG0alg8Vw
	 dxYhTFYP4tYtT/SPJl1sHI8f2eGvnABCK8dkV6s6dKxYb3bSLBw3m3GAa1ZEQBkPOu
	 jE4UEqqChRiWbUTPKFoCE5Un8fXOQOxyCM5MMvbljNYjZ2VFvdrulj+Gr5h8dPTjcJ
	 yBTegtkSv7pNkfMl/uCTRfZqngDDhc4IN/2UrFX7n5lBPrZDPb78j7MXGH87t5odMg
	 ajqctf6tSIM+xv50KD0cDqBBMQE3tarCk9rNy3eO/SdC+g4SrdfWC970/MzP2T6eM4
	 HlHmduOxb8eyQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Meir Elisha <meir.elisha@volumez.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 10/12] md/raid1: Add check for missing source disk in process_checks()
Date: Mon, 21 Apr 2025 22:18:24 -0400
Message-Id: <20250422021826.1941778-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021826.1941778-1-sashal@kernel.org>
References: <20250422021826.1941778-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.134
Content-Transfer-Encoding: 8bit

From: Meir Elisha <meir.elisha@volumez.com>

[ Upstream commit b7c178d9e57c8fd4238ff77263b877f6f16182ba ]

During recovery/check operations, the process_checks function loops
through available disks to find a 'primary' source with successfully
read data.

If no suitable source disk is found after checking all possibilities,
the 'primary' index will reach conf->raid_disks * 2. Add an explicit
check for this condition after the loop. If no source disk was found,
print an error message and return early to prevent further processing
without a valid primary source.

Link: https://lore.kernel.org/linux-raid/20250408143808.1026534-1-meir.elisha@volumez.com
Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 76f7ca53d8123..38e77a4b6b338 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2068,14 +2068,9 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 				if (!rdev_set_badblocks(rdev, sect, s, 0))
 					abort = 1;
 			}
-			if (abort) {
-				conf->recovery_disabled =
-					mddev->recovery_disabled;
-				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-				md_done_sync(mddev, r1_bio->sectors, 0);
-				put_buf(r1_bio);
+			if (abort)
 				return 0;
-			}
+
 			/* Try next page */
 			sectors -= s;
 			sect += s;
@@ -2214,10 +2209,21 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 	int disks = conf->raid_disks * 2;
 	struct bio *wbio;
 
-	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
-		/* ouch - failed to read all of that. */
-		if (!fix_sync_read_error(r1_bio))
+	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
+		/*
+		 * ouch - failed to read all of that.
+		 * No need to fix read error for check/repair
+		 * because all member disks are read.
+		 */
+		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) ||
+		    !fix_sync_read_error(r1_bio)) {
+			conf->recovery_disabled = mddev->recovery_disabled;
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+			md_done_sync(mddev, r1_bio->sectors, 0);
+			put_buf(r1_bio);
 			return;
+		}
+	}
 
 	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
 		process_checks(r1_bio);
-- 
2.39.5

