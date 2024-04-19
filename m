Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E377BAF5
	for <linux-raid@vger.kernel.org>; Fri, 19 Apr 2024 09:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713519587; cv=none; b=dOgJpC4o7TJr/UqXrLl2ebmGiQo6AX8qLj5rXR3TjDq4aogtyF3d57ynb3eeN9ByjA16mnUY818QT+FTXUOJDGLvCTzXFv41mZgNWo/1ib6Avse5mzeVzcMCAl5mDohMHO7ammUZan/syMF13avqVUArBDWwLD5OeyDChnp5RUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713519587; c=relaxed/simple;
	bh=uDD75Ng10UrCZJ6UpiuWV7cAF5ihdWe4f6/g3Oc2/VE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jbyrzjeq/oYAf34LlrYfncQKxsx6BoUVqCfdJC5ZNh1+dM7GwDUfv4+/zwFSKhy7K+Qdq2XSk2JFquM6fnJ/a1Dqvs2+H31o6sQF9Cpbn+M6DtgFySH6fvDMpo3Lmu4zapxfqh0FDGz2R4/CXdQf4MoNZSHyUT86bzfRj4cAVcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P1mLceyt; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P1mLceyt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713519586; x=1745055586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uDD75Ng10UrCZJ6UpiuWV7cAF5ihdWe4f6/g3Oc2/VE=;
  b=P1mLceytd1jitrqlL+upihU2YojxE3QWKdlh1166KkVj1pi8kaPbkO+7
   wNn6Ox+jWCIsYJxP265naxifpt2a5hrnFvM4f+lzLU8FtHHMzyunX95fG
   o6AhHf3Nw5po2zCDhVY68hraQ+8EzQEMKcplGIHTmRIhuAZKNXjnD9RD3
   nJ42AVqLHGP5k/+huXuMTDXvCuMvV0LDkRI+azCdOLFsRkhvfK2fbx16X
   AZyxiie+PbzrRmkXw06OwPgCJqqZ1nKmKYXyK2pqxAspCg3BZjcUjI1U7
   euGJOcAs2smNxfluuhTNSnQ638RKfVomCIYZtMXvhXThbKpEsQ/obL3I8
   w==;
X-CSE-ConnectionGUID: ken8ZaJkTuuQDsKlvICS2g==
X-CSE-MsgGUID: hesaMttvSCGL197bXxuVFQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="20254691"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="20254691"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 02:39:46 -0700
X-CSE-ConnectionGUID: Sk8pSsKhSYWOKs2A640RvA==
X-CSE-MsgGUID: QrwdOzmTQpKbJOplhIi38A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23714997"
Received: from unknown (HELO mtkaczyk-dev.igk.intel.com) ([10.102.108.41])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 02:39:44 -0700
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Paul E Luse <paul.e.luse@linux.intel.com>,
	Song Liu <song@kernel.org>,
	Kinga Tanska <kinga.tanska@linux.intel.com>,
	Jes Sorensen <jes@trained-monkey.org>
Subject: [PATCH 1/1] mdadm: Change main repository to Github
Date: Fri, 19 Apr 2024 03:48:39 +0200
Message-Id: <20240419014839.8986-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com>
References: <20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now github will be used for tracking mdadm, adjust README.md.
Daily routines will be automated on Github, there is not need to
describe them.

Adjust release process, it must be published to both repositories.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 MAINTAINERS.md | 41 +++++++++++----------------------
 README.md      | 61 ++++++++++++++++++++------------------------------
 2 files changed, 37 insertions(+), 65 deletions(-)

diff --git a/MAINTAINERS.md b/MAINTAINERS.md
index 9c79ba8748cd..e5b635f02d65 100644
--- a/MAINTAINERS.md
+++ b/MAINTAINERS.md
@@ -1,44 +1,29 @@
 # Maintainer tools
 
