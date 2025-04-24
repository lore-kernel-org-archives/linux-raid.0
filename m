Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23E5176AC8;
	Thu, 24 Apr 2025 06:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745476941; cv=none; b=kfU34uwCfQ6yOKVbLvmMNLfQr9lcDEl+BrnrdvjrRzvqMiwOCtgc8II3AOpqlTkQqx+R0soOvtG29U8LKaUWBT43rECiQG6n5ww4Uj05D/8hd1taIucjXt1TLnNNS+ak/K97k+TmJqTWX/T9ALI/5tNJ6mL1bNllobmD3vigp98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745476941; c=relaxed/simple;
	bh=tozlxvCj/x9cqspQcx4xfNdmJ+1dUbZ7wvHoIrt00J0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ONBlDQzSUgbun3zHhoZgplb6qIDgnCGPuknhsadxhJc9PebV0nvJVsdQAnANBD3Bm8GHse4chpUVXAv209/t8bUXZvkLWJizqOQq/+kbgjrptRVM+4zKvHIIYdA8TLTxi8iEbsQyIZS3tMsA+8NyqU1i8+rvs0al8hdNbkTbU8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msU5VL4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msU5VL4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11525C4CEE3;
	Thu, 24 Apr 2025 06:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745476940;
	bh=tozlxvCj/x9cqspQcx4xfNdmJ+1dUbZ7wvHoIrt00J0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=msU5VL4EULOfhv2NqhpL6T6z/ZcCi1j4TCto3xpGBcuxI5lcVsD7uRGEgvn7QEI9F
	 5cMDTvDsJKziF3efPaRDaU/cXWklEuo60ZMdIu+EcM6zwVrSngl3W0ZEtBYq9vip14
	 SQrLYgDe8xsn2CqCgVhxZfsWhfBCS2ESM1osg6dM=
Date: Thu, 24 Apr 2025 08:40:41 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, sashal@kernel.org,
	stable@vger.kernel.org, song@kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, yukuai3@huawei.com,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 6.1 0/2] md: fix mddev uaf while iterating all_mddevs list
Message-ID: <2025042418-come-vacant-ec55@gregkh>
References: <20250419012303.85554-1-yukuai1@huaweicloud.com>
 <aAkt8WLN1Gb9snv-@eldamar.lan>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAkt8WLN1Gb9snv-@eldamar.lan>

On Wed, Apr 23, 2025 at 08:14:09PM +0200, Salvatore Bonaccorso wrote:
> Hi Greg, Sasha, Yu,
> 
> On Sat, Apr 19, 2025 at 09:23:01AM +0800, Yu Kuai wrote:
> > From: Yu Kuai <yukuai3@huawei.com>
> > 
> > Hi, Greg
> > 
> > This is the manual adaptation version for 6.1, for 6.6/6.12 commit
> > 8542870237c3 ("md: fix mddev uaf while iterating all_mddevs list") can
> > be applied cleanly, can you queue them as well?
> > 
> > Thanks!
> > 
> > Yu Kuai (2):
> >   md: factor out a helper from mddev_put()
> >   md: fix mddev uaf while iterating all_mddevs list
> > 
> >  drivers/md/md.c | 50 +++++++++++++++++++++++++++++--------------------
> >  1 file changed, 30 insertions(+), 20 deletions(-)
> 
> I noticed that the change 8542870237c3 was queued for 6.6.y and 6.12.y
> and is in the review now, but wonder should we do something more with
> 6.1.y as this requires this series/manual adaption?
> 
> Or will it make for the next round of stable updates in 6.1.y? 
> 
> (or did it just felt through the cracks and it is actually fine that I
> ping the thread on this question).

This fell through the cracks and yes, it is great that you pinged it.
I'll queue it up for the next release, thanks!

greg k-h
