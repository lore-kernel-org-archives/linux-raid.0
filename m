Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2867D7C083
	for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 15:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706109578; cv=none; b=PpiK1rr2MuaqoTrCttTDcab6LQHPNu4fCsMtO1qn9DuKS0Oe9Xd0y1rwNJUVON/2n1b70+XVY+snyQcfUQV7TDQDpw7hMMHAPE+CZYpX+B0VTryLMTelvlUp5XA4aZxuzIFm+PTWspa55tv1OD4DY5RQ4yzN6/2ZtS/8uRqgo/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706109578; c=relaxed/simple;
	bh=xHIFJ7ZgRru/8sCi7GDNqYv7a4B6f2GnrdYZUH1behc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kUnz5iUloOeA4pIjgCRuMvM/2wonGUq/DlIZg0fIRXMm1zEHPShDB454AlNX4Y3Bfw700KSi7Zk/WA5SiMtrB+jYD+8KanBuiFINmiAs6L+TC7cFzQYf3LS0uRN4S6I8M6Ov7dGJKx5RwlNU9OYoeX6NJovPClDn7Pc3vWFQ+HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O9TNko8A; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O9TNko8A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706109577; x=1737645577;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xHIFJ7ZgRru/8sCi7GDNqYv7a4B6f2GnrdYZUH1behc=;
  b=O9TNko8AoNV2Xm/owb0rGuImASauFjR8fVEoDOSqWfCHYho4h2gYCfPr
   dMmqT9CImgPRt2fYystQuQ+6LixSo5tjTY24LsAlwJVA4axZ6QiwYgDiD
   y6Fd8KNagZhX1D/xYJUVbrnd/YplsUP8OO9tp9zw8crDqLonq5pmj5KmX
   iBPBvAKRlfK23gafGQmElazihON8g2JM+R+cyBerF3qAV0IyhIl+8m4EH
   jaWxV4nXbW4FE1VWbaBbxrgoXtH8nsqdc2MBaVD0I54Q9MU6Zxyeo0DdG
   Wv/izc6EhGYhTeYFMY3mHu8lRjRda4n0oB+L3Wq/qboRXYGUUUu9esH/k
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="8544804"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="8544804"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 07:19:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="856731990"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="856731990"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 07:19:28 -0800
Date: Wed, 24 Jan 2024 16:19:23 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH v2 0/3] Fix checkpointing - minors
Message-ID: <20240124161923.00006d90@linux.intel.com>
In-Reply-To: <20240118102842.12304-1-mateusz.kusiak@intel.com>
References: <20240118102842.12304-1-mateusz.kusiak@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Jan 2024 11:28:39 +0100
Mateusz Kusiak <mateusz.kusiak@intel.com> wrote:

> This is the first half of splitted patchset "Fix checkpointing" as
> asked. It contains minor changes that should be safe to merge prior to
> release.
> 
> Fixed minor things in "Replace "none" with macro":
> - Replaced hardcoded "null" size to "sizeof(STR_COMMON_NONE) - 1"
>   in str_is_none().
> - Removed is_none() on optarg as it checked only first four chars,
>   bad for user input.
> 
> I included "Add understanding output section in man" in second patchset
> to preserve history (adding it here, prior to release might seem
> random).
> 
> Mateusz Kusiak (3):
>   Define sysfs max buffer size
>   Replace "none" with macro
>   super-intel: Remove inaccessible code
> 

All applied! 

Thanks,
Mariusz
