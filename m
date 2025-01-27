Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1051FCF43;
	Mon, 27 Jan 2025 09:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737969149; cv=none; b=BLGSaNl1+QrsG1TDiU7QH/myBfuNdcCm4k6s9Zm3McV3Cm1jJS4+Ljpnkm/IS9LcATpeNo5SUmcIWJF/sV737No2kh5G0zATbXkEJ/Cg0jy53wG+be9vCxRJ2nMbRYGdTK+ZI0qvn4kCYhOcnEJsyqWjr70i0dTdoiFxtCIqBGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737969149; c=relaxed/simple;
	bh=GfUWG6ERUF8T2GDM5aOJgZ1hzhzKvaEP5FrdCuHGJOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C1VTChIXnJnKRqAfcwngpVfmfJH/hUQSFTQMSRN8Z/FOd9gDyDD/+uWGrsJ0XikqOaE9rINyLBdV+Ozdbe2xXBssxHkV41YIKOjs1fNN3PPq7jj2zK3vkuYLygaZd3sr/xcf1omcwShDwM+R2LlTbUTob/ML3w4WawxFAuMjLKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pN5VQe9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pN5VQe9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3394FC4CED2;
	Mon, 27 Jan 2025 09:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737969148;
	bh=GfUWG6ERUF8T2GDM5aOJgZ1hzhzKvaEP5FrdCuHGJOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pN5VQe9WZin6fmJc8h3fCa78Ljx3UUFEboETNcc1WJNz56wVTtvc0ogPlE9+Tu8C1
	 oxe5VVYCrlDJTQVhsYVwy3tz1uT9aZoPrYJtE4bN8V2zhAdyGCzPLTIMax8W1gcqGy
	 4h4OgwQa3hae/NaViUKJshEOeaUaX6MeqR7a7/F0=
Date: Mon, 27 Jan 2025 10:11:30 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: stable@vger.kernel.org, song@kernel.org, yukuai3@huawei.com,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 6.13 0/5] md/md-bitmap: move bitmap_{start, end}write to
 md upper layer
Message-ID: <2025012752-jolly-chowtime-d498@gregkh>
References: <20250127084928.3197157-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127084928.3197157-1-yukuai1@huaweicloud.com>

On Mon, Jan 27, 2025 at 04:49:23PM +0800, Yu Kuai wrote:
> This set fix reported problem:
> 
> https://lore.kernel.org/all/CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com/
> https://lore.kernel.org/all/ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io/
> 
> See details in patch 5.

Why were these all not properly taggeed for stable inclusion to start
with?

confused,

greg k-h
