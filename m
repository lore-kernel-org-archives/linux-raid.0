Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8001FECB0;
	Wed, 16 Jul 2025 12:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752668096; cv=none; b=qeyEEzM/dZvELfE+h+jbG06RONobhq5fAq+/yaY/xIrWijp2HAQQFYS+npjjI3DgCN9mhuoIAatnnFIed3pYBclq+3PUWFB5qhiJxB1dY+9aNJfY4ZR/5p283xl6GmIZXwU3RtMsQxtj1Te4v6IxheousVEjzu+a4Sv3inlhOLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752668096; c=relaxed/simple;
	bh=JXS2YraroALrDEhQVXf833W2lnrWaMOLPbKT4flPIrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E6oA07CVC5iDuuyBcxrEJfd5KddeOxpdIizcENENRWreHZTbGmaMXHprvwVpclB37/znn4A5qi5gzZLWiYiySUmtwtmUEc3N2TFcfAGhmx1lx2qPf8igAJ4cGeQbyJZAa34xU1MUXSnybI51tj30R2xdtMtaRMOsTdQ0ZwR2EuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7E1DE68BEB; Wed, 16 Jul 2025 14:14:49 +0200 (CEST)
Date: Wed, 16 Jul 2025 14:14:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Coly Li <colyli@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Coly Li <i@coly.li>,
	linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
	Yu Kuai <yukuai3@huawei.com>, Xiao Ni <xni@redhat.com>,
	Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH] md: split bio by io_opt size in md_submit_bio()
Message-ID: <20250716121449.GB2043@lst.de>
References: <20250715180241.29731-1-colyli@kernel.org> <20250716113737.GA31369@lst.de> <437E98DD-7D64-49BF-9F2C-04CB0A142A88@coly.li> <20250716114121.GA32207@lst.de> <D12A8BDA-5C2B-4FA7-9C92-731BD321A611@coly.li> <20250716114533.GA32631@lst.de> <danlsghtalte7sku3vlfxkgngujgwzspanfayaxy4jfnk54jbf@yfvmr5plavmp>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <danlsghtalte7sku3vlfxkgngujgwzspanfayaxy4jfnk54jbf@yfvmr5plavmp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 16, 2025 at 08:10:33PM +0800, Coly Li wrote:
> Just like hanlding discard requests, handling raid5 read/write bios should
> try to split the large bio into opt_io_size aligned both *offset* and
> *length*. If I understand correctly, bio_split_to_limits() doesn't handle
> offset alignment for read5 read/write bios.

Well, if you want offset alignment, set chunk_sectors.

