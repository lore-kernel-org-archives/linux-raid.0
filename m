Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A96F2576;
	Mon, 12 May 2025 04:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747025720; cv=none; b=ePOZlbvEigvK+h2QZnBI+TDsGVbmjqILtuKJj3ZucM1VL1cOKPYIyhl8UaNH/CpGS9kIBdVADxu04RFQPRX+0TtFD0o+RMKt+SsdLR87SlJk8eobuC3Fn2gLrTsHu0DTSVQMHC/C9OfVprZVkwADRBzltMD8BsyOLJHcL8XXMWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747025720; c=relaxed/simple;
	bh=FbVLm8YO5siWQNVRJw0xf5O1P1qFxSqSIuicHSt+ZTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WVe/ZyO38U4fT8LO12EXSZYMwQUYvCXmTW5Zu6etjOGNWohyGxbpHYw3GZZsnX/t0tP2nDOMQyIsTUBcTYCsxxzDOsPfiYs6oz+G3wcdO/5Vw0To70JGuFFC+TPBBFd+kkuPvmn5Af679+AZofxRwrvs/K8NjTvxWcfdkAm+4QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B804868AA6; Mon, 12 May 2025 06:55:11 +0200 (CEST)
Date: Mon, 12 May 2025 06:55:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH RFC md-6.16 v3 06/19] md: add a new parameter 'offset'
 to md_super_write()
Message-ID: <20250512045511.GF868@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-7-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512011927.2809400-7-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 09:19:14AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> The parameter is always set to 0 for now, following patches will use
> this helper to write llbitmap to underlying disks, allow writing
> dirty sectors instead of the whole page.

Givne that there is nothing super-block specific in md_super_write,
maybe use the chance to rename it?

