Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF92C74A5B
	for <linux-raid@archiver.kernel.org>; Thu, 23 Mar 2023 16:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbjCWQuo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Mar 2023 12:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbjCWQun (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Mar 2023 12:50:43 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3895E10E0
        for <linux-raid@vger.kernel.org>; Thu, 23 Mar 2023 09:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679590242; x=1711126242;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3KVdOgBQuXv6aSqi3fJsx5tGNGTMHq3JcRZn4fcExY0=;
  b=CB4iqoQC/8lhYHQeDJtUf5YFSGJbjAsggXarr3VCfUjaN9swfjSrDNMm
   RFZpOOHuefLfl23B9GAqjPDafZA19lRNWGpEjXRh3Te417yBfzqP3KJjy
   j3LG3VZkRGvr/mXIDme8NDuwuJnQHXF8xByhHUt1llE5y4jl6hRi3mN4G
   SxqAyck/3DzONIFthuykcGrhO605Y16De4RDUC96BDNyt03ytkyFGT7Sc
   onu9vpLXzizImf2qNF6TUsN9Kx/Jd40hR0TB5ZdlA0ugUN7q6Pr3PUErQ
   cWhAmIL5PedJFB7DX77E/6F3FuGzhQpBn5bEE7e6o1XYI0i74aM8HnS5c
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="339588405"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="339588405"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 09:50:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="682374170"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="682374170"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 09:50:40 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de, xni@redhat.com
Subject: [PATCH 0/4] Few config related refactors
Date:   Thu, 23 Mar 2023 17:50:13 +0100
Message-Id: <20230323165017.27121-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,
These patches remove multiple inlines across code and replace them
by defines or functions. No functional changes intended. The goal
is to make this some code reusable for both config and cmdline
(mdadm.c). I next patchset I will start optimizing names verification
(extended v2 of previous patchset).

Mariusz Tkaczyk (4):
  mdadm: define DEV_MD_DIR
  mdadm: define DEV_NUM_PREF
  mdadm: define is_devname_ignore()
  mdadm: numbered names verification

 Create.c      |  7 +++----
 Detail.c      |  9 ++++-----
 Incremental.c | 10 ++++------
 Monitor.c     | 34 +++++++++++++++++++---------------
 config.c      | 43 +++++++++++++++++++++----------------------
 lib.c         |  4 ++--
 mapfile.c     | 12 ++++++------
 mdadm.c       |  5 ++---
 mdadm.h       | 21 ++++++++++++++++++++-
 mdopen.c      | 16 ++++++++--------
 super-ddf.c   |  2 +-
 super-intel.c |  2 +-
 super1.c      |  3 +--
 sysfs.c       |  2 +-
 util.c        | 44 ++++++++++++++++++++++++++++++++++++++++++++
 15 files changed, 137 insertions(+), 77 deletions(-)

-- 
2.26.2

