Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60F62C3268;
	Sun,  2 Aug 2026 19:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700273; cv=none; b=OIUDZGF6hmHKtQka7HkYnQ90YDmnmIbkuHUFK9xuy4ZESvJH1dH2jEzl+R2sYOcn44FeFSCFIY2D/J+oDOc/78CTPpxOyeCBsDhJceRl7qGvGpwG/2elX8aICP+2zyM0c91dmzbc4B1jvGTdEH//fQyG8EL8j5usSz5PQp27rM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700273; c=relaxed/simple;
	bh=EG1hSCNgt7Vx9kszVsAxRC0ryiRK4TR1WqZWlcEEexY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQPM3yd0XWFz+TFjMogPAlM+4x6/FkDMeJo+mTASyFp2gzqF0A2EquBAalBOyusvI9sYtYQlW2h23DLBrMWELW4aqbgc/6z4V2AbctouJutOrWehAKXEbazdyIBPsdCgraQQwhc1h5mtsIlRd7lvDvsLOtmycCWEJipk3DEanFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wcbr6A2s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wcbr6A2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652441F000E9;
	Sun,  2 Aug 2026 19:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700272;
	bh=p+dw3vVAIj4YAPqd7MgSRpBgA99rCskitLXGzXREk6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wcbr6A2sse/VYuF0Kd5yi1m2/3qPhYmSLaE4lzO9Ik5g6SLhlbJcIzEVfr/wbVVQY
	 h+bubM4YEGkYrmDp/spuA2ynG2JwH4ID5CdJ/iROpe8RHYHh4558XjKSWGLYexMC+Z
	 0oQTEvz7AR0cuGKucAQ1l7LaiUN6A1F9/28vRo68N2fy8npfK3WNh2EtAot0Da2fpk
	 4Ne49Ifo4akk1xfFd2/uToArE9pL+rKCd4JpcoMmmuTRq1NqtnpdCMbDutVrpEfk0L
	 fPdUhQhIndD6C0xLb31kYj5LFtIWMmLTJZahN0jr0jKOYFPhFHrA7U5BHaLdGe6nrM
	 sggNGR7RG9sbA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 07/29] md: avoid stale clone I/O accounting timestamps
Date: Mon,  3 Aug 2026 03:50:16 +0800
Message-ID: <20260802195038.164272-8-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802195038.164272-1-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

md_clone_bio() always allocates the clone from mddev->io_clone_set, even
when queue I/O stats are disabled. In that case it does not call
bio_start_io_acct(), but it also left md_io_clone->start_time untouched.

The clone private data comes from a mempool and can contain data from a
previous user. md_end_clone_io() checks start_time to decide whether it
needs to call bio_end_io_acct(), so a stale non-zero value can make the
completion path end accounting that was never started for this bio.

Set start_time to 0 in the no-stats branch. This keeps the end path tied
to whether bio_start_io_acct() actually ran.

Fixes: c687297b8845 ("md: also clone new io if io accounting is disabled")
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b61040315aef..58fb5453a819 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9448,6 +9448,8 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	md_io_clone->mddev = mddev;
 	if (blk_queue_io_stat(bdev->bd_disk->queue))
 		md_io_clone->start_time = bio_start_io_acct(*bio);
+	else
+		md_io_clone->start_time = 0;
 
 	if (bio_data_dir(*bio) == WRITE && md_bitmap_enabled(mddev, false)) {
 		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
-- 
2.51.0

