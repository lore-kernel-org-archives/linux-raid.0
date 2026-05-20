Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8848337186A
	for <linux-raid@vger.kernel.org>; Wed, 20 May 2026 11:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779278219; cv=none; b=Bzsx6vJobBbaQb0N2zZI2w86zjBhf624i5cwjCeWE1i0W3lSqtHEGtgr0wdFOIt0FO5ZZQxqEwTiv+/w8Ybrx5pr8J/DZ7YwMXCjiTrrNPkfsj8WwbkRZLc64Z5tnUbrOhXCuSj7Sem21CP1g/9oeNEdi2KJSb2k1DcwuUcIquk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779278219; c=relaxed/simple;
	bh=bfxGorDe48GupWSTVui9vLOuTMtnHKiPipC2lS73SxI=;
	h=Cc:From:Date:Mime-Version:Subject:To:Message-Id:Content-Type:
	 References:In-Reply-To; b=kow1b5vfgEFB8fUUHc5UxgVqSchtXsyyu9HgqVeGRty+usoPfz7urnnsrKnhntHGJVbB+idNtRnbxVk7MJpoyZqlAnieeVDCQ/NbSX8PKuY+zuF2X4uxnoYnwR2Jl+/tlx3olE8qfSesUHMKJ8tapiUwieVbqHNHbg9v9uP+6bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=gQn/enHl; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="gQn/enHl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779278213;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=75zN7mSI/6DDgfWgyo8caYiYHedVezoArFhF9g22Y3g=;
 b=gQn/enHlmQxZVPZMHtdeK1xF1mh+7P03sFljHKWFnDHgoJBK8ECVD7y7PAmQ4A5wdsHL4V
 dtcKC+fmdKQcgurAm7qe+YHqzAF2yDkpUgW9Il1/MGcP/Bc4HMCNFJo/STKQSohGBF6IW7
 DmSjVrs9WMfGgHxgFbnBTeXBlGb+S/spD1UeYFSe85IBmcl2xS60eAZhT0KNmBsSn22lDT
 so/pebXC24TTq/4n8Lg1HChoxtrvxNEY6zRPS6I9l7NFcpzp2jvDUziDidd/BGSAIUt6db
 bx1j6/TbrlM6AinQd+osZZW7t8vyxoTqeXXg8405Cf7VD4RPwnRGBoCgRSrLnQ==
Reply-To: yukuai@fygo.io
Cc: <linux-raid@vger.kernel.org>, <linux-nvme@lists.infradead.org>, 
	<kmodukuri@nvidia.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.188]) by smtp.feishu.cn with ESMTPS; Wed, 20 May 2026 19:56:50 +0800
Date: Wed, 20 May 2026 19:56:48 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Language: en-US
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a0da183+6254d8+vger.kernel.org+yukuai@fnnas.com>
Subject: Re: [PATCH V3 2/3] md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device
X-Original-From: Yu Kuai <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
To: "Chaitanya Kulkarni" <kch@nvidia.com>, <song@kernel.org>, 
	<yukuai@fnnas.com>, <linan122@huawei.com>, <kbusch@kernel.org>, 
	<axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>
Message-Id: <c54cde9a-d76c-4e57-ac26-8f3e2248a7e9@fygo.io>
Content-Type: text/plain; charset=UTF-8
References: <20260416212633.72650-1-kch@nvidia.com> <20260416212633.72650-3-kch@nvidia.com>
In-Reply-To: <20260416212633.72650-3-kch@nvidia.com>

=E5=9C=A8 2026/4/17 5:26, Chaitanya Kulkarni =E5=86=99=E9=81=93:

> From: Kiran Kumar Modukuri<kmodukuri@nvidia.com>
>
> MD RAID does not propagate BLK_FEAT_PCI_P2PDMA from member devices to
> the RAID device, preventing peer-to-peer DMA through the RAID layer even
> when all underlying devices support it.
>
> Enable BLK_FEAT_PCI_P2PDMA unconditionally in raid0, raid1 and raid10
> personalities during queue limits setup.  blk_stack_limits() clears it
> automatically if any member device lacks support, consistent with how
> BLK_FEAT_NOWAIT and BLK_FEAT_POLL are handled in the block core.
>
> Parity RAID personalities (raid4/5/6) are excluded because they require
> CPU access to data pages for parity computation, which is incompatible
> with P2P mappings.
>
> Tested with RAID0/1/10 arrays containing multiple NVMe devices with
> P2PDMA support, confirming that peer-to-peer transfers work correctly
> through the RAID layer.
>
> Signed-off-by: Kiran Kumar Modukuri<kmodukuri@nvidia.com>
> Signed-off-by: Chaitanya Kulkarni<kch@nvidia.com>
> ---
>   drivers/md/raid0.c  | 1 +
>   drivers/md/raid1.c  | 1 +
>   drivers/md/raid10.c | 1 +
>   3 files changed, 3 insertions(+)

Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thansk,
Kuai
