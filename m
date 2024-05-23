Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440A412B16E
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 14:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716475161; cv=none; b=ZfJNZfJIVMVJrkfZ921UYbQ1ZekeRUYv/TVVRUOfYNYJJh5KZ2gAmFYjrzYGSiJUig6aMQZMdIdDCgH1s5c59mftlwkbS8E8meYrznb/ZJw4Fn/ytyZpXzBdQvLzxiPFTI+0mv2G1VjXmMiR0pCyk9GLyDgcl0Oj6I3e9bpzZTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716475161; c=relaxed/simple;
	bh=ORU3rKVuDwEehzkgJJK7GfPsMhUp6iKzfBTh5NyQ4L8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uWD5IsWpBUjJUqRxvo9F1iZAvQBPDRkom/pRURzIVcx7PoCuY3/88a4Mh/CT4F+O5jmYTu3BcjoBuZx2TLD+GPmBPFKCGdQNJFTyyoSTSv78t2D+Y+wqGmP/Te/n4fPIa0FQ49qR1vLC1xHbZngF6ezQpCwXYokuasYo+/wF8fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UTEpPqU8; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UTEpPqU8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716475160; x=1748011160;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ORU3rKVuDwEehzkgJJK7GfPsMhUp6iKzfBTh5NyQ4L8=;
  b=UTEpPqU8gtS1VgvvE+EMvkXYdRoOVS1BeUOzosX8gWLDykjahltLLKgB
   UvfMKUO4LN1qRdGf+LFrOIdW+5rzYsTAl2RBUZm6oJj7RvinwzDWEzbZk
   G33eQXHHatCUvoaX2ykH150+9VcCdyljSHaTTEgh07kHllDA5DIXsYfSS
   hNKP52+BoJth8T8raxlyaC/Fdb+IWAgdxJl2AyXJIa6MqYAkLMUv42XvA
   uI9WMG8oIgvU1izd7yBpMyCZTCRt7yImfzXqEHtdFkfx+GYbUV0p019xK
   rHGQRyoF/NvBeDb0iaEmXQ0H3W1UgN/TRKowdZXFrfwsJ1dJAdLpSKKFc
   w==;
X-CSE-ConnectionGUID: R/idG3aERCKSe3quwK8FbQ==
X-CSE-MsgGUID: I23Vl7S1SEK5UsgJiL2HMA==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="30328410"
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="30328410"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:39:19 -0700
X-CSE-ConnectionGUID: GmtGxEZqRLu8VH9WRX/RPg==
X-CSE-MsgGUID: qC5DsxBJQrKdFcyszq448A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="33665153"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:39:18 -0700
Date: Thu, 23 May 2024 16:39:13 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, heinzm@redhat.com, ncroxon@redhat.com
Subject: Re: [PATCH 07/19] mdadm/tests: 03assem-incr enhance
Message-ID: <20240523163913.00003520@linux.intel.com>
In-Reply-To: <20240522085056.54818-8-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
	<20240522085056.54818-8-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 May 2024 16:50:44 +0800
Xiao Ni <xni@redhat.com> wrote:

> It fails when hostname lenght > 32. Because the super1 metadata name
> doesn't include hostname when hostname length > 32. Then mdadm thinks
> the array is a foreign array if no device link is specified when
> assembling the array. It chooses a minor number from 127.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---

LGTM.
Skipping for now, obvious conflict.

Thanks,
Mariusz
