Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD0D63104
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 11:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708689042; cv=none; b=BJtIxVdcp2s8XtqbZ79rQDaSBa5ZzeYTtYYzKbRlukfkAkF7V7WsX6YIqBLqWv1tURGnH9FXbgPh1KNovH2vMY0Ve2zzxFoLrv1C+PX1/Gb4HUg37Gys8Thg3UTY6zePg4nNZWllzueH4cXhXFKIRm2pyTUw55iyXi9NVHRO5jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708689042; c=relaxed/simple;
	bh=N0/FgUsIdeNcwm//+i/aeDm9jvmfOxJ5earhrsq3qu4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L5PNEqVNiIfFR+m2rRfRSYF2sUi1Sg7C7kfCtPMlhHgCf6EQZDsgKkyNRlwU+k9lnJEGiv+a65yJSrFmuq/uSe5tAX0i6edv0c8a/2zKXaZoHLp7JHR5ZX1s0Gs2r8yvR73KVunsVUWGUU2sFjGDPPEqz2Y874vwEXYZXKHa4oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ktjxXVcD; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ktjxXVcD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708689040; x=1740225040;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N0/FgUsIdeNcwm//+i/aeDm9jvmfOxJ5earhrsq3qu4=;
  b=ktjxXVcDgkLnuB71Lp3rCBwCAF7/X/qvMwS0K3W9mzjqJ8ES882DJVCG
   oFV6GRZHEZ3k0YRkqK2znsHG32+7lX4P1RwrZp5ygMmbC1SxRqcKTAMus
   sjGGTG5FCrNq0IGo+n3W+uhon5uMg3uba35Mu3fE1biOkvFUPdUjcAl7g
   Ig5eoyfms92W+v5ZPsBMmP2t9e3PR2PI9cmaCa1XkJE0fp7lna+t7pzCA
   93gRcIn8yZ06VbwasxE7VqVO6CqRUxoOqjiAK3xfcB9lD0k2S4zLZqSzP
   JyyPYY1kwtplPmpqaB9ZvAOBDn671s3kI9sR9kN9HjqzrKS9tuRtBrFCZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="3156113"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="3156113"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 03:50:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="6261110"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.1.223])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 03:50:38 -0800
Date: Fri, 23 Feb 2024 12:50:32 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH] test: run tests on system level mdadm
Message-ID: <20240223125032.00001a68@linux.intel.com>
In-Reply-To: <20240220160444.3139-1-mateusz.kusiak@intel.com>
References: <20240220160444.3139-1-mateusz.kusiak@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 20 Feb 2024 17:04:44 +0100
Mateusz Kusiak <mateusz.kusiak@intel.com> wrote:

> The tests run with MDADM_NO_SYSTEMCTL flag by default, however it has
> no effect on udev. In case of external metadata, even if flag is set,
> udev will trigger systemd to launch mdmon.
> 
> This commit changes test execution level, so the tests are run on system
> level mdadm, meaning local build must be installed prior to running
> tests.
> 
> Add warning that the tests are run on system level mdadm and local
> build must be installed first.
> 
> Do not call mdadm with "quiet" as it makes it not display critical
> messages necessary for debug.
> 
> Remove forcing speed_limit and add restoring system speed_limit_max
> after test execution.
> 
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> ---
Applied! 

Thanks,
Mariusz
