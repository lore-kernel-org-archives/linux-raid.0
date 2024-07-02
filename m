Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7A782D7F
	for <linux-raid@vger.kernel.org>; Tue,  2 Jul 2024 10:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719916689; cv=none; b=qoWSDKIBY8i/q6vBWGu+934LITjhr44qz6lvDmQBTXm8urwSwP6xO3noy8lmjQlkh79A28vQMWom/kIN7kEeMFTit56BDPKMa6VgroznQtudphtayLT/DqrgjNpLhJtUsXZs7zkotUwqFYdeE8yAVgHsNIMucHQJmTnXieFgMss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719916689; c=relaxed/simple;
	bh=DPOcWYN7gk0Knuf93wt8N+JBCBsQw9H+xwtS8xeTu2A=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=ZlrQIjYTveMH55NeKQxpNM2vxcbohKDzeAz0A9eHTAjJQ1fRlkMl+z1cJvAHeA0Clxq6MBqqQmAizSHhP/1dgkK9Hu5e45pu8xvDBPUOtrx+ea4g+NDtuwHbv9TjVeh3NkL80mMHbOaWfkvtgDDK5aEqROlb9QTQ/wvHrPvhUiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PBrkQIJ7; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PBrkQIJ7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719916688; x=1751452688;
  h=date:from:to:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=DPOcWYN7gk0Knuf93wt8N+JBCBsQw9H+xwtS8xeTu2A=;
  b=PBrkQIJ7kqw9pgfAXnPoS6ftpCFOfCPQLKOO0pdzjroW6XLq8/TE0WCp
   sGU0yfNcdISwX6uNyC7ngmRzmo6ZM8wi+7JLTXiUbHVSehldCVo1uxwui
   +683xjB9bEWWCzmjQ+OAI40DmqkFVHB9sps98C993bDOWgZbGWuEJ47BL
   1x2EdbWzd+2/K08oHDMRQwXUI6wZVmSGEbFtEefOkZuBiqTMSEmzCS+7K
   eJ2XCWyeseila88DgkGAvBBqc2Ry6w+SaMSKK2XSRXhydZ6vSqSChLNTJ
   dSWolSF7qRREGmMC06lWycw8zOx8ZKuLje4eS/o2ngeipua1CKObQFCFx
   g==;
X-CSE-ConnectionGUID: W3y40n9pSpq3fO0P8oZtCg==
X-CSE-MsgGUID: 54CR70dESVKCAsz5ifxA4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11120"; a="42511088"
X-IronPort-AV: E=Sophos;i="6.09,178,1716274800"; 
   d="scan'208";a="42511088"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 03:38:07 -0700
X-CSE-ConnectionGUID: AbuXU2RfS12zYpgQ4zLWJQ==
X-CSE-MsgGUID: 0s+wejHmQQazc6Q5MumIKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,178,1716274800"; 
   d="scan'208";a="50216355"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.1.223])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 03:38:06 -0700
Date: Tue, 2 Jul 2024 12:38:02 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Subject: mdadm v4.4 is coming (~4 weeks)
Message-ID: <20240702123802.00000c97@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello,
Within 4 weeks I would like to release mdadm v4.4

Please let me know, if there is something urgent and it requires my attention.

Thanks,
Mariusz
