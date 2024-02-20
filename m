Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E0F5A7A8
	for <linux-raid@vger.kernel.org>; Tue, 20 Feb 2024 13:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708434434; cv=none; b=jQlLHqZrI6mkkaK+1SGKh+lQbkhMp8WrUs1Zy28JNt8bxBHH6NjAol3HSaDBuhIBVTyH+JaRgj0Q6oyl4z7YUCpyjrKmEfsUmRXzyZE+3Z/znqkAivtesftY6t/jZq69dct2gJv6hgeIA2C4aCx3oB5lIoY/A2hsXaD+1a/iRHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708434434; c=relaxed/simple;
	bh=5dmRMIDa7BKBvx3bBRJ78zScM1kDw7fiAbfzJY0sgAY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SrhJef6znChkU3GCyPKuXW4OfCQNvCBJYBre7LMLg9ll6/wi3Js0fsV8qEjww8hszGeJR6wKkgRzsZKlpvg2PC4e4KS11HteczJdi4FeXX4ZacbtkedOxpJD24qhcDakFhGa2Cb39wwH1dKGiA6YOxrp0Zp1d0MixEQbjWW911Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H/8DQa3X; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H/8DQa3X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708434433; x=1739970433;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5dmRMIDa7BKBvx3bBRJ78zScM1kDw7fiAbfzJY0sgAY=;
  b=H/8DQa3XFD21QdeMbHQf7e/jvAq8u0c7mDdv/vJ9WfRbvpIIBis0It6V
   rxkRc2BL9duGuj1Qu/stWhm44D8oRsMQMGl+Zx+GEKjPeWeye+zbbJVrM
   f6eji4AYXclsGPpu8AMORJ5K2aAFyCco6H9zGMH0fuD4/jbvLv6MIXXbX
   38NgGkfvXuwcZDeJ5Bg7Q4Rhkm56CinM1it1tKHwrabltlBpRJZlz7tMG
   ud6Fb8p+HOEsnG/vNxlFmtUTx4RcY8fz55mByWDc2j2jv8DSmINDOxcun
   LQzjc/W0dxN8eN4tx8RNViTDIBb5ICmv9mYdMOK/FL7XkXtN00r8fORGZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="27979227"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="27979227"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 05:07:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="9414589"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.1.223])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 05:07:11 -0800
Date: Tue, 20 Feb 2024 14:07:06 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH v2 0/5] Fix checkpointing - invasive
Message-ID: <20240220140706.000019c1@linux.intel.com>
In-Reply-To: <20240118103019.12385-1-mateusz.kusiak@intel.com>
References: <20240118103019.12385-1-mateusz.kusiak@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Jan 2024 11:30:14 +0100
Mateusz Kusiak <mateusz.kusiak@intel.com> wrote:

> This is the second half of splitted patchset "Fix checkpointing" as
> asked. It contains invasive changes regarding checkpoint handling,
> that should not be merged prior to release.
> 
> Note, this patchset applies on the first part "Fix checkpointing -
> minors".
> 
> Mateusz Kusiak (5):
>   Remove hardcoded checkpoint interval checking
>   monitor: refactor checkpoint update
>   Super-intel: Fix first checkpoint restart
>   Grow: Move update_tail assign to Grow_reshape()
>   Add understanding output section in man
> 
>  Grow.c        | 13 ++++++-----
>  mdadm.8.in    | 21 ++++++++++++++++-
>  monitor.c     | 65 +++++++++++++++++++++------------------------------
>  super-intel.c |  3 +++
>  4 files changed, 57 insertions(+), 45 deletions(-)
> 

Applied!

Thanks,
Mariusz
