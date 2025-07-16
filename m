Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ADF2C3745;
	Wed, 16 Jul 2025 11:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752666089; cv=none; b=kL8S4VeHYUhIdAd8uOMLkVZaal07/FlCaOaxQXDIym4nYM7iYHs9oJwX7fStF7uj61VGSAN4pEeg23iZjgrrvRXdmSmZpV87PuuN22EwwAz/VseIu0s5djrqVPAz+D+yuQS6ef/CEG9yhgNQExdatyliFV7qEFsoanS6gcwBCpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752666089; c=relaxed/simple;
	bh=WJ/JEtkLmuBSXX+im121cgKAc9IOVjG7XPbnyl88DNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QOVsCD50+AxwSSsRxQOoUayEUqABJDzhVnziVuB+z7oLHm8Pts8cQFdUzdYbfkUxdh9UgK+Rmy126Rv+cIkmueDDdtDLdkCAqjPFCIOH4oDjyHvqmJfs5tncZV6WdfobfbqmN/zR8QvZelw73lYl9EHY9BoL41juPAXFghiHFuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4A67A68BEB; Wed, 16 Jul 2025 13:41:22 +0200 (CEST)
Date: Wed, 16 Jul 2025 13:41:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Coly Li <i@coly.li>
Cc: Christoph Hellwig <hch@lst.de>, colyli@kernel.org,
	linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
	Yu Kuai <yukuai3@huawei.com>, Xiao Ni <xni@redhat.com>,
	Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH] md: split bio by io_opt size in md_submit_bio()
Message-ID: <20250716114121.GA32207@lst.de>
References: <20250715180241.29731-1-colyli@kernel.org> <20250716113737.GA31369@lst.de> <437E98DD-7D64-49BF-9F2C-04CB0A142A88@coly.li>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <437E98DD-7D64-49BF-9F2C-04CB0A142A88@coly.li>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 16, 2025 at 07:39:18PM +0800, Coly Li wrote:
> >> For raid level 4/5/6 such split method might be problematic and hurt
> >> large read/write perforamnce. Because limits.max_hw_sectors are not
> >> always aligned to limits.io_opt size, the split bio won't be full
> >> stripes covered on all data disks, and will introduce extra read-in I/O.
> >> Even the bio's bi_sector is aligned to limits.io_opt size and large
> >> enough, the resulted split bio is not size-friendly to corresponding
> >> raid456 level.
> > 
> > So why don't you set a sane max_hw_sectors value instead of duplicating
> > the splitting logic?
> 
> Can you explain a bit more detail?  In case I misunderstand you like I
> did with Kuai’s comments

Just set the max_hw_sectors you want.

