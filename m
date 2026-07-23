Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF6D4823AC
	for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 20:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839394; cv=none; b=uj7oB5G6Vtq8XvSqEMbsAO4nIldfWKcAx5J3P9KGyWV8jjC8XONojdHaJkTz6ciUaU+l5+k5UqEl4/vc58eGeGBF68+YsLtrFiBnqJOFOX/xdB4uK/iEwZ6Q1W4bOWUFmxY9WT+p6lCRW2hWyHq8QoS7A9+COfCO3NY2AL1t71Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839394; c=relaxed/simple;
	bh=6JUXonkvhqCluPq91YNslI6Xc6PHhaJJ82TMx9QRo24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfF0wdZ4gUVwP+E2niw4SB6k5TdUzrKhAfEgxi2Sls8Mar9W0FFUI76+4tkNhtKz/im6Ra0Yg5Zkn0x6kdPm+7cBZSKUVoGgX2rAWt0Ua7F7yUaf947nnUsbhWHx7m8rsxmp+TaVQmFuDbdQCpoUg0gSt4kcJP899iC7NxrYh3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=b9TCH004; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="b9TCH004"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47640541585so694020f8f.1
        for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 13:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784839387; x=1785444187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=InzNp2nHOOp7QQLn15Ay7fcFkfBNFGx8C4/KxQQFD2c=;
        b=b9TCH004kM7Ijzlq2L+uYapxZbsJtgiPIoccs97iLOok/j4G0z9BoSi7OGTZzfNraM
         9nBbybkLeR3kaqz8qibH9iQR2/+3QMIg8k9UtqWVXdcUsUBX4RdymARurgQLc9PBz+tX
         cU1oMcOcw42w0OxGq4UZ131+iaLE2py0jzPsTM1peGRNz2HSGRqdZT2XUA1zms+v/aFP
         RSKb39m9qHn/9kGElrHMfdLkSFCt2vA+ObV319T3/Q3iv30jBdhCVHMR7mKE0DXcTuWe
         tR1+ya8cQ5UblTusXMB+XkhJKb/d+KQIXTWrnGw3X47bbkfgMA0AmX7SlpGUHEbpPpM4
         +F7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839387; x=1785444187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=InzNp2nHOOp7QQLn15Ay7fcFkfBNFGx8C4/KxQQFD2c=;
        b=oZXFjQ8OyJhoEn8sfatisA4Divb/Q6nd2ALyBCpmRj6HCuUbllCDH3jzPXhiiH3GRR
         vZn5BCavx//B+QN4ob4DLQb2PmzAKgjRUk6pik0vGD+9eZLbQQUofe2tRE7d7iQMMF3h
         g4ecHn1nhUf9sJmGGl86+ZQHqSKGWTgybNDCe1shTNXXhONgczDLqHzR4fb5/J/yQYl/
         pazGkW1dD5hOME3zn3tA+jZ+9+IgudEAgOAisrGTOwK/IsEiXu3vaNwKJM7Oic5fIB6G
         P/J2k0dwByanfZ4JXZ+18K0hsJ0a+yWauhPCCE7DPfhcE2v3FVpAjEFEV/Nn4JDUGOO3
         0Ihw==
X-Forwarded-Encrypted: i=1; AHgh+RrYvYXCAHRtWYCdfEWVg83blZMfyuxE0z1KITXtjw1kF8FtTTFKxjRzuiiQ1vpMlCeNSj7upyDUMNye@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4Y72zSPRF2SxcrMdcdfoEtSsJf9eX2rv3wq3vQyaQ5/YLZssb
	uQwDiqPkORRGMnS27D/8NzG/ld/WYKqTx237N1zDSJXvdB6ibCCbbi1B6JUEV/8QkQ==
X-Gm-Gg: AR+sD13Lx6rKx0NBAbfqbGOVEYbzdByKw16RAZvkM1O7b66x6kAFsArMgPDmOzz6+j9
	9c0hFnP7F+uTTzBddfadAboU4rEgF5P1uu1vhAmDA3ayspJouNOjmCqxLkEZ2SyTMRKlvmjYf5R
	HwDpO50K+rZHLe8g2ftuHPVQ6J997XfCe0reoX5BxRuFHLxCOHNce6QbqhmjUUQkHEhJeufWGF/
	iGuqDDYuAf/AbMR1/LrEkPEPQXTzFQITtztLCFT5qg1R9jAmud6xwAJVrDgcT66aWI1UD190nKQ
	o28DlJqz6Kx/XNNOJskefT3sA7tSA63HhkJeKddFO15B/pjP3iggBTO/Kmzm/vZcjYQo5dIzaYG
	QLV25XnLvfkNTBHr7i7qn8U5Qu/5+cQpwViau0D2N2EH1FcKqAnFFF8pvBdegXyfAokBdlvPYIl
	KKk1dYQG8xKgpGZemAFkPwXu4Sw2RYxuV1x6SEddrZLlFKjGQddN00qRBxA6khM+4GYoVWza+43
	V/Azu9GC2zaogeCOJ1Xdn+Bk8/960UkjNhRihBMeQ==
X-Received: by 2002:a05:6000:611:b0:47f:25b1:e7b6 with SMTP id ffacd0b85a97d-47f8dc7a211mr5521629f8f.30.1784839386364;
        Thu, 23 Jul 2026 13:43:06 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c52fc0sm18268192f8f.23.2026.07.23.13.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:43:05 -0700 (PDT)
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
Subject: [PATCH v5 06/10] md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones
Date: Thu, 23 Jul 2026 22:42:02 +0200
Message-ID: <20260723204206.76930-7-mykola@meshstor.io>
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

narrow_write_error() re-issues a failed write in badblock-granularity
chunks, cloning from the master bio and resetting bi_opf to a bare
REQ_OP_WRITE. For a P2PDMA bio that reset drops REQ_NOMERGE, which is
the only request-level protection against the member queue merging
P2PDMA segments across pgmaps or with host memory (see the preceding
md_submit_bio() fix): the retry path would quietly reopen the hole
the submission path closes. Restore the flag on P2PDMA retry clones.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/raid1.c  | 3 +++
 drivers/md/raid10.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f07edeac6e5a..19c4dec450de 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2561,6 +2561,9 @@ static void narrow_write_error(struct r1bio *r1_bio, int i)
 		}
 
 		wbio->bi_opf = REQ_OP_WRITE;
+		/* Keep P2PDMA retry bios unmergeable, like the original */
+		if (md_bio_is_p2pdma(wbio))
+			wbio->bi_opf |= REQ_NOMERGE;
 		wbio->bi_iter.bi_sector = r1_bio->sector;
 		wbio->bi_iter.bi_size = r1_bio->sectors << 9;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5b63175fb382..428bddddfe71 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2823,6 +2823,9 @@ static void narrow_write_error(struct r10bio *r10_bio, int i)
 		wbio->bi_iter.bi_sector = wsector +
 				   choose_data_offset(r10_bio, rdev);
 		wbio->bi_opf = REQ_OP_WRITE;
+		/* Keep P2PDMA retry bios unmergeable, like the original */
+		if (md_bio_is_p2pdma(wbio))
+			wbio->bi_opf |= REQ_NOMERGE;
 
 		if (submit_bio_wait(wbio) &&
 		    !rdev_set_badblocks(rdev, wsector, sectors, 0)) {
-- 
2.52.0

