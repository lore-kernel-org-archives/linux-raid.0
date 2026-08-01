Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FF73BADB2;
	Sat,  1 Aug 2026 17:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605268; cv=none; b=pjHA+IZc1kgBFYB0LT2nukIjoKGlHsvtO92BwtVG//EUWvq6L8kJJuwQ9BD8jiDubASE7aPmom7I1sknKSzwC1mhotqXgQPVgElGJ0sUVMZJ7h/FxwBMKwNO/CqtwRqR/CrspUX9+bZxg3CaFhLbZULzkiSVObQsAhm6mjeoHbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605268; c=relaxed/simple;
	bh=/UNI4Q8H4Ps2aEhWVyhudcCJ/CpqWR7iJufJt9Rwx7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9bgwmTF8OJjmeP/POOQDb6h0QrPj+0wDBYKafXm7ulRQEgMhc7+aiIHrivlxaKFbIAAuiFFDHAWS8E6MjDoY5xADBBDSqS0G9Ur7rIxvuRiGvIaRRsV5fLJP1pOZ+lBdxCYHnkmunt14UzZbOIYhNXPh4RMDijtsclUZlvSTQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hPgU4dtb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPgU4dtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4331F00AC4;
	Sat,  1 Aug 2026 17:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605267;
	bh=RobKo1bwRrF0wRV96ba0Qp14plvpIJ0oDIqYiCVbVu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPgU4dtbRMO7BYc+fMgwO6CdyqrzyCwTuXAZDdGWmbYc4/W95XglYwBGXfY8NQIDJ
	 Ao43WUK4zpfi3m4J7jyHzibJJylauabJ68+TvnJFddu1+tSEhNx69NyqDu+B9zrqE9
	 wwDMC+scccotsPny3NCxNsRN5HdBYC4pFhtaq8RgrR0E5oQfKOR9eU6kEi6g7i3IRu
	 8eIgOXOHQECwWoBaCAQllelFx+ATCB1SxfgJbaOs1Aa6cMH6W2qcBViME0W22R7a9c
	 O93e9hp0hQZjRfk9weN8PRNUXN5SzXJ0zfJ1WXrE7MzB5kwIzY6ZQCSwwLdNrhOKNK
	 ZfXImqwv3OuYg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 23/25] md/raid5: reject llbitmap reshape when md chunk shrinks
Date: Sun,  2 Aug 2026 01:25:17 +0800
Message-ID: <20260801172519.2982121-24-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260801172519.2982121-1-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
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
index af7775278af6..5697570120da 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8511,6 +8511,9 @@ static int check_reshape(struct mddev *mddev)
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
+	if (mddev->bitmap_id == ID_LLBITMAP &&
+	    mddev->new_chunk_sectors < mddev->chunk_sectors)
+		return -EOPNOTSUPP;
 	if (mddev->new_chunk_sectors > mddev->chunk_sectors ||
 	    mddev->delta_disks > 0)
 		if (resize_chunks(conf,
-- 
2.51.0

