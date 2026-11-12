Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794491225;
	b=H4V8zF/6S7nHJurR1w/IxabHKFZEPoVInczZHc5P3w8QdsFHSpZNR5jX0nrGykAJ98T+
	 WpvMjosVVP68XBMTvIwzsh+I94KWs7/EIfBhZIRhHUmIUnYMGH6FWdGIlSuuT2/eJVhc9
	 eCGKhsfck2eO37YZXHjbOCi8e735nQTNkb1JGvUl9+niZOCLtB7DNgaDwwFpWahuweGbN
	 u5vpLwdH+QTdcYaGki30Ry676skrNEoo0DxByWq/Bf5tfd0Om3Sd1iu46nhdX6lezSs6W
	 GF8fNCCBdfPCpWenHRhhQvX7yHhOfWap05ONbAKCvZ+D6DpOAgHWc/jFC1zRN8O/Nrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794491225;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=At9dnyT/4q/wJJ9tfHQDwKMvIA9o4nNPXbuYEoFso6w=;
	b=h3yZcNJ7vUjejWKZ/iQ5Cq6QKIkpheuMZdHZLAkKs0jqQyyLO/V7P53E8vOZ6zjJn7i5
	 mQ6zz8GdecsCnXw9AuaTG4WUhJ9z16/NZdiv+/pqlB0SI6Q8b9bi1OUC4LEVV8HNjYGDE
	 oS65UJP9Uh5YT8wkMCiBBUja0UKJjaRaXgqqZXuPBKMIruXURH6Yph1tGN/MY5OSOkwuD
	 u7x0NcfjEJ8ppnWyWQx1GiKMGSM8pHOvFy6HECwr9BvmwgJHXa1ZH5xfuPe9Lu/WJJPfD
	 LtIQkvaoHwXEMXWsPZ2eMWQOUPycACvxxWZhznJe0Q3PocHQdQbetkXehZ66TE2RPgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloud.ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=Fm27Yuq9;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDBB606A884
	for <linux-raid@vger.kernel.org>; Thu, 12 Nov 2026 13:47:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1FDBB606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=Fm27Yuq9
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-49a357e48a2so122540f8f.3
        for <linux-raid@vger.kernel.org>; Thu, 12 Nov 2026 05:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1794491223; x=1795096023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=At9dnyT/4q/wJJ9tfHQDwKMvIA9o4nNPXbuYEoFso6w=;
        b=Fm27Yuq9g7zEqILjHO8VSWuJNFq4DrD6kqa1MUcXpyXdfjc16G9jkLcHADjhHFO+SX
         6EiMtZOmwH7i8vIYEqg14qvjz2PZFGAS+bwQf4ApqcHOCaX65vYSCtAemyHSY95qRSJP
         QLQUKnw/Ewmf30XmRjyHWK5iga3UBw+xW6IbwUh+JbJItzusbgI+crjcSRhmltNrCmiF
         VRZKk25hGlHbMbVKPZbIvL6fpoJytG9KNh2r1wVhz3vp2zuaIERwCEBVc0zPmOSVQPcF
         6yVcPlJSb5KdJiY8DtuOaVqw22+B0IjziubW5L4oOEyzB+zZQjBRE8vG24gvJaPF0zjX
         ErTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794491223; x=1795096023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=At9dnyT/4q/wJJ9tfHQDwKMvIA9o4nNPXbuYEoFso6w=;
        b=jqFVFAEOksmmyso/L7XMR05v3dXUSQP74+Hm9qrbJObGaafujJ/9CBVz8YSlwux5hF
         qdNk++OX84wY6VsnXP4BhtRJz0SS+vsKB6YcKjdw1uvBIN7MmeU4wTlDsYRwZsApvg5l
         L1cjMCqxzGf/HhDIrX+3EKKy9lbmsljItUhoEOgs/bnm9mLazl50aSRHi2cboSR3TYgh
         mlNto1ot4HKo+kyugtts4b0sByU/gyr8Uid7Q90WDODplEXAgVfrsQmRCVtwbj6zgQ4l
         AqAnS9X1CXT168K5xl0Abiu+xTE8cvYqiuMvHjywS7gL0GncBZs7ITxQMtsbuP7hl5nl
         7oRA==