-Useful tools used in daily routines:
+Useful tools for mdadm maintenance:
 - [checkpatch](https://docs.kernel.org/dev-tools/checkpatch.html)
 - [kup](https://korg.docs.kernel.org/kup.html)
 - [Auto-publishing](https://korg.docs.kernel.org/kup.html#auto-publishing-with-git-archive-signer)
 - [b4](https://b4.docs.kernel.org/en/latest/)
 
-# Checklist before applying patch
-
-We don't have CI testing yet, so all those steps must be performed manually:
-- Style check with [checkpatch](https://docs.kernel.org/dev-tools/checkpatch.html):
-
-  This is the current code style follows. We are not strict to all rules. It must be run
-  by **checkpatch --no-tree**, see README.md.
-
-- [Commit style](https://www.kernel.org/doc/html/v4.10/process/submitting-patches.html):
-
-  It doesn't need to be followed as strictly as is in kernel but changes should be logically
-  separated. Submitter should care at least to mention "It is used in next patches" if unused
-  externs/files are added in patch. We love: *Reported-by:*, *Suggested-by:*, *Fixes:* tags.
-
-- Compilation, ideally on various gcc versions.
-- Mdadm test suite execution.
-- Consider requesting new tests from submitter, especially for new functionalities.
-- Ensure that maintainer *sign-off* is added, before pushing.
-
 # Making a release
 
 Assuming that maintainer is certain that release is safe, following steps must be done:
 
-- Update versions strings in release commit, please refer to previous releases for examples.
+- Make and push release commit:
+  - Update versions strings, refer to previous releases for examples.
+  - Update CHANGELOG.md.
+
+- Create GPG signed tag and push it to both remotes. Use same format as was used previously,
+  prefixed by **mdadm-**, e.g. **mdadm-3.1.2**, **mdadm-4.1**.
 
-- Create GPG signed tag and push it to repo. Use same format as was used previously, prefixed by
-  **mdadm-**, e.g. **mdadm-3.1.2**, **mdadm-4.1**.
+- Run kernel.org
+  [Auto-publishing](https://korg.docs.kernel.org/kup.html#auto-publishing-with-git-archive-signer):
 
-- [Auto-publishing](https://korg.docs.kernel.org/kup.html#auto-publishing-with-git-archive-signer):
+  Adopt script to our release tag model. When ready, push signed note to kernel.org repository. If
+  it is done correctly, then *(sig)* is added to the package automatically generated by
+  kernel.org automation. There is no need to upload archive manually.
 
-  Adopt script to our release tag model. When ready, push signed note to repository. If it is done
-  correctly, then *(sig)* is added to the package automatically generated by kernel.org automation.
-  There is no need to upload archive manually.
+- Add release entry on Github.
 
-- Update CHANGELOG.md.
 - Write "ANNOUNCE" mail to linux-raid@kernel.org to notify community.
diff --git a/README.md b/README.md
index 64f2ecec784e..0f9eccaf7f07 100644
--- a/README.md
+++ b/README.md
@@ -20,58 +20,45 @@
     **IMPORTANT:** DDF is in **maintenance only** mode. There is no active development around it.
     Please do not use it in new solutions.
 
-# How to Contribute
+# How to Ask
 
- **mdadm** is hosted on [kernel.org](https://kernel.org/). You can access repository
-[here](https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git).
+You can use either Github panels (Issues or Discussions) on
+[Github](https://github.com/md-raid-utilities/mdadm) or ask on
+[Mailing List](https://lore.kernel.org/linux-raid/).
 
-It is maintained similarly to kernel, using *mailing list*. Patches must be send through email.
-Please familiarize with general kernel
-[submitting patches](https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html)
-documentation. Formatting, tags and commit message guidelines applies to **mdadm**.
+While we are transitioning to GitHub, you may want to use the Mailing List in order to reach a wider
+audience. Also, please use the Mailing list for all questions not specifically related to mdadm
+itself (mdraid, etc).
 
-## Sending patches step-by-step
+# How to Contribute
 
-To maximize change of patches being taken, follow this instruction when submitting:
+Effective immediately [Github](https://github.com/md-raid-utilities/mdadm) is the primary
+location for **mdadm**. Use pull request to contribute.
 
-1. Create possibly logically separated commits and generate patches:
+It was originally hosted on [kernel.org](https://kernel.org/). You can access the old repository
+[here](https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git).
 
-   Use ``git format-patch --cover-letter --signoff -v <nr>`` to create patches:
-   * ``--cover-letter`` can be skipped if it is only one patch;
-   * ``--signoff`` adds sign-off tag;
-   * ``-v <nr>`` indicates review revision number, sender should increment it before resending.
+**Patches sent through Mailing List are no longer accepted.**
 
-2. Check style of every patch with kernel
-   [checkpatch](https://docs.kernel.org/dev-tools/checkpatch.html) script:
+Kernel coding style is used. Please familiarize with general kernel
+[submitting patches](https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html)
+documentation. Formatting, tags and commit message guidelines applies to **mdadm**.
 
-   It is important to keep same coding style that is why in **mdadm**
-   [kernel coding style](https://www.kernel.org/doc/html/v4.10/process/coding-style.html)
-   is preferred. ``checkpath --no-tree <patch_file>`` can be used to verify patches.
-   Following checkpatch issues can be ignored:
-   - New typedefs.
-   - comparing with *True/False*.
-   - kernel *MAINTAINERS* file warning.
-   - *extern* keyword in headers.
+[Checkpatch](https://docs.kernel.org/dev-tools/checkpatch.html) script is run on
+every patch in pull request so be sure that your commits are not generating
+issues. There are some excludes, so the best is to follow github checkpatch action result.
 
-3. Send patches using ``git send-mail --to=linux-raid@vger.kernel.org <cover-letter> <patch1> <patch2> (...)``
+Pull Request are closed by `Rebase and Merge` option, so it requires to keep every commit
+meaningful. Kernel style requires that. The review changes must be pushed with **push --force**
+to the chosen branch, then Pull Request will be automatically updated.
 
-# Maintainers
+# Maintainers of mdadm repository on kernel.org
 
-It is good practice to add **mdadm maintainers** to recipients for patches:
+If there are differences between github and kernel.org, please contact kernel.org mdadm maintainers:
 
 - Jes Sorensen <jes@trained-monkey.org>;
 - Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>;
 
-Adding **MD maintainers** could be reasonable, especially if patches may affect MD driver:
-
-- Song Liu <song@kernel.org>;
-- Yu Kuai <yukuai3@huawei.com>;
-
-# Reviewers
-
-**mdadm** utility is not part of kernel tree, so there is no certificated *Reviewers* list. Everyone
-can comment on mailing list, last decision (and merging) belongs to maintainers.
-
 # Minimal supported kernel version
 
 We do not support kernel versions below **v3.10**. Please be aware that maintainers may remove
-- 
2.35.3

