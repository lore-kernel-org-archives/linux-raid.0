Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153D81DED4E
	for <linux-raid@vger.kernel.org>; Thu, 17 Oct 2024 15:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729177486; cv=none; b=q554tBhWHs2S71l00jLk0w2+qYPzhykloMGOJ6oEj9dd57y4wZDl0HBH7VlQqdAL5W4nayOd42AgHInY0sC6gqz3gQheTXidMZUf3PTRGtt93vJhzejjp1ornmKipVWj6r3ufwgoHM9zoUwkRiE0Y/hmoun/FnQPeVNM9cyjeAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729177486; c=relaxed/simple;
	bh=KfrihOozXdBtWitTRlw4rFDUk41c29FeXSAZBUWlz+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I1eho4ifXIOdH6fj0RL0PFtQRe28iuoSrsP5VrHcs9sK4c8UvocKR5XJfqVuSTlvUGkcCXA7O7Y00piy9Ym8WPW/7sgbH6EgLATjUZZA7MzAovbGSpyBWarjS1NRhZhMzwwB+f0E4FgJhhiAcfakUC1X/Nqi8qzFogYPqso9IR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XrB43quC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XrB43quC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NLxint0OyfKR418WFUU93Gn/5Fmr2hmaIYWQHqG8BB4=; b=XrB43quC6TzKVk/fiYdQNc+dKW
	WHBV0zYwVMC++k9gxDevf7IdJgXqAtRecWNNw1wpuzKdRnU69eJczKjSF1GMbVGvnXIdoK8Ru5kOj
	aX3tVjoeM92ykUdw+gJmHCXSDpdUNBv2BW3HwtmDAactDXgCoT05DNR4GKA9TPLhyeCd418xA3y6S
	wlS8nSNRzYiow4fk8ocOFB8eXm/AAtkTcdJ1XuSY9bSoBVxQBsu9X1asNCSsdEYq1BdZMTKIQDGME
	mxxpA+x55e0U7akuWKhuCLKyrWUchpzUqPlbjm6IlpsCyoQAbdP0/2A9cDJ96oYrxIffwCXoxF1tV
	vI4fao4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t1S3Q-0000000FDVg-309i;
	Thu, 17 Oct 2024 15:04:44 +0000
Date: Thu, 17 Oct 2024 08:04:44 -0700
From: "Hellwig, Christoph" <hch@infradead.org>
To: Laurence Oberman <loberman@redhat.com>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	"Hellwig, Christoph" <hch@infradead.org>,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH] Add the ":" to the allowed_symbols list to work with the
 latest POSIX changes
Message-ID: <ZxEnjGXPF0gBT3v6@infradead.org>
References: <20241015173553.276546-1-loberman@redhat.com>
 <20241016101433.00005bb9@linux.intel.com>
 <5321cf0e579ee5e025396e9f9b62432dd2ed3458.camel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5321cf0e579ee5e025396e9f9b62432dd2ed3458.camel@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 16, 2024 at 09:10:44AM -0400, Laurence Oberman wrote:
> Apologies Christoph and Mariusz, this could have definitely done with
> more of an explanation.
> 
> We have customers complaining about a regression in mdadm since these
> changes happened. They have 1000's of raid devices that can no longer
> be started because they have ":" in the name. Example 
> mdadm: Value "tbz:pv1" cannot be set as devname. Reason: Not POSIX
> compatible.
> 
> Should we add a --legacy flag where the original behavior is still an
> option, what are your thoughts ?

I don't really care either way, just please write an understandable
commit message.  

