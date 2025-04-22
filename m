Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC2D267398;
	Tue, 22 Apr 2025 02:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288302; cv=none; b=EdCkVrAx/b39KR/cZvs1uh3uulSqSNTe1uHb7u2GoQ8TKMWA687Z5lrTijvmTZ7xcx3N/pafZZ0cr8j7SCZEOZvnX8XENCeoNjUxIAd/wCjQOGrx8v8JbKnGHc/Tvl/RV47GZAPntSK/RXY8o3cfw5HmGiCBlZrrQbVxOrv0Weo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288302; c=relaxed/simple;
	bh=uEYhvK94dSqS6iiv5H95JMXtZNS4ftFD2LZNDXAhSzo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rPFhj6wR3pKSd7lZEqTg/kOhTbmM5sJwJDPV+xctLkmQmXh/nxC6GIvpXXRDbRDgUP5vAMZ8VuMADw8qLp+VLZ7+7dT4zvLbZJiXePOMuPEN6LxBbAc1Np4hdKKTBbZGoucX3LvnCb6k7wwjr3eXpAxgeKrurHS0+NiiwVLZPVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qqbqrb+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qqbqrb+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77032C4CEEF;
	Tue, 22 Apr 2025 02:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288302;
	bh=uEYhvK94dSqS6iiv5H95JMXtZNS4ftFD2LZNDXAhSzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qqbqrb+CC4Lg1432ifTunzsp3hk4aB2kd4rtPpbA7RfjE6Ws+cBSr3U5YaXC2oe+4
	 ikSETWiCwhvFHp4/seODbLU7FG1dWbKxXbcSI8o3XdD9sgEUp8x/BtpJsn4Ww4MtDy
	 xh3ZV1WdCqxKndDs4lJCDJG8euK/0ZSBwQoxUgA/wbGeAtoZTkZ2w0tsyl0rTtbfMJ
	 4mqlDPNJKv+o3IFpovBdX/pDeML4aiLJayk7h/4HvGODnnQn6TM5l2nrwaTG1yoDck
	 4LvtoockMSdTfl86IL7ntBlG4dIsk3qjGjBk3cVKmQ6Uet2GuOhnBdbnfBkjtvIP6k
	 eTCh4maTjVKAQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Meir Elisha <meir.elisha@volumez.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 13/15] md/raid1: Add check for missing source disk in process_checks()
Date: Mon, 21 Apr 2025 22:17:57 -0400
Message-Id: <20250422021759.1941570-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021759.1941570-1-sashal@kernel.org>
References: <20250422021759.1941570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.87
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
index 65309da1dca34..8b25287c89ed6 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2061,14 +2061,9 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
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
@@ -2207,10 +2202,21 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
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

