Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BFB4C9002;
	Fri,  5 Jun 2026 09:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650973; cv=none; b=aEfqfcj1kWDKClbVIA8IC0FYMf7joCfxjVIN7Sp/2/8KFXNZlw/EjuD7qX4rEM7NRm/bCIFweShq8uU/e7r00ILwxO4I2PSjj4rF9CxUN406eZspg6sULH+gObt0BhcC/HHv/MjnuopPmAsXlpnRXeG0iVg/1NjRK9JH/ZPLweo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650973; c=relaxed/simple;
	bh=fpsAMBjQbs0WmoYORr2VgdXVZa0GOC+cchJLEtxhO+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIxdRFp4b2X+FKrAv39zI7lIlDRxP6FsKsY56Q8CMK2iA6dQOhkaUOfQvmTANm1yyzCpbUK3HxmiTbCuyddL3MDlqKdREtN0xoqR+3LvYTb4yONLxD46B0CL2ya+r4UPAr3edHRsJE8heVNvLuz9qq3mZ0Qkrtcd4CEHGIfR6Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ICyC4KdB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ICyC4KdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BC91F00898;
	Fri,  5 Jun 2026 09:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650972;
	bh=XIOIkhYCrY0oi8N/i1JAcx1Okd+kB+KK+DuNGzG+5CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ICyC4KdBzWvgZDecPmux+P41ImTpC66HXOJnN65tkYDaACb+c0aeZRy3SGSsJuKF3
	 XMDGzVJjaVBRGfyPB1CTK8xHice9phllNdJUuB3SzL+zMEAWq1KGYbE9BluPF97AT5
	 ArraX7anAWIUo39A4/+J0mBYT4uessC00HlXLDDcHhArr7l+a66YkWmzai7kVtSdUe
	 X6K65C5kCcm1lN3y/pnXxUrYhyZB451OAwDpNYYkMi9oROtC9IZobPEXFILWECxc36
	 K1IPj+RRAO1hpyfYhKcqZwm2H2bf8zybyxB8c0KCZxbYGrc0zT3noUBh4YW7ThyyoU
	 SL271kQQp5/nQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid5: reject llbitmap reshape when md chunk shrinks
Date: Fri,  5 Jun 2026 17:15:25 +0800
Message-ID: <20260605091527.2463539-19-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605091527.2463539-1-yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

llbitmap reshape keeps one live bitmap and cannot safely make an
existing bitmap bit cover a smaller data range.

The llbitmap chunksize itself will not shrink when mddev->chunk_sectors
stays the same or grows. However, shrinking mddev->chunk_sectors shrinks
sectors_per_chunk used by raid5_bitmap_sector_map(). That can shrink the
effective data range covered by each bit across the old and new RAID5
geometry. Reject that reshape while llbitmap is active.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ff4da82f78fe..55af1d1eec63 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8497,10 +8497,13 @@ static int check_reshape(struct mddev *mddev)
 	}
 
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
+	if (mddev->bitmap_id == ID_LLBITMAP &&
+	    mddev->new_chunk_sectors < mddev->chunk_sectors)
+		return -EOPNOTSUPP;
 	if (mddev->new_chunk_sectors > mddev->chunk_sectors ||
 	    mddev->delta_disks > 0)
 		if (resize_chunks(conf,
 				  conf->previous_raid_disks
 				  + max(0, mddev->delta_disks),
-- 
2.51.0

