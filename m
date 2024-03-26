Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27D27316A
	for <linux-raid@vger.kernel.org>; Tue, 26 Mar 2024 12:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711455705; cv=none; b=qOK2eHHYobS/vO1lsgS81Dws5OwPTnLd4N/tq0eZj78EBdysvOqwNv5EiHRauPZjOB7b84t2TDBU1FZyfNsec7ckb+W2saXmIkY0b5LbJBovhYYCPBfguwNYQJXkUY1B0dZOJkhpnB1HuCYwf4aHkOzPFr/khel7+TIXigLR9mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711455705; c=relaxed/simple;
	bh=SYE4jA+PrnI+riGNBmIFEd7NtGhK2AlmrdTOqfG2FTk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fc4ZR1P0mLhawTV00H5G+alDOuls7LMAUI/NSleAYiTxqxkv+xipD9h8GrqHBoLCBIeG3xvhUJuXNKGXOR6NGsHvU0wYhVbtIaxgDxaczz/u+pTsigSXlsEXxm2GcbvBExJHZ/zRx7nO/qORfMLJkZtQ/B8ObC6N7rJg1YekuAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ApIU8ygD; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ApIU8ygD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711455703; x=1742991703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SYE4jA+PrnI+riGNBmIFEd7NtGhK2AlmrdTOqfG2FTk=;
  b=ApIU8ygDihztqIYzYqMDHuFAJ5f5OaSXFhicMoRKYnV67aCLQ6H65OQF
   b6AJs7kohjkWqs/m9mn3JefjU1Z+qdIbqACTugLV6xqj2OnASVJOwVF6c
   0sL2iF63zClwurF3CAT0ddb951X01fDABdgGPCMxeFKrI2x6/w+Cq/SKK
   XmzHTOOSJ1JPgkt13BcnKY0gecSVOQ51o2ZZtX+qjpGS5QiTmFxT9sq0v
   e3cP5gOp4iH42Wmv198t0yW/gU4ABotvIxOn//O5NPieRvnYvewlJsc5p
   KfjJRglSPsLencbdqGUayY3xPKk6njUyQB7/psQPANKeexWj5mAfZQrQp
   w==;
X-CSE-ConnectionGUID: wBDEimg/TUSpOkUu1WDuBw==
X-CSE-MsgGUID: ukuwWA5yQX+2x3VqQkzbUQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="17891015"
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="17891015"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 05:21:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="20425544"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 05:21:41 -0700
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Jes Sorensen <jes@trained-monkey.org>,
	Nix <nix@esperi.org.uk>
Subject: [PATCH 3/3] mdadm: Add README.md
Date: Tue, 26 Mar 2024 13:21:12 +0100
Message-Id: <20240326122112.25552-4-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240326122112.25552-1-mariusz.tkaczyk@linux.intel.com>
References: <20240326122112.25552-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Describe supported metadata types, add step-by-step patch sending
instruction, mention minimally supported kernel version and licensing.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 README.md | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)
 create mode 100644 README.md

diff --git a/README.md b/README.md
new file mode 100644
index 000000000000..64f2ecec784e
--- /dev/null
+++ b/README.md
@@ -0,0 +1,83 @@
+**mdadm** is a utility used to create and manage **software RAID** devices implemented through
+**Multiple devices driver (MD)** in kernel. It supports following RAID metadata formats:
+
+* [Linux native RAID](https://raid.wiki.kernel.org/index.php/RAID_superblock_formats):
+
+  Known as **native** or **native RAID**. First and default metadata format. Metadata management
+  is implemented in **MD driver**.
+
+* Matrix Storage Manager Support (no reference, metadata format documentation is proprietary).
+
+  Known as **IMSM**. Metadata format developed and maintained by **Intel®** as a part of **VROC**
+  solution. There are some functional differences between **native** and **imsm**. The most
+  important difference is that the metadata is managed from userspace.
+
+  **CAUTION:** **imsm** is compatible with **Intel RST**, however it is not officially supported.
+  You are using it on your own risk.
+
+* [Common RAID DDF Specification Revision](https://www.snia.org/sites/default/files/SNIA_DDF_Technical_Position_v2.0.pdf)
+
+    **IMPORTANT:** DDF is in **maintenance only** mode. There is no active development around it.
+    Please do not use it in new solutions.
+
+# How to Contribute
+
+ **mdadm** is hosted on [kernel.org](https://kernel.org/). You can access repository
+[here](https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git).
+
+It is maintained similarly to kernel, using *mailing list*. Patches must be send through email.
+Please familiarize with general kernel
+[submitting patches](https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html)
+documentation. Formatting, tags and commit message guidelines applies to **mdadm**.
+
+## Sending patches step-by-step
+
+To maximize change of patches being taken, follow this instruction when submitting:
+
+1. Create possibly logically separated commits and generate patches:
+
+   Use ``git format-patch --cover-letter --signoff -v <nr>`` to create patches:
+   * ``--cover-letter`` can be skipped if it is only one patch;
+   * ``--signoff`` adds sign-off tag;
+   * ``-v <nr>`` indicates review revision number, sender should increment it before resending.
+
+2. Check style of every patch with kernel
+   [checkpatch](https://docs.kernel.org/dev-tools/checkpatch.html) script:
+
+   It is important to keep same coding style that is why in **mdadm**
+   [kernel coding style](https://www.kernel.org/doc/html/v4.10/process/coding-style.html)
+   is preferred. ``checkpath --no-tree <patch_file>`` can be used to verify patches.
+   Following checkpatch issues can be ignored:
+   - New typedefs.
+   - comparing with *True/False*.
+   - kernel *MAINTAINERS* file warning.
+   - *extern* keyword in headers.
+
+3. Send patches using ``git send-mail --to=linux-raid@vger.kernel.org <cover-letter> <patch1> <patch2> (...)``
+
+# Maintainers
+
+It is good practice to add **mdadm maintainers** to recipients for patches:
+
+- Jes Sorensen <jes@trained-monkey.org>;
+- Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>;
+
+Adding **MD maintainers** could be reasonable, especially if patches may affect MD driver:
+
+- Song Liu <song@kernel.org>;
+- Yu Kuai <yukuai3@huawei.com>;
+
+# Reviewers
+
+**mdadm** utility is not part of kernel tree, so there is no certificated *Reviewers* list. Everyone
+can comment on mailing list, last decision (and merging) belongs to maintainers.
+
+# Minimal supported kernel version
+
+We do not support kernel versions below **v3.10**. Please be aware that maintainers may remove
+workarounds and fixes for legacy issues.
+
+# License
+
+It is released under the terms of the **GNU General Public License version 2** as published
+by the **Free Software Foundation**.
-- 
2.35.3

