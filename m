Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A562B1EB37
	for <linux-raid@vger.kernel.org>; Tue, 12 Mar 2024 12:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710247041; cv=none; b=jA0/FkjnnNBUWG3oiInAvF3sK4ziCndBR3HHqm+vhaYix+GQLudbXXyjNZB7EqMBjdWxp27tgFd/pgPOYLt+mSyIGoJY3uYL+Hhbvglf2lHRIsQT3JYQGiHMMdNW2ekc9st+coYrpn5xphgKas4lvwcLVciPAHVq4WwITDG66mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710247041; c=relaxed/simple;
	bh=NnD83IdxEO9XBPjtwW5NlA31cAdx6D879lG/7jXzAac=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sM6vufWhgMUhZz/uW6LsSaWlykH/DARGmKG7HhNMVSirh0+AKvIdVtfkrhr180p3gnIf0Kow2aLbED4gx4vR3B3h95jQj6Ih5EKxr7SP+va40ym+5TeHWqoJ13RufLQx4c1pRrOrT0muGEcvmErKuCOIOH6xZhkusWEBU8kRv+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Op36M0il; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Op36M0il"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710247040; x=1741783040;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NnD83IdxEO9XBPjtwW5NlA31cAdx6D879lG/7jXzAac=;
  b=Op36M0iltd55Yx2dDFe+TWmilkk+HGTwNeshAHLrr7lXCv9QDtVZRSYZ
   /IPEpzILGYwj/GSLKIA7o5gtP4gs+iVl1U68Du4HiMT3JAvcYD/qntfbV
   f6NaDY0rxkYomYczOeGHiArd3EENe2xe3tNP4tbNwzT5yZAEBbu647/O4
   lOf7KPnTCBWN0A61wX3lhEsAzYmo96TJDnu4gpAT5ag81oVRA6NkhtQtR
   X8mzlIuLB0sVovOakRwq4fQwsPAf0pbSiX1+VZTuwp4Hu3uAz4eiG03ym
   SS4Ko/ro9GOhK+Wd7+m71OQXQoqa9W4tls2SZ7PISyhKOoKRNjJUyKOPk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="5078063"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="5078063"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 05:37:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="34701074"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 05:37:18 -0700
Date: Tue, 12 Mar 2024 13:37:13 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH] mdadm: remove inventory file
Message-ID: <20240312133713.00002771@linux.intel.com>
In-Reply-To: <20240306124553.29390-1-mariusz.tkaczyk@linux.intel.com>
References: <20240306124553.29390-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  6 Mar 2024 13:45:53 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> It is a file with repo content list. It is outdated already.
> Remove it.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
No comments..
Applied! 

Thanks,
Mariusz
