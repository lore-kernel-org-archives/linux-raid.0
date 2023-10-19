Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2160CDB483
	for <linux-raid@archiver.kernel.org>; Thu, 19 Oct 2023 14:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346169AbjJSOfs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Oct 2023 10:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346205AbjJSOfp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Oct 2023 10:35:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCA3193
        for <linux-raid@vger.kernel.org>; Thu, 19 Oct 2023 07:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697726142; x=1729262142;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NFiR8E/VE4D9u0GetaW9atODvYuM0Jw1pd8D8bTh1wk=;
  b=cgwltz+EPYzh8IMFbEsymb8wnUF7T5OFDVPOdCQOdy1U/nny98dCZ7Ss
   BnhAujKMMNrAOh46L/FtoWKjBGvkbgp3SgjcKr81XHgRjFTh6aZeWKl6t
   NlSEK66RoDMm6QljVBHAnYzcm2tfI9H4uPQakN2/oYTEEaTKLcqj0Ab6j
   rMr7hKByKRSG59+Y9x4yzWUvO9bt/3ZWeBo/nX6sb9Te9Lm8uK+r+4xZr
   i0Mco2uLE1Tq5333gee8CtKNXb6ItyOQ8a8V/4t7iNp3bH0tLrzUkYbAM
   ekGuraoWLBnIENXBuF8iuY4PUGxh33D2h4M6AC/6IU5xp+SqtO2Ie29W+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="385139983"
X-IronPort-AV: E=Sophos;i="6.03,237,1694761200"; 
   d="scan'208";a="385139983"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 07:35:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="880675478"
X-IronPort-AV: E=Sophos;i="6.03,237,1694761200"; 
   d="scan'208";a="880675478"
Received: from dev-ppiatko.ger.corp.intel.com ([10.102.95.202])
  by orsmga004.jf.intel.com with ESMTP; 19 Oct 2023 07:35:41 -0700
From:   Pawel Piatkowski <pawel.piatkowski@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 2/2] Fix assembling RAID volume by using incremental
Date:   Thu, 19 Oct 2023 16:35:25 +0200
Message-Id: <20231019143525.2086-3-pawel.piatkowski@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20231019143525.2086-1-pawel.piatkowski@intel.com>
References: <20231019143525.2086-1-pawel.piatkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

After change "mdadm: remove container_enough logic"
IMSM volumes are started immediately. If volume is during
reshape, then it will be blocked by block_subarray() during
first mdadm -I <devname>. Assemble_container_content() for
next disk will see the change because metadata version from
sysfs and metadata doesn't match and will execute
sysfs_set_array again. Then it fails to set same
component_size, it is prohibited by kernel.

If array is frozen then first sign from metadata version
is different ("/" vs "-"), so exclude it from comparison.
All we want is to double check that base properties are set
and we don't need to call sysfs_set_array again.

Signed-off-by: Pawel Piatkowski <pawel.piatkowski@intel.com>
---
 Assemble.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 49804941..add002f8 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1982,12 +1982,10 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		return 1;
 	}
 
-	if (strcmp(sra->text_version, content->text_version) != 0) {
-		if (content->array.major_version == -1 &&
-		    content->array.minor_version == -2 &&
-		    c->readonly &&
-		    content->text_version[0] == '/')
-			content->text_version[0] = '-';
+	/* Fill sysfs properties only if they are not set. Determine it by checking text_version
+	 * and ignoring special character on the first place.
+	 */
+	if (strcmp(sra->text_version + 1, content->text_version + 1) != 0) {
 		if (sysfs_set_array(content, 9003) != 0) {
 			sysfs_free(sra);
 			return 1;
-- 
2.39.1

