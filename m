Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C9C47FB10
	for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 20:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839392; cv=none; b=ZnfjJJ3ZbnyZvwOVWvpdNem0kZSmbmh5wVtbpYk0dXhKpOwrpWRD91baeKC+B4PsfViMo500PwNyV65D7dPP8RGSNyKw3Nu9t3ncY1AgP/1CTOweEkqoa0NEy+//TzVSdGtBRNaIbrvBlUvk2bQX9JlC4sW9YAtCug+6INfY7RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839392; c=relaxed/simple;
	bh=tb87IS5YwxWP0/pdiRmCvUCzVsNHu9wl18O2iixHy6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSkKl9HncegjD8cAlDjBnayXZdIU2KshZP1pklxWl3+PmC2VeqKJmKl1bYpduSGy6ftVvp2q5jrap9ruHoQ/v1shw08nGbOsrdLQGgvopT8z0wm2AhYFVEgMvOBto+bTbW7Z9hkPcG1fnYpUJyEP0LxmTBgMX8yOkCqJIGkPaO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=Pt9YwXgU; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="Pt9YwXgU"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4728c12ba97so667139f8f.0
        for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 13:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784839382; x=1785444182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jvUC0Lia0it+LgLYsOXSPjeMnXEhLq3Hqn52LEDkVn4=;
        b=Pt9YwXgUB/n16uijEWINzVy9fytMeDArZSye7T8oKIibLMO23Fp79F6KTTDm4420OC
         K/c+vKpY0QebTMHsOxZFCUtSAFXNKXhWTwpsfnOA+iS6Y4gj4OfU37ft6goBgbz/WAyK
         khgeZ9l6ktaXAkg9fMXiilzowWyWyZpCPVceqH+Dp7XoKYKfneNV+HSAGQOA2+FgEkSb
         cKe21z/xgFbykL/dvmvMtEe/e4LwyNBlYR+uts3K0w0X0tkwkScWSfk1A9lpW/UMhScV
         kPxrYYImjXAs21aTfaVI+BwU3u4x1OTe1kV9QtHsAoWo/OGblM05ozxD7wQRl7bz+fIZ
         c35g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839382; x=1785444182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jvUC0Lia0it+LgLYsOXSPjeMnXEhLq3Hqn52LEDkVn4=;
        b=IIuWVYbbxzwQgdlH5wtkVkwaoJMLbU1sH20isH7hPmmsJ10WjQPMc/0OVbDT95bYIT
         2Vgz5y/DG2Y9pJ5uH3BPJE2Wv6LI/A/McSI3eh0y5e92G9474ynq/r0MA0M/6oud8fLb
         OxWPMTdzZN+MPbXYFCX1Ku3uNnQGTLTFzC12GHDkuYXPNQY+2WLnTbQGXlb1sjVX46Gj
         uq3QLS1O6uY07RMRo0EkhZvBT3SU3AT+S6akLpKhCMpoh637/Oj25PVazUlaVIzuy1Gh
         ukZg6P6T4z+T5DQk9snzLDYM5keCmtZhA6xEPcVczrZdfdN/QiRMxnbqXcIS7zwnayNC
         EBxw==
X-Forwarded-Encrypted: i=1; AHgh+RqaPKXl9BebfY4iHjYzkJWcJNU344LJv2HJNr2V3B8WAijI/Imrr25c9IB4edbbFzUIfOfNQv9DIqGQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwrJHAHpXTYSSqx/VosdIOSo62MlqfRxWepU21ihWCpo2+ZWkSt
	nDO1TxRrgZlLixucuVx/kHHZ8W6ra1uXBu50QIJFfyrdlveCh9ensf5Pa+VCeecmwg==
X-Gm-Gg: AR+sD10A0M9A7ZPQj8K6VHpiddzMxgmOHcAkEIoa1zkFOiDuKdGdD3+qawzQ0Ru+v25
	6LJk9yT3BYUT3uGW7yk6SrGNGMerUcKKgVPv8QuHngQ2ctbCHJkzsB9SdGMhchn0nuu6mJULlMa
	yFaVz3jeFwBLwkqdzy2rvFrkuFPcOCTCXoA+Iv/clEczYqH+XjRUzAzsVnHLm/QKt3mjD3mtEwW
	nYmARTZ91u3j+G95lXk+l3viZegXSJGLo7RLKzAPtWHMYb3XRaOwWNXG2lBTZcoTr36c4GdsEKD
	mtO4ThIJAZMqg/jIWbzHNh44Dd3lHoloAWe2LrPu/UWuv/GKJAfjqXNxO/TXnSwvw7LQLNtfnag
	M9HF8LBJP2du3b9knFLEDMrPZBIgYohTAGq3lICZnnT9Fxb1KS7bHwe4ByVyFFk4iL9nEhoAafB
	OKl9QlZil2nppyFbtPmNYFzziTXhA1fF0u77yDmqaPSD4OOyJJ5dmxmOKo5WNc4V4OmpZVr5+bi
	OBXNQqb9mTx9E9xzc5mbJOFF/qdkz/x8s568cgzO/339LEniarv
X-Received: by 2002:a05:6000:4301:b0:47f:943a:a7f4 with SMTP id ffacd0b85a97d-47f943aa945mr2275162f8f.61.1784839381805;
        Thu, 23 Jul 2026 13:43:01 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c52fc0sm18268192f8f.23.2026.07.23.13.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:43:01 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Jens Axboe <axboe@kernel.dk>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH v5 04/10] md/raid1: don't use write-behind for P2PDMA bios
Date: Thu, 23 Jul 2026 22:42:00 +0200
Message-ID: <20260723204206.76930-5-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260723204206.76930-1-mykola@meshstor.io>
References: <20260723204206.76930-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

alloc_behind_master_bio() copies the bio's data with bio_copy_data(),
a CPU copy. P2PDMA pages are peer device (BAR) memory; generic code
must not assume CPU load/store access to them is safe or fast on
every architecture, and bouncing peer memory through the CPU defeats
the point of a peer-to-peer transfer.

Skip write-behind for P2PDMA bios: they are written directly to all
members, including write-mostly ones.  Ordering against write-behind
I/O in flight to overlapping sectors is preserved: the non-behind
clone path serializes on CollisionCheck rdevs (see the preceding
fix), which covers these bios like any other write that bypasses
write-behind.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/raid1.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 997f79c05db7..7d769b6460ca 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1523,6 +1523,7 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	bool write_behind = false;
 	bool nowait = bio->bi_opf & REQ_NOWAIT;
 	bool is_discard = op_is_discard(bio->bi_opf);
+	bool is_p2pdma = md_bio_is_p2pdma(bio);
 	sector_t sector = bio->bi_iter.bi_sector;
 
 	if (mddev_is_clustered(mddev) &&
@@ -1575,9 +1576,12 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 		/*
 		 * The write-behind io is only attempted on drives marked as
 		 * write-mostly, which means we could allocate write behind
-		 * bio later.
+		 * bio later. P2PDMA bios are excluded: write-behind copies
+		 * the data with bio_copy_data(), a CPU copy that cannot be
+		 * assumed safe or fast on P2PDMA (device BAR) pages.
 		 */
-		if (!is_discard && rdev && test_bit(WriteMostly, &rdev->flags))
+		if (!is_discard && !is_p2pdma && rdev &&
+		    test_bit(WriteMostly, &rdev->flags))
 			write_behind = true;
 
 		r1_bio->bios[i] = NULL;
-- 
2.52.0

