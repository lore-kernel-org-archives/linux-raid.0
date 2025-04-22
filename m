Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BFE25E835;
	Tue, 22 Apr 2025 02:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288256; cv=none; b=H2ss/+9P1REWWUiw/Yjbsc5mN6O5KK+rfcG6Wd6zoBOI6R2ffX41EER0gFg2854UYSwIIWyPuZqinYnlcEMtjHCc4XSI0djOUNW/7PJhBDC2gNEu5WXYyZrlF0HnpoapC49a70JhCbgbT3gi1MTBqvVbJ+opfLSyapl5phznwk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288256; c=relaxed/simple;
	bh=6Mv3OiLkxsIp1YkuuADzsY7fnK3Kf5tAbvBtKM+k194=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZB2nFx/l/qMJuqczD53aZjLsGaMY2eMBv/GDkvNQ8HgKmr7oR7a7blHKIiXWgeIRfJzxrySZYLgKvvZnG/LvNajG5L9ZtJFKU4hMsXwDlMHz8JHhbb+tD5f3EX2oOAVuTRplF7pV6BOCnYMgaS+rva8T2axFI+lBUVOwosiRiCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Clgw4Avi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Clgw4Avi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88355C4CEEF;
	Tue, 22 Apr 2025 02:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288255;
	bh=6Mv3OiLkxsIp1YkuuADzsY7fnK3Kf5tAbvBtKM+k194=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Clgw4Aviw2S5jb/uZu/CfyZ56xmfjs/ypEzEg7QIFBOsFRdFEOxokaJ5wbACB9YuW
	 /cDQ4lDL1of8Py9uy7E2PtmDe/xyu6YqzpiCUpfe2xSv+FaJz/6jEb4DzM/QjsU0da
	 kMzGzW2Jnd+NQ+PC1ZvsVG113r/xR6cVv4v77SkH4BYDuSA8lhR0d0mNucw3qIFT9v
	 OGz9I4LLG4kitYqr5ulmvjIlsxyufJzmh8omUX4yXB27LYOQ9kvBJTcAhiVoQTkJdC
	 E6RCFBRwHc47YBpaJXAC4jNWMypjVPp/ZybcaGQiIBN4H6GuOVSykvX1VHRhtBbP1W
	 xxDojZcG9oZqg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Meir Elisha <meir.elisha@volumez.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 19/23] md/raid1: Add check for missing source disk in process_checks()
Date: Mon, 21 Apr 2025 22:16:59 -0400
Message-Id: <20250422021703.1941244-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021703.1941244-1-sashal@kernel.org>
References: <20250422021703.1941244-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.24
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
index 8a994a1975ca7..6b6cd753d61a9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2156,14 +2156,9 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
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
@@ -2302,10 +2297,21 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
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

