Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5479938A725;
	Wed, 24 Jun 2026 06:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283390; cv=none; b=A3g17pXL2Qa3f4LvuWc6UQUzy24HXtfj+u6o/2tC8hTSZQXQLcIoy3m6xWEDykEsOLmIJoZWfp8/T+T92TI5VXpjOlqqNNdXsRNBupax4Ky8ID0xgowmaajPW+lz/nTDbyomjtmxLjRcdu256gWwKSHV5SFyTORrif0ugJZ3PNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283390; c=relaxed/simple;
	bh=yuSwbjW7duFYkgjMJVcCcr7GLiUZaWwvytbVKgijPz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnKDFjRDJNE51Zw9Z34+nFinTkSym/oE+9l1ACsCxTepdMMlvK5jXfJYH3ypwGvE8kqTAvdNcRj4/Lx9Qmt/IZQKueQdjopGA1fJtmhEdhMeeEVQCa/1WrXb5TSH2zFX9cjOqkXxVB+UA78LL0Bf5kisu9guMgo4gmj4KTSlD8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CVGqmMiv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CVGqmMiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133261F000E9;
	Wed, 24 Jun 2026 06:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283388;
	bh=2ATxipAfQv76/T1JQd04/VqmfW1xajd3Nn+VcUogVbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVGqmMivqHkibBRwSSX+DKZhzZmW3pc+0v7n8hn8mWnTJfzED3OIly8QAmw2iyuNw
	 eccRFKP6HD91tN1QfCYJOMPzV6gLwfmM5/BHWH6QmiJ8wj8BX6m0zjcCHAtprL13h5
	 sb4FQRR16YR3uQR4Rh6x4wxZ/hZ0euYiU156Ng436wIxx2lknIziMtmDP4MmklvS5+
	 teWCyIRGRL5DCuMbXnSP9FEfgEGQ+8STU9k02IoOZ2jd2j20VAguwKLspvHOHkXCmm
	 B9vljqMrCmPlmzNg5SD3RvcUapMVkCNFgIP4Fr+GcBqNFEEFbiqHbMfawWzioKtiHo
	 dNkYbyfKKG7bg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 18/20] md/raid5: reject llbitmap reshape when md chunk shrinks
Date: Wed, 24 Jun 2026 14:42:15 +0800
Message-ID: <9b06d3a655f709b35ab10995a872b30d2026f7c3.1782282042.git.yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org> <cover.1782282042.git.yukuai@kernel.org>
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
index 1613a42cc25d..9de648f75dd0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8506,6 +8506,9 @@ static int check_reshape(struct mddev *mddev)
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

