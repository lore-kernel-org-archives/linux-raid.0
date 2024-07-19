Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6706BFC7
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 08:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721376156; cv=none; b=eLHfReJoBnIXE8jJ7P1mkZN6UWVfMWwV+H6GMHiI3tkvGMH4KbhskCi2RlJ3Osw+TEl+HTnd7xvGMVyPpAhGrbghpMUBaf87A5/bgvjgNvH82uREjZ9wCOp9PaX8cVpo1tMfnrO/lIAW20e7N/D5HPAIGrUIonfurF/MN9eRCr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721376156; c=relaxed/simple;
	bh=Ty94Cq+XnY2LUp5LLVpMS0KlTpC8/egyPwa6dIbuzeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kh0/Wxn8u2e53ZMcixVOm/tTyOAov8PXYQf01K0PUasumQlrwVC5rJyv4QRL4lyje2m6N/f8VzZv6BRghvSdU1g9zdJsVSWxnht29mJeFXXNwMLy22PhqnHX/EYkfK3/rjA9GhJXEfRGyNQo9raPeBIjtDNzpEdT3+asuajyKU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n9aYemlQ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n9aYemlQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721376154; x=1752912154;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=Ty94Cq+XnY2LUp5LLVpMS0KlTpC8/egyPwa6dIbuzeU=;
  b=n9aYemlQmpj+tdAWJ93Vw85G/cEQPRVvYDSb4irZF63BHttqGangFYTt
   mJVd7r1b/eyI8stYlv78M2Opwi7N4dQ+ruUmusRt3BufzYhvpU9OZBC+P
   5JJ4DqstIdi4DEY5FeyGz9iW+BczRp0WQAAIZ1xu/3auHv94gpICLTc+O
   vdKBi3cqTtmmeDlatbMec5xEY4L8VTvF+Nn2cJeFUKCb2aJyoiJ5DLFc6
   jdhfzjgJD9luBHRCWgVlc6HSj6oeA0WAVLcKShd5gxybmQsLvGqzMxXwW
   THzjh6JkOdeblLyzDF+Yp+YM7NY109J1ujyZNY0t5s/IExK6ftQSTQRG8
   A==;
X-CSE-ConnectionGUID: 0m4iPm/yRQSOKrbWvSoZIQ==
X-CSE-MsgGUID: VMkY1W9FSZqdF25IT5jOOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22742416"
X-IronPort-AV: E=Sophos;i="6.09,220,1716274800"; 
   d="scan'208";a="22742416"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2024 01:02:34 -0700
X-CSE-ConnectionGUID: aHORANXQT1CiLZc7C3ODPA==
X-CSE-MsgGUID: yxg8gV6dTJOYH6bMKHuotg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,220,1716274800"; 
   d="scan'208";a="74253959"
Received: from mkusiak-mobl1.ger.corp.intel.com (HELO [10.246.51.208]) ([10.246.51.208])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2024 01:02:33 -0700
Message-ID: <3564b25f-e754-4556-afcc-c6045d38e183@linux.intel.com>
Date: Fri, 19 Jul 2024 10:02:30 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: IMSM: Drive removed during I/O is set to faulty but not removed
 from volume
To: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <f34452df-810b-48b2-a9b4-7f925699a9e7@linux.intel.com>
 <f3d0f203-f9b9-04c1-e5a0-d61fc5c6c0d2@huaweicloud.com>
Content-Language: pl, en-US
From: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
In-Reply-To: <f3d0f203-f9b9-04c1-e5a0-d61fc5c6c0d2@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 19.07.2024 09:02, Yu Kuai wrote:
> 
> Hi,
> 
> With some discussion and log collection, looks like this is a deadlock
> introduced by:
> 
> https://lore.kernel.org/r/20230825031622.1530464-8-yukuai1@huaweicloud.com
> 
> Root cause is that:
> 
> 1) New io is blocked because array is suspended;
> 2) md_start_sync suspend the array, and it's waiting for inflight IO to be done;
> 3) inflight IO is waiting for md_start_sync to be done, from
> md_start_write->flush_work().
> 
> Can you give following patch a test?
> 
> Thanks!
> Kuai
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 64693913ed18..10c2d816062a 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8668,7 +8668,6 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
>          BUG_ON(mddev->ro == MD_RDONLY);
>          if (mddev->ro == MD_AUTO_READ) {
>                  /* need to switch to read/write */
> -               flush_work(&mddev->sync_work);
>                  mddev->ro = MD_RDWR;
>                  set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>                  md_wakeup_thread(mddev->thread);
> 

Hi Kuai,
With the patch you provided the issue still reproduces.

Thanks,
Mateusz
