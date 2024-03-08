Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7DC4F883
	for <linux-raid@vger.kernel.org>; Fri,  8 Mar 2024 07:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709883351; cv=none; b=Ovqnb5jwDpzgzTNZFeRY2MZFtyllAewQTySVQO2xGwDAiffAzme0ZNuooKaxQG8qpx21OZ+rWwijOcRimREAmoWoplA6xbwe6H+NV9mdTfttbqCsQYz2K9uCPDBCZXVm+qpyWX5M+5F4BwyVQHAQGpP4Sjj2H7C6M+qTPI6h6GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709883351; c=relaxed/simple;
	bh=YDhCeSGFj3VluVfoa58Kg16P9KZFiutXxIbjAPU0hwM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iA5uRyr0BY+bYxZrphstPO/Hpeqb1SGG64NqKYaHMWY3+7NAGE0N8kIimZSXLylnmRKEL33w/AfUUCLJJi7XGtBegrZc78uwv4g3VvCSmmbE94CVEzwLE+TbZTDJ3J6NW48zZqCv6K8QZbhG8sXn/AezAn/0suIY/yhefeBdqUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TghpiIaS; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TghpiIaS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709883350; x=1741419350;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YDhCeSGFj3VluVfoa58Kg16P9KZFiutXxIbjAPU0hwM=;
  b=TghpiIaSbtSK4YykKuxHWRl8dv5Ck1/GEhuWrnxsIMUVPUjzP8++ZYk9
   YczlqSziIAnBSxBdaC/vvjsw/QnToOmFzyp3+cRwhwfNWm3NhGpkmRjgp
   L89DWXEDook4Yzhk4BdbYrcXwfSe/rvkT0fLUwv1MsTrAySiJ8lzbkw/s
   Of41ugAecetLSSMCIMPoLc1IsrkyVTWMJW6j/aldyIVM6teeX9Z2fyUPQ
   mSz7pgAbMSTG9DjJY28NFNCkpzAVnHAEkxegBxM37LCGA3ISTK5q0ipfc
   yjwDoPrqlMzZpnpP0F5t/U5Xe2VcFLG3cxsnjfwHleeXIo5be73WITpqP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4718775"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="4718775"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 23:35:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="10275677"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.1.223])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 23:35:48 -0800
Date: Fri, 8 Mar 2024 08:35:42 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Nix <nix@esperi.org.uk>
Cc: jes@trained-monkey.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/6] mdadm: remove ANNOUNCEs
Message-ID: <20240308083542.00006121@linux.intel.com>
In-Reply-To: <87jzme9otb.fsf@esperi.org.uk>
References: <20240223145146.3822-1-mariusz.tkaczyk@linux.intel.com>
	<20240223145146.3822-2-mariusz.tkaczyk@linux.intel.com>
	<871q8wsld5.fsf@esperi.org.uk>
	<20240228164046.00001565@linux.intel.com>
	<87jzme9otb.fsf@esperi.org.uk>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 07 Mar 2024 13:03:28 +0000
Nix <nix@esperi.org.uk> wrote:

> On 28 Feb 2024, Mariusz Tkaczyk spake thusly:
> 
> > On Wed, 28 Feb 2024 14:40:22 +0000
> > Nix <nix@esperi.org.uk> wrote:
> >  
> >> On 23 Feb 2024, Mariusz Tkaczyk uttered the following:
> >>   
> >> > Release stuff is not necessary in repository. Remove it.    
> >> 
> >> ... it's actually pretty useful to have the ANNOUNCEs there for people
> >> building from the repo. Given that the changelog is not updated, having
> >> a summary of changes *somewhere* without having to grovel around in
> >> mailing list archives seems like a thing that shouldn't just be thrown
> >> out as "not necessary".  
> >
> > Agree, we have to maintain it but in simpler form. I will create CHANGELOG
> > instead. I will copy the content of those files to changelog, with some
> > modifications.  
> 
> They are a bit of a mess at the top level though. Maybe move them into
> misc/ or a new doc/ or something?
> 

In other projects files like that are handled in main directory. I should
consider moving code into "/src" directory, udev stuff into "/udev", man files
into "/man" instead.

If you would like to try create some patches to help me with cleanup I will be
appreciated!

For now, I'm working on following files:
- README.md - general instructions; what is it, how to contribute, etc.
- MAINTAINERS.md - instructions for maintainers.
- CHANGELOG.md - release stuff.

I choose markdown because it is most popular and it gives ".md" it the name:)
I should send them to review next week.

Thanks,
Mariusz
