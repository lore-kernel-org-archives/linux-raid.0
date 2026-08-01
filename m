Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB32E3B3898;
	Sat,  1 Aug 2026 17:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605258; cv=none; b=bJCDThJI0LBKqRV6uBmcfALcLVZ0PdfyM91Zpnm9aenib7wOrBa9uiRgcBVJRQd7J2WTv5U1CWJczs6vIiILkq7M3r0m+lVaJ+YAXu54HVf3Yyndl2sGZAcOT0TvwDwl2wUnLJIdR7HdOkd+nWMNKZokcTXmgc8R7NXoWEusvuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605258; c=relaxed/simple;
	bh=DFz9j/LUqMTB/KJD4y+MuD1SvAJ4inz3anY4ukvjgEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEhLO9oyIPkij/0/VKN0RUUA31W0bpbSlepDbHFqsPeZlJ+nKNHmMWQwb4jxuYH8xyxt/87NkerzvJuppses1t2GIvdk5+Way/BakGpseHkxEL4gUqhbpBF2OqP3Gzmnj1D/Xfk1cLILm2TW8SAx4bbBGFhG8SjWJs1puAnbCYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H8BYrer9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H8BYrer9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C1D1F00AC4;
	Sat,  1 Aug 2026 17:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605257;
	bh=A7JHketKneKBfUVY/rm7ha78+U5Bqu5XSZlfyCTdK3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H8BYrer9WfQt3gPEv2tnHMXjkhqhcfXA3xo3L/HIENKUOAQpKq1QarZIe260IdFrU
	 6sAuUTqjVOrdXpKE80iTI2vDzfKck+IAZBlEJ5xXyjvyb/71bsZrW19g8TUcRIZCTm
	 DD4odz9TsXqhm1e88Rwe6ERdjJVMUg+68gzY9DvJr47GktCFvNak1MuKTf5K3QhLIZ
	 uQqN9T4hgJA3bTcPbnOlHApWx8ipc5LVLCckpDsNSKuR/sBKrswwNRkJ1xNxBxuG5I
	 afvjjfptSk+OVKaR128KoG8Vq2wtOUxI7PE31kw+kKBP0sl1BKfYXZtP3g0qtqz8LO
	 oUpHm1TCeE7qQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 21/25] md/raid10: split reshape bios before bitmap accounting
Date: Sun,  2 Aug 2026 01:25:15 +0800
Message-ID: <20260801172519.2982121-22-yukuai@kernel.org>
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

Use the shared mddev_bio_split_at_reshape_offset() helper so RAID10
submits only one-side bios to llbitmap during reshape.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid10.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e50e4adee389..61900ace190f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1886,6 +1886,7 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct r10conf *conf = mddev->private;
 	sector_t chunk_mask = (conf->geo.chunk_mask & conf->prev.chunk_mask);
+	const int rw = bio_data_dir(bio);
 	int chunk_sects = chunk_mask + 1;
 	int sectors = bio_sectors(bio);
 
@@ -1911,6 +1912,15 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 		sectors = chunk_sects -
 			(bio->bi_iter.bi_sector &
 			 (chunk_sects - 1));
+
+	bio = mddev_bio_split_at_reshape_offset(mddev, bio, &sectors,
+						&conf->bio_split);
+	if (!bio) {
+		if (rw == WRITE)
+			md_write_end(mddev);
+		return true;
+	}
+
 	if (!__make_request(mddev, bio, sectors))
 		md_write_end(mddev);
 
-- 
2.51.0

