Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA877E10D
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 13:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709212526; cv=none; b=HtCOhDsJyTpbO9q1YSILyt44skMWaecNARnqkRaTwaCFlwQ6KcMKvVQoWpOtSQtfDqTjSW5AQItealTIMhjSjzULeGkXKwRf+i+mgxwuCfkNrfXeM4ypLBcsrKnVDQxRV3CMjH5fLa4uH2WdyAWSOYBc/KqQP+sY9QLR83bRPqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709212526; c=relaxed/simple;
	bh=Z2baBKmJqnF8OfMwQwEHVX6IxKjuRdIrcV8OtpHsvlg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I2k+VRNxwtTBqYzG1jN6c00lkAKiB5GwJSzIld+KBCreDr7uiTwwT8B+ei7hOLocyhwIMKSM92ujVFNKokU46nXlqpvzMThua9hEklgPPTn5392On4+xy1+RUrPQ0XGo+Cp88oNMwj9zGKybb3hO2b86M+FfehtslyYJ6v30PkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SGYQNh1T; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SGYQNh1T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709212525; x=1740748525;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z2baBKmJqnF8OfMwQwEHVX6IxKjuRdIrcV8OtpHsvlg=;
  b=SGYQNh1T1pEYznXcGJF/6LA83V47TKr7ycFvrDrSwgzcuZ8sYY48lplj
   MybSJtuWJMfreZGXNyvvjO31NsKJ1wyabOwq5t7xKyfKH0XHHRU6BcSyx
   nRE8JubAPLlVHkp0JFvDFe03+JmdpiL0vw1xWuV8v712g7ygUl/RhBNG/
   sgFq4i7XAprwLjJvy9IsIFD8Y4q2Mpi6o1K6v2eV1Jtfp10k58lHLFx0s
   7lv7ZTR2rXINB/ACsGH2eKviWIBSZ+8BltulBG7/3P8nIeFbWyRuU6vts
   YLjsLrKdCxqUIB0vmoYjaF+hT9uU/cyFhKdnpvuwy1I9yjfy+ypujkePU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3843939"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="3843939"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 05:15:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="8246176"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 05:15:23 -0800
Date: Thu, 29 Feb 2024 14:15:17 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Kinga Tanska <kinga.tanska@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH] super-intel: respect IMSM_DEVNAME_AS_SERIAL flag
Message-ID: <20240229141517.00004058@linux.intel.com>
In-Reply-To: <20240227063639.31396-1-kinga.tanska@intel.com>
References: <20240227063639.31396-1-kinga.tanska@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 27 Feb 2024 07:36:39 +0100
Kinga Tanska <kinga.tanska@intel.com> wrote:

> IMSM_DEVNAME_AS_SERIAL flag was respected only when searching
> serial using nvme or scsi device wasn't successful. This
> flag shall be applied first, to have user settings with
> the highest priority.
> 
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---

Applied!

Thanks,
Mariusz
