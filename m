Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2897D110A
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 10:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718187340; cv=none; b=OtFBZbsUg4cwnOp5+sVVLQH3bDEJ5y4w+Xl156RgvrkWoE+S9KJ4OGz4uvYN4OPZ+5MaX0MSIxV7PTl3/LZRXagYJak2ZsNw7+JfOCi+AkLpJ8vWBaAY4qL8T1NtaMPxoWPeLcZPpwhQ/izCmBjJCrljd6Xc9IE7JovsAblWAMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718187340; c=relaxed/simple;
	bh=Ri2P5qEMKq9oUl5PLFOLUtJ4KWaJc2+DylnxowXzFKM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wqw19CqWCfEujUtnhiGdNClpTJ+zkE4VZnGPj+UEYJ/AIHOKhzmN/N6D0Ov/i2B/UwH1LDus1hNAFH4C44I4C3YmZwwakEEqzSNqVX8hVGW4fzO8z0uhxUfTXVz9USHk/pTnDN/wmz13c6xTIrL+V19Lf7DiQ3pYQgggF4tgoK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lprra4Wh; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lprra4Wh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718187339; x=1749723339;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ri2P5qEMKq9oUl5PLFOLUtJ4KWaJc2+DylnxowXzFKM=;
  b=lprra4Wh2LOBZM3g2xHLHiJb7ZPTbKHCbRQXgbUH7Ek42jsNj8eTw5wS
   fSBGdCk2Ou/ENkGxCzWr59KAItHRhCxJ2SmLNQdLeyIVtbhjKChoZejnl
   S5tfRyIFr+J1OloxIj3cZ/wRWWrKSPYAzaVJgz74V0QIMnQXtoxVkNYab
   T5bKk42ueSOqvGg/wD2BDtfN/ai8HduIlQYgknbkNiUu5TFX9BpmnCPlh
   DWZspn51/VC+3Q8Su6j48Zm94AvZfZ+GW8NvqX3waJ4VsaQCQn6UxpLln
   riNVZ8+g32GW0CI5mVefApAgat2WBQWyVGLPwCIYtipTJ561ntHqU1Bz9
   A==;
X-CSE-ConnectionGUID: aCHNWDtvRQ2pna5VYpUiPQ==
X-CSE-MsgGUID: uvMVEK9YSNqC97b2S4FasA==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="26348928"
X-IronPort-AV: E=Sophos;i="6.08,232,1712646000"; 
   d="scan'208";a="26348928"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 03:15:38 -0700
X-CSE-ConnectionGUID: qHXc8aIQR/CcD5ITz/AHMw==
X-CSE-MsgGUID: YjmWoF/2QUycqiTlHcHWjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,232,1712646000"; 
   d="scan'208";a="44308439"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 03:15:37 -0700
Date: Wed, 12 Jun 2024 12:15:32 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>, Xiao
 Ni <xni@redhat.com>, Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH mdadm 0/2] Bug fixes for --write-zeros option
Message-ID: <20240612121532.00006aaa@linux.intel.com>
In-Reply-To: <20240604163837.798219-1-logang@deltatee.com>
References: <20240604163837.798219-1-logang@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  4 Jun 2024 10:38:35 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> Hi,
> 
> Xiao noticed that the write-zeros tests failed randomly, especially
> with small disks. We tracked this down to an issue with signalfd which
> coallesced SIGCHLD signals into one. This is fixed by checking the
> status of all children after every SIGCHLD.
> 
> While we were at it, we noticed a potential reace with SIGCHLD coming
> in before the signal was blocked in wait_for_zero_forks() and fix this
> by moving the blocking before the child creation.
> 
> Thanks,
> 
> Logan
> 
> --
Hello Logan,
Thanks for fixes. LGTM.

I will fix typo when merging, no need to sent v2.
I have proxy issue, I have to solve it first.

Thanks,
Mariusz
