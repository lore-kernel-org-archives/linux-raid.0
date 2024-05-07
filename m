Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB101509B9
	for <linux-raid@vger.kernel.org>; Tue,  7 May 2024 10:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715078305; cv=none; b=q5RiYwROXt3iBQqTUUwCjzWZUNPqPyzNOv+Knf7q2I02T9euFMbQ0gWv2DnaltDZr3HTJjkDhZBig1RO5ZFOknoe0ySzktjgSOeuCsXyhtl97FAUU+olRlHvnZGzNEvut5W8F+Ajwxvj4HyPQ70Qf0SIWBFucReNlJsPig5/8L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715078305; c=relaxed/simple;
	bh=VKaUeTPE2KgyvgSM2Jvmlpyh8V1jvW2KaPGI0wfWY4E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EGDl//BLI3qDjGVVe3OCWlOPwxPbyTeJt6ecKyQ6/M/470hwUl3uZDl7ACVsrQKjpv7Db/RUyD9qNLlXqiUOM23YwDcKeG02Gx3w028Ek1ErlknX7LHbhwEHJGFwAFRDRbXsoB/sIAiYDaKhiM5ZNgNN4jjd8hgNBPAayRqdC9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LZRHkW05; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LZRHkW05"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715078303; x=1746614303;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VKaUeTPE2KgyvgSM2Jvmlpyh8V1jvW2KaPGI0wfWY4E=;
  b=LZRHkW052JkkaS2keuf3jrwYmJ01+UisyxnxBkqrZ6Y+fysYxWLISGIq
   UElxK3izjvrsLm2rUcQktuOf08l3uNH9A+0VMjMXwDl99MyKRJBcy9dZz
   P39vp34imanF5H/NLfz0YifKbvM6rhgG7llvzu2PkW3ShD/X/P9C4bBnS
   zRvHZZknsIKzFmg0mjryosesuybE/L7dn34abZfB1YN1kZaEX3aFLBT67
   J6R5a2gciVnUiiZKvewAGc32XfRF1RPAWN8Fq5/xdLdpZpAedw1JzLUNG
   wwM+ddlC0YsveRoKs6UjTcWQuMca+KcKq73OJs3A8jc5t1/0mrY2rSTEH
   g==;
X-CSE-ConnectionGUID: 4zvgmg7YQaWKCz+dYlSEOw==
X-CSE-MsgGUID: KksADYwiQ0qVCQo66Hlpvw==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="21416738"
X-IronPort-AV: E=Sophos;i="6.07,261,1708416000"; 
   d="scan'208";a="21416738"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 03:38:22 -0700
X-CSE-ConnectionGUID: 3ikqfDIcTBiRzYR1CxTsSg==
X-CSE-MsgGUID: D3ftJrvCQxacgCuTEq/oJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,261,1708416000"; 
   d="scan'208";a="59335647"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orviesa002.jf.intel.com with ESMTP; 07 May 2024 03:38:21 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 0/2] New timeout while waiting for mdmon
Date: Tue,  7 May 2024 05:38:54 +0200
Message-Id: <20240507033856.2195-1-kinga.stefaniuk@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series of patches contains adding new timeout
which is needed to have mdmon started completely.

Kinga Stefaniuk (2):
  util.c: change devnm to const in mdmon functions
  Wait for mdmon when it is stared via systemd

 Assemble.c |  4 ++--
 Grow.c     |  7 ++++---
 mdadm.h    |  6 ++++--
 util.c     | 33 +++++++++++++++++++++++++++++++--
 4 files changed, 41 insertions(+), 9 deletions(-)

-- 
2.35.3

