Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6D91D799D;
	Mon, 26 May 2025 06:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748241002; cv=none; b=Fl0H9aG9KGUidh3M4vCgNeG9dTorfGpblJ7zSHBe0zGGYpFpNug8CKCiuyuDBC0HFdZgnWpNO9OFRi4XIgGIvx72neUb2vATrIxrmW5gp/JNjSpQt3c7hN4ecEtI1jpWbmcxd+yaAKEolDSpYEkOCH8dcLL6xD1F3HPkZuaNZ5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748241002; c=relaxed/simple;
	bh=3xxgT3Hk+AVWFpLf6EZIzYz6xS/kGpSPuN6AGgTd5iw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a7ct4sFjwmHMA3vSWnJVLVt3I60m7L3wduFfOqyMGcs/aow7NZmVU4jU9VrsF2cZvCLEYjx0T1M/w1lpbjb2vSbgYg0nFLSxJV92mEx7Y21TQPmaVBlkpCzlUZNTjJ/LqyJkbuE0gV9D9CdooKomlt7WB8q105vO/ETEZrKbsd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9223768AFE; Mon, 26 May 2025 08:29:57 +0200 (CEST)
Date: Mon, 26 May 2025 08:29:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, song@kernel.org,
	yukuai3@huawei.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 04/23] md/md-bitmap: support discard for bitmap ops
Message-ID: <20250526062957.GD12730@lst.de>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-5-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250524061320.370630-5-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +typedef void (md_bitmap_fn)(struct mddev *mddev, sector_t offset,
> +			    unsigned long sectors);

Does this typedef really add any value?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

