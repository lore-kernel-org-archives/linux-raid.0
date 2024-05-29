Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56E91D531;
	Wed, 29 May 2024 06:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716962993; cv=none; b=UR0pr7poncuPN5FTcAXi92pwbaPoPb8IZNPbcrLkISFwI+W3APUUSCQWWVX5PZy/sTg8cw4Q66mje8VYhvJhlxiHl6eWk0/bnCpQYYm1wFabTvtgqyb0Jf7TqRMLBROWbXHlVh8CaJg8uoRF1vPD3G7WYeDdkj4zzP7NQMP+7WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716962993; c=relaxed/simple;
	bh=cS3mOSWOwnCsXFDAlr/R0hdrwPsnVMvOAeC9MB0iJnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A18/m2MpQupScMQFTAyS8lqjgQuVSPLlOb6j+WLMuj9Cfk8ASXG8+Wg8w8C8SntwlgpTH+V2H7FKINmFbaUx2NBdvFSiIZpLWlARrezyt8HNFEQMZpPoKl5/jW8Jpzi/Ge4jHMSrpdJjhpDW0jYEK/tNKOu7IR9QteR/agvQ09M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PbIxQ4aP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PbIxQ4aP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iQFKXiRuggval0rDYcI/GE9lXQV3wEyAb9C3A1xxaNs=; b=PbIxQ4aPnLnt1ABs9RK1C2ufQv
	qIhOzOw79eUYZ7KglvZg6wNHlr6YFPWncUATvf/zBzJtR/VBLyFm7fwyFbs7AlHxCxuHY5RJITNoR
	1UpOgAqNh16VDI47ww/B5EFf/rxpTDRU+MlygczKk+khGO76Ueza0MesS9NBkyqvITm85lNPItd/G
	PH3gTqo5gOKrzMwWhaPnyiy2zxdAZezsa8ca+klke7oA4kwryBB5GhjNuBLByHBMSgK6OvScfzjoU
	bxo+66+yrBoyQQxKYuc5HzIf8h/RQT/lxPDBDACq8wiWzQPJ8ZCR43A0fx5O0m65ejJSQaxkerZAS
	FK9k+iYQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCCVR-00000002y0c-3hOw;
	Wed, 29 May 2024 06:09:49 +0000
Date: Tue, 28 May 2024 23:09:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Li Nan <linan666@huaweicloud.com>, song@kernel.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v2] md: make md_flush_request() more readable
Message-ID: <ZlbGrdbnVRk_JYp5@infradead.org>
References: <20240528203149.2383260-1-linan666@huaweicloud.com>
 <ZlXa5mFl9x4Lk4KQ@infradead.org>
 <bc582a25-2124-2aa8-f26b-94fd5a50f900@huaweicloud.com>
 <ZlbAo1XgsPAxQ2Qe@infradead.org>
 <dc394cf0-337d-a216-2fb2-8813e4c82575@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc394cf0-337d-a216-2fb2-8813e4c82575@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, May 29, 2024 at 02:08:20PM +0800, Yu Kuai wrote:
> 
> submit_bio_noacct
>  if (op_is_flush(bio->bi_opf))
>   if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
>    if (!bio_sectors(bio))
>     bio_endio(bio);
> 
> Or will the bi_size to be less than one sector?

bi_size is always aligned to the sector size except for passthrough
command.  So the two versions are 100% equivalent.  bio_sectors just
does a useless shift (which the compiler hopefully optimizes away)

