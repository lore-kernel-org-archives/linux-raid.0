Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B23081729
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 15:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714403975; cv=none; b=rNQeKByk3ong7pgzts7P06anP/760O/MhIPM+yA1ldZ/sk61nwkczVP3KbGUT9bF8EcfqGHeiKPHdce8hSCosXklclXmWcj259ZmWV9rmtMzBYEVoDIwx+2ISPyKAHjLBPpbJNGMBfv0Fdbs+N4A9JKRaQ5lPRhSQu2Qqq7XHkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714403975; c=relaxed/simple;
	bh=kYQG80VR9dL7R+nIcjy+yXI9ZlFB8KEpR4gncprsyU4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rTogSQaSh6zTRkmYRHx7wKwPiXxs/nTlDxVYVTwEvpVE4qYXZLP0UV8k7TArh7+CFedNuc8AIco/WXw8HlrOL2PVx6Zuilhj95bbbaoRX6MMhQu29ugMIuEQqMhmDSo8H9u95JQsiZJr8rBWqaqIeV3EiZv8QhOOsn4LiHwFqlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZFZIkJfN; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZFZIkJfN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714403974; x=1745939974;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kYQG80VR9dL7R+nIcjy+yXI9ZlFB8KEpR4gncprsyU4=;
  b=ZFZIkJfNlH0qeFqmi62MAGFqZTC/ufZvV3tPBrwBc+TnMj0HkB+6JkRp
   Q8pjtJg7Kg/4fsqxj8UjaCBzycNmKiJzHvLirpBdO1eV5pG4/p1pJygpe
   7x4cwjiRdclzZ6EAbrI60TYBke0IBorG5VORYysI4zuBuWT8t7nBP4um8
   izNaVymPXLAvGVgIlmL75bcOopKa4V/mzRSH2OPWXW0A8LovMovA7g2rH
   17f3IK/R+OgjIREmJZdbeDOwIs/DDUZAzGkWcufHidqJfx7KTuSaQkupG
   L3ylIVn7r8PJrmcsZj27XQ/HEjFYjq2dIpiV2BR2qb24MsWi6tGq46iNI
   g==;
X-CSE-ConnectionGUID: X+TO/yyUTM2XcZo/+SINyQ==
X-CSE-MsgGUID: 0m/tGddDS2OMj4t8ovZpTg==
X-IronPort-AV: E=McAfee;i="6600,9927,11059"; a="10288819"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="10288819"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 08:19:33 -0700
X-CSE-ConnectionGUID: SHAnXJoiR/uYBKEwi8saeQ==
X-CSE-MsgGUID: B0BMTaFkTROk4u0EPfCgZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26126998"
Received: from unknown (HELO mtkaczyk-dev.igk.intel.com) ([10.102.108.41])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 08:19:31 -0700
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Paul E Luse <paul.e.luse@linux.intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Song Liu <song@kernel.org>,
	Kinga Tanska <kinga.tanska@linux.intel.com>,
	Jes Sorensen <jes@trained-monkey.org>
Subject: [PATCH v2 0/1] mdadm: Change main repository to Github
Date: Mon, 29 Apr 2024 09:28:55 +0200
Message-Id: <20240429072856.10603-1-mariusz.tkaczyk@linux.intel.com>
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

Cc: Paul E Luse <paul.e.luse@linux.intel.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Song Liu <song@kernel.org>
Cc: Kinga Tanska <kinga.tanska@linux.intel.com>
Cc: Jes Sorensen <jes@trained-monkey.org>

v2: Highlight that linux-raid@kernel.org remains as main place for questions and discussions.

Mariusz Tkaczyk (1):
  mdadm: Change main repository to Github

 MAINTAINERS.md | 41 ++++++++----------------
 README.md      | 84 +++++++++++++++++++++++++++-----------------------
 2 files changed, 59 insertions(+), 66 deletions(-)

-- 
2.35.3

