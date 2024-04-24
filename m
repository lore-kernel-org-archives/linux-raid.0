Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09407142E67
	for <linux-raid@vger.kernel.org>; Wed, 24 Apr 2024 06:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713940884; cv=none; b=TSWE3rchegzgEWhuoV2zndwwxRqJ4sspYwPWmPop4ki9BoKirZMe73hZL4g7hGrz6qpKWQgwF4Q2bV0x3ELuFU0HeWBtYktLdZFtmMRaOhCbbnssngnQM8cCtcnX1fqCIlv1KyrSJ9u6Q0vhpUkXMq9MUrYv4pMeJPFnGsrQrvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713940884; c=relaxed/simple;
	bh=iMvtSHmmBRVWv0WI/U8nrpalJcORoPVoVPNhONJw8YE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=TxySVC1w0moVhqoO6PeYWnNALmt8/8biWmnKUnuGrb4cWeiMBSw/IafFsiE9/nDBOueokkHCkK2ahEzSZq4nYHhwxAIErJ6ArVJF5Svm8sJNO9jbUWPXFVLtQfS0xyhJo/YsdhACR7mA/dNEddqJROy+eFbC98yOmlovCr1laLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DQFDh0Lq; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DQFDh0Lq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713940883; x=1745476883;
  h=date:from:to:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=iMvtSHmmBRVWv0WI/U8nrpalJcORoPVoVPNhONJw8YE=;
  b=DQFDh0LqRJVlTPexaXhZsnfYA3v5S4Uc2QEAGWiNU/V2/fqxI5h4DTnF
   +v4/Q5LDmMx+yGo6PxBVLUMo5TcIqDAz0bsxTSTkiKGeuSag9lUQ4/aaO
   S6uZYzMID2iyKwyMgVxJpsDt1kIqPVtIvjbd3XIJIQ2/7NJFjBvVnOiVk
   NvMDnTVar4GrdMNzDxmSxS9lyrDrqfSNvM5nez5RR81/keDtxFKRQn4sb
   fwIYEavAaeUnje4VbT0F+wKEOkIglSAo5M+QNBpSIR92Xws+01a/rD2NG
   5eDb7mS/ZhQhsFJiUdhU6OwWEVt+1TX+KlobAbdJbz8LudHI/2Upe2o+v
   g==;
X-CSE-ConnectionGUID: WO/7Q90fTXi9YFZmgWdXJA==
X-CSE-MsgGUID: zx63l5DGT0qFSqxjQrsGwA==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="10093131"
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="10093131"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 23:41:22 -0700
X-CSE-ConnectionGUID: 849vkzRdTYq+lt/uStza/w==
X-CSE-MsgGUID: bnlKotaaSUGJU0mrbHCd0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="24652442"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 23:41:21 -0700
Date: Wed, 24 Apr 2024 08:41:16 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Subject: Move mdadm development to Github
Message-ID: <20240424084116.000030f3@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello,
In case you didn't notice the patchset:
https://lore.kernel.org/linux-raid/20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com/T/#t

For now, I didn't receive any feedback. I would love to hear you before
making it real.

Thanks,
Mariusz
