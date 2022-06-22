Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F30CCA479
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 20:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbiFVUZf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 16:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiFVUZa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 16:25:30 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A1E369DB
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 13:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:Message-Id:Date:Cc:To:From
        :references:content-disposition:in-reply-to;
        bh=65KDpvRdzv6sYx7s7eRRNbs2/SuAhZOC+aNwG8MtcPM=; b=Ml6n1w1atzfTQ5pBr0VjjtQJH+
        t+lEPZPrHVNn6bhgR/Z2NTo3bjZSI4i4YVQTD90JhxmTyRdGwBhxyFzXdx2x75yiWVn8mFIUOHTKv
        5gBzrRkXYb1VbeRdk2wnh4fCMixPI7jUueGlaDp7TWpUIq29/2gH6yyFIVjT7RX0ePfu4adrfqr8U
        xmSAwr3jZm4MZsV2Hq1WFQRqmC0MIZ9H1CkXZap0CrY/FhCm8PQdFeJ3mqVYcu1JsNMWvOVkk0Bfo
        n8EneLwMtVo5UwrUZsF7Xk4Z2g6Nt3xwgWEJhFPM26Nsv9e8nb+tmMozpHugJ2nSRf0mpSOu+SnC4
        XG0Dk1rA==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46uk-00EGyX-Qr; Wed, 22 Jun 2022 14:25:28 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46ug-0009M8-Oq; Wed, 22 Jun 2022 14:25:22 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>
Cc:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Wed, 22 Jun 2022 14:25:05 -0600
Message-Id: <20220622202519.35905-1-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v2 00/14] Bug fixes and testing improvments
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

This series tries to clean up the testing infrastructure to be a bit
more reliable. It doesn't fix all the broken tests but annotates those
that I see as broken so testing can continue. V2 includes changes
requested in the feedback so far.

As such, I've fixed all the kernel panics (in md-next now) and segfaults
that caused testing to halt regardless of whether --keep-going was
passed. I've also included some patches posted to the list from Sudhakar
and Himanshu which fix some more broken tests.

I've also included a patch which adds the --loop option to ./test which
runs tests for a specified number of iterations (or indefinitely if zero
is specified). This was very useful for ferreting out tests that failed
randomly.

The last two patches adds some infrastructure and annotation for known
broken tests so that they don't stop the processing (even if
--keep-going is not passed). Tests that are known to be broken  can
optionally be skipped with the --skip-broken or --skip-always-broken
flags.

With these changes it's possible to run './test --loop=0' for several
days without stopping.

There are still a number of broken tests which need more work, and there
may be other issues on other people's systems (kernel configurations,
etc) but that will have to be left to other developers.

The tests that are still broken for me in one way or another are:
  01r5integ, 01raid6integ, 04r5swap.broken, 04update-metadata,
  07autoassemble, 07autodetect, 07changelevelintr, 07changelevels,
  07reshape5intr, 07revert-grow, 07revert-shrink, 07testreshape5,
  09imsm-assemble, 09imsm-create-fail-rebuild, 09imsm-overlap,
  10ddf-assemble-missing, 10ddf-fail-create-race,
  10ddf-fail-two-spares, 10ddf-incremental-wrong-order,
  14imsm-r1_2d-grow-r1_3d, 14imsm-r1_2d-takeover-r0_2d,
  18imsm-r10_4d-takeover-r0_2d, 18imsm-r1_2d-takeover-r0_1d,
  19raid6auto-repair, 19raid6repair.broken

Details on how they are broken can be found in the last patch.

This series is based on the current kernel.org master (190dc029) and
a git repo can be found here:

  https://github.com/lsgunth/mdadm bugfixes_v2


Thanks,

Logan

--

Changes since v1:
  * Rebase onto latest master (190dc029b141c423e), which means
    reworking patch 6 seeing the original patch was already
    reverted
  * Drop mdadm.static from the make target everything-test as well
    as everything (as pointed out by Mariusz)
  * Switch to using close_fd() helper in patch 4 (per Mariusz)
  * Fixed a couple minor typos and whitespace issues from Guoqing
    and Paul
  * Collected Acks from Mariusz

--

Logan Gunthorpe (10):
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

Sudhakar Panneerselvam (4):
  tests/00raid0: add a test that validates raid0 with layout fails for
    0.9
  tests: fix raid0 tests for 0.90 metadata
  tests/04update-metadata: avoid passing chunk size to raid1
  tests/02lineargrow: clear the superblock at every iteration

 Grow.c                                     |  4 +-
 Makefile                                   |  4 +-
 ReadMe.c                                   |  1 +
 mdadm.c                                    |  6 +-
 mdadm.h                                    |  1 +
 monitor.c                                  |  3 +
 super-ddf.c                                | 94 ++++++++++------------
 test                                       | 71 +++++++++++++---
 tests/00raid0                              | 10 +--
 tests/00readonly                           |  4 +
 tests/01r5integ.broken                     |  7 ++
 tests/01raid6integ.broken                  |  7 ++
 tests/02lineargrow                         |  2 +
 tests/03r0assem                            |  6 +-
 tests/04r0update                           |  4 +-
 tests/04r5swap.broken                      |  7 ++
 tests/04update-metadata                    |  8 +-
 tests/07autoassemble.broken                |  8 ++
 tests/07autodetect.broken                  |  5 ++
 tests/07changelevelintr.broken             |  9 +++
 tests/07changelevels.broken                |  9 +++
 tests/07reshape5intr.broken                | 45 +++++++++++
 tests/07revert-grow.broken                 | 31 +++++++
 tests/07revert-shrink.broken               |  9 +++
 tests/07testreshape5.broken                | 12 +++
 tests/09imsm-assemble.broken               |  6 ++
 tests/09imsm-create-fail-rebuild.broken    |  5 ++
 tests/09imsm-overlap.broken                |  7 ++
 tests/10ddf-assemble-missing.broken        |  6 ++
 tests/10ddf-fail-create-race.broken        |  7 ++
 tests/10ddf-fail-two-spares.broken         |  5 ++
 tests/10ddf-incremental-wrong-order.broken |  9 +++
 tests/14imsm-r1_2d-grow-r1_3d.broken       |  5 ++
 tests/14imsm-r1_2d-takeover-r0_2d.broken   |  6 ++
 tests/18imsm-r10_4d-takeover-r0_2d.broken  |  5 ++
 tests/18imsm-r1_2d-takeover-r0_1d.broken   |  6 ++
 tests/19raid6auto-repair.broken            |  5 ++
 tests/19raid6repair.broken                 |  5 ++
 38 files changed, 361 insertions(+), 83 deletions(-)
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


base-commit: 190dc029b141c423e724566cbed5d5afbb10b05a
--
2.30.2
