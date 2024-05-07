Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222EA13C3E6
	for <linux-raid@vger.kernel.org>; Tue,  7 May 2024 07:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715068046; cv=none; b=PMZyXuNyPmEgK2MYepBvmxqXiPEC1bW6CWokO816hRvz5TOrIhifjpnzNmOJOewmiLr2DILUHTrgY2KnVkeFIc7qZPDPkFqxVW/AHhJqrUSH+aKjRo/I4cD/tVH3kNgGzUg0g7IclqQF4ZU2i5smQlVbPHGVC3VePeCNznwaDsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715068046; c=relaxed/simple;
	bh=tBk1W2YG+ZSvLPv8vzJxZfaji1yf+2BFPOjATe4OF2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bek+DEYcVrdwhx/VVLDG/YVv+d7q/HmIyHHEW/bcBLomWUYdrqSyxK6Wnkq1F/8BV7MWcgXWnvlFI79dVApUKOPxyJRAfK11sSn6LMw/2P/xLQcH+I/hymr7ODzOiKAG/tJZfQl7N6ybdQhupgzT6MK3DCfCgywrK1koed2VQ/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EyN1d1YN; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EyN1d1YN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715068045; x=1746604045;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tBk1W2YG+ZSvLPv8vzJxZfaji1yf+2BFPOjATe4OF2Y=;
  b=EyN1d1YNNEKLoe7+DyzbvDipVjtSAc/2pgQ7xrUojYJQDSE2eiD1UX73
   LH0c3UNJNwl9n+0//+YbGXsVMQbgVFS7Fj+QXcAmyIeN2w/g971fr6qcI
   +uAjgn3UzsDXXWu6hrvXE5xbQfIKrhSarv7QJfZ6nV3zHLHAFHBv+749i
   zDKLkmltDIPX7S7U+uYtZ3zl8jSh/XQQWaa8jd5HlDPaQhgTrnZD08F3W
   1cajWVxiEQIJHKn3rsU+64AMDfBQm8pe6e7O889tb7rzqoMG2aB8zW9Tr
   Y2QiZ5Q5tWO8o5PKmoWctIfnz8FGsbNoEnjNCFCtlLvuM5Ts4KjWz2Wsk
   Q==;
X-CSE-ConnectionGUID: lhwNHnk/Sj2Dw6Uv4RDKPw==
X-CSE-MsgGUID: fh9abvuURTGb85c6zSE7QQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="11060198"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="11060198"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 00:47:24 -0700
X-CSE-ConnectionGUID: O6fY7zWbR3C3LuPMvRWCaA==
X-CSE-MsgGUID: 5RuY0KuOTMyRBLnio1ynVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="33103247"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 00:47:23 -0700
Date: Tue, 7 May 2024 09:47:18 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH 0/8] Add R10D4+ support for IMSM
Message-ID: <20240507094718.000026ea@linux.intel.com>
In-Reply-To: <20240429130720.260452-1-mateusz.kusiak@intel.com>
References: <20240429130720.260452-1-mateusz.kusiak@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 Apr 2024 15:07:12 +0200
Mateusz Kusiak <mateusz.kusiak@intel.com> wrote:

> This series of patches adds support for RAID10 with more than 4 drives
> (R10D4+) to IMSM.
> 
> Mateusz Kusiak (8):
>   mdadm: pass struct context for external reshapes
>   mdadm: use struct context in reshape_super()
>   imsm: add support for literal RAID 10
>   imsm: refactor RAID level handling
>   imsm: bump minimal version
>   imsm: define RAID_10 attribute
>   imsm: simplify imsm_check_attributes()
>   imsm: support RAID 10 with more than 4 drives
> 
>  Assemble.c       |   7 +-
>  Create.c         |   9 +-
>  Grow.c           | 143 ++++++++++------
>  mdadm.c          |   2 +-
>  mdadm.h          |  25 ++-
>  platform-intel.c |  58 +++++++
>  platform-intel.h |  32 ++--
>  super-intel.c    | 433 +++++++++++++++++++++++------------------------
>  util.c           |  39 +++--
>  9 files changed, 419 insertions(+), 329 deletions(-)
> 

Applied! 

Thanks,
Mariusz
