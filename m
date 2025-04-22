Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153432777F9;
	Tue, 22 Apr 2025 02:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288347; cv=none; b=d4bOimFhcZb4x6StVX3patQ3F9KNHLPwYDi0hK2Y7vAML9KCztPbTLTRwsFmwmoErIefZWxudZQt4L7TwCEnkutw6ghNxK3oLdJnzO9Xe0sdOj42GRM/EYNL9V4sjfAv8kya+QkKlywBno0o5vnb2dNtNnhxZQPmWnfcQvnZsBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288347; c=relaxed/simple;
	bh=Sn56wi909LIqh56kmvMhFfN+gsPaBfnynrO1Lc4YmoM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hpsgrK9/aDRjnjWkCif+QyIlLbr44d/wZX6dLaN9DWgYffFC7qvsxSy0a94W/XZTKngM266CM0evRH3trBHospm/LAWqmc2ihYrcua2pQmnSBedIQ1BPmZJZYNKxDF2CojZ3Lc2rXHZP7fuhdxVAOX02y4zOYhRbI0LvBLmK7JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AkO4tPMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AkO4tPMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B423EC4CEEC;
	Tue, 22 Apr 2025 02:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288346;
	bh=Sn56wi909LIqh56kmvMhFfN+gsPaBfnynrO1Lc4YmoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AkO4tPMWTBt797LNw++Zw2HSW/9A4+C1JFtHDEr5AZv8NkDWuVB74RMrzcM+DK34o
	 iQEpchFIUPMAiL5Bv3SnrTVDdXFa8FF3AUuWtAajqXHu/hCXhSP+vncrbqecsvdWEu
	 g8JCvMKv1TMNdFYxfhZjYL7QVsIh8k8UHJuOtzjcu75n+KdtRJgwQZlcMpvTjli8zo
	 rYX8onkOLFIH1pdyy+cCx9e1Wx2Rgnzdm0zkQ8JJfBJxTz/I0v48cLoY8JXzds+kR5
	 69FDIGarwXWQsjWOUQkaXGG6NKzPhS/dPZi7HHVAMr96RDu//mWw0uHziwH9RPB+Gg
	 3rfEz1pFfbu6A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Meir Elisha <meir.elisha@volumez.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 2/3] md/raid1: Add check for missing source disk in process_checks()
Date: Mon, 21 Apr 2025 22:19:01 -0400
Message-Id: <20250422021903.1942115-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021903.1942115-1-sashal@kernel.org>
References: <20250422021903.1942115-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.292
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
index c40237cfdcb0f..395a279e2c885 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2051,14 +2051,9 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
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
@@ -2198,10 +2193,21 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
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

