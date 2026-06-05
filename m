Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E31547D922;
	Fri,  5 Jun 2026 07:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780644411; cv=none; b=ojX3FkUf0/rgcyGinb00+KY23+GokFhVcJgl3ZonOHBoz0T849/3nbZ4SB5Ek0GVAyNNehaH++8lHta0ydbYAPaN8cgQc4Ska2agv+K0EnBw9wysonYSosBCsJtthkpIqQrUcE/FXLr95LgwtiAZkupjXXVyS/Zi9oMblZ/NaVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780644411; c=relaxed/simple;
	bh=X5zPx8AaczLpYI+wT+Fancgh3HTrYISPlYf3dPPokDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AD7Y7fqbxl1hYwiJFWTQOsZqFyX2gVDLo0aGt9ii9yFvhUmQPdY8kz2KisZjZ2sDedclh33Ad8TGV0+MYSug0XevQrU8h7V4eTnXlb2r43Sd2lgkCaInWxH1EgTPZk8GVpkk14jdNAv5/qiLS7fXeXQZokjYrNJY1d39I2xHBOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=edz8X+9z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edz8X+9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D4D1F00893;
	Fri,  5 Jun 2026 07:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780644410;
	bh=YB9jvAFrKIidDpZBfqQVx0rYEerO4lsJ66X/tMi2qVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=edz8X+9zuZJ8OvqAisw0Q4HevaimXXm4Oya/UZQiiVRkH4QijA8btDMqbe9Md6biO
	 ajozUgXcUwE9IFvMNUT5sXyVem+2CpWmwPcCnHQuNVUtK1t/9VhAXwG6d0K5SK0P+z
	 7/yPdAFc/0y/hc/7Lgs9ekjq80Gowy5XQCV+SBILdqq4hvsxwv+NRwFi+Z9BlpRxUw
	 z7UirzYOBkIx8mjkbBAwpAnxnMi5XTkYvpL+d/7GlNOlOMuvAOxYTn95DbDJTsVHIY
	 w9cc3fbmGntzsoO8iBed1EYGAXZ58iz+Tl0ZFPhn3GgcEI6bOuQglanAbO/QgxNjQM
	 d3eDEPsqXuiyA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] md/raid5: always convert llbitmap bits for discard
Date: Fri,  5 Jun 2026 15:26:39 +0800
Message-ID: <20260605072639.2434847-4-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605072639.2434847-1-yukuai@kernel.org>
References: <20260605072639.2434847-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

llbitmap discard is useful even when no underlying member device supports
it. The discard still converts the llbitmap range to unwritten, so later
reads and recovery do not rely on stale parity for that range.

Let llbitmap discard bypass the raid5 lower discard support check. If lower
discard is not safe or not supported, complete the accounted clone after
md_account_bio() so the llbitmap conversion callbacks run without member
discard bios.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 76e736ee48d3..180ff0660b6a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1136,10 +1136,13 @@ static void defer_issue_bios(struct r5conf *conf, sector_t sector,
 
 static bool raid5_discard_limits(struct mddev *mddev, struct bio *bi)
 {
 	struct r5conf *conf = mddev->private;
 
+	if (mddev->bitmap_id == ID_LLBITMAP)
+		return true;
+
 	if (!conf->raid5_discard_unsupported)
 		return true;
 
 	bi->bi_status = BLK_STS_NOTSUPP;
 	bio_endio(bi);
@@ -5738,10 +5741,16 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	md_account_bio(mddev, &bi);
 	orig_bi->bi_iter = bi_iter;
 	bi->bi_iter = bi_iter;
 	bi->bi_next = NULL;
 
+	if (mddev->bitmap_id == ID_LLBITMAP &&
+	    conf->raid5_discard_unsupported) {
+		bio_endio(bi);
+		return;
+	}
+
 	logical_sector = first_stripe * conf->chunk_sectors;
 	last_sector = last_stripe * conf->chunk_sectors;
 
 	for (; logical_sector < last_sector;
 	     logical_sector += RAID5_STRIPE_SECTORS(conf)) {
-- 
2.51.0

