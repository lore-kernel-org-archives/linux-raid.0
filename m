Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FC4A42
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 10:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705573830; cv=none; b=N1n/1vn4FmblDll3liwYIQEld/bdDmU6aNA1gbZ3XTRDXBCgS56+wLt4ZvsZ5elX9yy1F2ZnSc7p4+xgWo8TNlhNxZMJpCNpetk7/cTFNlZk6S4pGyjNE75hBdHSN4qUdMppAGYbKFp/9279CfT39bXCSlxyTU+b7XdALWScDuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705573830; c=relaxed/simple;
	bh=qmdB+99O2WXZ6iaHNo464c5JUhwBfZ8aSGgi7emqPLQ=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding; b=KMhcYhWTru/4eEgr1+reqw6oaENNeaVIJGfT0LwTrNIRG1W7IZwsSZDMA3SW8ckE2adGA3accX8Bx+ADPVhvLpZalMOU+aZ8m4ejfYjGQtpBUMqh+XB6iqg/zctOfRdbi4JHRa8SzadTg1qmKSewKHu2cNgEbb1+TS88odsJhwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l7LjSQpy; arc=none smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l7LjSQpy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705573828; x=1737109828;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qmdB+99O2WXZ6iaHNo464c5JUhwBfZ8aSGgi7emqPLQ=;
  b=l7LjSQpyyizwtzsaOE2mocwTvSRSrQCnUak2O++aTszv1Qu6ItpBKZDM
   O0lCxDyE79SVttxE9MaxbSb7H7IavewS20ZYE0XJz6fmMv0CfzezfFX2R
   YBnPfhwlvLLnHDwY5BhAX5+2kRyuU1uE+bHkGbRSRzMCmwkaTVbUtSEqN
   tLnnd1ewa8RRtWVWdvTM/N/UrnT1qZWPB4Z9if6SU8pvPDPQRdW51zgfu
   aR8zMnCP3f0TL70UjLCCPH278gHi+C+Yshga7R7N9FrK/KAzBu48H4S+M
   WxrfIn6QCeowysl45iTPbmrjhnkyyACAAP2D8OcupgUM5vNitRAQYKqA+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="390858520"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="390858520"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 02:30:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="1115926908"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="1115926908"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jan 2024 02:30:27 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH v2 0/5] Fix checkpointing - invasive
Date: Thu, 18 Jan 2024 11:30:14 +0100
Message-Id: <20240118103019.12385-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the second half of splitted patchset "Fix checkpointing" as
asked. It contains invasive changes regarding checkpoint handling,
that should not be merged prior to release.

Note, this patchset applies on the first part "Fix checkpointing -
minors".

Mateusz Kusiak (5):
  Remove hardcoded checkpoint interval checking
  monitor: refactor checkpoint update
  Super-intel: Fix first checkpoint restart
  Grow: Move update_tail assign to Grow_reshape()
  Add understanding output section in man

 Grow.c        | 13 ++++++-----
 mdadm.8.in    | 21 ++++++++++++++++-
 monitor.c     | 65 +++++++++++++++++++++------------------------------
 super-intel.c |  3 +++
 4 files changed, 57 insertions(+), 45 deletions(-)

-- 
2.35.3

