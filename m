Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB7D2EA73F;
	Thu, 21 Aug 2025 08:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755765825; cv=none; b=lXqT6rNRn4SdMEXTbyLmauPamwvscVwKssfAKw+nT84taTkqvuv+htjkbWiIdoiZLbgLO/M0vtKrFANk0fpH8nE/A0ZwIdH6qZuleDX3ua8xxhE8wCdhcwxxDhBk3aguoARRRjyVmNqK6zudXxjNXU9N5sv4PU3l2qSchBmnilE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755765825; c=relaxed/simple;
	bh=xz2QDVMW2//ZXMgaL/nvpdLjNADQbMTtSoAjowyUmLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kWWX9tcb1M9jPhuntDTEH/C/VL2l3GmCngIxZMLUixfp0wDunIUmGGyKaXP7FZ26QyY4DaCmWWLuvRp2AnwNyqpDq/goB7zTbP2Aczwtfjfo4unjdNt9tLwlQjLUcibaG4RDNrUKkPcXTdvQRqDZcE7pQbm4mYqOA1/HnCkVzq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qCQuRWw2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qCQuRWw2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DH0T/wVqGIUrA7DRyv7+vAYFqL3H3OPlMVniGSHn7b4=; b=qCQuRWw2nhD1tDO2X+/gUmaxbK
	iqJVgttsy6MqvS9n3I3phJStiZvC0ts+s+lPfgGjUtK0Aqf6IfmPY7tga6h3fh+iVYRN3dBJuiZD4
	6MIftmAcA4z1Pk5go0VqYq2uyyr6JfZikg/qwDK4w7R2lqeTGjxP+bQmns8fkLeHuE3Ewa9q/Rgy4
	linqJZeBU6tUSh8+vYdG9uAgZuwXlCaMDCRSUHH/3h2cGb3DDiWv+mfjV1rml6aTIyIQbcBvvyZI6
	I4Uhc/aEFdLqegc1kCJKR4DGbHrgtr5hm56eyNR9Z6Aq7RgPuuhJx8TjRaCQOlvKViBeOnyhu2q2i
	vcp00v5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1up0tP-0000000GIHr-3M2u;
	Thu, 21 Aug 2025 08:43:31 +0000
Date: Thu, 21 Aug 2025 01:43:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, neil@brown.name, akpm@linux-foundation.org,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, colyli@kernel.org, xni@redhat.com,
	yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: Re: [PATCH] block: fix disordered IO in the case recursive split
Message-ID: <aKbcM1XDEGeay6An@infradead.org>
References: <20250821074707.2604640-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821074707.2604640-1-yukuai1@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 21, 2025 at 03:47:06PM +0800, Yu Kuai wrote:
> +	if (current->bio_list) {
> +		if (bio_flagged(bio, BIO_CHAIN))
> +			bio_list_add_head(&current->bio_list[0], bio);
> +		else
> +			bio_list_add(&current->bio_list[0], bio);
> +	} else if (!bdev_test_flag(bio->bi_bdev, BD_HAS_SUBMIT_BIO)) {

This breaks all the code the already chains the right way around,
and there's quite a bit of that (speaking as someone who created a few
instances).

So instead fix your submitter to chain the right way instead.

