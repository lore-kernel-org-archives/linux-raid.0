Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08539C04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbiG1MVY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238299AbiG1MVP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:21:15 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEF76BC26
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:21:14 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id BEE6A3736A;
        Thu, 28 Jul 2022 12:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010872; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=2q6VW6H2NPHynJ71ZOsnzoJ6j+oc96IoBNd2jj9by0M=;
        b=1DcZua1USW4R5CFtgJC+5YfaSkyoZx2fUMllygzA5iTza7vHPNNlwfMxbi2O5QCDCbupNV
        0Acn2TKoCNnlRnt4DhBsTF5F3MrXPh1uZLMBBRy/0xaOF9tmW0UT8hV555CiSarhKwLgKj
        ACO7OjVotMGY6SBePIJ0fdgqEQf+V0E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010872;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=2q6VW6H2NPHynJ71ZOsnzoJ6j+oc96IoBNd2jj9by0M=;
        b=7/oVGsdN6tZwE9Hd60i7i8VJvBURReOCaBcL4mdz6W4keFc2wo4LRiy7ylWhx1h63Zi1ui
        oYhno1Jta3LEzuBQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id E9B632C141;
        Thu, 28 Jul 2022 12:21:10 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 00/23] mdadm-CI for-jes/20220728: patches for merge
Date:   Thu, 28 Jul 2022 20:20:38 +0800
Message-Id: <20220728122101.28744-1-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,

The following patches are reviewed by Mariusz and me, and the non-test
patches  pass roughly testing by array (with/without imsm) array
creation/stop.

All the patches are pushed to for-jes/20220728 branch of my mdadm-CI
tree, for patchwork to trace them more conveniently I post them all in
this email threads.

Please consider to take them to mdadm upstream.

Thanks.

Coly Li
---
Hannes Reinecke (1):
  mdadm: enable Intel Alderlake RSTe configuration

Kinga Tanska (2):
  Assemble: check if device is container before scheduling force-clean
    update
  mdadm: replace container level checking with inline

Logan Gunthorpe (11):
  Makefile: Don't build static build with everything and everything-test
  DDF: Cleanup validate_geometry_ddf_container()
  DDF: Fix NULL pointer dereference in validate_geometry_ddf()
  mdadm/Grow: Fix use after close bug by closing after fork
  monitor: Avoid segfault when calling NULL get_bad_blocks
  mdadm: Fix mdadm -r remove option regression
  mdadm: Fix optional --write-behind parameter
  mdadm/test: Add a mode to repeat specified tests
  mdadm/test: Mark and ignore broken test failures
  tests: Add broken files for all broken tests
  tests/00readonly: Run udevadm settle before setting ro

Mariusz Tkaczyk (3):
  tests: add test for names
  mdadm: remove symlink option
  mdadm: move data_offset to struct shape

Mateusz Kusiak (1):
  Grow: Split Grow_reshape into helper function

NeilBrown (1):
  super1: report truncated device

Sudhakar Panneerselvam (4):
  tests/00raid0: add a test that validates raid0 with layout fails for
    0.9
  tests: fix raid0 tests for 0.90 metadata
  tests/04update-metadata: avoid passing chunk size to raid1
  tests/02lineargrow: clear the superblock at every iteration

 Assemble.c                                 |  10 +-
 Create.c                                   |  22 ++--
 Grow.c                                     | 142 +++++++++++----------
 Incremental.c                              |   4 +-
 Makefile                                   |   4 +-
 ReadMe.c                                   |   2 +-
 config.c                                   |   7 +-
 mdadm.8.in                                 |   9 --
 mdadm.c                                    |  46 ++-----
 mdadm.conf.5.in                            |  15 ---
 mdadm.h                                    |  24 +++-
 monitor.c                                  |   3 +
 platform-intel.c                           |   8 +-
 super-ddf.c                                |  98 +++++++-------
 super-intel.c                              |   4 +-
 super0.c                                   |   2 +-
 super1.c                                   |  36 ++++--
 sysfs.c                                    |   2 +-
 test                                       |  71 +++++++++--
 tests/00createnames                        |  93 ++++++++++++++
 tests/00raid0                              |  10 +-
 tests/00readonly                           |   5 +
 tests/01r5integ.broken                     |   7 +
 tests/01raid6integ.broken                  |   7 +
 tests/02lineargrow                         |   2 +
 tests/03r0assem                            |   6 +-
 tests/04r0update                           |   4 +-
 tests/04r5swap.broken                      |   7 +
 tests/04update-metadata                    |   8 +-
 tests/07autoassemble.broken                |   8 ++
 tests/07autodetect.broken                  |   5 +
 tests/07changelevelintr.broken             |   9 ++
 tests/07changelevels.broken                |   9 ++
 tests/07reshape5intr.broken                |  45 +++++++
 tests/07revert-grow.broken                 |  31 +++++
 tests/07revert-shrink.broken               |   9 ++
 tests/07testreshape5.broken                |  12 ++
 tests/09imsm-assemble.broken               |   6 +
 tests/09imsm-create-fail-rebuild.broken    |   5 +
 tests/09imsm-overlap.broken                |   7 +
 tests/10ddf-assemble-missing.broken        |   6 +
 tests/10ddf-fail-create-race.broken        |   7 +
 tests/10ddf-fail-two-spares.broken         |   5 +
 tests/10ddf-incremental-wrong-order.broken |   9 ++
 tests/14imsm-r1_2d-grow-r1_3d.broken       |   5 +
 tests/14imsm-r1_2d-takeover-r0_2d.broken   |   6 +
 tests/18imsm-r10_4d-takeover-r0_2d.broken  |   5 +
 tests/18imsm-r1_2d-takeover-r0_1d.broken   |   6 +
 tests/19raid6auto-repair.broken            |   5 +
 tests/19raid6repair.broken                 |   5 +
 util.c                                     |  14 ++
 51 files changed, 626 insertions(+), 251 deletions(-)
 create mode 100644 tests/00createnames
 create mode 100644 tests/01r5integ.broken
 create mode 100644 tests/01raid6integ.broken
 create mode 100644 tests/04r5swap.broken
 create mode 100644 tests/07autoassemble.broken
 create mode 100644 tests/07autodetect.broken
 create mode 100644 tests/07changelevelintr.broken
 create mode 100644 tests/07changelevels.broken
 create mode 100644 tests/07reshape5intr.broken
 create mode 100644 tests/07revert-grow.broken
 create mode 100644 tests/07revert-shrink.broken
 create mode 100644 tests/07testreshape5.broken
 create mode 100644 tests/09imsm-assemble.broken
 create mode 100644 tests/09imsm-create-fail-rebuild.broken
 create mode 100644 tests/09imsm-overlap.broken
 create mode 100644 tests/10ddf-assemble-missing.broken
 create mode 100644 tests/10ddf-fail-create-race.broken
 create mode 100644 tests/10ddf-fail-two-spares.broken
 create mode 100644 tests/10ddf-incremental-wrong-order.broken
 create mode 100644 tests/14imsm-r1_2d-grow-r1_3d.broken
 create mode 100644 tests/14imsm-r1_2d-takeover-r0_2d.broken
 create mode 100644 tests/18imsm-r10_4d-takeover-r0_2d.broken
 create mode 100644 tests/18imsm-r1_2d-takeover-r0_1d.broken
 create mode 100644 tests/19raid6auto-repair.broken
 create mode 100644 tests/19raid6repair.broken

-- 
2.35.3

