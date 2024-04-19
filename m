Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58133EA68
	for <linux-raid@vger.kernel.org>; Fri, 19 Apr 2024 07:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713511824; cv=none; b=fmZXzIZuEYvA71vUGU81uslau18U2auV7fY9XeykOm8JDkEUX2WtPNQi0luwkU773vwIUbplERRSjWjVmGw4I24O2Vyt8PtlcTjpAnHixlIq+Tlmyhp9nsgqd/uZTusIrqemIpZG6xQmFO8RF6PU8o9/m6TKAP/CxpmvGO2+DsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713511824; c=relaxed/simple;
	bh=tEpUvdmX6zhWLZgWsypam8Q7/LVrdKuzfGtYtiVgqio=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=u5Z9zXOmbr1ms6z1HYOCFhkgT7YPQPEbEOpqZF+zXpgiJZyyjpZk/q7hgYV4hfEnB+XGZ/JJR2btYws0PZ/uFchnk6jVRQegotUn01SFTJVKj+/tpg1ZyCcxlt57FEAoIpcme6Jvwj4aYc0Y6gkXUeQp/9RwrUHsbtNLHsQl+v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CHVwEco6; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CHVwEco6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713511823; x=1745047823;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=tEpUvdmX6zhWLZgWsypam8Q7/LVrdKuzfGtYtiVgqio=;
  b=CHVwEco6w4EdRs5336ESA007GqUtk+3GC2cNW3rOMqFK4BWoAfMTDL6R
   UFbg1Hm7AHL1wWq2dYy2rPxioDGc4FYs4nEbob4RDsmYtn4lKE0+eIBqV
   DHdWp/c5HlgmEYW/+sxQP1Dz6mKee8/7c0KwKZ1paI0GuA8x7CKMx97Ki
   6hZ9smSy1zUA9BN4NYLYD7wMzRKNrC0BmfAXe8Hn8PUjI62ti0f+GEtBq
   BeAo/hkaxjYqLt5kfTcQZn0fR6tBRVi0YQOwA5GfT2D28PmoKv2DZGElU
   BcM/5OXEcUXbTDOosftAzzD5pzjB+Km4/4TZvFvUpSkYR3H7z4jpJ3L9y
   A==;
X-CSE-ConnectionGUID: kILTouEZT6GasbpEm8B5RQ==
X-CSE-MsgGUID: JaFwiXsYTLue/HcWYh9jNw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="9023750"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="9023750"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 00:30:21 -0700
X-CSE-ConnectionGUID: c4ugFV2bQ/u/enxTVxRc3Q==
X-CSE-MsgGUID: BfvU1/1ySRqSWdjy9wpifQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23335149"
Received: from mkusiak-mobl1.ger.corp.intel.com (HELO [10.246.35.139]) ([10.246.35.139])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 00:30:19 -0700
Message-ID: <64f751b0-542b-474e-aedf-7d2b80f41d2d@linux.intel.com>
Date: Fri, 19 Apr 2024 09:30:16 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] tests/test enhance
From: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org, song@kernel.org, yukuai1@huaweicloud.com,
 ncroxon@redhat.com, colyli@suse.de, mariusz.tkaczyk@linux.intel.com
References: <20240418102321.95384-1-xni@redhat.com>
 <20240418102321.95384-2-xni@redhat.com>
 <bf7edcf8-9cb8-4349-ae34-a9ca5fa9cf17@linux.intel.com>
Content-Language: pl, en-US
In-Reply-To: <bf7edcf8-9cb8-4349-ae34-a9ca5fa9cf17@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19.04.2024 09:16, Mateusz Kusiak wrote:
> Hi Xiao,
> one small note from me.
> 
> On 18.04.2024 12:23, Xiao Ni wrote:
>> @@ -309,6 +322,7 @@ print_warning() {
>>   main() {
>>       print_warning
>>       do_setup
>> +    record_system_speed_limit
>>       echo "Testing on linux-$(uname -r) kernel"
>>       [ "$savelogs" == "1" ] &&
> 
> 
> I feel like record_system_speed_limit() should be called in do_setup() rather than main().
> Saving current system settings is job of setup.
> 
> Thanks,
> Mateusz
> 

One more thing. Feel free to add tag "fixes".
I broke this behavior (lowering sync speed) in 4c12714d1ca0 ("test: run tests on system level mdadm").

Thanks,
Mateusz
