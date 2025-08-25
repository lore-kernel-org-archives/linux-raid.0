Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEACE2BE62B;
	Mon, 25 Aug 2025 09:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756113347; cv=none; b=grjj2GEe4FdY9OGBmIzlvNqHYCam1bLnv+waYyKKO5Q7yEi4qwmlfCDjeYogVcWYIMFedJIDLwGzw3x3S94GCiOBdAlP+Rfezkv0zeM+p8mCQ6NFIFeQZQPb+aG7GqTKVShUo8ZEUPJCKXYJWpWFw5HDOYW2IVTKdVamw3Ii3lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756113347; c=relaxed/simple;
	bh=hkMEJhZ+IhlFsBgGxXEJNCRhVzgLK8LNLV7uLt3mMaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sRrOHDPHsTEKC4JYE5CPDkZDrVrpJBY9ag8IoWmnotWiskoT7bTm1diVgDb4dqnoCYysQb6ZPAw3WpeaaneOHMAjWyLRS2WmZf+4EsZVwHOfDhubAdvnL6F2WPgT+QTJNOtr5WzkliARkktiF7HZBB41W16PomYFUHWiyUXqpjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZeFpGGCw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZeFpGGCw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=chd5c/KEnH8eMkFrA+AmkvvEx/MXJwt14HKMO25OPbA=; b=ZeFpGGCwvD6T7yEDj7w1eJcal+
	AZl5DREZvjjjKr53hrty0CrqJJmSsmS5Qiks/tNLA89VHl4R7NsFcXIJmzBMSAnXsypsfEjsVfwPK
	mnBhBQpK+YwuqrD/gSBh6KPzWlotPUapOsTydjo5E4KspRyt0U/zoRMNXtand7viudBKzIhn9TBHr
	vypTM1Is7PSSD1WjknvApsV4M4vgI9/d5IYfkwy4lip7Hv+rIGdoyllW8NBzAPldxziClCJZdc0pL
	s4O7kV9mWqoDO2jjAcSsG+Hbr2h48hiyVQEFpf855f2DQQ5EcdeqOCRabYIYlTqGBM1k1AGQ+qnUt
	DH26zr9g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqTIj-00000007SgR-1jms;
	Mon, 25 Aug 2025 09:15:41 +0000
Date: Mon, 25 Aug 2025 02:15:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, neil@brown.name,
	akpm@linux-foundation.org, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	colyli@kernel.org, xni@redhat.com, yi.zhang@huawei.com,
	yangerkun@huawei.com, johnny.chenyi@huawei.com, tieren@fnnas.com,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH] block: fix disordered IO in the case recursive split
Message-ID: <aKwpvfDLgeNaGjnF@infradead.org>
References: <20250821074707.2604640-1-yukuai1@huaweicloud.com>
 <aKbcM1XDEGeay6An@infradead.org>
 <54fc027f-f4dc-0412-0d6d-b44a3e644c39@huaweicloud.com>
 <aKbgqoF0UN4_FbXO@infradead.org>
 <060396d7-797e-b876-9945-1dc9c8cbf2b4@huaweicloud.com>
 <510600c4-5ff3-a02e-de6d-020fad771425@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510600c4-5ff3-a02e-de6d-020fad771425@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 25, 2025 at 02:15:49PM +0800, Yu Kuai wrote:
> > be resubmitted to current->bio_list, hence this patch won't break this
> > case, right?
> 
> And xfs_rw_bdev() is not under submit_bio() context, current->bio_list
> is still NULL, means xfs_rw_bdev() is submitting bio one by one in the
> right lba order, the bio recursive handling is not related in this case.

Yes, usually not - unless we somehow eventually get the loop device
out a separate workque context.

