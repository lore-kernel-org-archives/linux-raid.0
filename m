Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8615A433D8
	for <linux-raid@vger.kernel.org>; Fri,  9 Feb 2024 08:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707466310; cv=none; b=P05nc7EtyqZJP5ognkwR08NPKk48GjcEezRADHrm47m2PvJoO2uu9GjeLtEIu5jh1ldqSBCGH64YXueGnTbvedOWVYWnhFbxej5cgtOodjWBLFryWYlOJk6s6lMF/7w57Fau5uHvTrhS5EtzxC/8aBq1MCte0IMIGUOJ2lxKpIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707466310; c=relaxed/simple;
	bh=9ss6A2MmWSdq7x3gRnn/zScw+tnhNOOk6+NNAuoogU4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O1BtHSpsxkT0HzQxVNjuT7EKk3FqFqyiPcJUHD4bpKv6TyJsvZGohC/BVGw/W4reCjMb7wC4lxKTj6NYOwrRmTAa6051HrWCpTO6/J5piYPHZ0XloSQb+4h+zAnraTFnFSvtU+LIUbquBCmg5LKRSZjYpDtCH58weSFWt36EbPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IbcjfNLm; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IbcjfNLm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707466309; x=1739002309;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9ss6A2MmWSdq7x3gRnn/zScw+tnhNOOk6+NNAuoogU4=;
  b=IbcjfNLmCRWny26tuKutTQUwIQMe4rdF37yXJPVnDpgeK+BZVibiPc/W
   E9I6tDegWuq13R8qO+1TlsFOTEzJpvgfhs8G2iMSvDzQG1gbF3tFe0X/Y
   SFbZpzzGEJGhTNEgL7SYI7PPrk8T9wBr6l01bISISzdfpr/ELRSPO+gW4
   aqv2ZGDDhKBVA0Q+8NQNf0XMeXq4IFEGoDkXrWt2t08k+PrLWTDDzUfL0
   gCi1zWOrsZAwbBf847dXPmQiTpiyiEn8IPEaOOAAtFCNhtpWnv2a7pjJJ
   COkvbcnuWnorAklEvw5MYzna6UO8kURmxlcyhwnJvo1qvshxOPFvLCxk7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10978"; a="1523791"
X-IronPort-AV: E=Sophos;i="6.05,256,1701158400"; 
   d="scan'208";a="1523791"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 00:11:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,256,1701158400"; 
   d="scan'208";a="2260318"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 00:11:46 -0800
Date: Fri, 9 Feb 2024 09:11:42 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v2] Revert "mdadm: remove container_enough logic"
Message-ID: <20240209091142.00006534@linux.intel.com>
In-Reply-To: <20240205145029.12022-1-mariusz.tkaczyk@linux.intel.com>
References: <20240205145029.12022-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  5 Feb 2024 15:50:29 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> Mentioned patch changes way of IMSM member arrays assembling, they are
> updated by every new drive incremental processes. Previously, member
> arrays were created and filled once, by last drive incremental process.
> 
> We determined regressions with various impact. Unfortunately, initial
> testing didn't show them.
> 
> Regressions are connected to drive appearance order and may not be
> reproducible on every configuration, there are at least two know
> issues for now:
> 
> - sysfs attributes are filled using old metadata if there is
>   outdated drive and it is enumerated first.
> 
> - rebuild may be aborted and started from beginning after reboot,
>   if drive under rebuild is enumerated as the last one.
> 
> This reverts commit 4dde420fc3e24077ab926f79674eaae1b71de10b. It fixes
> checkpatch issues and reworks logic to remove empty "if" branch in
> Incremental.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

No comments, Applied! 

Thanks,
Mariusz
