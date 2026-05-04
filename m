Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BBF3DDDA1
	for <linux-raid@vger.kernel.org>; Mon,  4 May 2026 21:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777929952; cv=none; b=qBpGJc9U/7//viGblV3yJsO9iZ1VQi84WQi1HTrs9h98kjwmApGhOzN2pI3dLgg8NJmY8tCjtKds6nUUX5JhZfwMhbeRBWKXGHNWZ1+LotxISFLd+LHS6oyFsjy8lt/GlhcCFp5eHttDaVIMrqXcprqbC1aOLHPleCSMHc6LNzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777929952; c=relaxed/simple;
	bh=hccEVS5c9/Z+UzLn4rYGGfEAemcCmsompAhGx5uqefE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uP92FPiS9sEy6bL/ykSD2G8woBQPz4uqtIoSyxNvc/ciea1pfLZYxGJJNa5ob2QygfMDnc9DVGZU2KyOy4dhadBiJxR2IlauUeidbDQjycl8cIrgtcTnzSK3z/8Y5iDK66SOS29aawh0V1rMk4nqtWbPOBpmrbJn5NAyXZ7vZtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j+TGBGAT; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j+TGBGAT"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b46da8c48eso13065ad.1
        for <linux-raid@vger.kernel.org>; Mon, 04 May 2026 14:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777929949; x=1778534749; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0/8EmIfUXkK4i6WQDdd5nq5pu0xAfgin2bGfz4H6FIo=;
        b=j+TGBGATIOjn1rvyR05bDsRv0Ho4tefNgop/W8qUwEQahMTE0WiHMZJ7s23DRY8srx
         EZPL4yf2on2M9H3SZvLFQx+A80HLoC+8EVNX9qJokCPEmElExexLxQJDl5ZVDlerZdAQ
         vTbi5B/o8IznI0JwKetb3Y4BthfN+XVIj4GO6nWXryZL6CQgEBUXHVgB6psHH9Aqe6ZL
         uNiy/svxQfWcIyM5fpUUFABCDDUK/DZEjX8vxJ/eJoCcpyT55p1dYKgxxlMpJq5/Jv3p
         tJjDAZHgxeWFeDja7hD1CuuCLX9xH2rGTyXfniPwczt7bH4iLPeULAW3gPJUKQYdLqir
         dUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777929949; x=1778534749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0/8EmIfUXkK4i6WQDdd5nq5pu0xAfgin2bGfz4H6FIo=;
        b=ZE5x3cCs+kxDSXufl17qBuZLnifL7hGX6NDWTf7X3Y/oIK0q8adcjy4s1ZcuDSIkTh
         vvSpKGIAwyDEX9npy84rBGf/I9iLs08ZWENkS4ocKPGAYAwSu/pLqBl2dgbjeGhGiU87
         5d0R6DNGUvtpiAqDcQ/HFj/G4kQVNUCIQX4T5db6pINEW2uWAK1C375pUybYcNJ6haLE
         ToEo39KVdYn2RrTOtsHBwhsJZA7s7Goy+gqSPIKQDlo+CU3r/hZpc4OUnEitO8JgL7vp
         mQUJVxD9xVXS0JV71n2kZ7Rp73+62ITgcMmNcWBQB+KYzmLo2DkCJCXWsMB7DDoEIYgk
         8PTQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Eo8T96ONI3gZJHtDbDg7KCt890urHuE8JWIGhas6nq8KHlR987DaYkM73ZODEE2re+nCPZNnA/ohJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx70rCF6OUOwvoNkbOi76v5gVqmEtmRaWvHGg2HiBodBE+iwulC
	UbABX6uL6opQjqEqfcMAPii0SPfGgO1xB6ZA1xdr9pteakUCyPaKyoO/QXh177woQI+ihHaY6p5
	6MqQt+w==
