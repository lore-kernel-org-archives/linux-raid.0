Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEAF129A91
	for <linux-raid@vger.kernel.org>; Thu, 15 Feb 2024 10:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707993721; cv=none; b=mZpNcNHTsUiclQlh/WitmH5B8jYbHLBcBdCL65QZn6c0nbuj0oTxq3VIZRPhmK6OvRNeP+ItFA7oe+QnlYGS1MYDokxrSLwVJV2N3lHaijrrf4DP0FGPURTydnsse81CL8UlhRaUlVmqPtE1ouVuBy0HCeab2FfnoLwDRhzKLLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707993721; c=relaxed/simple;
	bh=Qf/nfzAtR3K+wKubdb0HBnYC5fXm43BKqRElL2vHqjg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=h28Zcgfk//KtLaJE2uBYNVUEO0zZP2v+nyjINfK1reMOQpKDwgG9RLcXAsZqSnxZDGf5F3oVhFuFZxR/vtyTi6NNadDoQVXJzpjhIVsvp/J3JDPRz9ZzPzRoCQsPMcfvov2Qvf50tcEhTyu+XEq8smXyqvZh12gTE3PByBsrPj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SweIQwGH; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SweIQwGH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707993720; x=1739529720;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=Qf/nfzAtR3K+wKubdb0HBnYC5fXm43BKqRElL2vHqjg=;
  b=SweIQwGHPPhM1lkLCIoBOJyVmksz/Okn4Qdm63ZHCvzxI/bB1wUtHAiX
   PaGJ1zwBFFtt1pTOTVceD/Kyc2QY3fqmUV3EcbueXW+kZQPuyB79iQJxI
   BC3QpGbLfYwqkYTeAIQRFTFf9RjdsSjMETkDzB9smHeMbCvNYfR3J1Ycz
   KcAJr4XvRbLephbmjSrAZ9H+24xbmHrsjXTYNaXnUibBsTD7f9nVLAP4F
   /3gZ4dVHErjHkXlFvzFAGl0XNwG7naI4qlUeEU+3gdCgS1IHUBzLrAOhF
   MmirDv6DSwjHt0COSkL4HypzvJc5PN6WU6B3mehToy8PB1+PvmKIrF6F5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10984"; a="12788941"
X-IronPort-AV: E=Sophos;i="6.06,161,1705392000"; 
   d="scan'208";a="12788941"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2024 02:41:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,161,1705392000"; 
   d="scan'208";a="8104100"
Received: from mkusiak-mobl1.ger.corp.intel.com (HELO [10.94.251.99]) ([10.94.251.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2024 02:41:58 -0800
Message-ID: <561a0a23-c524-4af3-807f-622c3001da21@linux.intel.com>
Date: Thu, 15 Feb 2024 11:41:55 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Fwd: The read data is wrong from raid5 when recovery happens
To: Xiao Ni <xni@redhat.com>, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org
References: <CALTww2_4pS=wF6tR0rVejg1ocyGhkTJic0aA=WCcTXDh+cZXQQ@mail.gmail.com>
 <5ead30f5-31db-4175-bae7-e776a0be07ff@linux.intel.com>
 <CALTww29s1WupaVRSrEX1GbD=1Bt7b5cxseDnBLARkH1uHUhtCA@mail.gmail.com>
Content-Language: pl
From: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
In-Reply-To: <CALTww29s1WupaVRSrEX1GbD=1Bt7b5cxseDnBLARkH1uHUhtCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15.02.2024 04:23, Xiao Ni wrote:

>
> Hi Mateusz
>
> We used a rhel only patch to fix this problem. Now upstream patch 
> 45b478951b2ba5aea70b2850c49c1aa83aedd0d2 should fix this problem. But 
> there is a bug report against this patch 
> https://lkml.iu.edu/hypermail/linux/kernel/2312.0/08634.html. So we 
> didn't backport this patch to rhel and we still use the rhel only 
> patch. We'll consider to backport in next release. For other OSes, you 
> can have a try with this patch.
>
> Regards
> Xiao


Hello,
thanks for the info, I missed that this patch was merged with upstream.

On 14.02.2024 18:12, Song Liu wrote:
> I think 45b478951b2ba5aea70b2850c49c1aa83aedd0d2 have fixed it.
> Do we still get reports from systems with this fix?
>
> Thanks,
> Song
We tested this with much older inbox kernels. I will try upstream kernel 
to verify this.Thanks, Mateusz
