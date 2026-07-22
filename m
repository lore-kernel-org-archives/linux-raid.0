Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25B83AB466
	for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 18:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746752; cv=none; b=RY8lDDzy2wr8nw32fp0NoxxEfO0BSCabtNs+LpjmLCR2zqM/3NsynuX0iuzpcWmbq9kdMTULKWZ6zj/I38SYR0SUbp91GZ1XBiknH5g4sUbLeLm23jHVEQX3JaYTBCNMRAh59ve4KOz5NN507dn5rtWs9Fb8UGw7t9ZboEckHBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746752; c=relaxed/simple;
	bh=hrTCMMr70YntHE8rHfpC3UJfjfd1U5mS3A9u7ATI3Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swPjZGkkkeGSOSUeJ6DmjuQh561jumhM/TiOzeL3/LZSIIoYmHUgT7keNjmmB3Mn0rTT7t5XzzEsUo2RzF3RY/uqoiCTS5eHyb70rSFrER987+4eDQBb9QuerugzU94pm12oSu/GccRGLJ0vCELuo+6Wyjof2leLJPWztChPNrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=SCM4LtE0; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="SCM4LtE0"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4955158f26aso29562935e9.3
        for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 11:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746744; x=1785351544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GLcS/ETJPdW48ntvSy2VqAomcBgiATmYTCUKJMNlgIw=;
        b=SCM4LtE0/HpN8EcuX55CGhXLzQF6CsoQYXwzal4P7HmkEvDIZZkJr5vC/kZovKCeL5
         PbzcFYqq0NevqxMdGWPlGgJNkm069JS2A0YXg+z/gRCj9mM8V8mTJ5g0OePRGhZahP2R
         WE1+kftU5H0VLSnCXfGtSkx5C5lJoWSsgahn9zwgXpEuuEgZuQwbsFRU9c/YuKlbGSmt
         ls30RVA7zLvvd4l2JiWbZKamN9xdgNZiryp5kbj9H5flxCjCwY1nLZRjB14Jy4PxFwTH
         wW+Mbb5hP/c+D2MkM3PGnESFAs905wfwpcYLmk/M1LL3WJLiy+rXXs9KPasSJz4m//Gf
         a2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746744; x=1785351544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GLcS/ETJPdW48ntvSy2VqAomcBgiATmYTCUKJMNlgIw=;
        b=Mg6m+sjIrwa2bjbYJqPoekAL+Qhhc1wSwAD7pNLmwLuBdO24sA6Ude/IWVg87DRCUt
         5yn2YFDxh7RA5ntjfESavIWprEb+WcHG2JUeN1qMI2EcmJmgXbWQNYlJVLUh4E3yVYHp
         FcZQq7+xMhpPunLHO3uWLsvUBw34Va8JVCBpSTcyQko56qCrY7J/fbWBmOPQ8vj1p288
         NYUFehGE8zn/qfLhmRQpfxjo1DWCrO+LcMOJ9LjEijFaMEvlAd2gOhCt/0LfKDmXGgLF
         kS8sDONz4xByga4PZ0ZygeumbD0ek3TGwvCZ3ZODULz/eot313uWj/4cGWqxC/gTtULQ
         URkw==
X-Forwarded-Encrypted: i=1; AHgh+RogpCIJATDwg46Bpr8SHR2O4rCNpjWnpSX00CLAqtDZLF9/ncuTYAiJ4lyQ3nkdLzSZwJ8H4QMRRXyr@vger.kernel.org
X-Gm-Message-State: AOJu0YyXGuCPEfIH64OUGshRF1aQNpyScMYWtsiY63WASEJDyOuS38d7
	wM73j6StVtfinbGNhRxa8FXgmg43sRroYkxTme97eh6fFAq+CkL9k62u7SjoFLSkyA==
X-Gm-Gg: AR+sD12VySmtgFm3EbiluaUxNUEOXAt6DzI5YH+7F+29Co78T2iefe+S8UrruuiDymB
	U/nnxwyE8xgfcpZtWyeQca6ZDU3IReKlEgJahIZ3pHdiK4lSV4HCwwbRRBGzSvGmGArXjf0EJKw
	iQRizijMHQUza5xu0iNY2FMJ04qt/6FQepZfFbRAvFrPrGB03VU4DdO3J8B5r1n4Z+m2ZExp9+t
	Rh8+iDzR9GW5rQgtoaKqyxz4LXXP+wSJ5OCokN61d7e9NXdrkZ88nIXfPhUVDczkMf4FvwHcx1U
	CbGAA6OtwHYSwrFeimy0a/rvB0MmlFqwG1YWD6mOKvr4wmd3e1bcYem0nq0egGZTv4U6f1//C2n
	Gi8YrnpKJETd72/nVPWS/YyQG7dS4c8Lsg8GxjCGdkuvEi4UqLyo5/lXqVrQ8KmCa5JTos/WwjS
	CTtF2CaBqatHAHcr05bV7C9iF0qo/kDwwibvjxVopJwR8zJNg=
X-Received: by 2002:a05:600c:c84:b0:495:4811:d71c with SMTP id 5b1f17b1804b1-4954a3ed4bamr271393965e9.13.1784746744468;
        Wed, 22 Jul 2026 11:59:04 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495730353d9sm13740055e9.12.2026.07.22.11.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:59:03 -0700 (PDT)
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
Subject: [PATCH v4 3/9] md/raid1: serialize non-write-behind writes on CollisionCheck rdevs
Date: Wed, 22 Jul 2026 20:58:35 +0200
Message-ID: <20260722185841.449934-4-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260722185841.449934-1-mykola@meshstor.io>
References: <20260722185841.449934-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A write that skips write-behind (full behind queue, a waiting
reader, failed behind-bio allocation) races the in-flight behind
write it overlaps: nothing orders the two on the write-mostly
member, and if the older behind data lands last the member keeps
stale data for sectors already acknowledged as rewritten.

Serialize on CollisionCheck, which marks exactly the rdevs owning a
serial tree: serialize_policy rdevs plus write-mostly members when
write-behind arms serialization -- the case the MD_SERIALIZE_POLICY
test misses.  remove_serial() under the same condition.  This also
avoids the old gate's latent NULL deref for rdevs hot-added under
serialize_policy (they never get a serial tree).

Fixes: d0d2d8ba0494 ("md/raid1: introduce wait_for_serialization")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid1.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index afe2ca96ad8c..997f79c05db7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -564,7 +564,7 @@ static void raid1_end_write_request(struct bio *bio)
 				call_bio_endio(r1_bio);
 			}
 		}
-	} else if (test_bit(MD_SERIALIZE_POLICY, &rdev->mddev->flags))
+	} else if (test_bit(CollisionCheck, &rdev->flags))
 		remove_serial(rdev, lo, hi);
 	if (r1_bio->bios[mirror] == NULL)
 		rdev_dec_pending(rdev, conf->mddev);
@@ -1677,7 +1677,11 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 			mbio = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO,
 					       &mddev->bio_set);
 
-			if (test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
+			/*
+			 * CollisionCheck marks every rdev with a serial
+			 * tree; order against in-flight write-behind I/O.
+			 */
+			if (test_bit(CollisionCheck, &rdev->flags))
 				wait_for_serialization(rdev, r1_bio);
 		}
 
-- 
2.52.0

