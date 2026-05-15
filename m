Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDDB3D0903;
	Fri, 15 May 2026 04:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778819741; cv=none; b=T3wdkPtpFs5o6DMsqgrHeVkXicbzSh7nYEBlKTHndbg/5GVPiOqb8DV85+njnkYL4LZI+TOAPJ8aeuAfgPq9A3iYo+JeFWO6GGldDFSFEKIKDREC5p9ev5xFxeMnQX+PVqobQdDObdcRL3B+f8jK5qhQHljmcMB9x0jSQz57Cv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778819741; c=relaxed/simple;
	bh=ae7wFLoOHSnbM/McJge8aIEZ5M6Q6C3H0xORl5Z7iVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BzxJVONSomzFT8Om2crXfPPT2MXn4NT9PaN9+xw0sAHuUw4kyxhXYjnk4H4Dz7as2PRg3uVWL7wgCgYRRLtkP0HMVC2jxa37nP7Gx3pGf32XLFael3OHv4EusTi01qofsPAxubFEQqerm5Zg8PcEogUxt6z94eLpJuOxR7A5KSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CEE9C6732A; Fri, 15 May 2026 06:35:35 +0200 (CEST)
Date: Fri, 15 May 2026 06:35:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
	kbusch@kernel.org, axboe@kernel.dk, sagi@grimberg.me,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org, kmodukuri@nvidia.com
Subject: Re: [PATCH V4 0/3] md/nvme: Enable PCI P2PDMA support for RAID0
 and NVMe Multipath
Message-ID: <20260515043535.GB3756@lst.de>
References: <20260513185153.95552-1-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513185153.95552-1-kch@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Still looks good to me as per the reviews.

