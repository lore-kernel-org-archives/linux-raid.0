Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BED6745E0
	for <linux-raid@vger.kernel.org>; Tue,  6 Feb 2024 09:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707210844; cv=none; b=u9bjbMUb4+i06ggI05Ng15xU7qSL4T0gSURNP/M1XKgyrDyml4YfHaMtWuAPxe0PoLNRZVgAG2O67devbMK/qViU1HRtYqepFYsSesu/AK6ByYPfHIb3ReTctQdz8sF/BMALWMiINiw92yGcD5i/ApPTzD+BFj/TlMF+ssqlCiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707210844; c=relaxed/simple;
	bh=aH3wWTMf5tQfHnhFpdxgLEXkgSDpKjTSJMcftOoN4V0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=NVuydv+3MzZnTM/51tIKoo/P9M4i7NLizeDJQwnrjmAmk7AQesSi8ZLZ6xvHeDPGZ8YG9gFZ5ngUhr0UWIqoRCs8LMIZZqXHDnQ1ClUDodd9/y2xOXK5Uj+SY8Bp0qGQzz8BqRUoXP/gnxVEvyk8MIZZNkAw1Ba3PrXiJz4Xy/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QFdi9d+O; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QFdi9d+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707210844; x=1738746844;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=aH3wWTMf5tQfHnhFpdxgLEXkgSDpKjTSJMcftOoN4V0=;
  b=QFdi9d+OGiZTz24Fywi9mdJd3I76aH09ThdXfmpkedH+j7Y4PbDIjBdI
   6D9Xyr4Gr+59bksW+kFrR8aO7CEhZBAS/QYTZinowyrDcykZfdHCC2xcL
   hO7m9iEzlDAd6PjPVov1kyVRBUevKzJRKDqCOorISH4QCPDO3rsC55+9l
   /SZhHpeE4m0CTeUm2l++q4+NcubTB7MZiuIEM1X5m2BIfXUFUMCwf6Gw9
   cobhwARFVMY2WLKRu9uiPg8ovDJFJ7mz7GUML878NLErPUCXHeXLvSJmx
   f9GsyTdO6V9d7oc+p5uE3CqxtNWcuX4LP/gpQ9WwRhUnuQDBujg6J3MwN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="966986"
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="966986"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 01:14:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="5572681"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 01:14:00 -0800
Date: Tue, 6 Feb 2024 10:13:55 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org, Andrea Janna
 <andrea1@newsletter.dpss.psy.unipd.it>, Song Liu <song@kernel.org>
Subject: Mdadm 4.3 last call
Message-ID: <20240206101355.00007921@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi All,
Within two weeks I'm going to release new mdadm version. Two last fixes are
waiting, if no objections I will take then this week. If you are familiar with
anything that require my attention, please let me know.

Patches list is almost clean, expect one regression fix in progress:
https://lore.kernel.org/linux-raid/20240108120230.00004b80@linux.intel.com/
I will consider resubmitting it myself if no feedback by the end of this week.
It is regression, so it is worth to be fixed.

I would like to stop making ANNOUNCE files for a release. I think that well
described tagged commit is sufficient. Let me know if someone have something
again.

Thanks,
Mariusz
