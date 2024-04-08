Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4D4482C2
	for <linux-raid@vger.kernel.org>; Mon,  8 Apr 2024 09:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712568211; cv=none; b=k/4QXTUDA6zic8lBDXxrMrIerIj2+iubRKsRX7AyE5dDMBN22q1P4VGKiOtGH4nN8xSbcbmefzx2y/teJPUOYhYlAq9auodOrm6Ma4fU6i6RPc6eOhkTunaGiccAeYJg+Eyvfc/+VATi3lPCk7poAwWkhJXxhELhI8K3TMmCjaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712568211; c=relaxed/simple;
	bh=o9MgaIesql1SVpqHcgjcEo9khnq4YU6mHBOSWQU3+I8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XqVouXGnP3kPktVs8dUqzA1rb8b4aRSgW8dzv8LIW1ZwrLWLxQmZTgg3yF4y+QIqtIvbzdDeWD4En2Mx3gVHzOwIgnxnwuCLtM/DvkDFUrFR1EV8au/SfzZ2MKNVEIUeL4UwFdt/CYLBtk92hc4pIMamU4x50/Gg3AUy/FT6oyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n8jGwIRP; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n8jGwIRP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712568209; x=1744104209;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o9MgaIesql1SVpqHcgjcEo9khnq4YU6mHBOSWQU3+I8=;
  b=n8jGwIRPtLEDWxDHGYX8EujvEsmXIf1JrjOPemVz/gSl85PdaxECBbOE
   U3DsvfAcbu2dHRWfwe6IRRQfeV8u3yE9AhaUVjeEyvbq6DOvN0EFpJAjn
   rNq+kDHE5OyUbruFK/7x3UqRA/KgsbVFSXsBJ0jTZ81nCdnc0LBjLH8RJ
   IcluYDlmhFToAbxwhBafodcqiJYKRXBeoxXqxh1yIJC+4glga/wXPj0uD
   h5SnpwNKxcyLeUxRUDUejchUYIZvXFQ8BfZpsLb2/Iv7hmUxeHUvxOjlG
   /u5KUgfsmz0XgzfoZDOA2EXwLR+GtzmKCFQKP/Ek4zOKnYdQRY99E82eW
   A==;
X-CSE-ConnectionGUID: hUGtphRDT6q/Wxyl8v24cA==
X-CSE-MsgGUID: 1f/4hxuUSVqqoEqK8L0fWA==
X-IronPort-AV: E=McAfee;i="6600,9927,11037"; a="11666874"
X-IronPort-AV: E=Sophos;i="6.07,186,1708416000"; 
   d="scan'208";a="11666874"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 02:23:29 -0700
X-CSE-ConnectionGUID: UL2Cj80tT+mUP7GGnDjSGA==
X-CSE-MsgGUID: bb05mb0rT+ar0MSFpcS74w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,186,1708416000"; 
   d="scan'208";a="19913633"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.1.223])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 02:23:27 -0700
Date: Mon, 8 Apr 2024 11:23:22 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Jes Sorensen <jes@trained-monkey.org>, Nix <nix@esperi.org.uk>
Subject: Re: [PATCH 0/3] mdadm: Add .md doc files
Message-ID: <20240408112322.000012f8@linux.intel.com>
In-Reply-To: <20240326122112.25552-1-mariusz.tkaczyk@linux.intel.com>
References: <20240326122112.25552-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 26 Mar 2024 13:21:09 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> This is an attempt to document some flows for submitters and
> maintainers. It removes ANNOUNCE files in flavour of one
> CHANGELOG.md, all releases are ported to this file.
> 
> For sure there are missing sections in README.md, for example I didn't
> provide compilation HOWTO. If there are no objections I will do that
> later.
> 
> I pushed it to my github to help with review:
> https://github.com/mtkaczyk/mdadm/tree/add_md_files
> 
> You can either report suggestions here or on github. I will be happy
> to answer.
> 
> Cc: Jes Sorensen <jes@trained-monkey.org>
> Cc: Nix <nix@esperi.org.uk>
> 

No feedback,

Applied!

Thanks,
Mariusz
