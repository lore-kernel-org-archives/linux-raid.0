Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930A4200AB
	for <linux-raid@vger.kernel.org>; Wed, 20 Dec 2023 09:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cjUa8obr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703064784; x=1734600784;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vooEKPntHsQ8D92jw7frJ4clTyw2D1vSQvvCSBf8zbs=;
  b=cjUa8obrdODZszkubNxuYhzs4o2S6R/9ZPCrS2xcYfbkKu4qcetMZRQr
   pBGmJmAAbhKEkJaKiOJ7oqeXV7xUEHWi7YzJPVI/diJWTUuBbyb5fJkUA
   g+X1v3ObgNo4arRHkYODhTufpYHzbuKFXt46Bh7QNhSwCidmdIqFe1JIm
   WNJc6NpjeDTpzJcwUDJlBUVOLvMAvxUquoJrHafdu8bWZ3KceDfXGWNl/
   jsHBTTcOgoAjWUmSItWDO/Nb6nxqQZ/4jCX3A8CidTaINWud6BZ4af1HI
   pTlpECasrZwl808JprhpHlQxZF1rwjrbIW9V1h+AL43Jc1To2srbCbLv9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="2615134"
X-IronPort-AV: E=Sophos;i="6.04,291,1695711600"; 
   d="scan'208";a="2615134"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 01:33:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="810538545"
X-IronPort-AV: E=Sophos;i="6.04,291,1695711600"; 
   d="scan'208";a="810538545"
Received: from unknown (HELO dev-ppiatko.ger.corp.intel.com) ([10.102.95.202])
  by orsmga001.jf.intel.com with ESMTP; 20 Dec 2023 01:33:02 -0800
From: Pawel Piatkowski <pawel.piatkowski@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	colyli@suse.de,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 0/1] Adjust checking subarray state
Date: Wed, 20 Dec 2023 10:32:48 +0100
Message-Id: <20231220093249.2778-1-pawel.piatkowski@intel.com>
X-Mailer: git-send-email 2.26.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pawel Piatkowski (1):
  manage: adjust checking subarray state in update_subarray

 Manage.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.39.1

