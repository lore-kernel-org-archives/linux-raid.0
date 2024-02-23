Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B55F8288E
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 14:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708699930; cv=none; b=eiLsXceRXHLNLXx6o7tgxTA2Z4ITM38bmq0i2b51wMmLCZPFscBEI9RHHGwkg+tpuC7i3IH7xpQVsjmNIb04tmy4D/a5AZX43/eB0Zg70nwT1AAY/dhm1gVhimA0d+ZpMWXcZyivkJAL/iw3FAUUTr/TN05Hg/422DnKhEk3C5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708699930; c=relaxed/simple;
	bh=4WAicOQ1rFKABFmBFqZ8bGgS5l1m1H4i53cQYeTXEM0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MFLmdNUTLebhQNTHrh4qj17VznXDNcsmggBALqISYLLFcTupQ4XwPXJmEPnom1o3f+o54i9ROlfCj9vLNEaGtdIfUFyMW4dMb2261E8YhJBPUFxGbg/aE0kbRP9baXrUVyrL9l0pvgvqNO0NEUyz2xTQKTB/HapuK82PEBCnHpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lARDMs3+; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lARDMs3+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708699928; x=1740235928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4WAicOQ1rFKABFmBFqZ8bGgS5l1m1H4i53cQYeTXEM0=;
  b=lARDMs3+rgQtl9y2WKtyazD4NWvBxM3vaS171k4pO816xKblN0GE+qas
   q2M6zS6U6oS2wgsccEx21+KYK+eVGepw2d30OWmxebCZmkkk1KTw4zaok
   ptj1uW7v4INKEAi9jvIul7joRJMsu/rmXRtwE1PUN8AsFlNXcnN9o5Dwa
   l0DboJV8XfcTYWRr6XmgoGKAKpTKZ/xkkLmqQaHjBXQuS9Ub8V/FKURjS
   OiG2sBAPpB2hf98Wkdo+kVkNaoEPuOzQrVexu5Oh0EvQsGaEvrOYskRwQ
   s0nWJvikaODfeleAwC2OyZWPV0NIhtTWdhIUdHpjVs8lPlN0b5v5/Lamm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10993"; a="20454934"
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="20454934"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 06:52:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="10495438"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 06:52:07 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 6/6] mdadm: move documentation to folder
Date: Fri, 23 Feb 2024 15:51:46 +0100
Message-Id: <20240223145146.3822-7-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240223145146.3822-1-mariusz.tkaczyk@linux.intel.com>
References: <20240223145146.3822-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move documentation text files to directory.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 .../external-reshape-design.txt                                   | 0
 mdadm.conf-example => documentation/mdadm.conf-example            | 0
 mdmon-design.txt => documentation/mdmon-design.txt                | 0
 3 files changed, 0 insertions(+), 0 deletions(-)
 rename external-reshape-design.txt => documentation/external-reshape-design.txt (100%)
 rename mdadm.conf-example => documentation/mdadm.conf-example (100%)
 rename mdmon-design.txt => documentation/mdmon-design.txt (100%)

diff --git a/external-reshape-design.txt b/documentation/external-reshape-design.txt
similarity index 100%
rename from external-reshape-design.txt
rename to documentation/external-reshape-design.txt
diff --git a/mdadm.conf-example b/documentation/mdadm.conf-example
similarity index 100%
rename from mdadm.conf-example
rename to documentation/mdadm.conf-example
diff --git a/mdmon-design.txt b/documentation/mdmon-design.txt
similarity index 100%
rename from mdmon-design.txt
rename to documentation/mdmon-design.txt
-- 
2.35.3

