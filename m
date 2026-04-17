Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523A735DA67
	for <linux-raid@vger.kernel.org>; Fri, 17 Apr 2026 07:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776412405; cv=none; b=CB2mjhIlL/vlLempARpDhE4F/lgVhaOeaOyB3baCshym8d64I1tyelNTaiy4FJpXmyirJyzVJvVjkIBc4r1yUg3eabwuDl8ajAYbPhiHFZuc/BI96f0DdmYl4CaHwdVFS5yhzxj0QYbXGWY5Tc3fy3tvkRJUrHNho6lNV/CxEkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776412405; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mln0e+UpjwVJHMY+jcJsInZGyNGdElc4keg9adMYkCBr9j8p9oSR/xgf/6BZeMDQNamVHZ2quNBH94xUVDO2tXN/q0xy5hmJFMhgE9BsdfNE4/5Gp4beCbuDcGffi6ljTbvdjwPZO263kf9wg5R4a+mIOYE35OmMkjiy2NOfjWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 723F168C7B; Fri, 17 Apr 2026 09:53:13 +0200 (CEST)
Date: Fri, 17 Apr 2026 09:53:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
	kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	kmodukuri@nvidia.com
Subject: Re: [PATCH V3 2/3] md: propagate BLK_FEAT_PCI_P2PDMA from member
 devices to RAID device
Message-ID: <20260417075313.GB31524@lst.de>
References: <20260416212633.72650-1-kch@nvidia.com> <20260416212633.72650-3-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416212633.72650-3-kch@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

