Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803503C5856
	for <linux-raid@vger.kernel.org>; Tue, 26 May 2026 21:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779832358; cv=none; b=niYpXY0MHMr7LlOmeYn+QNFI96KWUBQu2gbM7xW2y8F0gs8n+gQ2QA8+aeK7z/rMuZg8MAi+zE+inqLgxz9F+W60Hwowl3+x1wbhbSehgMCyU+/DGff3ixhdT9ZJl3tYRLNlOtgGA2nsp01aTXSb3XySZIKghq3/QCCbFFPQLLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779832358; c=relaxed/simple;
	bh=4NrTmsYwJJmQ5/ng8nsl+5S2O34t8HzC26mJd+ruPNg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fm+CuPLLFb36uWbUGY6wsZxEkR52VM2r3Z3pGXAmcr71+ngsnNHCNyZBx1LxKuMI5gh51JZcHjm5i+l7ZcNY/mZyiM2YO7uKGxA6N5VadjRakr00yswtPWkiYIzzCCeCoTw5b8If0XWgypOixThcSZwYnJYR3Dg6Mw40JjLccd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=w9IdnVFl; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="w9IdnVFl"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-43b8a96ff5eso2480115fac.2
        for <linux-raid@vger.kernel.org>; Tue, 26 May 2026 14:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779832349; x=1780437149; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ygleTelCqI5oqapwk6Og8dhDrlXNgz7gDtcSwArrBbE=;
        b=w9IdnVFlWMtWJOQvUeXQp8ZP69zopJWnlfVQz5qR5vF2OVlPyXk222oWHWzxPBEtVN
         g02xQQr1PzMGpEcvaSAvW1fxbf5S/f7gUiMjEo3bfIStgyT73uFTtWeIuHvpvW0UovSm
         4AdLAME3Wo1H3vFDOY6dTnapYdASLFN/MmSOX7wt0fH5ZB+gey7DpJjBotICiDcSWLUB
         /UaoW5+GU9aNv1T02Ktml72uh28ET053FbcaH7IFQCjOW6fFRC47NSC9HlO3qrmNHmmg
         Z367Q5NAT5vUmUhHwqvezl0tlvlmtmRJGh4bXtYk6ZEW1DgDFqU0KpaV1z1grEaKLmJu
         4T1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779832349; x=1780437149;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ygleTelCqI5oqapwk6Og8dhDrlXNgz7gDtcSwArrBbE=;
        b=UFrFnPKEpdxxhBwi/8mkVQYaNA3+REgr339qeD8Tok9ptt+0MacYILNBQREQYEtn+4
         evgg5R664pZhQxKQGWJJ9usFAMG87dbRPDJF1tgxwo5jHtN757Oni8CDszQ+Z3gnPejK
         bV5hlidwgdh0upOLMve3OfJctgVdtzPc/eUjSeTIV+tSa9fR5loaT3Um7c1TxhHTtSQv
         1wZwDU46be8pAo9YYXGRbTtAyfW4Z3NNO6hTiLUGh9UFWrdWmBUFWz4WQ5v2Y2voYteM
         IeyisfAIZUSxAzixUqkXwOpa5V+fUXR/Ij19ZhxQ/SSNDxn+QLORN6A0xg6gBfuAHIei
         oeUw==
X-Forwarded-Encrypted: i=1; AFNElJ8BbcBNdzQi8ekdT4nGhiCzc9P8XKtlLpf/TyPgiaWw+kh9AgcZT1/e7XCyrI3XEcLhdV9jjM4n40zD@vger.kernel.org
X-Gm-Message-State: AOJu0YwiXVlfR0EALS+suPorfOuj9uV5JGW3fMP4++ZONhSPIzcIyZ2X
	OU7ercawhCJWbzaDWmeUc0ZV7FZyWlnzQkpxwtH4i4bjoOuk6y0ze+NXtSnhfG8kIm0Q5osfzip
	CDKvwCts=
X-Gm-Gg: Acq92OFocyOYT2i/bjXWOXSxoniJp/NDUE3xO3NYwo9zEgWeB6LfVttO15WjS7MhAvv
	YkqKYbQp5TivPqzjiBJ7uStollzAWjwcl1gxoEkv1BNrPHq+4l+9c8Rlav+63/b6qaKbrPmzeCP
	ILXqIGCIHFCT3GIeAvvO/AAohmtvw2PIu8OIYh6Ru5jgLeZRIczgmZ5EckyzUkjT6MqrOeuRjj8
	Aea973sQ6ah7Rs7FqU1GgMQWs3yHw+b7JTTcjMdVfDPHJ69xZn98IecmKL9DvyX/kSuWeby5PA3
	6eSt0sGxJVBVUwRDNdVQCBqTKuuSWcCNa7ZeTY8neUHvcP5DffounThUIYSIP1cHukSZBxtnrIb
	9y5ocw5Ki/J7C+q/BOD6HKhNuzfWwQF7Rue9dtWVN9pfbm3qzPy9anKpCLQHmPEXg+Cca24XIcO
	FdbIT4IjdiDB8ru8hbVxNyrfbw+r/BzZTkfzWGyX97dAIOy3E+FrHsa21jiuckhtZGwJXVGt3xb
	K+N1/bf3SVFrg==
X-Received: by 2002:a05:6870:88a0:b0:42f:c1ea:f19d with SMTP id 586e51a60fabf-43b5aacfaefmr11826864fac.10.1779832349406;
        Tue, 26 May 2026 14:52:29 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b639725a5sm14453746fac.10.2026.05.26.14.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 14:52:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com, 
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, 
 Chaitanya Kulkarni <kch@nvidia.com>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-nvme@lists.infradead.org, kmodukuri@nvidia.com
In-Reply-To: <20260513185153.95552-1-kch@nvidia.com>
References: <20260513185153.95552-1-kch@nvidia.com>
Subject: Re: [PATCH V4 0/3] md/nvme: Enable PCI P2PDMA support for RAID0
 and NVMe Multipath
Message-Id: <177983234828.663325.17778666619930426072.b4-ty@b4>
Date: Tue, 26 May 2026 15:52:28 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Wed, 13 May 2026 11:51:50 -0700, Chaitanya Kulkarni wrote:
> This patch series extends PCI peer-to-peer DMA (P2PDMA) support to enable
> direct data transfers between PCIe devices through RAID and NVMe multipath
> block layers.
> 
> Current Linux kernel P2PDMA infrastructure supports direct peer-to-peer
> transfers, but this support is not propagated through certain storage
> stacks like MD RAID and NVMe multipath. This adds two patches for
> MD RAID 0/1/10 and NVMe to propogate P2PDMA support through the
> storage stack.
> 
> [...]

Applied, thanks!

[1/3] block: clear BLK_FEAT_PCI_P2PDMA in blk_stack_limits() for non-supporting devices
      commit: 7882834048f110931275357db60dccff906dc96a
[2/3] md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device
      commit: 02666132403aec8fc5de315002894f713ef17dbc
[3/3] nvme-multipath: enable PCI P2PDMA for multipath devices
      commit: fb0eeeed91f3236133383445fee5cc8f20330e6e

Best regards,
-- 
Jens Axboe



