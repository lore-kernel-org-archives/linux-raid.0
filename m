Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844EF39185C;
	Wed, 24 Jun 2026 06:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283385; cv=none; b=lZLJekO8X2qqdNVyGDKTgRQPPvCDgvnU2KVn3JOFLlBEmVrEg+BMBssSsPz4jDRNiW1asPr6wVi6dVVoylFEk412JYlEvXX9dE2Ubi21NA1onG9kUEDnJPVFFeoqPAlzFUiv2WYWbDvGz+N1YkZQZW4P0YnjPlxZZXtjFUBqqmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283385; c=relaxed/simple;
	bh=Aw1gNRevTwqD+2er8RV/YU/327IH64O8LBFutTh4Ocs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gp9wPq2sgQubvZYchqdSwzbFbnlbomxtYs91jC3fiOwHHPV7yaoBNI8jojtokYKhx43JtziZy5qlnIfIH8g/akJGY88AyMxRgp3F1xKkcm6yt6420vKDWYO8SaOaj+lT4MJF1N8yaSQkYXktEx1p7dVNMrYVSutWOxS87aGJ9ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LX6vW+EZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LX6vW+EZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9A01F000E9;
	Wed, 24 Jun 2026 06:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283384;
	bh=FyXqR6M7679RX5rJ83DKHfiPQpxbwKXhyLNfX3Pe9Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LX6vW+EZRUb8AEXu1v6wTd7BFwvpaw3QLGhWVMHfZsgx/lIwwPvPPmlPACn6FILLY
	 jHP64U+Xua28hJxs13b3xjKwsnGBSvsbMlBxHlGKHBM2HI07doRD8DJfeiXi6epUL/
	 1gpKPABLgphK72b0aZOaFBB9ld/NR4HhnbVj8/R/jhENS+/UElyWsHyihRndHiflwm
	 KeNxm1JFjPBecZjDTbh6r8RuiokgUNXQOUm1su+gppMrpYitkDWotofHYnzawo0/vD
	 2oWrmXKtxVB9oml2nuTz20TxxsHPaFc0IqiV095tPI8WWELXp5fNbaNngKV5YYD/HZ
	 JfMPNnvpI+SgA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 16/20] md/raid10: split reshape bios before bitmap accounting
Date: Wed, 24 Jun 2026 14:42:13 +0800
Message-ID: <afeb48e05a8925b52e9def6bab1b0ca1e87c4aa0.1782282042.git.yukuai@kernel.org>
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

Use the shared mddev_bio_split_at_reshape_offset() helper so RAID10
submits only one-side bios to llbitmap during reshape.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid10.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e50e4adee389..fd364a2e2fd9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1911,6 +1911,12 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 		sectors = chunk_sects -
 			(bio->bi_iter.bi_sector &
 			 (chunk_sects - 1));
+
+	bio = mddev_bio_split_at_reshape_offset(mddev, bio, &sectors,
+						&conf->bio_split);
+	if (!bio)
+		return true;
+
 	if (!__make_request(mddev, bio, sectors))
 		md_write_end(mddev);
 
-- 
2.51.0

