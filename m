Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845803E0C6B
	for <linux-raid@vger.kernel.org>; Sat, 18 Jul 2026 16:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784391990; cv=none; b=iNSUAWPBb91lFq5KjogCnb7Qb6Za3HXhUZioLl/eSG5A5pDkudSGxL8qa/Vi9fQWWGtyzIKbx+phEEVxTsxSIcLgNHU8/iK8yMfMr/MuBtwXycRZHIOnDmatefivd7qgwoZ5Jp7dfcwm18bWeOkcC1OvwRImyGxINj2EI3plALM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784391990; c=relaxed/simple;
	bh=bc8MxzvbVIXgCq+hE70J7nSNv3Wiq2lrvNKvz8Yb5i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maAu6wcYR+gAKb4Ez77Llp3XAt+flbnRk6Mho6CYE9EbiQb6ViwcDB2fLU3uMWoCyi/vttChEhU1IWeDJ9rbWnlVVajzqp4Vq3uONDUeoD6DI40DKSOCPYdRG/M9SAHslm5iDpzjygbYAM01RJSwiMPDQf1oTSdIExx1rvGsdJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=murysiT0; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="murysiT0"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4953ddae026so27524635e9.3
        for <linux-raid@vger.kernel.org>; Sat, 18 Jul 2026 09:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784391984; x=1784996784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CUxR31Xh85+TAm3j4nZpX4fvNBvJG7NmZg0i4br8yQ0=;
        b=murysiT0EDR3QJc8dX8UEXj7Qx7YqS5luH0QXYnY2LoVxmqXB/hDbwz0lDT6/bOMYY
         93zuVvzwfXfgn9G06TCyC/PW//Wya0zWw7DKa5gxIPyd+OOT7ul8Xosjv22ImWvth730
         70xJA+mdQ209vab47/Msu78SF9sXPHI1/YZ9Mt0wZMLAtc2d5p6sE7wg9FXRFWT7bb6X
         LzJVCw+yJZ9/ruXNJh6/96vHdWB3zWb+YKVwPqwrSSE89v7FVwnsywXJJGydbYlDTh/R
         +ZSMX7W0dYfO54nN7TOV3g6Jsf0udkt4L5Q0jRzxjR+ONr1vcKTJouI7LI6HQJHYQQi5
         92lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784391984; x=1784996784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CUxR31Xh85+TAm3j4nZpX4fvNBvJG7NmZg0i4br8yQ0=;
        b=WQmuwlZNYFkHt7KRKEaUTszFl++I0kONVvK2/dukAXfYHcLAsje/Wor3kaIvF0/BKK
         WzrMy//c098JC/1Pq2O1uYige80Lm2QFv4YvBP0CMMuK60sUxGusxbLwxsc65jtc9BtZ
         dOoWLJ6KqEh1AM1FUo+zXOpXcEL7TNYfUyd1gHu3RqKZuSt2c9E3DlR2ib65G5yIfFp1
         NFH5H+Fn/JHHORZ5NAiLkAoxbOZ9KpXzFP5NHyq4QBJLXsqrAg7B9z/b3BE+3qd/Gvbu
         hz61cA2obDXXnYH/zLTivD7A4IeL/MZ7RYQ2Qu4BKeNyTVdHhzzZAXAXuhgMG2nc8ezF
         s5Kg==
X-Forwarded-Encrypted: i=1; AHgh+Rq86VtjH04DySJd52AytF29qFUFOpNcldqvSGWXjZpEVSIBGNr11aMpKplZV5Itk2w+4FYpFyRqNOF/@vger.kernel.org
X-Gm-Message-State: AOJu0YzvyQ9FkZ9iAkC4bN2TFIO9Bt6slL0ZQln7G7KtIOpAIQ7fB9eJ
	kU3BwsOzcqoKyQEXXZPEiO5rWfqX8pTalRJOL8PbbLKAkpVxLbzjJRYdjAKwdPb/Vw==
X-Gm-Gg: AfdE7clu/7ERKjGYmLbsEltFmDbw/iuzGAWjIyn2EN5N8Ic+9r6D68mMSCF3gdyoFJ+
	sB5YZ7ypftRQ+UiTiertfqCI0IfkKOC8uKp/ftl3x/4KfH1ZgepWzw8rVsi3SMbR9d0ZnrcFbO8
	YoWJnJoTQvtmTxM5sGDXbgzbHJEMP6DYJ5ANpfUVTJ8CKYAXnLWPTeEItC/10aHJIQ15WFnYxaV
	hp+4FxgItv5Nba5p6AQwgxU6rOmDbQkQFgPJoQvpvjRfN0VFIIr++pfHdpgha9/OxAgIo4P81+7
	oZBfZrP31rZM5N9fmrFzIQrh8f1eqS0Od2cI/6qh6eBWBNsragTezvqlxb6B7iaC5rf4mihIhfj
	fo8nhyxOrZSVGJZ5Kgr7EQ/C6OMVCo9/kTRZttJl8mnygzGw5SGLwYL4k8bIaTA==
X-Received: by 2002:a05:600c:1914:b0:492:7101:3d88 with SMTP id 5b1f17b1804b1-4954a402e03mr75887675e9.24.1784391983856;
        Sat, 18 Jul 2026 09:26:23 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2eddb8sm266444085e9.14.2026.07.18.09.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 09:26:23 -0700 (PDT)
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
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH 4/6] md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones
Date: Sat, 18 Jul 2026 16:25:45 +0000
Message-ID: <20260718162547.448892-5-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260718162547.448892-1-mykola@meshstor.io>
References: <20260718162547.448892-1-mykola@meshstor.io>
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
---
 drivers/md/raid1.c  | 3 +++
 drivers/md/raid10.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 57f64e890102..a30032321191 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2565,6 +2565,9 @@ static void narrow_write_error(struct r1bio *r1_bio, int i)
 		}
 
 		wbio->bi_opf = REQ_OP_WRITE;
+		/* Keep P2PDMA retry bios unmergeable, like the original */
+		if (md_bio_is_p2pdma(wbio))
+			wbio->bi_opf |= REQ_NOMERGE;
 		wbio->bi_iter.bi_sector = r1_bio->sector;
 		wbio->bi_iter.bi_size = r1_bio->sectors << 9;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a3cfdd3f5df..f7ef903a3d4e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2831,6 +2831,9 @@ static void narrow_write_error(struct r10bio *r10_bio, int i)
 		wbio->bi_iter.bi_sector = wsector +
 				   choose_data_offset(r10_bio, rdev);
 		wbio->bi_opf = REQ_OP_WRITE;
+		/* Keep P2PDMA retry bios unmergeable, like the original */
+		if (md_bio_is_p2pdma(wbio))
+			wbio->bi_opf |= REQ_NOMERGE;
 
 		if (submit_bio_wait(wbio) &&
 		    !rdev_set_badblocks(rdev, wsector, sectors, 0)) {
-- 
2.43.0

