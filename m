Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F96379C2
	for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 06:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718086406; cv=none; b=hgUdKmOBy0NrAz+0LuID6yiDGXEvhkBwKFxvI/2Nu3esMPo5jZyOMM3nr95ZptxI0iUlIGzk1WlWnEA0cAoctWsJa6+qwlO0D6WHcXMNR3cfSoq5YMNiwTMQeg3ujHR53KvAs7d78xAtfMoIhRvf2oEVYLvIN1nzSgqsL2ku3VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718086406; c=relaxed/simple;
	bh=ewGDcnYpWIfI8siIUIVdRSO4LJ6d/2xAMHpoRgL7sKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qUNKjvgY0pm/Jayr7zMVpVqm8DfJ0gzWK2btq6ftS+Ki7n7qaLZ7mP+Hy8TUycEq4o4FxLvUOiuDUGPmuVRFpLTVcc9F9sLn3uAUPp97tH2TyXl+JpF0WwBgMLWv6l2JFJ4oXPN+AWzMogoh7js7bNrbveZx9pJpj+xylK1vSMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 27AFC67373; Tue, 11 Jun 2024 08:13:21 +0200 (CEST)
Date: Tue, 11 Jun 2024 08:13:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Song Liu <song@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org
Subject: Re: fix ->run failure handling
Message-ID: <20240611061320.GA4744@lst.de>
References: <20240604172607.3185916-1-hch@lst.de> <CAPhsuW7cBhbH9iQQunmVohGkwnGJNnw7PFfExXh3umL1qB=SVw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW7cBhbH9iQQunmVohGkwnGJNnw7PFfExXh3umL1qB=SVw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 10, 2024 at 01:58:17PM -0700, Song Liu wrote:
> > raid10 and raid5 also free conf on failure in their ->run handle,
> > but set mddev->private to NULL which prevents the double free as well
> > (but requires more code)
> >
> > Diffstat:
> >  raid0.c |   21 +++++----------------
> >  raid1.c |   14 +++-----------
> >  2 files changed, 8 insertions(+), 27 deletions(-)
> 
> Thanks for the patchset. I applied it to the md-6.11 branch.

I was planning to respin this to also handle failures in the takeover
path.

