Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FEC3A1C2
	for <linux-raid@vger.kernel.org>; Wed,  8 May 2024 07:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715152983; cv=none; b=Y0hx6gZErbRFsJzJ3zwrfarIyP71w8uZuvAxEJ49oBKvnQqeNus/oY+LNPAJgvLLOSRp2EcS4cZubL4aNsDPBPGDftIF7FVDra/TJ4K5SdliO+hGE0xty5Nc3BkYVrrg2SQH7anOcBSkCLCuNzeszO8u6V14uWyjrKCH+fhbvCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715152983; c=relaxed/simple;
	bh=aRKfYS1pHiSUbkA6ynJgs+8Egv4jaZsydyXcJSqrSVM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WC85H2pB/1hmm9B56sk58Zgiq7AAaMTWLnITpDyKvmS7SSJwVwCwFdXIK5mtLHPc8Q/zsJZJdKEFf6xn1Mvbb56KUq+QorNk0+iMtHLaGVA6SUnQUM1zqyl5dazzB3rjbQz6G/uXtgtThU0ekujzBoZw1yaJvlXEn71vypiBx5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n6nfst4s; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n6nfst4s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715152981; x=1746688981;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aRKfYS1pHiSUbkA6ynJgs+8Egv4jaZsydyXcJSqrSVM=;
  b=n6nfst4sLHMKqMcCvl+LmyUjFD0ofb4KVlfEoeH1hquBRPqkURN4ohcE
   jDVljs6d/Ub7/35Px6yJyMnH5as6viYfXyD3EQkl1EB/yw8erfRlIWKRk
   c9NcRCUqu8aGYUmoIWLG3sGtbE34QRxgXdD7hYuRdR69lUb446laen86H
   QX+BDSWeZUK3KqkdlJoc2fYZ5AuVMJEZhOphy8bqoei3iKTyoFyDjQZz+
   Wm6ejhQepNnBAK/9beG168vBt6DDuDDxpjwF7r5iJwDhkGUibtg5jM7qg
   U0s0433Ow38Tq79MYNdnIOzUP983ZYZkHC372qulFhG6v74BaNSniJWyx
   A==;
X-CSE-ConnectionGUID: 9Pl9fvYAS3m4RCAGKNKKWg==
X-CSE-MsgGUID: 5gx3Cc+lS6qXbLsMRnOGQg==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="14798316"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="14798316"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 00:23:01 -0700
X-CSE-ConnectionGUID: S5CdWWGkQxmJEiB1Elhpew==
X-CSE-MsgGUID: T4TlUpAWSX+WsrK9SsR0AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="28849449"
Received: from ktanska-mobl1.ger.corp.intel.com (HELO intel.linux.com) ([10.246.2.150])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 00:22:58 -0700
Date: Wed, 8 May 2024 09:22:55 +0200
From: Kinga Tanska <kinga.tanska@linux.intel.com>
To: Paul E Luse <paul.e.luse@linux.intel.com>, jes@trained-monkey.org,
 mariusz.tkaczyk@linux.intel.com
Cc: Kinga Stefaniuk <kinga.stefaniuk@intel.com>, linux-raid@vger.kernel.org
Subject: Re: [PATCH 0/2] New timeout while waiting for mdmon
Message-ID: <20240508092133.00001845@intel.linux.com>
In-Reply-To: <20240506212859.4044771f@peluse-desk5>
References: <20240507033856.2195-1-kinga.stefaniuk@intel.com>
 <20240506212859.4044771f@peluse-desk5>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 6 May 2024 21:28:59 -0700
Paul E Luse <paul.e.luse@linux.intel.com> wrote:

> On Tue,  7 May 2024 05:38:54 +0200
> Kinga Stefaniuk <kinga.stefaniuk@intel.com> wrote:
> 
> > This series of patches contains adding new timeout
> > which is needed to have mdmon started completely.
> >   
> 
> Thanks Kinga!  What is the end user experience w/o this patch? (ie
> what negative impact does this patch address? mystery hang?  missing
> events?)
> 
> -Paul
> 
> > Kinga Stefaniuk (2):
> >   util.c: change devnm to const in mdmon functions
> >   Wait for mdmon when it is stared via systemd
> > 
> >  Assemble.c |  4 ++--
> >  Grow.c     |  7 ++++---
> >  mdadm.h    |  6 ++++--
> >  util.c     | 33 +++++++++++++++++++++++++++++++--
> >  4 files changed, 41 insertions(+), 9 deletions(-)
> >   
> 
> 

Hi Paul,

we have an issue for R0 - if grow is run for R0 to n-number of drives,
R0 has to move to R4, then mdmon is started for it. After that, mdadm
finishes --grow command, and systemd runs --grow-continue to have this
reshape continued for prepared array. With new kernels, we noticed that
R4 has not enough time to has mdmon started during this process, and for
this reason, the next command, --grow-continue failed.
Another problem is reboot during resync, sometimes mdmon has not
enough time to start too, and resync has been not continued after
reboot.
That's why I've proposed timeout which will address this problem.

Kinga
