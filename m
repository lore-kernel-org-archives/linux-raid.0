Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EE5199B9;
	Wed, 30 Oct 2024 13:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730296048; cv=none; b=bZ3xCZzDJMJTHYJDhOkj2I8DPNhZHEZcx8s+U+vCZfbbFac++h64Mm+z8JpRZsX6mUQ3qdxtIHor69J5mgkH8/cEAft1/rTVcjV65KlkTX+wHtRsOA+y2UGRNqxUc+VHuq/hfbQJ3e1hNlLsgA/cG4EKN6nKyvhAJK86jl7A6D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730296048; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nBAsRMrTif7j7fyNqw3HuFGh5WsK3Wjvp6gnHZsEiKVtR2mlh3jDnCpHPmaZQZyaDPvUVDR18yjiRW1KyvHtABVEW+SlEyPb5wOmCUStFYpB4zYknEp4rzqoBmBeLTrQJrzguM9sz+9RhiRjv1pI6CP53ZlsYwvcpn5nTcxbtpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A9B95227AAE; Wed, 30 Oct 2024 14:47:22 +0100 (CET)
Date: Wed, 30 Oct 2024 14:47:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH v2 1/5] block: Add extra checks in
 blk_validate_atomic_write_limits()
Message-ID: <20241030134722.GB27762@lst.de>
References: <20241030094912.3960234-1-john.g.garry@oracle.com> <20241030094912.3960234-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030094912.3960234-2-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

