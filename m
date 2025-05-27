Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C1B2F2F;
	Tue, 27 May 2025 08:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748334557; cv=none; b=GSzEfF65FBl/Afz0bDYfgnC69NE0kXXqdrlyARWSgGy78khIj3QyiXjd64ahhKQEF2raEtbCcHOb9QvkYgNiNpdj/zhoL/ukKwa+nGRfmeHgwnPHqWmWdyxctvqcOo/qWFql3ZpUpzWaLem758gJq6mFc7PTSxSxucEGHGtAOwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748334557; c=relaxed/simple;
	bh=BdXMEgcy9rY0zaxdi69jm1pF/Pmw19r1TAJ8p6m0z2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9nFNwrq7brlX6H52Xs34HB3CRIzB5OUVQHTsaoFUc9P/weXRulmRdwr113XJ3qoOt7qb0q7ugL3GhYV0A1kX9Tb6ZnnYAAOwSLxpIt7zOwk1FyLjjMXrIM/JXMLXQIKySp/xnipnbvakc30CcI5Cqikgehh+u6PFn9k8S003zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA06E67373; Tue, 27 May 2025 10:29:11 +0200 (CEST)
Date: Tue, 27 May 2025 10:29:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, song@kernel.org,
	yukuai3@huawei.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 23/23] md/md-llbitmap: add Kconfig
Message-ID: <20250527082911.GB32108@lst.de>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-24-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250524061320.370630-24-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, May 24, 2025 at 02:13:20PM +0800, Yu Kuai wrote:
>  	MD_PERSONALITY = 0,
>  	MD_CLUSTER,
> -	MD_BITMAP, /* TODO */
> +	MD_BITMAP,
>  };
>  
>  enum md_submodule_id {
> @@ -39,7 +39,7 @@ enum md_submodule_id {
>  	ID_RAID10	= 10,
>  	ID_CLUSTER,
>  	ID_BITMAP,
> -	ID_LLBITMAP,	/* TODO */
> +	ID_LLBITMAP,

Please just drop the TODO annotation from the initial patch.

