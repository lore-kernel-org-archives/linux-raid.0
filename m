Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877AEC433F5
	for <linux-raid@archiver.kernel.org>; Mon,  4 Apr 2022 12:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346654AbiDDMlL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345285AbiDDMlL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 08:41:11 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F07E089
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 05:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649075955; x=1680611955;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FPBq2LbSplbHiIBLJWxZ2upn9te1HoaZB2wZw3iqfeI=;
  b=OWbVGsMqERSmBbxLnCM4shI8iO+slc2DiHP1fNZTDY/axfnZLg8P8DAK
   F4DJcSzG18sfwbyhLOLzke36srRg5Y+ce+fxmNMdnisNI6uWcXnqdNR4A
   /iRpnVChsKaC1tFxn7iWB17dBb4GTlVknVoTJaMgwDL07h87HA10iwL9j
   KDLAn9ZMmAnSYNloPnFtFuxUo8mIuh2kyMzu/F6SzIAXH9GFeTGCM9FcB
   8GVyiUAZgXSKJ1abQjU7hZKV2cXRPaaszmU+0OH/+0KeaVPUAoMRE8pwC
   6Mnn114SonB8V7WoIDiLskDSaGxhMeXp9Jun8ldWZ3LIVomy5eT82w24X
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="321199234"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="321199234"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 05:39:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="569365364"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga008.jf.intel.com with ESMTP; 04 Apr 2022 05:39:13 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 0/2] Mdmonitor improvements
Date:   Mon,  4 Apr 2022 14:43:14 +0200
Message-Id: <20220404124316.12880-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Series of patches contains fix segfault for running
monitor for devices different than md devices. Also
logging was improved to have informations about monitor
in verbose mode.

Kinga Tanska (2):
  Mdmonitor: Fix segfault
  Mdmonitor: Improve logging method

 Monitor.c | 36 ++++++++++++++++++++++++------------
 mdadm.h   |  1 +
 mdopen.c  | 17 +++++++++++++++++
 util.c    |  2 +-
 4 files changed, 43 insertions(+), 13 deletions(-)

-- 
2.26.2

