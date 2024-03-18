Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F24B28DD6
	for <linux-raid@vger.kernel.org>; Mon, 18 Mar 2024 15:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710775220; cv=none; b=F7rVodINzUW3KJT4Jp89z5x7HdDYLM+n3KnI7Knj567D8hicpjOCYzHIUQ96ycmaNY8vvl/l3zVejEOCXfC27CpRYdYjAwQOMAtNK0YjQ/yuVuLYg8ZIZZGjiI26TBK2bIk1J5NEKenCEXz+PP95p2xa8KvVmGrYBHFYjwV55z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710775220; c=relaxed/simple;
	bh=dK79OzGUHmTxmb09/HR2dpjCBigPZ3BZhhkr1Rbp0/A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j1GkU4NEITTWfF1Qy5cDb9mxzq3YhhY8DdkaHBiJV2ZX2uqThhQiAWdPH3gL82EhTgaoftwdQwhGIWbYMPrbIVWiyKmu3t2kBAE38gqC6r8Nv3KTwIC+l5d6S9dRUo0Ea8GqwH3LjFcrBYl4wLyNwhH1NWvL25SNcpjysoiTkgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YtY2YG3M; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YtY2YG3M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710775219; x=1742311219;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dK79OzGUHmTxmb09/HR2dpjCBigPZ3BZhhkr1Rbp0/A=;
  b=YtY2YG3Mr6teItFq4HwS9eHgXqZcLDRic4Ret5Era8Q7AdxU5z3yxWJy
   ILiD/LdFXBiLak3NY82GGMOJFdFIOhhb6Y6mc00dYXK5kSrgyKAUxDy1z
   AIbVuFy8VRtXQfWpVeVMwNPHKq75fZ1pb9voFUtzB8USSU4iJ6X6Rr710
   eBUiD2cWqmzswy6WYjLEerhp/c8NJCJYT3KamtISHDo43txOiaAAb6MtT
   EG1RSzhhi8py6W4rF2ysWXHge+MfyWZa2k7VzdtI1FT8/oJs6CweLROyG
   GaYfYT4y7bXGcwNzDkdRp+B3gaCayoYf+omSvyIlzaMPSJdDNX9ocVAm/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="28075135"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="28075135"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 08:20:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="18069444"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 08:20:14 -0700
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Xiao Ni <xni@redhat.com>,
	Jes Sorensen <jes@trained-monkey.org>
Subject: [PATCH 0/2] mdadm: Fix --detail --export issue
Date: Mon, 18 Mar 2024 16:19:28 +0100
Message-Id: <20240318151930.8218-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 60c19530dd7c ("Detail: remove duplicated code") introduced
regression catched by 00confnames because generated UUID was different
than expected. This patchset fixes the issue.

Mariusz Tkaczyk (2):
  mdadm: set swapuuid in all handlers
  mdadm: Fix native --detail --export

Cc: Xiao Ni <xni@redhat.com>
Cc: Jes Sorensen <jes@trained-monkey.org>

 Detail.c      | 26 +++++++++++++++++++++++++-
 mdadm.h       |  3 +--
 super-ddf.c   | 11 ++++++-----
 super-intel.c | 17 +++++++++--------
 super0.c      |  2 ++
 util.c        | 24 +++++++++++++-----------
 6 files changed, 56 insertions(+), 27 deletions(-)

-- 
2.35.3

