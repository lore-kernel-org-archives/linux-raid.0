Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAC2413619;
	Fri,  5 Jun 2026 09:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650969; cv=none; b=S0JyLFu2sktuo+ulU9X2YlNgvvzE7l1Hm0bJZv/lBqziB6XEshSZrH60bIJ5MjXfaxvx3OzjRqT3T3cJW9cxNlBP2GQcGZWBvDoCAg4Y42ChSjkFjb2ClV1QyXedsF5h+yIhbG3kzNyqjKP33jVOhMJ1xTTbyyPcYNkDqjMn9l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650969; c=relaxed/simple;
	bh=sugyi6mtfvuq1wbrdcRMBvb8slckQPPlqvq6edJm8Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0rjcoY+j8o56eVPuQJUHGzksMSzT2nRWT0Ep9HEDomXrO3CcqUmwynxLIWgJ69G5H9+XEF7ILTm9QvQ5Nwk5Mf53KBB85YHy2U59reOxE6A0cKl+mY/NHwAQFhoavsZeRXp8Fxn4VZfJhnWYDfMcrMLJWfKextobmfJzCwt4GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDKYZaIg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDKYZaIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC051F00898;
	Fri,  5 Jun 2026 09:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650967;
	bh=Y4oNsB7h4Pw/vHl+I625Tfm1dVhF4ypIsvBQOoGS+oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDKYZaIgs1e4dtE35zDOJYpzRL3dMOeZDcEDwgr/xiDHX71+nMsVCoAjDppAS0/NN
	 BySI2vRB/oPmo2PRUX+CLKwT47miAxhwejeB3wyX9Z+1Jwa8QUmwmtab8isLsWdRA+
	 gM1pqE5kDt1GNSdJhuaGEEHeJoYsBn60XEzOlX834lI9yGEizpIjzNP0/HQXIDsoSm
	 zEOymmLzekKM+9s01XJf8LLyXljyrdzEsg9z0FYlKpvACBDYCRRFnoZYDqad1GoTZu
	 zkNe29Nlr3b51inzrNcV9iOGq1B14uIB0MKDn8BeHFgDPcKYchUiY7d/B0ZHAJPS4Q
	 EwQvRDxxgwECA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid10: split reshape bios before bitmap accounting
Date: Fri,  5 Jun 2026 17:15:23 +0800
Message-ID: <20260605091527.2463539-17-yukuai@kernel.org>
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

Use the shared mddev_bio_split_at_reshape_offset() helper so RAID10
submits only one-side bios to llbitmap during reshape.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid10.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 40000b867136..cd35d183877c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1898,10 +1898,16 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 			 || conf->prev.near_copies <
 			 conf->prev.raid_disks)))
 		sectors = chunk_sects -
 			(bio->bi_iter.bi_sector &
 			 (chunk_sects - 1));
+
+	bio = mddev_bio_split_at_reshape_offset(mddev, bio, &sectors,
+						&conf->bio_split);
+	if (!bio)
+		return true;
+
 	__make_request(mddev, bio, sectors);
 
 	/* In case raid10d snuck in to freeze_array */
 	wake_up_barrier(conf);
 	return true;
@@ -4273,11 +4279,10 @@ static int raid10_check_reshape(struct mddev *mddev)
 		return -EINVAL;
 	if (mddev->bitmap_id == ID_LLBITMAP &&
 	    mddev->new_chunk_sectors &&
 	    mddev->new_chunk_sectors < mddev->chunk_sectors)
 		return -EOPNOTSUPP;
-
 	if (setup_geo(&geo, mddev, geo_start) != conf->copies)
 		/* mustn't change number of copies */
 		return -EINVAL;
 	if (geo.far_copies > 1 && !geo.far_offset)
 		/* Cannot switch to 'far' mode */
-- 
2.51.0

