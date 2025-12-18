Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3620C1BC41;
	Thu, 18 Dec 2025 07:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766042044; cv=none; b=iRWJCse2kwlcOu8PWImHSlazCmQPTYRZTrrfLPAlK2q5F3egXrVLSnSiz/z0ERZftXPpLTAluhNUmAFf5Pp7rL1wGNFVZQdKhvJdl1hoFA9Fb/Z966ncT8lp5HBTlJgk9hu1lDaCWtub3VjyaxIgSR7LvdSijl0u5Nr7JDDyq5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766042044; c=relaxed/simple;
	bh=07jxoBjWTtDHJh4vv6be10PJ3A4HCvArOnIeflRk4EM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G1TMQ8MsdkvX4y17+mXtmFZVOGLQOIjX1JdFSFld8V5bnFcEvL7W365laQEvyXeIZbYNtVpWKeJxn2yk38fZM+0KJxVzUPIWPvN1BAbjOMeqrLD6EOmIpnqCfytc0avqA8DnbzmejCGr0jlRiF64RlTXZfdUfIVBYegczzYXOqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9p3ghC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9p3ghC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB5BC4CEFB;
	Thu, 18 Dec 2025 07:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1766042043;
	bh=07jxoBjWTtDHJh4vv6be10PJ3A4HCvArOnIeflRk4EM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r9p3ghC0xbiDjib5DjReLMCbVxeXMK/7zu/PSM4qJ3BwTAED7KnZL23vOgTubv9+E
	 Cc+RKEZAQX2fR7K86EHCz638aRXneUGpklw/Z3+WrybZK00ETI2rpqd9g8otfOSESk
	 VZYA/SHw7Tp2dtoKDkYPhUBz8tNuh4VuTxPIaDZc=
Date: Thu, 18 Dec 2025 08:14:00 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Li Nan <linan666@huaweicloud.com>
Cc: Roman Mamedov <rm@romanrm.net>, Yu Kuai <yukuai@fnnas.com>,
	stable@vger.kernel.org, song@kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: Re: [PATCH stable/6.18-6.17] md: add check_new_feature module
 parameter
Message-ID: <2025121849-moonlit-emotion-41ed@gregkh>
References: <20251217130513.2706844-1-linan666@huaweicloud.com>
 <2025121700-pedicure-reckless-65b9@gregkh>
 <6979cd43-d38c-477d-857c-8d211bc85474@fnnas.com>
 <20251217223130.1c571fa5@nvm>
 <2025121800-doorframe-enviably-56d5@gregkh>
 <c34450ca-7359-7be0-1266-133a71f6c579@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c34450ca-7359-7be0-1266-133a71f6c579@huaweicloud.com>

On Thu, Dec 18, 2025 at 02:57:23PM +0800, Li Nan wrote:
> 
> 
> 在 2025/12/18 14:30, Greg KH 写道:
> > On Wed, Dec 17, 2025 at 10:31:30PM +0500, Roman Mamedov wrote:
> > > On Thu, 18 Dec 2025 01:11:43 +0800
> > > "Yu Kuai" <yukuai@fnnas.com> wrote:
> > > 
> > > > Hi,
> > > > 
> > > > 在 2025/12/17 22:04, Greg KH 写道:
> > > > > On Wed, Dec 17, 2025 at 09:05:13PM +0800, linan666@huaweicloud.com wrote:
> > > > > > From: Li Nan <linan122@huawei.com>
> > > > > > 
> > > > > > commit 9c47127a807da3e36ce80f7c83a1134a291fc021 upstream.
> > > > > > 
> > > > > > Raid checks if pad3 is zero when loading superblock from disk. Arrays
> > > > > > created with new features may fail to assemble on old kernels as pad3
> > > > > > is used.
> > > > > > 
> > > > > > Add module parameter check_new_feature to bypass this check.
> > > > > This is a new feature, why does it need to go to stable kernels?
> > > > > 
> > > > > And a module parameter?  Ugh, this isn't the 1990's anymore, this is not
> > > > > good and will be a mess over time (think multiple devices...)
> > > > 
> > > > Nan didn't mention the background. We won't backport the new feature to stable
> > > > kernels(Although this fix a data lost problem in the case array is created
> > > > with disks in different lbs, anyone is interested can do this). However, this
> > > > backport is just used to provide a possible solution for user to still assemble
> > > > arrays after switching to old LTS kernels when they are using the default lbs.
> > > 
> > > This is still a bad scenario. Original problem:
> > > 
> > > - Boot into a new kernel once, reboot into the old one, the existing array no
> > >    longer works.
> > > 
> > > After this patch:
> > > 
> > > - Same. Unless you know how, where and which module parameter to add, to
> > >    be passed to md module on load. Might be not convenient if the root FS
> > >    didn't assemble and mount and is inaccessible.
> > > 
> > > Not ideal whatsoever.
> > > 
> > > Wouldn't it be possible to implement minimal *automatic* recognition (and
> > > ignoring) of those newly utilized bits instead?
> > 
> > Yes, that should be done instead.
> > 
> > And again, a module parameter does not work for multiple devices in a
> > system, the upstream change should also be reverted.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > .
> 
> We propose the following fix for this issue. After fix, md arrays created
> on old kernels won't be affected by this feature.
> 
> https://lore.kernel.org/linux-raid/825e532d-d1e1-44bb-5581-692b7c091796@huaweicloud.com/T/#mb205fb97ab4af629cae9db8dfd236ceaa93f14ad
> 
> The method is:
> > only set lbs by default for new array, for assembling the array still
> > left the lbs field unset, in this case the data loss problem is not fixed,
> > we should also print a warning and guide users to set lbs to fix the
> problem,
> > with the notification the array will not be assembled in old kernels.

Great, have a patch for this?

thanks,

greg k-h
