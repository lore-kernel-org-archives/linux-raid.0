Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDB046C4D2
	for <linux-raid@vger.kernel.org>; Tue, 21 Jul 2026 17:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655969; cv=none; b=uln8fMRtnDTMCDTzYf7sUl2SKl8FhDniRGrN2osXSecikcN6BO/pMRrGBq6J1ENMYQ85eSlk3DtdYs0nf6NLmMruxc+XnEUqBZ/pBl3OQ8SXEf0K3N+P57gjfrSwLhHbg6iNq3VBxufGNLzH6dBodTQHgp4lBb8puCEGY8gfm8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655969; c=relaxed/simple;
	bh=hrTCMMr70YntHE8rHfpC3UJfjfd1U5mS3A9u7ATI3Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpyPvp238s+rSnGWNTO+RLJaztFoGhh3pdCAtE+NFXSuBcBsyfC74MiLvPsrglVel+zZduvkxgAAEazJzhDjVDeHEc1qxKl48VfYfY42K4EKm/4H5Pci0GFUQFTExGnzTSV7OgSVSNf8ZWnZE1/D4P+qWqqZudOXfSpdCkISgLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=MnhgK+D0; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="MnhgK+D0"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-472326ca506so8974379f8f.2
        for <linux-raid@vger.kernel.org>; Tue, 21 Jul 2026 10:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784655966; x=1785260766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GLcS/ETJPdW48ntvSy2VqAomcBgiATmYTCUKJMNlgIw=;
        b=MnhgK+D0jVt3+ATaByMqGtxcYbe71WAklsLkYbQhxrMZaCwgzYNT3aHKFTRkoVNwii
         fgMwGPTb6jPT5SBWRC4CmDhweLrQ+ncGrx27LpP8vn/ROytTD5noUlKp/4F8olifBqD9
         2Pl1nWmvOyjv96G8ddkLN1sumDxP06ApYiHy5alMfrN/hF/SdcsFRLxsN+qPNqB+5/mS
         6ffSR3qx2XZefTKfoLDbwgATTTPTeYZl/gP4rDxmc7vF/6QOdo6WcwutfQA637576wt0
         /z5DGIbaOVuFqSZMx9teep6Z363p8TYoW8xpugvIWBhRGFDCZARezjr2kSRc5vlKzMNH
         NldA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784655966; x=1785260766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GLcS/ETJPdW48ntvSy2VqAomcBgiATmYTCUKJMNlgIw=;
        b=jCXTXjix//CN9ZEQcidy1aLS6D6u/sjE1sNP62k18cgm/vQ68sZlNgj/TTAXuPCiX4
         4FWiinTepiG8pzqR4whJLtbdUt1S4Rc89lhdo9P/KItHG6PLCv1b8J7qdwzmR7DpBaAo
         XgFz09ghjL2+kWMce3b2yLAL4xzVzFpSBG3Qb4rVjP3XuhAwQfvbDhNBVs0Ba28RQqsM
         /IfZgP6gCK0xNPUF8jUbeKK2HQHg5hp2n2hw38t4UpZaaNK4hVGGgWNRG0yj8hUCxXg3
         p4Xffmj4wSXaUXtR4JRhCQfoyEvuiqA9PCf+sHNIhw8SAF1F9RYSBJAfyJgsS+j0rR1D
         gVbg==
X-Forwarded-Encrypted: i=1; AHgh+RpryXwWF3rNLKZ8EHMpRozSIhmfyhEH7mL4CldaSUQz9wEXHFCPGVhhu085euar/+AMsrfAFiFRFEiH@vger.kernel.org
X-Gm-Message-State: AOJu0YxyAdMRneM+PFjQ5FRBmwmixA2as8yRvesPhrSPY8fV+pmEfj+s
	Uay0ljOwF/j7DiHyRqaK3W4pwLFi1c8EYSxOEJQ6MZ5fptw7VqqRPTF/3LKX3LI9QA==
X-Gm-Gg: AR+sD12dXIS65m+w/+NixZZssCq1mtKub4jqEF1bmqAj985szBBsTNLEelBnptsk+5w
	1J2ezXii3kD54dwp7bNf60GQWksFfpmDHpslby2rdHIuO0V/k6ab6ziZhdGsNXxciJuOWiLnjPA
	dS8jLGMYU21n0tYlQJrxewSPyFHGiznSKJp3hYS+Rlh8zP7GnGGdEOtldUkvtniJQuv5BDCbGnC
	Le9nYS+v/UtqymRzwMH9ABdVlPxLnfcm4HYrZ1hWxQdh5n19wvr2It9xPCSZlVpyMiMVvxJDaNX
	/OKs4cQ6nTWPK3NfrAdCjgSZn0bpkjj/RJ9oHTOZ2bTFsq+4VYTZL/Uq6jGkT6/wzunii6zlyKm
	zu3tPz5LSa7r3X/UEuouK/i44nNWkAr/XdTqeAVtM7D81KlS8v7SIRDidyeenB5+XnPGT+kvKsE
	tMq3ROpCyYzY7GPRBLhD7Hb7KCSEU5MOHjMHqbR0CK0+UkN0c=
X-Received: by 2002:a05:6000:27db:20b0:47f:4602:66e9 with SMTP id ffacd0b85a97d-47f6232e29dmr17004239f8f.40.1784655965889;
        Tue, 21 Jul 2026 10:46:05 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63eddd27sm40860513f8f.28.2026.07.21.10.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:46:05 -0700 (PDT)
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
Subject: [PATCH v3 3/8] md/raid1: serialize non-write-behind writes on CollisionCheck rdevs
Date: Tue, 21 Jul 2026 19:44:57 +0200
Message-ID: <20260721174502.111503-4-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260721174502.111503-1-mykola@meshstor.io>
References: <20260721174502.111503-1-mykola@meshstor.io>
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

