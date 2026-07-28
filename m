Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1E241A785;
	Tue, 28 Jul 2026 08:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228672; cv=none; b=TO9jTzzbTp3TtQtcx5JWPCAyeSJIzsM8TzEAZ9tuo/a5mVxD5zN6gSYi1TqIyMB/rEKvek0uWOTI1joxgJuCH/Zrl+8XIOy5cLz3H6wyL/+g1kgXcLGz6CwYN4yVI3KUSCIGZ6AXyx4nx3ws4PtiysUdWU1UDpcpL+2g26+6fx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228672; c=relaxed/simple;
	bh=UAFeomWxm7KJ6mn2ZvC9IVpdLZnZNA4iz9jL2E9ZUHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3Tu2AjmFCrbw5TMAJbX+BCUyxYAFzj5nfiCNPwO9q6SGCOheg4u9o1lkWgGi9+xqHMvZcWA5lClY9dzk+rfir33MQqZ3HeEy1A2q5iCTVq7sysZdAwE/MwD8DiIs3pzJbLGXJQUbkriUEnrlvaprFUy1LEAH+Rk940C/BRuv+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=arsv5Qv8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="arsv5Qv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD341F000E9;
	Tue, 28 Jul 2026 08:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228670;
	bh=0OOQrxhdJ0I0iP6sU7VKgaXj/zfjfzxLVf+kTqT65Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=arsv5Qv84B+y5YA+dVKrgK/7MpVNzBw4BQqvROAXylKfJkw7ys3LPqBSOrwkjCzcU
	 MuUXCy4UGJYl6PrpaM7OpWqmC0AADqaGlTvZb7qnplxgLv8I4VEYuVgjxqK+sOAOY3
	 ugO+6FTjsH4lrt5PAOF2F3fN5uFzzXo9ifmkoo3MqxRDBmPwEPWYO18Yy89akNvg5u
	 yLXJwEs4SBj8JGWBSR8HbxrF4S4z+Wrznsqr3o57bAVyQpPjPjuRc452hU0IHrn/tE
	 uVKbg1yel14Kiz4vDhpMaukXFt2I/N/13ClxIHctL3Xx7JxlqtX6pB0XBORewjKoB7
	 I9tvATD8rVeiA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 21/21] md/raid5: split reshape bios before bitmap accounting
Date: Tue, 28 Jul 2026 16:49:21 +0800
Message-ID: <4444c934f36b1c902cccfef2c4a9c9a919ff1145.1785206690.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Use the shared mddev_bio_split_at_reshape_offset() helper so RAID5
submits only one-side bios to llbitmap during reshape.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f70b2f611980..30e18ce7c0e3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6184,6 +6184,14 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 		return true;
 	}
 
+	bi = mddev_bio_split_at_reshape_offset(mddev, bi, NULL,
+					       &conf->bio_split);
+	if (!bi) {
+		if (rw == WRITE)
+			md_write_end(mddev);
+		return true;
+	}
+
 	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
 	bi->bi_next = NULL;
 
-- 
2.51.0

