Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A55814BF8F
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 14:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716474345; cv=none; b=V8eSltMKYty2MIffNVryhuYV8Lrs2W9+mgCBMzNvGtS07FmqrWJwNYJGYE0Do87zPtRwB5KPa9XqyHzJWIVbQb1NAU2Qpkjc0RvzK34jCuf2sd/5HzWCRKm/2on/n6PK6aRZ6RVrP4Sa5JNf3atcnUeNcL4xEMCvU6HDvD9I+D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716474345; c=relaxed/simple;
	bh=gS28OZSVbjZAIhQNoEkjwkvAMb7EO64BtlDEanO0jws=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IiaVAYVHCtIci4iSuD/JEKmHrjquc7KqpwZgeznn9m9oQamIXR33pxtT6la5U0sfldkKpCNNBK2eIvSZa2m+y1cwaGXndK8sfPct51XKh3YEG1WBB5M/FbZOszNys/Op1UUYoA5RvgTJ7CmXJZ/PnzLpGByCMtyVyPNTUml5WJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZNQIPKYR; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZNQIPKYR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716474344; x=1748010344;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gS28OZSVbjZAIhQNoEkjwkvAMb7EO64BtlDEanO0jws=;
  b=ZNQIPKYR5UYVpKF6KoHcLzkVbtFBq36G7ShBeEipkBdC33ngJvNTQE7r
   mGHyxPC7hMn2cEzkD9FobPqJFn0rAlHiyfa1JbkQSX7ntbCG2gqh+2eik
   5teSyeeVSel+JADa3i9l8TSXpyIDKcF3fGjEGky4BG0JOJ1KzsIKBxv0V
   U36I2pwqhYIhj7wThIRaQ626gMVEajO7ZnJc4LGxsw12aOYcxqpo2sgaB
   UZGW6z1HIEydhMVt42QjPkZxdBnvoYoEbpEhNqK3UM+KTc1rYDTE8cbOg
   B0UywhxPfTVVXFhUxodIqCC7AWl22VTwWdawoA0McxmJhxhrp8M6+H8pL
   g==;
X-CSE-ConnectionGUID: Ep+n9NziRhGlqpSGe1eJIg==
X-CSE-MsgGUID: uLtSlRmbT9eoKrw8s0V0Yw==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="12573803"
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="12573803"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:25:43 -0700
X-CSE-ConnectionGUID: Q0zr6yogTkCf/EnHJuhKjw==
X-CSE-MsgGUID: B+B/9QrpS8KAAyrmGWMAFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="38526441"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:25:42 -0700
Date: Thu, 23 May 2024 16:25:37 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, heinzm@redhat.com, ncroxon@redhat.com
Subject: Re: [PATCH 03/19] Don't control reshape speed in daemon
Message-ID: <20240523162537.0000620b@linux.intel.com>
In-Reply-To: <20240522085056.54818-4-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
	<20240522085056.54818-4-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 May 2024 16:50:40 +0800
Xiao Ni <xni@redhat.com> wrote:

> It tries to set the max sync speed in reshape. This should be done by
> administrators by control interfaces /proc/sys/dev/raid/speed_limit_max/min.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
I totally agree.

Applied! 

Thanks,
Mariusz
