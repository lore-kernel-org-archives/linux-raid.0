Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A696F52A
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 13:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709212250; cv=none; b=uClsY5NH0ue1HKVHB6I/rNrJQ61DnI7Fa6duGu/6WcitWrVERPRrmJTLbHJdcFYhF8cIEXhzLyyV6oup37+vsONmbOXe0tvq5BbI2FuDSepyKuz+2+fQAbru+J96GDHFfmL2yecCOQMKXe6UUk7BT2YagdIS5XzAmCgtm6CPIHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709212250; c=relaxed/simple;
	bh=z94gwGhSir8hJ4hoxE5f6bkaBG54/sI8imuiAHkcLTU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eE8MDvp5BU7lu2p4jNzRIqfOmmX0UjpwtI0vPlcKUnuV+HqR//rjtRWe71A6AyY5h3JRoC8CO+oiLdDBbkfIxe6GvrFy35h1qGTgm0SMae4kcyjpDa2W83EvXkwTQ/LsuukxO1VrPQ8EgmSC1I7kEZ5pWbXaFVyqCYpfWJ++gaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IYZy/9hH; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IYZy/9hH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709212248; x=1740748248;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z94gwGhSir8hJ4hoxE5f6bkaBG54/sI8imuiAHkcLTU=;
  b=IYZy/9hHIhw09e1KvyHkLKou9qmr96BYBsvpoQ5V1h/oXnUcAxpad2hp
   3VniBHaxEfdS+Q0hTG4NZF5728yeYYHvRJA8hGuaDoHkcNzzpZmzRyuHW
   jNxzEEi9oWA+pNcC2NO6xZH2vmjg7YcbJfsZaC3z0ME/vN0SuXHnvLTkD
   oE7SYAVn5ZleYGZ0MEV2LerrvJWdMjApNmCOroA12eJ+S7plK4S2nY/o2
   ss2D75lEjwC1Wga4oB07YYQ4o/vn2tLUi2qSxFPvDySPWwuht8rtAzbjJ
   xkhfSrbuxu3egdmIo36lViPapncVIydFA1/YnGhPPA9EhggqYpjCN9DiU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3845878"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="3845878"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 05:10:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7728591"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 05:10:45 -0800
Date: Thu, 29 Feb 2024 14:10:41 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH 0/1] Fix regression when no PID file
Message-ID: <20240229141041.00004df3@linux.intel.com>
In-Reply-To: <20240228153720.12685-1-mateusz.kusiak@intel.com>
References: <20240228153720.12685-1-mateusz.kusiak@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Feb 2024 16:37:19 +0100
Mateusz Kusiak <mateusz.kusiak@intel.com> wrote:

> Following patch is a fix for regression introduced by commit b7d7837128e9
> ("Monitor: open file before check in check_one_sharer()").
> 
> This prevented Monitor from starting if there was no PID file in
> /run/mdadm. 
> 
> Mateusz Kusiak (1):
>   Monitor: Allow no PID in check_one_sharer()
> 
>  Monitor.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 

Applied! 

Thanks,
Mariusz
