Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1780B2522B5;
	Thu, 24 Apr 2025 10:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745490406; cv=none; b=Tsm3KtFwGmuvCXynnflK3Uj2AZfPrh2DVY3kRiWkCxCw5udnDLN7rV8s2InkLGUjiXIONfYGVgKwdFvAnuiraWXyn93DlqGLlFD7ukMf68G6zJJqk5jAucsQto/yIKBu0CpnZC/5qT906v/bZL8kvQ+GN8XqHjuU57tFpzOFaaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745490406; c=relaxed/simple;
	bh=ghFZ18sDAQK79Sk1EjjWTkiCDOqMm17tDKKZSop6maU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mSTFKDKNLoFmXNJd87Xqoq2fsDefWInrT1DS5+GDiEIF/uTMljc1ERQJ42pE/DI0FwVXcKtemNYizTFmehhoFMv+RSdLHzZnDGyY57aehyAhnqhzpg37mozEp2ouq4nZZosgklqS8KHJ4N3TUJ67FaALIYN3Jp8dFP01vN8T4wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mw4ACHVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mw4ACHVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A04C4CEE4;
	Thu, 24 Apr 2025 10:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745490405;
	bh=ghFZ18sDAQK79Sk1EjjWTkiCDOqMm17tDKKZSop6maU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mw4ACHVnvd4kAS2/1CNB74VCs7txTbRXioRFOgvybQYdMtUBnomkjDDaFRmjfbZ8X
	 OKr9qPrND0hvMSufaj6RxJTL8x/Hw2tII8Tb6DSg/GFF+AMESDwlHHz9W05CaTLfLo
	 gKWWjDukRTZuY6y1L6WkhwRR+gs3uZtNhS9NcxK8=
Date: Thu, 24 Apr 2025 12:26:42 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, sashal@kernel.org,
	stable@vger.kernel.org, song@kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, yukuai3@huawei.com,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 6.1 0/2] md: fix mddev uaf while iterating all_mddevs list
Message-ID: <2025042436-iodize-dazzler-e7b2@gregkh>
References: <20250419012303.85554-1-yukuai1@huaweicloud.com>
 <aAkt8WLN1Gb9snv-@eldamar.lan>
 <2025042418-come-vacant-ec55@gregkh>
 <aAoFRJ_RIq6pdyn9@eldamar.lan>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAoFRJ_RIq6pdyn9@eldamar.lan>

On Thu, Apr 24, 2025 at 11:32:52AM +0200, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Thu, Apr 24, 2025 at 08:40:41AM +0200, Greg KH wrote:
> > On Wed, Apr 23, 2025 at 08:14:09PM +0200, Salvatore Bonaccorso wrote:
> > > Hi Greg, Sasha, Yu,
> > > 
> > > On Sat, Apr 19, 2025 at 09:23:01AM +0800, Yu Kuai wrote:
> > > > From: Yu Kuai <yukuai3@huawei.com>
> > > > 
> > > > Hi, Greg
> > > > 
> > > > This is the manual adaptation version for 6.1, for 6.6/6.12 commit
> > > > 8542870237c3 ("md: fix mddev uaf while iterating all_mddevs list") can
> > > > be applied cleanly, can you queue them as well?
> > > > 
> > > > Thanks!
> > > > 
> > > > Yu Kuai (2):
> > > >   md: factor out a helper from mddev_put()
> > > >   md: fix mddev uaf while iterating all_mddevs list
> > > > 
> > > >  drivers/md/md.c | 50 +++++++++++++++++++++++++++++--------------------
> > > >  1 file changed, 30 insertions(+), 20 deletions(-)
> > > 
> > > I noticed that the change 8542870237c3 was queued for 6.6.y and 6.12.y
> > > and is in the review now, but wonder should we do something more with
> > > 6.1.y as this requires this series/manual adaption?
> > > 
> > > Or will it make for the next round of stable updates in 6.1.y? 
> > > 
> > > (or did it just felt through the cracks and it is actually fine that I
> > > ping the thread on this question).
> > 
> > This fell through the cracks and yes, it is great that you pinged it.
> > I'll queue it up for the next release, thanks!
> 
> Thank you! Very much appreciated! (People installing Debian will be
> happy as it affects kernel under certiain circumstances, cf.
> https://bugs.debian.org/1086175, https://bugs.debian.org/1089158, but
> was longstanding already).

Now queued up, thanks.

greg k-h
