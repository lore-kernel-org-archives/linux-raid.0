Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE531F943F
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 07:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733126260; cv=none; b=C1W/cupuevnAGiAExvcsWAqf3ghWP2KQFJ/9Tshn/4k1Gi3IcX2rvqpFbIUWzNB//sIBJvZCi5VMjZgYpk43vyYDtsV/CA37n9oIZB9KOvNX5vVPpBMB2Rdl6sCjlnvNod8b2rAL3F5yPNvkkJZ+jYJ609n2P62loQz1oBuzwhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733126260; c=relaxed/simple;
	bh=RAZ27sA/FsHGYLBtVBS0pjMmqvrUMiKtWvIV5hg4fE0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Opvjf/nvtByTIMW3EThw9UwkTJ6wqQ2nh7OurKOFbSZwfr4Fw6D6jzj00BI7Hbi9uayIoIxWs1fjCFDtRr6eDj9DGlIq6Fwe8hznoeyiqPJ/0gCbVO2x/kP9SVR9QE/SJ/8MmDcUaa9ImvjU1+CsfMrjpl80QZgPZe/LmDfqyFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ef9n7TbH; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ef9n7TbH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733126259; x=1764662259;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RAZ27sA/FsHGYLBtVBS0pjMmqvrUMiKtWvIV5hg4fE0=;
  b=ef9n7TbHfDaIP5X6yLLBFd2TS33QidMf0U8D0qxZx3/jH95i0Lksic8C
   vmrYlQcRlIXyY4PoicqyD7AwEP0UP0mD5I7/jmcPR0D/27laTf7FdAoHF
   LaOJJqQdr5tRun5l6A/jqB/qWtdzYYdpajDdWiYkkQAcCL6CpzEpcZTOK
   ObS/6LRiKTYeGzKRy0IThBRqXWImK7WuV2Tfiac2lKw/3z66QKNHYnY1j
   jHw+HdSBPumWfb+S1kSnVQnd8hS0oCe9mb4FZPUSV2LdYLtQuQQAqx0hQ
   aFQiU6EYi/nXnUwx9tg9hwtyKS1YH+VhQGCtO/zGeiTq9Z4Y1/KmLP/Xt
   w==;
X-CSE-ConnectionGUID: xH3cz0wARTiuNerBjxiNzA==
X-CSE-MsgGUID: Qeg7Um+JQmC7Y9MLRRwcqA==
X-IronPort-AV: E=McAfee;i="6700,10204,11273"; a="32635148"
X-IronPort-AV: E=Sophos;i="6.12,201,1728975600"; 
   d="scan'208";a="32635148"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2024 23:57:38 -0800
X-CSE-ConnectionGUID: 4R8VABSnQA69zjT4ifuHfw==
X-CSE-MsgGUID: jjsEEYMATYWmIxoGM613GQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,201,1728975600"; 
   d="scan'208";a="93513264"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.120])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2024 23:57:37 -0800
Date: Mon, 2 Dec 2024 08:57:32 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v4 mdadm 0/5] mdadm: remove bitmap file support
Message-ID: <20241202085732.00001138@linux.intel.com>
In-Reply-To: <20241202015913.3815936-1-yukuai1@huaweicloud.com>
References: <20241202015913.3815936-1-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  2 Dec 2024 09:59:08 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> Changes in v2:
>  - remove patch to support lockless bitmap;
> 
> Changes in v3:
>  - add patch 4;
> 
> Changes in v4:
>  - add patch 4 to change behaviour if user doesn't set bitmap;
>  - add commit message about external metadata for patch 3;
> 

Hi Kuai,
LGTM.

I opened PR to test against our changes:
https://github.com/md-raid-utilities/mdadm/pull/133

If all fine, I will take it and make a release soon!

Thanks,
Mariusz
