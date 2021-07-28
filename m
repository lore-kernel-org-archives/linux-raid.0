Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FAEC4338F
	for <linux-raid@archiver.kernel.org>; Wed, 28 Jul 2021 14:41:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EB56608FB
	for <linux-raid@archiver.kernel.org>; Wed, 28 Jul 2021 14:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbhG1OlI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Jul 2021 10:41:08 -0400
Received: from mga04.intel.com ([192.55.52.120]:52195 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235389AbhG1OlH (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 28 Jul 2021 10:41:07 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10058"; a="210790456"
X-IronPort-AV: E=Sophos;i="5.84,276,1620716400"; 
   d="scan'208";a="210790456"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2021 07:41:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,276,1620716400"; 
   d="scan'208";a="417779687"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.57])
  by orsmga003.jf.intel.com with ESMTP; 28 Jul 2021 07:41:04 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] tests: Avoid passing chunk size when creating RAID 1
Date:   Wed, 28 Jul 2021 16:31:11 +0200
Message-Id: <20210728143111.4478-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Tests fail because passing chunk size for RAID 1 is now forbidden.
Failing tests:
- 14imsm-r1_2d-grow-r1_3d
- 14imsm-r1_2d-takeover-r0_2d
- 18imsm-1d-takeover-r1_2d
- 18imsm-r1_2d-takeover-r0_1d

Correct tests to not pass chunk size when RAID level is 1.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 tests/14imsm-r1_2d-grow-r1_3d     |  1 -
 tests/14imsm-r1_2d-takeover-r0_2d |  1 -
 tests/18imsm-1d-takeover-r1_2d    |  2 +-
 tests/18imsm-r1_2d-takeover-r0_1d |  1 -
 tests/imsm-grow-template          | 18 +++++++++++++-----
 5 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/tests/14imsm-r1_2d-grow-r1_3d b/tests/14imsm-r1_2d-grow-r1_3d
index 1edd50e4..be20ab81 100644
--- a/tests/14imsm-r1_2d-grow-r1_3d
+++ b/tests/14imsm-r1_2d-grow-r1_3d
@@ -10,7 +10,6 @@ spare_list="$dev4"
 # Before: RAID 1 volume, 2 disks, 64k chunk size
 vol0_level=1
 vol0_comp_size=$((5 * 1024))
-vol0_chunk=64
 vol0_num_comps=$((num_disks - 1))
 vol0_offset=0
 
diff --git a/tests/14imsm-r1_2d-takeover-r0_2d b/tests/14imsm-r1_2d-takeover-r0_2d
index d8296815..27002e1c 100644
--- a/tests/14imsm-r1_2d-takeover-r0_2d
+++ b/tests/14imsm-r1_2d-takeover-r0_2d
@@ -10,7 +10,6 @@ device_list="$dev0 $dev1"
 # Before: RAID 1 volume, 2 disks, 64k chunk size
 vol0_level=1
 vol0_comp_size=$((5 * 1024))
-vol0_chunk=64
 vol0_num_comps=$((num_disks - 1))
 vol0_offset=0
 
diff --git a/tests/18imsm-1d-takeover-r1_2d b/tests/18imsm-1d-takeover-r1_2d
index 72e4173e..e38ed89b 100644
--- a/tests/18imsm-1d-takeover-r1_2d
+++ b/tests/18imsm-1d-takeover-r1_2d
@@ -12,7 +12,7 @@ check wait
 imsm_check container $vol0_num_comps
 
 # Create RAID 1 volume
-mdadm --create --run $member0 --auto=md --level=1 --size=$vol0_comp_size --chunk=64 --raid-disks=$((vol0_num_comps + 1)) $dev0 missing
+mdadm --create --run $member0 --auto=md --level=1 --size=$vol0_comp_size --raid-disks=$((vol0_num_comps + 1)) $dev0 missing
 check wait
 
 # Test the member0
diff --git a/tests/18imsm-r1_2d-takeover-r0_1d b/tests/18imsm-r1_2d-takeover-r0_1d
index fd5852ed..049f19c9 100644
--- a/tests/18imsm-r1_2d-takeover-r0_1d
+++ b/tests/18imsm-r1_2d-takeover-r0_1d
@@ -9,7 +9,6 @@ device_list="$dev0 $dev1"
 # Before: RAID 1 volume, 2 disks
 vol0_level=1
 vol0_comp_size=$((5 * 1024))
-vol0_chunk=64
 vol0_num_comps=$(( $num_disks - 1 ))
 vol0_offset=0
 
diff --git a/tests/imsm-grow-template b/tests/imsm-grow-template
index 428e448e..1a8676e0 100644
--- a/tests/imsm-grow-template
+++ b/tests/imsm-grow-template
@@ -42,13 +42,21 @@ check wait
 imsm_check container $num_disks
 
 # Create first volume inside the container
-mdadm --create --run $member0 --auto=md --level=$vol0_level --size=$vol0_comp_size --chunk=$vol0_chunk --raid-disks=$num_disks $device_list
+if [[ ! -z $vol0_chunk ]]; then
+	mdadm --create --run $member0 --auto=md --level=$vol0_level --size=$vol0_comp_size --chunk=$vol0_chunk --raid-disks=$num_disks $device_list
+else
+	mdadm --create --run $member0 --auto=md --level=$vol0_level --size=$vol0_comp_size --raid-disks=$num_disks $device_list
+fi
 check wait
 
 # Create second volume inside the container (if defined)
-if [ ! -z $vol1_chunk ]; then
-    mdadm --create --run $member1 --auto=md --level=$vol1_level --size=$vol1_comp_size --chunk=$vol1_chunk --raid-disks=$num_disks $device_list
-    check wait
+if [ ! -z $vol1_level ]; then
+	if [ ! -z $vol1_chunk ]; then
+		mdadm --create --run $member1 --auto=md --level=$vol1_level --size=$vol1_comp_size --chunk=$vol1_chunk --raid-disks=$num_disks $device_list
+	else
+		mdadm --create --run $member1 --auto=md --level=$vol1_level --size=$vol1_comp_size --raid-disks=$num_disks $device_list
+	fi
+	check wait
 fi
 
 # Wait for any RESYNC to complete
@@ -59,7 +67,7 @@ imsm_check member $member0 $num_disks $vol0_level $vol0_comp_size $((vol0_comp_s
 testdev $member0 $vol0_num_comps $vol0_comp_size $vol0_chunk
 
 # Test second volume (if defined)
-if [ ! -z $vol1_chunk ]; then
+if [ ! -z $vol1_level ]; then
     imsm_check member $member1 $num_disks $vol1_level $vol1_comp_size $((vol1_comp_size * vol1_num_comps)) $vol1_offset $vol1_chunk
     testdev $member1 $vol1_num_comps $vol1_comp_size $vol1_chunk
 fi
-- 
2.26.2

