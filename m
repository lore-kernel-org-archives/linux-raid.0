Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4510C3BBA03;
	Sat,  1 Aug 2026 17:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605279; cv=none; b=VVsrsUCX3GabpwQvXcejlkFATL751JqYcct6wujm7lbSulHTLKCmNPZkFoJev8OguTew/3NGAr6YjK/WtUCZZ/O4bqbf1tIDEaTsSbqk6Na1rP8Cb/DDHCuAw3dauN+MNRMEq782EVZYwFdeUHinpdH1lNRI98FCW6smGuZQSUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605279; c=relaxed/simple;
	bh=SnoXFkre/tus+jLL0QefuZLY51AVPhhnVMSXBVffu30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htiAehEKKe0c7L8XGtYmlgq/aA3y16ClGoMlvCojaM39ddiKuqBJiOLuXpXgTSTEXgiA/QmAn9MK96PxvaIFDE+sWEDFaxeSP+Xey2CoZJ7UXO4mEhQgfr6HH/FnWFN2yAFsDotVWjGRaaY0BWw2sHNyGtGEURyG5rEi7BNnM4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nbej/YFw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nbej/YFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22ADF1F00AC4;
	Sat,  1 Aug 2026 17:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605278;
	bh=YLcxogMF0Z5kTX0xm+jXmH5SCSYzBlu+Y6zSYOVRMfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nbej/YFwz3r8huA2CqlQSo7+dXx3Tr7l/d8tHHYoZq2lJNJTBW6qXUYtLfwxEsQL7
	 MH1TvhWppCKKA9vsgB9VOPYmBzKn/exzVPbM2n148hZRQ6IYOX45ZG8BUjWJ2k184F
	 tuFFPC/TKeRDceWnUnRtL6tT7zqcOvNXcUILBuCGFph0W7eihTZldc18S7a1b5LfSY
	 +u0gMGAqW7xlFFr7zBM61hKQu6ALbzgaV3lTwHfobMHEwZOwMj826XK2LfEZhk6Upf
	 0YtN4svrL/vjbeDEWbVcJCAyHgy78wPyT1TJzsTrcTfTwk25/dEZPhr2G+g+8Y2Mg5
	 C3gNn1ucJzIeA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 25/25] md/raid5: split reshape bios before bitmap accounting
Date: Sun,  2 Aug 2026 01:25:19 +0800
Message-ID: <20260801172519.2982121-26-yukuai@kernel.org>
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

RAID5 maps array sectors through different geometries before and after the
reshape position. During llbitmap reshape, md core cannot account one bio
against both geometries as a single bitmap range, because the old and new
bitmap mappings can cover different chunks.

Split bios that cross reshape_position before md_account_bio(), so the
bitmap only sees ranges that belong to one side of the reshape boundary.

mddev_bio_split_at_reshape_offset() uses bio_submit_split_bioset(), which
submits the remainder immediately and returns the front split bio. If that
front bio later has to wait for reshape, md_handle_request() must not retry
the original bio pointer, because after the split that pointer is the
already-submitted remainder. Track whether the split happened, clear the
temporary BLK_STS_RESOURCE status after the internal clone completion, and
resubmit the front bio directly after the reshape wait. Keep the old
return-false retry path for unsplit bios, where md_handle_request() still
owns the same bio.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 896aa522f446..9b47d9a277f9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6148,9 +6148,11 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	struct r5conf *conf = mddev->private;
 	const int rw = bio_data_dir(bi);
 	struct stripe_request_ctx *ctx;
+	struct bio *front_bio;
 	sector_t logical_sector;
 	enum stripe_result res;
 	int s, stripe_cnt;
+	bool split = false;
 	bool on_wq;
 
 	if (unlikely(bi->bi_opf & REQ_PREFLUSH)) {
@@ -6184,6 +6186,18 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 		return true;
 	}
 
+	front_bio = bi;
+	bi = mddev_bio_split_at_reshape_offset(mddev, bi, NULL,
+					       &conf->bio_split);
+	if (!bi) {
+		if (rw == WRITE)
+			md_write_end(mddev);
+		return true;
+	}
+	if (bi != front_bio)
+		split = true;
+	front_bio = bi;
+
 	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
 	bi->bi_next = NULL;
 
@@ -6284,6 +6298,11 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 		bio_endio(bi);
 
 		wait_for_completion(&done);
+		front_bio->bi_status = BLK_STS_OK;
+		if (split) {
+			submit_bio_noacct(front_bio);
+			return true;
+		}
 		return false;
 	}
 
-- 
2.51.0

