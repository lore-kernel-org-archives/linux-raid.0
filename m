Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79641FBC8C;
	Wed, 16 Jul 2025 11:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752666341; cv=none; b=tmOoDT4m6VbeTuNwECsyFzBk38DKXBHA+BwpPq0md0ArxOUUgYal0W125kP80hGesL/Gq4oLZlY/1B3bORAUetMckFhH4xwlRwX+4ImiAYslheWPg3rt1phoBHyiaZL8Skn6BM+615x8t0OeKyD9C4WkzXIw/5b5ABoFmhD1nXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752666341; c=relaxed/simple;
	bh=e7TOPkhwketDytwB+lc4B0oz5K0ebz1t+kO3HmmQGNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cKQzhKjtDcCgo6PdeAccQi42eTU2Z5WcP0yJqY4TX5qKZPXkscVEIjCeh/Inmy0ID9wplS6cLoACYZQ61MqSvqU30bYY/e7YFV2Fn+HJiorWBINVoPsnT1vbG+VK/DuCj2kWTtnbE0iNLUUYHPyhfJEumcBbjXvQ7nqTJ9qHELs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2BB07227A87; Wed, 16 Jul 2025 13:45:33 +0200 (CEST)
Date: Wed, 16 Jul 2025 13:45:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Coly Li <i@coly.li>
Cc: Christoph Hellwig <hch@lst.de>, colyli@kernel.org,
	linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
	Yu Kuai <yukuai3@huawei.com>, Xiao Ni <xni@redhat.com>,
	Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH] md: split bio by io_opt size in md_submit_bio()
Message-ID: <20250716114533.GA32631@lst.de>
References: <20250715180241.29731-1-colyli@kernel.org> <20250716113737.GA31369@lst.de> <437E98DD-7D64-49BF-9F2C-04CB0A142A88@coly.li> <20250716114121.GA32207@lst.de> <D12A8BDA-5C2B-4FA7-9C92-731BD321A611@coly.li>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D12A8BDA-5C2B-4FA7-9C92-731BD321A611@coly.li>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 16, 2025 at 07:44:38PM +0800, Coly Li wrote:
> Do you mean setting max_hw_sectors as (chunk_size * data_disks)?

If that is what works best: yes.

