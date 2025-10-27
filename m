Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46932FE057
	for <linux-raid@vger.kernel.org>; Mon, 27 Oct 2025 15:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577516; cv=none; b=pRZNA19f0kDxc+U6sSgPiZ4MHzDjT1sycusqygdisZhxjEPpjQJGwxmN0R0g78ggOkwl4f2spbuBdPqBtawzlT1zQNRdXQ9xxhlM/lhDBNO5gH95gVwmxp3mIZab5HJ1Lq5E3KwTW2SeiBheqa9vJMTDJWLlsTCO6QMmwBAox/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577516; c=relaxed/simple;
	bh=REdJID8evdRNIV2SALKM9j+CDHk2lNYcuzoh5ecGRG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4m3yQvcDP5bWRhSDA5yeoqKhZrxWEb1WskluMQXPA+nO+wdlGLG1jKKJh+J30Axq/LR++oPEdgXdmqEXtoSRWaYFuMbxMeAe2Bunhj4vDtCQ1pf0xn5a5CRZeo7qF/xnMVPxtLwrQ/1kH3NLueHPSR20cXALS3WFl9hGj8VNOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=jCSr0Rb1; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="jCSr0Rb1"
Received: from fedora (p3796170-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.173.170])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 59RF4hAo090988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 28 Oct 2025 00:04:46 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=GEzNtrrxCNuYas2ZIUicNm+BKzW5PcfO8c9yQJ8eNLY=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1761577486; v=1;
        b=jCSr0Rb1CXVZvPif/aR5OkLs7kSDgpYTWcF3zmuVdajPwnFnjum3aprU4hVXp/ZA
         dwbDaXj0wsF8HJ2GZJBMS7DEMb+hgHKId3JpdVuvNm8KkS19KZlGoYRnApozKpbo
         gNlv9OPm/Ffja1uo84OampodAsMcYGkaPmvYca1N3RGprO/GIt31kcj3OJ3gSSDL
         aWSbZGpi3smAcV9r7PNYBwTQaUZTit5JajunCYOf00ypK4lEqYairunu9EAcW52e
         g2okWUEd1E2iHXSku7lehi9K9qLwAp/sXEaKSiVe6cIAziKdkg8Nr6YFR53CP8r8
         DnnwwkPdJy5/e/9hERAGWg==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v5 14/16] md/raid10: Add error message when setting MD_BROKEN
Date: Tue, 28 Oct 2025 00:04:31 +0900
Message-ID: <20251027150433.18193-15-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251027150433.18193-1-k@mgml.me>
References: <20251027150433.18193-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Once MD_BROKEN is set on an array, no further writes can be performed.
The user must be informed that the array cannot continue operation.

Add error logging when MD_BROKEN flag is set on raid10 arrays to improve
debugging and system administration visibility.

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/raid10.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index aa9d328fe875..369def3413c0 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2031,6 +2031,10 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 
 	if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_disk)) {
 		set_bit(MD_BROKEN, &mddev->flags);
+		pr_crit("md/raid10:%s: Disk failure on %pg, this is the last device.\n"
+			"md/raid10:%s: Cannot continue operation (%d/%d failed).\n",
+			mdname(mddev), rdev->bdev,
+			mdname(mddev), mddev->degraded + 1, conf->geo.raid_disks);
 
 		if (!mddev->fail_last_dev)
 			return;
-- 
2.50.1

