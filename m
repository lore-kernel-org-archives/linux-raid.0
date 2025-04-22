Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336D12512C3;
	Tue, 22 Apr 2025 02:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288192; cv=none; b=I2sLZGmme6u40CL8ZEIAqWWeYqm8V9rYG99yK8KBja/3txnNw8U6fabdjG+HogAY09AE2i2Gp5qZjgVuRqbQTcPCOT0oPuxZf78kyFSsSsBKOrDNiYOoGzLtrJyiLQpO6MVO/HaZ9ITyxkRyAuV+osLa9dIRsTrOYnxR0Ah+G10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288192; c=relaxed/simple;
	bh=5sh30OSZDjiP8D7TjxqFQH3dDrseTqCBhKt0Obutt2A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h56iGEixJkrz8Mzs4D90+zCH/nSr9uXppxvy5jYXYgiPgkppj5yE4b8kh+t/oXrhmPdwarlYHO+qtyYulf4KHtO+NTYdms3rg5IAD8QEZOdUyIQuW5kUoBK67rpv7Dl7kCwR+duOOcGm0b0p+5FZuC3ePKF5eZmc7aIOFu1Vz54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ThQHWZ+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ThQHWZ+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F41C4CEE4;
	Tue, 22 Apr 2025 02:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288192;
	bh=5sh30OSZDjiP8D7TjxqFQH3dDrseTqCBhKt0Obutt2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThQHWZ+SR+cSqldir9+Ilq4t4+TM5i1gi6zsgDRFjJs8bqw3qoCc74Z31e8U5hWzb
	 m313ZgKSEWnXheLtwoa2TUtUyz6bV0vil/fEbsNItPQuV0Ok8kSMXHLDTY7Suj2CZM
	 uSw40GyfrNFq6TYmH8Nv6e7FYll3ShtZzXKUHzwNcqhwZUvGciR/NN3hqW1f5Uf03S
	 XtHID/KT74cxK2UzvcPvhPalFps986inw8v7me5sEUEU5ASGRFZuxwQiYfL4dhYTNA
	 95JxxLbGErK3zGTZ9LcMtx43f9FPXo7eGPTAH3eNbqO06kghQWIinn24ZsYvkSl1jx
	 RtWiZ4DggQKbw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Meir Elisha <meir.elisha@volumez.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 23/30] md/raid1: Add check for missing source disk in process_checks()
Date: Mon, 21 Apr 2025 22:15:43 -0400
Message-Id: <20250422021550.1940809-23-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021550.1940809-1-sashal@kernel.org>
References: <20250422021550.1940809-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.3
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
index 15829ab192d2b..7373dff023d0f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2199,14 +2199,9 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
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
@@ -2345,10 +2340,21 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
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

