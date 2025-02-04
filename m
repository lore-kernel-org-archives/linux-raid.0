Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB8220C02B;
	Tue,  4 Feb 2025 11:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738669218; cv=none; b=HZKSVkAUWHQY18Lp0vdd+fWzKPbP0expD1jUJjdmFvH1CqCH3qqUc6xA62wUV8UO5LjOloyfHMJtILJx73sf5LJPXrRQ/mvnEvwAcNyetGx0BJRCxchJBM3Nmb7kojlpv7iLZ6XFEqXmkan2x8MzUMNKFERqQxuiv+BtzadryPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738669218; c=relaxed/simple;
	bh=Rl5IODSX3nSgDk5xRkzyDGOq2rnXoTlgAQv1V1BIv18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQEkS2ZejkqnLJwBE3lbTDq/3SBjFKJDnUaQShhODRBXFlzZIzswczPMQuEL5cZpXYQftIHmYaULXVdByblsKPXxhDYT/SS+BBnsUgG6yTV6pdJ5R7culYRs6OE+SpEbRqm0RLomkEVYtOLDn/a7650wowUi6s2cJAwIxy4/wB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n0VTmAl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0VTmAl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B96C4CEDF;
	Tue,  4 Feb 2025 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738669215;
	bh=Rl5IODSX3nSgDk5xRkzyDGOq2rnXoTlgAQv1V1BIv18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n0VTmAl0TaBuJCFI5kq5shDnF3ORHkTEixPhUP6xROnxO5XKiamWrRia5/OYm+s23
	 eBIBBtq5FwyioRs22eTYMphVG5p16ltfVZDmRtk385M7HK+9Jw2Pi1CLEM3XNfbdBp
	 yRaJVQlh26FTeWUU/DnYgUFgkuepfvkRz5S55ytA=
Date: Tue, 4 Feb 2025 12:40:12 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: stable@vger.kernel.org, song@kernel.org, yukuai3@huawei.com,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 6.6 0/6] md/md-bitmap: move bitmap_{start, end}write to
 md upper layer
Message-ID: <2025020447-hesitant-corroding-16c1@gregkh>
References: <20250127085351.3198083-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127085351.3198083-1-yukuai1@huaweicloud.com>

On Mon, Jan 27, 2025 at 04:53:45PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> This set fix reported problem:
> 
> https://lore.kernel.org/all/CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com/
> https://lore.kernel.org/all/ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io/
> 
> See details in patch 6.

Please redo this series and describe in it what you changed from the
original commits, as these are not just normal cherry-picks at all.

thanks,

greg k-h
