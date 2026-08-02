Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDCD33C518;
	Sun,  2 Aug 2026 19:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700355; cv=none; b=GYODV9BB8Re3DT4A8GbLTxRX4OxjAvS3AdRtOsMIgp7nFF7UFfJlH5ppx9u5WwD+vuu5fKle3aS7MSd0dQQfwJ1SHCdpW61fyAv9Z6O3ujIMoyz7trOSuXxf1H3ywugk3i0nQ4fsQwItOUSI0ng6o02OYbbEmV2MUFlGbKlYvgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700355; c=relaxed/simple;
	bh=FAjN71/gjsFz604tkKGo3e60EXOL2SxkEFrQ2DSw0WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzd1KIxzRRYeO/2xwOKYW2Ikwiis+MOL1edx1+jPME5Z5bb9lVXdbAEa3ypYVBk/7Lcg/xBanJnkJPiBRUJq4PF+HBsBeeSaq1CqaquZhgurk30TWrjZSCAVgnDGpmT7rx0Yo7nwYRXar5lhpArv2HiS7qkFNbBoP1acjTtN5r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUXqtyMn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUXqtyMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533761F000E9;
	Sun,  2 Aug 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700353;
	bh=U5AZPitFOQ2suw5rmOmr7esnHtQb3NLo8m9K2W7ESK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUXqtyMnGfB5khENlJ1M798OecfyG8cM0fF/Qz0+d//EtvZGMA61Lavi/LzP7nOYr
	 VbTg82DUmqQN2PF0l6ggvQ7Jt/O94P7y5rpCpmipfvAFopNxtxI28w8n/fqKbyJiUE
	 0TKI/YL//sFrcJdPd7W7YFwATDPzrnm9L8mbCcJp57SUxUUnTRs/9c/iqMnzDzEzGw
	 b+HK7uWLqKQ02mZSm7ofRzk/Uit5IVZM12V7YLszGuzNnC7OFHMUbvmR+mOOh+XvRv
	 X60Fyi9VYsrsY4KeW9RPPFAHeIKKQreTK12BNXX9YKOaqglFZDWa0ALFYL2Ux8YPSi
	 2Qwv43/243fCQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 29/29] md/raid5: split reshape bios before bitmap accounting
Date: Mon,  3 Aug 2026 03:50:38 +0800
Message-ID: <20260802195038.164272-30-yukuai@kernel.org>
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

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5176de5b5956..b91545ce090d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6221,9 +6221,11 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
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
@@ -6257,6 +6259,18 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
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
 
@@ -6348,6 +6362,11 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
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