X-Gm-Gg: AeBDievscQQ+vmVy3IwUPiRRjpGun8zKJFevGrqpuSo9hop4A7NlCYBE7pAMR8SJzOB
	N0jO924VwgzKIBjFSJl785TWVwNzCkMKxUkRv3u+xDIh7lXkHRSMBdZ0UU8G2C9tjECnuo6BCNK
	oTboBCg6yrni76kwd/Q8ByxVhCecHlV7d14X8pD3ieSgSE/mJzd65y6CtgvQYg+IiYDTYX7aM2v
	1K+jaWYyafnzRxQPmw9Sg2/KgRi6p+LQ4fgSnkp+icP2LiGnW+z6qoqG7lme/3pFEcCzfakbPbD
	2yXVIN4AdRJJgOBcfmQbPLVGv/8Jzn2+l5LZHweAbtCBUpMybm68Clevshpf5IL7fjzRxdgvBDR
	2e4Hs0KLk4RQn07Zx+1uP4M+5qTIajcoX8nWW2l3N/+4vMtnGV6ufHLLwZ6iGAMy1ix7OFYQdCy
	fQMZmD4+QAuBJeZd8Um3rhSzvP++tA4Hp1ib3vI6qIIEte/hpUW6uyRtWgqrSigwI2J1KARCatY
	JtkWR4=
X-Received: by 2002:a17:903:3d05:b0:2ba:dfa:328d with SMTP id d9443c01a7336-2ba530f0db5mr549245ad.1.1777929948029;
        Mon, 04 May 2026 14:25:48 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caa91671sm115257035ad.13.2026.05.04.14.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 14:25:47 -0700 (PDT)
Date: Mon, 4 May 2026 21:25:41 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
	kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	kmodukuri@nvidia.com
Subject: Re: [PATCH V3 0/2] md/nvme: Enable PCI P2PDMA support for RAID0 and
 NVMe Multipath
Message-ID: <afkO1WExGV9-jv8b@google.com>
References: <20260416212633.72650-1-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416212633.72650-1-kch@nvidia.com>

On Thu, Apr 16, 2026 at 02:26:30PM -0700, Chaitanya Kulkarni wrote:
> Hi,
> 
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
> All four test scenarios demonstrate that P2PDMA capabilities are correctly
> propagated through both the MD RAID layer (patch 1/2) and NVMe multipath
> layer (patch 2/2). Direct peer-to-peer transfers complete successfully with
> full data integrity verification, confirming that:
> 
> 1. RAID devices properly inherit P2PDMA capability from member devices
> 2. NVMe multipath devices correctly expose P2PDMA support
> 3. P2P memory buffers can be used for transfers involving both types
> 4. Data integrity is maintained across all transfer combinations
> 
> I've added the patch specific tests and blktest log as well at the end.
> 
> Repo:-
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git
> 
> Branch HEAD:-
> 
> commit 88a57e15861997dd6fa98154ad087f7831bbead1 (origin/for-next)
> Merge: 81a0a2e4e535 36446de0c30c
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Fri Apr 10 07:02:42 2026 -0600
> 
>     Merge branch 'for-7.1/block' into for-next
> 
>     * for-7.1/block:
>       ublk: fix tautological comparison warning in ublk_ctrl_reg_buf
> -ck
> 
> Changes from V2:-
> 
> 1. Unconditionally set the BLK_FEAT_PCI_P2PDMA for md and nvme multipath.
>    (Christoph)
> 2. Add a prep patch to diable BLK_FEAT_PCI_P2PDMA in the blk_stack_limit().
>    (christoph)
> 
> Changes from V1:-
> - Update patch 1 to explicitly support MD RAID 0/1/10.
> - Fix signoff chain order for patch 2.
> - Clear BLK_FEAT_PCI_P2PDMA in nvme_mpath_add_disk() when a newly
>   added path does not support it, to handle multipath across different
>   transports.
> - Add nvme multipath test log for mixed transport TCP and PCIe.
> 
> Chaitanya Kulkarni (1):
>   block: clear BLK_FEAT_PCI_P2PDMA in blk_stack_limits() for
>     non-supporting devices
> 
> Kiran Kumar Modukuri (2):
>   md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device
>   nvme-multipath: enable PCI P2PDMA for multipath devices
> 
>  block/blk-settings.c          | 2 ++
>  drivers/md/raid0.c            | 1 +
>  drivers/md/raid1.c            | 1 +
>  drivers/md/raid10.c           | 1 +
>  drivers/nvme/host/multipath.c | 2 +-
>  5 files changed, 6 insertions(+), 1 deletion(-)
> 

Tested with NVMe-oF (RDMA).

Tested=by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
