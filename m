Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C426E22EF3
	for <linux-raid@vger.kernel.org>; Tue, 14 May 2024 09:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715677801; cv=none; b=iKec/vMTyW+qQgdpNDszfh35G3XV07MssBE6LlhsLVVFS8BPmXdU3lac752i+PAWAAqbfyHxP4gsOpyTSlOZkdacU2wgpMJDwCYGV5urGSWy+9pEW1npf3NV6h9rxHQUAmqdE+8HZgAYocM0cz5qBSqgmi8tEUCRsWf1kc2oOsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715677801; c=relaxed/simple;
	bh=rg04UjG2CpTS8FGK+pklra81gh3k55OLkkz6WhZVI10=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cWtI6ms0YNm/ZN5lhm1I3MkhIf6XYAr/luiV+0fxLsbx5ykvV2wkAzfDjHVYjggQDmsgvjXTywb3RuP7lidipmW6eDDcIXYvYvWaufb5zgzxFgrCM0Gp4In1ieQIHbTVTBPThJ709YASiJQRlexjgO8faQqZ6ParCyYb8dpg/I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EK1NcnSn; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EK1NcnSn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715677800; x=1747213800;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rg04UjG2CpTS8FGK+pklra81gh3k55OLkkz6WhZVI10=;
  b=EK1NcnSnrIIm2NhhOwnYcAYbVDl8pw8lyBiYrfP20FOLdVb7zrpRkMSD
   V4gu9a72KxxMK42Q4S0/xMlkxJ62wEaelhhHOd01OGuYipmFo8Hmil2rB
   PoCU1qey99bgaqPu8drNE0z6nQ+Z/fpxQvLgiaTiIqZ6kKK5v1Bz/lH7F
   C7OuBClkZYZdkVkoGcktiQaddUiMYMs2tk8VqRc+Y44cxwgRNJOg+8kZa
   19A2fRtI4BLuaat51OMP9xYqiVw9awf6VDJ26i9cKSHB3Qz8KDC3qiPRv
   BdWjkIvADtQlUeWXrsewmIbBs6QVHDWsJbEOmptTDdjbpW0HAx2TKXu1A
   g==;
X-CSE-ConnectionGUID: lCiMUzoEQXWjn6gfC6LzFQ==
X-CSE-MsgGUID: D/+cEMLuT4qDrCN9/uxx3g==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="15468251"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="15468251"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 02:09:53 -0700
X-CSE-ConnectionGUID: Y5//L8v7Ss+2HVsWaUplUg==
X-CSE-MsgGUID: /PAr4gv4R6yVDpic687qkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="30691825"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 02:09:52 -0700
Date: Tue, 14 May 2024 11:09:48 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH 0/2] New timeout while waiting for mdmon
Message-ID: <20240514110948.00006d80@linux.intel.com>
In-Reply-To: <20240507033856.2195-1-kinga.stefaniuk@intel.com>
References: <20240507033856.2195-1-kinga.stefaniuk@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  7 May 2024 05:38:54 +0200
Kinga Stefaniuk <kinga.stefaniuk@intel.com> wrote:

> This series of patches contains adding new timeout
> which is needed to have mdmon started completely.
> 
> Kinga Stefaniuk (2):
>   util.c: change devnm to const in mdmon functions
>   Wait for mdmon when it is stared via systemd
> 
>  Assemble.c |  4 ++--
>  Grow.c     |  7 ++++---
>  mdadm.h    |  6 ++++--
>  util.c     | 33 +++++++++++++++++++++++++++++++--
>  4 files changed, 41 insertions(+), 9 deletions(-)
> 

Applied! 

Thanks,
Mariusz
