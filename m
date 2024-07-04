Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15841A2555
	for <linux-raid@vger.kernel.org>; Thu,  4 Jul 2024 09:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720086171; cv=none; b=JM+hPL5wdOTbaYMbkfY7JBQdC7GYBndm3ZMLXvEBuytWfpuFA9FYTEanjScI1ZI94RBXv8RPuIP9CJokIx3vYVHwLRebHuKeLmcEJ8U3WztcWs5BoS5Fbn2hR0ApGDSEPYN2xh/L1sa9RsOMi27S4AOh9wkOXMzF/9ZNweUOIoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720086171; c=relaxed/simple;
	bh=QtYXq6GPOpnbaOKefQfwJHdwwAHlKrfJbz2iaKhGuL0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=aj0LMrd2B5f1Jl/VMLApt+URMMVgTbDWgl6O3CwdcRXydQEEl7cmpr6YnXvYcbyan94a/ZB2SgQfWmlL8IVlWSeOyh9B0X/QHlHIQ3FTiB6eELVoSn9xj1wv3VjoFHTLq3WUXz+7GJ6HSVvLcPialvXqCc7v7C+5vcCi2KpUBf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZgIuW9nr; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZgIuW9nr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720086170; x=1751622170;
  h=message-id:date:mime-version:subject:from:to:references:
   in-reply-to:content-transfer-encoding;
  bh=QtYXq6GPOpnbaOKefQfwJHdwwAHlKrfJbz2iaKhGuL0=;
  b=ZgIuW9nrC42RJOl+aiBAsyBFH2qznuHwJPycOiI4D+0b67loKK3AdYJr
   q87U9Cm11KFlRfoEqpcat3EMrni1fF71MHG4ckfMt74yGIVEUJafmvpVb
   qRFHqhmOdK6fo8bwdCQJaGy2PN/CJPtZa2t1MDMQunNhx+Qs3f4mjlNUF
   uCMfqV7daSgjUqwRVzElhuv3vOk2KDqVn+HbL8BtJAqJ9FPCsHmuk4bGk
   lNtxygfjzvIlOZjBm5GJdthzv4Xx8dpmgst3z8sjRXu5LyS2yweufEoMp
   /qq5ak3wByRbScva74qln1ruarDxVdCTK6L5gYLFwHdw61Jyb2K/+iipI
   w==;
X-CSE-ConnectionGUID: 73c7d7NnRz6bpmn03zTVEA==
X-CSE-MsgGUID: xrSPb+0vTSy2sKiMSMRi0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="17490959"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="17490959"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 02:42:49 -0700
X-CSE-ConnectionGUID: eOv2IBxMRlOLKtwnD96lqA==
X-CSE-MsgGUID: s1KxeSxMSEqHDoy4Y/BIEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="46509904"
Received: from mkusiak-mobl1.ger.corp.intel.com (HELO [10.246.35.139]) ([10.246.35.139])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 02:42:49 -0700
Message-ID: <3e3cdb1c-db76-4332-b7b9-f53ae6723013@linux.intel.com>
Date: Thu, 4 Jul 2024 11:42:46 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: MD: drive removal hangs with freshly created partition
From: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
To: linux-raid@vger.kernel.org
References: <5db667c7-56dc-4283-9205-9bfde1affd5d@linux.intel.com>
Content-Language: pl, en-US
In-Reply-To: <5db667c7-56dc-4283-9205-9bfde1affd5d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02.07.2024 16:57, Mateusz Kusiak wrote:
> Hello,
> I'm back with another regression found in SLES15SP6.
> 
> The scenario is as follows:
> 1.Create RAID 1 volume with native metadata.
> # mdadm -CR /dev/md126 -l1 -n2 /dev/nvme[0-1]n1 --assume-clean --size=5G
> 
> 2. Create partition and filesystem on raid volume.
> # parted -a optimal /dev/md126 mktable gpt mkpart primary ext4 0% 100% -s
> # mkfs.ext4 -F /dev/md126p1
> 
> 3. Remove device via "--incremental --fail".
> # mdadm -If nvme0n1
> 
> Result:
> Mdadm hangs and hung task info from mutliple components starts appearing on serial.
> 

FYI, this is fixed by: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=855678ed8534518e2b428bcbcec695de9ba248e8

More info: https://github.com/advisories/GHSA-93q3-24jj-x39c

Thanks,
Mateusz
