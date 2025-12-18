Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A57221FBA;
	Thu, 18 Dec 2025 06:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766039428; cv=none; b=qLFrJ4maQQ9Quq0U9ZBVXP5fGS/cYPaCHy+Nyryd2AHmVLIvmEisMRRl4B29HSvMgR+9fjvpo3NkZYZsBR8f/vvte5irrY2xgk2CWk1KF1NFSDAqhyBtR38FmoJCVo4E8QPRZOMw6xO9Rx6bHMSpZwv69RiZgx/nD1YqGiUyCig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766039428; c=relaxed/simple;
	bh=1h3acOqy1Zij7H8b5LHPq5MorRW6Lek3AXGxaqAixpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kSOqUGCKLnvs+fohPZ8Kyhj2/b3D2hYx59GwAopb+bZbI28EnBQyUZuWAgLRJUj6Smr+iieyJq5frfECCa3buFzaJVQok+jJpwWjxK24xG177t1ghgpOiUHAPH8dbKqI48tjVLZhTZ4JP4yY3Sce2BbdyuiWNj6NsJAZsuoaxEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+/vvaJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+/vvaJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9626FC4CEFB;
	Thu, 18 Dec 2025 06:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1766039428;
	bh=1h3acOqy1Zij7H8b5LHPq5MorRW6Lek3AXGxaqAixpU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l+/vvaJ95wcsjuwoL7KJPb9HeEUN7Wht+RkgmWsTL2JN44n0lLbgXvN4WBmCJzFVT
	 I8WpDEgaD1nFGJPLl/L1Y95KSoIm582tRAlux/jDEVBXq72651J6qurrNza8sYNelW
	 zkyR0vvJ+NGRva9T2ieV3Mc+s3UaDcLjHvFEjaYc=
Date: Thu, 18 Dec 2025 07:30:25 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: Yu Kuai <yukuai@fnnas.com>, linan666@huaweicloud.com,
	stable@vger.kernel.org, song@kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: Re: [PATCH stable/6.18-6.17] md: add check_new_feature module
 parameter
Message-ID: <2025121800-doorframe-enviably-56d5@gregkh>
References: <20251217130513.2706844-1-linan666@huaweicloud.com>
 <2025121700-pedicure-reckless-65b9@gregkh>
 <6979cd43-d38c-477d-857c-8d211bc85474@fnnas.com>
 <20251217223130.1c571fa5@nvm>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251217223130.1c571fa5@nvm>

On Wed, Dec 17, 2025 at 10:31:30PM +0500, Roman Mamedov wrote:
> On Thu, 18 Dec 2025 01:11:43 +0800
> "Yu Kuai" <yukuai@fnnas.com> wrote:
> 
> > Hi,
> > 
> > 在 2025/12/17 22:04, Greg KH 写道:
> > > On Wed, Dec 17, 2025 at 09:05:13PM +0800, linan666@huaweicloud.com wrote:
> > >> From: Li Nan <linan122@huawei.com>
> > >>
> > >> commit 9c47127a807da3e36ce80f7c83a1134a291fc021 upstream.
> > >>
> > >> Raid checks if pad3 is zero when loading superblock from disk. Arrays
> > >> created with new features may fail to assemble on old kernels as pad3
> > >> is used.
> > >>
> > >> Add module parameter check_new_feature to bypass this check.
> > > This is a new feature, why does it need to go to stable kernels?
> > >
> > > And a module parameter?  Ugh, this isn't the 1990's anymore, this is not
> > > good and will be a mess over time (think multiple devices...)
> > 
> > Nan didn't mention the background. We won't backport the new feature to stable
> > kernels(Although this fix a data lost problem in the case array is created
> > with disks in different lbs, anyone is interested can do this). However, this
> > backport is just used to provide a possible solution for user to still assemble
> > arrays after switching to old LTS kernels when they are using the default lbs.
> 
> This is still a bad scenario. Original problem:
> 
> - Boot into a new kernel once, reboot into the old one, the existing array no
>   longer works.
> 
> After this patch:
> 
> - Same. Unless you know how, where and which module parameter to add, to
>   be passed to md module on load. Might be not convenient if the root FS
>   didn't assemble and mount and is inaccessible.
> 
> Not ideal whatsoever.
> 
> Wouldn't it be possible to implement minimal *automatic* recognition (and
> ignoring) of those newly utilized bits instead?

Yes, that should be done instead.

And again, a module parameter does not work for multiple devices in a
system, the upstream change should also be reverted.

thanks,

greg k-h
