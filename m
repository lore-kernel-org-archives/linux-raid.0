Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ED028BA8D;
	Wed, 16 Jul 2025 12:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752668272; cv=none; b=KL/rfnWM7zSA5UdpXdJD5MpT/DEDxAxsVpFhtT1j2GWoOzUPHsFVfEivnT9lfJ+lp7WtZlqyaJuoCU3o0PFdJ2e3dfhiP2/D02sO5qlcMy1x06CsxDBkr1L30w8XnwOolzTiXhznz5JL5tMPSahsflgIoJ+OAQ3o773X00zuO/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752668272; c=relaxed/simple;
	bh=V4MeM2PQ2JhErRHk73m2EXf2vRq45TySVkh6JEnAjOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JTiZjb6Rxyc6bIp4TPhteAPWhV8PQzeqLLEesyqPxtPWqCzY/kmdayQyqjmDu6cEk45DtQgSTrS7/EYpyBRRttd6ZuGfy4ibQuD4lexd/CaUCCJUD+l5vH3Q/JH/bSKrCc/aBt4/aSe3nHwWceZY/azpzEoYRmlSdT81yMaKif8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ABDD968BEB; Wed, 16 Jul 2025 14:17:45 +0200 (CEST)
Date: Wed, 16 Jul 2025 14:17:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Coly Li <i@coly.li>
Cc: Christoph Hellwig <hch@lst.de>, Coly Li <colyli@kernel.org>,
	linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
	Yu Kuai <yukuai3@huawei.com>, Xiao Ni <xni@redhat.com>,
	Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH] md: split bio by io_opt size in md_submit_bio()
Message-ID: <20250716121745.GA2700@lst.de>
References: <20250715180241.29731-1-colyli@kernel.org> <20250716113737.GA31369@lst.de> <437E98DD-7D64-49BF-9F2C-04CB0A142A88@coly.li> <20250716114121.GA32207@lst.de> <D12A8BDA-5C2B-4FA7-9C92-731BD321A611@coly.li> <20250716114533.GA32631@lst.de> <danlsghtalte7sku3vlfxkgngujgwzspanfayaxy4jfnk54jbf@yfvmr5plavmp> <20250716121449.GB2043@lst.de> <DE36C995-4014-44DC-A998-1C4FF9AFD7F9@coly.li>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DE36C995-4014-44DC-A998-1C4FF9AFD7F9@coly.li>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 16, 2025 at 08:16:34PM +0800, Coly Li wrote:
> 
> 
> > 2025年7月16日 20:14，Christoph Hellwig <hch@lst.de> 写道：
> > 
> > On Wed, Jul 16, 2025 at 08:10:33PM +0800, Coly Li wrote:
> >> Just like hanlding discard requests, handling raid5 read/write bios should
> >> try to split the large bio into opt_io_size aligned both *offset* and
> >> *length*. If I understand correctly, bio_split_to_limits() doesn't handle
> >> offset alignment for read5 read/write bios.
> > 
> > Well, if you want offset alignment, set chunk_sectors.
> > 
> 
> Do you mean setting max_hw_sectors as chunk_sectors?

Setting both to the desired value (full stipe width).

