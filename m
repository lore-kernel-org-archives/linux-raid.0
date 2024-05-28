Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BDB61FE3
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 07:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716880184; cv=none; b=A5kjRkAbkZOf1JSqF1fFQ6dGIjhYKyVSHnowpCfh7IRJZW4IOHzny0jjrWC2s+IR6C3blJw/F5R4r77tfTpzS6kuGR/+Px9ef5gDC5x/q2ubRF8LBIay1aC4csC41hStReS6k2MQs3DPU+86cNsSu2NXC8vz40NBK0hKW9L/Yqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716880184; c=relaxed/simple;
	bh=pBMFPSPyREpBWI7LGdZSNlrbOkmMiewp99uONdGAqSw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iP5txkv75FKyIjc8eatCfHGHif/6a/zujz/uj1nWaQFkdXCY6xG2fe1r5Cia+EJr8Uph1pf8/qMzuWiJMwSB+a5KZfQFqaCxclZviyVbOIG+2h9VbkHTMusX8q2dWitBgC8qYzYwGQCLFlWCA2/2mcdiz82u0qdxXyIhlkhqc6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=atX9UcaX; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="atX9UcaX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716880183; x=1748416183;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pBMFPSPyREpBWI7LGdZSNlrbOkmMiewp99uONdGAqSw=;
  b=atX9UcaXsh+2htaf5UKNVn/gzLC714xQXnPEnrk+vEHINvV0C3mVlA1b
   mYnYasJmk3nAvat1pxVKc2TtaEm7Q2JDSxSUVsEDJb1GxWZ+uuFL/eaDF
   bT3pCsU+bWtxerOdd/o6dsathH1iEjGc38g1SbjGR4zzKVHVpGP0MAfXv
   Gli3xv6ZHyxqH71lwCyU+HFjkzxKE5I1IvqF9Wx4lHEregQdYUAumu/7J
   1VRtNn5xn8GE3a2BPWsnzmc/qQRz97zMQhNCrHk05byIkpNOG0E8X32MM
   bc6S0KoUrCbhj2r/z55sOi9MceH3iTt0J4dDDTvSbsCQs0CdLG7xb7Cjn
   A==;
X-CSE-ConnectionGUID: s8goUFZmRpS7WpTgprmE3Q==
X-CSE-MsgGUID: L2fcebwtRZyb+T75G1Yw7A==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="35720348"
X-IronPort-AV: E=Sophos;i="6.08,194,1712646000"; 
   d="scan'208";a="35720348"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 00:09:42 -0700
X-CSE-ConnectionGUID: +JSNt5FkShO2igXfPbcY9A==
X-CSE-MsgGUID: +Uv+hq9BTdOEBM3LbFpfJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,194,1712646000"; 
   d="scan'208";a="39369290"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.75])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 00:09:40 -0700
Date: Tue, 28 May 2024 09:09:35 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: blazej.kucman@intel.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/1] mdadm/platform-intel: Fix buffer overflow
Message-ID: <20240528090935.00002526@linux.intel.com>
In-Reply-To: <20240528022903.20039-1-xni@redhat.com>
References: <20240528022903.20039-1-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 May 2024 10:29:03 +0800
Xiao Ni <xni@redhat.com> wrote:

> It reports buffer overflow detected when creating raid with big
> nvme devices. In my test, the size of the nvme device is 1.5T.
> It can't reproduce this with nvme device which size is smaller
> than 1T.

Hi Xiao,

Size of disks should have nothing to do with this. We are just parsing sysfs.
Weird..

> 
> In function get_nvme_multipath_dev_hw_path it allocs memory in a for
> loop and the size it allocs is big. So if the iteration number is
> large, it has a risk that the stack space is larger than the limit.
> So move the memory allocation at the biginning of the funtion.

I would expect that memory is deallocated after each loop but the fix
is correct and I'm willing to take this because obviously it is a fix for
something.

I don't understand the problem but I trust you. Maybe varied size stack array is
a problem?

Probably, enough would be to just replace [strlen(dev_path) +
strlen(ent->d_name) + 1] by [PATH_MAX] but I'm quite confused why it is an
issue at all.

LGTM. Please fix typos raised by Paul and I will merge it.

Thanks,
Mariusz

> 
> Fixes: d835518b6b53 ('imsm: nvme multipath support')
> Reported-by: Guang Wu <guazhang@redhat.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  platform-intel.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/platform-intel.c b/platform-intel.c
> index 15a9fa5a..0732af2b 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -898,6 +898,7 @@ char *get_nvme_multipath_dev_hw_path(const char *dev_path)
>  	DIR *dir;
>  	struct dirent *ent;
>  	char *rp = NULL;
> +	char buf[PATH_MAX];
>  
>  	if (strncmp(dev_path, NVME_SUBSYS_PATH, strlen(NVME_SUBSYS_PATH)) !=
> 0) return NULL;
> @@ -907,14 +908,13 @@ char *get_nvme_multipath_dev_hw_path(const char
> *dev_path) return NULL;
>  
>  	for (ent = readdir(dir); ent; ent = readdir(dir)) {
> -		char buf[strlen(dev_path) + strlen(ent->d_name) + 1];
>  
>  		/* Check if dir is a controller, ignore namespaces*/
>  		if (!(strncmp(ent->d_name, "nvme", 4) == 0) ||
>  		    (strrchr(ent->d_name, 'n') != &ent->d_name[0]))
>  			continue;
>  
> -		sprintf(buf, "%s/%s", dev_path, ent->d_name);
> +		snprintf(buf, PATH_MAX, "%s/%s", dev_path, ent->d_name);

>  		rp = realpath(buf, NULL);
>  		break;
>  	}

