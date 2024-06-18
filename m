Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B9616CD03
	for <linux-raid@vger.kernel.org>; Tue, 18 Jun 2024 14:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718720707; cv=none; b=kciMzqegoPLPdlXURW3eluich2RyPkrj1fip8Gi5P4TrB3/ZwcDkLFeVlTjGiVrVc274blmoo5kprF81bYvbVDBHhmhci88/15LdHahkYwrc86jTIyEQJWpdPJaumrWjRsrkib5J3VelFz++7aNE8hG4N/8WMsS+0V3bpQ/oBiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718720707; c=relaxed/simple;
	bh=SLxEVLo6CmEGicWOz5u4tE1JnudFY3VBAFcfPhDdBo8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=aOD08kpf6+E0mrrGiZwrNcQdfO5OqlKWqzvB3nXJsUsFWysJeOZ96JTTyUzE64r+zIsnsrtISzRT5DVuLs0pKp7FpgfeiAwye4kwiNOxBBbnmMlHIt9jBg6z4RyatMHQ5dophQTv7oD5oz94Vsy3U3zQPVUpInXbRwJFMLPOLrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V+yBYo3M; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V+yBYo3M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718720706; x=1750256706;
  h=message-id:date:mime-version:from:subject:to:
   content-transfer-encoding;
  bh=SLxEVLo6CmEGicWOz5u4tE1JnudFY3VBAFcfPhDdBo8=;
  b=V+yBYo3MYJTIAtbLBTPD/BTdeJ8tgxclhfTQUkyFayy2z9GlnjKZ9NRq
   gDsJKzflTsOXtci5bOXPWHopI6/FCGIdsLzbMWRSCSNYD1WpikUErXauD
   9ASLQyGAEb4tun+Zk/ujVSzoxTiuewB08Uir4Rlkt7AuZ2xnKLfd/Rqo8
   w1yj90MhFvLY/sS/5NzaJRI/ZmH+CwJwo05DFB+/AYalSpJcA67wBFj5I
   30hJfdZTo6zFINrGULsjol3PELFBfNsoxVmpCKdD+vRos9FYo9zjTMSco
   HsNA/8WOwJaYuPMbuguag14+lYxxuLbYoILEXmfnebcI8UqjT67MEapUK
   Q==;
X-CSE-ConnectionGUID: 2bN27KDnSp6GSCQdeWRpnQ==
X-CSE-MsgGUID: UfYos2GPST2sQB9F6Ae/6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="15365644"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="15365644"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 07:25:06 -0700
X-CSE-ConnectionGUID: tAuxlQclR5infYSFlvUl3g==
X-CSE-MsgGUID: r+GinJYESbm384wB8B45oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="42047701"
Received: from mkusiak-mobl1.ger.corp.intel.com (HELO [10.94.250.10]) ([10.94.250.10])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 07:25:05 -0700
Message-ID: <814ff6ee-47a2-4ba0-963e-cf256ee4ecfa@linux.intel.com>
Date: Tue, 18 Jun 2024 16:24:50 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: pl, en-US
From: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
Subject: MD: Long delay for container drive removal
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,
we have an issue submitted for SLES15SP6 that is caused by huge delays when trying to remove drive 
from a container.

The scenario is as follows:
1. Create two drive imsm container
# mdadm --create --run /dev/md/imsm --metadata=imsm --raid-devices=2 /dev/nvme[0-1]n1
2. Remove single drive from container
# mdadm /dev/md127 --remove /dev/nvme0n1

The problem is that drive removal may take up to 7 seconds, which causes timeouts for other 
components that are mdadm dependent.

We narrowed it down to be MD related. We tested this with inbox mdadm-4.3 and mdadm-4.2 on SP6 and 
delay time is pretty much the same. SP5 is free of this issue.

I also tried RHEL 8.9 and drive removal is almost instant.

Is it default behavior now, or should we treat this as an issue?

Thanks,
Mateusz
