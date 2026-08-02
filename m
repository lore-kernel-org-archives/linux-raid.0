Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B01533F597;
	Sun,  2 Aug 2026 19:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700338; cv=none; b=eVIKIgPXjA2AWf4EXhvh62jczbL4GFi/VEZT+xJEZYGQeQYfJhZn22wHmfnWFtcVZN+8ILKfcfVi43YW7OUGO1ZKI+4O1atuTWsy/hGBN/k0fj8/c8TcSjT2cnU9wyU8HRZQ6CPg5yhEWIqesMuPHQqQUunI8SfO/MCfkyZfNUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700338; c=relaxed/simple;
	bh=I0WCHnswMmVNxkmOkSkooY3CurCC16eDuCPucYJWViw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2vXuF0yUYtjFvEAI36JWFoymiSjkYvCZImFxBtTRXdQoTPzfD7mUrNS1+mFbapUlS2+BXhxrIKqgG9yZXdzeJlMIFwErD96FIEzQSEl+/2gZy7a1RnisnWfoejs3bxIOwen3cLe8I0BOOuhTwigNbTmliWKJM/qLXvIYTJvaE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+qW6xsv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+qW6xsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499941F000E9;
	Sun,  2 Aug 2026 19:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700336;
	bh=ryAAtN55XBalJyhi3qRADAZhr6I0H9xs6ZEKweeOw94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+qW6xsvmF0Y/da+OwptuVbTwnomN7DnZqa+1iN4Of3+TeuRvNhpNlQe7r3V61qIt
	 LvpCKj3cpBVlr3FCWh8RW76KAnuyiyLya2Epy5baaCEZAiICFolpRTL1g0aPsFx3d2
	 5E8bvPTOuwYp07ASSebDRQa8I9bSwCCqKsgl+YtEcBEh/FqhGVgPtabr5Gax8MXBJg
	 fihzgXLfo+CoGzQmf/AdpeBW+DQeOQQDFvFmYhbqv2KI29k5gcJsN8BnkAlS6zo3c5
	 3Re59O8Sx8CYRlcelWa/NAYBZ3n7e5mpz09+6mx4DPHN4iXj3AyLMvtHyqFkKL0hYJ
	 08X/O2bVcGy1w==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 25/29] md/raid10: split reshape bios before bitmap accounting
Date: Mon,  3 Aug 2026 03:50:34 +0800
Message-ID: <20260802195038.164272-26-yukuai@kernel.org>
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

Use the shared mddev_bio_split_at_reshape_offset() helper so RAID10
submits only one-side bios to llbitmap during reshape.

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid10.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index bac9edd28c97..562a325a7195 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1848,6 +1848,7 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct r10conf *conf = mddev->private;
 	sector_t chunk_mask = (conf->geo.chunk_mask & conf->prev.chunk_mask);
+	const int rw = bio_data_dir(bio);
 	int chunk_sects = chunk_mask + 1;
 	int sectors = bio_sectors(bio);
 
@@ -1873,6 +1874,15 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
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

