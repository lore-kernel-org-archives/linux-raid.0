Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A771DDC22;
	Mon, 26 May 2025 06:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748241183; cv=none; b=usyGL6isxRm+C69WTvdZUBhhIsWpqyjDdgMuhn+8xuZ8m2jLbYQtaBW3QnNZeN0VkVNhCYnvBu970vm/A5/r5Cf+KpohMFsLenmNDv7Jo8JpkDP+UaMUQhgHc9IN9elrkhuwi98oZTRPmlgl++ZdnjLczk7XO3PQTSIebZTVBi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748241183; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RfOOGR6Yobef3XTv+YdSc688Zz4RKhn+G/6esA7IYdjyMpF6Y0Bqfr6KNL7m1qjFiUxfOZXLZbbgffBNgUABnJVCG6ox9UGaVwnauvFf5UVcvonErjs2r1dJuo6dypgUEaBeUu0edcNbfJ8U4Gl1e45+qj5+6oLsxiqkb0ri8W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 54E5F68AFE; Mon, 26 May 2025 08:32:58 +0200 (CEST)
Date: Mon, 26 May 2025 08:32:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, song@kernel.org,
	yukuai3@huawei.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 07/23] md/md-bitmap: delay registration of bitmap_ops
 until creating bitmap
Message-ID: <20250526063258.GC12811@lst.de>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-8-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250524061320.370630-8-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

