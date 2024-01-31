Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00146DD00
	for <linux-raid@vger.kernel.org>; Wed, 31 Jan 2024 11:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706699828; cv=none; b=hvxCe5VdpaZNPaP/JLzhoxyFEf3x0dO/nTziVOHF8iU7X/qiS24N9sWYRf7NkFbTWV5mtNT+b9h4FzevuNwnXriB5xpQTg4sVlROxNIkcPd9c7IsFHpKhhUj8z3kjGPQsgDwvLqc+KQQQh61r6pQH4s6VGax/n1+zOr8giEU458=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706699828; c=relaxed/simple;
	bh=ve74EjcdiiIDzxneT85YD9BcGmVt05qHmTaHUCmz3Qc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=geyThdUnKNicBA/x12uvYOzF4z43cVo112Pov6+AJ7INOvFLo/le2Pe3wvWOcxB8YJQ9sdZnV55K6XifPtNm7XcoFgd5hS8uNsNFstgSpJQg5DPNdXmEpJjpc1Bfgo41R6cFsWdUmybeSEp/w5I81dov5KfVYhwDTwEQ74wiJvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=B0/92SfK; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B0/92SfK"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-40e913e3f03so53250075e9.3
        for <linux-raid@vger.kernel.org>; Wed, 31 Jan 2024 03:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706699825; x=1707304625; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MtlqC73B9czrrJSb1ShLwb8FyuBnnTaUdZNgETjk/y0=;
        b=B0/92SfKm+2MpFKwpzKFqdOonVUg2NvnMrlxIUMKxzd9AO+/lZ0Je+mn7JRlON+BYf
         N7yTtOvqevqUxYqEOu5QEhexoCDMZfwCIBfrrx7u9jczmLqYMQkd094nMu/tyP3rq9Wy
         EC/NuEe82ITmXnQIJ7NWAiR0kpgIS9+RUNe33wyzeoW+tt/terfF2NXwBSj71bZprDYL
         TBApeX4on/K4+l3OHAbcGA18To3b56vah/wxHwae3xHHfUUSAhqv4THUGFYQlc5/j45r
         RAkY8a1nJMkQlve6P8NpYZHLmQB1jVqrbTMC9tFWF9MrNrlUnmJKq/0RgMNnU59Wevrq
         wnRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706699825; x=1707304625;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MtlqC73B9czrrJSb1ShLwb8FyuBnnTaUdZNgETjk/y0=;
        b=GihyxfXSmOatDQVvJpEq+7lxq50jGx23e4DRDUB2XDtRoIoIUFahgXyojg5U8B0UhO
         0rd+/pQfOCd0rp6E0c89tKrxjcaXOfeFjJSJDve3xk7oAf8PqHkwOA6YrGUIJapnp4Ym
         81c1Jfet636ThnxbIhH3gBsEnxgZRP/8zkoaFd1eyugFBCJxXduilCpwPhhoe1PnTxsG
         +LW/KJ8LGR/iSrt465hY7NkPwaUXU4WlT7dSeAvi1GFX7T48PX+gDg37FEil1et6x6pJ
         BxtFooWwa7X4ta/opbL6QiTKZ4wBZPyCaZIb3UodjrEnAEP1m+22JgL2wbe32ddsxgMe
         7kGg==
X-Gm-Message-State: AOJu0Yw5ShrmRYWbdj+xok83GG6+OqcDY4+GuvCAZJ33miPkHPWC53qC
	7V0f+eBrUFSMhrWsGkQnQMebVNCuY2gczld8nuDRxvHtNNeZuGVjsNpL6EolbiY=
X-Google-Smtp-Source: AGHT+IH+2JNL6gEFoLsSm+XvyJGZeCwbrk9vz495se484ikIfeD1zn721jndzUlH3Thyivow3eEhsg==
X-Received: by 2002:a05:600c:470e:b0:40e:fc20:b574 with SMTP id v14-20020a05600c470e00b0040efc20b574mr1142195wmo.10.1706699825106;
        Wed, 31 Jan 2024 03:17:05 -0800 (PST)
Received: from localhost ([102.140.226.10])
        by smtp.gmail.com with ESMTPSA id fl26-20020a05600c0b9a00b0040ee6ff86f6sm1328337wmb.0.2024.01.31.03.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 03:17:04 -0800 (PST)
Date: Wed, 31 Jan 2024 14:17:00 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org
Subject: [bug report] md: also clone new io if io accounting is disabled
Message-ID: <2cf10b2e-3703-414b-99b6-457dd4b14177@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Yu Kuai,

The patch c687297b8845: "md: also clone new io if io accounting is
disabled" from Jun 22, 2023 (linux-next), leads to the following
Smatch static checker warning:

	drivers/md/md.c:8718 md_clone_bio()
	potential NULL container_of 'clone'

drivers/md/md.c
    8711 static void md_clone_bio(struct mddev *mddev, struct bio **bio)
    8712 {
    8713         struct block_device *bdev = (*bio)->bi_bdev;
    8714         struct md_io_clone *md_io_clone;
    8715         struct bio *clone =
    8716                 bio_alloc_clone(bdev, *bio, GFP_NOIO, &mddev->io_clone_set);

Generally in the kernel, you have to check for allocation failure.  In
this case if the allocation fails it leads to a NULL dereference.

    8717 
--> 8718         md_io_clone = container_of(clone, struct md_io_clone, bio_clone);
    8719         md_io_clone->orig_bio = *bio;
    8720         md_io_clone->mddev = mddev;
    8721         if (blk_queue_io_stat(bdev->bd_disk->queue))
    8722                 md_io_clone->start_time = bio_start_io_acct(*bio);
    8723 
    8724         clone->bi_end_io = md_end_clone_io;
    8725         clone->bi_private = md_io_clone;
    8726         *bio = clone;
    8727 }

regards,
dan carpenter
