Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912D417A31C
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 06:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776838859; cv=none; b=jaqzIxMhB3YespO5jIBvaVD8iMKm7Pj5y3aAufHYmjGKSnocDfeW67lIY2snzujZ0K15tytGOua79Gjh2sNNW+zgJUJNNlfBDAChuAEUN/yVThlR7DevXz0oMKvaFsFJ7HOJ/nOhEuyP7PHJ/jRaskkNp913rxbdzyEQfS5NeNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776838859; c=relaxed/simple;
	bh=SUJTU2e1oWk9TCd44pIUiWb+xyFwE8bpSs6rGWtJ+Q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UDVWuServvo3E+VCD3KOZiDUndJkVL1Rkw/kUK5qkUZ1bM7z6zgc7AaQHsBp1SgqaZVl6elCAPbhGEurzdOBOK3pQKmMAz/FDNKP6DAKrGPDRp1vqwMCd1r/hDNDzwSRaC4p8O/qF702iAcO4usAYA3hN/KjRzBivB4kMe6CFWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 332FE68D07; Wed, 22 Apr 2026 08:20:53 +0200 (CEST)
Date: Wed, 22 Apr 2026 08:20:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Nitesh Shetty <nj.shetty@samsung.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>, song@kernel.org, yukuai@fnnas.com,
	linan122@huawei.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org, kmodukuri@nvidia.com
Subject: Re: [PATCH V3 1/3] block: clear BLK_FEAT_PCI_P2PDMA in
 blk_stack_limits() for non-supporting devices
Message-ID: <20260422062052.GG5391@lst.de>
References: <20260416212633.72650-1-kch@nvidia.com> <20260416212633.72650-2-kch@nvidia.com> <CGME20260417101607epcas5p204981188700b5f9e3135d80ed7f16eb1@epcas5p2.samsung.com> <20260417101127.uku7q65akj6gwwh4@green245.gost>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417101127.uku7q65akj6gwwh4@green245.gost>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Apr 17, 2026 at 03:41:27PM +0530, Nitesh Shetty wrote:
>>
>> 	t->flags |= (b->flags & BLK_FLAG_MISALIGNED);
> I think you need below patch[1] as well to unset this here.
> Also I feel better to include Mike,Mikulas and dm-devel mailing list as well.

Why do we need that?  dm support is a different project and will require
additional verification.  Especially as the multiple tables per devices
concept makes it a lot more complicated.

