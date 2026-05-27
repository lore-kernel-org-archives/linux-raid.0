Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076C236F8E7;
	Wed, 27 May 2026 06:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779863904; cv=none; b=GMROi1/UecGPrqiV0U6J5ZFdXhoun38bqHzLd7GNUcqe2QW0TrNeAOARH7/wi9abVBDaaeqKi4k9+jYF7JgjRH+1sG+dLKE8zmuAuKsur6HtM5ZWif7mUYJ3koH0VlWwR6aHq7jCOuPIVpu7G4kok+aMgZCUvHDI1ywq55av/2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779863904; c=relaxed/simple;
	bh=CCn6lVlHDLNUlUsN/Lvb11P/Dz1l2RIV5PPFn5iDXJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=um8BjEFWsPwlcFA9nituUw+EdQSM7e9wyCbgaSV1gY9YX45rBpMXuBxCL7MBfMqCmcjnsIqljQua5744h/c2CsFImDGKL3SYMCbcbLgGOIXjUqr3TxN/RmX4JtwTinru6UnxRzHdRvvYCdX/8FuO2Sngr3A6hA2V6cBPE+2+8PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 47D3D68C4E; Wed, 27 May 2026 08:38:15 +0200 (CEST)
Date: Wed, 27 May 2026 08:38:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/2] lib/raid6: use kvmalloc() in raid6_select_algo()
Message-ID: <20260527063814.GA17042@lst.de>
References: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org> <20260526-lib-v2-2-ca3f0fc24b14@kernel.org> <20260526103424.0d884374dee8cbc4f9f17c3a@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526103424.0d884374dee8cbc4f9f17c3a@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, May 26, 2026 at 10:34:24AM -0700, Andrew Morton wrote:
>  	/* prepare the buffer and fill it circularly with gfmul table */
> -	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
> +	disk_ptr = kvmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);

This changes to vmalloc for no good reason.  It also doesn't use
the _array version for overflow-safe multiplying (not that it matters
much here..)

