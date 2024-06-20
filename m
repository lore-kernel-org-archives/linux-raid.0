Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69221AB535
	for <linux-raid@vger.kernel.org>; Thu, 20 Jun 2024 12:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718887435; cv=none; b=mJLnJgVq8hpD5oNBPuxs1ehu+cP9vfh5A8Jva2TbjPSN0r34/mBrRmxTWFh3T4g6nj957ZikBu9QeLLelM5er3DTj3f+ObDgSFEjPgTvCrBI9u8RKmiXpWm6lGSlg2YnNtKSo4WTeY4x/TjtNFWqpp4dUNBYxFoGCHlVkfL6l1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718887435; c=relaxed/simple;
	bh=u9eJ5VeWJrPHdi38ooQlSUYISdJ+cJI43FnBfBBWMcE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=fwfrZDE4K3UIe1gYA9bfy74gaxQcBZb1ZgmVVeKc8T96epQhdIPIMFgvm6ah5hpG4jP+alJ9Gc4a5bZRclvKwVVaSbcXbeDtapq3XVf9W+7fW/hxvP99BIpxRhoiyCQCkqiP5wOvNyZE6N7cIY5bL0oBJbz2Z3eVP4AYnqbjPb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zm2ICgs+; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zm2ICgs+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718887434; x=1750423434;
  h=message-id:date:mime-version:subject:from:to:references:
   in-reply-to:content-transfer-encoding;
  bh=u9eJ5VeWJrPHdi38ooQlSUYISdJ+cJI43FnBfBBWMcE=;
  b=Zm2ICgs+6q/GiKMoox7EiMABMqt1H57RTmNq+gG0k9+uy2pV4X1ieZrW
   Tv9/N7f2kGhiV7CT8Vm4ezGy9oTAw2Cqsh1VKg749d5pc+4cQrUneLGkB
   OfM97ROybdNx0LZiY7wBaBupTTdF3HDwcWrNwBfF10APtsdewsoGgdhz9
   1PZlArFdihvUPrmaU7VR0m/YtPGGiNM9macVRjVVKPZOWazBblmWBs3e1
   dhAI+8mapy4C1hW9NTiYosLiSCnj1ChNFurLQJ3lZ06CYF3Yv+bw9AUF7
   pq2gXfDieXQfGX5IFsYXfk6xr29Z0eolZzy36UzXdjDc/JE66gcgpdoyU
   A==;
X-CSE-ConnectionGUID: bgo4eCUWQyW0v26aNYlrlQ==
X-CSE-MsgGUID: GpmHiOVLT9a5/GR1rrl8iA==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="12163217"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="12163217"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 05:43:53 -0700
X-CSE-ConnectionGUID: qJwL+ngaSuOGcvrpAC4xfQ==
X-CSE-MsgGUID: KhA3bF/EQE+SH4cXtjzLSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="42049321"
Received: from mkusiak-mobl1.ger.corp.intel.com (HELO [10.237.142.62]) ([10.237.142.62])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 05:43:52 -0700
Message-ID: <24cf4b0e-2cb5-4b50-8867-f7feadaf367d@linux.intel.com>
Date: Thu, 20 Jun 2024 14:43:50 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: MD: Long delay for container drive removal
From: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
To: linux-raid@vger.kernel.org
References: <814ff6ee-47a2-4ba0-963e-cf256ee4ecfa@linux.intel.com>
Content-Language: pl, en-US
In-Reply-To: <814ff6ee-47a2-4ba0-963e-cf256ee4ecfa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.06.2024 16:24, Mateusz Kusiak wrote:
> Hi all,
> we have an issue submitted for SLES15SP6 that is caused by huge delays when trying to remove drive 
> from a container.
> 
> The scenario is as follows:
> 1. Create two drive imsm container
> # mdadm --create --run /dev/md/imsm --metadata=imsm --raid-devices=2 /dev/nvme[0-1]n1
> 2. Remove single drive from container
> # mdadm /dev/md127 --remove /dev/nvme0n1
> 
> The problem is that drive removal may take up to 7 seconds, which causes timeouts for other 
> components that are mdadm dependent.
> 
> We narrowed it down to be MD related. We tested this with inbox mdadm-4.3 and mdadm-4.2 on SP6 and 
> delay time is pretty much the same. SP5 is free of this issue.
> 
> I also tried RHEL 8.9 and drive removal is almost instant.
> 
> Is it default behavior now, or should we treat this as an issue?
> 
> Thanks,
> Mateusz
> 

I dug into this more. I retested this on:
- Ubuntu 24.04 with inbox kernel 6.6.0: No reproduction
- RHEL 9.4 with usptream kernel: 6.9.5-1: Got reproduction
(Note that SLES15SP6 comes with 6.8.0-rc4 inbox)

I plugged into mdadm with gdb and found out that ioctl call in hot_remove_disk() fails and it's 
causing a delay. The function looks as follows:

int hot_remove_disk(int mdfd, unsigned long dev, int force)
{
	int cnt = force ? 500 : 5;
	int ret;

	/* HOT_REMOVE_DISK can fail with EBUSY if there are
	 * outstanding IO requests to the device.
	 * In this case, it can be helpful to wait a little while,
	 * up to 5 seconds if 'force' is set, or 50 msec if not.
	 */
	while ((ret = ioctl(mdfd, HOT_REMOVE_DISK, dev)) == -1 &&
	       errno == EBUSY &&
	       cnt-- > 0)
		sleep_for(0, MSEC_TO_NSEC(10), true);

	return ret;
}
... if it fails, then it defaults to removing drive via sysfs call.

Looks like a kernel ioctl issue...

Thanks,
Mateusz
