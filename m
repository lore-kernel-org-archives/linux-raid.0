Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAAD2C159D;
	Mon, 25 Aug 2025 09:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756113435; cv=none; b=uNue0Z0sl6zR9CyhfvIQpShHmta2hBzBVrLfj3wbpeClwFUjEgNcSGh9VNc+e1GMmoWf530QCb1QrSZo+/r8z+S7dBvDXpqTT0xOmeVpRHDO9tYiiB4qbgwHUEWfz2+SYZ4FoEZRxFm5okJpI+s/O7nE8xAZFSJMzMqdf3cZKCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756113435; c=relaxed/simple;
	bh=Wn+Z4e/eyGL5ZJyM0Z35TAjutO4TFYoFh7Rgq+3AWdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lIyFDiLRJJz00DOWCfB9GT4HZMtUQ3i9X1I3UKrTJ/nY7faLalAHerqnI4v6fnvy2rtZQOxkP91Bf0jx0J2fqs27tWVoi9/9VY4XPJcxxfyF/GtgfgfiWGQEMBuLB4gHWbIFQeC2IQiUB6NsbLvkt+aIXW0InVX05eXiDg1cnqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ecp3JWL2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ecp3JWL2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QSOpiHvfx6/SVw3HLXrF9GepkDXKMd95Oqf1Q9zcAyw=; b=Ecp3JWL2xZ4kAjXe1xAYgnl+/B
	JK4ujQdpWmpHiA4KLCwwdIJVlKLSmZeNtA4cva3cidK3Plik8/sB0bpLksJFIVIwT0uJ3j64mLNAX
	LAdqcy0MQDO+/q6xRLoeSGOwX5TLEyJYYGjL6efDPyeBgkiZQMJe0YVwZ7KRqwL3xADNsxeEz2Hz2
	FWVdD9PRFS0PoveoPYB/YStdRkMDiVR9NECwvUPlty7OMr25z8sk7+Cmw0zKZ0d8SUJNRY4/8Sq0+
	APJdiT6DDHWbAiYzCRIx7V9J5dr4UEtkaY5CcHzE09O3XpGO7yTwyqXJBJMifC1kqVtr/Y67+b3Js
	wlcmh+QQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqTKD-00000007T1S-02Ip;
	Mon, 25 Aug 2025 09:17:13 +0000
Date: Mon, 25 Aug 2025 02:17:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, neil@brown.name,
	akpm@linux-foundation.org, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	colyli@kernel.org, xni@redhat.com, yi.zhang@huawei.com,
	yangerkun@huawei.com, johnny.chenyi@huawei.com,
	"yukuai (C)" <yukuai3@huawei.com>, tieren@fnnas.com
Subject: Re: [PATCH] block: fix disordered IO in the case recursive split
Message-ID: <aKwqGHE_ImVwoH6B@infradead.org>
References: <20250821074707.2604640-1-yukuai1@huaweicloud.com>
 <aKbcM1XDEGeay6An@infradead.org>
 <54fc027f-f4dc-0412-0d6d-b44a3e644c39@huaweicloud.com>
 <aKbgqoF0UN4_FbXO@infradead.org>
 <060396d7-797e-b876-9945-1dc9c8cbf2b4@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <060396d7-797e-b876-9945-1dc9c8cbf2b4@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 21, 2025 at 05:37:15PM +0800, Yu Kuai wrote:
> Fix bio splitting by the crypto fallback code

Yes.

> 
> I'll take look at all the callers of bio_chain(), in theory, we'll have
> different use cases like:
> 
> 1) chain old -> new, or chain new -> old
> 2) put old or new to current->bio_list, currently always in the tail,
> we might want a new case to the head;
> 
> Perhaps it'll make sense to add high level helpers to do the chain
> and resubmit and convert all callers to use new helpers, want do you
> think?

I don't think chaining really is problem here, but more how bios
are split when already in the block layer.  It's been a bit of a
source for problems, so I think we'll need to sort it out.  Especially
as the handling of splits for the same device vs devices below the
current one seems a bit problematic in general.

