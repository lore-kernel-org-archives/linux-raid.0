Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9158B142E92
	for <linux-raid@vger.kernel.org>; Thu, 18 Jul 2024 14:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721314629; cv=none; b=AiIpBUrES85XWd0s1xl0xRpcv5B7DBUJwrHXOXBbuISnMSt4PdYeQ4yu+AvM0QKpQzAbpmiztI1zeeksN4g2MfAs8ouW/PY6oTaDZ8rFiyYNP6qA14x/2uL20wcJ8RF+D7yV6ql2bDdoSDnL0720FVNTY1aE/IWCEZJXDki2rbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721314629; c=relaxed/simple;
	bh=vzdjWJwFMGRUMUD4n9NnHO9A4xvJ0crxgd7pHp8R8jQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=HC50wX7FLe/RUg1sx2fWX2WcH9wJMPRFy1unbmd7RONi9PG9w1hgST+Ukqn7cKrCwQTscW9e72ZmuTe2+b/SAx79XdsNLS9g8x9sGa/25KO6WqJs1IxUI11DJwnzZIoYYlvrCNlxp5iKa3wEdh1vzEiP3lPtbiFyHmSX/owMrJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=En2m1mkS; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="En2m1mkS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721314627; x=1752850627;
  h=message-id:date:mime-version:from:subject:to:
   content-transfer-encoding;
  bh=vzdjWJwFMGRUMUD4n9NnHO9A4xvJ0crxgd7pHp8R8jQ=;
  b=En2m1mkSQyGux2Wszsgx2lQfHhF61nBzSG2dtvLzk5nLaySesO/mYvgf
   waqaJNkD2Sy4+MA/kziOnG89wM/7btLuvWUp0DhPGZc8F2DYI4/b3ayHm
   e/CZzjMjGGkE9amxirDltv9+GAQSKK+JsCLdk3oxEelY3smst6sGFekDE
   ViWGOuGxrK1xycffRjdnyTgDOfKCOoW+8k9zlU5gcRs3TZOzX8TIymSYn
   pwr0TZ/ZRdVBBxfUMkbIw3rb2Su/vqRPVO8C1zAd0iQutrOfLlVdPMqqj
   L9Sby15d/XoQflhYdZt7XY2eAo0qQbRF3/1e5P4UEDWbKyqD2PnOcP4vC
   Q==;
X-CSE-ConnectionGUID: FJ96d5rsT8yH/2gDmvM2+Q==
X-CSE-MsgGUID: yiPy5CiaQQqegpEHL4G4Jg==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="44303059"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="44303059"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 07:57:06 -0700
X-CSE-ConnectionGUID: AZL2ZqcdQd26jflyj+dSdw==
X-CSE-MsgGUID: qS2fFoe3RQeNwQgXqSpQ5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="50858233"
Received: from mkusiak-mobl1.ger.corp.intel.com (HELO [10.246.49.33]) ([10.246.49.33])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 07:57:06 -0700
Message-ID: <f34452df-810b-48b2-a9b4-7f925699a9e7@linux.intel.com>
Date: Thu, 18 Jul 2024 16:57:03 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: pl, en-US
From: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
Subject: IMSM: Drive removed during I/O is set to faulty but not removed from
 volume
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,
recently we discovered an issue regarding drive removal during I/O.

Description:
Drive removed during I/O from IMSM R1D2 array is being set to faulty but is not removed from a 
volume. I/O on the array hangs.

The scenario is as follows:
1. Create R1D2 IMSM array.
2. Create single partition, format it as ext4 and mount is somewhere.
3. Start multiple checksum tests processes (more on that below) and wait a while.
4. Unplug one RAID member.

About "Checksum test":
Checksum test creates ~3GB file and calculates it's checksum twice. It basically does the following:
# dd if=/proc/kcore bs=1024 count=3052871 status=none | tee <filename> | md5sum
...and then recalculates checksum to verify if it matches.
In this scenario we use it to simulate I/O, by running multiple tests.

Expected result:
Raid member is removed from the volume and the container, array continues operation on one drive.

Actual result:
Raid member is set to faulty on volume and does not disappear (it's not removed), but it is removed 
from a container. I\O on mounted volume hangs.

Additional notes:
The issue reproduces on kernel-next. We bisected that potential cause of the issue might be patch 
"md: use new apis to suspend array for adding/removing rdev from state_store()" 
(cfa078c8b80d0daf8f2fd4a2ab8e26fa8c33bca1) as it's the first one we observe the issue on our 
reproduction setup.

Having said that, we also observed the issue for example on SLES15SP6 with kernel 
6.4.0-150600.10-default, which might indicate that the problem was here, but became apparent for 
some reason (race-condition or something else).

I will work on simplifying the scenario and try to provide script for reproduction.

Thank,
Mateusz
