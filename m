Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D194481729
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 15:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714403978; cv=none; b=jKFB1xsd+G0Wfuhbbh0lAfQgqFgbmEB3hS4rUHhSrpotMr5R4xu7dqbL9st1vyKIudI8YypcJbt8Ek7GTLdK69qAd+cQXzG5ZeQ2/0CECtfkdvyJwDqleaoX1Ll+fMAD50w/MNI/iIODBV8F6SuGLIMQrhKw0YP/TPZX4+3jzoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714403978; c=relaxed/simple;
	bh=LxQx96SM48oWI9MVCby7x6HHMROXWYrv/niv5mwSxjw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mVpnZZbOO/utHemctR0Z7okF+uww5bhN4T85ZfIZxBIBvQBk1SXNGm9lp9loK2UXn1qL6577PPS5SiP1xJ5iohgOU61ipahC7hlagHo7WYCEDezdYK/iOmhNyO5q4ZH1U0/OAN+ozrUlR6NTXM7BIOpKC4aZM4e0Sgu/AbF+YlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L51aesZv; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L51aesZv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714403977; x=1745939977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LxQx96SM48oWI9MVCby7x6HHMROXWYrv/niv5mwSxjw=;
  b=L51aesZv2VpQwU/CfQn6YBU5SnRCGTc6fWzXEgXk7mYE71MyNZShouiT
   deox+fd8zh+gBChrlm36Q/Q/5zSAwu6FZMmUegjH67kgXFpS4ImAX9bVe
   v+6AGh4nVhSvrNrGbLZy4EjDg0FXM65y36nsquSQ2Dhfgioh2nGn5XH2x
   VKJUEf1i9mxPCTUsiDyXIqhr+WIPhigKTv9uOwhhodJSEhTxyJ/8DCHg+
   xzM7b5neZr87T72L5MhbtqUliBjE1hpfqzISNQv17m5jRtN6Cdk/Driez
   r9/XxY4SEcPkP8L7B8C01YPZnxQuobWzD6ITzsfAaxkVw2WiyImF3hSJj
   g==;
X-CSE-ConnectionGUID: srzVaRDyROq1SYnK+tXdmA==
X-CSE-MsgGUID: Vf9kY036TWScVQymBQeYeg==
X-IronPort-AV: E=McAfee;i="6600,9927,11059"; a="10288827"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="10288827"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 08:19:36 -0700
X-CSE-ConnectionGUID: fpLAMjAmTYqaITvjqfyZvQ==
X-CSE-MsgGUID: kQuQZdgqR0iBKQji8gs9sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26127035"
Received: from unknown (HELO mtkaczyk-dev.igk.intel.com) ([10.102.108.41])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 08:19:35 -0700
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Paul E Luse <paul.e.luse@linux.intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Song Liu <song@kernel.org>,
	Kinga Tanska <kinga.tanska@linux.intel.com>,
	Jes Sorensen <jes@trained-monkey.org>
Subject: [PATCH v2 1/1] mdadm: Change main repository to Github
Date: Mon, 29 Apr 2024 09:28:56 +0200
Message-Id: <20240429072856.10603-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240429072856.10603-1-mariusz.tkaczyk@linux.intel.com>
References: <20240429072856.10603-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now github will be used for tracking mdadm, adjust README.md.
Daily routines will be automated on Github, there is not need to
decribe them.

Adjust release process, it must be published to both repositories.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 MAINTAINERS.md | 41 ++++++++----------------
 README.md      | 84 +++++++++++++++++++++++++++-----------------------
 2 files changed, 59 insertions(+), 66 deletions(-)

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
index 64f2ecec784e..f959a210eeb0 100644
--- a/README.md
+++ b/README.md
@@ -20,58 +20,66 @@
     **IMPORTANT:** DDF is in **maintenance only** mode. There is no active development around it.
     Please do not use it in new solutions.
 
-# How to Contribute
-
- **mdadm** is hosted on [kernel.org](https://kernel.org/). You can access repository
-[here](https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git).
+# Questions and Support
+
+This Github site is **not** right place to ask if your are looking for:
+- support from Linux Raid Community;
+- support with kernel issues;
+
+This is a the place where development of mdadm application is done. Please, do not use for
+looking for support. You should always ask on [Mailing List](https://lore.kernel.org/linux-raid/).
+
+Please use issues if you have confirmation that issue you are experiencing is related to mdadm
+components:
+- mdadm;
+- mdmon;
+- raid6check;
+- swap_super;
+- test_stripe;
+- systemd services ( see systemd/);
+- udev rules;
+- manual pages (including md.man)
+
+For example:
+- mdadm issues (e.g segfaults, memory leaks, crashes, bad communication with MD driver);
+- feature requests for mdadm;
+- suggestions or minor fixes requested (e.g. better error messages);
+
+Generally, if you are not sure it is better to ask on
+[Mailing List](https://lore.kernel.org/linux-raid/) first.
 
-It is maintained similarly to kernel, using *mailing list*. Patches must be send through email.
-Please familiarize with general kernel
-[submitting patches](https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html)
-documentation. Formatting, tags and commit message guidelines applies to **mdadm**.
+# How to Contribute
 
-## Sending patches step-by-step
+Effective immediately [Github](https://github.com/md-raid-utilities/mdadm) is the primary
+location for **mdadm**. Use pull request to contribute.
 
-To maximize change of patches being taken, follow this instruction when submitting:
+It was originally hosted on [kernel.org](https://kernel.org/). You can access the old repository
+[here](https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git).
 
-1. Create possibly logically separated commits and generate patches:
+**Patches sent through Mailing List are no longer accepted.**
 
-   Use ``git format-patch --cover-letter --signoff -v <nr>`` to create patches:
-   * ``--cover-letter`` can be skipped if it is only one patch;
-   * ``--signoff`` adds sign-off tag;
-   * ``-v <nr>`` indicates review revision number, sender should increment it before resending.
+**NOTE:** Maintainers may ask you to send RFC to mailing list if the proposed code requires
+consultation with kernel developers.
 
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

