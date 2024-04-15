Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24555763F8
	for <linux-raid@vger.kernel.org>; Mon, 15 Apr 2024 15:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713194697; cv=none; b=ofg4TRUFw7l5t7wx2g6kszmRd41fPROIwsoz8Zm5Btdb7px83n2W0f1sEJTLIEkaWwnTzNUYkvvH1iDYUUSR0ETx0007Wo2eLEwW7Ihd6VgxSttlDWrUoA7HA8fN0jpRGj+EOeXOs2rXitM60MjAGPkpDOL7VtpVL5tJ9rsLNzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713194697; c=relaxed/simple;
	bh=uEc3f4BNI1M1Ex4YAdwbXiKq9007eeuFQTU226f7nOA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jkG+Sqdd+ZwjqrnhQyRJFpRk405MjXZBF9Mr3c7w4RtcUAYzwgUyCIXB6hSa19/x4M6D/UF0jfYLlPx8Q0q2XQE6IcYYT+uMMbMgjSukG49Xu46yi6+fwU+kOD5+vr4dS8O5Dm1xczmivaBRcklwRTy30zvsMPS/x1hgY6UL9ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DoXayML2; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DoXayML2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713194696; x=1744730696;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uEc3f4BNI1M1Ex4YAdwbXiKq9007eeuFQTU226f7nOA=;
  b=DoXayML2Tj3+Ppyu950cak1QnZAysyx1J8hSAnMB6G3vl30JgbPQtreO
   ooASdIg243JyP/0zjZUsMZSpg7DI5pVgnCS4wy3nCV13JBFR7exA/1TOK
   hphaRi/qEhbQ9zB5TReEYHr1kf2E6UsPbVuSZCT/MZlo+TTdF0UhqRANa
   NP0I5PsLqqB9lfZkGCAZwBGbvPnRpamnBuBq7yQMHbpm2y/D2UkPU8p/7
   pfdL4gzJP4M9OopVA77U/JZHR8xwFit/CNRWK2t2bG+xGCMPp97OdLwnm
   eDYZFVRtHySKNW/2w319ox9N2FsTQxDl+ZpaFUJ7I6wZOn0Nob/pH45Wo
   A==;
X-CSE-ConnectionGUID: nYwwUJHiS7WWAOPpajOVVg==
X-CSE-MsgGUID: y516SPGnT2iivgaYRUmnpQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="19983539"
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="19983539"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 08:24:55 -0700
X-CSE-ConnectionGUID: 3ch/fNqXQWm6jOIGcSd2cw==
X-CSE-MsgGUID: DxCBrE/cS8WjU1TDgltUKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="26730786"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.113])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 08:24:54 -0700
Date: Mon, 15 Apr 2024 17:24:50 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Fabrice Fontaine <fontaine.fabrice@gmail.com>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] Create.c: fix uclibc build
Message-ID: <20240415172450.00000597@linux.intel.com>
In-Reply-To: <20240412164513.6829-1-fontaine.fabrice@gmail.com>
References: <20240412164513.6829-1-fontaine.fabrice@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Apr 2024 18:45:13 +0200
Fabrice Fontaine <fontaine.fabrice@gmail.com> wrote:

> Define FALLOC_FL_ZERO_RANGE if needed as FALLOC_FL_ZERO_RANGE is only
> defined for aarch64 on uclibc-ng resulting in the following or1k build
> failure since commit 577fd10486d8d1472a6b559066f344ac30a3a391:
> 
> Create.c: In function 'write_zeroes_fork':
> Create.c:155:35: error: 'FALLOC_FL_ZERO_RANGE' undeclared (first use in this
> function) 155 |                 if (fallocate(fd, FALLOC_FL_ZERO_RANGE |
> FALLOC_FL_KEEP_SIZE, |                                   ^~~~~~~~~~~~~~~~~~~~
> 
> Fixes:
>  -
> http://autobuild.buildroot.org/results/0e04bcdb591ca5642053e1f7e31384f06581e989
> 
> Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>

Applied! 

Thanks,
Mariusz
