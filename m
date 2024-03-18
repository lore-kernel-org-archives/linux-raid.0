Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6474EB5E
	for <linux-raid@vger.kernel.org>; Mon, 18 Mar 2024 15:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710775221; cv=none; b=DZ1J5kzuD7zkFTFVy/jdaDdVfD7BzoE+5euo90aZ2AhXEEdIqgp3j5A4LsWcdlnlUvf2x2+AhDDsZRp6w0/xc6ugsdNmqofmtJNyN3V18FfAZOHnCbyn0wnqtm0Jl2hhZWnjE1KW3/RAhGVlYLvE67Nl4Pm7yt1Y8519fIq26eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710775221; c=relaxed/simple;
	bh=SfM1U8MqBRaSycEcqoNPWgR5ii0nloeV3jsizMYs2e0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m7j92ETjsVzY5jER4ln/+Bjf3PRyMkm2Domof7i0D213+ONr1jQ3wGtOoU8IAdOqb8HsYZfor/h/joeX2j6ibWcJI3KNezg3Khd5nso2Rm5/yGrSImWgnRKGIZkwcQbBm70/Mp/ZnzCXNw7vKJdZFq6ksAhQeBKBPb9ltvu74Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JL5hi6gr; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JL5hi6gr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710775220; x=1742311220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SfM1U8MqBRaSycEcqoNPWgR5ii0nloeV3jsizMYs2e0=;
  b=JL5hi6grAPmpw7qWdxnX3Mlfyz6/sxMfDWKT/E7MGQZXZtNZDNp8D2Qp
   PPnjUCwcucyG/nxJrc6EIkHbAwNIQcUYHjCXj/US/fkND2eThB1abwoOR
   wIE1qgNZ8Q5RtVQ2xEgrg4l1sSK0mRPlRpxE2lJBs7eMMKqhvRgzAk76v
   46oSU78uhdRRokqYy1TQkG7HAp5HYtOy+J9n0hMMkozGYi8+vzeXpxD/p
   RkW0Ywi3s+cNY0cvbh6Yw6sdIhfEpGFia5bAyz//bEejnLF0cXki184eh
   +YZReKAFvOLXJfCBwso8KpDbSi4CxKWxMUF9AGUMDbfr/jsMPSxZc0MG5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="28075145"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="28075145"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 08:20:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="18069449"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 08:20:18 -0700
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Xiao Ni <xni@redhat.com>,
	Jes Sorensen <jes@trained-monkey.org>
Subject: [PATCH 1/2] mdadm: set swapuuid in all handlers
Date: Mon, 18 Mar 2024 16:19:29 +0100
Message-Id: <20240318151930.8218-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240318151930.8218-1-mariusz.tkaczyk@linux.intel.com>
References: <20240318151930.8218-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is not set, so it should be 0 but it may vary on compilation
settings. Set it always to 0.

metadata should care to set UUID and read in proper endianness so it
doesn't follow super1 concept of swapuuid to depend on endianness.

It is not an attempt to fix endianness issues.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-ddf.c   | 1 +
 super-intel.c | 1 +
 super0.c      | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/super-ddf.c b/super-ddf.c
index 7571e3b740c6..94ac5ff3965a 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -5162,6 +5162,7 @@ struct superswitch super_ddf = {
 	.default_geometry = default_geometry_ddf,
 
 	.external	= 1,
+	.swapuuid	= 0,
 
 /* for mdmon */
 	.open_new       = ddf_open_new,
diff --git a/super-intel.c b/super-intel.c
index 7714045575b2..e1754f29246c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -13116,6 +13116,7 @@ struct superswitch super_imsm = {
 	.validate_ppl	= validate_ppl_imsm,
 
 	.external	= 1,
+	.swapuuid	= 0,
 	.name = "imsm",
 
 /* for mdmon */
diff --git a/super0.c b/super0.c
index a7c5f813d926..9b8a1bd63bb7 100644
--- a/super0.c
+++ b/super0.c
@@ -1369,5 +1369,7 @@ struct superswitch super0 = {
 	.locate_bitmap = locate_bitmap0,
 	.write_bitmap = write_bitmap0,
 	.free_super = free_super0,
+
+	.swapuuid = 0,
 	.name = "0.90",
 };
-- 
2.35.3

