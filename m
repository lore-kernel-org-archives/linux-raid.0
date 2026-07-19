Received: from mail-wm2-f1.google.com (mail-wm2-f1.google.com [74.125.225.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E98396565
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 10:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784458428; cv=none; b=ClnRwIEG8jL3aMMeqgLlKgPbqynlyIWes8/GlR/TqJRC3W9yARTYsDGpt13lDKitLHWEfIGyxiMP2bU40AZOAlKYqX38SyRSwcOGXptPawIOY2ozhjQXKdK6W35NHejj9wwHBtp1/DzoGmnD2IFof1ltmRg43vuqV2c+/DzBctY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784458428; c=relaxed/simple;
	bh=ckOwh+/KVDM4Fp986EbTgYg+bPUMzv5VlFWjz/PbPJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZLV57viusEUMkWHP9bOFTUyNykGfWrwVxHxSwDzh6M9+GuHlZjbUk9b8btB9IC7dHqn8JoX/Lq/trHjhTKDOlvrnl+NOZbKHGahUMIcKiNK9fdon//+3P/wvcZrWHuqegzwcTGJDcv1JqgG6HOwHa4BQoHC5AhbDMc7+aCjY5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=JAFucgbw; arc=none smtp.client-ip=74.125.225.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="JAFucgbw"
Received: by mail-wm2-f1.google.com with SMTP id 5b1f17b1804b1-492367f3094so37280425e9.0
        for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 03:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784458425; x=1785063225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2eFgBNGHZVs+4VEn+rFjG8dtsShNuRCRL19zmjqYsAk=;
        b=JAFucgbwqnuXms9cXGHT8sLvtkrldP4kQoLjBJrfyz5rDi2+4d5LG3rxQcsOb56Nlb
         44iYz5BRwf+XIY1G3w6CKTzBUP8cY1ivHuE8tcO2q/7xURPinrCs3IqfItPOmCv+jYYH
         CpattxbHEKF4zH1H5AYZAy2ZImrZbNxRyr1chBAVeu907UB150gQktRQsNlBo5SSfTzV
         /T2jMiUfEKKpppOUMn42Ox4DrZtiuAlSG3NlshP8/okOzvoJ/KQJBcCtdORJHBJjSMmT
         QedaBihhuQXXHk9pc3tU+g6LiDE37OrCjUyYoBU+lFcx7fkjakAetCNySuduRRuq4vCr
         Obuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784458425; x=1785063225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2eFgBNGHZVs+4VEn+rFjG8dtsShNuRCRL19zmjqYsAk=;
        b=NIiDtgUX0HbbrdKV6UfkqDepX91v+f69eEqTxRLDlfjmsrZEd2AjpDX9L6Ly7LaSw/
         XqRyOQ+FrXnJNuRcXMmQ0pXXl6Ymt91Eh10RD1B+dphM7GDAYB0MUlGJ+r8d4Ys/SyXk
         OlCHtE8E4y8vbsM2w6W4vV4GlOLORRuvyIrOto+HxwHRU847CVLNl3x3WrWPCOruBK6A
         QaAPVDHDflQXW2JiOf1J4MaAtLgHPVEJfCMlD9TBVd9isZ1Mbc4Fcph4FkevavjpdnRF
         bJi5vxqQu0s6zzLLd3vG1GyhzCEFxxuPbun4cdIa3cfqsdklJ3ubj6Y4NLiU+OJx0pI8
         9idA==
X-Forwarded-Encrypted: i=1; AHgh+Rpe2U6fyqXJF1FtX8ne8UL/GGWWS1es28Q2Uqa33BNwJNAXlj3Mei6YBaEUM+tq+9whleKImx2rJWEC@vger.kernel.org
X-Gm-Message-State: AOJu0YyzKnzFbSErqmAC+n/WwaQQQyGJdlz4zRqw3q0UC0FMqpTi2lpi
	Vw1AIuxLb3bqbJ6JgE9UxYPAypt3pk/GMejFmm4aH+cBvTDVybFJu4aVhyxgN9FyFg==
X-Gm-Gg: AfdE7ckqb80fI/MIX9a/vWA8U+bvZiQ2LNYIOwyjltIxmxQCsWIHuP2kN7VcE/kvY+V
	KLqxSi5S1sVjXoOOvwL7PV/6Lj2wFGqTC1DbwFYqxpWK1x/XYaAqXhVvQosjqaXt0C8oWIonF5X
	zygiaoZXs9iO49KGf1TZAIyU6r6fptrDBGeEV2ii2dSqeqBoDDe9M3fpEoyPGz/hV3Up6s4mm+Y
	pAkJc/2WyeywCM6AK/Vr+ckV6LHeQk9xHwgaYJHO1HJdudGrnYlmxFyx3jEokAV5cmsi/+AZce9
	4BriCxdy0BYwwfjb+zcFbkHb7iju4rtu19TII3V4yLaqwOV6xKDnicyuYtHTYjbzUxD82ueFvPF
	QppmAcLcaj9VLiGhbHkRl0GIC88UGVB5FZ/2nlOr28CQuXfJhUkjPexjMa2Y2KYNuCPgFW/at
X-Received: by 2002:a05:600c:4585:b0:492:437a:a653 with SMTP id 5b1f17b1804b1-4954a50b811mr100979195e9.26.1784458425036;
        Sun, 19 Jul 2026 03:53:45 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2a24b6sm197679575e9.3.2026.07.19.03.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 03:53:44 -0700 (PDT)
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
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH v2 5/7] md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones
Date: Sun, 19 Jul 2026 10:53:25 +0000
Message-ID: <20260719105327.864949-6-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719105327.864949-1-mykola@meshstor.io>
References: <20260719105327.864949-1-mykola@meshstor.io>
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
index 914fb86452c0..f562b6bd438b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2573,6 +2573,9 @@ static void narrow_write_error(struct r1bio *r1_bio, int i)
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

