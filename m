Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F1F433A6
	for <linux-raid@vger.kernel.org>; Wed,  8 May 2024 08:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715157342; cv=none; b=cmUsfxTbqIFObf7hKGWinitmcMu7ufgbmxIBVxI0PINnIbG6j0qDlYyd6LrKzpCyQeAf3qi+TSyL4GZ2dI+eQ4Y1zlTgGmpJ+cg7e4DcgePnqrSkkoXXPi5b+PU3XqA66aV44rhbsUfYe7DE/f+slEc5JREDQqVAUYNNu0bIBkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715157342; c=relaxed/simple;
	bh=pXYAjRAa5VDatJxHVS1eX59zONm/j4pIXP/ArGnp8pw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bYVqls42lj3unagihLCFpS+AoTNGJcbG0UBkQmLO2I1Lvnsx4pUYMFH1e/zRu/sJwzc+c7ujoWQFnreRtmpFwqT375QK8KQZMJOEB37moRskH3b0jP8FkV+IsuFF1MN+vuJi08rsLY5EjCU0xS+y1cHS2NVWrePL3VIhetXR6mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WS0McjKO; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WS0McjKO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715157341; x=1746693341;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pXYAjRAa5VDatJxHVS1eX59zONm/j4pIXP/ArGnp8pw=;
  b=WS0McjKO4xmh6NuB70vfVr8igJsS3BXTdQ7QcXOEPsK691HWeidldAQU
   cJeSmCtvFTo2fybpShAU8oWZc7Aiy7sWKArKJlbrTste5LGIUI7m2/NG1
   vJldUAs0hDbvmHLLAVSHBqG+TsYDeWmx+OtMMkJEPtTI5oAY62uUKaIKr
   82DsnEjXZv6WPjNEMWngLNgc61/guxLuH0F7gH8ILQTwvUIK1zBpZgnff
   yjXXgxm1lgdkewL1jUTqpsK0yPwunvWlWlvWQoO+u9BLiyZpCnWDKsyxF
   ObZPijWcj3kMGPCLl3xBEFs3ReCPTZbdRJfeFk6CNC9M0IPqTof8XGyBv
   Q==;
X-CSE-ConnectionGUID: xqklKVxpT3qkUvzfjEqUOg==
X-CSE-MsgGUID: IQqmwrY+Sm2zJ2bG+08kQg==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="11132919"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="11132919"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 01:35:40 -0700
X-CSE-ConnectionGUID: 6d4X5lBLT2eaiVIaoulOdw==
X-CSE-MsgGUID: 2c7HafttRlKLqbmtZUK4iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="33293879"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 01:35:38 -0700
Date: Wed, 8 May 2024 10:35:33 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, song@kernel.org,
 yukuai1@huaweicloud.com, ncroxon@redhat.com, colyli@suse.de
Subject: Re: [PATCH 3/5] tests/01r5fail enhance
Message-ID: <20240508103533.0000681a@linux.intel.com>
In-Reply-To: <20240418102321.95384-4-xni@redhat.com>
References: <20240418102321.95384-1-xni@redhat.com>
	<20240418102321.95384-4-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Apr 2024 18:23:19 +0800
Xiao Ni <xni@redhat.com> wrote:

> After removing dev0, the recovery starts because it already has a spare
> disk. It's good to check recovery. But it's not right to check recovery
> after adding dev3. Because the recovery may finish. It depends on the
> recovery performance of the testing machine. If the recovery finishes,
> it will fail. But dev3 is only added as a spare disk, we can't expect
> there is a recovery happens.
> 
> So remove the codes about adding dev3.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---


Applying this one!

Thanks,
Mariusz
