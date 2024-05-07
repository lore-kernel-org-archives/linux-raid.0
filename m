Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F450161331
	for <linux-raid@vger.kernel.org>; Tue,  7 May 2024 15:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715096137; cv=none; b=jMHaosoQTo7ADTSCBW+aJFbyLxo6PaRvuoTpuxeq/Kp6rD5DZKBVVQp+0dmZTUG0EaAIfD6O0P4w076QknHa6N1ZUMLVsPoWGUK78E/9tbOJqvdljk6bFxd2dlH1l9iliwUDA9nf0b775k6zFhzLzXgTuUiDL2I5LyvfbJdOZxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715096137; c=relaxed/simple;
	bh=meoJAmNwJwn7roIrBQimdpvAaCylC56wBSKydflmhrA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fTyeNDGnkhJ9v1xf1r9XpGefftTaT05y+FaPw5FghIOEXJKfJcGUeTlkcE+4dHV14mKYAvwLLK7Ak9gALW0n+6uEESD9NXMBh/1JDEFCOapLRh/ouNkV+oX3BvPOf0gBO00nWaydKpGvYbAg1s0/jecjj7VqFHzKnSyBwrZnZIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UzC3FhzI; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UzC3FhzI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715096135; x=1746632135;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=meoJAmNwJwn7roIrBQimdpvAaCylC56wBSKydflmhrA=;
  b=UzC3FhzIkKkyqTMPsDVd8COqdYn/crACQ98KFBFh3JJ9yd7D0N34LgGR
   htk3eF/e10tMgxqCDD4bmNZTJlx+dGfC0o2F5vk4ItbE/9up0Vyih+GeQ
   TJ3G2gL3XuKsLU4TGXxMkbNkGC3SKpYrGAcb6ZMVQ9VxMrToi46ipC6eu
   YoVPj7P40sD9lSGCCXz+0twq3NAc0LlC3qWuanmV871IA+ZpvfEETfZda
   8o9YkIsvJ0iGSgPGLaG9avZWQBjMRImKmVIjgAsR6AvNBhIs4B1/EKf6V
   wwz5xX83a+2wf3ND/7b+uq0+fTHfNQsXET2LrXowIRWKri3k7ZSdgFJ65
   g==;
X-CSE-ConnectionGUID: 6knAobWmQm+S3IQpD4WoIA==
X-CSE-MsgGUID: vtzkT0r1Sea1JZ4cxrOmzA==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="10767825"
X-IronPort-AV: E=Sophos;i="6.08,142,1712646000"; 
   d="scan'208";a="10767825"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 08:35:34 -0700
X-CSE-ConnectionGUID: maWL8IWjSWCRrLa/5IseWw==
X-CSE-MsgGUID: tU/4XZ3HRyS3KDp0WaadqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,142,1712646000"; 
   d="scan'208";a="33126932"
Received: from unknown (HELO mtkaczyk-dev.igk.intel.com) ([10.102.108.41])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 08:35:31 -0700
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Hannes Reinecke <hare@suse.de>,
	Paul E Luse <paul.e.luse@linux.intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Song Liu <song@kernel.org>,
	Kinga Tanska <kinga.tanska@linux.intel.com>,
	Jes Sorensen <jes@trained-monkey.org>
Subject: [RFC PATCH v3 0/1] mdadm: Change main repository to Github
Date: Tue,  7 May 2024 17:35:08 +0200
Message-Id: <20240507153509.23451-1-mariusz.tkaczyk@linux.intel.com>
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

Patches sent to ML will be accepted but Github Pull Requests are
preferred so please use mailing list only if it is necessary. I will
setup GitHub to send email to the mailing list on each new PR so that
everyone is still aware of pending patches via the mailing list.

As a kernel.org mdadm maintainer, I will keep kernel.org repo and Github
in-sync for both master/main branches. Although they will be kept
in sync, developers should consider GitHub/main effective immediately
after merging this patchset.

I have strong confidence that it is good change for mdadm but I
understand that review flow will be worse.

Thanks all for comments!

Cc: Hannes Reinecke <hare@suse.de>
Cc: Paul E Luse <paul.e.luse@linux.intel.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Song Liu <song@kernel.org>
Cc: Kinga Tanska <kinga.tanska@linux.intel.com>
Cc: Jes Sorensen <jes@trained-monkey.org>

v2: Highlight that linux-raid@kernel.org remains as main place for
    questions and discussions.
v3: Accept patches sent through Mailing List and missed RFC tag.

Mariusz Tkaczyk (1):
  mdadm: Change main repository to Github

 MAINTAINERS.md | 41 ++++++++----------------
 README.md      | 86 ++++++++++++++++++++++++++++----------------------
 2 files changed, 61 insertions(+), 66 deletions(-)

-- 
2.35.3