X-Forwarded-Encrypted: i=1; AL+hErF+Tv/AbfR/n6FKDwkzmEFBM7vdZGh7+Hynay6xecvugJ8vOARahaCEHLy4jcbAPlhLn6F+GwrecQoA@vger.kernel.org
X-Gm-Message-State: APuU4Z/4DlVhyjkViUwoaFzNL9B/tACylLqK0dCswNOrrs7J4LOMFV0g
	gITsK7jdSdabnaF3K/WkSQvNCfBTCUX4995mjTbSxmOh+kUMaHszsMU+ANQE1D3bNU37j5Z5Rua
	WAAxFWns=
X-Gm-Gg: AYBFou1g93EOfhNLhm6kbtXmDgmwmh7gZa0weFfCamAyZiX3NuCl8ZhwyXxnSupHs+s
	UZppcAdZkYAm+7n+wiaLxG8e7QRnu7Tp5vpgvtMBb1tMHWWR+aST8ZTrEvfgTICznXlSGiY9tLe
	Stqj8op2eAybPz0nTkrV5Y0eUwPUygONUunV6P2iJ7hrjzEJveEuchHW+9qfpiFMZQaTFZCGHEt
	ujzJDEyvEgZ8qOLbwZmLASMCcUBSHsxBMU2hi736uxtZoDe6v+GUQEFI8zHRhGTYkfBZAxSNEzu
	/+mC9vCs8yBuoQrwdCnOYSU9/R5yKxnkt4LVlVFZj9A8kF/ZjUhfiByGMbZ1QF8ki5NPWVwkhIf
	olnNzwxjbIcgdG70/sfDnMb/akcTVTBJtXPuwpMf8/VfD9wsd4gX0yrMIugS9fWtprAK3HSldPL
	Y/wcsf8gA2q98o5/u4QjUK0eWzov13mi+RMwQirmR8yBocXoAbQivoVLMvxHBnb4qaGANiLJEfb
	Lr7qJZ7jeRDKQfIZ9qOIAAbAa2zhloaw4e3lLA+P2AfLbQsQmgc02CbwesQ/gg7ZQhrsROUeQnD
	UipOUrxbd9MkZFxs57d64ob9fpjSKGbzadCcBtgUD90zASW6/YIxklK46WknmGCa5W0mVRhpAbA
	9j3QnBQ==
X-Received: by 2002:adf:e196:0:b0:48c:6611:82 with SMTP id ffacd0b85a97d-499c434be3fmr10614340f8f.1.1794491223476;
        Thu, 12 Nov 2026 05:47:03 -0800 (PST)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498367b99bcsm17665990f8f.51.2026.11.12.05.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 05:47:03 -0800 (PST)
From: Jack Wang <jinpu.wang@cloud.ionos.com>
To: Yu Kuai <yukuai@fygo.io>,
	Song Liu <song@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] md: suspend the array instead of freezing the queue for limits updates
Date: Thu, 12 Nov 2026 14:47:00 +0100
Message-ID: <20261112134700.372702-3-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261112134700.372702-1-jinpu.wang@cloud.ionos.com>
References: <20261112134700.372702-1-jinpu.wang@cloud.ionos.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Provide ->suspend() and ->resume() for md_fops using mddev_suspend() and
mddev_resume(), so sysfs limits updates no longer freeze the queue.

mddev_suspend() only waits for active_io, but md_submit_bio() reads the
limits in bio_split_to_limits() before taking it. A bio already there may
see a mix of old and new limits, as with mddev_update_io_opt().

Fixes: c99f66e4084a ("block: fix queue freeze vs limits lock order in sysfs store methods")
Suggested-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/md.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a802..c9fa4e99569a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8669,6 +8669,16 @@ static unsigned int md_check_events(struct gendisk *disk, unsigned int clearing)
 	return ret;
 }
 
+static int md_suspend_disk(struct gendisk *disk)
+{
+	return mddev_suspend(disk->private_data, true);
+}
+
+static void md_resume_disk(struct gendisk *disk)
+{
+	mddev_resume(disk->private_data);
+}
+
 static void md_free_disk(struct gendisk *disk)
 {
 	struct mddev *mddev = disk->private_data;
@@ -8689,6 +8699,8 @@ const struct block_device_operations md_fops =
 	.getgeo		= md_getgeo,
 	.check_events	= md_check_events,
 	.set_read_only	= md_set_read_only,
+	.suspend	= md_suspend_disk,
+	.resume		= md_resume_disk,
 	.free_disk	= md_free_disk,
 };
 
-- 
2.43.0

