Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101C982871
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 14:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708699926; cv=none; b=MS/Aj3ziFZdWozg4uKtOhNFc0brmuxvNQvK1XeS7NSOrmeri47ScOz2XLNT2vmUiTxlhIi2J4PhaGPK2P+wPSo7FNa/PtBlqiM22pMJ+0tpyrZjQQ0iwK5OGAlGpaEi1oIdRi4G1rSzNDv+J8nOILW6QCp9AoD0iNgJWP4zROYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708699926; c=relaxed/simple;
	bh=CVjb26xuv4vAXxwigAVZTEryr3plLkd0hwJ8Pg1T7nw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qYpY/dPEvT+WodqZuHrxcoft35laB5nH6dIyB8Lcj2sLwqqAjEyql/40rtgFHVHa9wj1fTVdb9GEs4HsOBUltlpE+zya7rH5AP6BRDfNnPle8UpDUv2OjKZJXrt1dMafAqKNKASeONNhPrBVmPRCvJo1R6GUOPdDPz5ER4f8FxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gP7RQ+1P; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gP7RQ+1P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708699924; x=1740235924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CVjb26xuv4vAXxwigAVZTEryr3plLkd0hwJ8Pg1T7nw=;
  b=gP7RQ+1PxsCN/jIX4us4qSK3YyDlOj23Zp/JsTdxLYbr+jhEx+J97fII
   gF4Nl/YDOr+BfwVu2Aq3C9tHizKznjsWzNT+M4mzVQbQ7ryL06Sm++QTz
   UH0HNVoXQZPVjUA714FhYxZ6W+yos2YRDtTThb8c4fIpwG9mH+ikKklCw
   LYWt+uVaQGUi7ByBCwH8SoEDkXftZNet4qfxJyy3OZiArccyCZ4153+0g
   hn2Qua1rVFj3PpoP1AfbQRtKgeFfXM6LM7Vc/H13T6grva03SdfCdjdGb
   APx/Ew/wSsKVqG6cQYPMnkovoClLQdZKH8TR27wmgvhSiIzPi88mxwe0R
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10993"; a="20454922"
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="20454922"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 06:52:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="10495436"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 06:52:03 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 4/6] mdadm: remove mdadm.spec
Date: Fri, 23 Feb 2024 15:51:44 +0100
Message-Id: <20240223145146.3822-5-mariusz.tkaczyk@linux.intel.com>
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

This file is outdated, various distributions has their own specs.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 mdadm.spec | 47 -----------------------------------------------
 1 file changed, 47 deletions(-)
 delete mode 100644 mdadm.spec

diff --git a/mdadm.spec b/mdadm.spec
deleted file mode 100644
index 12e7859a16a4..000000000000
--- a/mdadm.spec
+++ /dev/null
@@ -1,47 +0,0 @@
-Summary:     mdadm is used for controlling Linux md devices (aka RAID arrays)
-Name:        mdadm
-Version:     4.3
-Release:     1
-Source:      https://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-%{version}.tar.gz
-URL:         https://neil.brown.name/blog/mdadm
-License:     GPL
-Group:       Utilities/System
-BuildRoot:   %{_tmppath}/%{name}-root
-Obsoletes:   mdctl
-
-%description
-mdadm is a program that can be used to create, manage, and monitor
-Linux MD (Software RAID) devices.
-
-%prep
-%setup -q
-# we want to install in /sbin, not /usr/sbin...
-%define _exec_prefix %{nil}
-
-%build
-# This is a debatable issue. The author of this RPM spec file feels that
-# people who install RPMs (especially given that the default RPM options
-# will strip the binary) are not going to be running gdb against the
-# program.
-make CXFLAGS="$RPM_OPT_FLAGS" SYSCONFDIR="%{_sysconfdir}"
-
-%install
-make DESTDIR=$RPM_BUILD_ROOT MANDIR=%{_mandir} BINDIR=%{_sbindir} install
-install -D -m644 mdadm.conf-example $RPM_BUILD_ROOT/%{_sysconfdir}/mdadm.conf
-
-%clean
-rm -rf $RPM_BUILD_ROOT
-
-%files
-%defattr(-,root,root)
-%doc TODO ChangeLog mdadm.conf-example COPYING
-%{_sbindir}/mdadm
-%{_sbindir}/mdmon
-/usr/lib/udev/rules.d/01-md-raid-creating.rules
-/usr/lib/udev/rules.d/63-md-raid-arrays.rules
-/usr/lib/udev/rules.d/64-md-raid-assembly.rules
-/usr/lib/udev/rules.d/69-md-clustered-confirm-device.rules
-%config(noreplace,missingok)/%{_sysconfdir}/mdadm.conf
-%{_mandir}/man*/md*
-
-%changelog
-- 
2.35.3

