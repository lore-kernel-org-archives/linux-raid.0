Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E503A1F1507
	for <linux-raid@vger.kernel.org>; Tue, 22 Apr 2025 13:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745329740; cv=none; b=csbWOyeOqHMWAj7S2Tja4EUAehiGt6yJqr9TXCqg4qTENEqagnUH4E7D5sDUnhSJPiNTIohXg8mfWR2MTtncKRtEOPEEByX4xvJrGV9EC2pySeAQaVdv0jTVUYnsDGtJo+cy+u7k+j8THsSfqMfWFUGBn8/JH+N1/9z8MEwIKqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745329740; c=relaxed/simple;
	bh=cbF18u7rov7oZYzKlQd7ztYcovcSOZcyOVjTQVRRP7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rgryb9EpZFJzFKVNj2u0lHA7m5yJUjRPgj74CPGYI4oTl3xPJnw31ucTpCTpZMkPMHv9YpV3HXwbm0oYQofCpB3AaSem0nijrJpAlqC0YFxtGE6GweOK9frhetzaRJAUilrMWCLg7neAmIFwCoUd/ctSNVSXpHdvTIjY1LMbXHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7512467373; Tue, 22 Apr 2025 15:48:52 +0200 (CEST)
Date: Tue, 22 Apr 2025 15:48:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, yukuai1@huaweicloud.com,
	ming.lei@redhat.com, ncroxon@redhat.com
Subject: Re: [RFC PATCH 1/1] md: delete gendisk in ioctl path
Message-ID: <20250422134851.GA23131@lst.de>
References: <20250422032403.63057-1-xni@redhat.com> <20250422055108.GA29356@lst.de> <CALTww2-L_29Zpdf1VKQccO-O+=FSGErLakbj-dk4ZDpidr4_5A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALTww2-L_29Zpdf1VKQccO-O+=FSGErLakbj-dk4ZDpidr4_5A@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 22, 2025 at 04:31:57PM +0800, Xiao Ni wrote:
> There is another reason that I want to put del_gendisk in the ioctl
> path. Because sometimes device node can still exist after command
> mdadm --stop. del_gendisk removes inode first and then removes device
> node (e.g. /dev/md0). So there is a small window that device node can
> be open again. Then some strange things happen. Sometimes the array is
> created but device node can't be created (I guess it's removed by
> devtempfs?). Sometimes the kernel message prints "block device
> autoloading is deprecated and will be removed".

FYI, I'm all for sorting out the md gendisk lifetime and probing
mess.  But let's do that separately from a regression fix as changes
in the area are intricate and might cause further regressions.

