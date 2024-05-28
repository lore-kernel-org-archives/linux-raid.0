Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84D71DFDE
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 14:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716906798; cv=none; b=KlXpXGu1vl8iVF7O3HPKvDlCUA5BYz/cVIbpHgK9jzkR9aDoNeuHF19Jyhvq6U0VYaazmeRAZ5i7OAuOZMBrM0CdTkHkvV2yrF93c/EIfJxxbmX0W1WILwaKBq8gOsVKXgSbverA0OQBwjhIKfAS670cneZE+pYQfqyukAYRQYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716906798; c=relaxed/simple;
	bh=JXorx8Bldaj/na3q4Fbb9D0mI0a/zBZ2iUyD3ES8Hok=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H92KgJ0Nk9ZqBXyNqmjbggK4VjY8tyUj7L/8S2HRXfUhphHfheXpX9ZMqrWxMYNuDPc3mkGSb6FpXhzJYlvzrcdiuUWUV4wMTyMMATeuVf7J8DY1esyKQ9frCSH/Ni8cvX409GjHPQWxgifqjbIw9ZJl+pqE3ywK5KPc9QUXqWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P46vIK2M; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P46vIK2M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716906797; x=1748442797;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JXorx8Bldaj/na3q4Fbb9D0mI0a/zBZ2iUyD3ES8Hok=;
  b=P46vIK2MTk2SJqwRGj4G2wnCePh6o4bCe4uowk+j+nZU3MgnzM8rJk/c
   NdAIUW2o/XXsO2bOfId6GXHyugcgnROrZjdAEMkw7yKmvQiPm+TKXNd1s
   1/ar/RBFCqVVv567gVCm9IcDOKqi8JI1KuNryhhH2SmvDyJ0eyFHD+mn/
   B7Z6/xyhzNqTyUmfjyeWqlzNOhQ0SzNp+G6LQyuiDUWpEqWgdBrLXSkaG
   MD1rOJu+2NpD6yXN/wchpYbU8QLIGZvdkc96RBcXxOfEBCa1CMYXTGrjG
   5hnVZbT9IMgbwj7B+JI+qy0yCwf5uqNOLsWUhlOyd8hjDZ4gILi9d6NrX
   A==;
X-CSE-ConnectionGUID: 3WNOdCuDSO2MVAomNuAmvg==
X-CSE-MsgGUID: 6tQHUff1TJmULBVt1Zcv/Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="24382819"
X-IronPort-AV: E=Sophos;i="6.08,195,1712646000"; 
   d="scan'208";a="24382819"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 07:33:17 -0700
X-CSE-ConnectionGUID: O/l4Pr7yTsaBRCDFQreKFQ==
X-CSE-MsgGUID: e7dCdDRcTtamTyT3/yu/sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,195,1712646000"; 
   d="scan'208";a="66298868"
Received: from unknown (HELO mtkaczyk-dev.igk.intel.com) ([10.102.108.41])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 07:33:15 -0700
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH] mdadm: add --fast-initialize
Date: Tue, 28 May 2024 16:33:05 +0200
Message-Id: <20240528143305.18374-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is not complete change but I would like to get the feedback on
concept proposed. There are few features for optimized space zeroing.
We already support --write-zeroes but Intel would like to add support of
deallocate command (discard) in the future. There is also Sata trim
which could be potentially used.

The goal of this RFC is to get feedback about proposing one option to
check for few features which can be used for performing smarter
initialization instead of resync. With that, user may just type
--fast-initialize and mdadm will determine what can be used, else abort.

This won't be merged.

Cc: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

---
 mdadm.8.in | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mdadm.8.in b/mdadm.8.in
index aa0c540399f6..be592d70ac9b 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -849,6 +849,17 @@ each disk is zeroed in parallel with the others.
 .IP
 This is only meaningful with --create.
 
+.TP
+.BR \-\-fast-initialize
+When creating an array, check disks for optional features to perform optimized initialization
+instead of resync. These features are: NVMe's write-zeros or deallocate and Sata trims. If there is
+feature supported by all drives, it is executed, otherwise error is returned. This option invokes
+.B \-\-assume\-clean
+.This is intended for use with devices that have hardware offload for zeroing, but despite this
+zeroing can still take several minutes for large disks to complete.
+.IP
+This is only meaningful with --create.
+
 .TP
 .BR \-\-backup\-file=
 This is needed when
-- 
2.35.3

