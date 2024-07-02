Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552BE1DFE3
	for <linux-raid@vger.kernel.org>; Tue,  2 Jul 2024 14:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719932263; cv=none; b=BDi5bsJJsrjVhd+sUSDaujpPxZ4HHa5gAgnWsF+JEmDKmf2R96fRPIQk0IGFqeuXJJtx1KTeSVNAt4vgS0xINzdED2Lbptza6uka0e4KlNb29yHWImDF2mhNwhOpZqi8Z0YLSevU+wvxGIPE9kU85/0X0Z7mOYodp44x0k22PLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719932263; c=relaxed/simple;
	bh=3pL/xt/e+zb1cxSWT0PKaeWNq1QH1rm+vsxB/RzE9R8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=JMRBPGjgfve7HEE7GS/oRa4Ek/8G9S9wz+Qp7641v/re4OmEWz+Uc3P3T8zuCQ9kQkgwwDpaEwZ6wDVBQothez2n2IYYkK8bpCjGit1V5DHL8Hktms2G8xtJ6eil/0j8j301ykeGIX/05Kv14Y2dI4TRmQGc+LWSUXfE889L8YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LDyCwzDy; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LDyCwzDy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719932263; x=1751468263;
  h=message-id:date:mime-version:from:subject:to:
   content-transfer-encoding;
  bh=3pL/xt/e+zb1cxSWT0PKaeWNq1QH1rm+vsxB/RzE9R8=;
  b=LDyCwzDyDZjmz8Pq8Uz2EXe/x58F4REZFdL8SfY0QnhCv1mlwIT7kPN3
   I/nUUuhAU/4OjYf1WGNo3+FE/gmaWAvhrQh8MrPYMJ27l0xOh8S+KKaDX
   wDvrzvyjG+ddM5yAeG2kYKY1rtZ6PerHtUiaIEhiaFL7glldA1zZ6vauk
   LvegAFT34Om1BGDRqd5wmV8CHy9faBxpLLANOnri/ahekXbaiSk11vmFL
   AKawdSacvsSPuoCuNM85I0ZlBgbdTTUNMVx2Zvr0bOKh7E54n3Y+3IJz5
   Vqy1Wsd2xTsmY2qdoxis15aTzzY6NdaGGUIVQICE9np09PJDoHTlMAGNG
   w==;
X-CSE-ConnectionGUID: tQg7c6W2TlCRKWdWQXs8XA==
X-CSE-MsgGUID: /T88ZMphR1m+1SP9snR1iQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="28244646"
X-IronPort-AV: E=Sophos;i="6.09,178,1716274800"; 
   d="scan'208";a="28244646"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 07:57:42 -0700
X-CSE-ConnectionGUID: vs2cn8GZREqsYAC90Kzj7g==
X-CSE-MsgGUID: 7Gnz13pzSlejyV+ylaSEFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,178,1716274800"; 
   d="scan'208";a="50545754"
Received: from mkusiak-mobl1.ger.corp.intel.com (HELO [10.237.142.105]) ([10.237.142.105])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 07:57:40 -0700
Message-ID: <5db667c7-56dc-4283-9205-9bfde1affd5d@linux.intel.com>
Date: Tue, 2 Jul 2024 16:57:38 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: pl, en-US
From: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
Subject: MD: drive removal hangs with freshly created partition
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,
I'm back with another regression found in SLES15SP6.

The scenario is as follows:
1.Create RAID 1 volume with native metadata.
# mdadm -CR /dev/md126 -l1 -n2 /dev/nvme[0-1]n1 --assume-clean --size=5G

2. Create partition and filesystem on raid volume.
# parted -a optimal /dev/md126 mktable gpt mkpart primary ext4 0% 100% -s
# mkfs.ext4 -F /dev/md126p1

3. Remove device via "--incremental --fail".
# mdadm -If nvme0n1

Result:
Mdadm hangs and hung task info from mutliple components starts appearing on serial.

Few notes:
* Issue does not reproduce without creating partition and filesystem.
* If array is stopped and reassembled before step 3, the issue does not reproduce.
* If partition is "reused" (metadata was cleared, new raid volume created, partition left in tact, 
no recreating partition) the issue does not reproduce.
* If "--set-faulty" and then "--remove" used (instead of "--incremental --fail") "--set-faulty" 
succeeds, "--remove" hangs.
* I verified this is not mdadm issue by installing mdadm-4.2 (SLES15SP6 has mdadm-4.3 inbox) and 
rerunning the test. Outcome is the same.
* Writing "remove" to sysfs directly has same result.

Thanks,
Mateusz
