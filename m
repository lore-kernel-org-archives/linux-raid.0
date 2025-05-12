Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6BA4A23;
	Mon, 12 May 2025 04:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747025522; cv=none; b=r1wZyoDMdRdT8myKvGBoBFcptKObM2toMxVUqJyQp9ZRvY203BcirSzg3jUu8/D0sK5AQrxwIniO3G3c7zEEQkoFcQrda8uMNdgSs02LlSOzBURfeUpa8muWNg0yS9knFaemHpbi07dyCXdUIaHdNVmaPpUsiixcLPb5C4DjwE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747025522; c=relaxed/simple;
	bh=nuzymvJ9urfYFge83vIgEUU9ANY2WZuCC0qWpKMcJvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oXbexHodkzBiACzhzDSO/+Tl4Ch06ErJvKbqHBZSAUwTBCOZE8HH0k8mztQy/X2yI3QGYXNnlk8RnUpR1ico5TrE11VM3Esji30iFBftRddVUZux6Mm6t7gaTRV3GJo8PMi2+6LExWc1rDyimlpWbteB0eL0VE9g8qnmglo1HHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B44E068AA6; Mon, 12 May 2025 06:51:55 +0200 (CEST)
Date: Mon, 12 May 2025 06:51:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH RFC md-6.16 v3 04/19] md: add a new sysfs api
 bitmap_version
Message-ID: <20250512045155.GD868@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-5-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512011927.2809400-5-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 09:19:12AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> The api will be used by mdadm to set bitmap version while creating new
> array or assemble array, prepare to add a new bitmap.

Maybe call it type or variant instead of version?

Also this needs a Documentation/ file like for other new sysfs APIs.

