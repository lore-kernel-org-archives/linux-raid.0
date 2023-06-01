Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7EBC77B7A
	for <linux-raid@archiver.kernel.org>; Thu,  1 Jun 2023 07:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbjFAH33 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Jun 2023 03:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjFAH31 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Jun 2023 03:29:27 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0E5134
        for <linux-raid@vger.kernel.org>; Thu,  1 Jun 2023 00:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685604566; x=1717140566;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+rRojxLr672iDV5NGgB5f3AG0XHCwEoD4sH65tsH3k8=;
  b=i+Ic+Zls4bCvA6D3Ejp8KEg+aj/mp6Zqym4/fDUumMxgMUT3c1veY7dk
   JmlfCjNZ2/ZkbOFSeV+pDvmsNZur7eAuTJoQ8Xyey1ua8f5C73rHRV3qP
   FTLUlOPL90Yro7c7ixWvEQbX90iHoXcrSoP0JvvZdCtMhWdBNvCzsNYCs
   xE5nhbNPri0vjWXgYda5kZeqvT7T6TlQvnWOCOLu7gKIbK4Caw08sSkq7
   UmoBl6kS3eIeL9HIAEeCMFLU6Isl3gKlIyz7PveOX3pqgyfoyB/6ZQW4R
   gqAuoF5Lq5XFcOVFwNrujJlhnLyLb/ej/ZNf0c2tzxevRCjEBYyUkr3W0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="345007099"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="345007099"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 00:28:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="707221103"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="707221103"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 00:28:33 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH v2 0/6] mdadm: POSIX portable naming rules
Date:   Thu,  1 Jun 2023 09:27:44 +0200
Message-Id: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,
To avoid problem with udev and VROC UEFI driver I developed stronger
naming policy, basing on POSIX portable names standard. Verification is
added for names and config entries. In case of an issue, user can update
name to make it compatible (for IMSM and native).

The changes here may cause /dev/md/ link will be different than before
mdadm update. To make any of that happen user need to use unusual naming
convention, like:
- special, non standard signs like, $,%,&,* or space.
- '-' used as first sign.
- locals.

Note: I didn't analyze configurations with "names=1". If name cannot be
determined mdadm should fallback to default numbered dev creation.

If you are planning release soon then feel free to merge it after the
release. It is a potential regression point.

It is a new version of [1] but it is strongly rebuild. Here is a list
of changes:
1. negative and positive test scenarios for both create and config
   entries are added.
2. Save parsed parameters in dedicated structs. It is a way to control
   what is parsed, assuming that we should use dedicated set_* function.
3. Verification for config entries is added.
5. Improved error logging for names:
   - during creation, these messages are errors, printed to stderr.
   - for config entries, messages are just a warnings printed to stdout.
6. Error messages reworked.
7. Updates in manual.

[1] https://lore.kernel.org/linux-raid/20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com/

Mariusz Tkaczyk (6):
  tests: create names_template
  tests: create 00confnames
  mdadm: set ident.devname if applicable
  mdadm: refactor ident->name handling
  mdadm: define ident_set_devname()
  mdadm: Follow POSIX Portable Character Set

 Build.c                        |  21 ++--
 Create.c                       |  35 +++----
 Detail.c                       |  17 ++-
 config.c                       | 184 +++++++++++++++++++++++++++------
 lib.c                          |  76 +++++++++++---
 mdadm.8.in                     |  70 ++++++-------
 mdadm.c                        |  73 +++++--------
 mdadm.conf.5.in                |   4 -
 mdadm.h                        |  36 ++++---
 super-intel.c                  |  47 +++++----
 tests/00confnames              | 107 +++++++++++++++++++
 tests/00createnames            |  89 ++++------------
 tests/templates/names_template |  80 ++++++++++++++
 13 files changed, 551 insertions(+), 288 deletions(-)
 create mode 100644 tests/00confnames
 create mode 100644 tests/templates/names_template

-- 
2.26.2

