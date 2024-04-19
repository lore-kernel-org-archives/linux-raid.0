Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF537BAF5
	for <linux-raid@vger.kernel.org>; Fri, 19 Apr 2024 09:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713519583; cv=none; b=WITf15FhUJz33B+pXUcUtdLeMUaniiFreckPR9v0gGPTtpGvZMWP7v6lBu3DafS6bccC/4J4XHTUsbNzGKoYnMwxKGtYTg4q0uCxG9waeYT18FaTY9jrdALO3Ah3FIu9fidYmJ9pnre1iZxLEPdHrDq69rL5FVIUKifIPwhinlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713519583; c=relaxed/simple;
	bh=PM5hk2PZBZms8BIOS2tWwo6e7l1Sn4QiTg9b9aQnv/Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bYEsTYM7yeJJeabLcIuXSsyKkvx0rODXAdSJv/nYbLPZ5+mHKHrWxOtZioybpLZMCw97NaTId2TBaa2iGrhbPQj9REgDDr/a++3WD0IEic/IT5RUxLZHj2PpHB6NfdUiG1NGbwQOm6zed7TQVS8cfWefu5sPRHh71ruS5qOpAAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kONRjMv2; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kONRjMv2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713519583; x=1745055583;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PM5hk2PZBZms8BIOS2tWwo6e7l1Sn4QiTg9b9aQnv/Y=;
  b=kONRjMv2w+kP17XSu6uCE2wDQNtJvBF350VmbTEIN1Li/p9H+xpJLPA6
   h4STZig8t7yzPJ8FCF/7PVzLvV2TMpLmwFzkd0iwJtjkRb68uS+Xt6TZ5
   F4MDWFO0J5YIb7tYBK2B/tPwSpROnz2PbJOp9668qgEcqMXpbnioKYJLu
   PWGWExhX9juHle9qA9mUevRsp2cVpnxAX9CHmUPOAO0mbQ+oaH6Tl8fOf
   UGyzy5cGcR+zAjShJgqMYyg0a23vP7ksYGxrPvSQ8+1uMuG+pFBJMRm6m
   1T1A4Zw42EUlMDVNgTSxYU2tTD8CooEUBqJa7UOQ+Q4FNFfg1v6gf1LAw
   w==;
X-CSE-ConnectionGUID: n0OSjPkvQd2xeD52w0gq1A==
X-CSE-MsgGUID: lmIzAwz2R0q6tfmJs5pmJA==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="20254675"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="20254675"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 02:39:42 -0700
X-CSE-ConnectionGUID: JmoNcn1xREKvSE1aSIiCaw==
X-CSE-MsgGUID: sW0uELxDRH+D1nAVcul2gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23714976"
Received: from unknown (HELO mtkaczyk-dev.igk.intel.com) ([10.102.108.41])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 02:39:40 -0700
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Paul E Luse <paul.e.luse@linux.intel.com>,
	Song Liu <song@kernel.org>,
	Kinga Tanska <kinga.tanska@linux.intel.com>,
	Jes Sorensen <jes@trained-monkey.org>
Subject: [PATCH 0/1] Move mdadm development to Github
Date: Fri, 19 Apr 2024 03:48:38 +0200
Message-Id: <20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks to Song and Paul, we created organization for md-raid on Github.
This is a perfect place to maintain mdadm. I would like announce moving
mdadm development to Github.

It is already forked, feel free to explore:
https://github.com/md-raid-utilities/mdadm

Github is powerful and it has well integrated CI. On the repo, you can
already find a pull request which will add compilation and code style
tests (Thanks to Kinga!).
This is MORE than we have now so I believe that with the change mdadm
stability and code quality will be increased. The participating method
will be simplified, it is really easy to create pull request. Also,
anyone can fork repo with base tests included and properly configured.

Note that Song and Paul are working on a per patch CI system using GitHub
Actions and a dedicated rack of servers to enable fast container, VM and
bare metal testing for both mdraid and mdadm. Having mdadm on GitHub will
help with that integration.

As a result of moving to GitHub, we will no longer be using mailing list
to propose patches, we will be using GitHub Pull Requests (PRs). As the
community adjusts to using PRs I will be setting up auto-notification
for those who attempt to use email for patches to let them know that we
now use PRs.  I will also setup GitHub to send email to the mailing list
on each new PR so that everyone is still aware of pending patches via
the mailing list.

Please let me know if you have questions of other suggestions.

As a kernel.org mdadm maintainer, I will keep kernel.org repo and Github
in-sync for both master/main branches. Although they will be kept
in sync, developers should consider GitHub/main effective immediately
after merging this patchset.

I will wait at least one week with merge to gather feedback and resolve
objections. Feel free to ask.

Cc: Paul E Luse <paul.e.luse@linux.intel.com>
Cc: Song Liu <song@kernel.org>
Cc: Kinga Tanska <kinga.tanska@linux.intel.com>
Cc: Jes Sorensen <jes@trained-monkey.org>

Mariusz Tkaczyk (1):
  mdadm: Change main repository to Github

 MAINTAINERS.md | 41 +++++++++++----------------------
 README.md      | 61 ++++++++++++++++++++------------------------------
 2 files changed, 37 insertions(+), 65 deletions(-)

-- 
2.35.3

