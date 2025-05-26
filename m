Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22116139E;
	Mon, 26 May 2025 06:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748241664; cv=none; b=q9uBRXwpSr5jGEDDXxrJjvM4CYoH7WdfBB54w8h7y4OBZkDj0Izt0eVi0PYKhCzLjqaDZ6YnNpLRxQt5LsqsMdjfIHftYNttOMFhx3/A9RkvIwik7szipfb09e8EFpDmrrHfpF8mbEuOvu4itUnC0h42ECqZeZrg4KPBwQG5t7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748241664; c=relaxed/simple;
	bh=W9ec/G/b5oDXdlw6tR7/Wnb/nlUJppRMsfickaR1Zlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ktu9KgM0Bsgo5w0bnSwRri2eSYoIZ6NsTzo5wtC5PCmzsgaTmXsL1q8jg2Sndvsj+/xgXx1OLQbqHyT+LGc9ZZUL4YakxjL5GBwWXY2qhRIh9erGo7C5k0nSQtfxUPenpKvdQbREoXNsOt0+AMMFl3xv7ES8LSgRLwPzVrnioUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9880668AFE; Mon, 26 May 2025 08:40:58 +0200 (CEST)
Date: Mon, 26 May 2025 08:40:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, song@kernel.org,
	yukuai3@huawei.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 13/23] md/md-bitmap: fix dm-raid max_write_behind
 setting
Message-ID: <20250526064057.GA13016@lst.de>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-14-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250524061320.370630-14-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, May 24, 2025 at 02:13:10PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> It's supposed to be COUNTER_MAX / 2, not COUNTER_MAX.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

And maybe move this to the front of the series and/or submit it ASAP
for 6.16?

