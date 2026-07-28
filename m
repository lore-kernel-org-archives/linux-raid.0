Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F8F41A565;
	Tue, 28 Jul 2026 08:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228661; cv=none; b=iaRNDQPxl79iuVgCmB3GoEaT0NodprRSr39R9nbFCJLvOLTktU/p5lt/9k24ErEeyyM7AvNMrFgmbQftzmsOMvErQHviSWuvZToTofEbghBHle1eFW0l/Ie0bfbgH7MvYAhjWMjwkjJTsEt6n5k5CT2CcrdfRLQCgVB2z/JuuEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228661; c=relaxed/simple;
	bh=XhkO/5xQwhGveXExWIOJoSkVRwXOK2ASJ4Hn963RO40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMQOc9DJs3sS1HdRAmRLOCsks3ormIECYCsuIv0jvT2pbmsfBNTMHa6H5ZQtuaXll3X/xBOYKoSbT4KBugsUkMHJKh7DNZbOp5vuYUwI/zLNviktbPxyEH0g4O64oCEwAcC6f1vU9ngguhmrN/F9X09dWiaQ3kp+adbrbOg2wRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUSvFUWP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUSvFUWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029141F000E9;
	Tue, 28 Jul 2026 08:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228660;
	bh=oPpvnv+tT2UgFus8xGlUgmYiE4MIToQ4jp96Ywkr4kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JUSvFUWP4+YPRjxy4AQQsAQbgv+/erUhZGoLeTR15YbnkJndi5t+6fl9+bVFsL74I
	 kRPCMBFu5slXXLjMj6gvvoF6pgKtzMwLiT0sEUweUg6YUQrPbhZZ8ugYkmj7QLFMdz
	 OdzZ2wOD9hD/mWA5wuuOwyYSv3DuhDHIkdyCQG6FKSWH9IuPOJ4y4cIj25mT01vwWE
	 Y8/oShbEQedjMApMYBCRP1qXcECAi983BDuqLOP6JW9+LmdnZPVVWA+QfbTt3ojcdj
	 q4wRxpAj7zqgTw4vJbp1MM7rpVxT7qcC8CbFLxdR1V+PzE1Zkl2FqZj/pituTb2Mpe
	 MRh9xndLQuERA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 19/21] md/raid5: reject llbitmap reshape when md chunk shrinks
Date: Tue, 28 Jul 2026 16:49:19 +0800
Message-ID: <649ae8376b9960aff1567265162c132fd80df566.1785206690.git.yukuai@fygo.io>
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
index 8b28afa538e2..f0817599dd27 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8509,6 +8509,9 @@ static int check_reshape(struct mddev *mddev)
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

