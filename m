Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4059F1C4A2B
	for <linux-raid@vger.kernel.org>; Wed, 16 Oct 2024 08:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729066481; cv=none; b=PmgdkGk5Kj1K8ZJ4WDagigb5gRuZZqv4fAcrR/PArh2RWfG+uyEBDGkpzWUIThlXO+vCJ5jHigboFnV/fXK6Kwuy3WTqq11fhqBpcoVQs8hGnnqEIrCXh8K3YwQO9LrD/haDw9bNeidZz67voyn7qLETAEedY0WWdzXfieHhq2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729066481; c=relaxed/simple;
	bh=ifI0+xNjnVEkhet+KsSqvugZfZJE0IQQgNvONCNkmIc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hnd5mUA2pSAg7XmZJKvVZjJOVBQM9zJN9baXT5PLuvlZMnbzwwEdx8j0Gqyyc/SrKyyM9mVwiZXvZgJ6/rar4e8iXFqqcneevX6ECFBGJIERg7xSZFslj1AJ4xktMRwMd11OmrJRTw51uj+qefhZpagv3U0uIStiwnGnJX8DNj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dnvRPC5R; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dnvRPC5R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729066480; x=1760602480;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ifI0+xNjnVEkhet+KsSqvugZfZJE0IQQgNvONCNkmIc=;
  b=dnvRPC5RqWLFiJYNEF/GclpP8E9LUlU8LLPFxX7jZjL33P1HMbDWngOv
   tmIiQMX0RL8x1jEOY4D8y5ttVIDUpDc6iwvLAz3gcNGfHEgisl3ox9bgS
   E2Rn1WL41IIwsv3nGOuy/2FXCsGYWOiP1QA5jV7cXQeASXcOXZ4dPmfAh
   Pxi6m1UTHk1FnSbDBe/ZJ9zSDJ6eDV0X2V68yq+mdKlfsZ5l/N496rl4G
   nJves296PGc6VeRNEuXBZrFjdI+2O2bCpdmIVdkr8IRK2CurlWrJAuo3R
   VB04fyVxHDvjGqQY+Qthh8ELOD/FQEjmYyY9K5iq3coeRAn677NDHQUPN
   w==;
X-CSE-ConnectionGUID: p4uWw1SJT52avyQ2Q1CFOQ==
X-CSE-MsgGUID: QPX1WVuFTQSH0KDKP0MAQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28645118"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28645118"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 01:14:39 -0700
X-CSE-ConnectionGUID: PEKGPl+CSceNygoTtP2nJA==
X-CSE-MsgGUID: YUdf/4ccQ9ml9cWemx3LxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,207,1725346800"; 
   d="scan'208";a="83227532"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 01:14:39 -0700
Date: Wed, 16 Oct 2024 10:14:33 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Laurence Oberman <loberman@redhat.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH] Add the ":" to the allowed_symbols list to work with
 the latest POSIX changes
Message-ID: <20241016101433.00005bb9@linux.intel.com>
In-Reply-To: <20241015173553.276546-1-loberman@redhat.com>
References: <20241015173553.276546-1-loberman@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Oct 2024 13:35:24 -0400
Laurence Oberman <loberman@redhat.com> wrote:

Hello Laurence,
Thanks for the patch.

":" is used internally by native metadata name, we have "hostname:name". We are
searching for it specifically, for that reason I think that I cannot accept it.
Name must stay simple.

If you want this again, I need to full set of mdadm tests that is covering every
scenario and is confirming that we are able to determine hostname (if exists)
and name in every case correctly.

There are some workaround in code for that, I can see that we are not appending
homehost if ":" is in the name. It is not user friendly. I prefer to not
allow ":" to keep in simpler unless you have really good reason to have it back
- there is no reason in commit message.


> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> ---
>  lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib.c b/lib.c
> index f36ae03a..cb4b6a0f 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -485,7 +485,7 @@ bool is_name_posix_compatible(const char * const name)
>  {
>  	assert(name);
>  
> -	char allowed_symbols[] = "-_.";
> +	char allowed_symbols[] = "-_.:";

Because the function has been made to follow POSIX, this cannot be simply added
here. Please at least explain that in description.

It is not POSIX compatible with this change.


>  	const char *n = name;
>  
>  	if (!is_string_lq(name, NAME_MAX))

Thanks,
Mariusz
