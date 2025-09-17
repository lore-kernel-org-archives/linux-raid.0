Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5D42D2483
	for <linux-raid@vger.kernel.org>; Wed, 17 Sep 2025 14:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758118885; cv=none; b=dsA5JY5UwEVczDXk8F+CBlAj9dUi+9IWE63AxJVnAwLpSlHPxhAOXCFz7QzfFR5nCmdzQUbTgF52Vk51ScYS4e9AFAmdN3J4fKvkVDSOi8jP0o4RyhDveQjdvvetaCJjdEyI+y/d1/4eXPn9BF+ZBcX3KHoM84Xvi3xkxgyoMAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758118885; c=relaxed/simple;
	bh=1TUVSazKQlcSc3z3Y2bsrkbYOyuQZNMq/r+GrFIaxTI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hTmSC2L6xHRojVGHABZigGlcy7qd9TfeUtUqRxoKFWcopSCUcMz1AMXCZLty5An+sPuudgKjunikp1CSKJ0S2nLtRR0vwUA4+lkuQFn+T/GJvujmkCU6WcfpoQLTUmh402GjmaYnaOBCwv8qDe549v3OHNPrreWPeIn2uEEE+yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wjJHQij1; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wjJHQij1"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-88432e27c77so180980939f.2
        for <linux-raid@vger.kernel.org>; Wed, 17 Sep 2025 07:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758118873; x=1758723673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d68s8pWNCdPaGhVBNodG3vOwiZCJ3oHbIMlBi1U/Nnw=;
        b=wjJHQij1Djnyd+LvAKaJ4kZDOns/Xoy+QAvOS3vhpqxRB2B+xGPTELcZ2lPynzkwTK
         I3l4cTijuHItHj42TfPELiHvw2dhDtgLdYHWo5xIhbNbLEzoVQUrjCjhSh2tEqSrbo6t
         xHcXVl2d08mcWhHFf0v4CGXDC9Lgk2lfF9aQHF42dyYSRugUJ48y1NN3jiTpUt+PIH2c
         huq2O72EpWltyhKJhSubacSFu5Ba3RpyJ58Uise8DjqELET2s6wlEAKwr4IF+nEq5IV8
         cfBPcfLjgSiLIzWOpd0sHHjoOxSa+eEjLpBaEst2HvKX4LKilkAe+yRuG/vvcbpBz302
         fmFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758118873; x=1758723673;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d68s8pWNCdPaGhVBNodG3vOwiZCJ3oHbIMlBi1U/Nnw=;
        b=l7R2ltsIYoMqRW4j8rC2iT9ZjGYrWFx9OQV8uy3Qq/bBVBc1ULw+oAhS+RIVoM1qcE
         qCDdZQ5FUWHWCF8lr0vCyCpMbEHxSKtVZVUbmeYz0jUcG9fKSmBxAl/1hH3FlJjMji5R
         N/5Pe/QjiJhq+lvoSRa1cf3epeoPvYeujzKMOTw9+oSeDcly5n8wNj+8sfy7tMGNQhDe
         3c6MdpAkVXaNbcajK7YKKfNs45VBsHyD0pxshJW+CahoMxfUVA+vM9oDpdXexLJG1OMp
         LqZP36Wp6aw2BzEaH3qD5ngxAIQ91P+pXjXaCrOlnrQ0PK+D61+FUB6eTrqenDFvgjcs
         KD6w==
X-Forwarded-Encrypted: i=1; AJvYcCWQIixJhjBE2fKzKtIqLAH79Uc/QT+t1vgjxuEDUhfj3nmhPpSBkhC8pH4f6v6xbRNBSXSr2RNWA9JY@vger.kernel.org
X-Gm-Message-State: AOJu0YyG2Jy6Ez8eOSEN0GEjLBYWCqMR0YrkZL6SIvZI09cr8uNh55MD
	OT7wlm+Ou0rg1hyHNOKDGVaGY2dXHz4wTYaBnlOomnoYqzWJvXKmy76g4/PWf4EOZbM=
X-Gm-Gg: ASbGncv6pGqVnd9RvGA0s/1MpfIpsk2X56Gxulzj+jVQE5Qxtckh5egE77gzomtpYmp
	tzpVHz3RkBYSWlF4ydPsfdS0u4x1vtFBFJ8cLdFFI6mgFhyZqXd7rPNDNe+iqll6T23pHITev9n
	SBl5fOOU4Sm25KZcWT8wiNLWbXgNNgxt4b5UxWToAN0wWE2UadxD0c9nXEqAj2L4vPmNDUyh/l0
	FYOIYW5CjyVoJBO75J9U4SOzUYzEo8B/hpqA7PK7Bb454tRxkqWxLWxCplPpYq3bp0sE+pAptNS
	02TRrSqIx0WsIqo7yy4eCp8k9bTPdGmIyE2pxeKDnOHqcSoxwT7c0l9TgAJPb21NwN4PaMraWpd
	ORRVYYe8xW/0d7w==
X-Google-Smtp-Source: AGHT+IHdd2VS4yz6Fa1klXONV8I+5ZoG/vMhg8JzZxOXeIeHOgf+AemBCv8ARUuHNgaKUufvKlJZJA==
X-Received: by 2002:a05:6602:1683:b0:887:1b69:9693 with SMTP id ca18e2360f4ac-89d1bfaa016mr356375239f.5.1758118872921;
        Wed, 17 Sep 2025 07:21:12 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-88f2f6c6339sm670751239f.21.2025.09.17.07.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 07:21:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, 
 drbd-dev@lists.linbit.com, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 john.g.garry@oracle.com, pmenzel@molgen.mpg.de, hch@lst.de, 
 martin.petersen@oracle.com, yi.zhang@huawei.com, yukuai3@huawei.com, 
 yangerkun@huawei.com
In-Reply-To: <20250910111107.3247530-1-yi.zhang@huaweicloud.com>
References: <20250910111107.3247530-1-yi.zhang@huaweicloud.com>
Subject: Re: (subset) [PATCH v2 0/2] Fix the initialization of
 max_hw_wzeroes_unmap_sectors for stacking drivers
Message-Id: <175811887192.378805.895284774096542580.b4-ty@kernel.dk>
Date: Wed, 17 Sep 2025 08:21:11 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Wed, 10 Sep 2025 19:11:05 +0800, Zhang Yi wrote:
> Changes since v1:
>  - Improve commit messages in patch 1 by adding a simple reproduction
>    case as Paul suggested and explaining the implementation differences
>    between RAID 0 and RAID 1/10/5, no code changes.
> 
> v1: https://lore.kernel.org/linux-block/20250825083320.797165-1-yi.zhang@huaweicloud.com/
> 
> [...]

Applied, thanks!

[2/2] drbd: init queue_limits->max_hw_wzeroes_unmap_sectors parameter
      commit: 027a7a9c07d0d759ab496a7509990aa33a4b689c

Best regards,
-- 
Jens Axboe



