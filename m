Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4459935DA76
	for <linux-raid@vger.kernel.org>; Fri, 17 Apr 2026 07:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776412414; cv=none; b=Kmn7yy2yw1HVv3coZDuTltXMeJ2L7m9MDfvlET+icCvV9lFBZO1+pIu5MfEQ46uC1fKOfKD8l+P4cFlk/lZ6ihAllcR6AjnaZMgSt+vnNLBDRm9s5yoPnZ77N1PlscwNZ4kBv4w/FlHZaN3tq/qW9jMMVPVd0B80yS/n+lODQQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776412414; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nf1VUVDQUGhkS2SMUcS2gRjjG5aIQvGOmclCWPVhFQqIT5Fn9ghOA4gC/3mrGMySO654EA/xASLKPeU5PCH1D31f3OUtrta2UfQthKvnpoup0BQRx2UyvvhE0nRTQ3AdsYSDVdE2g0rthWsG77TkIy+OqkU0eyt7wRPmRzxgSBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 64C4E68C7B; Fri, 17 Apr 2026 09:53:27 +0200 (CEST)
Date: Fri, 17 Apr 2026 09:53:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
	kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	kmodukuri@nvidia.com
Subject: Re: [PATCH V3 3/3] nvme-multipath: enable PCI P2PDMA for multipath
 devices
Message-ID: <20260417075327.GC31524@lst.de>
References: <20260416212633.72650-1-kch@nvidia.com> <20260416212633.72650-4-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416212633.72650-4-kch@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

