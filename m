Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D757A12B6C
	for <linux-raid@vger.kernel.org>; Tue, 26 Mar 2024 12:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711455702; cv=none; b=Sgj2kWQhnuQ5DUCHYc/E55umV4eZgKHxpa3XwwR86SPUV4UnwRLIW52EZcfl6UXSSt7sNrkTnh+vTw5+iJ9JXOu/+Tc81lzj3OyCTnM2Gc2apot/d7Kkxud/QXkD0WTJ54yNlSCO2dJ/R3JjSDT0C+6JrMSIpp4nuE8iU3GG6iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711455702; c=relaxed/simple;
	bh=/y0YuaFDpWGKpcMVUAF/1imv13E2F4OVbBgGfW9kcY0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GmN/OMIaOhv5mkTDxbjpo6YOdjo+NB9xE2mg2Qlx0nJZCQnmz+Lh5v5KUr4cSFSNJJR9Oc5SLHAKg5pBcfqu0WIofrKWRWbjImC+Ev8wKDVFcv+dY11NLE8dLhQiLK2J1VzyNlbJI54j5dMO2quyw7SFU0QWCrPHWjaMn4rmf3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lSdE/83z; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lSdE/83z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711455701; x=1742991701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/y0YuaFDpWGKpcMVUAF/1imv13E2F4OVbBgGfW9kcY0=;
  b=lSdE/83zrJu9loBDpVLTyMXABvxnKdUFQiV4oXYZgiLO/1bmbLQbVAAB
   4/TeDSjudCE3NcoxRwnzkxbZ/eUUn6Xgp/i7fgyxCeCWWC6G4J9pLjcLl
   be1Bpzg1TRTEly65GG0/9DXWXykt9Ed39oQTM9wFredAb2gQ2QE5Rxul0
   9s7E3uZ9PaMGoHkEOYVr8EKN1Pjwlg8AlehkHozZI63EdZZfq+jGTOZ6W
   K72ILB/1AHz8MOEFiwj0LU/XEhtF7ESDnRtc+ukGtCqEDSXU9DEK0FooY
   b94DqLIPKZ0GwkEI7dXOYuWYGt7BKGeWIq0JmFEz8XlLo5++lDD6hv+7D
   A==;
X-CSE-ConnectionGUID: fxxVmhtWRG+ssAvZPtdvZQ==
X-CSE-MsgGUID: fnKO7y1ERM+s0rZkQ2KiyA==
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="17891012"
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="17891012"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 05:21:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="20425530"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 05:21:39 -0700
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Jes Sorensen <jes@trained-monkey.org>,
	Nix <nix@esperi.org.uk>
Subject: [PATCH 2/3] mdadm: Add MAINTAINERS.md
Date: Tue, 26 Mar 2024 13:21:11 +0100
Message-Id: <20240326122112.25552-3-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240326122112.25552-1-mariusz.tkaczyk@linux.intel.com>
References: <20240326122112.25552-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Describe rules maintainer should follow.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 MAINTAINERS.md | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 MAINTAINERS.md

diff --git a/MAINTAINERS.md b/MAINTAINERS.md
new file mode 100644
index 000000000000..9c79ba8748cd
--- /dev/null
+++ b/MAINTAINERS.md
@@ -0,0 +1,44 @@
+# Maintainer tools
+
+Useful tools used in daily routines:
+- [checkpatch](https://docs.kernel.org/dev-tools/checkpatch.html)
+- [kup](https://korg.docs.kernel.org/kup.html)
+- [Auto-publishing](https://korg.docs.kernel.org/kup.html#auto-publishing-with-git-archive-signer)
+- [b4](https://b4.docs.kernel.org/en/latest/)
+
+# Checklist before applying patch
+
+We don't have CI testing yet, so all those steps must be performed manually:
+- Style check with [checkpatch](https://docs.kernel.org/dev-tools/checkpatch.html):
+
+  This is the current code style follows. We are not strict to all rules. It must be run
+  by **checkpatch --no-tree**, see README.md.
+
+- [Commit style](https://www.kernel.org/doc/html/v4.10/process/submitting-patches.html):
+
+  It doesn't need to be followed as strictly as is in kernel but changes should be logically
+  separated. Submitter should care at least to mention "It is used in next patches" if unused
+  externs/files are added in patch. We love: *Reported-by:*, *Suggested-by:*, *Fixes:* tags.
+
+- Compilation, ideally on various gcc versions.
+- Mdadm test suite execution.
+- Consider requesting new tests from submitter, especially for new functionalities.
+- Ensure that maintainer *sign-off* is added, before pushing.
+
+# Making a release
+
+Assuming that maintainer is certain that release is safe, following steps must be done:
+
+- Update versions strings in release commit, please refer to previous releases for examples.
+
+- Create GPG signed tag and push it to repo. Use same format as was used previously, prefixed by
+  **mdadm-**, e.g. **mdadm-3.1.2**, **mdadm-4.1**.
+
+- [Auto-publishing](https://korg.docs.kernel.org/kup.html#auto-publishing-with-git-archive-signer):
+
+  Adopt script to our release tag model. When ready, push signed note to repository. If it is done
+  correctly, then *(sig)* is added to the package automatically generated by kernel.org automation.
+  There is no need to upload archive manually.
+
+- Update CHANGELOG.md.
+- Write "ANNOUNCE" mail to linux-raid@kernel.org to notify community.
-- 
2.35.3

